"use client"

import { useEffect, useRef, useState, Suspense } from "react"
import { useRouter, useSearchParams } from "next/navigation"

// ─── Types ────────────────────────────────────────────────────────────────────

type Status = "loading" | "success" | "error"

const LOGO_URL =
  "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png"

// ─── Icône animée (cercle + coche / croix qui se dessinent) ──────────────────

function AnimatedIcon({ status }: { status: Status }) {
  const ok = status === "success"
  const color = status === "loading" ? "var(--brand)" : ok ? "#22C55E" : "#EF4444"

  return (
    <div className="copiq-icon-pop" style={{ width: 96, height: 96, position: "relative" }}>
      {status !== "loading" && (
        <div
          className="copiq-glow"
          style={{
            background: `radial-gradient(circle, ${ok ? "rgba(34,197,94,.4)" : "rgba(239,68,68,.4)"}, transparent 70%)`,
          }}
        />
      )}
      <svg width="96" height="96" viewBox="0 0 96 96" fill="none">
        <circle
          cx="48"
          cy="48"
          r="42"
          stroke={color}
          strokeWidth="3"
          strokeLinecap="round"
          className={status === "loading" ? "copiq-circle-spin" : "copiq-circle-draw"}
          style={{ opacity: status === "loading" ? 0.25 : 1 }}
        />
        {status === "loading" && (
          <path
            d="M48 6a42 42 0 0 1 42 42"
            stroke={color}
            strokeWidth="3"
            strokeLinecap="round"
            className="copiq-arc-spin"
          />
        )}
        {ok && (
          <path
            d="M30 49l12 12 24-26"
            stroke={color}
            strokeWidth="4.5"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="copiq-check-draw"
          />
        )}
        {status === "error" && (
          <>
            <path d="M34 34l28 28" stroke={color} strokeWidth="4.5" strokeLinecap="round" className="copiq-cross-draw-1" />
            <path d="M62 34L34 62" stroke={color} strokeWidth="4.5" strokeLinecap="round" className="copiq-cross-draw-2" />
          </>
        )}
      </svg>
    </div>
  )
}

// ─── Styles (animations) ──────────────────────────────────────────────────────

function AnimStyles() {
  return (
    <style>{`
      @keyframes copiq-fade-up {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
      }
      @keyframes copiq-pop {
        0% { opacity: 0; transform: scale(.7); }
        60% { opacity: 1; transform: scale(1.06); }
        100% { opacity: 1; transform: scale(1); }
      }
      @keyframes copiq-draw { to { stroke-dashoffset: 0; } }
      @keyframes copiq-spin { to { transform: rotate(360deg); } }
      @keyframes copiq-glow-pulse {
        0% { opacity: 0; transform: scale(.6); }
        45% { opacity: 1; transform: scale(1.05); }
        100% { opacity: 0; transform: scale(1.7); }
      }
      @keyframes copiq-settle {
        0% { transform: scale(1); }
        50% { transform: scale(1.08); }
        100% { transform: scale(1); }
      }

      .copiq-card { animation: copiq-fade-up .5s cubic-bezier(.16,1,.3,1) both; }
      .copiq-logo { animation: copiq-fade-up .5s cubic-bezier(.16,1,.3,1) both; }
      .copiq-icon-pop {
        animation: copiq-pop .55s cubic-bezier(.16,1,.3,1) both .1s,
                   copiq-settle .4s cubic-bezier(.34,1.56,.64,1) both .85s;
        opacity: 0;
      }
      .copiq-glow {
        position: absolute;
        inset: -24px;
        border-radius: 50%;
        opacity: 0;
        animation: copiq-glow-pulse 1.1s ease-out .5s forwards;
        pointer-events: none;
      }

      .copiq-circle-draw {
        stroke-dasharray: 264;
        stroke-dashoffset: 264;
        animation: copiq-draw .6s ease-out .15s forwards;
      }
      .copiq-check-draw {
        stroke-dasharray: 50;
        stroke-dashoffset: 50;
        animation: copiq-draw .35s ease-out .55s forwards;
      }
      .copiq-cross-draw-1, .copiq-cross-draw-2 {
        stroke-dasharray: 40;
        stroke-dashoffset: 40;
        animation: copiq-draw .3s ease-out forwards;
      }
      .copiq-cross-draw-1 { animation-delay: .5s; }
      .copiq-cross-draw-2 { animation-delay: .68s; }

      .copiq-circle-spin, .copiq-arc-spin {
        transform-origin: 48px 48px;
        animation: copiq-spin 1s linear infinite;
      }
    `}</style>
  )
}

// ─── Boutons ──────────────────────────────────────────────────────────────────

function Btn({ href, onClick, children, variant = "primary" }: {
  href?: string
  onClick?: () => void
  children: React.ReactNode
  variant?: "primary" | "ghost"
}) {
  const cls =
    variant === "primary"
      ? "w-full h-12 rounded-full bg-brand text-white text-[15px] font-semibold flex items-center justify-center hover:bg-brand-mid active:scale-[.98] transition-all"
      : "w-full h-12 rounded-full text-[var(--on-surface-muted)] text-[15px] font-medium flex items-center justify-center hover:text-[var(--on-surface)] transition-colors"

  if (href) {
    return (
      <a href={href} className={cls}>
        {children}
      </a>
    )
  }
  return (
    <button type="button" onClick={onClick} className={cls}>
      {children}
    </button>
  )
}

// ─── Écran unique ─────────────────────────────────────────────────────────────

function Screen({
  status,
  title,
  message,
  detail,
  primary,
}: {
  status: Status
  title: string
  message: string
  detail?: string
  primary?: React.ReactNode
}) {
  return (
    <div
      className="fixed inset-0 z-[999] flex items-center justify-center px-6"
      style={{ background: "var(--surface)" }}
    >
      <AnimStyles />
      <div className="w-full max-w-[340px] flex flex-col items-center text-center">
        <img
          src={LOGO_URL}
          alt="COP'IQ"
          width={64}
          height={64}
          className="copiq-logo w-16 h-16 object-contain mb-10"
        />

        <AnimatedIcon status={status} />

        <h1
          className="copiq-card text-[var(--on-surface)] text-[22px] font-bold tracking-tight mt-7 mb-2"
          style={{ animationDelay: ".2s" }}
        >
          {title}
        </h1>
        <p
          className="copiq-card text-[var(--on-surface-muted)] text-[14px] leading-relaxed mb-1"
          style={{ animationDelay: ".28s" }}
        >
          {message}
        </p>
        {detail && (
          <p
            className="copiq-card text-[var(--on-surface-faint)] text-[12px] leading-relaxed mb-2"
            style={{ animationDelay: ".32s" }}
          >
            {detail}
          </p>
        )}

        {primary && (
          <div className="copiq-card w-full mt-8 flex flex-col gap-2" style={{ animationDelay: ".38s" }}>
            {primary}
          </div>
        )}
      </div>
    </div>
  )
}

// ─── Handler principal ────────────────────────────────────────────────────────

function ConfirmHandler() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const [status, setStatus] = useState<Status>("loading")
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

    const hashParams = new URLSearchParams(window.location.hash.replace(/^#/, ""))
    const accessToken = hashParams.get("access_token")
    const hashError = hashParams.get("error")
    const hashErrorDescription = hashParams.get("error_description")

    // Retour de GoTrue après redirection native (voir plus bas) : succès si un
    // access_token est présent dans le hash, échec si error/error_description.
    const anyError = error || error_description || hashError || hashErrorDescription
    if (anyError) {
      const raw = error_description ?? error ?? hashErrorDescription ?? hashError ?? "Erreur inconnue"
      setErrorMsg(decodeURIComponent(raw))
      setStatus("error")
      router.replace("/confirm")
      return
    }
    if (accessToken || urlStatus === "success") {
      setStatus("success")
      router.replace("/confirm?status=success")
      return
    }

    // Flux PKCE : le lien de l'email pointe vers l'endpoint GoTrue de Supabase,
    // qui confirme l'email CÔTÉ SERVEUR puis redirige ici avec ?code=... AVANT
    // qu'on arrive sur cette page. Ce code sert uniquement à établir une session
    // web (exchangeCodeForSession) — impossible ici puisque l'inscription vient
    // de l'app mobile, pas de ce navigateur (le code_verifier PKCE est stocké
    // côté app). Mais la confirmation d'email a déjà réussi avant cette
    // redirection : sa seule présence (sans erreur) suffit à afficher le succès.
    // Vérifié en base : confirmed_at est posé dès le clic sur le lien, avant
    // même le chargement de cette page.
    if (code) {
      setStatus("success")
      router.replace("/confirm?status=success")
      return
    }

    if (!token_hash || !type) {
      setErrorMsg("Aucun paramètre de confirmation dans le lien.")
      setStatus("error")
      return
    }

    // Redirection native (pas d'appel supabase-js/fetch) vers l'endpoint GoTrue
    // qui vérifie le token côté serveur puis redirige ici avec le résultat.
    // Évite les soucis de CORS/preflight rencontrés avec un appel fetch/SDK
    // direct à /auth/v1/verify (verifyOtp côté client passait par ce même
    // endpoint et échouait de façon intermittente malgré une vérification
    // server-side réussie).
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL ?? "https://nuoonagnkhbeeymtvrcn.supabase.co"
    const redirectTo = window.location.origin + "/confirm"
    window.location.replace(
      `${supabaseUrl}/auth/v1/verify?token_hash=${encodeURIComponent(token_hash)}` +
        `&type=${encodeURIComponent(type)}&redirect_to=${encodeURIComponent(redirectTo)}`,
    )
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  if (status === "loading") {
    return (
      <Screen
        status="loading"
        title="Vérification…"
        message="Un instant, on confirme ton adresse email."
      />
    )
  }

  if (status === "success") {
    return (
      <Screen
        status="success"
        title="Email confirmé"
        message="Ton compte COP'IQ est activé."
        primary={
          <>
            <Btn href="copiq://" variant="primary">Ouvrir l’application</Btn>
            <Btn href="/login" variant="ghost">Se connecter sur le web</Btn>
          </>
        }
      />
    )
  }

  return (
    <Screen
      status="error"
      title="Échec de la confirmation"
      message="Ce lien est invalide, expiré, ou déjà utilisé."
      detail={errorMsg || undefined}
      primary={
        <>
          <Btn href="copiq://" variant="primary">Ouvrir l’application</Btn>
          <Btn href="/login" variant="ghost">Se connecter sur le web</Btn>
        </>
      }
    />
  )
}

// ─── Export public ────────────────────────────────────────────────────────────

export function ConfirmEmailPage() {
  return (
    <Suspense
      fallback={
        <div className="fixed inset-0 z-[999] flex items-center justify-center" style={{ background: "var(--surface)" }}>
          <div className="w-9 h-9 rounded-full border-2 border-brand border-t-transparent animate-spin" />
        </div>
      }
    >
      <ConfirmHandler />
    </Suspense>
  )
}
