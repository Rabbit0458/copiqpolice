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
      const pending = factors?.totp?.find((f) => f.status === "unverified")

      if (!totp) {
        // Aucun facteur validé : on enrôle (on réutilise un enrôlement en attente)
        if (pending) {
          factorIdRef.current = pending.id
          setStep("totp-verify")
        } else {
          setStep("totp-enroll")
        }
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
      <Shell title="Panel administrateur" subtitle="Étape 1 sur 3 — Identifiants">
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
        subtitle="Étape 2 sur 3 — Google Authenticator"
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
      <Shell title="Double authentification" subtitle="Étape 2 sur 3 — Code à 6 chiffres">
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
    <Shell title="Code staff" subtitle="Étape 3 sur 3 — Code personnel">
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
  children,
}: {
  title?: string
  subtitle?: string
  children: React.ReactNode
}) {
  return (
    <div className="flex min-h-screen items-center justify-center bg-[var(--surface-container)] p-4">
      <div className="w-full max-w-sm rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-7 shadow-xl">
        <div className="mb-6 flex items-center gap-2.5">
          <div className="grid h-9 w-9 place-items-center rounded-lg bg-[var(--brand)] text-sm font-bold text-white">
            CQ
          </div>
          <div>
            <div className="text-sm font-semibold leading-tight">COP&apos;IQ</div>
            <div className="text-[11px] uppercase tracking-wide text-[var(--on-surface-faint)]">
              Administration
            </div>
          </div>
        </div>
        {title && <h1 className="text-lg font-semibold">{title}</h1>}
        {subtitle && (
          <p className="mb-5 mt-0.5 text-xs text-[var(--on-surface-faint)]">{subtitle}</p>
        )}
        {children}
      </div>
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
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
        {label}
      </span>
      <input
        {...rest}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2.5 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/20"
      />
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
      className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-3 text-center font-mono text-2xl tracking-[0.4em] outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/20"
    />
  )
}

function ErrorMsg({ error }: { error: string | null }) {
  if (!error) return null
  return (
    <p className="rounded-lg bg-[var(--danger)]/10 px-3 py-2 text-xs text-[var(--danger)]">
      {error}
    </p>
  )
}
