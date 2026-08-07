"use client"

import Link from "next/link"
import {
  ArrowUpRight,
  Activity,
  BookOpenCheck,
  Bug,
  CheckCircle2,
  ClipboardCheck,
  Flag,
  GraduationCap,
  MessageSquareMore,
  RefreshCw,
  ShieldCheck,
  Sparkles,
  Users,
} from "lucide-react"
import { casPratiqueApi, supportApi } from "@/lib/admin/api"
import {
  Badge,
  Card,
  ErrorBox,
  Loading,
  PageHeader,
  Stat,
  useAsync,
} from "@/components/admin/admin-ui"

const journeys = [
  { label: "Concours Policier adjoint", short: "PA · Examen", color: "#EF4056" },
  { label: "Concours Gardien de la paix", short: "GPX · Examen", color: "#2563EB" },
  { label: "Scolarité Policier adjoint", short: "PA · École", color: "#10B981" },
  { label: "Scolarité Gardien de la paix", short: "GPX · École", color: "#8B5CF6" },
]

const shortcuts = [
  { href: "/admin/forum/", label: "Modérer le forum", hint: "Publications, signalements et sanctions", icon: MessageSquareMore },
  { href: "/admin/utilisateurs/", label: "Gérer les utilisateurs", hint: "Profils, accès et historique", icon: Users },
  { href: "/admin/quiz/", label: "Administrer les quiz", hint: "Questions et contenus pédagogiques", icon: GraduationCap },
  { href: "/admin/signalements/", label: "Traiter les alertes", hint: "File de priorité unifiée", icon: Flag },
]

export default function AdminHome() {
  const dashboard = useAsync(() => casPratiqueApi.dashboard(), [])
  const health = useAsync(() => casPratiqueApi.health(), [])
  const globalStats = useAsync(() => supportApi.dashboardStats(), [])
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
      {dashboard.loading && <Loading label="Chargement des indicateurs…" />}

      <section aria-labelledby="global-indicators-title" className="mb-6">
        <div className="mb-3 flex flex-wrap items-end justify-between gap-2">
          <div>
            <h2 id="global-indicators-title" className="text-sm font-semibold">Activité globale</h2>
            <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Données réelles de l’application et du site</p>
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
        {globalStats.loading && <GlobalStatsSkeleton />}
        {globalStats.data && (
          <div className="grid grid-cols-2 gap-3 lg:grid-cols-3 2xl:grid-cols-6">
            <GlobalMetric icon={Users} label="Utilisateurs" value={globalStats.data.users_total} hint={`${globalStats.data.users_active_30d} actifs sur 30 j`} />
            <GlobalMetric icon={Sparkles} label="Premium" value={globalStats.data.users_premium} hint={`${globalStats.data.users_trial} en essai`} tone="brand" />
            <GlobalMetric icon={Flag} label="Signalements" value={globalStats.data.forum_reports_open + globalStats.data.reports_open_cg + globalStats.data.reports_open_psy} hint="à traiter" tone={globalStats.data.forum_reports_open > 0 ? "warn" : "neutral"} href="/admin/signalements/" />
            <GlobalMetric icon={Bug} label="Bugs ouverts" value={globalStats.data.bug_reports_open} hint={`${globalStats.data.contact_open} contacts en attente`} tone={globalStats.data.bug_reports_open > 0 ? "warn" : "neutral"} href="/admin/signalements/" />
            <GlobalMetric icon={ShieldCheck} label="Équipe active" value={globalStats.data.staff_total} hint={`${globalStats.data.staff_locked} compte verrouillé`} tone={globalStats.data.staff_locked > 0 ? "warn" : "neutral"} href="/admin/administrateurs/" />
            <GlobalMetric icon={Activity} label="Audits sur 24 h" value={globalStats.data.audit_logs_24h} hint={`${globalStats.data.critical_events_7d} critique sur 7 j`} tone={globalStats.data.critical_events_7d > 0 ? "bad" : "neutral"} href="/admin/journal/" />
          </div>
        )}
      </section>

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

          <div className="grid gap-6 xl:grid-cols-[1.45fr_.8fr]">
            <Card className="overflow-hidden">
              <div className="flex items-center justify-between border-b border-[var(--outline-variant)] px-5 py-4">
                <div>
                  <h2 className="text-sm font-semibold">Les quatre parcours COP’IQ</h2>
                  <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Socle commun du futur site web</p>
                </div>
                <BookOpenCheck size={19} className="text-[var(--brand)]" />
              </div>
              <div className="grid gap-px bg-[var(--outline-variant)] sm:grid-cols-2">
                {journeys.map((journey) => (
                  <div key={journey.short} className="bg-[var(--surface)] p-5 transition hover:bg-[var(--surface-container)]">
                    <div className="mb-4 flex items-start justify-between gap-3">
                      <span className="grid h-10 w-10 place-items-center rounded-xl text-white shadow-sm" style={{ backgroundColor: journey.color }}>
                        <ClipboardCheck size={19} />
                      </span>
                      <Badge tone="brand">À porter sur le web</Badge>
                    </div>
                    <p className="text-xs font-semibold uppercase tracking-[0.12em] text-[var(--on-surface-faint)]">{journey.short}</p>
                    <h3 className="mt-1 text-sm font-semibold">{journey.label}</h3>
                  </div>
                ))}
              </div>
            </Card>

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
