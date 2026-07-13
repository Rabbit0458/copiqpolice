import type { Metadata } from "next"
import { ConfirmEmailPage } from "@/features/auth/confirm-email"

export const metadata: Metadata = {
  title: "Confirmation email",
  description: "Confirmation de votre adresse email COP'IQ.",
  robots: { index: false, follow: false },
}

/**
 * Route /confirm
 *
 * Gère les liens de confirmation email envoyés par Supabase Auth.
 *
 * Paramètres URL supportés :
 *   - token_hash + type   → verifyOtp (flux email standard Supabase)
 *   - code                → exchangeCodeForSession (flux PKCE)
 *   - error               → affichage de l'erreur Supabase
 *   - error_description   → message d'erreur détaillé
 *   - next                → redirect après succès (géré côté client)
 *
 * Cette page est PUBLIQUE (hors AUTH_ROUTES et PROTECTED_ROUTES du middleware).
 * Accessible avec ou sans session active.
 *
 * Config Supabase Dashboard à vérifier :
 *   Authentication > URL Configuration
 *   ├── Site URL       : https://copiq.fr
 *   └── Redirect URLs  :
 *       ├── https://copiq.fr/confirm
 *       ├── https://copiq.fr/auth/callback
 *       ├── copiq://confirm
 *       └── copiq://auth/callback
 *
 * Template email Supabase (Confirm signup) :
 *   {{ .SiteURL }}/confirm?token_hash={{ .TokenHash }}&type=email
 */
export default function ConfirmPage() {
  return <ConfirmEmailPage />
}
