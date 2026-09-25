"use client"

import Link from "next/link"
import {
  ArrowRight,
  CheckCircle2,
  EyeOff,
  Info,
  ShieldAlert,
  Sparkles,
} from "lucide-react"
import { useMemo, useState } from "react"
import type {
  AdminDashboardStats,
  AdminLearningAnalytics,
  AdminPeriodComparison,
  AdminPeriodComparisonMetric,
  CpDashboard,
  CpHealthRow,
} from "@/lib/admin/api"
import { Card } from "@/components/admin/admin-ui"

type AlertLevel = "critical" | "attention" | "info" | "good"

type DecisionAlert = {
  id: string
  level: AlertLevel
  title: string
  detail: string
  href?: string
}

type DecisionCenterProps = {
  globalStats: AdminDashboardStats | null
  dashboard: CpDashboard | null
  health: CpHealthRow[] | null
  learning: AdminLearningAnalytics | null
  comparison: AdminPeriodComparison | null
}

const DISMISSED_KEY = "copiq_admin_decision_center_dismissed"
const DISMISS_TTL = 24 * 60 * 60 * 1000

export function DecisionCenter({ globalStats, dashboard, health, learning, comparison }: DecisionCenterProps) {
  const [dismissed, setDismissed] = useState<Record<string, number>>(() => readDismissed())
  const alerts = useMemo(
    () => buildAlerts({ globalStats, dashboard, health, learning, comparison }),
    [globalStats, dashboard, health, learning, comparison],
  )

  const visible = alerts.filter((alert) => !dismissed[alert.id])
  const attention = visible.filter((alert) => alert.level === "critical" || alert.level === "attention")
  const positive = visible.filter((alert) => alert.level === "good")
  const informational = visible.filter((alert) => alert.level === "info")
  const hasSourceData = Boolean(globalStats || dashboard || health || learning || comparison)

  if (!hasSourceData) return null

  function dismiss(id: string) {
    const next = { ...dismissed, [id]: Date.now() }
    setDismissed(next)
    try {
      window.localStorage.setItem(DISMISSED_KEY, JSON.stringify(next))
    } catch {
      // Rien à faire : la donnée reste affichée lors du prochain rendu.
    }
  }

  return (
    <section aria-labelledby="decision-center-title" className="mb-7">
      <div className="mb-3 flex flex-wrap items-end justify-between gap-2">
        <div>
          <div className="flex items-center gap-2">
            <h2 id="decision-center-title" className="text-sm font-semibold">Centre de décisions</h2>
            {attention.length > 0 && <span className="rounded-full bg-[var(--warning)]/12 px-2 py-0.5 text-[11px] font-semibold text-[var(--warning)]">{attention.length} à surveiller</span>}
          </div>
          <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Les alertes sont calculées à partir des données disponibles et ouvrent directement l’action concernée.</p>
        </div>
        {Object.keys(dismissed).length > 0 && (
          <button type="button" onClick={() => { setDismissed({}); window.localStorage.removeItem(DISMISSED_KEY) }} className="inline-flex min-h-10 cursor-pointer items-center gap-1.5 rounded-xl border border-[var(--outline-variant)] px-3 text-xs font-semibold text-[var(--on-surface-muted)] transition hover:border-[var(--brand)]/40 hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">
            Réafficher les alertes
          </button>
        )}
      </div>

      <Card className="overflow-hidden p-0">
        <div className="grid divide-y divide-[var(--outline-variant)] lg:grid-cols-3 lg:divide-x lg:divide-y-0">
          <DecisionColumn title="À surveiller" count={attention.length} level="attention" alerts={attention} onDismiss={dismiss} />
          <DecisionColumn title="En amélioration" count={positive.length} level="good" alerts={positive} onDismiss={dismiss} />
          <DecisionColumn title="Stable / information" count={informational.length} level="info" alerts={informational} onDismiss={dismiss} />
        </div>
      </Card>
    </section>
  )
}

function DecisionColumn({ title, count, level, alerts, onDismiss }: { title: string; count: number; level: AlertLevel; alerts: DecisionAlert[]; onDismiss: (id: string) => void }) {
  const Icon = level === "attention" ? ShieldAlert : level === "good" ? Sparkles : Info
  return (
    <div className="min-w-0 p-4 md:p-5">
      <div className="flex items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <span className={`grid h-8 w-8 place-items-center rounded-xl ${levelClasses(level).icon}`}><Icon size={16} aria-hidden="true" /></span>
          <h3 className="text-sm font-semibold">{title}</h3>
        </div>
        <span className={`text-lg font-semibold tabular-nums ${levelClasses(level).text}`}>{count}</span>
      </div>
      {alerts.length === 0 ? (
        <div className="mt-4 flex items-center gap-2 rounded-xl bg-[var(--surface-container)] px-3 py-3 text-xs text-[var(--on-surface-muted)]">
          <CheckCircle2 size={15} className="text-[var(--success)]" aria-hidden="true" /> Rien de nouveau dans cette catégorie.
        </div>
      ) : (
        <div className="mt-4 space-y-2">
          {alerts.slice(0, 4).map((alert) => <AlertRow key={alert.id} alert={alert} onDismiss={onDismiss} />)}
          {alerts.length > 4 && <p className="px-1 text-[11px] text-[var(--on-surface-faint)]">+ {alerts.length - 4} autre{alerts.length - 4 > 1 ? "s" : ""} alerte{alerts.length - 4 > 1 ? "s" : ""}</p>}
        </div>
      )}
    </div>
  )
}

function AlertRow({ alert, onDismiss }: { alert: DecisionAlert; onDismiss: (id: string) => void }) {
  const content = (
    <div className="flex min-w-0 items-start gap-2.5">
      <span className={`mt-0.5 h-2 w-2 shrink-0 rounded-full ${levelClasses(alert.level).dot}`} aria-hidden="true" />
      <span className="min-w-0 flex-1"><span className="block text-xs font-semibold">{alert.title}</span><span className="mt-0.5 block text-[11px] leading-relaxed text-[var(--on-surface-muted)]">{alert.detail}</span></span>
      {alert.href && <ArrowRight size={14} className="mt-1 shrink-0 text-[var(--on-surface-faint)]" aria-hidden="true" />}
    </div>
  )
  return (
    <div className="group rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/60 p-3 transition duration-200 hover:border-[var(--brand)]/35">
      {alert.href ? <Link href={alert.href} className="block rounded-lg focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">{content}</Link> : content}
      <button type="button" onClick={() => onDismiss(alert.id)} className="mt-2 inline-flex min-h-8 cursor-pointer items-center gap-1 text-[10px] font-medium text-[var(--on-surface-faint)] opacity-0 transition group-hover:opacity-100 focus-visible:opacity-100 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"><EyeOff size={12} aria-hidden="true" /> Masquer 24 h</button>
    </div>
  )
}

function buildAlerts({ globalStats, dashboard, health, learning, comparison }: DecisionCenterProps): DecisionAlert[] {
  const alerts: DecisionAlert[] = []
  const add = (alert: Omit<DecisionAlert, "id"> & { id: string }) => alerts.push(alert)

  const criticalHealth = (health ?? []).filter((item) => item.gravite === "critique").length
  const importantHealth = (health ?? []).filter((item) => item.gravite === "important").length
  if (criticalHealth > 0) add({ id: `health-critical-${criticalHealth}`, level: "critical", title: `${criticalHealth} anomalie${criticalHealth > 1 ? "s" : ""} critique${criticalHealth > 1 ? "s" : ""}`, detail: "Un contenu nécessite une correction avant publication ou utilisation.", href: "/admin/sante/" })
  else if (importantHealth > 0) add({ id: `health-important-${importantHealth}`, level: "attention", title: `${importantHealth} point${importantHealth > 1 ? "s" : ""} important${importantHealth > 1 ? "s" : ""}`, detail: "La santé éditoriale signale des vérifications à effectuer.", href: "/admin/sante/" })

  if (globalStats) {
    const reports = globalStats.forum_reports_open + globalStats.reports_open_cg + globalStats.reports_open_psy
    if (reports > 0) add({ id: `reports-${reports}`, level: "attention", title: `${reports} signalement${reports > 1 ? "s" : ""} en attente`, detail: "Ouvrir la file unifiée de traitement.", href: "/admin/signalements/" })
    if (globalStats.bug_reports_open > 0) add({ id: `bugs-${globalStats.bug_reports_open}`, level: "critical", title: `${globalStats.bug_reports_open} bug${globalStats.bug_reports_open > 1 ? "s" : ""} ouvert${globalStats.bug_reports_open > 1 ? "s" : ""}`, detail: `${globalStats.contact_open} demande${globalStats.contact_open > 1 ? "s" : ""} de contact en attente.`, href: "/admin/signalements/?kind=bug" })
    if (globalStats.staff_locked > 0) add({ id: `staff-locked-${globalStats.staff_locked}`, level: "attention", title: `${globalStats.staff_locked} compte administrateur verrouillé`, detail: "Vérifier l’équipe et les accès.", href: "/admin/administrateurs/" })
    if (globalStats.critical_events_7d > 0) add({ id: `audit-critical-${globalStats.critical_events_7d}`, level: "critical", title: `${globalStats.critical_events_7d} événement${globalStats.critical_events_7d > 1 ? "s" : ""} critique${globalStats.critical_events_7d > 1 ? "s" : ""}`, detail: "Consulter le journal d’audit pour qualifier l’incident.", href: "/admin/journal/?severity=critical" })
    if (globalStats.users_total > 0 && globalStats.users_24h === 0) add({ id: "activity-zero-24h", level: "info", title: "Aucune activité identifiée sur 24 h", detail: "Le chiffre reflète uniquement les événements d’activité enregistrés.", href: "/admin/statistiques/#activity-title" })
    else if (globalStats.users_24h > 0) add({ id: `activity-${globalStats.users_24h}`, level: "good", title: `${globalStats.users_24h} utilisateur${globalStats.users_24h > 1 ? "s" : ""} actif${globalStats.users_24h > 1 ? "s" : ""} sur 24 h`, detail: "Activité réelle détectée sur l’application.", href: "/admin/statistiques/#activity-title" })
  }

  if (dashboard?.appeals_pending) add({ id: `appeals-${dashboard.appeals_pending}`, level: "attention", title: `${dashboard.appeals_pending} appel${dashboard.appeals_pending > 1 ? "s" : ""} élève à examiner`, detail: "Les validations peuvent enrichir la grille de correction.", href: "/admin/appels/" })
  if (dashboard && dashboard.cases_sans_rubric === 0 && dashboard.questions_sans_modele === 0) add({ id: "content-ready", level: "good", title: "Contenus prêts à l’utilisation", detail: "Aucun cas sans grille ni question sans modèle n’est remonté." })

  if (learning) {
    const enough = learning.summary.saved >= 20 && learning.summary.learners >= 5
    if (enough && learning.summary.accuracy !== null && learning.summary.accuracy >= 70) add({ id: `accuracy-${learning.summary.accuracy}`, level: "good", title: `Réussite moyenne à ${learning.summary.accuracy} %`, detail: "Calculée uniquement sur les réponses sauvegardées.", href: "/admin/statistiques/#learning-title" })
    else if (!enough) add({ id: `sample-${learning.summary.saved}-${learning.summary.learners}`, level: "info", title: "Échantillon pédagogique encore limité", detail: `${learning.summary.saved} réponses et ${learning.summary.learners} apprenant${learning.summary.learners > 1 ? "s" : ""} · les pourcentages restent masqués.`, href: "/admin/statistiques/#learning-title" })
  }

  if (comparison) {
    addTrendAlert(alerts, {
      id: "trend-active-users",
      metric: comparison.metrics.active_users,
      label: "l’activité",
      noun: "utilisateurs actifs",
      minimumVolume: 10,
      href: "/admin/statistiques/#comparison-title",
    })
    addTrendAlert(alerts, {
      id: "trend-answers-saved",
      metric: comparison.metrics.answers_saved,
      label: "les réponses sauvegardées",
      noun: "réponses",
      minimumVolume: 20,
      href: "/admin/statistiques/#comparison-title",
    })
    addTrendAlert(alerts, {
      id: "trend-incidents",
      metric: comparison.metrics.incident_events,
      label: "les incidents techniques",
      noun: "incidents",
      minimumVolume: 5,
      inverse: true,
      href: "/admin/statistiques/#comparison-title",
    })
  }

  return alerts
}

function addTrendAlert(alerts: DecisionAlert[], options: {
  id: string
  metric: AdminPeriodComparisonMetric
  label: string
  noun: string
  minimumVolume: number
  inverse?: boolean
  href: string
}) {
  const { metric, inverse = false } = options
  const volume = metric.current + metric.previous
  const change = metric.change_pct
  if (volume < options.minimumVolume || change === null || Math.abs(change) < 20) return

  const growing = change > 0
  const favorable = inverse ? !growing : growing
  const movement = growing ? "hausse" : "baisse"
  alerts.push({
    id: `${options.id}-${metric.current}-${metric.previous}`,
    level: favorable ? "good" : inverse && growing && Math.abs(change) >= 50 ? "critical" : "attention",
    title: `${favorable ? "Amélioration" : "À surveiller"} : ${options.label}`,
    detail: `${movement[0].toUpperCase()}${movement.slice(1)} de ${Math.abs(change).toLocaleString("fr-FR", { maximumFractionDigits: 1 })} % · ${metric.current.toLocaleString("fr-FR")} ${options.noun} contre ${metric.previous.toLocaleString("fr-FR")} sur la période précédente.`,
    href: options.href,
  })
}

function levelClasses(level: AlertLevel) {
  if (level === "critical") return { icon: "bg-[var(--danger)]/12 text-[var(--danger)]", text: "text-[var(--danger)]", dot: "bg-[var(--danger)]" }
  if (level === "attention") return { icon: "bg-[var(--warning)]/12 text-[var(--warning)]", text: "text-[var(--warning)]", dot: "bg-[var(--warning)]" }
  if (level === "good") return { icon: "bg-[var(--success)]/12 text-[var(--success)]", text: "text-[var(--success)]", dot: "bg-[var(--success)]" }
  return { icon: "bg-[var(--brand)]/10 text-[var(--brand)]", text: "text-[var(--brand)]", dot: "bg-[var(--brand)]" }
}

function readDismissed(): Record<string, number> {
  if (typeof window === "undefined") return {}
  try {
    const raw = window.localStorage.getItem(DISMISSED_KEY)
    if (!raw) return {}
    const parsed = JSON.parse(raw) as Record<string, number>
    const active = Object.fromEntries(Object.entries(parsed).filter(([, timestamp]) => Date.now() - timestamp < DISMISS_TTL))
    window.localStorage.setItem(DISMISSED_KEY, JSON.stringify(active))
    return active
  } catch {
    return {}
  }
}
