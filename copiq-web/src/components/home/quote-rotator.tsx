"use client"

import { useEffect, useRef, useState } from "react"
import { cn } from "@/lib/utils"
import { MOTIVATION_QUOTES } from "@/data/home"
import { SplitText } from "@/components/home/motion"

/**
 * Phrases de motivation COP'IQ : une à la fois, en grand.
 * Chaque nouvelle phrase monte mot par mot ; la précédente s'efface en
 * glissant vers le haut. Changement toutes les 9 secondes, en pause au
 * survol ou au clavier, immobile si l'utilisateur réduit les animations.
 */
const INTERVAL_MS = 9000
const QUOTE_CLASS =
  "block text-[clamp(1.75rem,4.2vw,3.4rem)] font-semibold leading-[1.12] tracking-[-0.03em] text-white [text-wrap:balance]"

const clean = (q: string) => q.replace(/^«\s*|\s*»$/g, "")

function Marks({ side }: { side: "open" | "close" }) {
  return (
    <span aria-hidden="true" className="text-[#E0162B]">
      {side === "open" ? "« " : " »"}
    </span>
  )
}

export function QuoteRotator() {
  const [index, setIndex] = useState(0)
  const [leaving, setLeaving] = useState<number | null>(null)
  const [paused, setPaused] = useState(false)
  const timer = useRef<number | null>(null)
  const indexRef = useRef(0)

  function go(next: number) {
    const current = indexRef.current
    if (next === current) return
    indexRef.current = next
    setLeaving(current)
    setIndex(next)
    if (timer.current) window.clearTimeout(timer.current)
    timer.current = window.setTimeout(() => setLeaving(null), 700)
  }

  useEffect(() => {
    if (paused || MOTIVATION_QUOTES.length < 2) return
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return
    const id = window.setInterval(
      () => go((indexRef.current + 1) % MOTIVATION_QUOTES.length),
      INTERVAL_MS,
    )
    return () => window.clearInterval(id)
  }, [paused, index])

  useEffect(() => () => {
    if (timer.current) window.clearTimeout(timer.current)
  }, [])

  // La phrase la plus longue réserve la hauteur : rien ne saute au changement.
  const longest = MOTIVATION_QUOTES.reduce((a, b) => (b.length > a.length ? b : a), "")

  return (
    <figure
      onMouseEnter={() => setPaused(true)}
      onMouseLeave={() => setPaused(false)}
      onFocus={() => setPaused(true)}
      onBlur={() => setPaused(false)}
    >
      <div className="relative">
        <span aria-hidden="true" className={cn(QUOTE_CLASS, "invisible")}>
          « {clean(longest)} »
        </span>
        {leaving !== null && (
          <span aria-hidden="true" className={cn(QUOTE_CLASS, "cq-quote-out absolute inset-x-0 top-0")}>
            <Marks side="open" />
            {clean(MOTIVATION_QUOTES[leaving])}
            <Marks side="close" />
          </span>
        )}
        <div className="absolute inset-x-0 top-0">
          <SplitText
            key={index}
            as="blockquote"
            delay={leaving !== null ? 260 : 0}
            stagger={38}
            text={clean(MOTIVATION_QUOTES[index])}
            before={<Marks side="open" />}
            after={<Marks side="close" />}
            className={QUOTE_CLASS}
          />
        </div>
      </div>

      {MOTIVATION_QUOTES.length > 1 && (
        <div className="mt-8 flex items-center gap-1" role="group" aria-label="Choisir une phrase">
          {MOTIVATION_QUOTES.map((q, i) => (
            <button
              key={q}
              type="button"
              onClick={() => go(i)}
              aria-label={`Phrase ${i + 1} sur ${MOTIVATION_QUOTES.length}`}
              aria-current={i === index}
              className="cq-tap grid place-items-center"
            >
              <span
                className={cn(
                  "block h-1.5 rounded-full transition-all duration-700 ease-[cubic-bezier(0.22,1,0.36,1)]",
                  i === index ? "w-8 bg-white" : "w-3 bg-white/30 hover:bg-white/60",
                )}
              />
            </button>
          ))}
        </div>
      )}
    </figure>
  )
}
