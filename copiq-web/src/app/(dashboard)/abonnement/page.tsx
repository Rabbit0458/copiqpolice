"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Crown, CheckCircle, Zap } from "lucide-react"
import toast from "react-hot-toast"

const PLANS = [
  { id: "week", label: "Semaine", price: "4,99 €", suffix: "/ semaine", recommended: false },
  { id: "month", label: "Mensuel", price: "8,99 €", suffix: "/ mois", recommended: true },
  { id: "year", label: "Annuel", price: "86,99 €", suffix: "/ an", recommended: false },
] as const

export default function AbonnementPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [sub, setSub] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [busy, setBusy] = useState<string | null>(null)
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

  async function openCheckout(plan: "week" | "month" | "year") {
    setBusy(plan)
    try {
      const { data, error } = await supabase.functions.invoke("cas_pratique_create_checkout", {
        body: {
          plan,
          success_url: `${window.location.origin}/abonnement/?success=true`,
          cancel_url: `${window.location.origin}/abonnement/?canceled=true`,
        },
      })
      if (error) throw error
      if (!data?.url) throw new Error("Lien de paiement indisponible")
      window.location.assign(data.url)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Le paiement ne peut pas être ouvert")
      setBusy(null)
    }
  }

  async function openPortal() {
    setBusy("portal")
    try {
      const { data, error } = await supabase.functions.invoke("cas_pratique_customer_portal", {
        body: { return_url: `${window.location.origin}/abonnement/` },
      })
      if (error) throw error
      if (!data?.url) throw new Error("Portail de facturation indisponible")
      window.location.assign(data.url)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Le portail ne peut pas être ouvert")
      setBusy(null)
    }
  }

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
          <div className="grid gap-3 sm:grid-cols-3">
            {PLANS.map((plan) => (
              <button key={plan.id} type="button" disabled={busy !== null}
                onClick={() => openCheckout(plan.id)}
                className={`min-h-24 cursor-pointer rounded-xl border p-3 text-left transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#1147D9] disabled:cursor-wait disabled:opacity-60 ${plan.recommended ? "border-[#1147D9] bg-[#1147D9] text-white" : "border-[var(--outline)] hover:border-[#1147D9]"}`}>
                <span className="block text-xs font-semibold opacity-80">{plan.label}</span>
                <span className="mt-1 block text-lg font-bold">{busy === plan.id ? "Ouverture…" : plan.price}</span>
                <span className="text-xs opacity-75">{plan.suffix}</span>
              </button>
            ))}
          </div>
        </div>
      )}
      {isPremium && (
        <button type="button" onClick={openPortal} disabled={busy !== null}
          className="min-h-11 w-full cursor-pointer rounded-xl border border-[var(--outline)] px-4 py-3 text-sm font-semibold text-[var(--on-surface-muted)] transition-colors hover:border-[var(--outline-dark)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#1147D9] disabled:cursor-wait disabled:opacity-60">
          {busy === "portal" ? "Ouverture…" : "Gérer mon abonnement et mes factures"}
        </button>
      )}
    </div>
  )
}
