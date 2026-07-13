"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { TrendingUp, Target, CheckCircle, Star } from "lucide-react"

export default function ProgressionPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [stats, setStats] = useState({ quizCompleted: 0, casCompleted: 0, xpTotal: 0, streak: 0 })
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const [quiz, cas, profile] = await Promise.all([
        (supabase as any).from("quiz_attempts").select("id", { count: "exact" }).eq("user_id", data.user.id),
        (supabase as any).from("cas_pratique_attempts").select("id", { count: "exact" }).eq("user_id", data.user.id),
        (supabase as any).from("profiles").select("xp_total, streak_days").eq("id", data.user.id).maybeSingle(),
      ])
      setStats({
        quizCompleted: quiz.count ?? 0,
        casCompleted: cas.count ?? 0,
        xpTotal: profile.data?.xp_total ?? 0,
        streak: profile.data?.streak_days ?? 0,
      })
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  const cards = [
    { icon: <Target size={22} className="text-[#1147D9]" />, label: "Quiz réussis", value: stats.quizCompleted, color: "bg-blue-50 dark:bg-blue-950/20" },
    { icon: <CheckCircle size={22} className="text-emerald-500" />, label: "Cas pratiques", value: stats.casCompleted, color: "bg-emerald-50 dark:bg-emerald-950/20" },
    { icon: <Star size={22} className="text-amber-500" />, label: "XP Total", value: stats.xpTotal, color: "bg-amber-50 dark:bg-amber-950/20" },
    { icon: <TrendingUp size={22} className="text-violet-500" />, label: "Série actuelle", value: `${stats.streak} j`, color: "bg-violet-50 dark:bg-violet-950/20" },
  ]

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6">Ma Progression</h1>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        {cards.map(c => (
          <div key={c.label} className={`rounded-2xl border border-[var(--outline)] p-5 ${c.color}`}>
            <div className="mb-3">{c.icon}</div>
            <p className="text-2xl font-bold text-[var(--on-surface)]">{c.value}</p>
            <p className="text-xs text-[var(--on-surface-muted)] mt-1">{c.label}</p>
          </div>
        ))}
      </div>
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <h2 className="font-semibold text-[var(--on-surface)] mb-4">Niveau</h2>
        <div className="flex items-center gap-3">
          <span className="text-3xl font-bold text-[#1147D9]">Niv. {Math.floor(stats.xpTotal / 100) + 1}</span>
          <div className="flex-1">
            <div className="h-2 rounded-full bg-[var(--outline)] overflow-hidden">
              <div className="h-full rounded-full bg-[#1147D9] transition-all" style={{ width: `${(stats.xpTotal % 100)}%` }} />
            </div>
            <p className="text-xs text-[var(--on-surface-muted)] mt-1">{stats.xpTotal % 100} / 100 XP pour le prochain niveau</p>
          </div>
        </div>
      </div>
    </div>
  )
}
