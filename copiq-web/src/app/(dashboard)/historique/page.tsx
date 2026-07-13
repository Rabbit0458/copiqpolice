"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { History, Clock, CheckCircle, XCircle } from "lucide-react"

export default function HistoriquePage() {
  const router = useRouter()
  const [attempts, setAttempts] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      const { data: att } = await (supabase as any)
        .from("cas_pratique_attempts")
        .select("*")
        .eq("user_id", data.user.id)
        .order("created_at", { ascending: false })
        .limit(20)
      setAttempts(att ?? [])
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6 flex items-center gap-2"><History size={24} />Historique</h1>
      {attempts.length === 0 ? (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-12 text-center">
          <History size={40} className="text-[var(--on-surface-faint)] mx-auto mb-3" />
          <p className="text-[var(--on-surface-muted)]">Aucune tentative pour l'instant</p>
        </div>
      ) : (
        <div className="space-y-3">
          {attempts.map((a) => (
            <div key={a.id} className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 flex items-center gap-4">
              {a.score >= 70 ? <CheckCircle size={20} className="text-emerald-500 shrink-0" /> : <XCircle size={20} className="text-red-500 shrink-0" />}
              <div className="flex-1 min-w-0">
                <p className="font-medium text-[var(--on-surface)] text-sm truncate">{a.module_id || "Cas pratique"}</p>
                <p className="text-xs text-[var(--on-surface-muted)] flex items-center gap-1 mt-0.5">
                  <Clock size={11} />{new Date(a.created_at).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })}
                </p>
              </div>
              <span className={`text-sm font-bold ${a.score >= 70 ? "text-emerald-500" : "text-red-500"}`}>{a.score ?? "-"}/100</span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
