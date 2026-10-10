import type { Metadata } from "next"
import { Suspense } from "react"
import { ForgotPasswordV5 } from "@/features/auth/forgot-password-v5"

/**
 * /forgot-password — demande de lien de réinitialisation (version 5).
 *
 * Le lien envoyé mène à https://copiq.fr/reset-password/, la page officielle
 * (hébergée à part, non modifiée) où l'on choisit le nouveau mot de passe,
 * exactement comme depuis l'application.
 * Ancienne version : `features/auth/forgot-password-form.tsx`.
 */
export const metadata: Metadata = {
  title: "Mot de passe oublié",
  description: "Reçois un lien pour choisir un nouveau mot de passe COP'IQ.",
  robots: { index: false, follow: false },
}

export default function ForgotPasswordPage() {
  return (
    <Suspense fallback={<div className="min-h-[100svh] bg-[var(--surface)]" />}>
      <ForgotPasswordV5 />
    </Suspense>
  )
}
