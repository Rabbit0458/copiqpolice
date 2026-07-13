import type { Metadata } from "next"
import { LandingPage } from "@/features/landing/landing-page"

export const metadata: Metadata = {
  title: "COP'IQ — Préparez votre concours Police Nationale",
  description:
    "La plateforme de référence pour réussir le concours Policier Adjoint et Gardien de la Paix. Quiz, cours juridiques, cas pratiques et statistiques de progression.",
}

export default function HomePage() {
  return <LandingPage />
}
