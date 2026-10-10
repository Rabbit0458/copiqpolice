"use client"

import Link from "next/link"
import { useCallback, useEffect, useMemo, useRef, useState, type CSSProperties } from "react"
import { createPortal } from "react-dom"
import { ArrowRight, Check, CloudCheck, CloudOff, Loader2, RotateCcw, Sparkles, Timer, TrendingUp, X } from "lucide-react"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import type { PathwayDefinition } from "@/config/pathways"
import { Counter } from "@/components/home/counter"
import { loadQuestions, SessionRecorder, type SessionPlan, type SessionQuestion, type SyncState } from "@/features/home/session"

/**
 * Lecteur de session plein écran (mode concentration).
 * Une question à la fois, correction instantanée et explication, puis un
 * score animé. Chaque réponse est enregistrée comme dans l'application.
 *
 * Clavier : 1-4 ou A-D pour répondre, Entrée pour continuer, Échap pour quitter.
 */

type Answer = { value: string; correct: boolean; ms: number }

const LETTERS = ["A", "B", "C", "D", "E", "F"]

export function SessionPlayer({
  plan,
  pathway,
  onClose,
  onFinished,
  onReplay,
}: {
  plan: SessionPlan
  pathway: PathwayDefinition
  onClose: () => void
  onFinished: () => void
  onReplay: () => void
}) {
  const supabase = useMemo(() => createClient(), [])
  const [status, setStatus] = useState<"loading" | "error" | "play" | "done">("loading")
  const [questions, setQuestions] = useState<SessionQuestion[]>([])
  const [index, setIndex] = useState(0)
  const [answers, setAnswers] = useState<Answer[]>([])
  const [sync, setSync] = useState<SyncState>("idle")
  const [confirmQuit, setConfirmQuit] = useState(false)
  const [errorText, setErrorText] = useState("")
  const [attempt, setAttempt] = useState(0)
  const [durationMs, setDurationMs] = useState(0)
  const recorder = useRef<SessionRecorder | null>(null)
  const startedAt = useRef(0)
  const questionAt = useRef(0)
  const titleRef = useRef<HTMLHeadingElement | null>(null)
  const nextRef = useRef<HTMLButtonElement | null>(null)

  const q = questions[index]
  const picked = answers[index]?.value ?? null

  /* Chargement des questions + session de l'utilisateur. */
  useEffect(() => {
    let alive = true
    ;(async () => {
      try {
        const [{ data: auth }, list] = await Promise.all([supabase.auth.getUser(), loadQuestions(supabase, plan)])
        if (!alive) return
        if (!auth.user) throw new Error("Ta session a expiré. Reconnecte-toi pour continuer.")
        recorder.current = new SessionRecorder(supabase, {
          userId: auth.user.id,
          email: auth.user.email ?? null,
          pathway,
          plan,
          total: list.length,
        })
        startedAt.current = performance.now()
        questionAt.current = performance.now()
        setQuestions(list)
        setStatus("play")
      } catch (e) {
        if (!alive) return
        setErrorText(e instanceof Error && e.message ? e.message : "Impossible de charger les questions.")
        setStatus("error")
      }
    })()
    return () => {
      alive = false
    }
  }, [supabase, plan, pathway, attempt])

  /* Verrouille le défilement de la page derrière le lecteur. */
  useEffect(() => {
    const prev = document.body.style.overflow
    document.body.style.overflow = "hidden"
    return () => {
      document.body.style.overflow = prev
    }
  }, [])

  /* Nouvelle question : chrono et focus. */
  useEffect(() => {
    if (status !== "play") return
    questionAt.current = performance.now()
    titleRef.current?.focus({ preventScroll: true })
  }, [index, status])

  useEffect(() => {
    if (picked !== null) nextRef.current?.focus({ preventScroll: true })
  }, [picked])

  const pick = useCallback(
    (value: string) => {
      if (status !== "play" || !q || answers[index]) return
      const ms = performance.now() - questionAt.current
      const correct = value === q.answer
      setAnswers((prev) => {
        const next = [...prev]
        next[index] = { value, correct, ms }
        return next
      })
      setSync("saving")
      recorder.current
        ?.answer(q, value, ms, index + 1)
        .then(() => setSync((s) => (s === "error" ? s : "saved")))
        .catch(() => setSync("error"))
    },
    [status, q, answers, index],
  )

  const finish = useCallback(
    async (list: Answer[]) => {
      const done = list.filter(Boolean)
      try {
        await recorder.current?.finish(done.length, done.filter((a) => a.correct).length)
        if (recorder.current && !recorder.current.failed && done.length) setSync("saved")
      } catch {
        setSync("error")
      }
      onFinished()
    },
    [onFinished],
  )

  const next = useCallback(() => {
    if (picked === null) return
    if (index + 1 < questions.length) {
      setIndex((i) => i + 1)
    } else {
      setDurationMs(performance.now() - startedAt.current)
      setStatus("done")
      void finish(answers)
    }
  }, [picked, index, questions.length, answers, finish])

  const requestClose = useCallback(() => {
    if (status === "play" && answers.filter(Boolean).length > 0) {
      setConfirmQuit(true)
      return
    }
    onClose()
  }, [status, answers, onClose])

  const quitNow = useCallback(async () => {
    setConfirmQuit(false)
    await finish(answers)
    onClose()
  }, [answers, finish, onClose])

  /* Raccourcis clavier. */
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      if (e.metaKey || e.ctrlKey || e.altKey) return
      if (e.key === "Escape") {
        e.preventDefault()
        if (confirmQuit) setConfirmQuit(false)
        else requestClose()
        return
      }
      if (status !== "play" || !q || confirmQuit) return
      const k = e.key.toUpperCase()
      const n = /^[1-6]$/.test(k) ? Number(k) - 1 : LETTERS.indexOf(k)
      if (picked === null && n >= 0 && n < q.options.length) {
        e.preventDefault()
        pick(q.options[n])
      } else if (picked !== null && (e.key === "Enter" || e.key === " ") && document.activeElement?.tagName !== "A") {
        e.preventDefault()
        next()
      }
    }
    window.addEventListener("keydown", onKey)
    return () => window.removeEventListener("keydown", onKey)
  }, [status, q, picked, pick, next, requestClose, confirmQuit])

  const accent = pathway.color

  // Rendu dans <body> : la zone de page animée (transform) ne doit pas
  // devenir le repère du plein écran.
  return createPortal(
    <div
      role="dialog"
      aria-modal="true"
      aria-label={`Session : ${plan.theme.label}`}
      className="cq-player fixed inset-0 z-[120] flex flex-col bg-[var(--surface-container)]"
      style={{ "--accent": accent } as CSSProperties}
    >
      {/* Barre supérieure */}
      <header className="relative z-10 shrink-0 border-b border-[var(--outline)] bg-[var(--surface)]/90 backdrop-blur-xl">
        <div className="mx-auto flex h-16 max-w-4xl items-center gap-3 px-4 sm:px-6">
          <button
            type="button"
            onClick={requestClose}
            aria-label="Quitter la session"
            className="grid h-10 w-10 shrink-0 place-items-center rounded-xl text-[var(--on-surface-muted)] transition-colors hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)]"
          >
            <X className="h-5 w-5" aria-hidden="true" />
          </button>
          <div className="min-w-0 flex-1">
            <p className="truncate text-[14.5px] font-semibold text-[var(--on-surface)]">
              {plan.express ? "Test express" : plan.theme.label}
            </p>
            <p className="truncate text-[12.5px] text-[var(--on-surface-faint)]">
              {status === "play" || status === "done" ? `${Math.min(index + 1, questions.length)} / ${questions.length} questions` : pathway.shortLabel}
            </p>
          </div>
          <SyncBadge state={sync} />
        </div>
        {/* Progression segmentée */}
        <div className="mx-auto flex max-w-4xl gap-1 px-4 pb-3 sm:px-6" aria-hidden="true">
          {(questions.length ? questions : Array.from({ length: plan.count })).map((_, i) => {
            const a = answers[i]
            return (
              <span key={i} className="relative h-1.5 flex-1 overflow-hidden rounded-full bg-[var(--surface-container-hi)]">
                <span
                  className={cn(
                    "cq-seg absolute inset-0 origin-left rounded-full",
                    a ? (a.correct ? "bg-[#16A34A]" : "bg-[#DC2626]") : i === index && status === "play" ? "cq-seg-current bg-[var(--accent)]" : "",
                    (a || (i === index && status === "play")) && "is-on",
                  )}
                />
              </span>
            )
          })}
        </div>
      </header>

      {/* Contenu */}
      <div className="relative flex-1 overflow-y-auto overscroll-contain">
        <span className="cq-player-glow pointer-events-none absolute inset-x-0 top-0 h-72" aria-hidden="true" />
        <div className="relative mx-auto flex min-h-full w-full max-w-2xl flex-col px-4 pt-7 sm:px-6 sm:pt-10">
          {status === "loading" && <PlayerSkeleton />}

          {status === "error" && (
            <div className="cq-pop-in mx-auto max-w-md rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-7 text-center">
              <span className="mx-auto grid h-12 w-12 place-items-center rounded-2xl bg-[#DC2626]/10 text-[#DC2626]">
                <CloudOff className="h-6 w-6" aria-hidden="true" />
              </span>
              <h2 className="mt-4 text-[18px] font-semibold text-[var(--on-surface)]">La session n’a pas pu démarrer</h2>
              <p className="mt-2 text-[14.5px] leading-relaxed text-[var(--on-surface-muted)]">{errorText}</p>
              <div className="mt-6 flex justify-center gap-2">
                <button
                  type="button"
                  onClick={() => {
                    setStatus("loading")
                    setAttempt((n) => n + 1)
                  }}
                  className="cq-btn inline-flex h-11 items-center gap-2 rounded-xl bg-[#000B36] px-5 text-[14.5px] font-semibold text-white dark:bg-[#1147D9]"
                >
                  <RotateCcw className="h-4 w-4" aria-hidden="true" /> Réessayer
                </button>
                <button type="button" onClick={onClose} className="h-11 rounded-xl px-4 text-[14.5px] font-semibold text-[var(--on-surface-muted)] hover:bg-[var(--surface-container-hi)]">
                  Fermer
                </button>
              </div>
            </div>
          )}

          {status === "play" && q && (
            <div key={q.id} className="cq-q-enter">
              <div className="flex flex-wrap items-center gap-2">
                {q.sourceLabel !== plan.theme.label && (
                  <span className="inline-flex max-w-full items-center gap-1.5 truncate rounded-full px-3 py-1 text-[12.5px] font-semibold" style={{ background: `${accent}14`, color: accent }}>
                    <span className="h-1.5 w-1.5 shrink-0 rounded-full" style={{ background: accent }} aria-hidden="true" />
                    {q.sourceLabel}
                  </span>
                )}
                {q.difficulty && (
                  <span className="rounded-full bg-[var(--surface)] px-3 py-1 text-[12.5px] font-medium text-[var(--on-surface-muted)] ring-1 ring-[var(--outline)]">{q.difficulty}</span>
                )}
              </div>
              <h2
                ref={titleRef}
                tabIndex={-1}
                className="mt-4 text-[clamp(1.2rem,2vw,1.5rem)] font-semibold leading-[1.3] tracking-[-0.015em] text-[var(--on-surface)] outline-none"
              >
                {q.question}
              </h2>

              <ul className="mt-6 grid gap-2.5" role="list">
                {q.options.map((opt, i) => {
                  const isPicked = picked === opt
                  const isAnswer = opt === q.answer
                  const state = picked === null ? "idle" : isAnswer ? (isPicked ? "right" : "reveal") : isPicked ? "wrong" : "dim"
                  return (
                    <li key={opt} className="cq-opt-in" style={{ "--i": i } as CSSProperties}>
                      <button
                        type="button"
                        disabled={picked !== null}
                        onClick={() => pick(opt)}
                        aria-pressed={isPicked}
                        className={cn("cq-opt group relative flex w-full items-center gap-3.5 overflow-hidden rounded-[16px] border-2 px-3.5 py-3 text-left sm:px-4", `is-${state}`)}
                      >
                        <span className="cq-opt-key grid h-8 w-8 shrink-0 place-items-center rounded-[10px] text-[13px] font-bold">
                          {state === "right" || state === "reveal" ? (
                            <Check className="cq-opt-icon h-4.5 w-4.5" strokeWidth={3} aria-hidden="true" />
                          ) : state === "wrong" ? (
                            <X className="cq-opt-icon h-4.5 w-4.5" strokeWidth={3} aria-hidden="true" />
                          ) : (
                            LETTERS[i]
                          )}
                        </span>
                        <span className="flex-1 text-[15px] leading-snug">{opt}</span>
                        {state === "right" && <Burst />}
                        <span className="sr-only">
                          {state === "right" ? " — bonne réponse" : state === "wrong" ? " — ta réponse, incorrecte" : state === "reveal" ? " — bonne réponse" : ""}
                        </span>
                      </button>
                    </li>
                  )
                })}
              </ul>

              {picked !== null && (
                <div className={cn("cq-feedback mt-5 rounded-[16px] border p-4", answers[index]?.correct ? "is-right" : "is-wrong")} role="status" aria-live="polite">
                  <p className="flex items-center gap-2 text-[14.5px] font-semibold">
                    {answers[index]?.correct ? (
                      <>
                        <Sparkles className="h-4.5 w-4.5" aria-hidden="true" /> Bonne réponse !
                      </>
                    ) : (
                      <>Pas tout à fait. La bonne réponse : « {q.answer} »</>
                    )}
                  </p>
                  {q.explanation && <p className="mt-1.5 text-[14px] leading-relaxed text-[var(--on-surface-muted)]">{q.explanation}</p>}
                </div>
              )}
            </div>
          )}

          {status === "play" && (
            <div className="sticky bottom-0 z-10 -mx-4 mt-auto px-4 pb-[max(1rem,env(safe-area-inset-bottom))] pt-8 sm:-mx-6 sm:px-6 sm:pb-6" style={{ background: "linear-gradient(to top, var(--surface-container) 62%, transparent)" }}>
              <div className="flex justify-end">
                <button
                  ref={nextRef}
                  type="button"
                  onClick={next}
                  disabled={picked === null}
                  title={picked === null ? "Touches 1 à 4 pour répondre" : "Entrée pour continuer"}
                  className={cn(
                    "cq-next inline-flex h-12 w-full items-center justify-center gap-2 rounded-[14px] px-6 text-[15px] font-semibold text-white sm:w-auto",
                    picked === null ? "cursor-not-allowed bg-[#94A3B8]/50 dark:bg-[#334155]" : "is-ready bg-[#000B36] shadow-[0_14px_30px_-16px_rgba(0,11,54,.9)] hover:bg-[#0A1A55] dark:bg-[#1147D9] dark:hover:bg-[#1A55E6]",
                  )}
                >
                  {index + 1 < questions.length ? "Question suivante" : "Voir mon résultat"}
                  <ArrowRight className="h-4 w-4" aria-hidden="true" />
                </button>
              </div>
            </div>
          )}

          {status === "done" && (
            <Result
              questions={questions}
              answers={answers}
              durationMs={durationMs}
              accent={accent}
              express={!!plan.express}
              onReplay={onReplay}
              onClose={onClose}
              sync={sync}
            />
          )}
        </div>
      </div>

      {/* Confirmation de sortie */}
      {confirmQuit && (
        <div className="absolute inset-0 z-20 grid place-items-center bg-[#000B36]/45 p-4 backdrop-blur-sm" onClick={() => setConfirmQuit(false)}>
          <div
            role="alertdialog"
            aria-modal="true"
            aria-labelledby="quit-title"
            onClick={(e) => e.stopPropagation()}
            className="cq-pop-in w-full max-w-sm rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6 shadow-[0_30px_80px_-30px_rgba(0,11,54,.7)]"
          >
            <h2 id="quit-title" className="text-[18px] font-semibold text-[var(--on-surface)]">
              Quitter la session ?
            </h2>
            <p className="mt-2 text-[14.5px] leading-relaxed text-[var(--on-surface-muted)]">
              Tes {answers.filter(Boolean).length} réponse{answers.filter(Boolean).length > 1 ? "s" : ""} sont conservées et comptent déjà dans ta progression.
            </p>
            <div className="mt-6 grid gap-2 sm:grid-cols-2">
              <button type="button" autoFocus onClick={() => setConfirmQuit(false)} className="h-11 rounded-xl bg-[#000B36] text-[14.5px] font-semibold text-white dark:bg-[#1147D9]">
                Continuer
              </button>
              <button type="button" onClick={() => void quitNow()} className="h-11 rounded-xl text-[14.5px] font-semibold text-[#DC2626] ring-1 ring-[var(--outline)] hover:bg-[#DC2626]/8 dark:text-[#F87171]">
                Quitter
              </button>
            </div>
          </div>
        </div>
      )}
    </div>,
    document.body,
  )
}

/* ─── Indicateur de synchronisation ───────────────────────────────────────── */

function SyncBadge({ state }: { state: SyncState }) {
  if (state === "idle") return null
  return (
    <span
      className={cn(
        "cq-pop-in inline-flex shrink-0 items-center gap-1.5 rounded-full px-2.5 py-1 text-[12px] font-semibold",
        state === "error" ? "bg-[#DC2626]/10 text-[#DC2626] dark:text-[#F87171]" : "bg-[#16A34A]/10 text-[#15803D] dark:text-[#4ADE80]",
      )}
      title={state === "error" ? "Certaines réponses n’ont pas pu être enregistrées." : "Tes réponses sont enregistrées sur ton compte, comme dans l’application."}
    >
      {state === "saving" ? (
        <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden="true" />
      ) : state === "error" ? (
        <CloudOff className="h-3.5 w-3.5" aria-hidden="true" />
      ) : (
        <CloudCheck className="h-3.5 w-3.5" aria-hidden="true" />
      )}
      <span className="hidden sm:inline">{state === "error" ? "Non synchronisé" : state === "saving" ? "Enregistrement…" : "Synchronisé avec l’app"}</span>
    </span>
  )
}

/* ─── Éclat de bonne réponse ──────────────────────────────────────────────── */

function Burst() {
  return (
    <span className="cq-burst pointer-events-none absolute left-[2.15rem] top-1/2" aria-hidden="true">
      {Array.from({ length: 10 }, (_, i) => (
        <span key={i} style={{ "--a": `${i * 36}deg`, "--c": i % 3 === 0 ? "#22C55E" : i % 3 === 1 ? "#4ADE80" : "#FBBF24" } as CSSProperties} />
      ))}
    </span>
  )
}

/* ─── Résultat ────────────────────────────────────────────────────────────── */

function Result({
  questions,
  answers,
  durationMs,
  accent,
  express,
  onReplay,
  onClose,
  sync,
}: {
  questions: SessionQuestion[]
  answers: Answer[]
  durationMs: number
  accent: string
  express: boolean
  onReplay: () => void
  onClose: () => void
  sync: SyncState
}) {
  const [drawn, setDrawn] = useState(false)
  const [showMistakes, setShowMistakes] = useState(false)
  const done = answers.filter(Boolean)
  const correct = done.filter((a) => a.correct).length
  const total = questions.length
  const percent = total ? Math.round((correct / total) * 100) : 0
  const avg = done.length ? Math.round(done.reduce((s, a) => s + a.ms, 0) / done.length / 100) / 10 : 0
  const minutes = Math.max(1, Math.round(durationMs / 60000))
  const mistakes = questions.map((q, i) => ({ q, a: answers[i] })).filter((m) => m.a && !m.a.correct)
  const R = 72
  const C = 2 * Math.PI * R

  const headRef = useRef<HTMLHeadingElement | null>(null)

  useEffect(() => {
    headRef.current?.focus({ preventScroll: true })
    const id = requestAnimationFrame(() => setDrawn(true))
    return () => cancelAnimationFrame(id)
  }, [])

  const verdict =
    percent >= 90 ? "Impressionnant !" : percent >= 70 ? "Très belle session !" : percent >= 50 ? "C’est un bon début." : "Chaque erreur te fait progresser."
  const sub =
    percent >= 70
      ? "Tu tiens le rythme du concours. Une autre pour confirmer ?"
      : percent >= 50
        ? "Encore quelques sessions et ce thème n’aura plus de secret."
        : "Relis les explications ci-dessous : c’est là que tout se joue."

  return (
    <div className="cq-result relative pb-16 text-center">
      {percent >= 70 && <Confetti />}
      <p className="cq-enter text-[12.5px] font-semibold uppercase tracking-[0.16em] text-[var(--on-surface-faint)]" style={{ "--d": "60ms" } as CSSProperties}>
        {express ? "Test express terminé" : "Session terminée"}
      </p>
      <div className="relative mx-auto mt-6 h-[188px] w-[188px]">
        <svg viewBox="0 0 188 188" className="h-full w-full -rotate-90" aria-hidden="true">
          <defs>
            <linearGradient id="cq-result-grad" x1="0" y1="0" x2="1" y2="1">
              <stop offset="0%" stopColor={percent >= 50 ? "#22C55E" : "#F59E0B"} />
              <stop offset="100%" stopColor={percent >= 50 ? accent : "#E0162B"} />
            </linearGradient>
          </defs>
          <circle cx="94" cy="94" r={R} fill="none" stroke="var(--outline)" strokeWidth="12" opacity=".6" />
          <circle
            cx="94"
            cy="94"
            r={R}
            fill="none"
            stroke="url(#cq-result-grad)"
            strokeWidth="12"
            strokeLinecap="round"
            strokeDasharray={C}
            strokeDashoffset={drawn ? C * (1 - percent / 100) : C}
            className="cq-ring-arc"
          />
        </svg>
        <div className="absolute inset-0 grid place-items-center">
          <div>
            <p className="text-[2.6rem] font-bold leading-none tracking-[-0.05em] text-[var(--on-surface)]">
              <Counter value={percent} suffix=" %" delay={200} />
            </p>
            <p className="mt-1.5 text-[14px] font-semibold tabular-nums text-[var(--on-surface-muted)]">
              {correct} / {total}
            </p>
            <p className="text-[11.5px] font-medium uppercase tracking-[0.1em] text-[var(--on-surface-faint)]">bonnes réponses</p>
          </div>
        </div>
      </div>
      <h2 ref={headRef} tabIndex={-1} className="cq-enter mt-6 outline-none text-[clamp(1.6rem,3vw,2.2rem)] font-bold tracking-[-0.035em] text-[var(--on-surface)]" style={{ "--d": "380ms" } as CSSProperties}>
        {verdict}
      </h2>
      <p className="cq-enter mx-auto mt-2 max-w-md text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]" style={{ "--d": "460ms" } as CSSProperties}>
        {sub}
      </p>

      <dl className="cq-enter mx-auto mt-7 grid max-w-md grid-cols-3 gap-2" style={{ "--d": "540ms" } as CSSProperties}>
        {[
          { label: "Réussite", value: `${percent} %`, icon: TrendingUp },
          { label: "Par question", value: `${avg.toLocaleString("fr-FR")} s`, icon: Timer },
          { label: "Durée", value: `${minutes} min`, icon: Sparkles },
        ].map(({ label, value, icon: Icon }) => (
          <div key={label} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-3.5">
            <Icon className="mx-auto h-4 w-4 text-[var(--on-surface-faint)]" aria-hidden="true" />
            <dd className="mt-1.5 text-[17px] font-semibold tabular-nums text-[var(--on-surface)]">{value}</dd>
            <dt className="text-[12px] text-[var(--on-surface-faint)]">{label}</dt>
          </div>
        ))}
      </dl>

      <p className="cq-enter mt-5 inline-flex items-center gap-1.5 text-[13px] text-[var(--on-surface-muted)]" style={{ "--d": "600ms" } as CSSProperties}>
        {sync === "error" ? (
          <>
            <CloudOff className="h-3.5 w-3.5 text-[#DC2626]" aria-hidden="true" /> Résultat non synchronisé : vérifie ta connexion.
          </>
        ) : (
          <>
            <CloudCheck className="h-3.5 w-3.5 text-[#16A34A]" aria-hidden="true" /> Résultat ajouté à ta progression, ici et dans l’application.
          </>
        )}
      </p>

      <div className="cq-enter mt-8 flex flex-col items-stretch justify-center gap-2.5 sm:flex-row sm:items-center" style={{ "--d": "680ms" } as CSSProperties}>
        <button
          type="button"
          onClick={onReplay}
          className="cq-btn cq-btn-shine inline-flex h-13 items-center justify-center gap-2 rounded-2xl bg-[#E0162B] px-6 text-[15.5px] font-semibold text-white shadow-[0_16px_36px_-16px_rgba(224,22,43,.9)] hover:bg-[#C8102A]"
        >
          <RotateCcw className="h-4.5 w-4.5" aria-hidden="true" /> {express ? "Lancer une vraie session" : "Nouvelle session"}
        </button>
        <Link
          href="/progression"
          className="inline-flex h-13 items-center justify-center gap-2 rounded-2xl bg-[var(--surface)] px-6 text-[15.5px] font-semibold text-[var(--on-surface)] ring-1 ring-[var(--outline)] hover:bg-[var(--surface-container-hi)]"
        >
          Voir ma progression <ArrowRight className="h-4 w-4" aria-hidden="true" />
        </Link>
        <button type="button" onClick={onClose} className="h-13 rounded-2xl px-4 text-[15px] font-semibold text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]">
          Retour à l’accueil
        </button>
      </div>

      {mistakes.length > 0 && (
        <div className="cq-enter mx-auto mt-10 max-w-2xl text-left" style={{ "--d": "760ms" } as CSSProperties}>
          <button
            type="button"
            onClick={() => setShowMistakes((v) => !v)}
            aria-expanded={showMistakes}
            className="flex w-full items-center justify-between rounded-2xl border border-[var(--outline)] bg-[var(--surface)] px-5 py-4 text-[15px] font-semibold text-[var(--on-surface)]"
          >
            Revoir mes erreurs ({mistakes.length})
            <ArrowRight className={cn("h-4 w-4 transition-transform duration-300", showMistakes && "rotate-90")} aria-hidden="true" />
          </button>
          {showMistakes && (
            <ol className="mt-3 grid gap-3">
              {mistakes.map(({ q, a }, i) => (
                <li key={q.id} className="cq-stagger-item rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5" style={{ "--i": i } as CSSProperties}>
                  <p className="text-[12px] font-semibold uppercase tracking-[0.12em] text-[var(--on-surface-faint)]">{q.sourceLabel}</p>
                  <p className="mt-1.5 text-[15.5px] font-semibold leading-snug text-[var(--on-surface)]">{q.question}</p>
                  <p className="mt-3 flex items-start gap-2 text-[14px] text-[#B91C1C] dark:text-[#F87171]">
                    <X className="mt-0.5 h-4 w-4 shrink-0" aria-hidden="true" />
                    <span className="line-through decoration-1">{a?.value}</span>
                  </p>
                  <p className="mt-1 flex items-start gap-2 text-[14px] font-semibold text-[#15803D] dark:text-[#4ADE80]">
                    <Check className="mt-0.5 h-4 w-4 shrink-0" aria-hidden="true" />
                    {q.answer}
                  </p>
                  {q.explanation && <p className="mt-3 border-t border-[var(--outline)] pt-3 text-[14px] leading-relaxed text-[var(--on-surface-muted)]">{q.explanation}</p>}
                </li>
              ))}
            </ol>
          )}
        </div>
      )}
    </div>
  )
}

function Confetti() {
  const colors = ["#1147D9", "#E0162B", "#FBBF24", "#22C55E", "#FFFFFF", "#7FB3FF"]
  return (
    <span className="cq-confetti pointer-events-none absolute inset-x-0 -top-6 h-0" aria-hidden="true">
      {Array.from({ length: 36 }, (_, i) => (
        <span
          key={i}
          style={
            {
              "--x": `${((i * 37) % 100) - 50}vw`,
              "--r": `${(i * 53) % 360}deg`,
              "--d": `${(i % 9) * 60}ms`,
              "--t": `${1700 + ((i * 97) % 900)}ms`,
              background: colors[i % colors.length],
            } as CSSProperties
          }
        />
      ))}
    </span>
  )
}

function PlayerSkeleton() {
  return (
    <div aria-busy="true" aria-label="Préparation de ta session">
      <div className="cq-skel h-7 w-36 rounded-full" />
      <div className="cq-skel mt-6 h-9 w-11/12 rounded-xl" />
      <div className="cq-skel mt-3 h-9 w-2/3 rounded-xl" />
      <div className="mt-8 grid gap-3">
        {[0, 1, 2, 3].map((i) => (
          <div key={i} className="cq-skel h-[68px] rounded-[18px]" style={{ animationDelay: `${i * 90}ms` }} />
        ))}
      </div>
    </div>
  )
}
