import type { Metadata } from "next"

/**
 * `page.tsx` de cette route est un composant client : il ne peut pas exporter
 * `metadata`. Ce layout le fait à sa place, pour que la page ait un `title`
 * unique, une description et une URL canonique au lieu d'hériter du titre par
 * défaut du site.
 */
export const metadata: Metadata = {
  title: "Questions fréquentes",
  description:
    "Les réponses aux questions les plus posées sur COP'IQ : parcours, contenus, abonnement, synchronisation mobile et web.",
  alternates: { canonical: "/faq" },
}

export default function Layout({ children }: { children: React.ReactNode }) {
  return children
}
