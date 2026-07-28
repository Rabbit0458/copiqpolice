"use client"

/** COP'IQ — Briques d'interface partagées du panel administrateur. */

import Link from "next/link"
import { usePathname } from "next/navigation"
import { useEffect, useState } from "react"
import { adminAuth, type AdminSession } from "@/lib/admin/api"

/* ────────────────────────────────────────────────────────────────────────── */
/*  Navigation                                                                */
/* ────────────────────────────────────────────────────────────────────────── */

const NAV: { href: string; label: string; icon: string; perm?: string }[] = [
  { href: "/admin/", label: "Vue d'ensemble", icon: "◧", perm: "dashboard" },
  { href: "/admin/cas-pratiques/", label: "Cas pratiques", icon: "▤", perm: "cas_pratiques" },
  { href: "/admin/appels/", label: "Appels élèves", icon: "⚖", perm: "cas_pratiques" },
  { href: "/admin/quiz/", label: "Quiz de scolarité", icon: "◈", perm: "quiz.write" },
  { href: "/admin/cours/", label: "Fiches de cours", icon: "▦", perm: "quiz.write" },
  { href: "/admin/sante/", label: "Santé du contenu", icon: "✚", perm: "cas_pratiques" },
  { href: "/admin/signalements/", label: "Signalements", icon: "⚑", perm: "flags" },
  { href: "/admin/forum/", label: "Modération forum", icon: "◉", perm: "flags" },
  { href: "/admin/utilisateurs/", label: "Utilisateurs", icon: "◍", perm: "users" },
  { href: "/admin/abonnements/", label: "Abonnements", icon: "◎", perm: "subscriptions" },
  { href: "/admin/patch-notes/", label: "Notes de patch", icon: "✎", perm: "dashboard" },
  { href: "/admin/administrateurs/", label: "Administrateurs", icon: "⚿", perm: "admin_security" },
  { href: "/admin/journal/", label: "Journal d'audit", icon: "☰", perm: "admin_security" },
]

export function AdminShell({
  session,
  children,
}: {
  session: AdminSession
  children: React.ReactNode
}) {
  const pathname = usePathname()
  const [open, setOpen] = useState(false)
  const perms = session.permissions ?? {}
  const isOwner = session.role === "owner"
  const visible = NAV.filter((n) => !n.perm || isOwner || perms[n.perm])

  return (
    <div className="min-h-screen bg-[var(--surface-container)]">
      {/* Barre supérieure */}
      <header className="sticky top-0 z-30 flex h-14 items-center justify-between border-b border-[var(--outline-variant)] bg-[var(--surface)] px-4">
        <div className="flex items-center gap-3">
          <button
            onClick={() => setOpen((v) => !v)}
            className="rounded-lg p-1.5 text-lg hover:bg-[var(--surface-container)] md:hidden"
            aria-label="Menu"
          >
            ☰
          </button>
          <Link href="/admin/" className="flex items-center gap-2.5">
            <span className="grid h-8 w-8 place-items-center rounded-lg bg-[var(--brand)] text-xs font-bold text-white">
              CQ
            </span>
            <span className="text-sm font-semibold">
              COP&apos;IQ{" "}
              <span className="font-normal text-[var(--on-surface-faint)]">Admin</span>
            </span>
          </Link>
        </div>
        <div className="flex items-center gap-3">
          <span className="hidden text-xs text-[var(--on-surface-muted)] sm:inline">
            {session.email}
          </span>
          <span className="rounded-full bg-[var(--brand)]/10 px-2.5 py-1 text-[11px] font-medium uppercase tracking-wide text-[var(--brand)]">
            {session.role}
          </span>
          {session.aal === "aal2" && (
            <span
              title="Double authentification active"
              className="rounded-full bg-[var(--success)]/10 px-2 py-1 text-[11px] text-[var(--success)]"
            >
              2FA
            </span>
          )}
          <button
            onClick={async () => {
              sessionStorage.removeItem("copiq_admin_code_ok")
              await adminAuth.signOut()
              location.href = "/admin/"
            }}
            className="rounded-lg px-2.5 py-1.5 text-xs text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]"
          >
            Quitter
          </button>
        </div>
      </header>

      <div className="flex">
        {/* Barre latérale */}
        <aside
          className={`${
            open ? "block" : "hidden"
          } fixed inset-x-0 top-14 z-20 border-b border-[var(--outline-variant)] bg-[var(--surface)] p-3 md:sticky md:top-14 md:block md:h-[calc(100vh-3.5rem)] md:w-60 md:shrink-0 md:border-b-0 md:border-r`}
        >
          <nav className="space-y-0.5">
            {visible.map((n) => {
              const active = pathname === n.href || pathname === n.href.slice(0, -1)
              return (
                <Link
                  key={n.href}
                  href={n.href}
                  onClick={() => setOpen(false)}
                  className={`flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm transition ${
                    active
                      ? "bg-[var(--brand)] font-medium text-white"
                      : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]"
                  }`}
                >
                  <span className="w-4 text-center opacity-70">{n.icon}</span>
                  {n.label}
                </Link>
              )
            })}
          </nav>
        </aside>

        <main className="min-w-0 flex-1 p-4 md:p-6">{children}</main>
      </div>
    </div>
  )
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Primitives                                                                */
/* ────────────────────────────────────────────────────────────────────────── */

export function PageHeader({
  title,
  subtitle,
  action,
}: {
  title: string
  subtitle?: string
  action?: React.ReactNode
}) {
  return (
    <div className="mb-5 flex flex-wrap items-end justify-between gap-3">
      <div>
        <h1 className="text-xl font-semibold">{title}</h1>
        {subtitle && (
          <p className="mt-0.5 text-sm text-[var(--on-surface-muted)]">{subtitle}</p>
        )}
      </div>
      {action}
    </div>
  )
}

export function Card({
  children,
  className = "",
}: {
  children: React.ReactNode
  className?: string
}) {
  return (
    <div
      className={`rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] ${className}`}
    >
      {children}
    </div>
  )
}

export function Stat({
  label,
  value,
  hint,
  tone = "neutral",
}: {
  label: string
  value: React.ReactNode
  hint?: string
  tone?: "neutral" | "good" | "warn" | "bad"
}) {
  const colors = {
    neutral: "text-[var(--on-surface)]",
    good: "text-[var(--success)]",
    warn: "text-[var(--warning)]",
    bad: "text-[var(--danger)]",
  }
  return (
    <Card className="p-4">
      <div className="text-[11px] font-medium uppercase tracking-wide text-[var(--on-surface-faint)]">
        {label}
      </div>
      <div className={`mt-1 text-2xl font-semibold tabular-nums ${colors[tone]}`}>
        {value}
      </div>
      {hint && <div className="mt-0.5 text-xs text-[var(--on-surface-muted)]">{hint}</div>}
    </Card>
  )
}

export function Badge({
  children,
  tone = "neutral",
}: {
  children: React.ReactNode
  tone?: "neutral" | "good" | "warn" | "bad" | "brand"
}) {
  const map = {
    neutral: "bg-[var(--surface-container-hi)] text-[var(--on-surface-muted)]",
    good: "bg-[var(--success)]/12 text-[var(--success)]",
    warn: "bg-[var(--warning)]/15 text-[var(--warning)]",
    bad: "bg-[var(--danger)]/12 text-[var(--danger)]",
    brand: "bg-[var(--brand)]/10 text-[var(--brand)]",
  }
  return (
    <span
      className={`inline-flex items-center rounded-full px-2 py-0.5 text-[11px] font-medium ${map[tone]}`}
    >
      {children}
    </span>
  )
}

export function Button({
  variant = "primary",
  className = "",
  ...rest
}: React.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: "primary" | "ghost" | "danger"
}) {
  const map = {
    primary: "bg-[var(--brand)] text-white hover:brightness-110",
    ghost:
      "border border-[var(--outline)] text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]",
    danger: "bg-[var(--danger)] text-white hover:brightness-110",
  }
  return (
    <button
      {...rest}
      className={`rounded-lg px-3.5 py-2 text-sm font-medium transition disabled:cursor-not-allowed disabled:opacity-50 ${map[variant]} ${className}`}
    />
  )
}

export function Loading({ label = "Chargement…" }: { label?: string }) {
  return (
    <div className="flex items-center gap-2.5 p-8 text-sm text-[var(--on-surface-muted)]">
      <span className="h-4 w-4 animate-spin rounded-full border-2 border-[var(--brand)] border-t-transparent" />
      {label}
    </div>
  )
}

export function ErrorBox({ error }: { error: unknown }) {
  if (!error) return null
  const msg = error instanceof Error ? error.message : String(error)
  return (
    <Card className="border-[var(--danger)]/30 bg-[var(--danger)]/5 p-4">
      <div className="text-sm font-medium text-[var(--danger)]">Erreur</div>
      <div className="mt-1 text-sm text-[var(--on-surface-muted)]">{msg}</div>
    </Card>
  )
}

export function Empty({ children }: { children: React.ReactNode }) {
  return (
    <div className="p-10 text-center text-sm text-[var(--on-surface-muted)]">{children}</div>
  )
}

/** Hook de chargement de données avec gestion d'erreur et rafraîchissement. */
export function useAsync<T>(fn: () => Promise<T>, deps: React.DependencyList = []) {
  const [data, setData] = useState<T | null>(null)
  const [error, setError] = useState<unknown>(null)
  const [loading, setLoading] = useState(true)
  const [tick, setTick] = useState(0)

  useEffect(() => {
    let alive = true
    setLoading(true)
    setError(null)
    fn()
      .then((d) => alive && setData(d))
      .catch((e) => alive && setError(e))
      .finally(() => alive && setLoading(false))
    return () => {
      alive = false
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [...deps, tick])

  return { data, error, loading, reload: () => setTick((t) => t + 1) }
}
