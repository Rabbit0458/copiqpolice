"use client"

import Link from "next/link"
import { Card } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Crown, Target, ChevronRight, BookOpen } from "lucide-react"
import type { CpTier } from "@/types"

interface QuizSelectionPageProps {
  track: "pa" | "gpx"
  tier: CpTier
}

const PA_MODULES = [
  { id: "droit-penal", label: "Droit Pénal Général", count: 120, isPremium: false },
  { id: "procedure-penale", label: "Procédure Pénale", count: 150, isPremium: false },
  { id: "institutions", label: "Institutions & Valeurs", count: 80, isPremium: false },
  { id: "cadres-juridiques", label: "Cadres Juridiques", count: 200, isPremium: true },
  { id: "intervention", label: "Policier & Intervention", count: 180, isPremium: true },
  { id: "circulation", label: "Circulation Routière", count: 100, isPremium: true },
  { id: "armes", label: "Armes & Munitions", count: 60, isPremium: true },
  { id: "mineurs", label: "Mineurs & Famille", count: 80, isPremium: true },
  { id: "atteintes-personnes", label: "Atteintes aux Personnes", count: 120, isPremium: true },
  { id: "atteintes-biens", label: "Atteintes aux Biens", count: 90, isPremium: true },
  { id: "stupefiants", label: "Stupéfiants", count: 70, isPremium: true },
  { id: "libertes", label: "Libertés Publiques", count: 100, isPremium: true },
]

const GPX_MODULES = [
  { id: "culture-generale", label: "Culture Générale", count: 500, isPremium: false },
  { id: "droit-penal", label: "Droit Pénal Général", count: 120, isPremium: false },
  { id: "procedure-penale", label: "Procédure Pénale", count: 150, isPremium: false },
  { id: "institutions", label: "Institutions & Valeurs", count: 80, isPremium: false },
  { id: "cadres-juridiques", label: "Cadres Juridiques", count: 200, isPremium: true },
  { id: "intervention", label: "Policier & Intervention", count: 180, isPremium: true },
  { id: "psychotechniques", label: "Psychotechniques", count: 300, isPremium: true },
  { id: "langues", label: "Langues Étrangères", count: 150, isPremium: true },
  { id: "armes", label: "Armes & Munitions", count: 60, isPremium: true },
  { id: "stupefiants", label: "Stupéfiants", count: 70, isPremium: true },
  { id: "circulation", label: "Circulation Routière", count: 100, isPremium: true },
  { id: "mineurs", label: "Mineurs & Famille", count: 80, isPremium: true },
]

const MODULE_COLORS: Record<string, string> = {
  "culture-generale": "#F59E0B",
  "droit-penal": "#1147D9",
  "procedure-penale": "#22C55E",
  "institutions": "#0EA5E9",
  "cadres-juridiques": "#22C55E",
  "intervention": "#EF4444",
  "psychotechniques": "#A855F7",
  "langues": "#06B6D4",
  "armes": "#64748B",
  "stupefiants": "#F97316",
  "circulation": "#06B6D4",
  "mineurs": "#A855F7",
  "libertes": "#0EA5E9",
  "atteintes-personnes": "#EF4444",
  "atteintes-biens": "#F59E0B",
}

export function QuizSelectionPage({ track, tier }: QuizSelectionPageProps) {
  const isPremium = tier === "premium" || tier === "premium_trial"
  const modules = track === "pa" ? PA_MODULES : GPX_MODULES
  const trackLabel = track === "pa" ? "Policier Adjoint" : "Gardien de la Paix"

  const free = modules.filter((m) => !m.isPremium)
  const premium = modules.filter((m) => m.isPremium)

  return (
    <div className="space-y-8 animate-fade-in max-w-4xl">
      <div>
        <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-1">
          Quiz — {trackLabel}
        </h1>
        <p className="text-[var(--on-surface-muted)]">
          {modules.reduce((acc, m) => acc + m.count, 0).toLocaleString("fr")} questions réparties en {modules.length} modules
        </p>
      </div>

      {/* Modules gratuits */}
      <div>
        <h2 className="text-sm font-semibold text-[var(--on-surface-muted)] uppercase tracking-wider mb-3">
          Accès libre
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {free.map((mod) => (
            <Link key={mod.id} href={`/${track}/quiz/${mod.id}`}>
              <Card hover>
                <div className="flex items-center gap-4">
                  <div
                    className="w-10 h-10 rounded-xl flex items-center justify-center text-white shrink-0"
                    style={{ backgroundColor: MODULE_COLORS[mod.id] ?? "#1147D9" }}
                  >
                    <Target size={18} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-medium text-[var(--on-surface)] text-sm truncate">{mod.label}</div>
                    <div className="text-xs text-[var(--on-surface-faint)] mt-0.5">{mod.count} questions</div>
                  </div>
                  <ChevronRight size={16} className="text-[var(--on-surface-faint)] shrink-0" />
                </div>
              </Card>
            </Link>
          ))}
        </div>
      </div>

      {/* Modules premium */}
      <div>
        <div className="flex items-center gap-3 mb-3">
          <h2 className="text-sm font-semibold text-[var(--on-surface-muted)] uppercase tracking-wider">
            Premium
          </h2>
          {!isPremium && (
            <Link
              href="/abonnement"
              className="flex items-center gap-1.5 text-xs font-semibold text-brand hover:text-brand-mid transition-colors"
            >
              <Crown size={12} />
              Débloquer tout
            </Link>
          )}
        </div>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {premium.map((mod) => {
            const locked = !isPremium
            return locked ? (
              <div key={mod.id}>
                <Card className="opacity-60 cursor-default">
                  <div className="flex items-center gap-4">
                    <div
                      className="w-10 h-10 rounded-xl flex items-center justify-center text-white shrink-0"
                      style={{ backgroundColor: MODULE_COLORS[mod.id] ?? "#1147D9" }}
                    >
                      <BookOpen size={18} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="font-medium text-[var(--on-surface)] text-sm truncate">{mod.label}</div>
                      <div className="text-xs text-[var(--on-surface-faint)] mt-0.5">{mod.count} questions</div>
                    </div>
                    <Crown size={14} className="text-warning shrink-0" />
                  </div>
                </Card>
              </div>
            ) : (
              <Link key={mod.id} href={`/${track}/quiz/${mod.id}`}>
                <Card hover>
                  <div className="flex items-center gap-4">
                    <div
                      className="w-10 h-10 rounded-xl flex items-center justify-center text-white shrink-0"
                      style={{ backgroundColor: MODULE_COLORS[mod.id] ?? "#1147D9" }}
                    >
                      <Target size={18} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="font-medium text-[var(--on-surface)] text-sm truncate">{mod.label}</div>
                      <div className="text-xs text-[var(--on-surface-faint)] mt-0.5">{mod.count} questions</div>
                    </div>
                    <ChevronRight size={16} className="text-[var(--on-surface-faint)] shrink-0" />
                  </div>
                </Card>
              </Link>
            )
          })}
        </div>
      </div>
    </div>
  )
}
