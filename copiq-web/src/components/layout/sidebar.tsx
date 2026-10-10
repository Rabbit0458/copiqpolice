"use client"

import Link from "next/link"
import { useEffect, useLayoutEffect, useRef, useState } from "react"
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
  Home,
  Languages,
  MessageSquare,
  Settings,
  X,
  Camera,
  Scale,
  Car,
  Shield,
  Siren,
  Users,
  Landmark,
  FileSignature,
} from "lucide-react"
import { cn } from "@/lib/utils"
import type { CpTier } from "@/types"
import { cardHref, findProgram, readProgram } from "@/features/parcours/tree"
import { usePathway } from "@/features/pathway/pathway-provider"
import { COPIQ_LOGO_PNG } from "@/components/home/brand"
import { avatarSrc } from "@/features/auth/profile-rules"
import { createClient } from "@/lib/supabase/client"

/**
 * Navigation de l'espace connecté — version 5 (octobre 2026).
 * Bleu nuit (identité copiq.fr), logo seul, pastille active qui glisse d'un
 * lien à l'autre, carte du compte avec l'avatar choisi dans l'app.
 * Mêmes liens et mêmes droits qu'avant (navigation issue du parcours).
 */

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


const generalItems: NavItem[] = [
  { label: "Accueil", href: "/dashboard", icon: Home },
  { label: "Progression", href: "/progression", icon: BarChart2 },
  { label: "Historique", href: "/historique", icon: FileText },
  { label: "Favoris", href: "/favoris", icon: Bookmark },
]

const communityItems: NavItem[] = [
  { label: "Forum", href: "/forum", icon: MessageSquare },
  { label: "Notifications", href: "/notifications", icon: Bell },
]

/** Icône d'une carte du deck selon son libellé (l'app n'a pas d'icône par carte). */
function iconForCard(label: string): LucideIcon {
  const l = label.toLowerCase()
  if (/photo/.test(l)) return Camera
  if (/psycho/.test(l)) return Brain
  if (/langue/.test(l)) return Languages
  if (/cas pratique/.test(l)) return FileText
  if (/culture|connaissance/.test(l)) return BookOpen
  if (/épreuve|structure/.test(l)) return ClipboardCheck
  if (/circulation|routi|véhicule|accident/.test(l)) return Car
  if (/procès|pv|recueil|formulaire/.test(l)) return FileSignature
  if (/juridi|pénal|sanction|crime|délit|atteinte|libert/.test(l)) return Scale
  if (/intervention|patrouille|service|stupéf|arme/.test(l)) return Siren
  if (/institution|organisation|déontolog|hiérarch|laïcité|histoire|formation/.test(l)) return Landmark
  if (/public|victime|communication|stress|éthique|humain|mineur/.test(l)) return Users
  return Shield
}

const isActive = (pathname: string, href: string) => {
  if (href.includes("?")) return pathname === href.replace(/\/\?/, "?").replace(/\/$/, "")
  const p = pathname.replace(/\/$/, "") || "/"
  return p === href || (href !== "/dashboard" && p.startsWith(`${href}/`))
}

export function Sidebar({ user, tier, mobileOpen = false, onClose }: SidebarProps) {
  const pathname = usePathname()
  const { pathway, profile, loading } = usePathway()
  const isPremium = tier === "premium" || tier === "premium_trial"
  const [avatar, setAvatar] = useState<number | null>(null)

  useEffect(() => {
    let alive = true
    void createClient()
      .from("user_profiles")
      .select("avatar_index")
      .eq("user_id", user.id)
      .maybeSingle()
      .then(({ data }) => {
        const n = Number((data as { avatar_index?: number } | null)?.avatar_index)
        if (alive) setAvatar(n >= 1 && n <= 20 ? n : 1)
      })
    return () => {
      alive = false
    }
  }, [user.id])

  // Navigation du parcours = les cartes du deck de l'app (programme choisi pour la scolarité).
  const [programKey, setProgramKey] = useState<string | null>(null)
  const [search, setSearch] = useState("")
  useEffect(() => {
    if (!pathway) return
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setProgramKey(readProgram(pathway.id))
    setSearch(window.location.search)
  }, [pathway, pathname])
  const program = pathway ? findProgram(pathway.id, programKey) : null
  const schoolLocked = pathway?.mode === "school" && !isPremium
  const pathwayItems: NavItem[] = program
    ? program.cards.map((card) => ({
        label: card.label,
        href: cardHref(program.key, card),
        icon: iconForCard(card.label),
        premium: schoolLocked,
      }))
    : []
  const currentUrl = `${pathname.replace(/\/$/, "")}${search}`

  const name =
    [profile?.first_name, profile?.last_name].filter(Boolean).join(" ").trim() || profile?.username || user.email || "Mon compte"

  return (
    <>
      {/* Grand écran : toujours visible */}
      <div className="hidden h-full lg:block">
        <Panel
          pathname={currentUrl}
          name={name}
          avatar={avatar}
          tier={tier}
          isPremium={isPremium}
          pathway={pathway}
          loading={loading}
          pathwayItems={pathwayItems}
        />
      </div>

      {/* Mobile : tiroir */}
      <div className={cn("fixed inset-0 z-50 lg:hidden", mobileOpen ? "" : "pointer-events-none")} aria-hidden={!mobileOpen}>
        <button
          type="button"
          aria-label="Fermer le menu"
          tabIndex={mobileOpen ? 0 : -1}
          onClick={onClose}
          className={cn("absolute inset-0 bg-[#00061F]/55 backdrop-blur-[2px] transition-opacity duration-300", mobileOpen ? "opacity-100" : "opacity-0")}
        />
        <div
          className={cn(
            "relative h-full w-[min(86vw,290px)] transition-[transform,visibility] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)]",
            mobileOpen ? "visible translate-x-0" : "invisible -translate-x-full",
          )}
        >
          <Panel
            pathname={currentUrl}
            name={name}
            avatar={avatar}
            tier={tier}
            isPremium={isPremium}
            pathway={pathway}
            loading={loading}
            pathwayItems={pathwayItems}
            onClose={onClose}
          />
        </div>
      </div>
    </>
  )
}

function Panel({
  pathname,
  name,
  avatar,
  tier,
  isPremium,
  pathway,
  loading,
  pathwayItems,
  onClose,
}: {
  pathname: string
  name: string
  avatar: number | null
  tier: CpTier
  isPremium: boolean
  pathway: ReturnType<typeof usePathway>["pathway"]
  loading: boolean
  pathwayItems: NavItem[]
  onClose?: () => void
}) {
  const navRef = useRef<HTMLElement | null>(null)
  const pillRef = useRef<HTMLSpanElement | null>(null)

  /* Pastille active qui glisse d'un lien à l'autre. */
  useLayoutEffect(() => {
    const nav = navRef.current
    const pill = pillRef.current
    if (!nav || !pill) return
    const place = () => {
      const link = nav.querySelector<HTMLElement>('a[aria-current="page"]')
      if (!link) {
        pill.style.opacity = "0"
        return
      }
      pill.style.transform = `translate3d(0, ${link.offsetTop}px, 0)`
      pill.style.height = `${link.offsetHeight}px`
      pill.style.opacity = "1"
    }
    place()
    window.addEventListener("resize", place)
    return () => window.removeEventListener("resize", place)
  }, [pathname, pathwayItems.length])

  return (
    <aside aria-label="Navigation principale" className="cq-app-sidebar flex h-full w-full flex-col lg:w-[var(--sidebar-w,264px)]">
      <div className="flex h-[72px] shrink-0 items-center px-5">
        <Link href="/dashboard" onClick={onClose} className="group rounded-xl" aria-label="COP'IQ, accueil">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={COPIQ_LOGO_PNG} alt="" width={50} height={50} className="h-[50px] w-[50px] scale-[1.3] object-contain transition-transform duration-500 group-hover:scale-[1.38]" />
        </Link>
        {onClose && (
          <button type="button" onClick={onClose} aria-label="Fermer le menu" className="ml-auto grid h-10 w-10 place-items-center rounded-xl text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]">
            <X size={19} aria-hidden="true" />
          </button>
        )}
      </div>
      <span className="cq-tricolore mx-5 h-[2px] shrink-0 rounded-full opacity-80" aria-hidden="true" />

      {pathway && (
        <Link
          href="/choisir-parcours"
          onClick={onClose}
          className="group mx-3 mt-4 flex items-center gap-3 rounded-[16px] bg-[var(--surface-container)] px-3 py-2.5 transition-colors hover:bg-[var(--surface-container-hi)]"
        >
          <span className="h-8 w-1 rounded-full" style={{ backgroundColor: pathway.color }} aria-hidden="true" />
          <span className="min-w-0 flex-1">
            <span className="block text-[10.5px] font-bold uppercase tracking-[0.14em] text-[var(--on-surface-faint)]">Ton parcours</span>
            <span className="block truncate text-[14px] font-bold text-[var(--on-surface)]">{pathway.shortLabel}</span>
          </span>
          <ChevronRight size={16} className="shrink-0 text-[var(--on-surface-faint)] transition-transform group-hover:translate-x-0.5" aria-hidden="true" />
        </Link>
      )}

      <nav ref={navRef} className="cq-app-nav relative min-h-0 flex-1 overflow-y-auto px-3 py-5">
        <span ref={pillRef} className="cq-nav-indicator" aria-hidden="true" />
        <NavGroup items={generalItems} pathname={pathname} onNavigate={onClose} />
        <NavGroup
          title={loading ? "Chargement…" : pathway?.shortLabel ?? "Parcours à choisir"}
          items={pathwayItems}
          pathname={pathname}
          onNavigate={onClose}
          isPremium={isPremium}
        />
        <NavGroup title="Communauté" items={communityItems} pathname={pathname} onNavigate={onClose} />
      </nav>

      <div className="shrink-0 border-t border-[var(--outline-variant)] p-3">
        {!isPremium && (
          <Link
            href="/abonnement"
            onClick={onClose}
            className="cq-btn-ink group mb-2 flex h-11 items-center gap-2 rounded-[14px] px-3 text-[13.5px] font-bold"
          >
            <Crown size={15} className="shrink-0 text-[#FBBF24]" aria-hidden="true" />
            <span className="flex-1">Passer Premium</span>
            <ChevronRight size={14} className="opacity-60 transition-transform group-hover:translate-x-0.5" aria-hidden="true" />
          </Link>
        )}
        <Link href="/profil" onClick={onClose} className="group flex items-center gap-3 rounded-[16px] bg-[var(--surface-container)] p-2.5 transition-colors hover:bg-[var(--surface-container-hi)]">
          {avatar ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={avatarSrc(avatar)} alt="" width={36} height={36} className="h-9 w-9 shrink-0 rounded-full ring-2 ring-[var(--surface)]" />
          ) : (
            <span className="h-9 w-9 shrink-0 rounded-full bg-[var(--surface-container-hi)]" aria-hidden="true" />
          )}
          <span className="min-w-0 flex-1">
            <span className="block truncate text-[13px] font-bold text-[var(--on-surface)]">{name}</span>
            <span className="mt-0.5 flex items-center gap-1 text-[11.5px] text-[var(--on-surface-muted)]">
              {isPremium && <Crown size={11} className="text-[#FBBF24]" aria-hidden="true" />}
              {tier === "free" ? "Compte gratuit" : tier === "premium_trial" ? "Essai Premium" : "Premium"}
            </span>
          </span>
          <Settings size={15} className="shrink-0 text-[var(--on-surface-faint)] transition-transform duration-500 group-hover:rotate-45 group-hover:text-[var(--on-surface)]" aria-hidden="true" />
        </Link>
      </div>
    </aside>
  )
}

function NavGroup({ title, items, pathname, onNavigate, isPremium = false }: { title?: string; items: NavItem[]; pathname: string; onNavigate?: () => void; isPremium?: boolean }) {
  if (!items.length && title) {
    return <p className="mb-5 px-3 text-[12px] text-[var(--on-surface-faint)]">{title}</p>
  }
  return (
    <section className="mb-5 last:mb-0">
      {title && <h2 className="mb-2 px-3 text-[10.5px] font-bold uppercase tracking-[0.16em] text-[var(--on-surface-faint)]">{title}</h2>}
      <ul className="grid grid-cols-[minmax(0,1fr)] gap-0.5">
        {items.map((item) => {
          const active = isActive(pathname, item.href)
          const Icon = item.icon
          return (
            <li key={item.href}>
              <Link
                href={item.href}
                onClick={onNavigate}
                aria-current={active ? "page" : undefined}
                className={cn(
                  "cq-nav-link relative z-[1] flex min-h-11 items-center gap-3 rounded-[14px] px-3 text-[14px] transition-colors duration-200",
                  active ? "is-active font-bold" : "font-semibold text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]",
                )}
              >
                <Icon size={18} strokeWidth={active ? 2.2 : 1.8} aria-hidden="true" className="shrink-0" />
                <span className="min-w-0 flex-1 truncate">{item.label}</span>
                {item.premium && !isPremium && <Crown size={12} className="shrink-0 text-[#FBBF24]" aria-label="Premium" />}
              </Link>
            </li>
          )
        })}
      </ul>
    </section>
  )
}
