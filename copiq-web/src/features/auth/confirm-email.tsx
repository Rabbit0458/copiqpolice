"use client"

import { useEffect, useRef, useState, Suspense } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import Link from "next/link"
import { createClient } from "@/lib/supabase/client"

// ─── Types ────────────────────────────────────────────────────────────────────

type ConfirmStatus = "loading" | "success" | "error" | "expired" | "no-params"

// ─── Icons ────────────────────────────────────────────────────────────────────

function IconSuccess() {
  return (
    <div className="w-16 h-16 rounded-full flex items-center justify-center mb-6"
      style={{ background: "color-mix(in srgb, #22C55E 12%, transparent)" }}>
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <path d="M7 16.5L13 22.5L25 10" stroke="#22C55E" strokeWidth="2.5"
          strokeLinecap="round" strokeLinejoin="round" />
      </svg>
    </div>
  )
}

function IconError() {
  return (
    <div className="w-16 h-16 rounded-full flex items-center justify-center mb-6"
      style={{ background: "color-mix(in srgb, #EF4444 12%, transparent)" }}>
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <path d="M11 11l10 10M21 11L11 21" stroke="#EF4444" strokeWidth="2.5"
          strokeLinecap="round" />
      </svg>
    </div>
  )
}

function IconExpired() {
  return (
    <div className="w-16 h-16 rounded-full flex items-center justify-center mb-6"
      style={{ background: "color-mix(in srgb, #F59E0B 12%, transparent)" }}>
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <circle cx="16" cy="16" r="10" stroke="#F59E0B" strokeWidth="2" />
        <path d="M16 10v7" stroke="#F59E0B" strokeWidth="2" strokeLinecap="round" />
        <circle cx="16" cy="21.5" r="1.25" fill="#F59E0B" />
      </svg>
    </div>
  )
}

function IconInfo() {
  return (
    <div className="w-16 h-16 rounded-full flex items-center justify-center mb-6"
      style={{ background: "color-mix(in srgb, #1147D9 12%, transparent)" }}>
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
        <circle cx="16" cy="16" r="10" stroke="#1147D9" strokeWidth="2" />
        <path d="M16 15v7" stroke="#1147D9" strokeWidth="2" strokeLinecap="round" />
        <circle cx="16" cy="11" r="1.25" fill="#1147D9" />
      </svg>
    </div>
  )
}

function IconSpinner() {
  return (
    <div className="w-16 h-16 rounded-full flex items-center justify-center mb-6"
      style={{ background: "color-mix(in srgb, #1147D9 10%, transparent)" }}>
      <div className="w-8 h-8 border-2 border-[#1147D9] border-t-transparent rounded-full animate-spin" />
    </div>
  )
}

// ─── Boutons réutilisables ────────────────────────────────────────────────────

function BtnPrimary({ href, children }: { href: string; children: React.ReactNode }) {
  return (
    <Link
      href={href}
      className="w-full h-11 rounded-xl bg-brand text-white text-sm font-semibold
        flex items-center justify-center gap-2
        hover:bg-brand-mid active:scale-[.98] transition-all"
    >
      {children}
    </Link>
  )
}

function BtnSecondary({ href, children }: { href: string; children: React.ReactNode }) {
  return (
    <Link
      href={href}
      className="text-[var(--on-surface-muted)] text-sm text-center
        hover:text-[var(--on-surface)] transition-colors"
    >
      {children}
    </Link>
  )
}

function BtnOutline({ onClick, children }: { onClick: () => void; children: React.ReactNode }) {
  return (
    <button
      onClick={onClick}
      className="w-full h-11 rounded-xl border border-[var(--outline)] text-[var(--on-surface)]
        text-sm font-semibold flex items-center justify-center gap-2
        hover:bg-[var(--surface-container)] active:scale-[.98] transition-all"
    >
      {children}
    </button>
  )
}

// ─── États ───────────────────────────────────────────────────────────────────

function StateLoading() {
  return (
    <div className="flex flex-col items-center text-center py-8">
      <IconSpinner />
      <h1 className="text-[var(--on-surface)] text-2xl font-bold mb-2 tracking-tight">
        Vérification en cours
      </h1>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed">
        Vérification de votre lien de confirmation…
      </p>
      <p className="text-[var(--on-surface-faint)] text-sm mt-1">
        Merci de patienter quelques secondes.
      </p>
    </div>
  )
}

function StateSuccess() {
  return (
    <div className="flex flex-col items-center text-center py-8">
      <IconSuccess />
      <h1 className="text-[var(--on-surface)] text-2xl font-bold mb-2 tracking-tight">
        Email confirmé&nbsp;!
      </h1>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed mb-1">
        Votre adresse email est confirmée.
      </p>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed mb-8">
        Votre compte COP&apos;IQ est maintenant activé.
        Vous pouvez vous connecter à l&apos;application.
      </p>
      <div className="flex flex-col gap-3 w-full">
        <BtnPrimary href="/login">Se connecter</BtnPrimary>
        <BtnOutline onClick={() => { window.location.href = "copiq://" }}>
          {/* Icône téléphone */}
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
            <rect x="4" y="1" width="8" height="14" rx="2" stroke="currentColor" strokeWidth="1.5" />
            <circle cx="8" cy="12" r="1" fill="currentColor" />
          </svg>
          Ouvrir l&apos;application
        </BtnOutline>
        <BtnSecondary href="/">Retour à l&apos;accueil</BtnSecondary>
      </div>
    </div>
  )
}

function StateExpired() {
  return (
    <div className="flex flex-col items-center text-center py-8">
      <IconExpired />
      <h1 className="text-[var(--on-surface)] text-2xl font-bold mb-2 tracking-tight">
        Lien expiré
      </h1>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed mb-1">
        Ce lien de confirmation n&apos;est plus valide.
      </p>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed mb-8">
        Vous pouvez demander l&apos;envoi d&apos;un nouveau lien
        depuis l&apos;écran de connexion.
      </p>
      <div className="flex flex-col gap-3 w-full">
        <BtnPrimary href="/login">Se connecter</BtnPrimary>
        <BtnSecondary href="/">Retour à l&apos;accueil</BtnSecondary>
      </div>
    </div>
  )
}

function StateNoParams() {
  return (
    <div className="flex flex-col items-center text-center py-8">
      <IconInfo />
      <h1 className="text-[var(--on-surface)] text-2xl font-bold mb-2 tracking-tight">
        Lien invalide
      </h1>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed mb-8">
        Aucun paramètre de confirmation trouvé dans l&apos;URL.
        Veuillez cliquer sur le lien reçu par email.
      </p>
      <div className="flex flex-col gap-3 w-full">
        <BtnPrimary href="/login">Se connecter</BtnPrimary>
        <BtnSecondary href="/">Retour à l&apos;accueil</BtnSecondary>
      </div>
    </div>
  )
}

function StateError({ message }: { message: string }) {
  return (
    <div className="flex flex-col items-center text-center py-8">
      <IconError />
      <h1 className="text-[var(--on-surface)] text-2xl font-bold mb-2 tracking-tight">
        Confirmation impossible
      </h1>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed mb-1">
        Impossible de confirmer votre adresse email.
      </p>
      <p className="text-[var(--on-surface-muted)] text-sm leading-relaxed mb-4">
        Le lien est invalide, expiré ou a déjà été utilisé.
      </p>
      {message && (
        <div className="w-full rounded-lg px-4 py-3 mb-6 text-left"
          style={{
            background: "color-mix(in srgb, #EF4444 8%, transparent)",
            border: "1px solid color-mix(in srgb, #EF4444 25%, transparent)",
          }}>
          <p className="text-[#EF4444] text-xs font-mono break-words leading-relaxed">
            {message}
          </p>
        </div>
      )}
      <div className="flex flex-col gap-3 w-full">
        <BtnPrimary href="/login">Retour à la connexion</BtnPrimary>
        <BtnSecondary href="/">Retour à l&apos;accueil</BtnSecondary>
      </div>
    </div>
  )
}

// ─── Handler principal ────────────────────────────────────────────────────────

function ConfirmHandler() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const [status, setStatus] = useState<ConfirmStatus>("loading")
  const [errorMsg, setErrorMsg] = useState<string>("")
  const called = useRef(false)

  useEffect(() => {
    if (called.current) return
    called.current = true

    const token_hash = searchParams.get("token_hash")
    const type = searchParams.get("type")
    const code = searchParams.get("code")
    const error = searchParams.get("error")
    const error_description = searchParams.get("error_description")
    const urlStatus = searchParams.get("status")

    // URL déjà nettoyée après traitement
    if (urlStatus === "success") { setStatus("success"); return }
    if (urlStatus === "error")   { setStatus("error");   return }
    if (urlStatus === "expired") { setStatus("expired"); return }

    // Supabase a renvoyé une erreur dans l'URL
    if (error || error_description) {
      const raw = error_description ?? error ?? "Erreur inconnue"
      const msg = decodeURIComponent(raw)
      if (msg.toLowerCase().includes("expir") || error === "access_denied") {
        setStatus("expired")
        router.replace("/confirm?status=expired")
      } else {
        setErrorMsg(msg)
        setStatus("error")
        router.replace("/confirm?status=error")
      }
      return
    }

    // Aucun paramètre de confirmation
    if (!token_hash && !code) {
      setStatus("no-params")
      return
    }

    // Vérification Supabase
    const supabase = createClient()

    async function verify() {
      try {
        if (token_hash && type) {
          // Flux email OTP (lien Supabase standard)
          const { error } = await supabase.auth.verifyOtp({
            token_hash,
            type: type as "email" | "recovery" | "invite" | "email_change" | "magiclink",
          })
          if (error) {
            const isExpired =
              error.message.toLowerCase().includes("expir") ||
              error.status === 403 ||
              error.status === 401
            if (isExpired) {
              setStatus("expired")
              router.replace("/confirm?status=expired")
            } else {
              setErrorMsg(error.message)
              setStatus("error")
              router.replace("/confirm?status=error")
            }
          } else {
            setStatus("success")
            router.replace("/confirm?status=success")
          }
        } else if (code) {
          // Flux PKCE (Auth Code Flow)
          const { error } = await supabase.auth.exchangeCodeForSession(code)
          if (error) {
            setErrorMsg(error.message)
            setStatus("error")
            router.replace("/confirm?status=error")
          } else {
            setStatus("success")
            router.replace("/confirm?status=success")
          }
        }
      } catch (e: unknown) {
        const msg = e instanceof Error ? e.message : "Erreur inattendue"
        setErrorMsg(msg)
        setStatus("error")
      }
    }

    verify()
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  switch (status) {
    case "loading":   return <StateLoading />
    case "success":   return <StateSuccess />
    case "expired":   return <StateExpired />
    case "no-params": return <StateNoParams />
    case "error":     return <StateError message={errorMsg} />
  }
}

// ─── Export public ────────────────────────────────────────────────────────────

export function ConfirmEmailPage() {
  return (
    <Suspense
      fallback={
        <div className="flex flex-col items-center text-center py-8">
          <div className="w-16 h-16 rounded-full flex items-center justify-center mb-6"
            style={{ background: "color-mix(in srgb, #1147D9 10%, transparent)" }}>
            <div className="w-8 h-8 border-2 border-[#1147D9] border-t-transparent rounded-full animate-spin" />
          </div>
          <p className="text-[var(--on-surface-muted)] text-sm">Chargement…</p>
        </div>
      }
    >
      <ConfirmHandler />
    </Suspense>
  )
}
