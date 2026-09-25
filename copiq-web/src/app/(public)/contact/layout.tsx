import type { Metadata } from "next"

/**
 * `page.tsx` de cette route est un composant client : il ne peut pas exporter
 * `metadata`. Ce layout le fait à sa place, pour que la page ait un `title`
 * unique, une description et une URL canonique au lieu d'hériter du titre par
 * défaut du site.
 */
export const metadata: Metadata = {
  title: "Contact",
  description:
    "Une question sur votre préparation, votre compte ou votre abonnement ? Écrivez à l'équipe COP'IQ.",
  alternates: { canonical: "/contact" },
}

export default function Layout({ children }: { children: React.ReactNode }) {
  return children
}
