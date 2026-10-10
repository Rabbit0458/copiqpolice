"use client"

import Link from "next/link"
import { useEffect, useMemo, useRef, useState, type FormEvent } from "react"
import { useSearchParams } from "next/navigation"
import { ArrowRight, BarChart3, Eye, EyeOff, LogOut, Mail, RefreshCw, Smartphone, UserRound } from "lucide-react"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { SplitText } from "@/components/home/motion"
import {
  AuthShell,
  EMAIL_RE,
  FieldError,
  Notice,
  PrimaryButton,
  SuccessMark,
  confirmRedirectUrl,
  d,
  inputClass,
  labelClass,
} from "@/features/auth/auth-ui"

/**
 * Connexion COP'IQ — version 5 (octobre 2026).
 *
 * Même compte que l'application : `signInWithPassword` Supabase, puis accès
 * à l'espace. Messages clairs pour chaque cas (identifiants faux, e-mail pas
 * encore confirmé avec renvoi du lien, trop de tentatives) et reprise d'une
 * session déjà ouverte. Ancienne version conservée : `login-form.tsx`.
 *
 * Paramètres acceptés :
 *   ?redirect=/chemin   page à ouvrir après connexion (chemin interne seulement)
 *   ?email=…            pré-remplit l'adresse
 *   ?error=auth_callback_failed   retour d'un lien ouvert sur un autre appareil
 */

/** Seulement un chemin interne : jamais d'URL externe (redirection ouverte). */
function safeRedirect(value: string | null) {
  if (!value || !value.startsWith("/") || value.startsWith("//") || value.includes("\\")) return "/dashboard/"
  return value
}

type Phase = "checking" | "already" | "form" | "success"

export function LoginV5() {
  const params = useSearchParams()
  const supabase = useMemo(() => createClient(), [])
  const target = safeRedirect(params.get("redirect"))
  const callbackFailed = params.get("error") === "auth_callback_failed"

  const [phase, setPhase] = useState<Phase>("checking")
  const [currentEmail, setCurrentEmail] = useState<string | null>(null)
  const [email, setEmail] = useState(params.get("email") ?? "")
  const [password, setPassword] = useState("")
  const [showPwd, setShowPwd] = useState(false)
  const [capsLock, setCapsLock] = useState(false)
  const [tried, setTried] = useState(false)
  const [loading, setLoading] = useState(false)
  const [failure, setFailure] = useState<null | "credentials" | "unconfirmed" | "rate" | "network">(null)
  const [resend, setResend] = useState<"idle" | "sending" | "sent" | "error">("idle")
  const [cooldown, setCooldown] = useState(0)
  const passwordRef = useRef<HTMLInputElement | null>(null)

  const normalizedEmail = email.trim().toLowerCase()
  const errors = {
    email: !normalizedEmail ? "Renseigne ton adresse e-mail." : !EMAIL_RE.test(normalizedEmail) ? "Cette adresse e-mail n’est pas valide." : null,
    password: !password ? "Renseigne ton mot de passe." : null,
  }

  /* Session déjà ouverte dans ce navigateur ? On propose de la reprendre. */
  useEffect(() => {
    let cancelled = false
    supabase.auth
      .getSession()
      .then(({ data }) => {
        if (cancelled) return
        if (data.session) {
          setCurrentEmail(data.session.user.email ?? null)
          setPhase("already")
        } else {
          setPhase("form")
        }
      })
      .catch(() => !cancelled && setPhase("form"))
    return () => {
      cancelled = true
    }
  }, [supabase])

  useEffect(() => {
    if (cooldown <= 0) return
    const t = window.setTimeout(() => setCooldown((c) => c - 1), 1000)
    return () => window.clearTimeout(t)
  }, [cooldown])

  async function onSubmit(e: FormEvent) {
    e.preventDefault()
    setTried(true)
    setFailure(null)
    setResend("idle")
    if (errors.email || errors.password) {
      document.querySelector<HTMLElement>("#connexion [aria-invalid='true']")?.focus()
      return
    }
    setLoading(true)
    try {
      const { data, error } = await supabase.auth.signInWithPassword({ email: normalizedEmail, password })
      if (error || !data.session) {
        const msg = (error?.message ?? "").toLowerCase()
        const code = (error as { code?: string } | null)?.code ?? ""
        if (code === "email_not_confirmed" || msg.includes("not confirmed")) setFailure("unconfirmed")
        else if (error?.status === 429 || msg.includes("rate") || msg.includes("too many")) setFailure("rate")
        else if (code === "invalid_credentials" || msg.includes("invalid login") || msg.includes("invalid")) {
          setFailure("credentials")
          setTried(false)
          setPassword("")
          window.requestAnimationFrame(() => passwordRef.current?.focus())
        } else setFailure("network")
        setLoading(false)
        return
      }
      setPhase("success")
      // Navigation complète : l'espace se charge avec la session toute fraîche.
      window.setTimeout(() => window.location.assign(target), 900)
    } catch {
      setFailure("network")
      setLoading(false)
    }
  }

  async function resendConfirmation() {
    setResend("sending")
    const { error } = await supabase.auth.resend({
      type: "signup",
      email: normalizedEmail,
      options: { emailRedirectTo: confirmRedirectUrl() },
    })
    setResend(error ? "error" : "sent")
    setCooldown(60)
  }

  async function switchAccount() {
    await supabase.auth.signOut().catch(() => undefined)
    setCurrentEmail(null)
    setPhase("form")
  }

  const forgotHref = `/forgot-password/${normalizedEmail && !errors.email ? `?email=${encodeURIComponent(normalizedEmail)}` : ""}`

  return (
    <AuthShell
      title="Content de te revoir."
      text="Reprends exactement là où tu t’étais arrêté : ton compte et ta progression sont les mêmes sur le site et dans l’application."
      points={[
        { title: "Ta progression à jour", text: "Résultats et historique synchronisés entre tes appareils.", icon: <BarChart3 className="h-4 w-4" /> },
        { title: "Ton profil et ton parcours", text: "Concours ou école, Policier adjoint ou Gardien de la paix.", icon: <UserRound className="h-4 w-4" /> },
        { title: "Le même compte que l’app", text: "Un seul e-mail, un seul mot de passe, partout.", icon: <Smartphone className="h-4 w-4" /> },
      ]}
    >
      <div id="connexion" className="min-h-[24rem]">
        {phase === "checking" && (
          <div className="grid min-h-[20rem] place-items-center" aria-busy="true">
            <span className="h-7 w-7 animate-spin rounded-full border-2 border-[#1147D9] border-t-transparent" />
          </div>
        )}

        {/* ── Session déjà ouverte ───────────────────────────────────── */}
        {phase === "already" && (
          <div>
            <div className="cq-stagger">
              <h1 className="text-[clamp(1.75rem,3vw,2.3rem)] font-bold leading-[1.06] tracking-[-0.035em] text-[var(--on-surface)]">Tu es déjà connecté</h1>
              <p className="mt-2.5 text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]">
                {currentEmail ? (
                  <>Session ouverte avec <span className="font-semibold text-[var(--on-surface)]">{currentEmail}</span>.</>
                ) : (
                  "Une session est déjà ouverte dans ce navigateur."
                )}
              </p>
              <div className="mt-8 grid gap-3">
                <a
                  href={target}
                  className="cq-tap cq-btn cq-btn-lift group inline-flex h-[3.4rem] items-center justify-center gap-2 rounded-2xl bg-[#000B36] px-6 text-[16px] font-semibold text-white shadow-[0_14px_36px_-18px_rgba(0,11,54,0.9)] hover:bg-[#0A1A55] dark:bg-[#1147D9] dark:hover:bg-[#1A55F0]"
                >
                  Continuer vers mon espace
                  <ArrowRight className="h-4 w-4 transition-transform duration-300 group-hover:translate-x-0.5" aria-hidden="true" />
                </a>
                <button
                  type="button"
                  onClick={switchAccount}
                  className="cq-tap cq-btn inline-flex h-[3.4rem] items-center justify-center gap-2 rounded-2xl border border-[var(--outline)] px-6 text-[15px] font-semibold text-[var(--on-surface)] hover:border-[var(--on-surface-faint)]"
                >
                  <LogOut className="h-4 w-4" aria-hidden="true" />
                  Utiliser un autre compte
                </button>
              </div>
            </div>
          </div>
        )}

        {/* ── Formulaire ─────────────────────────────────────────────── */}
        {phase === "form" && (
          <div className="cq-step" data-dir="next">
          <form noValidate onSubmit={onSubmit} className="grid gap-6">
            <div style={{ "--i": 0 } as React.CSSProperties}>
              <h1 className="text-[clamp(1.75rem,3vw,2.3rem)] font-bold leading-[1.06] tracking-[-0.035em] text-[var(--on-surface)]">Connexion</h1>
              <p className="mt-2.5 text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]">
                Avec l’e-mail et le mot de passe de ton compte COP’IQ, les mêmes que dans l’application.
              </p>
            </div>

            {callbackFailed && !failure && (
              <Notice tone="info">
                Le lien a été ouvert sur un autre appareil ou navigateur. Pas d’inquiétude : ton adresse est bien confirmée, connecte-toi simplement ici.
              </Notice>
            )}

            {failure === "credentials" && (
              <Notice tone="error">
                E-mail ou mot de passe incorrect.{" "}
                <Link href={forgotHref} className="font-semibold underline underline-offset-2">
                  Mot de passe oublié ?
                </Link>
              </Notice>
            )}
            {failure === "rate" && <Notice tone="error">Trop de tentatives d’affilée. Patiente une minute puis réessaie.</Notice>}
            {failure === "network" && <Notice tone="error">La connexion n’a pas abouti. Vérifie ta connexion internet puis réessaie.</Notice>}
            {failure === "unconfirmed" && (
              <Notice tone="info">
                <span className="block font-semibold">Ton adresse n’est pas encore confirmée.</span>
                <span className="mt-1 block">Clique sur le lien reçu par e-mail à l’inscription (pense aux indésirables), puis reconnecte-toi.</span>
                <button
                  type="button"
                  onClick={resendConfirmation}
                  disabled={cooldown > 0 || resend === "sending"}
                  className="mt-3 inline-flex items-center gap-2 rounded-xl bg-[var(--surface)] px-3.5 py-2 text-[14px] font-semibold text-[var(--on-surface)] shadow-sm ring-1 ring-[var(--outline)] transition-colors hover:ring-[var(--on-surface-faint)] disabled:cursor-not-allowed disabled:opacity-60"
                >
                  <RefreshCw className={cn("h-4 w-4", resend === "sending" && "animate-spin")} aria-hidden="true" />
                  {cooldown > 0 ? `Renvoyer le lien (${cooldown} s)` : "Renvoyer le lien de confirmation"}
                </button>
                {resend === "sent" && <span className="mt-2 block text-[#15803D] dark:text-[#34D399]">Lien renvoyé à {normalizedEmail}.</span>}
                {resend === "error" && <span className="mt-2 block text-[#B91C1C] dark:text-[#F87171]">L’envoi a échoué. Réessaie dans une minute.</span>}
              </Notice>
            )}

            <div style={{ "--i": 1 } as React.CSSProperties}>
              <label htmlFor="email" className={labelClass}>Adresse e-mail</label>
              <div className="relative mt-2">
                <span className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" aria-hidden="true">
                  <Mail className="h-4 w-4" />
                </span>
                <input
                  id="email"
                  type="email"
                  inputMode="email"
                  autoComplete="username"
                  autoCapitalize="none"
                  spellCheck={false}
                  autoFocus={!email}
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="prenom.nom@exemple.fr"
                  aria-invalid={tried && errors.email ? true : undefined}
                  className={cn(inputClass(Boolean(tried && errors.email)), "pl-11")}
                />
              </div>
              <FieldError msg={tried && errors.email} />
            </div>

            <div style={{ "--i": 2 } as React.CSSProperties}>
              <div className="flex items-baseline justify-between gap-3">
                <label htmlFor="password" className={labelClass}>Mot de passe</label>
                <Link href={forgotHref} className="rounded-md text-[14px] font-semibold text-[#1147D9] underline-offset-4 hover:underline dark:text-[#7FB3FF]">
                  Mot de passe oublié ?
                </Link>
              </div>
              <div className="relative mt-2">
                <input
                  ref={passwordRef}
                  id="password"
                  type={showPwd ? "text" : "password"}
                  autoComplete="current-password"
                  autoFocus={Boolean(email)}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  onKeyUp={(e) => setCapsLock(e.getModifierState("CapsLock"))}
                  onBlur={() => setCapsLock(false)}
                  aria-invalid={(tried && errors.password) || failure === "credentials" ? true : undefined}
                  aria-describedby={capsLock ? "maj" : undefined}
                  className={cn(inputClass(Boolean((tried && errors.password) || failure === "credentials")), "pr-12")}
                />
                <button
                  type="button"
                  onClick={() => setShowPwd((v) => !v)}
                  aria-label={showPwd ? "Masquer le mot de passe" : "Afficher le mot de passe"}
                  className="cq-tap absolute right-1 top-1/2 grid -translate-y-1/2 place-items-center rounded-xl text-[var(--on-surface-faint)] transition-colors hover:text-[var(--on-surface)]"
                >
                  {showPwd ? <EyeOff className="h-[18px] w-[18px]" /> : <Eye className="h-[18px] w-[18px]" />}
                </button>
              </div>
              {capsLock && (
                <p id="maj" className="cq-quiz-in mt-2 text-[13.5px] font-medium text-[#B45309] dark:text-[#FBBF24]">
                  Verrouillage majuscules activé.
                </p>
              )}
              <FieldError msg={tried && errors.password} />
            </div>

            <div style={{ "--i": 3 } as React.CSSProperties}>
              <PrimaryButton busy={loading}>
                {loading ? "Connexion…" : "Se connecter"}
                {!loading && <ArrowRight className="h-4 w-4 transition-transform duration-300 group-hover:translate-x-0.5" aria-hidden="true" />}
              </PrimaryButton>
            </div>

            <div className="relative py-1" style={{ "--i": 4 } as React.CSSProperties}>
              <div className="flex items-center gap-4 text-[13.5px] text-[var(--on-surface-faint)]">
                <span className="h-px flex-1 bg-[var(--outline)]" />
                Pas encore de compte ?
                <span className="h-px flex-1 bg-[var(--outline)]" />
              </div>
              <Link
                href="/signup"
                className="cq-tap cq-btn mt-5 inline-flex h-[3.4rem] w-full items-center justify-center gap-2 rounded-2xl border border-[var(--outline)] px-6 text-[15.5px] font-semibold text-[var(--on-surface)] hover:border-[var(--on-surface-faint)]"
              >
                Créer mon compte gratuitement
              </Link>
            </div>
          </form>
          </div>
        )}

        {/* ── Connexion réussie ──────────────────────────────────────── */}
        {phase === "success" && (
          <div role="status" aria-live="polite" className="grid min-h-[20rem] content-center justify-items-center text-center">
            <SuccessMark />
            <SplitText
              as="h1"
              mode="load"
              delay={360}
              text="Connexion réussie"
              className="mt-7 block text-[clamp(1.75rem,3vw,2.3rem)] font-bold leading-[1.06] tracking-[-0.035em] text-[var(--on-surface)]"
            />
            <p className="cq-enter mt-3 text-[15.5px] text-[var(--on-surface-muted)]" style={d(560)}>
              Ouverture de ton espace…
            </p>
          </div>
        )}
      </div>
    </AuthShell>
  )
}
