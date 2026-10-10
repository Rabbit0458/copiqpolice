"use client"

import { useEffect } from "react"
import { useRouter } from "next/navigation"

/**
 * Anciennes pages du site (contenus de démonstration) : elles restent dans le
 * code mais renvoient vers l'accueil du parcours, où tout le contenu réel de
 * l'application est désormais disponible.
 */
export function LegacyRedirect({ to = "/dashboard" }: { to?: string }) {
  const router = useRouter()
  useEffect(() => {
    router.replace(to)
  }, [router, to])
  return (
    <div className="flex h-64 items-center justify-center" aria-busy="true">
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img src="/brand/copiq-logo.png" alt="Redirection vers ton accueil" width={56} height={56} className="cq-logo-breathe h-14 w-14 object-contain" />
    </div>
  )
}
