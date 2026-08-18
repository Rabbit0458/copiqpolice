"use client"

import dynamic from "next/dynamic"
import Link from "next/link"
import { useEffect, useRef } from "react"
import { ArrowRight, Crown } from "lucide-react"
import { gsap, ScrollTrigger } from "@/lib/animations/gsap"
import { useHeroScroll } from "@/lib/animations/scroll-store"
import { useReducedMotion } from "@/hooks/use-reduced-motion"
import { ExperienceLoader } from "@/components/three/experience-loader"
import { HeroFallback } from "@/components/three/hero-fallback"

const ExperienceCanvas = dynamic(
  () => import("@/components/three/experience-canvas").then((m) => m.ExperienceCanvas),
  { ssr: false, loading: () => <ExperienceLoader /> },
)
const HeroScene = dynamic(() => import("@/components/three/hero-scene").then((m) => m.HeroScene), {
  ssr: false,
})

export function HeroExperience() {
  const sectionRef = useRef<HTMLElement>(null)
  const reducedMotion = useReducedMotion()

  useEffect(() => {
    if (reducedMotion || !sectionRef.current) return

    const ctx = gsap.context(() => {
      ScrollTrigger.create({
        trigger: sectionRef.current,
        start: "top top",
        end: "+=120%",
        pin: true,
        scrub: 1,
        onUpdate: (self) => useHeroScroll.getState().setProgress(self.progress),
      })
    }, sectionRef)

    return () => ctx.revert()
  }, [reducedMotion])

  return (
    <section ref={sectionRef} className="relative min-h-[92vh] overflow-hidden">
      <ExperienceCanvas className="absolute inset-0" fallback={<HeroFallback />}>
        <HeroScene />
      </ExperienceCanvas>

      <div className="pointer-events-none relative z-10 flex min-h-[92vh] max-w-5xl mx-auto flex-col items-center justify-center px-4 py-24 text-center sm:px-6">
        <div className="pointer-events-auto mb-6 inline-flex items-center gap-2 rounded-full border border-white/20 bg-white/10 px-4 py-2 text-sm text-white/90 backdrop-blur-sm">
          <Crown size={13} className="text-amber-400" />
          Application mobile + Site web synchronisés
        </div>

        <h1 className="mb-6 font-black leading-[0.95] text-white" style={{ fontSize: "clamp(2.5rem, 8vw, 6.5rem)" }}>
          Votre concours.
          <br />
          Votre préparation.
          <br />
          <span className="bg-gradient-to-r from-[#4B8FFF] to-[#7FB3FF] bg-clip-text text-transparent">
            Votre réussite.
          </span>
        </h1>

        <p className="mb-10 max-w-2xl text-lg leading-relaxed text-white/75 sm:text-xl">
          Cours juridiques, quiz thématiques, cas pratiques corrigés par IA, psychotechniques et concours blancs.
          La plateforme complète pour Policier Adjoint et Gardien de la Paix.
        </p>

        <div className="pointer-events-auto flex flex-col gap-4 sm:flex-row">
          <Link href="/signup">
            <button className="flex w-full items-center justify-center gap-2.5 rounded-2xl bg-[#1147D9] px-8 py-4 text-base font-bold text-white shadow-xl transition-all hover:-translate-y-0.5 hover:bg-[#1A55E6] hover:shadow-2xl sm:w-auto">
              Commencer <ArrowRight size={18} />
            </button>
          </Link>
          <Link href="#features">
            <button className="w-full rounded-2xl border border-white/25 bg-white/10 px-8 py-4 text-base font-semibold text-white backdrop-blur-sm transition-all hover:bg-white/20 sm:w-auto">
              Découvrir COP&apos;IQ
            </button>
          </Link>
        </div>
      </div>
    </section>
  )
}
