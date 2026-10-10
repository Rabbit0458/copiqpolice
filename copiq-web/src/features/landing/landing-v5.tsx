import { SiteHeader, SiteFooter } from "@/components/marketing/site-chrome"
import { HomeHero } from "@/components/home/home-hero"
import { PathwaysMatrix } from "@/components/home/pathways-matrix"
import { FeaturesShowcase } from "@/components/home/features-showcase"
import { SyncSection, HomePricing, HomeFaq, ClosingQuote } from "@/components/home/home-sections"
import { SmoothScroll, ScrollProgress } from "@/components/home/motion"

/**
 * Accueil COP'IQ — version 5 (octobre 2026).
 *
 * Le moment fort : l'accroche est un vrai quiz, jouable sans compte.
 * Mouvement : entrée orchestrée au chargement, défilement fluide (Lenis,
 * souris et pavé tactile uniquement), titres qui montent mot par mot,
 * blocs qui apparaissent au défilement, liseré tricolore de progression.
 * Tout est coupé si l'utilisateur a demandé à réduire les animations.
 *
 * Retour arrière : dans `src/app/page.tsx`, remplacer `LandingV5` par
 * `LandingV4` (`features/landing/landing-v4.tsx`), conservé intact, comme
 * `landing-page.tsx` avant lui.
 */
export function LandingV5() {
  return (
    <>
      {/* Sans JavaScript, rien n'est caché : les apparitions sont neutralisées. */}
      <noscript>
        <style>{`.cq-appear{opacity:1!important;transform:none!important;filter:none!important}.cq-split[data-mode="view"] .cq-split-word>span{transform:none!important}`}</style>
      </noscript>
      <SmoothScroll />
      <ScrollProgress />
      <SiteHeader variant="overlay" />
      <main id="contenu" className="overflow-x-clip">
        {/* L'en-tête transparent est `sticky`, donc dans le flux : on remonte
            l'accroche de sa hauteur pour qu'elle passe dessous. */}
        <div className="-mt-16">
          <HomeHero />
        </div>
        <PathwaysMatrix />
        <FeaturesShowcase />
        <SyncSection />
        <HomePricing />
        <HomeFaq />
        <ClosingQuote />
      </main>
      <SiteFooter />
    </>
  )
}
