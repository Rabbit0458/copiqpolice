import { SmoothScrollProvider } from "@/animations/smooth-scroll-provider"
import { SiteHeader, SiteFooter } from "@/components/marketing/site-chrome"

/**
 * Coque des pages publiques.
 *
 * Ce qui change par rapport à la version précédente :
 *  - le logo n'est plus une approximation CSS (carré dégradé + lettre « C »)
 *    mais le fichier officiel, via `CopiqWordmark` (§61) ;
 *  - la mention d'indépendance institutionnelle apparaît dans le pied de page
 *    de **toutes** les pages publiques (§45) ;
 *  - le pied de page ne renvoie plus vers `/pa/scolarite` et `/gpx/scolarite`,
 *    qui sont des routes authentifiées : un visiteur non connecté y était
 *    renvoyé vers `/login` sans comprendre pourquoi ;
 *  - l'emoji du pied de page a été retiré (§8) ;
 *  - un lien d'évitement et un `<main id="contenu">` sont ajoutés (§49).
 *
 * L'accueil (`src/app/page.tsx`) n'utilise pas cette coque : il compose
 * lui-même `SiteHeader variant="overlay"` pour rester transparent au-dessus
 * du hero bleu nuit.
 */
export default function PublicLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <SmoothScrollProvider>
      <div className="min-h-screen bg-[var(--surface)] text-[var(--on-surface)]">
        <SiteHeader variant="solid" />
        <main id="contenu">{children}</main>
        <SiteFooter />
      </div>
    </SmoothScrollProvider>
  )
}
