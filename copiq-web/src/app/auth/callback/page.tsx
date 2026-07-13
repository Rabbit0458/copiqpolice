"use client"
import { useEffect, Suspense } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import { createClient } from "@/lib/supabase/client"

function AuthCallbackHandler() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const supabase = createClient()

  useEffect(() => {
    const code = searchParams.get("code")
    const next = searchParams.get("next") ?? "/dashboard"

    if (code) {
      supabase.auth.exchangeCodeForSession(code).then(({ error }) => {
        if (error) {
          router.replace("/login?error=auth_callback_failed")
        } else {
          router.replace(next)
        }
      })
    } else {
      // Check if we have a session from hash fragment (magic link / OAuth implicit)
      supabase.auth.getSession().then(({ data }) => {
        if (data.session) {
          router.replace(next)
        } else {
          router.replace("/login?error=auth_callback_failed")
        }
      })
    }
  }, [])

  return (
    <div className="min-h-screen flex items-center justify-center bg-[var(--background)]">
      <div className="text-center">
        <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#1147D9] mx-auto mb-4" />
        <p className="text-[var(--on-surface-muted)] text-sm">Connexion en cours...</p>
      </div>
    </div>
  )
}

export default function AuthCallbackPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen flex items-center justify-center bg-[var(--background)]">
        <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#1147D9]" />
      </div>
    }>
      <AuthCallbackHandler />
    </Suspense>
  )
}
