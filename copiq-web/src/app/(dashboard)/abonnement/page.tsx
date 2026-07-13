"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Crown, CheckCircle, Zap } from "lucide-react"

export default function AbonnementPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [sub, setSub] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const { data: s } = await (supabase as any).from("cas_pratique_subscriptions").select("*").eq("user_id", data.user.id).maybeSingle()
      setSub(s)
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  const tier = sub?.tier ?? "free"
  const isPremium = tier === "premium" || tier === "premium_trial"

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6 flex items-center gap-2"><Crown size={24} />Abonnement</h1>
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 mb-6">
        <div className="flex items-center gap-3 mb-4">
          <div className={`w-10 h-10 rounded-full flex items-center justify-center ${isPremium ? "bg-amber-100 dark:bg-amber-950/30" : "bg-[var(--surface-variant)]"}`}>
            <Crown size={20} className={isPremium ? "text-amber-500" : "text-[var(--on-surface-muted)]"} />
          </div>
          <div>
            <p className="font-semibold text-[var(--on-surface)]">{isPremium ? "Premium" : "Gratuit"}</p>
            <p className="text-sm text-[var(--on-surface-muted)]">{isPremium ? "Accès illimité à tous les modules" : "10 cas pratiques / semaine"}</p>
          </div>
        </div>
        {sub?.current_period_end && (
          <p className="text-xs text-[var(--on-surface-faint)]">Renouvellement le {new Date(sub.current_period_end).toLocaleDateString("fr-FR")}</p>
        )}
      </div>
      {!isPremium && (
        <div className="rounded-2xl border-2 border-[#1147D9] bg-gradient-to-br from-[#1147D9]/5 to-transparent p-6">
          <div className="flex items-center gap-2 mb-4"><Zap size={18} className="text-[#1147D9]" /><span className="font-bold text-[var(--on-surface)]">Passer à Premium</span></div>
          <ul className="space-y-2 mb-6">
            {["Cas pratiques illimités", "Tous les modules de cours", "Quiz sans limite", "Concours blanc complet", "Forum en accès total"].map(f => (
              <li key={f} className="flex items-center gap-2 text-sm text-[var(--on-surface)]"><CheckCircle size={14} className="text-[#1147D9]" />{f}</li>
            ))}
          </ul>
          <a href="/api/stripe/checkout" className="block w-full text-center py-3 rounded-xl bg-[#1147D9] text-white font-bold text-sm hover:bg-[#1A55E6] transition-all">
            S'abonner — 9,99€/mois
          </a>
        </div>
      )}
      {isPremium && (
        <a href="/api/stripe/portal" className="block w-full text-center py-3 rounded-xl border border-[var(--outline)] text-[var(--on-surface-muted)] text-sm hover:border-[var(--outline-dark)] transition-all">
          Gérer mon abonnement
        </a>
      )}
    </div>
  )
}
