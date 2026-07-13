"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { DashboardContent } from "@/features/dashboard/dashboard-content"

export default function DashboardPage() {
  const router = useRouter()
  const [pageData, setPageData] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data: authData }) => {
      if (!authData.user) { router.replace("/login"); return }
      const user = authData.user

      const [subRes, xpRes, quotaRes] = await Promise.all([
        (supabase as any).from("cas_pratique_subscriptions")
          .select("tier, status, current_period_end, cancel_at_period_end")
          .eq("user_id", user.id).maybeSingle(),
        (supabase as any).from("cas_pratique_xp_ledger")
          .select("points").eq("user_id", user.id),
        (supabase as any).from("free_weekly_usage")
          .select("request_count, window_start, updated_at").eq("user_id", user.id).maybeSingle(),
      ])

      const sub = subRes.data
      const totalXp = (xpRes.data ?? []).reduce((acc: number, r: any) => acc + (r.points ?? 0), 0)
      const freeQuota = quotaRes.data ? {
        used: quotaRes.data.request_count ?? 0,
        window_start: quotaRes.data.window_start,
        updated_at: quotaRes.data.updated_at ?? quotaRes.data.window_start,
      } : null

      setPageData({ user, sub, totalXp, freeQuota })
      setLoading(false)
    })
  }, [])

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" />
    </div>
  )

  return (
    <DashboardContent
      user={pageData.user}
      sub={pageData.sub}
      totalXp={pageData.totalXp}
      freeQuota={pageData.freeQuota}
    />
  )
}
