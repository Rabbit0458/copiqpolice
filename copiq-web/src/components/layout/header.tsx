"use client"

import Link from "next/link"
import { usePathname, useRouter } from "next/navigation"
import { useTheme } from "next-themes"
import { useEffect, useRef, useState } from "react"
import type { User } from "@supabase/supabase-js"
import { Bell, ChevronDown, Crown, LogOut, Menu, Moon, Settings, Sun, User as UserIcon } from "lucide-react"
import toast from "react-hot-toast"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import type { CpTier } from "@/types"
import { usePathway } from "@/features/pathway/pathway-provider"

/**
 * En-tête de l'espace connecté — version 5 (octobre 2026).
 * Titre de la page en cours, thème, notifications, Premium et menu du compte.
 * Un liseré tricolore file sous l'en-tête à chaque changement de page.
 */

interface HeaderProps {
  user: User
  tier: CpTier
  onOpenMenu?: () => void
}

const TITLES: [string, string][] = [
  ["/dashboard", "Accueil"],
  ["/parcours/categorie", "Catégorie"],
  ["/parcours/module", "Module"],
  ["/progression", "Progression"],
  ["/historique", "Historique"],
  ["/favoris", "Favoris"],
  ["/forum", "Forum"],
  ["/notifications", "Notifications"],
  ["/profil", "Mon profil"],
  ["/parametres", "Paramètres"],
  ["/abonnement", "Abonnement"],
  ["/choisir-parcours", "Mon parcours"],
  ["/culture-generale", "Culture générale"],
  ["/psychotechniques", "Psychotechniques"],
  ["/langues", "Langues"],
  ["/concours-blanc", "Concours blanc"],
  ["/memos", "Mémos"],
  ["/notes", "Notes"],
  ["/gpx/cas-pratiques", "Cas pratiques"],
  ["/gpx/quiz", "Quiz"],
  ["/pa/quiz", "Quiz"],
  ["/gpx/scolarite", "Ma scolarité"],
  ["/pa/scolarite", "Ma scolarité"],
]

function titleFor(pathname: string) {
  const p = pathname.replace(/\/$/, "")
  return [...TITLES].sort((a, b) => b[0].length - a[0].length).find(([href]) => p === href || p.startsWith(`${href}/`))?.[1] ?? "Mon espace"
}

export function Header({ user, tier, onOpenMenu }: HeaderProps) {
  const { resolvedTheme, setTheme } = useTheme()
  const router = useRouter()
  const pathname = usePathname()
  const { pathway, profile } = usePathway()
  const [menuOpen, setMenuOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement | null>(null)
  const name = profile?.first_name?.trim() || profile?.username || user.email?.split("@")[0] || "Mon compte"

  useEffect(() => {
    if (!menuOpen) return
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setMenuOpen(false)
    const onClick = (e: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) setMenuOpen(false)
    }
    window.addEventListener("keydown", onKey)
    window.addEventListener("mousedown", onClick)
    return () => {
      window.removeEventListener("keydown", onKey)
      window.removeEventListener("mousedown", onClick)
    }
  }, [menuOpen])

  async function handleLogout() {
    await createClient().auth.signOut()
    toast.success("Déconnexion réussie")
    router.push("/login")
    router.refresh()
  }

  const iconBtn =
    "grid h-10 w-10 place-items-center rounded-xl text-[var(--on-surface-muted)] transition-colors hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#4D82FF]"

  return (
    <header className="cq-app-topbar relative sticky top-0 z-30 flex h-16 shrink-0 items-center gap-3 px-4 sm:px-6 lg:px-8">
      <button type="button" onClick={onOpenMenu} aria-label="Ouvrir le menu principal" className={cn(iconBtn, "lg:hidden")}>
        <Menu size={20} aria-hidden="true" />
      </button>

      <Link href="/dashboard" aria-label="COP’IQ, accueil" className="shrink-0 rounded-xl">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src="/brand/copiq-logo.png" alt="" width={34} height={34} className="h-[34px] w-[34px] object-contain" />
      </Link>
      <span className="hidden h-6 w-px bg-[var(--outline)] sm:block" aria-hidden="true" />
      <div className="flex min-w-0 items-center gap-2 text-[14px]">
        {pathway && <span className="hidden truncate text-[var(--on-surface-faint)] sm:inline">{pathway.shortLabel}</span>}
        {pathway && <span className="hidden text-[var(--on-surface-faint)] sm:inline" aria-hidden="true">/</span>}
        <span className="truncate font-semibold text-[var(--on-surface)]">{titleFor(pathname)}</span>
      </div>

      <div className="ml-auto flex items-center gap-1.5">
        <button
          type="button"
          onClick={() => setTheme(resolvedTheme === "dark" ? "light" : "dark")}
          aria-label={resolvedTheme === "dark" ? "Activer le mode clair" : "Activer le mode sombre"}
          className={iconBtn}
        >
          {resolvedTheme === "dark" ? <Sun size={18} /> : <Moon size={18} />}
        </button>
        <Link href="/notifications" aria-label="Voir les notifications" className={iconBtn}>
          <Bell size={18} />
        </Link>
        {tier === "free" && (
          <Link
            href="/abonnement"
            className="cq-btn-ink hidden h-10 items-center gap-1.5 rounded-full px-4 text-[13px] font-bold sm:inline-flex"
          >
            <Crown size={14} className="text-[#FBBF24]" aria-hidden="true" />
            Premium
          </Link>
        )}

        <div ref={menuRef} className="relative">
          <button
            type="button"
            onClick={() => setMenuOpen((v) => !v)}
            aria-expanded={menuOpen}
            aria-haspopup="menu"
            aria-label="Ouvrir le menu du compte"
            className={cn(
              "flex h-10 items-center gap-2 rounded-xl pl-1.5 pr-2.5 text-[13.5px] font-medium text-[var(--on-surface)] transition-colors hover:bg-[var(--surface-container-hi)]",
              menuOpen && "bg-[var(--surface-container-hi)]",
            )}
          >
            <span className="grid h-7 w-7 place-items-center rounded-full bg-[var(--cq-ink)] text-[11px] font-bold text-[var(--cq-on-ink)]">
              {name.slice(0, 1).toUpperCase()}
            </span>
            <span className="hidden max-w-[9rem] truncate sm:block">{name}</span>
            <ChevronDown size={14} className={cn("text-[var(--on-surface-faint)] transition-transform duration-300", menuOpen && "rotate-180")} aria-hidden="true" />
          </button>

          {menuOpen && (
            <div role="menu" className="cq-pop-in absolute right-0 top-[calc(100%+8px)] z-50 w-60 overflow-hidden rounded-2xl border border-[var(--outline)] bg-[var(--surface)] shadow-[0_24px_60px_-28px_rgba(0,11,54,0.55)]">
              <div className="border-b border-[var(--outline)] px-4 py-3">
                <p className="truncate text-[13.5px] font-semibold text-[var(--on-surface)]">{user.email}</p>
                <p className="mt-0.5 text-[12px] text-[var(--on-surface-faint)]">{tier === "free" ? "Compte gratuit" : tier === "premium_trial" ? "Essai Premium" : "Premium"}</p>
              </div>
              <div className="p-1.5">
                {[
                  { label: "Mon profil", href: "/profil", icon: UserIcon },
                  { label: "Paramètres", href: "/parametres", icon: Settings },
                  { label: "Abonnement", href: "/abonnement", icon: Crown },
                ].map(({ label, href, icon: Icon }) => (
                  <Link
                    key={href}
                    href={href}
                    role="menuitem"
                    onClick={() => setMenuOpen(false)}
                    className="flex items-center gap-3 rounded-xl px-3 py-2.5 text-[14px] text-[var(--on-surface-muted)] transition-colors hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"
                  >
                    <Icon size={15} className="text-[var(--on-surface-faint)]" aria-hidden="true" />
                    {label}
                  </Link>
                ))}
              </div>
              <div className="border-t border-[var(--outline)] p-1.5">
                <button
                  type="button"
                  role="menuitem"
                  onClick={handleLogout}
                  className="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-[14px] text-[#DC2626] transition-colors hover:bg-[#DC2626]/8 dark:text-[#F87171]"
                >
                  <LogOut size={15} aria-hidden="true" />
                  Se déconnecter
                </button>
              </div>
            </div>
          )}
        </div>
      </div>

      <span key={pathname} className="admin-route-bar cq-tricolore pointer-events-none absolute inset-x-0 bottom-[-1px] h-[2px]" aria-hidden="true" />
    </header>
  )
}
