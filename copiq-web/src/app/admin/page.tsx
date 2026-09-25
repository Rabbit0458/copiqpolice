"use client"

import Link from "next/link"
import { useEffect, useState } from "react"
import {
  ArrowUpRight,
  Activity,
  ChartNoAxesCombined,
  Bug,
  CheckCircle2,
  Command,
  Flag,
  GraduationCap,
  MessageSquareMore,
  RefreshCw,
  ShieldCheck,
  Sparkles,
  Users,
} from "lucide-react"
import { adminAuth, casPratiqueApi, supportApi } from "@/lib/admin/api"
import { DecisionCenter } from "@/components/admin/decision-center"
import { createClient } from "@/lib/supabase/client"
import {
  Card,
  ErrorBox,
  Loading,
  PageHeader,
  Stat,
  useAsync,
} from "@/components/admin/admin-ui"

const shortcuts = [
  { href: "/admin/forum/", label: "Modérer le forum", hint: "Publications, signalements et sanctions", icon: MessageSquareMore },
  { href: "/admin/utilisateurs/", label: "Gérer les utilisateurs", hint: "Profils, accès et historique", icon: Users },
  { href: "/admin/quiz/", label: "Administrer les quiz", hint: "Questions et contenus pédagogiques", icon: GraduationCap },
  { href: "/admin/signalements/", label: "Traiter les alertes", hint: "File de priorité unifiée", icon: Flag },
]

export default function AdminHome() {
  const [poll, setPoll] = useState(0)
  useEffect(() => {
    const refresh = () => {
      if (!document.hidden) setPoll((current) => current + 1)
    }
    const interval = window.setInterval(refresh, 60_000)
    document.addEventListener("visibilitychange", refresh)
    return () => {
      window.clearInterval(interval)
      document.removeEventListener("visibilitychange", refresh)
    }
  }, [])

  useEffect(() => {
    const supabase = createClient()
    const channel = supabase
      .channel("copiq-admin-live-refresh")
      .on("postgres_changes", { event: "*", schema: "public", table: "bug_reports" }, () => setPoll((current) => current + 1))
      .on("postgres_changes", { event: "*", schema: "public", table: "contact_messages" }, () => setPoll((current) => current + 1))
      .on("postgres_changes", { event: "*", schema: "public", table: "forum_reports" }, () => setPoll((current) => current + 1))
      .on("postgres_changes", { event: "*", schema: "public", table: "admin_audit_logs" }, () => setPoll((current) => current + 1))
      .on("postgres_changes", { event: "*", schema: "public", table: "quiz_answer_history" }, () => setPoll((current) => current + 1))
      .subscribe()
    return () => {
      void supabase.removeChannel(channel)
    }
  }, [])

  const dashboard = useAsync(() => casPratiqueApi.dashboard(), [poll])
  const health = useAsync(() => casPratiqueApi.health(), [poll])
  const globalStats = useAsync(() => supportApi.dashboardStats(), [poll])
  const adminSession = useAsync(() => adminAuth.status(), [])
  const learning = useAsync(
    () => adminSession.data?.role === "owner" ? supportApi.learningAnalytics(30) : Promise.resolve(null),
    [adminSession.data?.role, poll],
  )
  const comparison = useAsync(
    () => adminSession.data?.role === "owner" ? supportApi.periodComparison(30) : Promise.resolve(null),
    [adminSession.data?.role, poll],
  )
  const critiques = (health.data ?? []).filter((item) => item.gravite === "critique").length
  const importants = (health.data ?? []).filter((item) => item.gravite === "important").length

  return (
    <>
      <PageHeader
        title="Centre de pilotage"
        subtitle="Vue opérationnelle de COP’IQ, de ses contenus et de sa communauté."
        action={<div className="flex items-center gap-2">
          <div className="inline-flex items-center gap-2 rounded-full border border-[var(--success)]/25 bg-[var(--success)]/10 px-3 py-1.5 text-xs font-semibold text-[var(--success)]">
              <span className="h-2 w-2 rounded-full bg-current shadow-[0_0_0_4px_rgba(34,197,94,.12)]" />
              Panel sécurisé
          </div>
          <button
            type="button"
            onClick={() => {
              dashboard.reload()
              health.reload()
              globalStats.reload()
              if (adminSession.data?.role === "owner") {
                learning.reload()
                comparison.reload()
              }
            }}
            disabled={dashboard.loading || health.loading || globalStats.loading}
            className="grid h-9 w-9 cursor-pointer place-items-center rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] text-[var(--on-surface-muted)] transition duration-200 hover:border-[var(--brand)]/35 hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] disabled:cursor-wait disabled:opacity-50"
            aria-label="Actualiser tous les indicateurs"
            title="Actualiser les indicateurs"
          >
            <RefreshCw size={16} className={dashboard.loading || health.loading || globalStats.loading ? "animate-spin" : ""} />
          </button>
        </div>}
      />

      {dashboard.error && <ErrorBox error={dashboard.error} />}
      {dashboard.loading && !dashboard.data && <Loading label="Chargement des indicateurs…" />}

      <section aria-labelledby="global-indicators-title" className="mb-6">
        <div className="mb-3 flex flex-wrap items-end justify-between gap-2">
          <div>
            <h2 id="global-indicators-title" className="text-sm font-semibold">Activité globale</h2>
            <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Données réelles · rafraîchissement automatique toutes les 60 secondes</p>
          </div>
          {globalStats.data?.refreshed_at && (
            <time dateTime={globalStats.data.refreshed_at} className="text-xs text-[var(--on-surface-faint)]">
              Actualisé {formatFreshness(globalStats.data.refreshed_at)}
            </time>
          )}
        </div>
        {Boolean(globalStats.error) && (
          <Card className="border-[var(--warning)]/30 bg-[var(--warning)]/5 p-4">
            <p className="text-sm font-medium text-[var(--warning)]">Les indicateurs globaux sont momentanément indisponibles.</p>
            <p className="mt-1 text-xs text-[var(--on-surface-muted)]">Les autres outils d’administration restent accessibles.</p>
          </Card>
        )}
        {globalStats.loading && !globalStats.data && <GlobalStatsSkeleton />}
        {globalStats.data && (
          <div className="grid grid-cols-2 gap-3 lg:grid-cols-3 2xl:grid-cols-6">
            <GlobalMetric icon={Users} label="Comptes inscrits" value={globalStats.data.users_total} hint={`${globalStats.data.users_active_30d} actifs sur 30 j · ${globalStats.data.users_24h} sur 24 h`} />
            <GlobalMetric icon={Sparkles} label="Premium payants" value={globalStats.data.users_premium} hint={`${globalStats.data.users_trial} essais distincts`} tone="brand" />
            <GlobalMetric icon={Flag} label="Signalements" value={globalStats.data.forum_reports_open + globalStats.data.reports_open_cg + globalStats.data.reports_open_psy} hint="à traiter" tone={globalStats.data.forum_reports_open > 0 ? "warn" : "neutral"} href="/admin/signalements/" />
            <GlobalMetric icon={Bug} label="Bugs ouverts" value={globalStats.data.bug_reports_open} hint={`${globalStats.data.contact_open} contacts en attente`} tone={globalStats.data.bug_reports_open > 0 ? "warn" : "neutral"} href="/admin/signalements/" />
            <GlobalMetric icon={ShieldCheck} label="Équipe active" value={globalStats.data.staff_total} hint={`${globalStats.data.staff_locked} compte verrouillé`} tone={globalStats.data.staff_locked > 0 ? "warn" : "neutral"} href="/admin/administrateurs/" />
            <GlobalMetric icon={Activity} label="Audits sur 24 h" value={globalStats.data.audit_logs_24h} hint={`${globalStats.data.critical_events_7d} critique sur 7 j`} tone={globalStats.data.critical_events_7d > 0 ? "bad" : "neutral"} href="/admin/journal/" />
          </div>
        )}
        {adminSession.data?.role === "owner" && <div className="mt-3 flex flex-wrap gap-2">
          <Link href="/admin/statistiques/" className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border border-[var(--brand)]/25 bg-[var(--brand)]/10 px-4 text-sm font-semibold text-[var(--brand)] transition-colors hover:bg-[var(--brand)]/15 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">
            <ChartNoAxesCombined size={17} aria-hidden="true" /> Explorer le suivi complet <ArrowUpRight size={15} aria-hidden="true" />
          </Link>
          <Link href="/admin/exploitation/" className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] px-4 text-sm font-semibold transition-colors hover:border-[var(--brand)]/35 hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">
            <Command size={17} aria-hidden="true" /> Ouvrir le centre d’exploitation <ArrowUpRight size={15} aria-hidden="true" />
          </Link>
        </div>}
      </section>

      <DecisionCenter
        globalStats={globalStats.data}
        dashboard={dashboard.data}
        health={health.data}
        learning={learning.data}
        comparison={comparison.data}
      />

      {adminSession.data?.role === "owner" && <section aria-labelledby="learning-overview-title" className="mb-7">
        <div className="mb-3 flex flex-wrap items-center justify-between gap-2"><div><h2 id="learning-overview-title" className="text-sm font-semibold">Préparation réelle · 30 jours</h2><p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">La réussite est calculée uniquement sur les réponses sauvegardées, jamais sur la longueur prévue d’une série.</p></div><Link href="/admin/statistiques/" className="inline-flex min-h-10 items-center gap-1.5 text-xs font-semibold text-[var(--brand)] hover:underline">Analyse détaillée <ArrowUpRight size={14} /></Link></div>
        {Boolean(learning.error) && <Card className="border-[var(--warning)]/30 bg-[var(--warning)]/5 p-4 text-sm text-[var(--warning)]">Les résultats pédagogiques ne sont pas disponibles pour le moment.</Card>}
        {learning.loading && !learning.data && <div className="skeleton h-44 rounded-2xl" aria-label="Chargement des résultats pédagogiques" />}
        {learning.data && <Card className="overflow-hidden border-[var(--brand)]/25 p-0">
          <div className="grid grid-cols-2 gap-px bg-[var(--outline-variant)] lg:grid-cols-4">{learning.data.journeys.map((journey) => <div key={`${journey.track}-${journey.mode}`} className="min-w-0 bg-[var(--surface)] p-4 transition-colors hover:bg-[var(--surface-container)]"><p className="truncate text-xs font-semibold text-[var(--on-surface-muted)]">{journey.label}</p><p className="mt-2 text-2xl font-semibold tabular-nums tracking-tight text-[var(--brand)]">{journey.saved >= 20 && journey.learners >= 5 && journey.accuracy !== null ? `${journey.accuracy} %` : "—"}</p><p className="mt-1 text-xs text-[var(--on-surface-muted)]">{journey.correct} / {journey.saved} réponses · {journey.learners} apprenants</p></div>)}</div>
          <div className="flex flex-wrap items-center justify-between gap-2 border-t border-[var(--outline-variant)] px-4 py-3 text-xs text-[var(--on-surface-muted)]"><span>{learning.data.summary.saved.toLocaleString("fr-FR")} réponses fournies · {learning.data.summary.learners} apprenants distincts</span><span>{learning.loading ? "Actualisation…" : `Actualisé ${formatFreshness(learning.data.refreshed_at)}`}</span></div>
        </Card>}
      </section>}

      {dashboard.data && (
        <div className="space-y-6">
          <section aria-labelledby="indicators-title">
            <div className="mb-3 flex items-center justify-between">
              <h2 id="indicators-title" className="text-sm font-semibold">Indicateurs pédagogiques</h2>
              <span className="text-xs text-[var(--on-surface-faint)]">Cas pratiques GPX</span>
            </div>
            <div className="grid grid-cols-2 gap-3 xl:grid-cols-4">
              <Stat label="Cas publiés" value={dashboard.data.cases_published} hint={`${dashboard.data.cases_total} contenus au total`} />
              <Stat label="Questions" value={dashboard.data.questions} hint="dans les cas pratiques" />
              <Stat label="Tentatives" value={dashboard.data.attempts_total} hint={`${dashboard.data.attempts_done} terminées`} />
              <Stat label="Score moyen" value={dashboard.data.avg_percent == null ? "—" : `${dashboard.data.avg_percent} %`} hint="copies finalisées" />
            </div>
          </section>

          <div className="grid gap-6">
            <Card className="p-5">
              <div className="flex items-center justify-between">
                <h2 className="text-sm font-semibold">Santé opérationnelle</h2>
                <ShieldCheck size={19} className="text-[var(--brand)]" />
              </div>
              {health.loading ? <Loading label="Analyse du contenu…" /> : (
                <div className="mt-5 space-y-3">
                  <HealthLine label="Anomalies critiques" value={critiques} danger={critiques > 0} />
                  <HealthLine label="Points importants" value={importants} danger={importants > 0} />
                  <HealthLine label="Appels en attente" value={dashboard.data.appeals_pending} danger={dashboard.data.appeals_pending > 0} />
                  <HealthLine label="Cas sans grille" value={dashboard.data.cases_sans_rubric} danger={dashboard.data.cases_sans_rubric > 0} />
                  <Link href="/admin/sante/" className="mt-2 inline-flex items-center gap-1.5 text-sm font-semibold text-[var(--brand)] hover:underline">
                    Ouvrir le diagnostic <ArrowUpRight size={15} />
                  </Link>
                </div>
              )}
            </Card>
          </div>

          <section aria-labelledby="quick-actions-title">
            <h2 id="quick-actions-title" className="mb-3 text-sm font-semibold">Actions rapides</h2>
            <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
              {shortcuts.map(({ href, label, hint, icon: Icon }) => (
                <Link key={href} href={href} className="group rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-4 transition duration-200 hover:-translate-y-0.5 hover:border-[var(--brand)]/35 hover:shadow-[0_14px_30px_rgba(15,23,42,.07)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">
                  <div className="flex items-start justify-between gap-4">
                    <span className="grid h-10 w-10 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><Icon size={19} /></span>
                    <ArrowUpRight size={17} className="text-[var(--on-surface-faint)] transition group-hover:text-[var(--brand)]" />
                  </div>
                  <h3 className="mt-4 text-sm font-semibold">{label}</h3>
                  <p className="mt-1 text-xs leading-relaxed text-[var(--on-surface-muted)]">{hint}</p>
                </Link>
              ))}
            </div>
          </section>
        </div>
      )}
    </>
  )
}

function HealthLine({ label, value, danger }: { label: string; value: number; danger: boolean }) {
  return (
    <div className="flex items-center justify-between gap-3 rounded-xl bg-[var(--surface-container)] px-3.5 py-3">
      <span className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)]">
        <CheckCircle2 size={16} className={danger ? "text-[var(--warning)]" : "text-[var(--success)]"} />
        {label}
      </span>
      <span className={`text-sm font-semibold tabular-nums ${danger ? "text-[var(--warning)]" : "text-[var(--on-surface)]"}`}>{value}</span>
    </div>
  )
}

type MetricTone = "neutral" | "brand" | "warn" | "bad"

function GlobalMetric({
  icon: Icon,
  label,
  value,
  hint,
  tone = "neutral",
  href,
}: {
  icon: typeof Users
  label: string
  value: number
  hint: string
  tone?: MetricTone
  href?: string
}) {
  const tones: Record<MetricTone, string> = {
    neutral: "bg-[var(--surface-container)] text-[var(--on-surface-muted)]",
    brand: "bg-[var(--brand)]/10 text-[var(--brand)]",
    warn: "bg-[var(--warning)]/12 text-[var(--warning)]",
    bad: "bg-[var(--danger)]/10 text-[var(--danger)]",
  }
  const content = (
    <Card className={`h-full p-4 transition duration-200 ${href ? "hover:-translate-y-0.5 hover:border-[var(--brand)]/30 hover:shadow-[0_12px_28px_rgba(15,23,42,.06)]" : ""}`}>
      <div className="flex items-start justify-between gap-3">
        <span className={`grid h-9 w-9 place-items-center rounded-xl ${tones[tone]}`}><Icon size={17} /></span>
        {href && <ArrowUpRight size={15} className="text-[var(--on-surface-faint)]" />}
      </div>
      <p className="mt-4 text-2xl font-semibold tabular-nums tracking-tight">{value.toLocaleString("fr-FR")}</p>
      <p className="mt-0.5 text-xs font-semibold">{label}</p>
      <p className="mt-1 text-[11px] text-[var(--on-surface-muted)]">{hint}</p>
    </Card>
  )
  return href ? <Link href={href} className="cursor-pointer rounded-xl focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">{content}</Link> : content
}

function GlobalStatsSkeleton() {
  return (
    <div className="grid grid-cols-2 gap-3 lg:grid-cols-3 2xl:grid-cols-6" aria-label="Chargement des statistiques globales">
      {Array.from({ length: 6 }).map((_, index) => <div key={index} className="skeleton h-36 rounded-xl" />)}
    </div>
  )
}

function formatFreshness(value: string) {
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return "récemment"
  return new Intl.DateTimeFormat("fr-FR", {
    day: "2-digit",
    month: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  }).format(date)
}
