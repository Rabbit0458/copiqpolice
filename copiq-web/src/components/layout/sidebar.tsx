"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import { cn } from "@/lib/utils"
import type { User } from "@supabase/supabase-js"
import type { CpTier } from "@/types"
import {
  LayoutDashboard, BookOpen, Target, BarChart2, Bookmark,
  MessageSquare, Settings, Crown, ChevronRight, GraduationCap,
  FileText, Brain, Globe, Zap, Bell, User as UserIcon
} from "lucide-react"

interface SidebarProps {
  user: User
  tier: CpTier
}

interface NavSection {
  title?: string
  items: Array<{
    label: string
    href: string
    icon: React.ReactNode
    isPremium?: boolean
    badge?: string
  }>
}

export function Sidebar({ user, tier }: SidebarProps) {
  const pathname = usePathname()
  const isPremium = tier === "premium" || tier === "premium_trial"

  const sections: NavSection[] = [
    {
      items: [
        { label: "Dashboard", href: "/dashboard", icon: <LayoutDashboard size={18} /> },
        { label: "Progression", href: "/progression", icon: <BarChart2 size={18} /> },
        { label: "Historique", href: "/historique", icon: <FileText size={18} /> },
        { label: "Favoris", href: "/favoris", icon: <Bookmark size={18} /> },
      ],
    },
    {
      title: "Policier Adjoint",
      items: [
        { label: "Scolarité PA", href: "/pa/scolarite", icon: <GraduationCap size={18} /> },
        { label: "Quiz PA", href: "/pa/quiz", icon: <Target size={18} /> },
        { label: "Cours PA", href: "/pa/cours", icon: <BookOpen size={18} />, isPremium: true },
      ],
    },
    {
      title: "Gardien de la Paix",
      items: [
        { label: "Scolarité GPX", href: "/gpx/scolarite", icon: <GraduationCap size={18} /> },
        { label: "Quiz GPX", href: "/gpx/quiz", icon: <Target size={18} /> },
        { label: "Cas Pratiques", href: "/gpx/cas-pratiques", icon: <FileText size={18} />, isPremium: true },
        { label: "Culture Générale", href: "/gpx/culture-generale", icon: <Globe size={18} /> },
        { label: "Psychotechniques", href: "/gpx/psychotechniques", icon: <Brain size={18} /> },
        { label: "Langues", href: "/gpx/langues", icon: <Globe size={18} /> },
        { label: "Concours Blanc", href: "/gpx/concours-blanc", icon: <Zap size={18} />, isPremium: true },
      ],
    },
    {
      title: "Communauté",
      items: [
        { label: "Forum", href: "/forum", icon: <MessageSquare size={18} /> },
        { label: "Notifications", href: "/notifications", icon: <Bell size={18} /> },
      ],
    },
  ]

  return (
    <aside className="hidden lg:flex w-[var(--sidebar-w,256px)] flex-col border-r border-[var(--outline)] bg-[var(--surface)] shrink-0 overflow-y-auto">
      {/* Logo */}
      <div className="p-5 border-b border-[var(--outline)]">
        <Link href="/dashboard" className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-brand to-brand-mid flex items-center justify-center shadow-brand shrink-0">
            <span className="text-white font-bold text-base">C</span>
          </div>
          <div>
            <div className="font-bold text-[var(--on-surface)] text-sm tracking-tight">COP&apos;IQ</div>
            <div className="text-[10px] text-[var(--on-surface-faint)]">Police Nationale</div>
          </div>
        </Link>
      </div>

      {/* Premium badge */}
      {isPremium ? (
        <div className="mx-3 mt-3 px-3 py-2 rounded-xl bg-gradient-to-r from-brand/10 to-brand-mid/10 border border-brand/20 flex items-center gap-2">
          <Crown size={14} className="text-brand shrink-0" />
          <span className="text-xs font-semibold text-brand">
            {tier === "premium_trial" ? "Essai Premium" : "Premium actif"}
          </span>
        </div>
      ) : (
        <Link
          href="/abonnement"
          className="mx-3 mt-3 px-3 py-2 rounded-xl bg-gradient-to-r from-brand to-brand-mid flex items-center gap-2 shadow-brand hover:shadow-brand-lg transition-shadow group"
        >
          <Crown size={14} className="text-white shrink-0" />
          <span className="text-xs font-semibold text-white flex-1">Passer Premium</span>
          <ChevronRight size={12} className="text-white/60 group-hover:translate-x-0.5 transition-transform" />
        </Link>
      )}

      {/* Navigation */}
      <nav className="flex-1 px-3 py-4 space-y-6">
        {sections.map((section, si) => (
          <div key={si}>
            {section.title && (
              <div className="px-2 mb-1.5 text-[10px] font-semibold uppercase tracking-widest text-[var(--on-surface-faint)]">
                {section.title}
              </div>
            )}
            <ul className="space-y-0.5">
              {section.items.map((item) => {
                const active = pathname === item.href || (item.href !== "/dashboard" && pathname.startsWith(item.href))
                return (
                  <li key={item.href}>
                    <Link
                      href={item.href}
                      className={cn(
                        "flex items-center gap-2.5 px-2.5 py-2 rounded-lg text-sm font-medium transition-all duration-150",
                        active
                          ? "bg-brand/10 text-brand"
                          : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"
                      )}
                    >
                      <span className={active ? "text-brand" : "text-[var(--on-surface-faint)]"}>
                        {item.icon}
                      </span>
                      <span className="flex-1">{item.label}</span>
                      {item.isPremium && !isPremium && (
                        <Crown size={12} className="text-warning shrink-0" />
                      )}
                    </Link>
                  </li>
                )
              })}
            </ul>
          </div>
        ))}
      </nav>

      {/* User footer */}
      <div className="p-3 border-t border-[var(--outline)]">
        <Link
          href="/profil"
          className="flex items-center gap-3 p-2.5 rounded-xl hover:bg-[var(--surface-container)] transition-colors group"
        >
          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-brand/20 to-brand-mid/20 border border-brand/20 flex items-center justify-center shrink-0">
            <UserIcon size={14} className="text-brand" />
          </div>
          <div className="flex-1 min-w-0">
            <div className="text-xs font-medium text-[var(--on-surface)] truncate">
              {user.email}
            </div>
            <div className="text-[10px] text-[var(--on-surface-faint)]">
              {tier === "free" ? "Compte gratuit" : tier === "premium_trial" ? "Essai Premium" : "Premium"}
            </div>
          </div>
          <Settings size={14} className="text-[var(--on-surface-faint)] group-hover:text-[var(--on-surface-muted)] shrink-0" />
        </Link>
      </div>
    </aside>
  )
}
