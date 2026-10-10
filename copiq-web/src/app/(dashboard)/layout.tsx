"use client"
import { useEffect, useMemo, useState } from "react"
import { usePathname, useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Sidebar } from "@/components/layout/sidebar"
import { Header } from "@/components/layout/header"
import type { User } from "@supabase/supabase-js"
import type { CpTier } from "@/types"
import { PathwayProvider, usePathway } from "@/features/pathway/pathway-provider"
import { EntitlementProvider, useEntitlement } from "@/features/access/entitlement"

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter()
  const [user, setUser] = useState<User | null>(null)
  const [ready, setReady] = useState(false)
  const supabase = useMemo(() => createClient(), [])

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      setReady(true)
    })
  }, [router, supabase])

  if (!ready) return (
    <div className="flex h-[100dvh] items-center justify-center bg-[var(--surface-container)]">
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img src="/brand/copiq-logo.png" alt="Chargement de ton espace" width={72} height={72} className="cq-logo-breathe h-[72px] w-[72px] object-contain" />
    </div>
  )

  return (
    <EntitlementProvider>
      <PathwayProvider user={user!}>
        <DashboardShell user={user!}>{children}</DashboardShell>
      </PathwayProvider>
    </EntitlementProvider>
  )
}

function DashboardShell({ children, user }: { children: React.ReactNode; user: User }) {
  const router = useRouter()
  // Palier issu de get_my_entitlement (même verdict Premium que l'app, achats stores compris).
  const { tier } = useEntitlement() as { tier: CpTier }
  const pathname = usePathname()
  const { pathway, loading, error } = usePathway()
  const [mobileOpen, setMobileOpen] = useState(false)

  // Le menu mobile se referme à chaque changement de page.
  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setMobileOpen(false)
  }, [pathname])

  useEffect(() => {
    if (!loading && !error && !pathway && pathname !== "/choisir-parcours") {
      router.replace("/choisir-parcours")
    }
  }, [error, loading, pathway, pathname, router])

  return (
    <div className="cq-app-shell flex h-[100dvh] overflow-hidden">
      <Sidebar user={user} tier={tier} mobileOpen={mobileOpen} onClose={() => setMobileOpen(false)} />
      <div className="flex min-w-0 flex-1 flex-col overflow-hidden">
        <Header user={user} tier={tier} onOpenMenu={() => setMobileOpen(true)} />
        <main className="flex-1 overflow-y-auto">
          <div key={pathname} className="admin-page-enter mx-auto w-full max-w-[1240px] px-4 pb-8 pt-5 sm:px-6 lg:px-10 lg:pt-7">{children}</div>
        </main>
      </div>
    </div>
  )
}
