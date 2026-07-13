"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import CasPratiquesInterface from "@/features/cas-pratiques/cas-pratiques-interface"

export default function GPXCasPratiquesPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [tier, setTier] = useState("free")
  const [freeUsed, setFreeUsed] = useState(0)
  const [recentAttempts, setRecentAttempts] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const [subRes, quotaRes, attRes] = await Promise.all([
        (supabase as any).from("cas_pratique_subscriptions").select("tier").eq("user_id", data.user.id).maybeSingle(),
        (supabase as any).from("free_weekly_usage").select("request_count").eq("user_id", data.user.id).maybeSingle(),
        (supabase as any).from("cas_pratique_attempts").select("*").eq("user_id", data.user.id).order("created_at", { ascending: false }).limit(5),
      ])
      setTier(subRes.data?.tier ?? "free")
      setFreeUsed(quotaRes.data?.request_count ?? 0)
      setRecentAttempts(attRes.data ?? [])
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-[var(--on-surface)]">Cas Pratiques GPX</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mt-1">Entraînez-vous sur des cas réels de maintien de l'ordre</p>
      </div>
      <CasPratiquesInterface
        userId={user.id}
        tier={tier}
        freeUsed={freeUsed}
        freeTotal={10}
        recentAttempts={recentAttempts}
        userEmail={user.email ?? ""}
      />
    </div>
  )
}
