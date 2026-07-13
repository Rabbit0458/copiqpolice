"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import ConcoursBlancInterface from "@/features/concours-blanc"
import { GraduationCap, Crown, Lock } from "lucide-react"

export default function ConcoursBlancPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [tier, setTier] = useState("free")
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const { data: sub } = await (supabase as any).from("cas_pratique_subscriptions").select("tier").eq("user_id", data.user.id).maybeSingle()
      setTier((sub as any)?.tier ?? "free")
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  const isPremium = tier === "premium" || tier === "premium_trial"

  if (!isPremium) return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <div className="rounded-2xl border-2 border-amber-300 dark:border-amber-700 bg-amber-50 dark:bg-amber-950/20 p-8 text-center">
        <Crown size={40} className="text-amber-500 mx-auto mb-4" />
        <h1 className="text-xl font-bold text-[var(--on-surface)] mb-2">Concours Blanc — Premium</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mb-6">Le concours blanc complet est réservé aux membres Premium.</p>
        <a href="/abonnement" className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-[#1147D9] text-white font-bold text-sm hover:bg-[#1A55E6] transition-all">
          <Crown size={15} />Passer à Premium
        </a>
      </div>
    </div>
  )

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-[var(--on-surface)] flex items-center gap-2"><GraduationCap size={24} />Concours Blanc</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mt-1">Simulation complète d'épreuve · 30 minutes · 10 questions</p>
      </div>
      <ConcoursBlancInterface userId={user!.id} />
    </div>
  )
}
