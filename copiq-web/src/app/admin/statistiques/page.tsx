"use client";

import { useEffect, useState } from "react";
import {
  Activity,
  ArrowDownRight,
  ArrowUpRight,
  BarChart3,
  ChartNoAxesCombined,
  CircleHelp,
  Clock3,
  CreditCard,
  DatabaseZap,
  GraduationCap,
  MessageSquareMore,
  Minus,
  RefreshCw,
  ShieldAlert,
  Smartphone,
  Users,
} from "lucide-react";
import { supportApi, type AdminAppAnalytics, type AdminCommunityAnalytics, type AdminLearningAnalytics, type AdminPeriodComparison, type AdminPeriodComparisonMetric, type AdminQualityAnalytics } from "@/lib/admin/api";
import { Card, ErrorBox, Loading, PageHeader, useAsync } from "@/components/admin/admin-ui";

const integer = (value: number) => new Intl.NumberFormat("fr-FR").format(value);
const dateLabel = (value: string) => new Intl.DateTimeFormat("fr-FR", { day: "numeric", month: "short" }).format(new Date(`${value}T12:00:00`));
const freshness = (value: string) => new Intl.DateTimeFormat("fr-FR", { dateStyle: "short", timeStyle: "short", timeZone: "Europe/Paris" }).format(new Date(value));

export default function AppStatisticsPage() {
  const [days, setDays] = useState<7 | 30 | 90>(30);
  const [poll, setPoll] = useState(0);

  useEffect(() => {
    const refresh = () => { if (!document.hidden) setPoll((current) => current + 1); };
    const interval = window.setInterval(refresh, 60_000);
    document.addEventListener("visibilitychange", refresh);
    return () => {
      window.clearInterval(interval);
      document.removeEventListener("visibilitychange", refresh);
    };
  }, []);

  const analytics = useAsync(() => supportApi.appAnalytics(days), [days, poll]);
  const comparison = useAsync(() => supportApi.periodComparison(days), [days, poll]);
  const learning = useAsync(() => supportApi.learningAnalytics(days), [days, poll]);
  const quality = useAsync(() => supportApi.qualityAnalytics(days), [days, poll]);
  const community = useAsync(() => supportApi.communityAnalytics(days), [days, poll]);
  // Keep the previous numbers while refreshing the same period, but never
  // display 30-day values under a newly selected 7-day heading (or vice versa).
  const report = analytics.data?.days === days ? analytics.data : null;
  const comparisonData = comparison.data?.days === days ? comparison.data : null;
  const outcomes = learning.data?.days === days ? learning.data : null;
  const diagnostics = quality.data?.days === days ? quality.data : null;
  const communityData = community.data?.days === days ? community.data : null;
  const initialLoading = !report && !comparisonData && !outcomes && !diagnostics && !communityData &&
    (analytics.loading || comparison.loading || learning.loading || quality.loading || community.loading);

  return (
    <>
      <PageHeader
        title="Statistiques de l’application"
        subtitle="Comprendre l’usage réel de COP’IQ, parcours par parcours."
        action={<button type="button" onClick={() => { analytics.reload(); comparison.reload(); learning.reload(); quality.reload(); community.reload(); }} disabled={analytics.loading || comparison.loading || learning.loading || quality.loading || community.loading} aria-label="Actualiser les statistiques" className="flex min-h-11 items-center gap-2 rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] px-4 text-sm font-semibold text-[var(--on-surface)] transition hover:border-[var(--brand)]/40 hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] disabled:opacity-50"><RefreshCw size={16} className={analytics.loading || comparison.loading || learning.loading || quality.loading || community.loading ? "motion-safe:animate-spin" : ""} /> Actualiser</button>}
      />

      <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
        <div className="inline-flex rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-1" role="group" aria-label="Période d’analyse">
          {([7, 30, 90] as const).map((period) => <button key={period} type="button" onClick={() => setDays(period)} aria-pressed={days === period} className={`min-h-10 rounded-xl px-4 text-sm font-semibold transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${days === period ? "bg-[var(--brand)] text-white" : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container-hi)]"}`}>{period} jours</button>)}
        </div>
        <div className="flex flex-wrap items-center gap-3">
          {report && outcomes && <button type="button" onClick={() => exportDailyCsv(report, outcomes)} className="min-h-10 rounded-xl border border-[var(--outline-variant)] px-3 text-xs font-semibold text-[var(--on-surface)] transition hover:border-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">Exporter les tendances CSV</button>}
          {report && <span className="inline-flex items-center gap-2 text-xs text-[var(--on-surface-muted)]"><Clock3 size={14} /> Mis à jour {freshness(report.refreshed_at)} · automatique toutes les 60 secondes</span>}
        </div>
      </div>

      <nav aria-label="Sections du tableau de bord" className="mb-6 flex gap-2 overflow-x-auto pb-1 text-xs font-semibold">
        {[["#learning-title", "Préparation"], ["#activity-title", "Activité"], ["#growth-title", "Croissance"], ["#journeys-title", "Parcours"], ["#billing-title", "Abonnements"], ["#quality-title", "Qualité"], ["#community-title", "Communauté"]].map(([href, label]) => <a key={href} href={href} className="whitespace-nowrap rounded-full border border-[var(--outline-variant)] bg-[var(--surface)] px-4 py-2 text-[var(--on-surface-muted)] transition hover:border-[var(--brand)]/40 hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]">{label}</a>)}
      </nav>

      {analytics.error && <ErrorBox error={analytics.error} />}
      {comparison.error && <ErrorBox error={comparison.error} />}
      {learning.error && <ErrorBox error={learning.error} />}
      {quality.error && <ErrorBox error={quality.error} />}
      {community.error && <ErrorBox error={community.error} />}
      {initialLoading && <Loading label="Analyse des données réelles de COP’IQ…" />}
      {report && outcomes && diagnostics && <ExecutiveInsights activity={report} learning={outcomes} quality={diagnostics} />}
      {comparisonData && <PeriodComparison report={comparisonData} refreshing={comparison.loading} />}
      {outcomes && <LearningSection report={outcomes} days={days} refreshing={learning.loading} />}
      {report && <div className={`space-y-7 transition-opacity ${analytics.loading ? "opacity-60" : "opacity-100"}`}>
        <section aria-labelledby="activity-title">
          <SectionTitle id="activity-title" icon={Activity} title="Activité & préparation" description="Utilisateurs distincts pour l’activité, volumes pour les exercices." />
          <div className="grid grid-cols-2 gap-3 lg:grid-cols-3 2xl:grid-cols-6">
            <Metric label="Actifs aujourd’hui" value={report.engagement.active_1d} hint="app ouverte ou navigation" />
            <Metric label="Actifs sur 7 jours" value={report.engagement.active_7d} hint="personnes distinctes" />
            <Metric label="Actifs sur 30 jours" value={report.engagement.active_30d} hint="personnes distinctes" />
            <Metric label={`Sessions enregistrées · ${days} j`} value={report.engagement.logged_sessions} hint="identifiants de session" />
            <Metric label={`Quiz lancés · ${days} j`} value={report.engagement.quiz_sessions} hint={`${integer(report.engagement.quiz_learners)} apprenants distincts`} />
            <Metric label={`Réponses sauvegardées · ${days} j`} value={report.engagement.answers_saved} hint="réponses effectivement fournies" />
          </div>
          <p className="mt-3 text-xs text-[var(--on-surface-muted)]"><CircleHelp size={13} className="mr-1 inline" />{report.activity_definition}. Les chiffres d’utilisateurs actifs ne comptent pas les seuls renouvellements de connexion.</p>
        </section>

        <div className="grid gap-5 xl:grid-cols-[minmax(0,1.5fr)_minmax(320px,1fr)]">
          <Card className="overflow-hidden p-5 md:p-6">
            <SectionTitle icon={ChartNoAxesCombined} title="Évolution quotidienne" description={`Activité, quiz et nouveaux comptes sur les ${days} derniers jours.`} />
            <DailyChart daily={report.daily} />
          </Card>
          <Card className="p-5 md:p-6">
            <SectionTitle icon={Users} title="Rétention après inscription" description="Toutes les cohortes depuis le lancement · retour exactement à J+1, J+7 ou J+30." />
            <div className="space-y-3">
              {report.retention.map((item) => <div key={item.day} className="rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] p-4">
                <div className="flex items-center justify-between gap-3"><span className="text-sm font-semibold">J+{item.day}</span><span className={`text-lg font-semibold tabular-nums ${item.eligible < 5 ? "text-[var(--on-surface-muted)]" : "text-[var(--brand)]"}`}>{item.eligible < 5 ? "Échantillon insuffisant" : `${item.rate ?? 0} %`}</span></div>
                <p className="mt-1 text-xs text-[var(--on-surface-muted)]">{integer(item.returned)} retours sur {integer(item.eligible)} inscriptions observables</p>
                {item.eligible >= 5 && <div className="mt-3 h-1.5 overflow-hidden rounded-full bg-[var(--surface-container-hi)]"><div className="h-full rounded-full bg-[var(--brand)]" style={{ width: `${Math.min(item.rate ?? 0, 100)}%` }} /></div>}
              </div>)}
            </div>
            <p className="mt-4 text-xs text-[var(--on-surface-muted)]">La rétention est calculée sur les cohortes assez anciennes pour atteindre chaque jour. Sous 5 personnes, le pourcentage n’est pas présenté comme fiable.</p>
          </Card>
        </div>

        <div className="grid gap-5 xl:grid-cols-2">
          <Card className="p-5 md:p-6">
          <SectionTitle id="growth-title" icon={BarChart3} title="Parcours d’adoption" description="Depuis le lancement : compte créé, usage de l’app et du quiz ; abonnement actuel." />
            <Funnel report={report} />
            <p className="mt-5 rounded-xl border border-[var(--warning)]/20 bg-[var(--warning)]/5 p-3 text-xs text-[var(--on-surface-muted)]">Ces étapes représentent des groupes d’utilisateurs qui se recoupent, et non une chronologie d’achats. Un abonnement Premium actif ne prouve pas qu’il a été acheté après un quiz.</p>
          </Card>
          <Card className="p-5 md:p-6">
            <SectionTitle id="journeys-title" icon={GraduationCap} title="Les cinq parcours" description="Choix actuel ; historique des quiz depuis le lancement, tous niveaux confondus." />
            <div className="space-y-2">
              {report.journeys.map((journey) => <div key={`${journey.track}-${journey.mode}`} className="grid grid-cols-[minmax(0,1fr)_auto] items-center gap-3 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] p-3.5 sm:grid-cols-[minmax(0,1fr)_auto_auto]">
                <span className="min-w-0 text-sm font-semibold">{journey.label}</span>
                <span className="text-right text-xs text-[var(--on-surface-muted)]"><b className="block text-base text-[var(--on-surface)]">{integer(journey.current_users)}</b>comptes actuels</span>
                <span className="col-span-2 text-xs text-[var(--on-surface-muted)] sm:col-span-1 sm:text-right"><b className="mr-1 text-[var(--on-surface)]">{integer(journey.quiz_sessions)}</b>quiz · {integer(journey.quiz_learners)} apprenants</span>
              </div>)}
            </div>
            <p className="mt-4 text-xs text-[var(--on-surface-muted)]">Un utilisateur peut changer de parcours. Le choix actuel est instantané ; les quiz sont un historique et un même apprenant peut apparaître dans plusieurs parcours.</p>
          </Card>
        </div>

        <div className="grid gap-5 xl:grid-cols-2">
          <Card className="p-5 md:p-6">
            <SectionTitle icon={Smartphone} title="Plateformes & navigation" description={`Usage identifié sur les ${days} derniers jours.`} />
            <div className="mb-5 grid grid-cols-2 gap-3">
              {(["ios", "android"] as const).map((name) => { const platform = report.platforms.find((entry) => entry.platform === name); return <div key={name} className="rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] p-4"><p className="text-xs font-semibold uppercase tracking-wide text-[var(--on-surface-muted)]">{name === "ios" ? "iOS" : "Android"}</p><p className="mt-1 text-2xl font-semibold tabular-nums">{integer(platform?.users ?? 0)}</p><p className="text-xs text-[var(--on-surface-muted)]">utilisateurs · {integer(platform?.sessions ?? 0)} sessions</p></div>; })}
            </div>
            <p className="mb-3 text-xs text-[var(--on-surface-muted)]">Une personne utilisant les deux appareils peut être comptée sur chaque plateforme.</p>
            <h3 className="mb-2 text-sm font-semibold">Écrans les plus visités</h3>
            {report.top_content.length === 0 ? <p className="text-sm text-[var(--on-surface-muted)]">Aucune navigation enregistrée sur cette période.</p> : <div className="overflow-x-auto"><table className="w-full text-left text-xs"><thead><tr className="border-b border-[var(--outline-variant)] text-[var(--on-surface-faint)]"><th className="py-2 pr-3 font-medium">Écran</th><th className="py-2 text-right font-medium">Vues</th><th className="py-2 text-right font-medium">Personnes</th></tr></thead><tbody>{report.top_content.map((content) => <tr key={content.route} className="border-b border-[var(--outline-variant)]/60 last:border-0"><td className="max-w-[260px] truncate py-2.5 pr-3" title={content.route}>{content.route}</td><td className="py-2.5 text-right tabular-nums">{integer(content.views)}</td><td className="py-2.5 text-right tabular-nums">{integer(content.users)}</td></tr>)}</tbody></table></div>}
          </Card>
          <Card className="p-5 md:p-6">
            <SectionTitle id="billing-title" icon={CreditCard} title="Abonnement & exercices" description="États actuels des abonnements et volumes d’usage." />
            <div className="grid grid-cols-2 gap-3">
              <SmallValue label="Premium payants actifs" value={report.engagement.paid_active} />
              <SmallValue label="Essais actifs" value={report.engagement.trials_active} />
              <SmallValue label={`Cas pratiques · ${days} j`} value={report.engagement.practical_attempts} />
              <SmallValue label={`Visiteurs du paywall · ${days} j`} value={report.engagement.paywall_visitors} />
            </div>
            {report.stores.length > 0 && <div className="mt-5"><h3 className="mb-2 text-sm font-semibold">Origine des Premium actifs</h3>{report.stores.map((store) => <div key={store.store} className="flex justify-between border-b border-[var(--outline-variant)]/60 py-2 text-xs last:border-0"><span className="text-[var(--on-surface-muted)]">{store.store}</span><span className="font-semibold tabular-nums">{integer(store.paid_active)}</span></div>)}</div>}
            <p className="mt-4 text-xs text-[var(--on-surface-muted)]">Ces nombres sont des statuts d’abonnement, pas des ventes ni du chiffre d’affaires.</p>
          </Card>
        </div>

        {diagnostics && <QualitySection report={diagnostics} />}
        {communityData && <CommunitySection report={communityData} />}

        <Card className="border-[var(--brand)]/20 bg-[var(--brand)]/5 p-5 md:p-6">
          <SectionTitle icon={CircleHelp} title="Mesures à instrumenter avant de les afficher" description="Aucun chiffre n’est estimé ou inventé." />
          <div className="grid gap-3 text-sm md:grid-cols-3">
            <p><b className="block">Chiffre d’affaires</b><span className="text-[var(--on-surface-muted)]">Nécessite les transactions validées et remboursements des boutiques.</span></p>
            <p><b className="block">Canal d’acquisition</b><span className="text-[var(--on-surface-muted)]">Nécessite un suivi explicite des campagnes et liens entrants.</span></p>
            <p><b className="block">Durée réelle des sessions</b><span className="text-[var(--on-surface-muted)]">Nécessite des événements d’entrée, de sortie et de reprise fiables.</span></p>
          </div>
          <p className="mt-4 text-xs text-[var(--on-surface-muted)]">Ce tableau présente uniquement des statistiques agrégées ; aucun profil individuel ni adresse e-mail n’est exposé ici.</p>
        </Card>
      </div>}
    </>
  );
}

function ExecutiveInsights({ activity, learning, quality }: { activity: AdminAppAnalytics; learning: AdminLearningAnalytics; quality: AdminQualityAnalytics }) {
  const j7 = activity.retention.find((item) => item.day === 7);
  const weakest = learning.difficulty.filter((item) => item.saved >= 20 && item.learners >= 5).sort((a, b) => (a.accuracy ?? 100) - (b.accuracy ?? 100))[0];
  const errorSessions = quality.summary.sessions > 0 ? Math.round(1000 * quality.summary.affected_sessions / quality.summary.sessions) / 10 : null;
  const insights = [
    { icon: Users, title: "Retour à J+7", value: j7 && j7.eligible >= 20 ? `${j7.rate ?? 0} %` : "—", detail: j7 ? `${integer(j7.returned)} retours sur ${integer(j7.eligible)} inscriptions observables` : "Cohorte non disponible", href: "#growth-title" },
    { icon: GraduationCap, title: "Difficulté à travailler", value: weakest?.label ?? "—", detail: weakest ? `${weakest.accuracy ?? 0} % de réussite · ${integer(weakest.saved)} réponses` : "Pas assez de réponses et d’apprenants", href: "#learning-title" },
    { icon: ShieldAlert, title: "Sessions avec erreur", value: errorSessions === null ? "—" : `${errorSessions} %`, detail: `${integer(quality.summary.affected_sessions)} sur ${integer(quality.summary.sessions)} sessions identifiées`, href: "#quality-title" },
  ];
  return <section aria-label="Points à examiner" className="mb-7 overflow-hidden rounded-[24px] border border-[var(--brand)]/25 bg-[linear-gradient(135deg,color-mix(in_srgb,var(--brand)_10%,var(--surface)),var(--surface))] p-5 md:p-6">
    <div className="mb-4 flex flex-wrap items-end justify-between gap-3"><div><p className="text-[11px] font-bold uppercase tracking-[.16em] text-[var(--brand)]">Lecture rapide</p><h2 className="mt-1 text-lg font-semibold tracking-tight">Les signaux à examiner</h2></div><p className="max-w-md text-xs text-[var(--on-surface-muted)]">Des observations, pas des causes établies. Ouvre chaque section pour voir son dénominateur et sa méthode.</p></div>
    <div className="grid gap-3 md:grid-cols-3">{insights.map(({ icon: Icon, title, value, detail, href }) => <a href={href} key={title} className="group min-w-0 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-4 transition duration-200 motion-safe:hover:-translate-y-0.5 hover:border-[var(--brand)]/35 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"><span className="inline-flex items-center gap-2 text-xs font-semibold text-[var(--on-surface-muted)]"><Icon size={16} className="text-[var(--brand)]" />{title}</span><strong className="mt-3 block truncate text-2xl font-semibold tabular-nums tracking-tight text-[var(--on-surface)]">{value}</strong><span className="mt-1 block text-xs text-[var(--on-surface-muted)]">{detail}</span></a>)}</div>
  </section>;
}

function PeriodComparison({ report, refreshing }: { report: AdminPeriodComparison; refreshing: boolean }) {
  const [clock, setClock] = useState(0);
  useEffect(() => {
    const updateClock = () => setClock(Date.now());
    updateClock();
    const interval = window.setInterval(updateClock, 60_000);
    return () => window.clearInterval(interval);
  }, [report.refreshed_at]);
  const metrics: Array<{
    key: keyof AdminPeriodComparison["metrics"];
    label: string;
    description: string;
    lowerIsBetter?: boolean;
  }> = [
    { key: "active_users", label: "Utilisateurs actifs", description: "personnes distinctes" },
    { key: "registrations", label: "Nouveaux comptes", description: "inscriptions" },
    { key: "quiz_sessions", label: "Quiz lancés", description: "sessions de quiz" },
    { key: "answers_saved", label: "Réponses sauvegardées", description: "questions traitées" },
    { key: "correct_answers", label: "Bonnes réponses", description: "réponses correctes" },
    { key: "community_contributions", label: "Contributions", description: "publications, commentaires et messages" },
    { key: "incident_events", label: "Incidents consignés", description: "production iOS et Android", lowerIsBetter: true },
  ];
  const ageMinutes = Math.max(0, Math.floor(((clock || new Date(report.refreshed_at).getTime()) - new Date(report.refreshed_at).getTime()) / 60_000));
  const freshnessState = ageMinutes <= 5
    ? { label: "Données à jour", tone: "text-[var(--success)] border-[var(--success)]/25 bg-[var(--success)]/5" }
    : ageMinutes <= 15
      ? { label: `Retard léger · ${ageMinutes} min`, tone: "text-[var(--warning)] border-[var(--warning)]/25 bg-[var(--warning)]/5" }
      : { label: `Actualisation en retard · ${ageMinutes} min`, tone: "text-[var(--danger)] border-[var(--danger)]/25 bg-[var(--danger)]/5" };

  return <section aria-labelledby="comparison-title" aria-busy={refreshing} className="mb-8 space-y-4">
    <div className="flex flex-wrap items-end justify-between gap-3">
      <SectionTitle id="comparison-title" icon={BarChart3} title="Évolution par rapport à la période précédente" description={`Deux fenêtres consécutives de ${report.days} jours, calculées avec les mêmes règles.`} />
      <span role="status" className={`inline-flex min-h-9 items-center gap-2 rounded-full border px-3 text-xs font-semibold ${freshnessState.tone}`}><DatabaseZap size={14} />{refreshing ? "Actualisation…" : freshnessState.label}</span>
    </div>
    <Card className="overflow-hidden p-0">
      <div className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)] px-4 py-3 text-xs text-[var(--on-surface-muted)] md:flex md:items-center md:justify-between md:px-5">
        <span><b className="text-[var(--on-surface)]">Actuelle :</b> {periodLabel(report.current_start, report.current_end)}</span>
        <span className="mt-1 block md:mt-0"><b className="text-[var(--on-surface)]">Précédente :</b> {periodLabel(report.previous_start, report.previous_end)}</span>
      </div>
      <div className="grid gap-px bg-[var(--outline-variant)] sm:grid-cols-2 xl:grid-cols-4">
        {metrics.map((item) => <ComparisonMetric key={item.key} metric={report.metrics[item.key]} label={item.label} description={item.description} lowerIsBetter={item.lowerIsBetter} />)}
      </div>
      <p className="border-t border-[var(--outline-variant)] px-4 py-3 text-xs text-[var(--on-surface-muted)] md:px-5">{report.definition} Une variation est signalée comme limitée quand les deux périodes cumulent moins de cinq événements.</p>
    </Card>
  </section>;
}

function ComparisonMetric({ metric, label, description, lowerIsBetter = false }: { metric: AdminPeriodComparisonMetric; label: string; description: string; lowerIsBetter?: boolean }) {
  const limited = metric.current + metric.previous < 5;
  const direction = metric.delta === 0 ? "flat" : metric.delta > 0 ? "up" : "down";
  const favorable = direction === "flat" ? null : lowerIsBetter ? direction === "down" : direction === "up";
  const Icon = direction === "up" ? ArrowUpRight : direction === "down" ? ArrowDownRight : Minus;
  const tone = limited || favorable === null
    ? "text-[var(--on-surface-muted)] bg-[var(--surface-container-hi)]"
    : favorable
      ? "text-[var(--success)] bg-[var(--success)]/8"
      : "text-[var(--danger)] bg-[var(--danger)]/8";
  const change = metric.change_pct === null
    ? metric.current > 0 && metric.previous === 0 ? "Nouvelle activité" : "Stable"
    : `${metric.change_pct > 0 ? "+" : ""}${new Intl.NumberFormat("fr-FR", { maximumFractionDigits: 1 }).format(metric.change_pct)} %`;

  return <article className="min-w-0 bg-[var(--surface)] p-4 md:p-5">
    <p className="min-h-8 text-[11px] font-semibold uppercase leading-tight tracking-wide text-[var(--on-surface-muted)]">{label}</p>
    <div className="mt-2 flex items-end justify-between gap-3">
      <strong className="text-3xl font-semibold tabular-nums tracking-tight">{integer(metric.current)}</strong>
      <span className={`inline-flex min-h-7 items-center gap-1 rounded-full px-2 text-[11px] font-bold tabular-nums ${tone}`}><Icon size={13} />{limited ? "Volume limité" : change}</span>
    </div>
    <p className="mt-2 text-xs text-[var(--on-surface-muted)]">Avant : <b className="text-[var(--on-surface)]">{integer(metric.previous)}</b> · {description}</p>
  </article>;
}

function periodLabel(start: string, exclusiveEnd: string) {
  const formatter = new Intl.DateTimeFormat("fr-FR", { day: "numeric", month: "short", timeZone: "Europe/Paris" });
  const end = new Date(new Date(exclusiveEnd).getTime() - 1);
  return `${formatter.format(new Date(start))} – ${formatter.format(end)}`;
}

function QualitySection({ report }: { report: AdminQualityAnalytics }) {
  const s = report.summary;
  const max = Math.max(...report.daily.map((day) => day.incidents), 1);
  return <section aria-labelledby="quality-title" className="space-y-4">
    <SectionTitle id="quality-title" icon={ShieldAlert} title="Qualité de l’application" description={`Production iOS et Android · ${report.days} jours · erreurs consignées, sans messages bruts.`} />
    <Card className="overflow-hidden p-0"><div className="grid grid-cols-2 gap-px bg-[var(--outline-variant)] md:grid-cols-4">
      {[
        { label: "Sessions observées", value: s.sessions, hint: "avec identifiant" },
        { label: "Sessions avec erreur", value: s.affected_sessions, hint: "sessions distinctes" },
        { label: "Personnes touchées", value: s.affected_users, hint: "utilisateurs distincts" },
        { label: "Incidents consignés", value: s.incident_events, hint: "plusieurs possibles par session" },
      ].map((item) => <div key={item.label} className="bg-[var(--surface)] p-4 md:p-5"><p className="text-[11px] font-semibold uppercase tracking-wide text-[var(--on-surface-muted)]">{item.label}</p><p className="mt-2 text-2xl font-semibold tabular-nums">{integer(item.value)}</p><p className="mt-1 text-xs text-[var(--on-surface-muted)]">{item.hint}</p></div>)}
    </div></Card>
    <div className="grid gap-4 xl:grid-cols-[minmax(0,1.2fr)_minmax(300px,1fr)]">
      <Card className="p-5 md:p-6"><h3 className="text-sm font-semibold">Évolution des incidents</h3><p className="mt-1 text-xs text-[var(--on-surface-muted)]">Une barre par jour avec des journaux enregistrés.</p>
        <div role="img" aria-label="Histogramme quotidien des incidents consignés" className="mt-5 flex h-36 items-end gap-1 overflow-x-auto pb-1">{report.daily.map((day) => <div key={day.date} title={`${dateLabel(day.date)} : ${day.incidents} incidents, ${day.affected_users} personnes`} className="group flex h-full min-w-[6px] flex-1 items-end"><div className={`w-full rounded-t-sm motion-safe:transition-[height] motion-safe:duration-500 ${day.incidents ? "bg-[var(--warning)] group-hover:bg-[var(--brand)]" : "bg-[var(--surface-container-hi)]"}`} style={{ height: `${Math.max(4, day.incidents / max * 100)}%` }} /></div>)}</div>
        <details className="mt-3 text-xs text-[var(--on-surface-muted)]"><summary className="cursor-pointer font-semibold text-[var(--on-surface)]">Voir les valeurs quotidiennes</summary><div className="mt-2 max-h-48 overflow-auto"><table className="w-full"><thead><tr><th className="py-1 text-left">Date</th><th className="text-right">Incidents</th><th className="text-right">Personnes</th></tr></thead><tbody>{report.daily.map((day) => <tr key={day.date} className="border-t border-[var(--outline-variant)]/60"><td className="py-1">{dateLabel(day.date)}</td><td className="text-right tabular-nums">{integer(day.incidents)}</td><td className="text-right tabular-nums">{integer(day.affected_users)}</td></tr>)}</tbody></table></div></details>
      </Card>
      <Card className="p-5 md:p-6"><h3 className="text-sm font-semibold">Versions utilisées</h3><p className="mt-1 text-xs text-[var(--on-surface-muted)]">Une personne peut avoir utilisé plusieurs versions.</p><div className="mt-4 space-y-1">{report.versions.map((item) => <div key={item.version} className="flex justify-between gap-3 border-b border-[var(--outline-variant)]/60 py-2 text-xs last:border-0"><span className="font-semibold">{item.version}</span><span className="text-right text-[var(--on-surface-muted)]">{integer(item.users)} utilisateurs · {integer(item.incidents)} incidents</span></div>)}</div>
        <h3 className="mt-5 text-sm font-semibold">Par plateforme</h3><div className="mt-2 space-y-1">{report.platforms.map((item) => <div key={item.platform} className="flex justify-between gap-3 border-b border-[var(--outline-variant)]/60 py-2 text-xs last:border-0"><span className="font-semibold">{item.platform === "ios" ? "iOS" : "Android"}</span><span className="text-right text-[var(--on-surface-muted)]">{integer(item.affected_users)} / {integer(item.users)} personnes · {integer(item.incidents)} incidents</span></div>)}</div>
        {report.os_versions.length > 0 && <><h3 className="mt-5 text-sm font-semibold">Versions du système</h3><p className="mt-1 text-xs text-[var(--on-surface-muted)]">Seuls les groupes d’au moins cinq personnes sont détaillés.</p><div className="mt-2 space-y-1">{report.os_versions.map((item) => <div key={`${item.platform}-${item.os_version}`} className="flex justify-between gap-3 border-b border-[var(--outline-variant)]/60 py-2 text-xs last:border-0"><span className="font-semibold">{item.platform === "ios" ? "iOS" : "Android"} {item.os_version}</span><span className="text-right text-[var(--on-surface-muted)]">{integer(item.affected_users)} / {integer(item.users)} personnes</span></div>)}</div></>}
        <p className="mt-4 rounded-xl bg-[var(--warning)]/5 p-3 text-xs text-[var(--on-surface-muted)]">{report.definition}</p>
      </Card>
    </div>
  </section>;
}

function CommunitySection({ report }: { report: AdminCommunityAnalytics }) {
  const s = report.summary;
  const items = [
    { label: "Publications", value: s.new_posts, hint: "nouvelles et visibles" },
    { label: "Commentaires", value: s.new_comments, hint: "publiés" },
    { label: "Réactions", value: s.new_reactions, hint: "sur contenus visibles" },
    { label: "Messages", value: s.new_messages, hint: "publiés" },
    { label: "Contributeurs", value: s.contributors, hint: "personnes distinctes" },
    { label: "Espaces actifs", value: s.active_spaces, hint: "état actuel" },
  ];
  return <section aria-labelledby="community-title" className="space-y-3">
    <SectionTitle id="community-title" icon={MessageSquareMore} title="Communauté & échanges" description={`Activité publiée sur les ${report.days} derniers jours ; contenus supprimés exclus.`} />
    <Card className="overflow-hidden p-0"><div className="grid grid-cols-2 gap-px bg-[var(--outline-variant)] sm:grid-cols-3 xl:grid-cols-6">{items.map((item) => <div key={item.label} className="min-w-0 bg-[var(--surface)] p-4"><p className="text-[11px] font-semibold uppercase tracking-wide text-[var(--on-surface-muted)]">{item.label}</p><p className="mt-2 text-2xl font-semibold tabular-nums">{integer(item.value)}</p><p className="mt-1 text-xs text-[var(--on-surface-muted)]">{item.hint}</p></div>)}</div><p className="border-t border-[var(--outline-variant)] px-4 py-3 text-xs text-[var(--on-surface-muted)]">{integer(s.visible_posts)} publications actuellement visibles. {report.definition}</p></Card>
  </section>;
}

function exportDailyCsv(activity: AdminAppAnalytics, learning: AdminLearningAnalytics) {
  const answers = new Map(learning.daily.map((day) => [day.date, day]));
  const lines = ["date;utilisateurs_actifs;quiz_lances;nouveaux_comptes;reponses_sauvegardees;bonnes_reponses", ...activity.daily.map((day) => {
    const saved = answers.get(day.date);
    return [day.date, day.active_users, day.quiz_sessions, day.registrations, saved?.saved ?? 0, saved?.correct ?? 0].join(";");
  })];
  const url = URL.createObjectURL(new Blob([`\uFEFF${lines.join("\n")}\n`], { type: "text/csv;charset=utf-8" }));
  const link = document.createElement("a");
  link.href = url;
  link.download = `copiq-statistiques-${activity.days}-jours.csv`;
  link.click();
  window.setTimeout(() => URL.revokeObjectURL(url), 1000);
}

function LearningSection({ report, days, refreshing }: { report: AdminLearningAnalytics; days: number; refreshing: boolean }) {
  const valid = report.summary.saved >= 20 && report.summary.learners >= 5;
  return <section aria-labelledby="learning-title" aria-busy={refreshing} className="mb-8 space-y-4">
    <div className="flex flex-wrap items-end justify-between gap-3">
      <SectionTitle id="learning-title" icon={GraduationCap} title="Réussite réelle des apprenants" description={`Uniquement les réponses enregistrées au cours des ${days} derniers jours.`} />
      {refreshing && <span role="status" className="text-xs text-[var(--on-surface-muted)]">Actualisation en arrière-plan…</span>}
    </div>
    <Card className="overflow-hidden border-[var(--brand)]/25 bg-[linear-gradient(115deg,var(--surface),color-mix(in_srgb,var(--brand)_8%,var(--surface)))] p-0">
      <div className="grid grid-cols-2 md:grid-cols-4">
        {[
          { label: "Réponses sauvegardées", value: integer(report.summary.saved), hint: "questions traitées" },
          { label: "Bonnes réponses", value: integer(report.summary.correct), hint: "réponses fournies" },
          { label: "Apprenants", value: integer(report.summary.learners), hint: "personnes distinctes" },
          { label: "Taux de réussite", value: valid && report.summary.accuracy !== null ? `${report.summary.accuracy} %` : "—", hint: valid ? "pondéré par question" : "échantillon insuffisant" },
        ].map((item, index) => <div key={item.label} className={`min-w-0 p-4 md:p-6 ${index >= 2 ? "border-t border-[var(--outline-variant)]/70 md:border-t-0" : ""} ${index % 2 === 1 ? "border-l border-[var(--outline-variant)]/70" : ""} ${index === 2 ? "md:border-l md:border-[var(--outline-variant)]/70" : ""}`}><p className="min-h-8 text-[11px] font-semibold uppercase leading-tight tracking-wide text-[var(--on-surface-muted)]">{item.label}</p><p className="mt-1 text-3xl font-semibold tabular-nums tracking-tight text-[var(--brand)]">{item.value}</p><p className="mt-1 text-xs text-[var(--on-surface-muted)]">{item.hint}</p></div>)}
      </div>
    </Card>
    <div className="grid gap-4 xl:grid-cols-[minmax(0,1.35fr)_minmax(300px,1fr)]">
      <Card className="p-5 md:p-6"><SectionTitle icon={GraduationCap} title="Résultats par parcours" description="Scolarité et concours, GPX et PA · tous les quiz et difficultés." />
        <div className="space-y-3">{report.journeys.map((journey) => <div key={`${journey.track}-${journey.mode}`} className="rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] p-4">
          <div className="flex flex-wrap items-center justify-between gap-2"><h3 className="text-sm font-semibold">{journey.label}</h3><span className="text-sm font-semibold tabular-nums text-[var(--brand)]">{journey.saved >= 20 && journey.learners >= 5 && journey.accuracy !== null ? `${journey.accuracy} %` : "—"}</span></div>
          <div className="mt-2 h-2 overflow-hidden rounded-full bg-[var(--surface-container-hi)]"><div className="h-full rounded-full bg-[var(--brand)] motion-safe:transition-[width] motion-safe:duration-500" style={{ width: `${journey.saved >= 20 && journey.learners >= 5 ? Math.min(journey.accuracy ?? 0, 100) : 0}%` }} /></div>
          <p className="mt-2 text-xs text-[var(--on-surface-muted)]">{integer(journey.correct)} bonnes réponses sur {integer(journey.saved)} · {integer(journey.learners)} apprenant{journey.learners > 1 ? "s" : ""}{journey.saved < 20 || journey.learners < 5 ? " · échantillon insuffisant" : ""}</p>
        </div>)}</div>
      </Card>
      <Card className="p-5 md:p-6"><SectionTitle icon={BarChart3} title="Par difficulté" description="Chaque taux utilise les réponses enregistrées dans ce niveau." />
        {report.difficulty.length === 0 ? <p className="text-sm text-[var(--on-surface-muted)]">Aucune réponse sur cette période.</p> : <div className="space-y-3">{report.difficulty.map((item) => <div key={item.label} className="flex items-center justify-between gap-3 border-b border-[var(--outline-variant)]/70 pb-3 last:border-0"><div className="min-w-0"><p className="truncate text-sm font-semibold">{item.label}</p><p className="text-xs text-[var(--on-surface-muted)]">{integer(item.correct)} / {integer(item.saved)} réponses · {integer(item.learners)} personnes</p></div><span className="shrink-0 text-sm font-semibold tabular-nums">{item.saved >= 20 && item.learners >= 5 && item.accuracy !== null ? `${item.accuracy} %` : "—"}</span></div>)}</div>}
        <p className="mt-4 rounded-xl bg-[var(--brand)]/5 p-3 text-xs text-[var(--on-surface-muted)]">{report.definition} Un pourcentage est masqué sous 20 réponses ou 5 apprenants ; ce seuil de lecture ne garantit pas une représentativité statistique.</p>
      </Card>
    </div>
    <div className="grid gap-4 md:grid-cols-2">
      <Card className="p-5"><SectionTitle icon={Activity} title="Tests psychotechniques" description="Performance sur les questions réellement traitées." /><div className="flex items-baseline justify-between gap-3"><p className="text-2xl font-semibold tabular-nums">{integer(report.psychotechnique.exercises)}</p><p className="text-sm font-semibold text-[var(--brand)]">{(report.psychotechnique.total_answered ?? 0) >= 20 && report.psychotechnique.learners >= 5 && report.psychotechnique.accuracy !== null ? `${report.psychotechnique.accuracy} % de réussite` : "Taux indisponible"}</p></div><p className="mt-2 text-xs text-[var(--on-surface-muted)]">{integer(report.psychotechnique.learners)} apprenants · {integer(report.psychotechnique.total_answered ?? 0)} réponses</p></Card>
      <Card className="p-5"><SectionTitle icon={GraduationCap} title="Cas pratiques" description="Tentatives et copies disposant d’un score." /><div className="flex items-baseline justify-between gap-3"><p className="text-2xl font-semibold tabular-nums">{integer(report.practical.attempts)}</p><p className="text-sm font-semibold text-[var(--brand)]">{report.practical.scored >= 5 && report.practical.learners >= 5 && report.practical.average_percent !== null ? `${report.practical.average_percent} % moyen` : "Taux indisponible"}</p></div><p className="mt-2 text-xs text-[var(--on-surface-muted)]">{integer(report.practical.learners)} apprenants · {integer(report.practical.scored)} copies notées</p></Card>
    </div>
  </section>;
}

function SectionTitle({ id, icon: Icon, title, description }: { id?: string; icon: typeof Activity; title: string; description: string }) {
  return <div className="mb-4 flex items-start gap-3"><span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><Icon size={18} /></span><div><h2 id={id} className="text-base font-semibold tracking-[-.015em]">{title}</h2><p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">{description}</p></div></div>;
}

function Metric({ label, value, hint }: { label: string; value: number; hint: string }) {
  return <Card className="min-w-0 p-4 md:p-5"><p className="min-h-8 text-[11px] font-semibold uppercase leading-tight tracking-wide text-[var(--on-surface-muted)]">{label}</p><p className="mt-2 text-3xl font-semibold tabular-nums tracking-tight text-[var(--brand)]">{integer(value)}</p><p className="mt-1 text-xs text-[var(--on-surface-muted)]">{hint}</p></Card>;
}

function SmallValue({ label, value }: { label: string; value: number }) {
  return <div className="rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] p-4"><p className="text-xs text-[var(--on-surface-muted)]">{label}</p><p className="mt-1 text-2xl font-semibold tabular-nums">{integer(value)}</p></div>;
}

function Funnel({ report }: { report: AdminAppAnalytics }) {
  const stages = [
    { label: "Comptes inscrits", value: report.funnel.registered },
    { label: "Ont ouvert l’app", value: report.funnel.opened_app },
    { label: "Ont pratiqué un quiz", value: report.funnel.practiced_quiz },
    { label: "Premium actifs parmi eux", value: report.funnel.paying_active_after_quiz },
  ];
  const total = Math.max(stages[0].value, 1);
  return <div className="space-y-4">{stages.map((stage, index) => <div key={stage.label}><div className="mb-1.5 flex justify-between gap-3 text-sm"><span>{stage.label}</span><span className="font-semibold tabular-nums">{integer(stage.value)} <span className="text-xs font-normal text-[var(--on-surface-muted)]">· {Math.round(stage.value / total * 100)} %</span></span></div><div className="h-4 overflow-hidden rounded-lg bg-[var(--surface-container-hi)]"><div className={`h-full rounded-lg ${index === 3 ? "bg-[var(--success)]" : "bg-[var(--brand)]"}`} style={{ width: `${stage.value === 0 ? 0 : Math.max(stage.value / total * 100, 2)}%`, opacity: 1 - index * .12 }} /></div></div>)}</div>;
}

function DailyChart({ daily }: { daily: AdminAppAnalytics["daily"] }) {
  const width = 720, height = 210, left = 28, top = 12, bottom = 28;
  const values = daily.flatMap((day) => [day.active_users, day.quiz_sessions, day.registrations]);
  const peak = Math.max(...values, 1);
  const x = (index: number) => left + index * (width - left - 12) / Math.max(daily.length - 1, 1);
  const y = (value: number) => top + (peak - value) * (height - top - bottom) / peak;
  const path = (key: "active_users" | "quiz_sessions") => daily.map((day, index) => `${index === 0 ? "M" : "L"}${x(index).toFixed(1)},${y(day[key]).toFixed(1)}`).join(" ");
  return <>
    <div className="mb-3 flex flex-wrap gap-x-5 gap-y-1 text-xs text-[var(--on-surface-muted)]"><Legend color="var(--brand)" label="Utilisateurs actifs" /><Legend color="var(--success)" label="Quiz lancés" /><Legend color="var(--warning)" label="Inscriptions" /></div>
    <div className="overflow-x-auto"><svg viewBox={`0 0 ${width} ${height}`} role="img" aria-label="Graphique quotidien des utilisateurs actifs, quiz lancés et inscriptions" className="min-w-[480px] w-full">
      {[0, .25, .5, .75, 1].map((step) => <g key={step}><line x1={left} x2={width} y1={y(peak * step)} y2={y(peak * step)} stroke="var(--outline-variant)" strokeDasharray="3 5" /><text x="0" y={y(peak * step) + 4} fill="var(--on-surface-muted)" fontSize="10">{Math.round(peak * step)}</text></g>)}
      {daily.map((day, index) => <rect key={day.date} x={x(index) - 3} y={y(day.registrations)} width="6" height={Math.max(height - bottom - y(day.registrations), 0)} rx="2" fill="var(--warning)" opacity=".5"><title>{dateLabel(day.date)} : {day.registrations} inscriptions</title></rect>)}
      <path d={path("active_users")} fill="none" stroke="var(--brand)" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" />
      <path d={path("quiz_sessions")} fill="none" stroke="var(--success)" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
      {daily.map((day, index) => <g key={`dot-${day.date}`}><circle cx={x(index)} cy={y(day.active_users)} r="3.5" fill="var(--brand)"><title>{dateLabel(day.date)} : {day.active_users} actifs</title></circle><circle cx={x(index)} cy={y(day.quiz_sessions)} r="2.5" fill="var(--success)"><title>{dateLabel(day.date)} : {day.quiz_sessions} quiz</title></circle></g>)}
      {[0, Math.floor((daily.length - 1) / 2), daily.length - 1].filter((item, index, all) => all.indexOf(item) === index).map((index) => <text key={index} x={x(index)} y={height - 6} fill="var(--on-surface-muted)" fontSize="11" textAnchor={index === 0 ? "start" : index === daily.length - 1 ? "end" : "middle"}>{dateLabel(daily[index].date)}</text>)}
    </svg></div>
    <details className="mt-3 rounded-xl border border-[var(--outline-variant)] p-3 text-xs text-[var(--on-surface-muted)]"><summary className="cursor-pointer font-semibold text-[var(--on-surface)]">Voir les valeurs jour par jour</summary><div className="mt-3 max-h-56 overflow-auto"><table className="w-full text-left"><thead><tr><th className="py-1">Date</th><th className="text-right">Actifs</th><th className="text-right">Quiz</th><th className="text-right">Inscrits</th></tr></thead><tbody>{daily.map((day) => <tr key={day.date} className="border-t border-[var(--outline-variant)]/60"><td className="py-1">{dateLabel(day.date)}</td><td className="text-right">{integer(day.active_users)}</td><td className="text-right">{integer(day.quiz_sessions)}</td><td className="text-right">{integer(day.registrations)}</td></tr>)}</tbody></table></div></details>
  </>;
}

function Legend({ color, label }: { color: string; label: string }) { return <span className="inline-flex items-center gap-1.5"><span className="h-2.5 w-2.5 rounded-full" style={{ backgroundColor: color }} />{label}</span>; }
