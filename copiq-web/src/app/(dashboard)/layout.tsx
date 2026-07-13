"use client"
import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Sidebar } from "@/components/layout/sidebar"
import { Header } from "@/components/layout/header"
import type { User } from "@supabase/supabase-js"
import type { CpTier } from "@/types"

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter()
  const [user, setUser] = useState<User | null>(null)
  const [tier, setTier] = useState<CpTier>("free")
  const [ready, setReady] = useState(false)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const { data: sub } = await (supabase as any).from("cas_pratique_subscriptions")
        .select("tier").eq("user_id", data.user.id).maybeSingle()
      setTier((sub?.tier as CpTier) ?? "free")
      setReady(true)
    })
  }, [])

  if (!ready) return (
    <div className="flex h-screen items-center justify-center bg-[var(--surface)]">
      <div className="w-8 h-8 border-2 border-[#1147D9] border-t-transparent rounded-full animate-spin" />
    </div>
  )

  return (
    <div className="flex h-screen overflow-hidden bg-[var(--surface)]">
      <Sidebar user={user!} tier={tier} />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header user={user!} tier={tier} />
        <main className="flex-1 overflow-y-auto">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
            {children}
          </div>
        </main>
      </div>
    </div>
  )
}
