"use client"

import { useLayoutEffect, useRef } from "react"

/**
 * Chiffre qui défile jusqu'à sa valeur quand il apparaît à l'écran
 * (« expo out », 1,1 s), puis à chaque changement de valeur.
 * Immobile si l'utilisateur préfère réduire les animations.
 */
export function Counter({
  value,
  suffix = "",
  duration = 1100,
  delay = 0,
}: {
  value: number
  suffix?: string
  duration?: number
  delay?: number
}) {
  const ref = useRef<HTMLSpanElement | null>(null)
  const shown = useRef(0)

  useLayoutEffect(() => {
    const el = ref.current
    if (!el) return
    const fmt = (n: number) => `${Math.round(n).toLocaleString("fr-FR")}${suffix}`
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      shown.current = value
      el.textContent = fmt(value)
      return
    }
    const from = shown.current
    el.textContent = fmt(from)
    let raf = 0
    let timer = 0
    const run = () => {
      let start = 0
      const step = (t: number) => {
        if (!start) start = t
        const p = Math.min(1, (t - start) / duration)
        const v = p === 1 ? value : from + (value - from) * (1 - Math.pow(2, -10 * p))
        shown.current = v
        el.textContent = fmt(v)
        if (p < 1) raf = requestAnimationFrame(step)
      }
      raf = requestAnimationFrame(step)
    }
    const io = new IntersectionObserver(([entry]) => {
      if (!entry.isIntersecting) return
      io.disconnect()
      timer = window.setTimeout(run, delay)
    })
    io.observe(el)
    return () => {
      io.disconnect()
      window.clearTimeout(timer)
      cancelAnimationFrame(raf)
    }
  }, [value, suffix, duration, delay])

  return (
    <span ref={ref} className="tabular-nums" aria-label={`${value.toLocaleString("fr-FR")}${suffix}`}>
      {`${value.toLocaleString("fr-FR")}${suffix}`}
    </span>
  )
}
