"use client"

import Link from "next/link"
import { useEffect, useMemo, useState, type CSSProperties, type FormEvent } from "react"
import { useSearchParams } from "next/navigation"
import { createClient as createSupabaseClient } from "@supabase/supabase-js"
import { ArrowLeft, Check, KeyRound, Mail, MailCheck, RotateCcw, ShieldCheck } from "lucide-react"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { SplitText } from "@/components/home/motion"
import {
  AuthShell,
  EMAIL_RE,
  FieldError,
  Notice,
  PrimaryButton,
  d,
  inputClass,
  labelClass,
  resetRedirectUrl,
} from "@/features/auth/auth-ui"

/**
 * Mot de passe oublié — version 5 (octobre 2026).
 *
 * Aligné sur l'application (lib/features/auth/reset_password.dart) :
 *  - vérifie d'abord qu'un compte existe (`is_email_available`) ;
 *  - envoie le lien vers https://copiq.fr/reset-password/, la page officielle
 *    de choix du nouveau mot de passe (non modifiée), comme l'app.
 *
 * Correctif : l'ancienne page envoyait vers `undefined/reset-password`
 * (variable d'environnement absente au build), donc Supabase retombait sur
 * l'accueil et le lien ne permettait pas de changer le mot de passe.
 *
 * La demande part en flux « implicit » : le lien fonctionne quel que soit
 * l'appareil qui l'ouvre (téléphone ou ordinateur). En flux PKCE, il ne
 * marcherait que dans le navigateur qui a fait la demande.
 */

type Phase = "form" | "sent"

function recoveryClient() {
  const cfg = (typeof window !== "undefined" ? (window as unknown as { COPIQ_CONFIG?: { SUPABASE_URL?: string; SUPABASE_ANON_KEY?: string } }).COPIQ_CONFIG : undefined) ?? {}
  const url = cfg.SUPABASE_URL && cfg.SUPABASE_URL !== "VOTRE_URL_SUPABASE_ICI" ? cfg.SUPABASE_URL : process.env.NEXT_PUBLIC_SUPABASE_URL ?? "https://placeholder.supabase.co"
  const key = cfg.SUPABASE_URL && cfg.SUPABASE_URL !== "VOTRE_URL_SUPABASE_ICI" ? cfg.SUPABASE_ANON_KEY ?? "" : process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? "placeholder"
  return createSupabaseClient(url, key, {
    auth: { flowType: "implicit", persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
  })
}

export function ForgotPasswordV5() {
  const params = useSearchParams()
  const supabase = useMemo(() => createClient(), [])

  const [phase, setPhase] = useState<Phase>("form")
  const [email, setEmail] = useState(params.get("email") ?? "")
  const [tried, setTried] = useState(false)
  const [loading, setLoading] = useState(false)
  const [failure, setFailure] = useState<null | "unknown" | "rate" | "network">(null)
  const [cooldown, setCooldown] = useState(0)
  const [resent, setResent] = useState<"idle" | "sending" | "sent" | "error">("idle")

  const normalizedEmail = email.trim().toLowerCase()
  const emailError = !normalizedEmail ? "Renseigne ton adresse e-mail." : !EMAIL_RE.test(normalizedEmail) ? "Cette adresse e-mail n’est pas valide." : null

  useEffect(() => {
    if (cooldown <= 0) return
    const t = window.setTimeout(() => setCooldown((c) => c - 1), 1000)
    return () => window.clearTimeout(t)
  }, [cooldown])

  /** Envoie le lien ; renvoie le type d'échec éventuel. */
  async function sendLink(): Promise<null | "rate" | "network"> {
    try {
      const { error } = await recoveryClient().auth.resetPasswordForEmail(normalizedEmail, { redirectTo: resetRedirectUrl() })
      if (!error) return null
      const msg = error.message.toLowerCase()
      return error.status === 429 || msg.includes("rate") || msg.includes("security purposes") || msg.includes("seconds") ? "rate" : "network"
    } catch {
      return "network"
    }
  }

  async function onSubmit(e: FormEvent) {
    e.preventDefault()
    setTried(true)
    setFailure(null)
    if (emailError) {
      document.getElementById("email")?.focus()
      return
    }
    setLoading(true)
    // Même contrôle que l'app : un compte existe-t-il pour cette adresse ?
    const { data: available, error: rpcError } = await supabase.rpc("is_email_available" as never, { p_email: normalizedEmail } as never)
    if (!rpcError && available === true) {
      setFailure("unknown")
      setLoading(false)
      return
    }
    const fail = await sendLink()
    setLoading(false)
    if (fail) {
      setFailure(fail)
      return
    }
    setCooldown(60)
    setPhase("sent")
  }

  async function resend() {
    setResent("sending")
    const fail = await sendLink()
    setResent(fail ? "error" : "sent")
    setCooldown(60)
  }

  const loginHref = `/login/${normalizedEmail && !emailError ? `?email=${encodeURIComponent(normalizedEmail)}` : ""}`

  return (
    <AuthShell
      title="Pas de panique."
      text="Un lien sécurisé dans ta boîte mail, un nouveau mot de passe, et tu reprends ta préparation là où tu l’avais laissée."
      points={[
        { title: "Un lien personnel", text: "Envoyé uniquement à l’adresse de ton compte.", icon: <Mail className="h-4 w-4" /> },
        { title: "Un nouveau mot de passe", text: "Choisi sur une page sécurisée de copiq.fr.", icon: <KeyRound className="h-4 w-4" /> },
        { title: "Rien n’est perdu", text: "Ta progression et ton profil restent intacts, sur le site et dans l’app.", icon: <ShieldCheck className="h-4 w-4" /> },
      ]}
    >
      {phase === "form" ? (
        <div className="cq-step" data-dir="next">
          <form noValidate onSubmit={onSubmit} className="grid gap-6">
            <div style={{ "--i": 0 } as CSSProperties}>
              <Link
                href={loginHref}
                className="mb-7 inline-flex items-center gap-2 rounded-lg text-[14.5px] font-medium text-[var(--on-surface-muted)] transition-colors hover:text-[var(--on-surface)]"
              >
                <ArrowLeft className="h-4 w-4" aria-hidden="true" />
                Retour à la connexion
              </Link>
              <h1 className="text-[clamp(1.75rem,3vw,2.3rem)] font-bold leading-[1.06] tracking-[-0.035em] text-[var(--on-surface)]">Mot de passe oublié</h1>
              <p className="mt-2.5 text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]">
                Indique l’adresse e-mail de ton compte : tu recevras un lien pour choisir un nouveau mot de passe.
              </p>
            </div>

            {failure === "unknown" && (
              <Notice tone="error">
                <span className="block font-semibold">Aucun compte COP’IQ n’est associé à cette adresse.</span>
                <span className="mt-1 block">
                  Vérifie l’orthographe, ou{" "}
                  <Link href="/signup" className="font-semibold underline underline-offset-2">crée ton compte gratuitement</Link>.
                </span>
              </Notice>
            )}
            {failure === "rate" && <Notice tone="error">Un lien vient déjà d’être demandé. Patiente une minute avant de réessayer.</Notice>}
            {failure === "network" && <Notice tone="error">L’envoi n’a pas abouti. Vérifie ta connexion internet puis réessaie.</Notice>}

            <div style={{ "--i": 1 } as CSSProperties}>
              <label htmlFor="email" className={labelClass}>Adresse e-mail</label>
              <div className="relative mt-2">
                <span className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" aria-hidden="true">
                  <Mail className="h-4 w-4" />
                </span>
                <input
                  id="email"
                  type="email"
                  inputMode="email"
                  autoComplete="email"
                  autoCapitalize="none"
                  spellCheck={false}
                  autoFocus
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value)
                    if (failure === "unknown") setFailure(null)
                  }}
                  placeholder="prenom.nom@exemple.fr"
                  aria-invalid={(tried && emailError) || failure === "unknown" ? true : undefined}
                  className={cn(inputClass(Boolean((tried && emailError) || failure === "unknown")), "pl-11")}
                />
              </div>
              <FieldError msg={tried && emailError} />
            </div>

            <div style={{ "--i": 2 } as CSSProperties}>
              <PrimaryButton busy={loading}>{loading ? "Envoi du lien…" : "Recevoir le lien"}</PrimaryButton>
              <p className="mt-5 text-center text-[15px] text-[var(--on-surface-muted)]">
                Tu t’en souviens ?{" "}
                <Link href={loginHref} className="font-semibold text-[#1147D9] underline-offset-4 hover:underline dark:text-[#7FB3FF]">
                  Se connecter
                </Link>
              </p>
            </div>
          </form>
        </div>
      ) : (
        <div role="status" aria-live="polite">
          <div className="cq-enter-panel relative mb-8 grid h-16 w-16 place-items-center rounded-2xl bg-[#000B36] text-white shadow-[0_20px_50px_-20px_rgba(17,71,217,0.9)]">
            <MailCheck className="h-7 w-7" aria-hidden="true" />
            <span className="absolute -right-1.5 -top-1.5 grid h-6 w-6 place-items-center rounded-full bg-[#16A34A] ring-4 ring-[var(--surface)]">
              <Check className="h-3.5 w-3.5" strokeWidth={3} aria-hidden="true" />
            </span>
          </div>
          <SplitText
            as="h1"
            mode="load"
            delay={120}
            text="Lien envoyé !"
            className="block text-[clamp(1.9rem,3.2vw,2.5rem)] font-bold leading-[1.05] tracking-[-0.035em] text-[var(--on-surface)]"
          />
          <p className="cq-enter mt-3 text-[16px] leading-relaxed text-[var(--on-surface-muted)]" style={d(300)}>
            Un lien pour choisir ton nouveau mot de passe vient d’être envoyé à{" "}
            <span className="font-semibold text-[var(--on-surface)]">{normalizedEmail}</span>.
          </p>

          <ol className="mt-8 grid gap-4">
            {[
              "Ouvre l’e-mail envoyé par COP’IQ (pense à regarder dans les indésirables).",
              "Clique sur le lien, depuis ton téléphone ou ton ordinateur.",
              "Choisis ton nouveau mot de passe, puis connecte-toi sur le site ou dans l’application.",
            ].map((s, idx) => (
              <li key={s} className="cq-enter flex gap-4" style={d(420 + idx * 90)}>
                <span className="grid h-8 w-8 shrink-0 place-items-center rounded-full border border-[var(--outline)] text-[14px] font-semibold text-[var(--on-surface)]">
                  {idx + 1}
                </span>
                <span className="pt-1 text-[15px] leading-relaxed text-[var(--on-surface)]">{s}</span>
              </li>
            ))}
          </ol>

          <div className="cq-enter mt-10 grid gap-3 sm:grid-cols-2" style={d(720)}>
            <button
              type="button"
              onClick={resend}
              disabled={cooldown > 0 || resent === "sending"}
              className="cq-tap cq-btn inline-flex items-center justify-center gap-2 rounded-2xl border border-[var(--outline)] px-5 py-3 text-[15px] font-semibold text-[var(--on-surface)] hover:border-[var(--on-surface-faint)] disabled:cursor-not-allowed disabled:opacity-55"
            >
              <RotateCcw className="h-4 w-4" aria-hidden="true" />
              {cooldown > 0 ? `Renvoyer (${cooldown} s)` : "Renvoyer le lien"}
            </button>
            <Link
              href={loginHref}
              className="cq-tap cq-btn inline-flex items-center justify-center gap-2 rounded-2xl px-5 py-3 text-[15px] font-semibold text-[#1147D9] hover:bg-[var(--surface-container)] dark:text-[#7FB3FF]"
            >
              <ArrowLeft className="h-4 w-4" aria-hidden="true" />
              Retour à la connexion
            </Link>
          </div>
          <p aria-live="polite" className="mt-3 min-h-[1.25rem] text-center text-[13.5px]">
            {resent === "sent" && <span className="text-[#16A34A] dark:text-[#34D399]">Nouveau lien envoyé.</span>}
            {resent === "error" && <span className="text-[#DC2626] dark:text-[#F87171]">L’envoi a échoué. Réessaie dans une minute.</span>}
          </p>
          <button
            type="button"
            onClick={() => {
              setPhase("form")
              setTried(false)
              setResent("idle")
            }}
            className="mx-auto mt-2 block rounded-lg text-[14px] font-medium text-[var(--on-surface-muted)] underline-offset-4 hover:text-[var(--on-surface)] hover:underline"
          >
            Ce n’est pas la bonne adresse ?
          </button>
        </div>
      )}
    </AuthShell>
  )
}
