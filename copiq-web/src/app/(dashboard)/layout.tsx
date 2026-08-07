"use client"
import { useEffect, useMemo, useState } from "react"
import { usePathname, useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Sidebar } from "@/components/layout/sidebar"
import { Header } from "@/components/layout/header"
import type { User } from "@supabase/supabase-js"
import type { CpTier } from "@/types"
import { PathwayProvider, usePathway } from "@/features/pathway/pathway-provider"

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter()
  const [user, setUser] = useState<User | null>(null)
  const [tier, setTier] = useState<CpTier>("free")
  const [ready, setReady] = useState(false)
  const supabase = useMemo(() => createClient(), [])

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const { data: sub } = await supabase.from("cas_pratique_subscriptions")
        .select("tier").eq("user_id", data.user.id).maybeSingle()
      setTier((sub?.tier as CpTier) ?? "free")
      setReady(true)
    })
  }, [router, supabase])

  if (!ready) return (
    <div className="flex h-screen items-center justify-center bg-[var(--surface)]">
      <div className="w-8 h-8 border-2 border-[#1147D9] border-t-transparent rounded-full animate-spin" />
    </div>
  )

  return (
    <PathwayProvider user={user!}>
      <DashboardShell user={user!} tier={tier}>{children}</DashboardShell>
    </PathwayProvider>
  )
}

function DashboardShell({ children, user, tier }: { children: React.ReactNode; user: User; tier: CpTier }) {
  const router = useRouter()
  const pathname = usePathname()
  const { pathway, loading, error } = usePathway()
  const [mobileOpen, setMobileOpen] = useState(false)

  useEffect(() => {
    if (!loading && !error && !pathway && pathname !== "/choisir-parcours") {
      router.replace("/choisir-parcours")
    }
  }, [error, loading, pathway, pathname, router])

  return (
    <div className="flex h-screen overflow-hidden bg-[var(--surface)]">
      <Sidebar user={user} tier={tier} mobileOpen={mobileOpen} onClose={() => setMobileOpen(false)} />
      <div className="flex min-w-0 flex-1 flex-col overflow-hidden">
        <Header user={user} tier={tier} onOpenMenu={() => setMobileOpen(true)} />
        <main className="flex-1 overflow-y-auto">
          <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">{children}</div>
        </main>
      </div>
    </div>
  )
}
