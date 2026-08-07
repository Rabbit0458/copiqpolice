"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import type { User } from "@supabase/supabase-js"
import type { LucideIcon } from "lucide-react"
import {
  BarChart2,
  Bell,
  BookOpen,
  Bookmark,
  Brain,
  ChevronRight,
  ClipboardCheck,
  Crown,
  FileText,
  GraduationCap,
  Languages,
  LayoutDashboard,
  MessageSquare,
  NotebookPen,
  Settings,
  StickyNote,
  Target,
  User as UserIcon,
  X,
} from "lucide-react"
import { cn } from "@/lib/utils"
import type { CpTier } from "@/types"
import { getPathwayNavigation, type PathwayIconKey } from "@/config/pathways"
import { usePathway } from "@/features/pathway/pathway-provider"

interface SidebarProps {
  user: User
  tier: CpTier
  mobileOpen?: boolean
  onClose?: () => void
}

interface NavItem {
  label: string
  href: string
  icon: LucideIcon
  premium?: boolean
}

const iconByKey: Record<PathwayIconKey, LucideIcon> = {
  dashboard: LayoutDashboard,
  graduation: GraduationCap,
  quiz: Target,
  knowledge: BookOpen,
  brain: Brain,
  languages: Languages,
  caseStudies: FileText,
  mockExam: ClipboardCheck,
  memos: StickyNote,
  notes: NotebookPen,
}

const generalItems: NavItem[] = [
  { label: "Accueil", href: "/dashboard", icon: LayoutDashboard },
  { label: "Progression", href: "/progression", icon: BarChart2 },
  { label: "Historique", href: "/historique", icon: FileText },
  { label: "Favoris", href: "/favoris", icon: Bookmark },
]

const communityItems: NavItem[] = [
  { label: "Forum", href: "/forum", icon: MessageSquare },
  { label: "Notifications", href: "/notifications", icon: Bell },
]

export function Sidebar({ user, tier, mobileOpen = false, onClose }: SidebarProps) {
  const pathname = usePathname()
  const { pathway, profile, loading } = usePathway()
  const isPremium = tier === "premium" || tier === "premium_trial"
  const pathwayItems: NavItem[] = pathway
    ? getPathwayNavigation(pathway.id, tier).map((item) => ({
        label: item.label,
        href: item.href,
        icon: iconByKey[item.iconKey],
        premium: item.premium,
      }))
    : []

  const name = [profile?.first_name, profile?.last_name].filter(Boolean).join(" ").trim()
    || profile?.username
    || user.email
    || "Mon compte"

  const content = (
    <aside
      aria-label="Navigation principale"
      className={cn(
        "flex h-full w-[min(86vw,280px)] shrink-0 flex-col overflow-y-auto border-r border-[var(--outline)] bg-[var(--surface)] lg:w-[var(--sidebar-w,256px)]",
        mobileOpen ? "shadow-2xl" : "",
      )}
    >
      <div className="flex min-h-16 items-center gap-3 border-b border-[var(--outline)] px-4 py-3">
        <Link href="/dashboard" onClick={onClose} className="flex min-h-11 flex-1 items-center gap-3 rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand">
          <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-gradient-to-br from-brand to-brand-mid text-base font-bold text-white shadow-brand">C</span>
          <span>
            <span className="block text-sm font-bold tracking-tight text-[var(--on-surface)]">COP&apos;IQ</span>
            <span className="block text-[10px] text-[var(--on-surface-faint)]">Police nationale</span>
          </span>
        </Link>
        <button type="button" onClick={onClose} aria-label="Fermer le menu" className="flex h-11 w-11 items-center justify-center rounded-xl text-[var(--on-surface-muted)] transition-colors hover:bg-[var(--surface-container)] lg:hidden">
          <X size={20} aria-hidden="true" />
        </button>
      </div>

      {pathway && (
        <Link
          href="/choisir-parcours"
          onClick={onClose}
          className="mx-3 mt-3 flex min-h-14 items-center gap-3 rounded-2xl border px-3 py-2.5 transition-transform hover:-translate-y-0.5 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand"
          style={{ borderColor: `${pathway.color}55`, backgroundColor: pathway.softColor }}
        >
          <span className="h-8 w-1 rounded-full" style={{ backgroundColor: pathway.color }} aria-hidden="true" />
          <span className="min-w-0 flex-1">
            <span className="block text-[10px] font-semibold uppercase tracking-[0.12em] text-neutral-500">Votre parcours</span>
            <span className="block truncate text-sm font-semibold text-neutral-950">{pathway.shortLabel}</span>
          </span>
          <ChevronRight size={16} className="shrink-0 text-neutral-500" aria-hidden="true" />
        </Link>
      )}

      {isPremium ? (
        <div className="mx-3 mt-3 flex items-center gap-2 rounded-xl border border-brand/20 bg-brand/10 px-3 py-2">
          <Crown size={14} className="shrink-0 text-brand" aria-hidden="true" />
          <span className="text-xs font-semibold text-brand">{tier === "premium_trial" ? "Essai Premium" : "Premium actif"}</span>
        </div>
      ) : (
        <Link href="/abonnement" onClick={onClose} className="group mx-3 mt-3 flex min-h-11 items-center gap-2 rounded-xl bg-gradient-to-r from-brand to-brand-mid px-3 py-2 text-white shadow-brand transition-shadow hover:shadow-brand-lg focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand focus-visible:ring-offset-2">
          <Crown size={14} className="shrink-0" aria-hidden="true" />
          <span className="flex-1 text-xs font-semibold">Passer Premium</span>
          <ChevronRight size={12} className="text-white/70 transition-transform group-hover:translate-x-0.5" aria-hidden="true" />
        </Link>
      )}

      <nav className="flex-1 space-y-6 px-3 py-4">
        <NavGroup items={generalItems} pathname={pathname} onNavigate={onClose} />
        <NavGroup
          title={loading ? "Chargement du parcours" : pathway?.shortLabel ?? "Parcours à choisir"}
          items={pathwayItems}
          pathname={pathname}
          onNavigate={onClose}
          isPremium={isPremium}
        />
        <NavGroup title="Communauté" items={communityItems} pathname={pathname} onNavigate={onClose} />
      </nav>

      <div className="border-t border-[var(--outline)] p-3">
        <Link href="/profil" onClick={onClose} className="group flex min-h-14 items-center gap-3 rounded-xl p-2.5 transition-colors hover:bg-[var(--surface-container)] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand">
          <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full border border-brand/20 bg-gradient-to-br from-brand/20 to-brand-mid/20">
            <UserIcon size={15} className="text-brand" aria-hidden="true" />
          </span>
          <span className="min-w-0 flex-1">
            <span className="block truncate text-xs font-medium text-[var(--on-surface)]">{name}</span>
            <span className="block text-[10px] text-[var(--on-surface-faint)]">{tier === "free" ? "Compte gratuit" : tier === "premium_trial" ? "Essai Premium" : "Premium"}</span>
          </span>
          <Settings size={14} className="shrink-0 text-[var(--on-surface-faint)] group-hover:text-[var(--on-surface-muted)]" aria-hidden="true" />
        </Link>
      </div>
    </aside>
  )

  return (
    <>
      <div className="hidden h-full lg:block">{content}</div>
      {mobileOpen && (
        <div className="fixed inset-0 z-50 lg:hidden">
          <button type="button" aria-label="Fermer le menu" onClick={onClose} className="absolute inset-0 bg-black/45 backdrop-blur-[2px]" />
          <div className="relative h-full animate-[slide-in_180ms_ease-out]">{content}</div>
        </div>
      )}
    </>
  )
}

function NavGroup({ title, items, pathname, onNavigate, isPremium = false }: { title?: string; items: NavItem[]; pathname: string; onNavigate?: () => void; isPremium?: boolean }) {
  if (!items.length && title) {
    return <p className="px-2 text-xs text-[var(--on-surface-faint)]">{title}</p>
  }

  return (
    <section>
      {title && <h2 className="mb-1.5 px-2 text-[10px] font-semibold uppercase tracking-[0.14em] text-[var(--on-surface-faint)]">{title}</h2>}
      <ul className="space-y-0.5">
        {items.map((item) => {
          const active = pathname === item.href || (item.href !== "/dashboard" && pathname.startsWith(item.href))
          const Icon = item.icon
          return (
            <li key={item.href}>
              <Link href={item.href} onClick={onNavigate} aria-current={active ? "page" : undefined} className={cn("flex min-h-11 items-center gap-2.5 rounded-xl px-2.5 py-2 text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand", active ? "bg-brand/10 text-brand" : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]")}>
                <Icon size={18} className={active ? "text-brand" : "text-[var(--on-surface-faint)]"} aria-hidden="true" />
                <span className="flex-1">{item.label}</span>
                {item.premium && !isPremium && <Crown size={12} className="shrink-0 text-warning" aria-label="Premium" />}
              </Link>
            </li>
          )
        })}
      </ul>
    </section>
  )
}
