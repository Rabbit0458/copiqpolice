"use client"

import Link from "next/link"
import { useState, type CSSProperties } from "react"
import { Check, X, Scale, RotateCcw } from "lucide-react"
import { cn } from "@/lib/utils"
import { HOME_QUIZ } from "@/data/home"

/**
 * Quiz de l'accueil : trois vraies questions de concours, jouables sans
 * compte. C'est le premier contact avec le produit — le visiteur s'entraîne
 * au lieu de lire une promesse.
 *
 * Les trois segments de progression reprennent le bleu, le blanc et le rouge :
 * chacun s'allume quand la question correspondante a reçu une réponse.
 */

const SEGMENT_COLORS = ["#3D7BFF", "#FFFFFF", "#E0162B"] as const
const LETTERS = ["A", "B", "C", "D"] as const

export function HeroQuiz() {
  const [index, setIndex] = useState(0)
  const [picked, setPicked] = useState<(number | null)[]>(() => HOME_QUIZ.map(() => null))
  const [done, setDone] = useState(false)

  const question = HOME_QUIZ[index]
  const choice = picked[index]
  const answered = choice !== null
  const isLast = index === HOME_QUIZ.length - 1
  const score = picked.filter((p, i) => p === HOME_QUIZ[i].answer).length

  function pick(option: number) {
    if (answered) return
    setPicked((prev) => prev.map((p, i) => (i === index ? option : p)))
  }

  function next() {
    if (isLast) setDone(true)
    else setIndex((i) => i + 1)
  }

  function restart() {
    setPicked(HOME_QUIZ.map(() => null))
    setIndex(0)
    setDone(false)
  }

  return (
    <div className="cq-quiz-panel relative rounded-[28px] p-5 sm:p-7">
      {/* Progression : un segment par question */}
      <div className="flex items-center justify-between gap-4">
        <p className="text-[13px] font-medium text-white/60">
          {done ? "Résultat" : `Question ${index + 1} sur ${HOME_QUIZ.length}`}
        </p>
        {!done && (
          <span className="rounded-full border border-white/12 px-2.5 py-1 text-[12px] font-medium text-white/75">
            {question.subject}
          </span>
        )}
      </div>
      <div className="mt-3 flex gap-1.5" aria-hidden="true">
        {HOME_QUIZ.map((q, i) => (
          <span
            key={q.id}
            className="h-1.5 flex-1 rounded-full transition-[background-color] duration-700 ease-[cubic-bezier(0.22,1,0.36,1)]"
            style={{
              background:
                picked[i] !== null
                  ? SEGMENT_COLORS[i]
                  : i === index && !done
                    ? "rgba(255,255,255,0.28)"
                    : "rgba(255,255,255,0.10)",
            }}
          />
        ))}
      </div>

      {done ? (
        <div key="result" className="cq-quiz-in mt-7">
          <p className="text-[clamp(3rem,7vw,4.25rem)] font-bold leading-none tracking-[-0.04em] text-white">
            {score}
            <span className="text-white/35">/{HOME_QUIZ.length}</span>
          </p>
          <p className="mt-4 text-[1.2rem] font-semibold leading-snug tracking-[-0.015em] text-white">
            {score === HOME_QUIZ.length
              ? "Sans faute. Tu as le niveau, maintenant il faut le garder."
              : score === 0
                ? "C'est exactement pour ça qu'on s'entraîne."
                : "Bon début. Chaque erreur corrigée aujourd'hui est un point gagné le jour J."}
          </p>
          <p className="mt-2 text-[15px] leading-relaxed text-white/65">
            Plus de 60 000 questions comme celles-ci t&apos;attendent dans COP&apos;IQ,
            classées par matière, avec la correction et l&apos;article de loi à chaque fois.
          </p>
          <div className="mt-6 flex flex-col gap-3 sm:flex-row">
            <Link
              href="/signup"
              className="cq-tap cq-btn cq-btn-shine cq-btn-lift inline-flex items-center justify-center rounded-2xl bg-[#E0162B] px-5 py-3 text-[15px] font-semibold text-white hover:bg-[#C8102A]"
            >
              Créer mon compte gratuit
            </Link>
            <button
              type="button"
              onClick={restart}
              className="cq-tap cq-btn inline-flex items-center justify-center gap-2 rounded-2xl border border-white/15 px-5 py-3 text-[15px] font-medium text-white/85 hover:border-white/35 hover:text-white"
            >
              <RotateCcw className="h-4 w-4" aria-hidden="true" />
              Rejouer
            </button>
          </div>
        </div>
      ) : (
        <div key={question.id} className="cq-quiz-in">
          <h2
            id="quiz-question"
            className="mt-6 text-[1.25rem] font-semibold leading-snug tracking-[-0.018em] text-white sm:text-[1.4rem]"
          >
            {question.prompt}
          </h2>

          <div role="group" aria-labelledby="quiz-question" className="cq-stagger mt-5 grid gap-2.5">
            {question.options.map((label, i) => {
              const isAnswer = i === question.answer
              const isPicked = i === choice
              const state = !answered ? "idle" : isAnswer ? "right" : isPicked ? "wrong" : "dim"
              return (
                <button
                  key={label}
                  type="button"
                  onClick={() => pick(i)}
                  disabled={answered}
                  aria-pressed={isPicked}
                  style={{ "--i": i } as CSSProperties}
                  className={cn(
                    "cq-tap cq-btn group flex w-full items-center gap-3.5 rounded-2xl border px-3.5 py-3 text-left text-[15px] leading-snug",
                    state === "idle" &&
                      "border-white/12 bg-white/[0.035] text-white/90 hover:border-white/35 hover:bg-white/[0.06]",
                    state === "right" && "border-[#34D399]/70 bg-[#34D399]/[0.10] text-white",
                    state === "wrong" && "border-[#F87171]/70 bg-[#F87171]/[0.10] text-white",
                    state === "dim" && "border-white/8 text-white/40",
                  )}
                >
                  <span
                    aria-hidden="true"
                    className={cn(
                      "grid h-8 w-8 shrink-0 place-items-center rounded-xl text-[13px] font-semibold",
                      state === "right"
                        ? "bg-[#34D399] text-[#022C1E]"
                        : state === "wrong"
                          ? "bg-[#F87171] text-[#3B0A0A]"
                          : "bg-white/[0.08] text-white/75",
                    )}
                  >
                    {state === "right" ? (
                      <Check className="h-4 w-4" strokeWidth={2.6} />
                    ) : state === "wrong" ? (
                      <X className="h-4 w-4" strokeWidth={2.6} />
                    ) : (
                      LETTERS[i]
                    )}
                  </span>
                  <span>{label}</span>
                </button>
              )
            })}
          </div>

          <div aria-live="polite">
            {answered && (
              <div className="cq-quiz-in mt-5 rounded-2xl bg-white/[0.04] p-4">
                <p className="text-[15px] font-semibold text-white">
                  {choice === question.answer ? "Bonne réponse." : "Pas tout à fait."}
                </p>
                <p className="mt-1.5 text-[14.5px] leading-relaxed text-white/72">
                  {question.explanation}
                </p>
                <p className="mt-3 flex items-center gap-2 text-[13px] font-medium text-[#9CC0FF]">
                  <Scale className="h-3.5 w-3.5 shrink-0" aria-hidden="true" />
                  {question.source}
                </p>
              </div>
            )}
          </div>

          {answered && (
            <button
              type="button"
              onClick={next}
              className="cq-tap cq-btn cq-btn-lift cq-quiz-in mt-4 inline-flex w-full items-center justify-center rounded-2xl bg-white px-5 py-3 text-[15px] font-semibold text-[#000B36] hover:bg-white/90 sm:w-auto"
            >
              {isLast ? "Voir mon résultat" : "Question suivante"}
            </button>
          )}
        </div>
      )}
    </div>
  )
}
