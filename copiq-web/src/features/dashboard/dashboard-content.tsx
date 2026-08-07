"use client"

import Link from "next/link"
import type { User } from "@supabase/supabase-js"
import { Card } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { Button } from "@/components/ui/button"
import {
  Crown, Target, GraduationCap, Brain, FileText,
  Globe, ClipboardCheck, TrendingUp, BookOpen, ArrowRight,
  Languages, StickyNote, NotebookPen, ShieldCheck
} from "lucide-react"
import { cn, TIER_LABELS } from "@/lib/utils"
import { usePathway } from "@/features/pathway/pathway-provider"
import type { PathwayIconKey } from "@/config/pathways"

interface DashboardContentProps {
  user: User
  sub: { tier: string; status: string; current_period_end: string | null; cancel_at_period_end?: boolean | null } | null
  totalXp: number
  freeQuota: { used: number; window_start: string; updated_at: string } | null
}

const moduleIcons: Record<PathwayIconKey, React.ReactNode> = {
  dashboard: <ShieldCheck size={20} />,
  graduation: <GraduationCap size={20} />,
  quiz: <Target size={20} />,
  knowledge: <Globe size={20} />,
  brain: <Brain size={20} />,
  languages: <Languages size={20} />,
  caseStudies: <FileText size={20} />,
  mockExam: <ClipboardCheck size={20} />,
  memos: <StickyNote size={20} />,
  notes: <NotebookPen size={20} />,
}

export function DashboardContent({ user, sub, totalXp, freeQuota }: DashboardContentProps) {
  const { profile, pathway, loading: pathwayLoading, error: pathwayError, refresh } = usePathway()
  const tier = sub?.tier ?? "free"
  const isPremium = tier === "premium" || tier === "premium_trial"
  const firstName = profile?.first_name?.trim() || profile?.username?.trim() || user.email?.split("@")[0] || "là"
  const used = freeQuota?.used ?? 0
  const freeLimit = 10
  const freeRemaining = Math.max(0, freeLimit - used)

  return (
    <div className="space-y-8 animate-fade-in">
      {/* En-tête */}
      <div className="flex items-start justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-2xl font-bold text-[var(--on-surface)]">Bonjour, {firstName}</h1>
          <p className="text-[var(--on-surface-muted)] mt-1">
            {pathway?.title ?? "Préparez votre prochaine session."}
          </p>
          {pathway && <Link href="/choisir-parcours" className="mt-2 inline-flex min-h-11 items-center text-sm font-semibold text-brand hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand">Changer de parcours</Link>}
        </div>
        {!isPremium && (
          <Link href="/abonnement">
            <Button variant="premium" size="sm">
              <Crown size={14} />
              Passer Premium
            </Button>
          </Link>
        )}
      </div>

      {/* Stats rapides */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        {[
          {
            label: "Points XP",
            value: totalXp.toLocaleString("fr"),
            icon: <TrendingUp size={18} />,
            color: "text-brand",
            bg: "bg-brand/10",
          },
          {
            label: "Abonnement",
            value: TIER_LABELS[tier] ?? "Gratuit",
            icon: <Crown size={18} />,
            color: isPremium ? "text-brand" : "text-[var(--on-surface-muted)]",
            bg: isPremium ? "bg-brand/10" : "bg-[var(--surface-container)]",
          },
          {
            label: "Quota semaine",
            value: isPremium ? "Illimité" : `${freeRemaining}/${freeLimit}`,
            icon: <Target size={18} />,
            color: freeRemaining > 3 ? "text-success" : "text-warning",
            bg: freeRemaining > 3 ? "bg-success/10" : "bg-warning/10",
          },
          {
            label: "Modules",
            value: pathway ? `${pathway.navigation.length} disponible${pathway.navigation.length > 1 ? "s" : ""}` : "À choisir",
            icon: <BookOpen size={18} />,
            color: "text-[var(--on-surface-muted)]",
            bg: "bg-[var(--surface-container)]",
          },
        ].map((stat) => (
          <Card key={stat.label}>
            <div className={cn("w-9 h-9 rounded-xl flex items-center justify-center mb-3", stat.bg)}>
              <span className={stat.color}>{stat.icon}</span>
            </div>
            <div className="text-lg font-bold text-[var(--on-surface)]">{stat.value}</div>
            <div className="text-xs text-[var(--on-surface-muted)] mt-0.5">{stat.label}</div>
          </Card>
        ))}
      </div>

      {/* Quota free (si gratuit) */}
      {!isPremium && (
        <Card className="border-warning/20 bg-warning/5">
          <div className="flex items-center justify-between mb-3 flex-wrap gap-2">
            <div className="flex items-center gap-2">
              <Target size={16} className="text-warning" />
              <span className="text-sm font-semibold text-[var(--on-surface)]">
                Quota hebdomadaire — Cas Pratiques
              </span>
            </div>
            <Badge variant="warning">{freeRemaining} restant{freeRemaining !== 1 ? "s" : ""}</Badge>
          </div>
          <Progress value={used} max={freeLimit} color="warning" size="md" />
          <p className="text-xs text-[var(--on-surface-muted)] mt-2">
            {used}/{freeLimit} requêtes utilisées cette semaine.{" "}
            <Link href="/abonnement" className="text-brand hover:underline font-medium">
              Passer Premium pour un accès illimité →
            </Link>
          </p>
        </Card>
      )}

      {pathwayError && (
        <Card className="border-danger/20 bg-danger/5">
          <p className="text-sm text-danger">{pathwayError.message}</p>
          <button type="button" onClick={() => void refresh()} className="mt-2 min-h-11 text-sm font-semibold text-danger hover:underline">Réessayer</button>
        </Card>
      )}

      {/* Modules du parcours actif */}
      <div>
        <div className="mb-4 flex flex-wrap items-end justify-between gap-3">
          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.14em]" style={{ color: pathway?.color }}>Votre sélection</p>
            <h2 className="mt-1 text-lg font-semibold text-[var(--on-surface)]">{pathway?.shortLabel ?? "Vos modules"}</h2>
          </div>
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {pathwayLoading && [0, 1, 2].map((item) => <div key={item} className="h-44 animate-pulse rounded-2xl bg-[var(--surface-container)]" />)}
          {pathway?.navigation.map((mod) => (
            <Link key={mod.href} href={mod.href}>
              <Card hover className="h-full">
                <div className="flex items-start justify-between mb-3">
                  <div
                    className="w-10 h-10 rounded-xl flex items-center justify-center text-white"
                    style={{ backgroundColor: pathway.color }}
                  >
                    {moduleIcons[mod.iconKey]}
                  </div>
                  <div className="flex items-center gap-1.5">
                    {mod.premium && !isPremium && (
                      <Badge variant="premium">
                        <Crown size={10} />
                        Premium
                      </Badge>
                    )}
                  </div>
                </div>
                <h3 className="font-semibold text-[var(--on-surface)] mb-1">{mod.label}</h3>
                <p className="text-xs text-[var(--on-surface-muted)] leading-relaxed">{mod.description}</p>
                <div className="flex items-center gap-1 mt-4 text-brand text-xs font-medium">
                  Accéder
                  <ArrowRight size={12} />
                </div>
              </Card>
            </Link>
          ))}
        </div>
      </div>
    </div>
  )
}
