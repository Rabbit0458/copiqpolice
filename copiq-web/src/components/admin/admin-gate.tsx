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
import { Check, Eye, EyeOff, KeyRound, LockKeyhole, ShieldCheck, Sparkles } from "lucide-react"
import { adminAuth, type AdminSession } from "@/lib/admin/api"

type Step =
  | "loading"
  | "signin"
  | "totp-enroll"
  | "totp-verify"
  | "staff-code"
  | "ready"
  | "denied"

const SESSION_KEY = "copiq_admin_code_ok"

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
        <button onClick={handleSignOut} className="btn-ghost mt-6 w-full">
          Se déconnecter
        </button>
      </Shell>
    )
  }

  if (step === "signin") {
    return (
      <Shell title="Bienvenue dans votre espace sécurisé" subtitle="Identifiez-vous pour accéder au centre de pilotage." currentStep={1}>
        <form onSubmit={handleSignIn} className="space-y-3">
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
          <button type="submit" disabled={busy} className="btn-primary w-full">
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
            <button onClick={startEnroll} disabled={busy} className="btn-primary w-full">
              {busy ? "Génération…" : "Générer mon QR code"}
            </button>
          </>
        ) : (
          <>
            <p className="mb-4 text-sm text-[var(--on-surface-muted)]">
              Scanne ce QR code dans ton application, puis saisis le code à 6 chiffres.
            </p>
            <div className="mb-4 flex justify-center rounded-xl bg-white p-4">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={enroll.qr} alt="QR code de configuration TOTP" className="h-44 w-44" />
            </div>
            <details className="mb-4">
              <summary className="cursor-pointer text-xs text-[var(--on-surface-faint)]">
                Impossible de scanner ? Saisie manuelle
              </summary>
              <code className="mt-2 block break-all rounded-lg bg-[var(--surface-container)] p-2 text-xs">
                {enroll.secret}
              </code>
            </details>
            <form onSubmit={handleVerifyTotp} className="space-y-3">
              <OtpField value={code} onChange={setCode} />
              <ErrorMsg error={error} />
              <button
                type="submit"
                disabled={busy || code.length < 6}
                className="btn-primary w-full"
              >
                {busy ? "Vérification…" : "Activer la 2FA"}
              </button>
            </form>
          </>
        )}
        <button onClick={handleSignOut} className="btn-ghost mt-4 w-full">
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
        <form onSubmit={handleVerifyTotp} className="space-y-3">
          <OtpField value={code} onChange={setCode} autoFocus />
          <ErrorMsg error={error} />
          <button
            type="submit"
            disabled={busy || code.length < 6}
            className="btn-primary w-full"
          >
            {busy ? "Vérification…" : "Valider"}
          </button>
        </form>
        <button onClick={handleSignOut} className="btn-ghost mt-4 w-full">
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
      <form onSubmit={handleStaffCode} className="space-y-3">
        <Field
          label="Code staff"
          type="password"
          value={staffCode}
          onChange={setStaffCode}
          autoComplete="one-time-code"
          required
        />
        <ErrorMsg error={error} />
        <button type="submit" disabled={busy} className="btn-primary w-full">
          {busy ? "Vérification…" : "Accéder au panel"}
        </button>
      </form>
      <button onClick={handleSignOut} className="btn-ghost mt-4 w-full">
        Se déconnecter
      </button>
    </Shell>
  )
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Sous-composants                                                           */
/* ────────────────────────────────────────────────────────────────────────── */

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
  const steps = [
    { label: "Compte", icon: KeyRound },
    { label: "2FA", icon: ShieldCheck },
    { label: "Staff", icon: LockKeyhole },
  ]
  return (
    <main className="relative isolate flex min-h-screen items-center justify-center overflow-hidden bg-[#050817] px-4 py-8 text-white sm:px-6">
      <div aria-hidden className="absolute inset-0 bg-[radial-gradient(circle_at_15%_15%,rgba(37,99,235,.24),transparent_32%),radial-gradient(circle_at_85%_80%,rgba(6,182,212,.16),transparent_34%),linear-gradient(145deg,#050817_0%,#0a1230_55%,#071020_100%)]" />
      <div aria-hidden className="admin-auth-orb absolute -left-24 top-1/4 h-72 w-72 rounded-full bg-blue-500/15 blur-3xl" />
      <div aria-hidden className="admin-auth-orb admin-auth-orb-delay absolute -right-20 bottom-1/4 h-80 w-80 rounded-full bg-cyan-400/10 blur-3xl" />
      <section className="admin-auth-enter relative w-full max-w-[1080px] overflow-hidden rounded-[32px] border border-white/10 bg-white/[0.055] shadow-[0_40px_120px_rgba(0,0,0,.55)] backdrop-blur-2xl lg:grid lg:grid-cols-[1.05fr_.95fr]">
        <div className="relative hidden min-h-[680px] overflow-hidden border-r border-white/10 p-12 lg:flex lg:flex-col lg:justify-between">
          <div aria-hidden className="absolute inset-0 bg-[linear-gradient(145deg,rgba(37,99,235,.2),transparent_52%)]" />
          <div className="relative">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png" alt="COP'IQ" className="h-32 w-auto object-contain drop-shadow-[0_16px_35px_rgba(59,130,246,.3)]" />
            <div className="mt-10 inline-flex items-center gap-2 rounded-full border border-blue-300/20 bg-blue-400/10 px-3 py-1.5 text-xs font-medium text-blue-100"><Sparkles size={14} aria-hidden /> Console nouvelle génération</div>
            <h2 className="mt-6 max-w-md text-4xl font-semibold leading-[1.12] tracking-[-0.035em]">Pilotez COP&apos;IQ avec précision et sérénité.</h2>
            <p className="mt-5 max-w-md text-base leading-7 text-slate-300">Un espace centralisé, protégé par trois niveaux de sécurité, pour administrer les contenus et accompagner la communauté.</p>
          </div>
          <div className="relative flex items-center gap-3 text-sm text-slate-300"><span className="grid h-9 w-9 place-items-center rounded-full border border-emerald-300/20 bg-emerald-400/10 text-emerald-300"><ShieldCheck size={18} /></span>Connexion chiffrée et accès contrôlé</div>
        </div>
        <div className="flex min-h-[620px] flex-col justify-center p-6 sm:p-10 lg:p-12">
          <div className="mx-auto w-full max-w-md">
            <div className="mb-8 flex justify-center lg:hidden">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src="https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png" alt="COP'IQ" className="h-24 w-auto object-contain" />
            </div>
            {currentStep && <ol aria-label="Progression de la connexion" className="mb-9 grid grid-cols-3 gap-2">{steps.map(({ label, icon: Icon }, index) => { const number = index + 1; const active = number === currentStep; const done = number < currentStep; return <li key={label} className="text-center"><div className={`mx-auto grid h-11 w-11 place-items-center rounded-2xl border transition-all duration-300 ${active ? "border-blue-400 bg-blue-500 text-white shadow-[0_0_28px_rgba(59,130,246,.38)]" : done ? "border-emerald-400/30 bg-emerald-400/15 text-emerald-300" : "border-white/10 bg-white/5 text-slate-500"}`}>{done ? <Check size={18} /> : <Icon size={18} />}</div><span className={`mt-2 block text-[11px] font-semibold uppercase tracking-[.16em] ${active ? "text-blue-200" : done ? "text-emerald-300" : "text-slate-500"}`}>{label}</span></li> })}</ol>}
            {title && <h1 className="text-2xl font-semibold tracking-[-0.025em] text-white sm:text-3xl">{title}</h1>}
            {subtitle && <p className="mb-7 mt-2 text-sm leading-6 text-slate-400">{subtitle}</p>}
            {children}
            <p className="mt-8 text-center text-[11px] leading-5 text-slate-500">Accès strictement réservé au personnel autorisé COP&apos;IQ.</p>
          </div>
        </div>
      </section>
    </main>
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
      <span className="mb-2 block text-xs font-semibold uppercase tracking-[.12em] text-slate-400">
        {label}
      </span>
      <span className="relative block">
        <input {...rest} type={isPassword && visible ? "text" : rest.type} value={value} onChange={(e) => onChange(e.target.value)} className="min-h-12 w-full rounded-2xl border border-white/10 bg-white/[0.055] px-4 py-3 pr-12 text-base text-white outline-none transition duration-200 placeholder:text-slate-600 hover:border-white/20 focus:border-blue-400/70 focus:bg-white/[0.075] focus:ring-4 focus:ring-blue-500/10" />
        {isPassword && <button type="button" aria-label={visible ? "Masquer le contenu" : "Afficher le contenu"} onClick={() => setVisible((shown) => !shown)} className="absolute right-2 top-1/2 grid h-10 w-10 -translate-y-1/2 cursor-pointer place-items-center rounded-xl text-slate-400 transition hover:bg-white/10 hover:text-white focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-400">{visible ? <EyeOff size={18} /> : <Eye size={18} />}</button>}
      </span>
    </label>
  )
}

function OtpField({
  value,
  onChange,
  autoFocus,
}: {
  value: string
  onChange: (v: string) => void
  autoFocus?: boolean
}) {
  return (
    <input
      autoFocus={autoFocus}
      inputMode="numeric"
      autoComplete="one-time-code"
      maxLength={6}
      placeholder="000000"
      value={value}
      onChange={(e) => onChange(e.target.value.replace(/\D/g, ""))}
      aria-label="Code d’authentification à 6 chiffres"
      className="min-h-14 w-full rounded-2xl border border-white/10 bg-white/[0.055] px-3 py-3 text-center font-mono text-2xl tracking-[0.42em] text-white outline-none transition hover:border-white/20 focus:border-blue-400/70 focus:ring-4 focus:ring-blue-500/10"
    />
  )
}

function ErrorMsg({ error }: { error: string | null }) {
  if (!error) return null
  return (
    <p role="alert" className="rounded-2xl border border-red-400/20 bg-red-400/10 px-4 py-3 text-sm leading-5 text-red-200">
      {error}
    </p>
  )
}
