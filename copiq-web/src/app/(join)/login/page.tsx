import type { Metadata } from "next"
import { Suspense } from "react"
import { LoginV5 } from "@/features/auth/login-v5"

/**
 * /login — connexion (version 5, octobre 2026).
 *
 * Sortie du groupe `(auth)` pour partager la mise en page plein écran de
 * /signup, SANS modifier `(auth)/layout.tsx`, qui habille toujours `/confirm`.
 * L'URL reste exactement `/login`. Ancienne version : `features/auth/login-form.tsx`.
 */
export const metadata: Metadata = {
  title: "Connexion",
  description: "Connecte-toi à ton compte COP'IQ : le même compte que dans l'application.",
  robots: { index: false, follow: false },
}

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="min-h-[100svh] bg-[var(--surface)]" />}>
      <LoginV5 />
    </Suspense>
  )
}
