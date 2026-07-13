"use client"
import { User } from "@supabase/supabase-js"
import { Award, BookOpen, Star, TrendingUp, Calendar, Shield, Crown } from "lucide-react"
import { getInitials, TIER_LABELS } from "@/lib/utils"

const BADGE_META: Record<string, { label: string; icon: string; color: string }> = {
  first_quiz: { label: "Premier quiz", icon: "🎯", color: "#1147D9" },
  first_cp: { label: "Premier cas pratique", icon: "📝", color: "#8B5CF6" },
  streak_7: { label: "Série 7 jours", icon: "🔥", color: "#F59E0B" },
  perfect_score: { label: "Score parfait", icon: "⭐", color: "#22C55E" },
  xp_100: { label: "100 XP", icon: "💎", color: "#06B6D4" },
  xp_500: { label: "500 XP", icon: "🏆", color: "#F97316" },
  premium: { label: "Membre Premium", icon: "👑", color: "#EAB308" },
}

const LEVEL_THRESHOLDS = [0, 100, 250, 500, 1000, 2000, 5000]
function getLevel(xp: number) {
  let level = 1
  for (let i = 0; i < LEVEL_THRESHOLDS.length; i++) {
    if (xp >= LEVEL_THRESHOLDS[i]) level = i + 1
  }
  const current = LEVEL_THRESHOLDS[Math.min(level - 1, LEVEL_THRESHOLDS.length - 1)]
  const next = LEVEL_THRESHOLDS[Math.min(level, LEVEL_THRESHOLDS.length - 1)]
  const pct = next > current ? Math.round(((xp - current) / (next - current)) * 100) : 100
  return { level, pct, next }
}

interface Props {
  user: User
  subscription: any
  xp: number
  badges: Array<{ badge_id: string; earned_at: string }>
  progress: any[]
}

export default function ProfilContent({ user, subscription, xp, badges, progress }: Props) {
  const tier = subscription?.tier ?? "free"
  const { level, pct, next } = getLevel(xp)
  const totalModules = progress.length
  const completedModules = progress.filter(p => p.completion_pct >= 100).length
  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-6">
      {/* Header card */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] overflow-hidden">
        <div className="h-24 bg-gradient-to-r from-[#000B36] to-[#1147D9]" />
        <div className="px-6 pb-6 -mt-10">
          <div className="flex items-end gap-4 flex-wrap">
            <div className="w-20 h-20 rounded-2xl bg-[#1147D9] flex items-center justify-center text-white text-2xl font-bold border-4 border-[var(--surface)] shadow-lg">
              {getInitials(user.email ?? "U")}
            </div>
            <div className="pb-1 flex-1">
              <h1 className="text-xl font-bold text-[var(--on-surface)]">{user.email}</h1>
              <div className="flex items-center gap-3 mt-1">
                <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-semibold ${tier === "premium" ? "bg-[#EAB308]/10 text-[#EAB308]" : "bg-[var(--surface-dark)] text-[var(--on-surface-muted)]"}`}>
                  {tier === "premium" && <Crown size={10} />}
                  {TIER_LABELS[tier as keyof typeof TIER_LABELS] ?? tier}
                </span>
                <span className="text-xs text-[var(--on-surface-faint)]">Niveau {level}</span>
              </div>
            </div>
          </div>
          {/* XP bar */}
          <div className="mt-4">
            <div className="flex justify-between text-xs text-[var(--on-surface-muted)] mb-1">
              <span>{xp} XP</span><span>Prochain niveau : {next} XP</span>
            </div>
            <div className="h-2 rounded-full bg-[var(--surface-dark)] overflow-hidden">
              <div className="h-full rounded-full bg-[#1147D9] transition-all" style={{ width: `${pct}%` }} />
            </div>
          </div>
        </div>
      </div>
      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        {[
          { label: "XP Total", value: xp.toLocaleString(), icon: Star, color: "#EAB308" },
          { label: "Niveau", value: level, icon: TrendingUp, color: "#1147D9" },
          { label: "Modules suivis", value: totalModules, icon: BookOpen, color: "#8B5CF6" },
          { label: "Badges", value: badges.length, icon: Award, color: "#22C55E" },
        ].map(({ label, value, icon: Icon, color }) => (
          <div key={label} className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 text-center">
            <div className="w-9 h-9 rounded-xl flex items-center justify-center mx-auto mb-2" style={{ backgroundColor: `${color}15` }}>
              <Icon size={18} style={{ color }} />
            </div>
            <div className="text-2xl font-bold text-[var(--on-surface)]">{value}</div>
            <div className="text-xs text-[var(--on-surface-faint)] mt-0.5">{label}</div>
          </div>
        ))}
      </div>
      {/* Badges */}
      {badges.length > 0 && (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
          <h2 className="font-semibold text-[var(--on-surface)] mb-4 flex items-center gap-2"><Award size={16} className="text-[#1147D9]" /> Badges obtenus</h2>
          <div className="grid grid-cols-3 sm:grid-cols-6 gap-3">
            {badges.map(b => {
              const meta = BADGE_META[b.badge_id] ?? { label: b.badge_id, icon: "🏅", color: "#1147D9" }
              return (
                <div key={b.badge_id} className="flex flex-col items-center gap-1 p-3 rounded-xl bg-[var(--surface-dark)] hover:scale-105 transition-transform">
                  <span className="text-2xl">{meta.icon}</span>
                  <span className="text-xs text-center text-[var(--on-surface-muted)] leading-tight">{meta.label}</span>
                </div>
              )
            })}
          </div>
        </div>
      )}
      {/* Progression modules */}
      {progress.length > 0 && (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
          <h2 className="font-semibold text-[var(--on-surface)] mb-4 flex items-center gap-2"><BookOpen size={16} className="text-[#1147D9]" /> Progression par module</h2>
          <div className="space-y-3">
            {progress.slice(0, 8).map((p: any) => (
              <div key={p.module_id}>
                <div className="flex justify-between text-sm text-[var(--on-surface)] mb-1">
                  <span>{p.module_id.replace(/-/g, " ").replace(/\b\w/g, (c: string) => c.toUpperCase())}</span>
                  <span className="text-[var(--on-surface-muted)]">{Math.round(p.completion_pct ?? 0)}%</span>
                </div>
                <div className="h-1.5 rounded-full bg-[var(--surface-dark)] overflow-hidden">
                  <div className="h-full rounded-full bg-[#1147D9] transition-all" style={{ width: `${p.completion_pct ?? 0}%` }} />
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
