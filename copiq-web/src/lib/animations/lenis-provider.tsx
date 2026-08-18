"use client"

import { useEffect } from "react"
import Lenis from "lenis"
import { gsap, ScrollTrigger } from "@/lib/animations/gsap"
import { useReducedMotion } from "@/hooks/use-reduced-motion"

/**
 * Smooth scroll for the landing experience only — mount this inside the
 * landing page tree, never in the root layout. The dashboard/admin must
 * keep native, instant scrolling (see COP'IQ redesign brief, point 33).
 */
export function SmoothScrollProvider({ children }: { children: React.ReactNode }) {
  const reducedMotion = useReducedMotion()

  useEffect(() => {
    if (reducedMotion) return

    const lenis = new Lenis({
      duration: 1.1,
      smoothWheel: true,
    })

    lenis.on("scroll", ScrollTrigger.update)

    const tick = (time: number) => lenis.raf(time * 1000)
    gsap.ticker.add(tick)
    gsap.ticker.lagSmoothing(0)

    return () => {
      gsap.ticker.remove(tick)
      lenis.destroy()
    }
  }, [reducedMotion])

  return <>{children}</>
}
