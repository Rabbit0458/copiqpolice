import type { Metadata } from "next"

/**
 * `page.tsx` de cette route est un composant client : il ne peut pas exporter
 * `metadata`. Ce layout le fait à sa place, pour que la page ait un `title`
 * unique, une description et une URL canonique au lieu d'hériter du titre par
 * défaut du site.
 */
export const metadata: Metadata = {
  title: "Notes de mise à jour",
  description:
    "Les nouveautés et corrections apportées à COP'IQ, version par version.",
  alternates: { canonical: "/notes-de-mise-a-jour" },
}

export default function Layout({ children }: { children: React.ReactNode }) {
  return children
}
