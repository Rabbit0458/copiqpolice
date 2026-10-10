"use client"

import { PathwayHome } from "@/features/parcours/pathway-home"

/**
 * /dashboard — Accueil du parcours, comme la Home de l'application :
 * salutation, recherche, deck de cartes glissantes du parcours choisi,
 * puis « Continue ta préparation » / « Ta prochaine étape ».
 * Versions précédentes conservées : features/home/accueil-v5.tsx et
 * features/dashboard/dashboard-content.tsx.
 */
export default function DashboardPage() {
  return <PathwayHome />
}
