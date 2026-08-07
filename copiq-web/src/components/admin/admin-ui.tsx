"use client"

/** COP'IQ — Briques d'interface partagées du panel administrateur. */

import Link from "next/link"
import { usePathname } from "next/navigation"
import { useEffect, useState } from "react"
import {
  Activity,
  BadgeEuro,
  BookOpenText,
  ChevronLeft,
  ChevronRight,
  ClipboardCheck,
  FileClock,
  FilePenLine,
  Flag,
  GraduationCap,
  HeartPulse,
  LayoutDashboard,
  LibraryBig,
  LogOut,
  Menu,
  MessageSquareMore,
  MoonStar,
  ShieldCheck,
  Sun,
  Users,
  X,
  type LucideIcon,
} from "lucide-react"
import { useTheme } from "next-themes"
import { adminAuth, type AdminSession } from "@/lib/admin/api"

/* ────────────────────────────────────────────────────────────────────────── */
/*  Navigation                                                                */
/* ────────────────────────────────────────────────────────────────────────── */

type NavItem = {
  href: string
  label: string
  icon: LucideIcon
  group: "Pilotage" | "Contenus" | "Communauté" | "Système"
  perm?: string
}

const NAV: NavItem[] = [
  { href: "/admin/", label: "Vue d'ensemble", icon: LayoutDashboard, group: "Pilotage", perm: "dashboard" },
  { href: "/admin/signalements/", label: "Signalements", icon: Flag, group: "Pilotage", perm: "flags" },
  { href: "/admin/cas-pratiques/", label: "Cas pratiques", icon: ClipboardCheck, group: "Contenus", perm: "cas_pratiques" },
  { href: "/admin/appels/", label: "Appels élèves", icon: FileClock, group: "Contenus", perm: "cas_pratiques" },
  { href: "/admin/contenus/", label: "Pilotage pédagogique", icon: LibraryBig, group: "Contenus", perm: "quiz.write" },
  { href: "/admin/quiz/", label: "Quiz de scolarité", icon: GraduationCap, group: "Contenus", perm: "quiz.write" },
  { href: "/admin/cours/", label: "Fiches de cours", icon: BookOpenText, group: "Contenus", perm: "quiz.write" },
  { href: "/admin/sante/", label: "Santé du contenu", icon: HeartPulse, group: "Contenus", perm: "cas_pratiques" },
  { href: "/admin/forum/", label: "Modération forum", icon: MessageSquareMore, group: "Communauté", perm: "flags" },
  { href: "/admin/utilisateurs/", label: "Utilisateurs", icon: Users, group: "Communauté", perm: "users" },
  { href: "/admin/abonnements/", label: "Abonnements", icon: BadgeEuro, group: "Communauté", perm: "subscriptions" },
  { href: "/admin/patch-notes/", label: "Notes de patch", icon: FilePenLine, group: "Système", perm: "dashboard" },
  { href: "/admin/administrateurs/", label: "Administrateurs", icon: ShieldCheck, group: "Système", perm: "admin_security" },
  { href: "/admin/journal/", label: "Journal d'audit", icon: Activity, group: "Système", perm: "admin_security" },
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
  const [collapsed, setCollapsed] = useState(false)
  const { resolvedTheme, setTheme } = useTheme()
  const perms = session.permissions ?? {}
  const isOwner = session.role === "owner"
  const visible = NAV.filter((n) => !n.perm || isOwner || perms[n.perm])

  return (
    <div className="min-h-screen bg-[var(--surface-container)] selection:bg-[var(--brand)]/20">
      {/* Barre supérieure */}
      <header className="sticky top-0 z-40 flex h-16 items-center justify-between border-b border-[var(--outline-variant)] bg-[var(--surface)]/95 px-4 backdrop-blur-xl md:px-5">
        <div className="flex items-center gap-3">
          <button
            onClick={() => setOpen((v) => !v)}
            className="rounded-xl p-2 transition hover:bg-[var(--surface-container)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] md:hidden"
            aria-label={open ? "Fermer le menu" : "Ouvrir le menu"}
            aria-expanded={open}
          >
            {open ? <X size={20} /> : <Menu size={20} />}
          </button>
          <Link href="/admin/" className="flex items-center gap-2.5">
            <span className="grid h-9 w-9 place-items-center rounded-xl bg-[var(--brand)] text-xs font-bold text-white shadow-[0_8px_20px_rgba(17,71,217,.25)]">
              CQ
            </span>
            <span className="text-sm font-semibold tracking-tight">
              COP&apos;IQ{" "}
              <span className="font-normal text-[var(--on-surface-faint)]">Admin</span>
            </span>
          </Link>
        </div>
        <div className="flex items-center gap-3">
          <span className="hidden max-w-48 truncate text-xs text-[var(--on-surface-muted)] lg:inline">
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
            onClick={() => setTheme(resolvedTheme === "dark" ? "light" : "dark")}
            className="rounded-xl p-2 text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
            aria-label={resolvedTheme === "dark" ? "Activer le thème clair" : "Activer le thème sombre"}
          >
            {resolvedTheme === "dark" ? <Sun size={18} /> : <MoonStar size={18} />}
          </button>
          <button
            onClick={async () => {
              sessionStorage.removeItem("copiq_admin_code_ok")
              await adminAuth.signOut()
              location.href = "/admin/"
            }}
            className="inline-flex items-center gap-2 rounded-xl px-2.5 py-2 text-xs text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--danger)]"
          >
            <LogOut size={16} /> <span className="hidden sm:inline">Quitter</span>
          </button>
        </div>
      </header>

      <div className="flex items-start">
        {/* Barre latérale */}
        <aside
          className={`${open ? "block" : "hidden"} fixed inset-x-0 top-16 z-30 max-h-[calc(100vh-4rem)] overflow-y-auto border-b border-[var(--outline-variant)] bg-[var(--surface)] p-3 shadow-2xl md:sticky md:top-16 md:block md:h-[calc(100vh-4rem)] md:max-h-none md:shrink-0 md:border-b-0 md:border-r md:shadow-none ${collapsed ? "md:w-20" : "md:w-64"} transition-[width] duration-200`}
        >
          <nav aria-label="Navigation d'administration" className="space-y-5">
            {(["Pilotage", "Contenus", "Communauté", "Système"] as const).map((group) => {
              const items = visible.filter((item) => item.group === group)
              if (items.length === 0) return null
              return <div key={group}>
                {!collapsed && <p className="mb-1.5 px-3 text-[10px] font-semibold uppercase tracking-[0.16em] text-[var(--on-surface-faint)]">{group}</p>}
                <div className="space-y-1">{items.map((n) => {
              const active = pathname === n.href || pathname === n.href.slice(0, -1)
              const Icon = n.icon
              return (
                <Link
                  key={n.href}
                  href={n.href}
                  onClick={() => setOpen(false)}
                  title={collapsed ? n.label : undefined}
                  className={`group flex min-h-10 items-center rounded-xl px-3 text-sm transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${collapsed ? "justify-center" : "gap-3"} ${
                    active
                      ? "bg-[var(--brand)] font-semibold text-white shadow-[0_8px_18px_rgba(17,71,217,.18)]"
                      : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"
                  }`}
                >
                  <Icon size={18} strokeWidth={active ? 2.3 : 1.8} aria-hidden="true" />
                  {!collapsed && <span className="truncate">{n.label}</span>}
                </Link>
              )
            })}</div></div>})}
          </nav>
          <button onClick={() => setCollapsed((value) => !value)} className="absolute bottom-4 right-3 hidden rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] p-2 text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] md:block" aria-label={collapsed ? "Agrandir la navigation" : "Réduire la navigation"}>
            {collapsed ? <ChevronRight size={17} /> : <ChevronLeft size={17} />}
          </button>
        </aside>

        <main className="min-w-0 flex-1 p-4 md:p-6 lg:p-8">
          <div className="mx-auto w-full max-w-[1500px] animate-fade-in">{children}</div>
        </main>
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
    // L'état doit repasser en chargement dès qu'une dépendance ou un rechargement change.
    // eslint-disable-next-line react-hooks/set-state-in-effect
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
