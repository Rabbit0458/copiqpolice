"use client"

import Link from "next/link"
import { useCallback, useEffect, useMemo, useState, type CSSProperties } from "react"
import { createPortal } from "react-dom"
import {
  ArrowRight,
  ArrowUpRight,
  BookOpen,
  Brain,
  CalendarClock,
  Check,
  ClipboardCheck,
  Clock3,
  Crown,
  FileText,
  Flame,
  GraduationCap,
  Languages,
  NotebookPen,
  Play,
  Search,
  Shuffle,
  Smartphone,
  Sparkles,
  StickyNote,
  Target,
  X,
  Zap,
  type LucideIcon,
} from "lucide-react"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { usePathway } from "@/features/pathway/pathway-provider"
import type { PathwayDefinition, PathwayFeature, PathwayIconKey } from "@/config/pathways"
import { Appear, SplitText, useInView } from "@/components/home/motion"
import { Counter } from "@/components/home/counter"
import { avatarSrc } from "@/features/auth/profile-rules"
import { daysUntil, loadHomeSnapshot, type CompetitionEvent, type HomeSnapshot, type Subject } from "@/features/home/progress"
import {
  EXAM_THEMES,
  loadQuestionOfTheDay,
  loadSchoolThemes,
  todayKey,
  type SessionPlan,
  type SessionQuestion,
  type SessionTheme,
} from "@/features/home/session"
import { SessionPlayer } from "@/features/home/session-player"

/**
 * Accueil de l'espace connecté — version 5 (octobre 2026).
 *
 * L'application, sur le site : on arrive, on choisit un thème, on joue.
 *  - « Que veux-tu travailler aujourd'hui ? » : thèmes, durée, lancement
 *    d'une session plein écran (features/home/session-player.tsx) ;
 *  - question du jour, série et accès à la progression ;
 *  - épreuves du parcours et calendrier du concours (ou modules de scolarité).
 * Un nouveau compte se voit proposer un test express de 5 questions.
 * Les sessions sont enregistrées comme dans l'application (même historique,
 * même progression). Les chiffres détaillés vivent sur /progression.
 */

const ICONS: Record<PathwayIconKey, LucideIcon> = {
  dashboard: Target,
  graduation: GraduationCap,
  quiz: Target,
  knowledge: BookOpen,
  brain: Brain,
  languages: Languages,
  caseStudies: FileText,
  mockExam: ClipboardCheck,
  memos: StickyNote,
  notes: NotebookPen,
}

const FEATURE_SUBJECT: Partial<Record<PathwayFeature, string>> = {
  generalKnowledge: "culture_generale",
  psychotechnics: "psychotechnique",
  languages: "langue_etrangere",
  caseStudies: "cas_pratique",
}

const LENGTHS = [5, 10, 20] as const

const SURPRISE: SessionTheme = { key: "surprise", label: "Session surprise", categories: [], quizSuffix: "", hint: "Un module au hasard" }

const greeting = () => {
  const h = new Date().getHours()
  return h >= 5 && h < 18 ? "Bonjour" : "Bonsoir"
}

const minutesFor = (n: number) => Math.max(2, Math.round(n * 0.45))

/* ─────────────────────────────────────────────────────────────────────────── */

export function AccueilV5() {
  const supabase = useMemo(() => createClient(), [])
  const { pathway, profile } = usePathway()
  const [userId, setUserId] = useState<string | null>(null)
  const [extra, setExtra] = useState<{ avatar: number; tier: string } | null>(null)
  const [snap, setSnap] = useState<HomeSnapshot | null>(null)
  const [schoolThemes, setSchoolThemes] = useState<SessionTheme[]>([])
  const [tick, setTick] = useState(0)
  const [plan, setPlan] = useState<SessionPlan | null>(null)
  const [run, setRun] = useState(0)

  useEffect(() => {
    let alive = true
    supabase.auth.getUser().then(async ({ data }) => {
      if (!alive || !data.user) return
      setUserId(data.user.id)
      const [{ data: prof }, { data: sub }] = await Promise.all([
        supabase.from("user_profiles").select("avatar_index").eq("user_id", data.user.id).maybeSingle(),
        supabase.from("cas_pratique_subscriptions").select("tier, status").eq("user_id", data.user.id).maybeSingle(),
      ])
      if (!alive) return
      const avatar = Number((prof as { avatar_index?: number } | null)?.avatar_index) || 1
      setExtra({ avatar: Math.min(20, Math.max(1, avatar)), tier: String((sub as { tier?: string } | null)?.tier ?? "free") })
    })
    return () => {
      alive = false
    }
  }, [supabase])

  useEffect(() => {
    if (!userId || !pathway) return
    let alive = true
    loadHomeSnapshot(supabase, userId, pathway)
      .then((s) => alive && setSnap(s))
      .catch(() => undefined)
    return () => {
      alive = false
    }
  }, [supabase, userId, pathway, tick])

  useEffect(() => {
    if (!pathway || pathway.mode !== "school") return
    let alive = true
    loadSchoolThemes(supabase, pathway.track)
      .then((t) => alive && setSchoolThemes(t))
      .catch(() => undefined)
    return () => {
      alive = false
    }
  }, [supabase, pathway])

  const launch = useCallback(
    (p: SessionPlan) => {
      let theme = p.theme
      if (theme.key === "surprise") {
        if (!schoolThemes.length) return
        theme = schoolThemes[Math.floor(Math.random() * schoolThemes.length)]
      }
      setPlan({ ...p, theme })
      setRun((r) => r + 1)
    },
    [schoolThemes],
  )

  if (!pathway) return null
  const firstName = profile?.first_name?.trim() || profile?.username || ""
  const premium = extra?.tier === "premium" || extra?.tier === "premium_trial"
  const kind = pathway.mode
  const isNew = snap !== null && snap.totalActivities === 0
  const themes = kind === "exam" ? EXAM_THEMES : [SURPRISE, ...schoolThemes]

  return (
    <div className="cq-accueil pb-10">
      <Launcher
        pathway={pathway}
        firstName={firstName}
        avatar={extra?.avatar ?? null}
        snap={snap}
        themes={themes}
        isNew={isNew}
        onLaunch={launch}
        schoolReady={kind === "exam" || schoolThemes.length > 0}
      />

      <div className="mt-6 grid gap-5 lg:grid-cols-12">
        <Appear className="lg:col-span-7" delay={60}>
          <QuestionOfTheDay
            pathway={pathway}
            schoolThemes={schoolThemes}
            onMore={(theme) => launch({ theme, count: 10, kind })}
          />
        </Appear>
        <Appear className="lg:col-span-5" delay={140}>
          <Momentum snap={snap} />
        </Appear>

        <Appear className="lg:col-span-12" delay={60}>
          <Epreuves pathway={pathway} snap={snap} premium={premium} />
        </Appear>

        {kind === "exam" ? (
          <Appear className="lg:col-span-12" delay={60}>
            <Timeline pathway={pathway} snap={snap} />
          </Appear>
        ) : (
          <Appear className="lg:col-span-12" delay={60}>
            <SchoolModules themes={schoolThemes} onLaunch={(theme) => launch({ theme, count: 10, kind })} />
          </Appear>
        )}

        <Appear className="lg:col-span-12" delay={60}>
          {premium ? <AppBand /> : <PremiumBand />}
        </Appear>
      </div>

      {plan && (
        <SessionPlayer
          key={run}
          plan={plan}
          pathway={pathway}
          onClose={() => setPlan(null)}
          onFinished={() => setTick((t) => t + 1)}
          onReplay={() =>
            launch(
              plan.express
                ? { theme: kind === "exam" ? EXAM_THEMES[0] : SURPRISE, count: 10, kind }
                : { ...plan, theme: plan.theme },
            )
          }
        />
      )}
    </div>
  )
}

/* ─── Lanceur : « Que veux-tu travailler aujourd'hui ? » ──────────────────── */

function Launcher({
  pathway,
  firstName,
  avatar,
  snap,
  themes,
  isNew,
  onLaunch,
  schoolReady,
}: {
  pathway: PathwayDefinition
  firstName: string
  avatar: number | null
  snap: HomeSnapshot | null
  themes: SessionTheme[]
  isNew: boolean
  onLaunch: (p: SessionPlan) => void
  schoolReady: boolean
}) {
  const [themeKey, setThemeKey] = useState(themes[0]?.key ?? "mix")
  const [count, setCount] = useState<(typeof LENGTHS)[number]>(10)
  const [allOpen, setAllOpen] = useState(false)
  const kind = pathway.mode
  const theme = themes.find((t) => t.key === themeKey) ?? themes[0]
  const visible = kind === "exam" ? themes.slice(0, 8) : themes.slice(0, 6)
  const selectedHidden = theme && !visible.some((t) => t.key === theme.key)
  const event = snap?.nextEvent ?? null
  const eventDate = event ? (event.type === "registration" ? event.endsOn : event.startsOn) : null
  const dLeft = eventDate ? daysUntil(eventDate) : null

  const start = () => theme && onLaunch({ theme, count, kind })
  const express = () => onLaunch({ theme: themes[0], count: 5, kind, express: true })

  return (
    <section className="cq-home-hero cq-enter-panel relative isolate overflow-hidden rounded-[28px] px-5 py-7 text-white sm:px-9 sm:py-9" aria-labelledby="accueil-titre">
      <span className="cq-hero-sheen pointer-events-none absolute inset-0" aria-hidden="true" />
      <span className="cq-launch-orb pointer-events-none absolute -right-24 -top-24 h-80 w-80 rounded-full" style={{ background: `radial-gradient(circle, ${pathway.color}55, transparent 65%)` }} aria-hidden="true" />

      <div className="relative grid gap-8 lg:grid-cols-[1fr_17.5rem]">
        <div className="min-w-0">
          <div className="flex items-center gap-3.5">
            {avatar ? (
              // eslint-disable-next-line @next/next/no-img-element
              <img src={avatarSrc(avatar)} alt="" width={52} height={52} className="cq-avatar-pop h-[52px] w-[52px] shrink-0 rounded-full ring-2 ring-white/20" />
            ) : (
              <span className="h-[52px] w-[52px] shrink-0 rounded-full bg-white/10" aria-hidden="true" />
            )}
            <div className="min-w-0">
              <p className="cq-enter text-[12.5px] font-semibold uppercase tracking-[0.16em] text-white/55" style={{ "--d": "100ms" } as CSSProperties}>
                {greeting()}
                {firstName ? ` ${firstName}` : ""} · {pathway.shortLabel}
              </p>
              <SplitText
                as="h1"
                id="accueil-titre"
                mode="load"
                delay={160}
                text="Que veux-tu travailler aujourd’hui ?"
                className="mt-1 block text-[clamp(1.65rem,3.4vw,2.6rem)] font-bold leading-[1.05] tracking-[-0.04em]"
              />
            </div>
          </div>

          {isNew && (
            <div className="cq-enter mt-6 flex flex-col gap-4 rounded-[22px] border border-white/15 bg-white/[0.08] p-4 backdrop-blur-md sm:flex-row sm:items-center sm:p-5" style={{ "--d": "380ms" } as CSSProperties}>
              <span className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-[#FBBF24]/15 text-[#FBBF24]">
                <Zap className="h-5 w-5" aria-hidden="true" />
              </span>
              <div className="min-w-0 flex-1">
                <p className="text-[15.5px] font-semibold">Nouveau ici ? Commence par le test express.</p>
                <p className="mt-0.5 text-[14px] text-white/65">5 questions, 2 minutes : tu sauras tout de suite où tu en es.</p>
              </div>
              <button
                type="button"
                onClick={express}
                disabled={!schoolReady}
                className="cq-btn cq-btn-shine inline-flex h-11 shrink-0 items-center justify-center gap-2 rounded-xl bg-white px-4 text-[14.5px] font-semibold text-[#000B36] hover:bg-white/90 disabled:opacity-60"
              >
                <Play className="h-4 w-4 fill-current" aria-hidden="true" /> Faire le test express
              </button>
            </div>
          )}

          {/* Thèmes */}
          <div className="cq-enter mt-6" style={{ "--d": "440ms" } as CSSProperties}>
            <p className="text-[12.5px] font-semibold uppercase tracking-[0.14em] text-white/50">{kind === "exam" ? "Thème" : "Module"}</p>
            <div className="mt-3 flex flex-wrap gap-2" role="radiogroup" aria-label={kind === "exam" ? "Choisir un thème" : "Choisir un module"}>
              {!schoolReady
                ? Array.from({ length: 5 }, (_, i) => <span key={i} className="h-10 w-32 animate-pulse rounded-full bg-white/10" />)
                : visible.map((t, i) => (
                    <ThemeChip key={t.key} theme={t} selected={t.key === theme?.key} index={i} onSelect={() => setThemeKey(t.key)} />
                  ))}
              {selectedHidden && theme && <ThemeChip theme={theme} selected index={0} onSelect={() => undefined} />}
              {themes.length > visible.length && (
                <button
                  type="button"
                  onClick={() => setAllOpen(true)}
                  className="inline-flex h-10 items-center gap-1.5 rounded-full px-3.5 text-[14px] font-medium text-white/75 ring-1 ring-dashed ring-white/25 transition-colors hover:bg-white/10 hover:text-white"
                >
                  <Search className="h-3.5 w-3.5" aria-hidden="true" />
                  {kind === "exam" ? "Plus de thèmes" : `Tous les modules (${themes.length - 1})`}
                </button>
              )}
            </div>
            {theme && <p className="mt-3 min-h-5 text-[13.5px] text-white/55">{theme.hint}</p>}
          </div>

          {/* Durée + lancement */}
          <div className="cq-enter mt-6 flex flex-col gap-3 sm:flex-row sm:items-center" style={{ "--d": "520ms" } as CSSProperties}>
            <div className="relative grid grid-cols-3 rounded-2xl bg-white/[0.08] p-1 ring-1 ring-white/10" role="radiogroup" aria-label="Nombre de questions">
              <span
                className="cq-seg-pill absolute inset-y-1 left-1 w-[calc((100%-0.5rem)/3)] rounded-xl bg-white shadow-[0_8px_20px_-10px_rgba(0,0,0,.6)]"
                style={{ transform: `translateX(${LENGTHS.indexOf(count) * 100}%)` }}
                aria-hidden="true"
              />
              {LENGTHS.map((n) => (
                <button
                  key={n}
                  type="button"
                  role="radio"
                  aria-checked={count === n}
                  onClick={() => setCount(n)}
                  className={cn("relative z-10 h-11 rounded-xl px-4 text-[14px] font-semibold transition-colors duration-300", count === n ? "text-[#000B36]" : "text-white/70 hover:text-white")}
                >
                  {n} <span className="font-normal opacity-70">quest.</span>
                </button>
              ))}
            </div>
            <button
              type="button"
              onClick={start}
              disabled={!theme || !schoolReady}
              className="cq-btn cq-btn-shine cq-launch-btn group inline-flex h-[52px] items-center justify-center gap-2.5 rounded-2xl bg-[#E0162B] px-6 text-[16px] font-semibold text-white shadow-[0_18px_40px_-16px_rgba(224,22,43,.95)] hover:bg-[#C8102A] disabled:opacity-60"
            >
              <Play className="h-4.5 w-4.5 fill-current" aria-hidden="true" />
              Lancer la session
              <span className="inline-flex items-center gap-1 rounded-lg bg-white/15 px-2 py-0.5 text-[12.5px] font-medium">
                <Clock3 className="h-3.5 w-3.5" aria-hidden="true" />≈ {minutesFor(count)} min
              </span>
            </button>
          </div>
        </div>

        {/* Colonne droite : échéance ou série */}
        <div className="cq-enter flex flex-col gap-3" style={{ "--d": "360ms" } as CSSProperties}>
          {dLeft !== null && event ? (
            <div className="rounded-[22px] border border-white/12 bg-white/[0.07] p-5 backdrop-blur-md">
              <p className="flex items-center gap-2 text-[12px] font-semibold uppercase tracking-[0.14em] text-white/55">
                <CalendarClock className="h-4 w-4" aria-hidden="true" />
                {event.type === "registration" ? "Fin des inscriptions" : event.typeLabel}
              </p>
              <p className="mt-3 text-[3rem] font-bold leading-none tracking-[-0.05em]">{dLeft === 0 ? "Aujourd’hui" : <>J‑<Counter value={dLeft} delay={450} /></>}</p>
              <p className="mt-2 line-clamp-2 text-[13.5px] leading-snug text-white/65">{event.dateText}</p>
            </div>
          ) : (
            <div className="rounded-[22px] border border-white/12 bg-white/[0.07] p-5 backdrop-blur-md">
              <p className="flex items-center gap-2 text-[12px] font-semibold uppercase tracking-[0.14em] text-white/55">
                <Sparkles className="h-4 w-4" aria-hidden="true" /> {pathway.title}
              </p>
              <p className="mt-3 text-[14.5px] leading-relaxed text-white/75">{pathway.description}</p>
            </div>
          )}
          <div className="grid grid-cols-2 gap-3">
            <MiniStat label="Série" value={snap ? snap.streakDays : null} suffix={snap && snap.streakDays > 1 ? " jours" : " jour"} flame={!!snap && snap.streakDays > 0} />
            <MiniStat label="Aujourd’hui" value={snap ? snap.doneToday : null} suffix={snap && snap.doneToday > 1 ? " séances" : " séance"} />
          </div>
        </div>
      </div>

      {allOpen && (
        <ThemeSheet
          themes={themes}
          kind={kind}
          selected={theme?.key ?? ""}
          onClose={() => setAllOpen(false)}
          onSelect={(k) => {
            setThemeKey(k)
            setAllOpen(false)
          }}
        />
      )}
    </section>
  )
}

function ThemeChip({ theme, selected, index, onSelect }: { theme: SessionTheme; selected: boolean; index: number; onSelect: () => void }) {
  const Icon = theme.key === "mix" || theme.key === "surprise" ? Shuffle : null
  return (
    <button
      type="button"
      role="radio"
      aria-checked={selected}
      onClick={onSelect}
      className={cn(
        "cq-chip cq-stagger-item inline-flex h-10 max-w-[16rem] items-center gap-1.5 rounded-full px-4 text-[14px] font-medium",
        selected ? "is-on bg-white text-[#000B36] shadow-[0_10px_26px_-12px_rgba(255,255,255,.55)]" : "bg-white/[0.08] text-white/85 ring-1 ring-white/12 hover:bg-white/[0.14] hover:text-white",
      )}
      style={{ "--i": index } as CSSProperties}
    >
      {Icon && <Icon className="h-3.5 w-3.5 shrink-0" aria-hidden="true" />}
      <span className="truncate">{theme.label}</span>
      {selected && <Check className="cq-chip-check h-3.5 w-3.5 shrink-0" strokeWidth={3} aria-hidden="true" />}
    </button>
  )
}

function MiniStat({ label, value, suffix, flame }: { label: string; value: number | null; suffix: string; flame?: boolean }) {
  return (
    <div className="rounded-[18px] border border-white/10 bg-white/[0.05] px-4 py-3.5">
      <p className="text-[12px] font-medium text-white/50">{label}</p>
      <p className="mt-1 flex items-center gap-1.5 text-[19px] font-bold tracking-[-0.02em]">
        {flame && <Flame className="cq-flame h-4.5 w-4.5 text-[#FB923C]" aria-hidden="true" />}
        {value === null ? <span className="inline-block h-5 w-10 animate-pulse rounded bg-white/10" /> : <Counter value={value} suffix={suffix} />}
      </p>
    </div>
  )
}

function ThemeSheet({
  themes,
  kind,
  selected,
  onClose,
  onSelect,
}: {
  themes: SessionTheme[]
  kind: "exam" | "school"
  selected: string
  onClose: () => void
  onSelect: (key: string) => void
}) {
  const [q, setQ] = useState("")
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose()
    window.addEventListener("keydown", onKey)
    return () => window.removeEventListener("keydown", onKey)
  }, [onClose])
  const norm = (s: string) => s.toLowerCase().normalize("NFD").replace(/\p{Diacritic}/gu, "")
  const list = themes.filter((t) => norm(`${t.label} ${t.hint}`).includes(norm(q)))
  const groups = new Map<string, SessionTheme[]>()
  for (const t of list) {
    const g = kind === "exam" ? "Culture générale" : t.group ?? "Au hasard"
    groups.set(g, [...(groups.get(g) ?? []), t])
  }

  return createPortal(
    <div className="fixed inset-0 z-[110] flex items-end justify-center bg-[#000B36]/50 p-0 backdrop-blur-sm sm:items-center sm:p-6" onClick={onClose}>
      <div
        role="dialog"
        aria-modal="true"
        aria-label={kind === "exam" ? "Tous les thèmes" : "Tous les modules"}
        onClick={(e) => e.stopPropagation()}
        className="cq-sheet flex max-h-[85dvh] w-full max-w-2xl flex-col overflow-hidden rounded-t-[28px] border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] shadow-[0_40px_100px_-40px_rgba(0,11,54,.8)] sm:rounded-[28px]"
      >
        <div className="flex items-center gap-3 border-b border-[var(--outline)] p-4">
          <Search className="ml-1 h-4.5 w-4.5 text-[var(--on-surface-faint)]" aria-hidden="true" />
          <input
            autoFocus
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder={kind === "exam" ? "Rechercher un thème" : "Rechercher un module (ex. flagrant délit)"}
            className="h-10 flex-1 bg-transparent text-[15.5px] outline-none placeholder:text-[var(--on-surface-faint)]"
          />
          <button type="button" onClick={onClose} aria-label="Fermer" className="grid h-10 w-10 place-items-center rounded-xl text-[var(--on-surface-muted)] hover:bg-[var(--surface-container-hi)]">
            <X className="h-5 w-5" aria-hidden="true" />
          </button>
        </div>
        <div className="overflow-y-auto p-3">
          {list.length === 0 && <p className="px-3 py-10 text-center text-[14.5px] text-[var(--on-surface-muted)]">Aucun résultat pour « {q} ».</p>}
          {[...groups.entries()].map(([g, items]) => (
            <div key={g} className="mb-2">
              <p className="px-3 pb-1.5 pt-3 text-[12px] font-semibold uppercase tracking-[0.12em] text-[var(--on-surface-faint)]">{g}</p>
              <ul className="grid gap-1 sm:grid-cols-2">
                {items.map((t, i) => (
                  <li key={t.key} className="cq-stagger-item" style={{ "--i": Math.min(i, 12) } as CSSProperties}>
                    <button
                      type="button"
                      onClick={() => onSelect(t.key)}
                      className={cn(
                        "flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left text-[14.5px] transition-colors",
                        t.key === selected ? "bg-[#1147D9]/10 font-semibold text-[#1147D9] dark:text-[#7FB3FF]" : "hover:bg-[var(--surface-container)]",
                      )}
                    >
                      <span className="min-w-0 flex-1 truncate">{t.label}</span>
                      {t.key === selected && <Check className="h-4 w-4 shrink-0" aria-hidden="true" />}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </div>
    </div>,
    document.body,
  )
}

/* ─── Question du jour ────────────────────────────────────────────────────── */

function QuestionOfTheDay({
  pathway,
  schoolThemes,
  onMore,
}: {
  pathway: PathwayDefinition
  schoolThemes: SessionTheme[]
  onMore: (theme: SessionTheme) => void
}) {
  const supabase = useMemo(() => createClient(), [])
  const [q, setQ] = useState<SessionQuestion | null>(null)
  const [state, setState] = useState<"loading" | "ready" | "empty">("loading")
  const [picked, setPicked] = useState<string | null>(null)
  const storageKey = `cq-qotd:${todayKey()}:${pathway.id}`
  const ready = pathway.mode === "exam" || schoolThemes.length > 0

  useEffect(() => {
    if (!ready) return
    let alive = true
    loadQuestionOfTheDay(supabase, pathway, schoolThemes)
      .then((question) => {
        if (!alive) return
        setQ(question)
        setState(question ? "ready" : "empty")
        try {
          const saved = window.localStorage.getItem(storageKey)
          if (saved && question?.options.includes(saved)) setPicked(saved)
        } catch {
          /* stockage indisponible : on rejoue simplement */
        }
      })
      .catch(() => alive && setState("empty"))
    return () => {
      alive = false
    }
  }, [supabase, pathway, schoolThemes, ready, storageKey])

  const choose = (opt: string) => {
    if (picked) return
    setPicked(opt)
    try {
      window.localStorage.setItem(storageKey, opt)
    } catch {
      /* rien */
    }
  }

  const right = picked !== null && q !== null && picked === q.answer
  const themeForMore = (): SessionTheme | null => {
    if (!q) return null
    if (pathway.mode === "exam") return EXAM_THEMES.find((t) => t.categories.length === 1 && t.categories[0] === q.sourceKey) ?? EXAM_THEMES[0]
    return schoolThemes.find((t) => t.key === q.sourceKey) ?? null
  }

  return (
    <section className="relative h-full overflow-hidden rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-7" aria-labelledby="qotd-title">
      <span className="pointer-events-none absolute -left-20 -top-24 h-56 w-56 rounded-full bg-[#1147D9]/10 blur-3xl" aria-hidden="true" />
      <div className="relative flex items-center justify-between gap-3">
        <p id="qotd-title" className="flex items-center gap-2 text-[12.5px] font-semibold uppercase tracking-[0.14em] text-[#1147D9] dark:text-[#7FB3FF]">
          <Sparkles className="h-4 w-4" aria-hidden="true" /> Question du jour
        </p>
        {q && <span className="truncate rounded-full bg-[var(--surface-container)] px-3 py-1 text-[12.5px] font-medium text-[var(--on-surface-muted)]">{q.sourceLabel}</span>}
      </div>

      {state === "loading" ? (
        <div className="relative mt-5" aria-busy="true">
          <div className="cq-skel h-7 w-5/6 rounded-lg" />
          <div className="mt-5 grid gap-2.5 sm:grid-cols-2">
            {[0, 1, 2, 3].map((i) => (
              <div key={i} className="cq-skel h-12 rounded-xl" />
            ))}
          </div>
        </div>
      ) : state === "empty" || !q ? (
        <p className="relative mt-5 text-[15px] text-[var(--on-surface-muted)]">La question du jour arrive bientôt. En attendant, lance une session ci-dessus.</p>
      ) : (
        <div className="relative">
          <h2 className="mt-4 text-[clamp(1.15rem,1.9vw,1.4rem)] font-semibold leading-snug tracking-[-0.02em] text-[var(--on-surface)]">{q.question}</h2>
          <ul className="mt-5 grid gap-2.5 sm:grid-cols-2">
            {q.options.map((opt, i) => {
              const st = picked === null ? "idle" : opt === q.answer ? (opt === picked ? "right" : "reveal") : opt === picked ? "wrong" : "dim"
              return (
                <li key={opt} className="cq-stagger-item" style={{ "--i": i } as CSSProperties}>
                  <button
                    type="button"
                    disabled={picked !== null}
                    onClick={() => choose(opt)}
                    className={cn("cq-opt cq-opt-sm relative flex h-full w-full items-center gap-3 overflow-hidden rounded-[14px] border-2 px-3.5 py-3 text-left", `is-${st}`)}
                  >
                    <span className="cq-opt-key grid h-7 w-7 shrink-0 place-items-center rounded-lg text-[12px] font-bold">
                      {st === "right" || st === "reveal" ? <Check className="cq-opt-icon h-4 w-4" strokeWidth={3} /> : st === "wrong" ? <X className="cq-opt-icon h-4 w-4" strokeWidth={3} /> : String.fromCharCode(65 + i)}
                    </span>
                    <span className="text-[14.5px] font-medium leading-snug">{opt}</span>
                  </button>
                </li>
              )
            })}
          </ul>
          {picked !== null && (
            <div className={cn("cq-feedback mt-4 rounded-[16px] border p-4", right ? "is-right" : "is-wrong")} role="status" aria-live="polite">
              <p className="text-[14.5px] font-semibold">{right ? "Bravo, bonne réponse !" : `Raté ! La bonne réponse : « ${q.answer} »`}</p>
              {q.explanation && <p className="mt-1.5 text-[14px] leading-relaxed text-[var(--on-surface-muted)]">{q.explanation}</p>}
              <div className="mt-3 flex flex-wrap items-center justify-between gap-2">
                <p className="text-[12.5px] text-[var(--on-surface-faint)]">Nouvelle question demain.</p>
                {themeForMore() && (
                  <button
                    type="button"
                    onClick={() => {
                      const t = themeForMore()
                      if (t) onMore(t)
                    }}
                    className="inline-flex items-center gap-1.5 rounded-lg text-[13.5px] font-semibold text-[#1147D9] hover:underline dark:text-[#7FB3FF]"
                  >
                    10 questions sur ce thème <ArrowRight className="h-3.5 w-3.5" aria-hidden="true" />
                  </button>
                )}
              </div>
            </div>
          )}
        </div>
      )}
    </section>
  )
}

/* ─── Élan : série, semaine, réussite → Progression ───────────────────────── */

function Momentum({ snap }: { snap: HomeSnapshot | null }) {
  const days = ["L", "M", "M", "J", "V", "S", "D"]
  return (
    <Link href="/progression" className="cq-card-lift group relative flex h-full flex-col rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-7">
      <div className="flex items-center justify-between">
        <h2 className="text-[15px] font-semibold text-[var(--on-surface)]">Ton élan</h2>
        <span className="inline-flex items-center gap-1 text-[13.5px] font-semibold text-[#1147D9] dark:text-[#7FB3FF]">
          Ma progression <ArrowUpRight className="h-3.5 w-3.5 transition-transform duration-300 group-hover:-translate-y-0.5 group-hover:translate-x-0.5" aria-hidden="true" />
        </span>
      </div>
      {!snap ? (
        <div className="mt-5 grid gap-3" aria-busy="true">
          <div className="cq-skel h-14 rounded-2xl" />
          <div className="cq-skel h-10 rounded-xl" />
          <div className="cq-skel h-10 rounded-xl" />
        </div>
      ) : (
        <>
          <div className="mt-5 flex items-center gap-4">
            <span className={cn("grid h-14 w-14 place-items-center rounded-2xl", snap.streakDays > 0 ? "bg-[#F97316]/12 text-[#EA580C]" : "bg-[var(--surface-container)] text-[var(--on-surface-faint)]")}>
              <Flame className={cn("h-7 w-7", snap.streakDays > 0 && "cq-flame")} aria-hidden="true" />
            </span>
            <div>
              <p className="text-[1.9rem] font-bold leading-none tracking-[-0.03em] text-[var(--on-surface)]">
                <Counter value={snap.streakDays} /> <span className="text-[15px] font-semibold text-[var(--on-surface-muted)]">jour{snap.streakDays > 1 ? "s" : ""} d’affilée</span>
              </p>
              <p className="mt-1 text-[13.5px] text-[var(--on-surface-muted)]">
                {snap.doneToday > 0 ? "Objectif du jour atteint, bravo !" : snap.streakDays > 0 ? "Une session aujourd’hui pour garder ta série." : "Une session aujourd’hui pour lancer ta série."}
              </p>
            </div>
          </div>
          <ol className="mt-5 grid grid-cols-7 gap-1.5" aria-label="7 derniers jours">
            {snap.week.map((d, i) => {
              const on = d.count > 0
              const today = i === snap.week.length - 1
              return (
                <li key={d.day.toISOString()} className="flex flex-col items-center gap-1">
                  <span
                    className={cn(
                      "cq-day grid aspect-square w-full max-w-9 place-items-center rounded-xl",
                      on ? "bg-[#1147D9] text-white shadow-[0_8px_18px_-10px_rgba(17,71,217,.9)]" : "bg-[var(--surface-container)]",
                      today && !on && "ring-2 ring-[var(--outline)]",
                    )}
                    style={{ "--d": `${200 + i * 60}ms` } as CSSProperties}
                  >
                    {on && <Check className="h-3.5 w-3.5" strokeWidth={3} aria-hidden="true" />}
                  </span>
                  <span className={cn("text-[11px] font-medium", today ? "text-[var(--on-surface)]" : "text-[var(--on-surface-faint)]")}>{days[(d.day.getDay() + 6) % 7]}</span>
                </li>
              )
            })}
          </ol>
          <div className="mt-auto grid grid-cols-2 gap-3 pt-5">
            <div className="rounded-2xl bg-[var(--surface-container)] px-4 py-3">
              <p className="text-[12px] text-[var(--on-surface-faint)]">Réussite globale</p>
              <p className="mt-0.5 text-[18px] font-semibold text-[var(--on-surface)]">{snap.totalActivities ? <Counter value={snap.globalPercent} suffix=" %" /> : "—"}</p>
            </div>
            <div className="rounded-2xl bg-[var(--surface-container)] px-4 py-3">
              <p className="text-[12px] text-[var(--on-surface-faint)]">Cette semaine</p>
              <p className="mt-0.5 text-[18px] font-semibold text-[var(--on-surface)]">
                <Counter value={snap.doneThisWeek} suffix={snap.doneThisWeek > 1 ? " séances" : " séance"} />
              </p>
            </div>
          </div>
        </>
      )}
    </Link>
  )
}

/* ─── Épreuves du parcours ────────────────────────────────────────────────── */

function Epreuves({ pathway, snap, premium }: { pathway: PathwayDefinition; snap: HomeSnapshot | null; premium: boolean }) {
  const [ref, inView] = useInView<HTMLUListElement>({ threshold: 0.15 })
  return (
    <section aria-labelledby="epreuves">
      <div className="mb-3 flex items-end justify-between px-1">
        <h2 id="epreuves" className="text-[17px] font-semibold tracking-[-0.01em] text-[var(--on-surface)]">
          {pathway.mode === "exam" ? "Tes épreuves" : "Ta scolarité"}
        </h2>
        <p className="hidden text-[13px] text-[var(--on-surface-faint)] sm:block">Survole une carte pour voir ta maîtrise</p>
      </div>
      <ul ref={ref} className="grid grid-cols-2 gap-3 md:grid-cols-3 xl:grid-cols-6">
        {pathway.navigation.map((n, i) => {
          const Icon = ICONS[n.iconKey]
          const subjectKey = FEATURE_SUBJECT[n.feature]
          const subject: Subject | undefined = subjectKey && snap ? snap.subjects.find((s) => s.key === subjectKey) : undefined
          const locked = n.premium && !premium
          return (
            <li key={n.href + n.label} className="cq-stagger-item" style={{ "--i": i } as CSSProperties}>
              <Link href={n.href} className="cq-epreuve group relative flex h-full min-h-[11.5rem] flex-col overflow-hidden rounded-[22px] border border-[var(--outline)] bg-[var(--surface)] p-4">
                <span className="cq-epreuve-wash pointer-events-none absolute inset-0" style={{ background: `radial-gradient(120% 80% at 0% 0%, ${pathway.color}1f, transparent 60%)` }} aria-hidden="true" />
                <span className="relative flex items-start justify-between">
                  <span className="cq-epreuve-icon grid h-11 w-11 place-items-center rounded-2xl" style={{ background: pathway.softColor, color: pathway.color }}>
                    <Icon className="h-5 w-5" aria-hidden="true" />
                  </span>
                  {locked && (
                    <span className="inline-flex items-center gap-1 rounded-full bg-[#F59E0B]/12 px-2 py-0.5 text-[11px] font-semibold text-[#B45309] dark:text-[#FBBF24]">
                      <Crown className="h-3 w-3" aria-hidden="true" /> Premium
                    </span>
                  )}
                </span>
                <span className="relative mt-4 text-[15px] font-semibold leading-snug text-[var(--on-surface)]">{n.label}</span>
                <span className="relative mt-1 text-[13px] leading-snug text-[var(--on-surface-muted)]">{n.description}</span>
                <span className="relative mt-auto pt-4">
                  {subject ? (
                    <>
                      <span className="flex items-baseline justify-between text-[12.5px]">
                        <span className="text-[var(--on-surface-faint)]">Maîtrise</span>
                        <span className="font-semibold tabular-nums" style={{ color: subject.color }}>
                          {subject.averagePercent} %
                        </span>
                      </span>
                      <span className="mt-1.5 block h-1.5 overflow-hidden rounded-full bg-[var(--surface-container-hi)]">
                        <span
                          className={cn("cq-bar block h-full rounded-full", inView && "is-in")}
                          style={{ width: `${Math.max(4, subject.averagePercent)}%`, background: subject.color, "--d": `${200 + i * 90}ms` } as CSSProperties}
                        />
                      </span>
                    </>
                  ) : (
                    <span className="inline-flex items-center gap-1 text-[13px] font-semibold" style={{ color: pathway.color }}>
                      Commencer <ArrowRight className="h-3.5 w-3.5 transition-transform duration-500 group-hover:translate-x-1" aria-hidden="true" />
                    </span>
                  )}
                </span>
              </Link>
            </li>
          )
        })}
      </ul>
    </section>
  )
}

/* ─── Calendrier du concours ──────────────────────────────────────────────── */

type Step = { key: string; label: string; phase?: string; match: (e: CompetitionEvent) => boolean }

function Timeline({ pathway, snap }: { pathway: PathwayDefinition; snap: HomeSnapshot | null }) {
  const [ref, inView] = useInView<HTMLDivElement>({ threshold: 0.25 })
  const isOral = (e: CompetitionEvent) => e.type === "oral" || (e.type === "other" && /oral/i.test(e.dateText))
  const steps: Step[] = [
    { key: "registration", label: "Inscriptions", match: (e) => e.type === "registration" },
    { key: "written", label: "Épreuves écrites", phase: pathway.track === "gpx" ? "Admissibilité" : undefined, match: (e) => e.type === "written" },
    { key: "sport", label: "Épreuves sportives", phase: pathway.track === "gpx" ? "Admission" : undefined, match: (e) => e.type === "sport" },
    { key: "oral", label: "Oral", phase: pathway.track === "gpx" ? "Admission" : undefined, match: isOral },
  ]
  const upcoming = snap?.upcoming ?? []
  const items = steps.map((s) => {
    const e = upcoming.find(s.match) ?? null
    const date = e ? (s.key === "registration" ? e.endsOn ?? e.startsOn : e.startsOn) : null
    return { ...s, event: e, date, days: date ? daysUntil(date) : null }
  })
  const soonest = items.reduce<number>((best, it, i) => (it.days === null ? best : best === -1 || it.days < (items[best].days ?? Infinity) ? i : best), -1)

  return (
    <section ref={ref} className="rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-7" aria-labelledby="calendrier">
      <div className="flex flex-wrap items-end justify-between gap-2">
        <div>
          <h2 id="calendrier" className="text-[17px] font-semibold tracking-[-0.01em] text-[var(--on-surface)]">
            Ton concours, étape par étape
          </h2>
          <p className="mt-1 text-[13.5px] text-[var(--on-surface-muted)]">Dates officielles publiées pour le concours {pathway.track === "gpx" ? "de gardien de la paix" : "de policier adjoint"}.</p>
        </div>
      </div>

      <div className="relative mt-7">
        {/* Rail */}
        <span className="absolute left-[1.15rem] top-2 bottom-2 w-[2px] rounded-full bg-[var(--surface-container-hi)] md:left-0 md:right-0 md:top-[1.15rem] md:bottom-auto md:h-[2px] md:w-auto" aria-hidden="true" />
        <span
          className={cn("cq-rail absolute left-[1.15rem] top-2 w-[2px] rounded-full md:left-0 md:top-[1.15rem] md:h-[2px]", inView && "is-in")}
          style={{ "--p": `${soonest < 0 ? 0 : ((soonest + 0.5) / items.length) * 100}%`, background: `linear-gradient(90deg, ${pathway.color}, #E0162B)` } as CSSProperties}
          aria-hidden="true"
        />
        <ol className="relative grid gap-6 md:grid-cols-4 md:gap-4">
          {items.map((it, i) => {
            const next = i === soonest
            return (
              <li key={it.key} className={cn("cq-step flex gap-4 md:block", inView && "is-in")} style={{ "--d": `${150 + i * 140}ms` } as CSSProperties}>
                <span
                  className={cn(
                    "relative z-10 grid h-[2.3rem] w-[2.3rem] shrink-0 place-items-center rounded-full border-2 text-[13px] font-bold",
                    next ? "cq-step-next border-transparent text-white" : it.date ? "border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)]" : "border-dashed border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface-faint)]",
                  )}
                  style={next ? { background: pathway.color } : undefined}
                >
                  {i + 1}
                </span>
                <div className="min-w-0 md:mt-4">
                  {it.phase && <p className="text-[11.5px] font-semibold uppercase tracking-[0.12em] text-[var(--on-surface-faint)]">{it.phase}</p>}
                  <p className="text-[15px] font-semibold text-[var(--on-surface)]">{it.label}</p>
                  {it.event && it.days !== null ? (
                    <>
                      <p className={cn("mt-1 text-[22px] font-bold tracking-[-0.03em]", next ? "" : "text-[var(--on-surface)]")} style={next ? { color: pathway.color } : undefined}>
                        {it.days <= 0 ? (it.key === "registration" ? "Ouvertes" : "Aujourd’hui") : `J‑${it.days}`}
                      </p>
                      <p className="mt-0.5 line-clamp-2 text-[13px] leading-snug text-[var(--on-surface-muted)]">{it.event.dateText}</p>
                    </>
                  ) : (
                    <p className="mt-1 text-[13.5px] text-[var(--on-surface-faint)]">{snap ? "Date à venir" : "…"}</p>
                  )}
                </div>
              </li>
            )
          })}
        </ol>
      </div>
    </section>
  )
}

/* ─── Scolarité : modules à explorer ──────────────────────────────────────── */

function SchoolModules({ themes, onLaunch }: { themes: SessionTheme[]; onLaunch: (t: SessionTheme) => void }) {
  const picks = useMemo(() => {
    if (!themes.length) return []
    const d = new Date()
    const start = (d.getFullYear() * 400 + d.getMonth() * 31 + d.getDate()) % themes.length
    return Array.from({ length: Math.min(6, themes.length) }, (_, i) => themes[(start + i * 7) % themes.length]).filter((t, i, a) => a.indexOf(t) === i)
  }, [themes])
  return (
    <section aria-labelledby="modules">
      <div className="mb-3 flex items-end justify-between px-1">
        <h2 id="modules" className="text-[17px] font-semibold tracking-[-0.01em] text-[var(--on-surface)]">
          Modules du jour
        </h2>
        <p className="hidden text-[13px] text-[var(--on-surface-faint)] sm:block">10 questions, correction immédiate</p>
      </div>
      <ul className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
        {picks.length === 0
          ? Array.from({ length: 3 }, (_, i) => <li key={i} className="cq-skel h-28 rounded-[22px]" />)
          : picks.map((t, i) => (
              <li key={t.key} className="cq-stagger-item" style={{ "--i": i } as CSSProperties}>
                <button type="button" onClick={() => onLaunch(t)} className="cq-epreuve group relative flex h-full w-full items-center gap-4 overflow-hidden rounded-[22px] border border-[var(--outline)] bg-[var(--surface)] p-5 text-left">
                  <span className="min-w-0 flex-1">
                    <span className="block text-[12px] font-semibold uppercase tracking-[0.12em] text-[var(--on-surface-faint)]">{t.group}</span>
                    <span className="mt-1 block truncate text-[15.5px] font-semibold text-[var(--on-surface)]">{t.label}</span>
                  </span>
                  <span className="cq-epreuve-icon grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-[#000B36] text-white dark:bg-[#1147D9]">
                    <Play className="h-4 w-4 translate-x-[1px] fill-current" aria-hidden="true" />
                  </span>
                </button>
              </li>
            ))}
      </ul>
    </section>
  )
}

/* ─── Premium / Application ───────────────────────────────────────────────── */

function PremiumBand() {
  return (
    <div className="cq-home-hero relative flex flex-col gap-5 overflow-hidden rounded-[24px] p-6 text-white sm:flex-row sm:items-center sm:p-7">
      <span className="cq-hero-sheen pointer-events-none absolute inset-0" aria-hidden="true" />
      <div className="relative min-w-0 flex-1">
        <p className="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-[12px] font-semibold uppercase tracking-[0.12em] ring-1 ring-white/10">
          <Crown className="h-3.5 w-3.5 text-[#FBBF24]" aria-hidden="true" /> Premium
        </p>
        <h2 className="mt-3 text-[1.35rem] font-bold leading-tight tracking-[-0.03em]">Tout COP’IQ, sans limite.</h2>
        <p className="mt-1.5 text-[14.5px] text-white/70">Cas pratiques corrigés, concours blancs chronométrés et tous les entraînements, sur le site et dans l’app.</p>
      </div>
      <Link href="/abonnement" className="cq-btn cq-btn-shine relative inline-flex h-12 shrink-0 items-center justify-center gap-2 rounded-xl bg-white px-5 text-[14.5px] font-semibold text-[#000B36] hover:bg-white/90">
        Voir les formules <ArrowRight className="h-4 w-4" aria-hidden="true" />
      </Link>
    </div>
  )
}

function AppBand() {
  return (
    <div className="flex items-center gap-4 rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6">
      <span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-[#1147D9]/10 text-[#1147D9] dark:text-[#7FB3FF]">
        <Smartphone className="h-5 w-5" aria-hidden="true" />
      </span>
      <div>
        <h2 className="text-[16px] font-semibold text-[var(--on-surface)]">Même compte, même progression</h2>
        <p className="mt-1 text-[14px] text-[var(--on-surface-muted)]">Tes sessions jouées ici apparaissent aussi dans l’application COP’IQ.</p>
      </div>
    </div>
  )
}
