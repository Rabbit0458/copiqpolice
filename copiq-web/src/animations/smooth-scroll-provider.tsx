"use client"
import { useEffect } from "react"
import Lenis from "lenis"
import { gsap, ScrollTrigger } from "./gsap"
import { useReducedMotion } from "./use-reduced-motion"

/**
 * Pilote le smooth-scroll (Lenis) et le synchronise avec le ticker GSAP,
 * pour que ScrollTrigger reste précis quelle que soit la scène 3D active.
 * Scopé aux pages marketing (public) — n'affecte jamais le dashboard
 * (scroll interne à sa propre div) ni le panel admin.
 */
export function SmoothScrollProvider({ children }: { children: React.ReactNode }) {
  const reducedMotion = useReducedMotion()

  useEffect(() => {
    if (reducedMotion) return

    const lenis = new Lenis({ duration: 1.2, smoothWheel: true })
    lenis.on("scroll", ScrollTrigger.update)

    function raf(time: number) {
      lenis.raf(time * 1000)
    }
    gsap.ticker.add(raf)
    gsap.ticker.lagSmoothing(0)

    return () => {
      gsap.ticker.remove(raf)
      lenis.destroy()
    }
  }, [reducedMotion])

  return children
}
