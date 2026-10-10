import type { Metadata } from "next"
import { Suspense } from "react"
import { SignupV5 } from "@/features/auth/signup-v5"

/**
 * /signup — page d'inscription (version 5, octobre 2026).
 *
 * Sortie du groupe `(auth)` pour avoir sa propre mise en page plein écran,
 * SANS modifier `(auth)/layout.tsx`, qui habille toujours `/confirm`,
 * `/forgot-password` et `/login`. L'URL reste exactement `/signup`.
 *
 * Paramètres acceptés :
 *   ?parcours=pa-school | pa-exam | gpx-school | gpx-exam (ou pa_school…)
 *   ?plan=month | year  (vient des tarifs de l'accueil)
 *
 * Ancienne version conservée : `features/auth/signup-form.tsx`.
 */
export const metadata: Metadata = {
  title: "Créer un compte",
  description:
    "Crée ton compte COP'IQ gratuitement : concours ou école, Policier adjoint ou Gardien de la paix. Le même compte sur le web et dans l'application.",
  robots: { index: false, follow: false },
}

export default function SignupPage() {
  return (
    <Suspense fallback={<div className="min-h-[100svh] bg-[var(--surface)]" />}>
      <SignupV5 />
    </Suspense>
  )
}
