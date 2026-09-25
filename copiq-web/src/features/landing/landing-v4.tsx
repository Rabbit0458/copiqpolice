import { SiteHeader, SiteFooter } from "@/components/marketing/site-chrome"
import { Hero } from "@/components/marketing/hero"
import {
  PathwaysSection,
  CapabilitiesSection,
  CasPratiqueBand,
  PhotolangageSection,
  TestimonialsSection,
  ClosingSection,
  IndependenceNotice,
} from "@/components/marketing/sections"
import { PricingSection } from "@/components/marketing/pricing-section"
import { FaqSection } from "@/components/marketing/faq-section"

/**
 * Vitrine COP'IQ — version 4.
 *
 * Remplace `landing-page.tsx`, qui est **conservé intact** : revenir en
 * arrière consiste à rétablir l'import dans `src/app/page.tsx`.
 *
 * Ce qui a été volontairement écarté (§8) : dégradé violet SaaS, emojis dans
 * les titres, glassmorphism généralisé, grille de flip-cards identiques,
 * badges « BEST SELLER », fade-in sur chaque paragraphe, grain artificiel.
 * Ce qui a été gardé et justifié : la lumière (deux halos, une seule source
 * par section), la profondeur (compositions produit superposées sur desktop),
 * le motif cérébral en très basse opacité (rappel du logo), et un reveal
 * unique au niveau des blocs de section.
 *
 * Mobile d'abord : chaque section est pensée en une colonne, le hero
 * abandonne la superposition, les tableaux deviennent des listes, et toutes
 * les cibles tactiles font au moins 44 px.
 */
export function LandingV4() {
  return (
    <>
      <SiteHeader variant="overlay" />
      <main id="contenu">
        {/* L'en-tête transparent est `sticky`, donc dans le flux : sans cette
            remontée de 4 rem il occuperait une bande de page au-dessus du hero
            et son texte blanc se retrouverait sur fond clair. Le hero est donc
            tiré sous l'en-tête, et son padding haut (6,5 rem / 9,5 rem)
            compense la hauteur de la barre. */}
        <div className="-mt-16">
          <Hero />
        </div>
        <IndependenceNotice tone="night" />
        <PathwaysSection />
        <CapabilitiesSection />
        <CasPratiqueBand />
        <PhotolangageSection />
        <PricingSection />
        <TestimonialsSection />
        <FaqSection />
        <ClosingSection />
      </main>
      <SiteFooter />
    </>
  )
}
