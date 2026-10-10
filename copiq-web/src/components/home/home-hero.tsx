import Link from "next/link"
import type { CSSProperties } from "react"
import { Smartphone } from "lucide-react"
import { HeroQuiz } from "@/components/home/hero-quiz"
import { Tricolore } from "@/components/home/brand"
import { HeroScrollStage, SplitText } from "@/components/home/motion"
import { LAUNCH } from "@/data/marketing"

/**
 * Accroche de l'accueil : la promesse à gauche, un vrai quiz à droite.
 *
 * Entrée orchestrée au chargement (pur CSS, démarre avant JavaScript) :
 *   0,10 s  le liseré tricolore se trace
 *   0,18 s  le titre monte mot par mot
 *   0,55 s  le quiz arrive, net, depuis un léger flou
 *   0,65 s  le texte, puis les boutons, puis la mention de l'application
 * Au défilement, le texte s'efface et remonte plus vite que le quiz.
 * Sur mobile, le quiz passe sous les boutons, sans rien perdre.
 */

const d = (ms: number) => ({ "--d": `${ms}ms` }) as CSSProperties

export function HomeHero() {
  return (
    <section
      aria-labelledby="titre-accueil"
      className="cq-home-hero relative isolate overflow-hidden text-white"
    >
      <HeroScrollStage className="mx-auto grid max-w-7xl gap-12 px-4 pb-16 pt-28 sm:px-6 sm:pt-32 lg:grid-cols-[minmax(0,1.05fr)_minmax(0,0.95fr)] lg:items-center lg:gap-16 lg:pb-24 lg:pt-36 xl:px-8">
        <div className="cq-par-text max-w-[38rem]">
          <Tricolore className="cq-enter-draw mb-8 h-1 w-16" />
          <SplitText
            as="h1"
            id="titre-accueil"
            mode="load"
            delay={180}
            stagger={55}
            text="Prépare ton concours de police, question après question."
            className="block text-[clamp(2.6rem,6vw,4.75rem)] font-bold leading-[0.98] tracking-[-0.045em] [text-wrap:balance]"
          />
          <p
            className="cq-enter mt-6 max-w-[34rem] text-[clamp(1.05rem,1.4vw,1.2rem)] leading-relaxed text-white/72 [text-wrap:pretty]"
            style={d(650)}
          >
            Gardien de la paix ou Policier adjoint, concours ou école : quiz corrigés,
            cours, cas pratiques et concours blancs. Sur le web et sur mobile, avec un
            seul compte.
          </p>

          <div className="cq-enter mt-9 flex flex-col gap-3 sm:flex-row" style={d(800)}>
            <Link
              href="/signup"
              className="cq-tap cq-btn cq-btn-shine cq-btn-lift inline-flex items-center justify-center rounded-2xl bg-[#E0162B] px-6 py-3.5 text-[16px] font-semibold text-white shadow-[0_14px_40px_-14px_rgba(224,22,43,0.9)] hover:bg-[#C8102A] hover:shadow-[0_20px_50px_-14px_rgba(224,22,43,1)]"
            >
              Créer mon compte gratuit
            </Link>
            <Link
              href="/login"
              className="cq-tap cq-btn cq-btn-lift inline-flex items-center justify-center rounded-2xl border border-white/20 px-6 py-3.5 text-[16px] font-medium text-white/90 hover:border-white/45 hover:text-white"
            >
              Se connecter
            </Link>
          </div>

          <p className="cq-enter mt-6 flex items-center gap-2 text-[14px] text-white/60" style={d(950)}>
            <Smartphone className="h-4 w-4 shrink-0" aria-hidden="true" />
            {LAUNCH.status === "live"
              ? "Disponible sur iOS et Android."
              : "Application iOS et Android bientôt disponible."}
          </p>
        </div>

        <div className="cq-par-panel w-full max-w-[34rem] lg:justify-self-end">
          <p className="cq-enter mb-3 text-[14px] font-medium text-white/70" style={d(720)}>
            Essaie maintenant : trois vraies questions de concours.
          </p>
          <div className="cq-enter-panel" style={d(550)}>
            <HeroQuiz />
          </div>
        </div>
      </HeroScrollStage>
    </section>
  )
}
