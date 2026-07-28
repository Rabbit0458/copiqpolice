"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import Link from "next/link"
import { Brain, Calculator, Layers, Lightbulb, ChevronRight, Trophy, Clock, Zap, Eye, Award } from "lucide-react"

// ─── TYPES & CONSTANTS ────────────────────────────────────────────────────────
const LEVELS = ["debutant", "intermediaire", "expert"] as const
type Level = (typeof LEVELS)[number]

const LEVEL_LABELS: Record<Level, string> = {
  debutant:      "Débutant",
  intermediaire: "Inter",
  expert:        "Expert",
}

const TYPES = [
  {
    id: "calcul",
    label: "Calcul mental",
    Icon: Calculator,
    iconColor: "#1147D9",
    description: "Additions, soustractions, multiplications rapides et pourcentages sous chrono.",
    bg: "bg-blue-50 dark:bg-blue-950/20",
    border: "border-blue-200 dark:border-blue-800/40",
  },
  {
    id: "suites-logiques",
    label: "Suites logiques",
    Icon: Layers,
    iconColor: "#8B5CF6",
    description: "Séries arithmétiques, géométriques, Fibonacci et motifs mixtes à compléter.",
    bg: "bg-violet-50 dark:bg-violet-950/20",
    border: "border-violet-200 dark:border-violet-800/40",
  },
  {
    id: "raisonnement",
    label: "Raisonnement",
    Icon: Lightbulb,
    iconColor: "#F59E0B",
    description: "Syllogismes, déductions logiques et raisonnement juridique appliqué.",
    bg: "bg-amber-50 dark:bg-amber-950/20",
    border: "border-amber-200 dark:border-amber-800/40",
  },
] as const

interface BestScore {
  score: number
  total: number
  date:  string
}

// ─── UTILS ────────────────────────────────────────────────────────────────────
function getRelativeDate(isoDate: string): string {
  const diff = Date.now() - new Date(isoDate).getTime()
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  if (days === 0) return "Aujourd'hui"
  if (days === 1) return "Hier"
  return `Il y a ${days} jours`
}

// ─── PAGE ─────────────────────────────────────────────────────────────────────
export default function PsychotechniquesPage() {
  const router = useRouter()
  const [loading,    setLoading]    = useState(true)
  const [bestScores, setBestScores] = useState<Record<string, BestScore | null>>({})
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) { router.replace("/login"); return }

      // Lecture des meilleurs scores depuis localStorage
      const scores: Record<string, BestScore | null> = {}
      TYPES.forEach(t => {
        LEVELS.forEach(lvl => {
          const key = `copiq_psycho_best_${t.id}_${lvl}`
          const raw = localStorage.getItem(key)
          scores[`${t.id}_${lvl}`] = raw ? (JSON.parse(raw) as BestScore) : null
        })
      })
      setBestScores(scores)
      setLoading(false)
    })
  }, []) // eslint-disable-line

  // Dernier score par niveau pour un type
  function getScoreForLevel(typeId: string, lvl: Level): BestScore | null {
    return bestScores[`${typeId}_${lvl}`] ?? null
  }

  // Meilleur score global pour un type (parmi tous les niveaux)
  function getBestForType(typeId: string): { score: number; total: number; level: Level } | null {
    let best: { score: number; total: number; level: Level } | null = null
    LEVELS.forEach(lvl => {
      const s = getScoreForLevel(typeId, lvl)
      if (!s) return
      const pct = s.score / s.total
      if (!best || pct > best.score / best.total) {
        best = { score: s.score, total: s.total, level: lvl }
      }
    })
    return best
  }

  // Dernière date jouée pour un type
  function getLastPlayed(typeId: string): string {
    const dates = LEVELS
      .map(lvl => getScoreForLevel(typeId, lvl)?.date)
      .filter((d): d is string => Boolean(d))
    if (dates.length === 0) return "Jamais joué"
    const latest = dates.reduce((a, b) => (new Date(a) > new Date(b) ? a : b))
    return getRelativeDate(latest)
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]"/>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">

      {/* ── En-tête ── */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-[var(--on-surface)] flex items-center gap-3">
          <Brain size={28} className="text-[#1147D9]"/>
          Psychotechniques
        </h1>
        <p className="text-[var(--on-surface-muted)] mt-2 max-w-xl">
          Exercices chronométrés pour développer rapidité mentale et logique — essentiels aux concours de police.
        </p>
      </div>

      {/* ── Cartes de types ── */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-5 mb-10">
        {TYPES.map(t => {
          const { Icon, iconColor } = t
          const best       = getBestForType(t.id)
          const lastPlayed = getLastPlayed(t.id)
          const bestPct    = best ? Math.round((best.score / best.total) * 100) : null

          return (
            <div key={t.id} className={`rounded-2xl border ${t.border} ${t.bg} p-5 flex flex-col gap-4`}>

              {/* Icône + titre */}
              <div className="flex items-start gap-3">
                <div className="rounded-xl p-2.5 shrink-0" style={{ backgroundColor: `${iconColor}18` }}>
                  <Icon size={22} style={{ color: iconColor }}/>
                </div>
                <div>
                  <p className="font-bold text-[var(--on-surface)] leading-tight">{t.label}</p>
                  <p className="text-xs text-[var(--on-surface-muted)] mt-0.5 leading-snug">{t.description}</p>
                </div>
              </div>

              {/* Bandeau niveaux */}
              <div>
                <p className="text-[10px] font-semibold text-[var(--on-surface-muted)] uppercase tracking-wide mb-1.5">
                  Niveaux
                </p>
                <div className="flex gap-1.5">
                  {LEVELS.map(lvl => {
                    const s   = getScoreForLevel(t.id, lvl)
                    const pct = s ? Math.round((s.score / s.total) * 100) : null
                    return (
                      <div
                        key={lvl}
                        className="flex-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)]/70 px-2 py-1.5 text-center"
                      >
                        <p className="text-[10px] font-semibold text-[var(--on-surface-muted)]">
                          {LEVEL_LABELS[lvl]}
                        </p>
                        {pct !== null ? (
                          <p
                            className="text-xs font-bold mt-0.5"
                            style={{ color: pct >= 80 ? "#22C55E" : pct >= 60 ? "#F59E0B" : "#EF4444" }}
                          >
                            {pct}%
                          </p>
                        ) : (
                          <p className="text-[10px] text-[var(--on-surface-muted)] mt-0.5">—</p>
                        )}
                      </div>
                    )
                  })}
                </div>
              </div>

              {/* Stats */}
              <div className="space-y-1">
                <div className="flex items-center gap-1.5 text-xs text-[var(--on-surface-muted)]">
                  <Trophy size={11}/>
                  {bestPct !== null ? (
                    <span>
                      Meilleur : <span className="font-bold text-[var(--on-surface)]">{bestPct}%</span>
                      {" "}({LEVEL_LABELS[best!.level]})
                    </span>
                  ) : (
                    <span>Pas encore joué</span>
                  )}
                </div>
                <div className="flex items-center gap-1.5 text-xs text-[var(--on-surface-muted)]">
                  <Clock size={11}/>
                  <span>{lastPlayed}</span>
                </div>
              </div>

              {/* Bouton Jouer */}
              <Link
                href={`/psychotechniques/${t.id}`}
                className="mt-auto flex items-center justify-center gap-2 rounded-xl py-3 font-bold text-sm text-white transition-all hover:opacity-90 active:scale-95"
                style={{ backgroundColor: iconColor }}
              >
                Jouer <ChevronRight size={14}/>
              </Link>
            </div>
          )
        })}
      </div>

      {/* ── Pourquoi les psychotechniques ? ── */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
        <h2 className="text-lg font-bold text-[var(--on-surface)] mb-5">
          Pourquoi les psychotechniques ?
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
          <div className="flex items-start gap-3">
            <div className="rounded-lg p-2 bg-[#1147D9]/10 shrink-0">
              <Zap size={18} className="text-[#1147D9]"/>
            </div>
            <div>
              <p className="font-semibold text-[var(--on-surface)] text-sm">Rapidité d&apos;exécution</p>
              <p className="text-xs text-[var(--on-surface-muted)] mt-1 leading-relaxed">
                Les concours de police testent votre capacité à traiter l&apos;information rapidement et précisément sous contrainte temporelle.
              </p>
            </div>
          </div>
          <div className="flex items-start gap-3">
            <div className="rounded-lg p-2 bg-[#8B5CF6]/10 shrink-0">
              <Eye size={18} className="text-[#8B5CF6]"/>
            </div>
            <div>
              <p className="font-semibold text-[var(--on-surface)] text-sm">Attention & concentration</p>
              <p className="text-xs text-[var(--on-surface-muted)] mt-1 leading-relaxed">
                Les suites logiques entraînent la mémoire de travail et l&apos;attention soutenue, qualités indispensables au métier de policier.
              </p>
            </div>
          </div>
          <div className="flex items-start gap-3">
            <div className="rounded-lg p-2 bg-[#22C55E]/10 shrink-0">
              <Award size={18} className="text-[#22C55E]"/>
            </div>
            <div>
              <p className="font-semibold text-[var(--on-surface)] text-sm">Concours Police Nationale</p>
              <p className="text-xs text-[var(--on-surface-muted)] mt-1 leading-relaxed">
                Présentes dans tous les concours (Gardien, OPJ, Officier), les épreuves psychotechniques représentent un coefficient déterminant.
              </p>
            </div>
          </div>
        </div>
      </div>

    </div>
  )
}
