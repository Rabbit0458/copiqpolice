"use client"

import Link from "next/link"
import { useRouter } from "next/navigation"
import { useTheme } from "next-themes"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import type { User } from "@supabase/supabase-js"
import type { CpTier } from "@/types"
import { Sun, Moon, Bell, Crown, LogOut, Settings, User as UserIcon, Menu } from "lucide-react"
import { useState } from "react"
import toast from "react-hot-toast"

interface HeaderProps {
  user: User
  tier: CpTier
}

export function Header({ user, tier }: HeaderProps) {
  const { theme, setTheme } = useTheme()
  const router = useRouter()
  const [menuOpen, setMenuOpen] = useState(false)
  const supabase = createClient()

  async function handleLogout() {
    await supabase.auth.signOut()
    toast.success("Déconnexion réussie")
    router.push("/login")
    router.refresh()
  }

  return (
    <header className="h-[var(--header-h,64px)] border-b border-[var(--outline)] bg-[var(--surface)] flex items-center px-4 sm:px-6 gap-4 shrink-0 sticky top-0 z-30">
      {/* Mobile menu button */}
      <button className="lg:hidden p-2 rounded-lg hover:bg-[var(--surface-container)] transition-colors text-[var(--on-surface-muted)]">
        <Menu size={20} />
      </button>

      {/* Breadcrumb / titre — injecté par les sous-layouts */}
      <div className="flex-1" />

      {/* Actions */}
      <div className="flex items-center gap-2">
        {/* Dark mode */}
        <button
          onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
          className="p-2 rounded-xl text-[var(--on-surface-faint)] hover:text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] transition-all"
          title={theme === "dark" ? "Mode clair" : "Mode sombre"}
        >
          {theme === "dark" ? <Sun size={18} /> : <Moon size={18} />}
        </button>

        {/* Notifications */}
        <Link
          href="/notifications"
          className="p-2 rounded-xl text-[var(--on-surface-faint)] hover:text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] transition-all relative"
        >
          <Bell size={18} />
        </Link>

        {/* Premium CTA (si gratuit) */}
        {tier === "free" && (
          <Link
            href="/abonnement"
            className="hidden sm:flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-gradient-to-r from-brand to-brand-mid text-white text-xs font-semibold shadow-brand hover:shadow-brand-lg transition-shadow"
          >
            <Crown size={12} />
            Premium
          </Link>
        )}

        {/* User avatar / menu */}
        <div className="relative">
          <button
            onClick={() => setMenuOpen(!menuOpen)}
            className={cn(
              "flex items-center gap-2 pl-2 pr-3 py-1.5 rounded-xl",
              "hover:bg-[var(--surface-container)] transition-colors text-sm",
              menuOpen && "bg-[var(--surface-container)]"
            )}
          >
            <div className="w-7 h-7 rounded-full bg-gradient-to-br from-brand/20 to-brand-mid/20 border border-brand/20 flex items-center justify-center">
              <UserIcon size={12} className="text-brand" />
            </div>
            <span className="hidden sm:block text-xs font-medium text-[var(--on-surface)] max-w-[120px] truncate">
              {user.email?.split("@")[0]}
            </span>
          </button>

          {/* Dropdown */}
          {menuOpen && (
            <>
              <div className="fixed inset-0 z-40" onClick={() => setMenuOpen(false)} />
              <div className="absolute right-0 top-full mt-2 w-52 rounded-xl border border-[var(--outline)] bg-[var(--surface)] shadow-card-hover z-50 overflow-hidden animate-scale-in">
                <div className="px-4 py-3 border-b border-[var(--outline)]">
                  <div className="text-xs font-medium text-[var(--on-surface)] truncate">{user.email}</div>
                  <div className="text-[10px] text-[var(--on-surface-faint)] mt-0.5">
                    {tier === "free" ? "Compte gratuit" : tier === "premium_trial" ? "Essai Premium" : "Premium"}
                  </div>
                </div>

                <div className="py-1">
                  {[
                    { label: "Mon profil", href: "/profil", icon: <UserIcon size={14} /> },
                    { label: "Paramètres", href: "/parametres", icon: <Settings size={14} /> },
                    { label: "Abonnement", href: "/abonnement", icon: <Crown size={14} /> },
                  ].map((item) => (
                    <Link
                      key={item.href}
                      href={item.href}
                      onClick={() => setMenuOpen(false)}
                      className="flex items-center gap-3 px-4 py-2.5 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] hover:bg-[var(--surface-container)] transition-colors"
                    >
                      <span className="text-[var(--on-surface-faint)]">{item.icon}</span>
                      {item.label}
                    </Link>
                  ))}
                </div>

                <div className="border-t border-[var(--outline)] py-1">
                  <button
                    onClick={handleLogout}
                    className="w-full flex items-center gap-3 px-4 py-2.5 text-sm text-danger hover:bg-danger/5 transition-colors"
                  >
                    <LogOut size={14} />
                    Se déconnecter
                  </button>
                </div>
              </div>
            </>
          )}
        </div>
      </div>
    </header>
  )
}
