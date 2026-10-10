"use client"

/**
 * COP'IQ — Portail d'accès au panel administrateur.
 *
 * Trois barrières successives :
 *   1. Mot de passe Supabase (compte devant exister dans `admin_users`)
 *   2. Code TOTP à 6 chiffres — Google Authenticator (enrôlement guidé si absent)
 *   3. Code staff personnel (PIN), vérifié contre un hash bcrypt en base
 *
 * Les barrières 1 et 2 sont ré-imposées côté PostgreSQL par `cp_admin_guard()`
 * (contrôle du niveau AAL2). Ce composant n'est qu'une couche d'ergonomie :
 * le contourner ne donne accès à aucune donnée.
 */

import { useCallback, useEffect, useRef, useState } from "react"
import { Check, Eye, EyeOff, KeyRound, LockKeyhole, ShieldCheck } from "lucide-react"
import { adminAuth, type AdminSession } from "@/lib/admin/api"
import { COPIQ_LOGO_PNG } from "@/components/home/brand"

type Step =
  | "loading"
  | "signin"
  | "totp-enroll"
  | "totp-verify"
  | "staff-code"
  | "ready"
  | "denied"

const SESSION_KEY = "copiq_admin_code_ok"

const GATE_PRIMARY =
  "inline-flex h-[3.4rem] w-full items-center justify-center gap-2 rounded-2xl bg-[#000B36] px-6 text-[16px] font-semibold text-white shadow-[0_14px_36px_-18px_rgba(0,11,54,0.9)] transition-[transform,background-color] duration-300 hover:-translate-y-0.5 hover:bg-[#0A1A55] active:translate-y-0 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 dark:bg-[#1147D9] dark:hover:bg-[#1A55F0]"
const GATE_GHOST =
  "inline-flex h-12 w-full items-center justify-center rounded-2xl border border-[var(--outline)] px-6 text-[15px] font-semibold text-[var(--on-surface-muted)] transition-colors hover:border-[var(--on-surface-faint)] hover:text-[var(--on-surface)]"

export function AdminGate({ children }: { children: (s: AdminSession) => React.ReactNode }) {
  const [step, setStep] = useState<Step>("loading")
  const [session, setSession] = useState<AdminSession | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [code, setCode] = useState("")
  const [staffCode, setStaffCode] = useState("")
  const [enroll, setEnroll] = useState<{ id: string; qr: string; secret: string } | null>(null)
  const factorIdRef = useRef<string | null>(null)

  /* ── Détermination de l'étape courante ─────────────────────────────────── */
  const refresh = useCallback(async () => {
    setError(null)
    try {
      const s = await adminAuth.status()
      setSession(s)

      if (!s.ok) {
        if (s.reason === "no_session") return setStep("signin")
        return setStep("denied")
      }

      const factors = await adminAuth.listFactors()
      const totp = factors?.totp?.find((f) => f.status === "verified")

      if (!totp) {
        // L'API ne renvoie ici que les facteurs vérifiés : un facteur absent
        // doit donc passer par l'écran d'enrôlement guidé.
        setStep("totp-enroll")
        return
      }

      factorIdRef.current = totp.id
      if (s.aal !== "aal2") return setStep("totp-verify")

      if (s.code_required && sessionStorage.getItem(SESSION_KEY) !== "1") {
        return setStep("staff-code")
      }
      setStep("ready")
    } catch (e) {
      setError(e instanceof Error ? e.message : "Erreur inattendue")
      setStep("signin")
    }
  }, [])

  useEffect(() => {
    // Le contrôle de session est précisément l'effet d'initialisation de cette porte.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    void refresh()
  }, [refresh])

  /* ── Actions ───────────────────────────────────────────────────────────── */

  async function handleSignIn(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setError(null)
    try {
      await adminAuth.signIn(email.trim(), password)
      sessionStorage.removeItem(SESSION_KEY)
      await refresh()
    } catch (err) {
      setError(err instanceof Error ? err.message : "Connexion impossible")
    } finally {
      setBusy(false)
    }
  }

  async function startEnroll() {
    setBusy(true)
    setError(null)
    try {
      const d = await adminAuth.enrollTotp()
      factorIdRef.current = d.id
      setEnroll({ id: d.id, qr: d.totp.qr_code, secret: d.totp.secret })
    } catch (err) {
      setError(err instanceof Error ? err.message : "Enrôlement impossible")
    } finally {
      setBusy(false)
    }
  }

  async function handleVerifyTotp(e: React.FormEvent) {
    e.preventDefault()
    if (!factorIdRef.current) return
    setBusy(true)
    setError(null)
    try {
      await adminAuth.verifyTotp(factorIdRef.current, code.trim())
      setCode("")
      setEnroll(null)
      await refresh()
    } catch (err) {
      setError(err instanceof Error ? err.message : "Code invalide")
    } finally {
      setBusy(false)
    }
  }

  async function handleStaffCode(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setError(null)
    try {
      const r = await adminAuth.verifyPanelCode(staffCode.trim())
      if (!r.ok) throw new Error(r.message)
      sessionStorage.setItem(SESSION_KEY, "1")
      setStaffCode("")
      await refresh()
    } catch (err) {
      setError(err instanceof Error ? err.message : "Code refusé")
    } finally {
      setBusy(false)
    }
  }

  async function handleSignOut() {
    sessionStorage.removeItem(SESSION_KEY)
    await adminAuth.signOut()
    setSession(null)
    setStep("signin")
  }

  /* ── Rendu ─────────────────────────────────────────────────────────────── */

  if (step === "ready" && session) return <>{children(session)}</>

  if (step === "loading") {
    return (
      <Shell>
        <div className="flex items-center gap-3 text-sm text-[var(--on-surface-muted)]">
          <span className="h-4 w-4 animate-spin rounded-full border-2 border-[var(--brand)] border-t-transparent" />
          Vérification de la session…
        </div>
      </Shell>
    )
  }

  if (step === "denied") {
    const reasons: Record<string, string> = {
      not_admin: "Ce compte n'est pas rattaché à un administrateur COP'IQ.",
      disabled: "Ce compte administrateur a été désactivé.",
      locked: `Compte verrouillé${session?.until ? ` jusqu'au ${new Date(session.until).toLocaleString("fr-FR")}` : ""}.`,
      expired: "Ce compte administrateur temporaire a expiré.",
    }
    return (
      <Shell title="Accès refusé">
        <p className="text-sm text-[var(--danger)]">
          {reasons[session?.reason ?? ""] ?? "Accès refusé."}
        </p>
        <button onClick={handleSignOut} className={`${GATE_GHOST} mt-6`}>
          Se déconnecter
        </button>
      </Shell>
    )
  }

  if (step === "signin") {
    return (
      <Shell title="Bienvenue dans votre espace sécurisé" subtitle="Identifiez-vous pour accéder au centre de pilotage." currentStep={1}>
        <form onSubmit={handleSignIn} className="space-y-4">
          <Field
            label="Adresse e-mail"
            type="email"
            value={email}
            onChange={setEmail}
            autoComplete="username"
            required
          />
          <Field
            label="Mot de passe"
            type="password"
            value={password}
            onChange={setPassword}
            autoComplete="current-password"
            required
          />
          <ErrorMsg error={error} />
          <button type="submit" disabled={busy} className={GATE_PRIMARY}>
            {busy ? "Connexion…" : "Continuer"}
          </button>
        </form>
      </Shell>
    )
  }

  if (step === "totp-enroll") {
    return (
      <Shell
        title="Activer la double authentification"
        subtitle="Sécurisez votre accès avec votre application d’authentification."
        currentStep={2}
      >
        {!enroll ? (
          <>
            <p className="mb-5 text-sm leading-relaxed text-[var(--on-surface-muted)]">
              L&apos;accès au panel exige un second facteur. Installe{" "}
              <strong>Google Authenticator</strong> (ou Authy, 1Password…) sur ton
              téléphone, puis lance l&apos;enrôlement : un QR code s&apos;affichera.
            </p>
            <ErrorMsg error={error} />
            <button onClick={startEnroll} disabled={busy} className={GATE_PRIMARY}>
              {busy ? "Génération…" : "Générer mon QR code"}
            </button>
          </>
        ) : (
          <>
            <p className="mb-4 text-sm text-[var(--on-surface-muted)]">
              Scanne ce QR code dans ton application, puis saisis le code à 6 chiffres.
            </p>
            <div className="mb-5 flex justify-center rounded-3xl border border-[var(--outline)] bg-white p-5 shadow-[0_18px_40px_-28px_rgba(0,11,54,.5)]">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={enroll.qr} alt="QR code de configuration TOTP" className="h-44 w-44" />
            </div>
            <details className="mb-4">
              <summary className="cursor-pointer text-[13.5px] font-medium text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]">
                Impossible de scanner ? Saisie manuelle
              </summary>
              <code className="mt-2 block break-all rounded-xl bg-[var(--surface-container)] p-3 font-mono text-[13px] text-[var(--on-surface)]">
                {enroll.secret}
              </code>
            </details>
            <form onSubmit={handleVerifyTotp} className="space-y-4">
              <OtpField value={code} onChange={setCode} />
              <ErrorMsg error={error} />
              <button
                type="submit"
                disabled={busy || code.length < 6}
                className={GATE_PRIMARY}
              >
                {busy ? "Vérification…" : "Activer la 2FA"}
              </button>
            </form>
          </>
        )}
        <button onClick={handleSignOut} className={`${GATE_GHOST} mt-3`}>
          Annuler
        </button>
      </Shell>
    )
  }

  if (step === "totp-verify") {
    return (
      <Shell title="Double authentification" subtitle="Saisissez le code temporaire à 6 chiffres." currentStep={2}>
        <p className="mb-4 text-sm text-[var(--on-surface-muted)]">
          Saisis le code affiché dans Google Authenticator.
        </p>
        <form onSubmit={handleVerifyTotp} className="space-y-4">
          <OtpField value={code} onChange={setCode} autoFocus />
          <ErrorMsg error={error} />
          <button
            type="submit"
            disabled={busy || code.length < 6}
            className={GATE_PRIMARY}
          >
            {busy ? "Vérification…" : "Valider"}
          </button>
        </form>
        <button onClick={handleSignOut} className={`${GATE_GHOST} mt-3`}>
          Se déconnecter
        </button>
      </Shell>
    )
  }

  // staff-code
  return (
    <Shell title="Dernière vérification" subtitle="Confirmez votre code staff personnel." currentStep={3}>
      <p className="mb-4 text-sm text-[var(--on-surface-muted)]">
        Dernière vérification : saisis ton code staff personnel.
      </p>
      <form onSubmit={handleStaffCode} className="space-y-4">
        <Field
          label="Code staff"
          type="password"
          value={staffCode}
          onChange={setStaffCode}
          autoComplete="one-time-code"
          required
        />
        <ErrorMsg error={error} />
        <button type="submit" disabled={busy} className={GATE_PRIMARY}>
          {busy ? "Vérification…" : "Accéder au panel"}
        </button>
      </form>
      <button onClick={handleSignOut} className={`${GATE_GHOST} mt-3`}>
        Se déconnecter
      </button>
    </Shell>
  )
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Sous-composants (design V5 — logique inchangée)                           */
/* ────────────────────────────────────────────────────────────────────────── */

const BARRIERS = [
  { label: "Compte", detail: "E-mail et mot de passe administrateur", icon: KeyRound },
  { label: "Authenticator", detail: "Code à 6 chiffres, renouvelé toutes les 30 s", icon: ShieldCheck },
  { label: "Code staff", detail: "Code personnel, vérifié en base", icon: LockKeyhole },
]

function Shell({
  title,
  subtitle,
  currentStep,
  children,
}: {
  title?: string
  subtitle?: string
  currentStep?: 1 | 2 | 3
  children: React.ReactNode
}) {
  return (
    <div className="admin-gate flex min-h-[100svh] flex-col bg-[var(--surface)] lg:flex-row">
      {/* Colonne de marque */}
      <aside className="cq-home-hero relative isolate overflow-hidden text-white lg:sticky lg:top-0 lg:flex lg:h-[100svh] lg:w-[44%] lg:max-w-[38rem] lg:flex-col">
        <div className="flex items-center gap-3 px-5 pb-5 pt-6 sm:px-8 lg:px-12 lg:pt-10">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={COPIQ_LOGO_PNG} alt="COP'IQ" width={56} height={56} className="cq-enter-header h-14 w-14 scale-[1.3] object-contain" />
        </div>

        <div className="hidden px-12 lg:flex lg:flex-1 lg:flex-col lg:justify-center">
          <span className="cq-tricolore cq-enter-draw mb-8 block h-1 w-14 rounded-full" aria-hidden="true" />
          <h2 className="cq-enter max-w-[26rem] text-[clamp(2rem,3vw,2.75rem)] font-bold leading-[1.05] tracking-[-0.04em] [text-wrap:balance]">
            L&apos;espace d&apos;administration COP&apos;IQ.
          </h2>
          <p className="cq-enter mt-4 max-w-[26rem] text-[16px] leading-relaxed text-white/65" style={{ animationDelay: "120ms" }}>
            Contenus, communauté, abonnements et statistiques. Accès protégé par trois vérifications successives.
          </p>
          <ol className="mt-10 grid max-w-[26rem] gap-3">
            {BARRIERS.map(({ label, detail, icon: Icon }, index) => {
              const n = index + 1
              const done = currentStep ? n < currentStep : false
              const active = n === currentStep
              return (
                <li
                  key={label}
                  style={{ animationDelay: `${300 + index * 90}ms` }}
                  className={`admin-gate-step flex items-center gap-3.5 rounded-2xl border px-4 py-3 transition-colors duration-500 ${
                    active ? "border-white/15 bg-white/[0.08]" : "border-transparent"
                  }`}
                >
                  <span
                    className={`grid h-9 w-9 shrink-0 place-items-center rounded-xl transition-colors duration-500 ${
                      done ? "bg-[#16A34A] text-white" : active ? "admin-gate-pulse bg-[#1147D9] text-white" : "bg-white/[0.07] text-white/45"
                    }`}
                    aria-hidden="true"
                  >
                    {done ? <Check size={17} strokeWidth={3} /> : <Icon size={17} />}
                  </span>
                  <span className="min-w-0">
                    <span className={`block text-[15px] font-semibold ${active || done ? "text-white" : "text-white/55"}`}>{label}</span>
                    <span className="block text-[13px] text-white/50">{detail}</span>
                  </span>
                </li>
              )
            })}
          </ol>
        </div>

        <p className="hidden px-12 pb-10 text-[12.5px] text-white/40 lg:block">Accès strictement réservé au personnel autorisé COP&apos;IQ.</p>
      </aside>

      {/* Formulaire */}
      <main className="flex flex-1 items-start justify-center px-4 py-10 sm:px-8 lg:items-center">
        <div key={title ?? "chargement"} className="admin-gate-card w-full max-w-[27rem]">
          {currentStep && (
            <nav aria-label="Progression de la connexion" className="mb-8">
              <p className="text-[12.5px] font-semibold uppercase tracking-[0.14em] text-[var(--on-surface-faint)]">
                Étape {currentStep} sur 3
              </p>
              <ol className="mt-3 grid grid-cols-3 gap-2">
                {BARRIERS.map(({ label }, index) => {
                  const n = index + 1
                  const state = n < currentStep ? "done" : n === currentStep ? "current" : "todo"
                  return (
                    <li key={label} aria-current={state === "current" ? "step" : undefined}>
                      <span className="relative block h-1 overflow-hidden rounded-full bg-[var(--outline)]">
                        <span
                          className="absolute inset-0 origin-left rounded-full transition-transform duration-700 ease-[cubic-bezier(0.22,1,0.36,1)]"
                          style={{ transform: `scaleX(${state === "todo" ? 0 : 1})`, background: state === "done" ? "#16A34A" : "#1147D9" }}
                        />
                      </span>
                      <span className={`mt-2 flex items-center gap-1 truncate text-[12.5px] font-medium ${state === "current" ? "text-[var(--on-surface)]" : state === "done" ? "text-[var(--on-surface-muted)]" : "text-[var(--on-surface-faint)]"}`}>
                        {state === "done" && <Check size={12} strokeWidth={3} className="text-[#16A34A]" aria-hidden="true" />}
                        {label}
                      </span>
                    </li>
                  )
                })}
              </ol>
            </nav>
          )}
          {title && <h1 className="text-[clamp(1.6rem,2.6vw,2.1rem)] font-bold leading-[1.08] tracking-[-0.035em] text-[var(--on-surface)]">{title}</h1>}
          {subtitle && <p className="mb-7 mt-2.5 text-[15px] leading-relaxed text-[var(--on-surface-muted)]">{subtitle}</p>}
          {children}
          <p className="mt-10 text-center text-[12px] leading-5 text-[var(--on-surface-faint)] lg:hidden">Accès strictement réservé au personnel autorisé COP&apos;IQ.</p>
        </div>
      </main>
    </div>
  )
}

function Field({
  label,
  value,
  onChange,
  ...rest
}: {
  label: string
  value: string
  onChange: (v: string) => void
} & Omit<React.InputHTMLAttributes<HTMLInputElement>, "onChange" | "value">) {
  const [visible, setVisible] = useState(false)
  const isPassword = rest.type === "password"
  return (
    <label className="block text-left">
      <span className="mb-2 block text-[15px] font-semibold text-[var(--on-surface)]">{label}</span>
      <span className="relative block">
        <input
          {...rest}
          type={isPassword && visible ? "text" : rest.type}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="block h-[3.25rem] w-full rounded-2xl border border-[var(--outline)] bg-[var(--surface)] px-4 pr-12 text-[16px] text-[var(--on-surface)] outline-none transition-[border-color,box-shadow] duration-300 placeholder:text-[var(--on-surface-faint)] hover:border-[var(--on-surface-faint)] focus:border-[#1147D9] focus:shadow-[0_0_0_4px_rgba(17,71,217,0.14)]"
        />
        {isPassword && (
          <button
            type="button"
            aria-label={visible ? "Masquer le contenu" : "Afficher le contenu"}
            onClick={() => setVisible((shown) => !shown)}
            className="absolute right-1.5 top-1/2 grid h-10 w-10 -translate-y-1/2 cursor-pointer place-items-center rounded-xl text-[var(--on-surface-faint)] transition hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-[#4D82FF]"
          >
            {visible ? <EyeOff size={18} /> : <Eye size={18} />}
          </button>
        )}
      </span>
    </label>
  )
}

/** Six cases visuelles au-dessus d'un vrai champ (saisie, collage, remplissage auto). */
function OtpField({
  value,
  onChange,
  autoFocus,
}: {
  value: string
  onChange: (v: string) => void
  autoFocus?: boolean
}) {
  const [focused, setFocused] = useState(Boolean(autoFocus))
  return (
    <div className="relative">
      <div className="grid grid-cols-6 gap-2" aria-hidden="true">
        {Array.from({ length: 6 }, (_, i) => {
          const char = value[i] ?? ""
          const caret = focused && i === Math.min(value.length, 5)
          return (
            <span
              key={i}
              className={`grid h-14 place-items-center rounded-2xl border bg-[var(--surface)] font-mono text-[24px] font-semibold tabular-nums text-[var(--on-surface)] transition-[border-color,box-shadow] duration-200 ${
                caret ? "border-[#1147D9] shadow-[0_0_0_4px_rgba(17,71,217,0.14)]" : char ? "border-[var(--on-surface-faint)]" : "border-[var(--outline)]"
              }`}
            >
              {char || (caret ? <span className="h-6 w-px animate-pulse bg-[#1147D9]" /> : "")}
            </span>
          )
        })}
      </div>
      <input
        autoFocus={autoFocus}
        inputMode="numeric"
        autoComplete="one-time-code"
        maxLength={6}
        value={value}
        onFocus={() => setFocused(true)}
        onBlur={() => setFocused(false)}
        onChange={(e) => onChange(e.target.value.replace(/\D/g, "").slice(0, 6))}
        aria-label="Code d’authentification à 6 chiffres"
        className="absolute inset-0 h-full w-full cursor-text opacity-0"
      />
    </div>
  )
}

function ErrorMsg({ error }: { error: string | null }) {
  if (!error) return null
  return (
    <p role="alert" className="cq-quiz-in rounded-2xl bg-[#DC2626]/8 px-4 py-3 text-[14px] leading-5 text-[#B91C1C] dark:text-[#F87171]">
      {error}
    </p>
  )
}
