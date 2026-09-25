"use client"

import { useEffect, useMemo, useState } from "react"
import {
  Activity, AlertTriangle, ArrowRight, BarChart3, BookOpenCheck, CheckCircle2,
  CircleDollarSign, CloudCog, Database, Download, FileSearch, Filter,
  Gauge, GitBranch, Languages, LineChart, Printer, RefreshCw, Save,
  Search, ShieldCheck, XCircle,
} from "lucide-react"
import toast from "react-hot-toast"
import {
  supportApi,
  type AdminContentGraphNode,
  type AdminContentImpactPreview,
  type AdminDataSourceRun,
  type AdminPremiumControlOverview,
  type AdminReportSchedule,
  type AdminRestoreExercise,
  type AdminSavedView,
} from "@/lib/admin/api"
import { Badge, Button, Card, ErrorBox, Loading, PageHeader, useAsync } from "@/components/admin/admin-ui"

type Tab = "overview" | "sources" | "content" | "continuity"
type Period = 7 | 30 | 90

const inputClass = "min-h-11 w-full rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)] px-3 text-sm text-[var(--on-surface)] outline-none transition placeholder:text-[var(--on-surface-faint)] focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/20"

export default function AdvancedControlPage() {
  const [tab, setTab] = useState<Tab>("overview")
  const [period, setPeriod] = useState<Period>(30)
  const [search, setSearch] = useState("")
  const [debouncedSearch, setDebouncedSearch] = useState("")
  const [impact, setImpact] = useState<AdminContentImpactPreview | null>(null)
  const [impactBusy, setImpactBusy] = useState<string | null>(null)
  const [poll, setPoll] = useState(0)

  useEffect(() => {
    const timer = window.setTimeout(() => setDebouncedSearch(search.trim()), 250)
    return () => window.clearTimeout(timer)
  }, [search])

  useEffect(() => {
    const refresh = async () => {
      try { await supportApi.refreshInternalSources() } catch { /* L’aperçu affiche l’erreur de source existante. */ }
      setPoll((value) => value + 1)
    }
    void refresh()
    const timer = window.setInterval(refresh, 60_000)
    return () => window.clearInterval(timer)
  }, [])

  const overview = useAsync(() => supportApi.premiumControlOverview(period), [period, poll])
  const graph = useAsync(() => supportApi.contentDependencyGraph(debouncedSearch), [debouncedSearch, poll])
  const views = useAsync(() => supportApi.savedViews("premium-control"), [poll])
  const restores = useAsync(() => supportApi.restoreExercises(), [poll])
  const translations = useAsync(() => supportApi.translationOverview(), [poll])
  const reviews = useAsync(() => supportApi.storeReviews(), [poll])
  const sourceRuns = useAsync(() => supportApi.dataSourceRuns(undefined, 50), [poll])
  const reportSchedules = useAsync(() => supportApi.reportSchedules(), [poll])

  const reload = () => setPoll((value) => value + 1)

  async function openImpact(node: AdminContentGraphNode) {
    setImpactBusy(node.id)
    try {
      setImpact(await supportApi.contentImpactPreview(node.entity_type, node.entity_id))
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Analyse d’impact impossible.")
    } finally {
      setImpactBusy(null)
    }
  }

  function exportReport() {
    if (!overview.data) return
    const payload = {
      generated_at: new Date().toISOString(),
      period_days: period,
      filters: { tab, content_search: debouncedSearch },
      overview: overview.data,
      dependencies: graph.data,
      restore_exercises: restores.data,
      translations: translations.data,
    }
    const url = URL.createObjectURL(new Blob([JSON.stringify(payload, null, 2)], { type: "application/json;charset=utf-8" }))
    const link = document.createElement("a")
    link.href = url
    link.download = `copiq-rapport-premium-${new Date().toISOString().slice(0, 10)}.json`
    link.click()
    URL.revokeObjectURL(url)
    toast.success("Rapport JSON généré avec ses sources et filtres.")
  }

  async function saveCurrentView() {
    const name = window.prompt("Nom de cette vue :", `Pilotage ${period} jours`)
    if (!name?.trim()) return
    try {
      await supportApi.saveView({ name: name.trim(), pageKey: "premium-control", filters: { tab, period, search }, isDefault: false })
      toast.success("Vue enregistrée.")
      reload()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Vue non enregistrée.")
    }
  }

  function applyView(view: AdminSavedView) {
    const filters = view.filters as { tab?: Tab; period?: Period; search?: string }
    if (filters.tab) setTab(filters.tab)
    if (filters.period) setPeriod(filters.period)
    setSearch(filters.search ?? "")
    toast.success(`Vue « ${view.name} » appliquée.`)
  }

  const error = overview.error || graph.error || views.error || restores.error || translations.error || reviews.error || sourceRuns.error || reportSchedules.error

  return <div className="print:bg-white print:text-black">
    <PageHeader title="Pilotage premium" subtitle="Décider avec des données traçables, contrôler les dépendances et préparer la continuité sans inventer de chiffres." action={
      <div className="flex flex-wrap justify-end gap-2 print:hidden">
        <button type="button" onClick={saveCurrentView} className="inline-flex min-h-11 items-center gap-2 rounded-xl border border-[var(--outline-variant)] px-3 text-xs font-semibold hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"><Save size={15} /> Enregistrer la vue</button>
        <button type="button" onClick={exportReport} className="inline-flex min-h-11 items-center gap-2 rounded-xl border border-[var(--outline-variant)] px-3 text-xs font-semibold hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"><Download size={15} /> Rapport</button>
        <button type="button" onClick={() => window.print()} className="grid min-h-11 min-w-11 place-items-center rounded-xl border border-[var(--outline-variant)] hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]" aria-label="Imprimer ou enregistrer en PDF"><Printer size={17} /></button>
        <button type="button" onClick={reload} className="grid min-h-11 min-w-11 place-items-center rounded-xl border border-[var(--outline-variant)] hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]" aria-label="Actualiser"><RefreshCw size={17} className={overview.loading ? "animate-spin motion-reduce:animate-none" : ""} /></button>
      </div>
    } />

    {error ? <ErrorBox error={error} /> : null}

    <div className="mb-5 flex flex-wrap items-center justify-between gap-3 print:hidden">
      <div className="flex overflow-x-auto rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-1" role="tablist" aria-label="Sections du pilotage premium">
        <TabButton active={tab === "overview"} onClick={() => setTab("overview")} icon={Gauge}>Synthèse</TabButton>
        <TabButton active={tab === "sources"} onClick={() => setTab("sources")} icon={Database}>Sources</TabButton>
        <TabButton active={tab === "content"} onClick={() => setTab("content")} icon={GitBranch}>Contenus</TabButton>
        <TabButton active={tab === "continuity"} onClick={() => setTab("continuity")} icon={ShieldCheck}>Continuité</TabButton>
      </div>
      <div className="flex items-center gap-2" aria-label="Période d’analyse">
        {[7, 30, 90].map((days) => <button key={days} type="button" onClick={() => setPeriod(days as Period)} className={`min-h-11 rounded-xl px-4 text-sm font-semibold focus-visible:outline-2 focus-visible:outline-[var(--brand)] ${period === days ? "bg-[var(--brand)] text-white" : "border border-[var(--outline-variant)] text-[var(--on-surface-muted)]"}`}>{days} j</button>)}
      </div>
    </div>

    {(views.data?.length ?? 0) > 0 && <div className="mb-4 flex flex-wrap items-center gap-2 print:hidden"><Filter size={15} className="text-[var(--brand)]" /><span className="text-xs text-[var(--on-surface-muted)]">Vues :</span>{views.data?.map((view) => <button type="button" key={view.id} onClick={() => applyView(view)} className="min-h-9 rounded-full border border-[var(--outline-variant)] px-3 text-xs font-semibold hover:border-[var(--brand)] hover:text-[var(--brand)]">{view.name}</button>)}</div>}

    {overview.loading && !overview.data && <Loading label="Consolidation des données réelles…" />}
    {tab === "overview" && overview.data && <Overview data={overview.data} reviewsCount={reviews.data?.length ?? 0} />}
    {tab === "sources" && overview.data && <Sources data={overview.data} runs={sourceRuns.data ?? []} />}
    {tab === "content" && <ContentDependencies nodes={graph.data?.nodes ?? []} edgeCount={graph.data?.edges.length ?? 0} search={search} setSearch={setSearch} loading={graph.loading} impactBusy={impactBusy} onImpact={openImpact} />}
    {tab === "continuity" && <Continuity restores={restores.data ?? []} schedules={reportSchedules.data ?? []} translations={translations.data?.by_locale ?? []} period={period} onReload={reload} />}

    {impact && <ImpactDialog impact={impact} onClose={() => setImpact(null)} />}
  </div>
}

function Overview({ data, reviewsCount }: { data: AdminPremiumControlOverview; reviewsCount: number }) {
  const disconnected = data.sources.filter((source) => source.status === "not_connected").length
  const qualityIssues = data.content_quality.courses_without_body + data.content_quality.courses_without_media_alt + data.content_quality.orphan_courses + data.content_quality.active_nodes_without_image
  return <>
    <section aria-label="Indicateurs principaux" className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
      <Kpi icon={CircleDollarSign} label="Chiffre d’affaires brut" value={formatMoney(data.economy.gross_revenue_cents)} note={`${data.economy.paid_invoices} facture(s) payée(s)`} />
      <Kpi icon={Activity} label="Abonnements actifs" value={data.economy.active_subscriptions} note={`${data.economy.past_due} à risque · ${data.economy.cancel_at_period_end} résiliation(s)`} tone={data.economy.past_due ? "warn" : "good"} />
      <Kpi icon={BookOpenCheck} label="Anomalies éditoriales" value={qualityIssues} note={`${data.content_quality.courses_published}/${data.content_quality.courses_total} cours publiés`} tone={qualityIssues ? "warn" : "good"} />
      <Kpi icon={CloudCog} label="Sources à raccorder" value={disconnected} note={`${data.sources.length - disconnected}/${data.sources.length} sources disponibles`} tone={disconnected ? "neutral" : "good"} />
    </section>

    <div className="mt-4 grid gap-4 xl:grid-cols-[1.25fr_.75fr]">
      <Card className="p-5 print:border-gray-300 print:bg-white">
        <div className="flex items-start justify-between gap-3"><div><h2 className="text-base font-semibold">Prévisions prudentes</h2><p className="mt-1 text-xs leading-5 text-[var(--on-surface-muted)]">{data.forecast.method}</p></div><LineChart size={20} className="text-[var(--brand)]" /></div>
        <div className="mt-5 grid gap-5 md:grid-cols-2">
          <Forecast title="Utilisateurs actifs" points={data.forecast.activity} available={data.forecast.activity_available} observed={data.forecast.activity_observed_days} minimum={data.forecast.minimum_observed_days} />
          <Forecast title="Réponses sauvegardées" points={data.forecast.answers} available={data.forecast.answers_available} observed={data.forecast.answers_observed_days} minimum={data.forecast.minimum_observed_days} />
        </div>
      </Card>
      <Card className="p-5 print:border-gray-300 print:bg-white">
        <div className="flex items-center justify-between"><h2 className="text-base font-semibold">Abonnements</h2><BarChart3 size={19} className="text-[var(--brand)]" /></div>
        <dl className="mt-4 divide-y divide-[var(--outline-variant)]">
          <StatRow label="Essais en cours" value={data.economy.trials} />
          <StatRow label="Paiements à risque" value={data.economy.past_due} warn={data.economy.past_due > 0} />
          <StatRow label="Fin de période demandée" value={data.economy.cancel_at_period_end} />
          <StatRow label="Expirés / annulés" value={data.economy.expired} />
          <StatRow label="Avis boutiques importés" value={reviewsCount} />
        </dl>
        {data.economy.by_store.length > 0 && <div className="mt-4 flex flex-wrap gap-2">{data.economy.by_store.map((row) => <Badge key={row.store}>{row.store} · {row.total}</Badge>)}</div>}
      </Card>
    </div>

    <div className="mt-4 grid gap-4 md:grid-cols-2 xl:grid-cols-4">
      <MiniQuality label="Cours sans contenu" value={data.content_quality.courses_without_body} />
      <MiniQuality label="Médias sans texte alternatif" value={data.content_quality.courses_without_media_alt} />
      <MiniQuality label="Cours orphelins" value={data.content_quality.orphan_courses} />
      <MiniQuality label="Catégories actives sans image" value={data.content_quality.active_nodes_without_image} />
    </div>
  </>
}

function Sources({ data, runs }: { data: AdminPremiumControlOverview; runs: AdminDataSourceRun[] }) {
  return <div className="space-y-4"><Card className="overflow-hidden p-0">
    <div className="border-b border-[var(--outline-variant)] p-5"><h2 className="text-base font-semibold">Registre de traçabilité</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Chaque chiffre indique son mode de collecte, sa fraîcheur et le dernier import. Les sources privées restent côté serveur.</p></div>
    <div className="overflow-x-auto"><table className="min-w-full text-left text-sm"><thead className="bg-[var(--surface-container)] text-xs uppercase tracking-wide text-[var(--on-surface-faint)]"><tr><th className="px-5 py-3">Source</th><th className="px-5 py-3">État</th><th className="px-5 py-3">Mode</th><th className="px-5 py-3">Dernière réussite</th><th className="px-5 py-3 text-right">Lignes</th></tr></thead><tbody className="divide-y divide-[var(--outline-variant)]">{data.sources.map((source) => <tr key={source.key}><td className="px-5 py-4"><div className="font-semibold">{source.label}</div><div className="mt-1 font-mono text-[11px] text-[var(--on-surface-faint)]">{source.key}</div>{source.last_error && <div className="mt-1 text-xs text-[var(--danger)]">{source.last_error}</div>}</td><td className="px-5 py-4"><SourceBadge status={source.status} /></td><td className="px-5 py-4 text-[var(--on-surface-muted)]">{source.mode}</td><td className="px-5 py-4 text-[var(--on-surface-muted)]">{formatDate(source.last_success_at)}</td><td className="px-5 py-4 text-right tabular-nums">{source.record_count.toLocaleString("fr-FR")}</td></tr>)}</tbody></table></div>
  </Card><Card className="overflow-hidden p-0"><div className="border-b border-[var(--outline-variant)] p-5"><h2 className="text-base font-semibold">Dernières synchronisations</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Début, fin, volume, doublons et erreur technique de chaque import.</p></div>{runs.length ? <div className="divide-y divide-[var(--outline-variant)]">{runs.map((run) => <div key={run.id} className="grid gap-2 p-4 text-sm sm:grid-cols-[1fr_auto_auto]"><div><div className="font-semibold">{run.source_key}</div><div className="mt-1 text-xs text-[var(--on-surface-faint)]">{run.run_key} · {formatDate(run.started_at)}</div>{run.error_message && <div className="mt-1 text-xs text-[var(--danger)]">{run.error_message}</div>}</div><Badge tone={run.status === "succeeded" ? "good" : run.status === "failed" ? "bad" : run.status === "partial" ? "warn" : "neutral"}>{run.status}</Badge><div className="text-right text-xs text-[var(--on-surface-muted)]"><div>{run.output_count.toLocaleString("fr-FR")} importé(s)</div><div>{run.duplicate_count.toLocaleString("fr-FR")} doublon(s)</div></div></div>)}</div> : <p className="p-6 text-sm text-[var(--on-surface-muted)]">Aucun import externe journalisé. Les sources internes temps réel n’inventent pas de faux « runs ».</p>}</Card></div>
}

function ContentDependencies({ nodes, edgeCount, search, setSearch, loading, impactBusy, onImpact }: { nodes: AdminContentGraphNode[]; edgeCount: number; search: string; setSearch: (value: string) => void; loading: boolean; impactBusy: string | null; onImpact: (node: AdminContentGraphNode) => void }) {
  const warningCount = useMemo(() => nodes.reduce((sum, node) => sum + node.warnings.filter(Boolean).length, 0), [nodes])
  return <>
    <div className="mb-4 grid gap-3 sm:grid-cols-3"><Kpi icon={FileSearch} label="Contenus trouvés" value={nodes.length} /><Kpi icon={GitBranch} label="Dépendances directes" value={edgeCount} /><Kpi icon={AlertTriangle} label="Alertes" value={warningCount} tone={warningCount ? "warn" : "good"} /></div>
    <Card className="p-4"><label className="relative block"><span className="sr-only">Rechercher un contenu</span><Search size={17} className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" /><input className={`${inputClass} pl-10`} value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Titre ou route d’un cours…" /></label></Card>
    {loading && <Loading label="Construction du graphe de dépendances…" />}
    <div className="mt-4 grid gap-3 xl:grid-cols-2">{nodes.slice(0, 200).map((node) => <Card key={node.id} className="p-4"><div className="flex items-start justify-between gap-3"><div className="min-w-0"><div className="flex flex-wrap gap-2"><Badge>{scopeLabel(node.scope)}</Badge><Badge tone={node.status === "published" ? "good" : "neutral"}>{node.status}</Badge>{node.warnings.filter(Boolean).map((warning) => <Badge tone="warn" key={warning}>{warning}</Badge>)}</div><h2 className="mt-3 truncate font-semibold">{node.label}</h2><p className="mt-1 truncate text-xs text-[var(--on-surface-faint)]">{node.route || node.entity_type}</p></div><button type="button" disabled={impactBusy === node.id} onClick={() => onImpact(node)} className="inline-flex min-h-11 shrink-0 items-center gap-2 rounded-xl border border-[var(--outline-variant)] px-3 text-xs font-semibold hover:border-[var(--brand)] hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-[var(--brand)] disabled:opacity-50">Impact <ArrowRight size={15} /></button></div></Card>)}</div>
    {!loading && nodes.length === 0 && <Card className="mt-4 p-8 text-center"><GitBranch className="mx-auto text-[var(--on-surface-faint)]" /><p className="mt-3 font-semibold">Aucun contenu correspondant</p></Card>}
  </>
}

function Continuity({ restores, schedules, translations, period, onReload }: { restores: AdminRestoreExercise[]; schedules: AdminReportSchedule[]; translations: Array<{ locale: string; total: number; approved: number; missing: number }>; period: Period; onReload: () => void }) {
  const [open, setOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const [draft, setDraft] = useState({ environment: "isolated" as AdminRestoreExercise["environment"], backup_reference: "", status: "planned" as AdminRestoreExercise["status"], recovery_time_minutes: "", data_loss_minutes: "", result_notes: "", evidence_url: "" })
  const [scheduleOpen, setScheduleOpen] = useState(false)
  const [scheduleBusy, setScheduleBusy] = useState(false)
  const [schedule, setSchedule] = useState({ name: "Bilan COP’IQ", format: "pdf" as AdminReportSchedule["format"], cadence: "weekly" as AdminReportSchedule["cadence"], recipients: "", next_run_at: "" })

  async function save(event: React.FormEvent) {
    event.preventDefault()
    if (!draft.backup_reference.trim()) return
    setBusy(true)
    try {
      await supportApi.saveRestoreExercise({
        environment: draft.environment,
        backup_reference: draft.backup_reference.trim(),
        status: draft.status,
        recovery_time_minutes: draft.recovery_time_minutes ? Number(draft.recovery_time_minutes) : null,
        data_loss_minutes: draft.data_loss_minutes ? Number(draft.data_loss_minutes) : null,
        result_notes: draft.result_notes.trim(),
        evidence_url: draft.evidence_url.trim() || null,
        started_at: draft.status === "planned" ? null : new Date().toISOString(),
        finished_at: ["passed", "failed", "cancelled"].includes(draft.status) ? new Date().toISOString() : null,
        integrity_checks: [],
      })
      toast.success("Exercice de continuité journalisé.")
      setOpen(false)
      onReload()
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Enregistrement impossible.")
    } finally { setBusy(false) }
  }

  async function saveSchedule(event: React.FormEvent) {
    event.preventDefault()
    setScheduleBusy(true)
    try {
      const recipients = schedule.recipients.split(/[;,\s]+/).map((value) => value.trim()).filter(Boolean)
      if (recipients.some((email) => !/^\S+@\S+\.\S+$/.test(email))) throw new Error("Une adresse e-mail est invalide.")
      await supportApi.saveReportSchedule({ name: schedule.name.trim(), report_key: "premium-control", format: schedule.format, cadence: schedule.cadence, recipients, filters: { period }, active: true, next_run_at: schedule.next_run_at ? new Date(schedule.next_run_at).toISOString() : null })
      toast.success("Planification enregistrée. Elle est prête pour le worker d’envoi sécurisé.")
      setScheduleOpen(false); onReload()
    } catch (error) { toast.error(error instanceof Error ? error.message : "Planification impossible.") }
    finally { setScheduleBusy(false) }
  }

  return <div className="grid gap-4 xl:grid-cols-[1.1fr_.9fr]">
    <Card className="overflow-hidden p-0"><div className="flex items-center justify-between gap-3 border-b border-[var(--outline-variant)] p-5"><div><h2 className="font-semibold">Tests de restauration</h2><p className="mt-1 text-xs text-[var(--on-surface-muted)]">RTO, RPO, intégrité et preuve d’exécution.</p></div><Button type="button" onClick={() => setOpen(!open)}>{open ? "Fermer" : "Journaliser un test"}</Button></div>
      {open && <form onSubmit={save} className="grid gap-3 border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/50 p-5 md:grid-cols-2"><Field label="Environnement"><select className={inputClass} value={draft.environment} onChange={(e) => setDraft({ ...draft, environment: e.target.value as AdminRestoreExercise["environment"] })}><option value="isolated">Isolé</option><option value="staging">Préproduction</option><option value="disaster-recovery">Secours</option></select></Field><Field label="Référence de sauvegarde"><input required className={inputClass} value={draft.backup_reference} onChange={(e) => setDraft({ ...draft, backup_reference: e.target.value })} /></Field><Field label="Résultat"><select className={inputClass} value={draft.status} onChange={(e) => setDraft({ ...draft, status: e.target.value as AdminRestoreExercise["status"] })}><option value="planned">Planifié</option><option value="running">En cours</option><option value="passed">Réussi</option><option value="failed">Échoué</option><option value="cancelled">Annulé</option></select></Field><Field label="Temps de reprise (minutes)"><input min="0" type="number" className={inputClass} value={draft.recovery_time_minutes} onChange={(e) => setDraft({ ...draft, recovery_time_minutes: e.target.value })} /></Field><Field label="Perte de données (minutes)"><input min="0" type="number" className={inputClass} value={draft.data_loss_minutes} onChange={(e) => setDraft({ ...draft, data_loss_minutes: e.target.value })} /></Field><Field label="Lien de preuve"><input type="url" className={inputClass} value={draft.evidence_url} onChange={(e) => setDraft({ ...draft, evidence_url: e.target.value })} /></Field><label className="md:col-span-2"><span className="mb-1.5 block text-xs font-semibold">Compte rendu</span><textarea className={`${inputClass} min-h-24 py-3`} value={draft.result_notes} onChange={(e) => setDraft({ ...draft, result_notes: e.target.value })} /></label><div className="md:col-span-2"><Button disabled={busy} type="submit">{busy ? "Enregistrement…" : "Enregistrer le test"}</Button></div></form>}
      <div className="divide-y divide-[var(--outline-variant)]">{restores.map((item) => <div key={item.id} className="p-5"><div className="flex flex-wrap items-center justify-between gap-2"><div className="font-semibold">{item.backup_reference}</div><Badge tone={item.status === "passed" ? "good" : item.status === "failed" ? "bad" : "neutral"}>{item.status}</Badge></div><div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-xs text-[var(--on-surface-muted)]"><span>{item.environment}</span><span>RTO : {item.recovery_time_minutes ?? "—"} min</span><span>RPO : {item.data_loss_minutes ?? "—"} min</span><span>{formatDate(item.finished_at || item.started_at || item.created_at)}</span></div>{item.result_notes && <p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">{item.result_notes}</p>}</div>)}{restores.length === 0 && <div className="p-8 text-center text-sm text-[var(--on-surface-muted)]">Aucun test réel journalisé. Le panel ne présentera pas une restauration comme validée tant qu’un exercice isolé n’aura pas été enregistré.</div>}</div>
    </Card>
    <div className="space-y-4"><Card className="p-5"><div className="flex items-center justify-between"><div><h2 className="font-semibold">Rapports planifiés</h2><p className="mt-1 text-xs text-[var(--on-surface-muted)]">Définition séparée de l’envoi : aucun e-mail ne part sans worker serveur et source configurés.</p></div><button type="button" onClick={() => setScheduleOpen(!scheduleOpen)} className="min-h-11 rounded-xl border border-[var(--outline-variant)] px-3 text-xs font-semibold hover:text-[var(--brand)]">{scheduleOpen ? "Fermer" : "Planifier"}</button></div>{scheduleOpen && <form onSubmit={saveSchedule} className="mt-4 space-y-3"><Field label="Nom"><input required minLength={2} className={inputClass} value={schedule.name} onChange={(e) => setSchedule({ ...schedule, name: e.target.value })} /></Field><div className="grid grid-cols-2 gap-3"><Field label="Format"><select className={inputClass} value={schedule.format} onChange={(e) => setSchedule({ ...schedule, format: e.target.value as AdminReportSchedule["format"] })}><option value="pdf">PDF</option><option value="csv">CSV</option><option value="json">JSON</option></select></Field><Field label="Cadence"><select className={inputClass} value={schedule.cadence} onChange={(e) => setSchedule({ ...schedule, cadence: e.target.value as AdminReportSchedule["cadence"] })}><option value="daily">Quotidien</option><option value="weekly">Hebdomadaire</option><option value="monthly">Mensuel</option><option value="manual">Manuel</option></select></Field></div><Field label="Destinataires séparés par une virgule"><input className={inputClass} value={schedule.recipients} onChange={(e) => setSchedule({ ...schedule, recipients: e.target.value })} placeholder="owner@copiq.fr" /></Field><Field label="Prochaine exécution"><input type="datetime-local" className={inputClass} value={schedule.next_run_at} onChange={(e) => setSchedule({ ...schedule, next_run_at: e.target.value })} /></Field><Button type="submit" disabled={scheduleBusy}>{scheduleBusy ? "Enregistrement…" : "Enregistrer la planification"}</Button></form>}{schedules.length > 0 && <div className="mt-4 space-y-2">{schedules.map((item) => <div key={item.id} className="rounded-xl bg-[var(--surface-container)] p-3 text-sm"><div className="flex justify-between gap-2"><span className="font-semibold">{item.name}</span><Badge tone={item.active ? "good" : "neutral"}>{item.cadence}</Badge></div><div className="mt-1 text-xs text-[var(--on-surface-muted)]">{item.format.toUpperCase()} · prochaine exécution {formatDate(item.next_run_at)}</div></div>)}</div>}</Card><Card className="p-5"><div className="flex items-center justify-between"><div><h2 className="font-semibold">Couverture multilingue</h2><p className="mt-1 text-xs text-[var(--on-surface-muted)]">Une traduction n’est publiée qu’après validation.</p></div><Languages size={20} className="text-[var(--brand)]" /></div>{translations.length ? <div className="mt-4 space-y-3">{translations.map((row) => <div key={row.locale}><div className="flex justify-between text-xs"><span className="font-semibold uppercase">{row.locale}</span><span>{row.approved}/{row.total} validés</span></div><div className="mt-1 h-2 overflow-hidden rounded-full bg-[var(--surface-container-hi)]"><div className="h-full rounded-full bg-[var(--brand)]" style={{ width: `${row.total ? Math.round(row.approved / row.total * 100) : 0}%` }} /></div></div>)}</div> : <p className="mt-4 rounded-xl border border-dashed border-[var(--outline-variant)] p-4 text-sm text-[var(--on-surface-muted)]">Aucune langue cible n’a encore été ouverte. Le français reste la source officielle.</p>}</Card>
      <Card className="p-5"><h2 className="font-semibold">Règles de continuité</h2><ul className="mt-4 space-y-3 text-sm leading-6 text-[var(--on-surface-muted)]"><Rule ok>Tester uniquement sur un environnement isolé.</Rule><Rule ok>Conserver la référence de sauvegarde et une preuve.</Rule><Rule ok>Mesurer le temps de reprise et la perte maximale.</Rule><Rule ok>Ne jamais annoncer un test réussi sans contrôles d’intégrité.</Rule></ul></Card></div>
  </div>
}

function ImpactDialog({ impact, onClose }: { impact: AdminContentImpactPreview; onClose: () => void }) {
  return <div className="fixed inset-0 z-50 grid place-items-end bg-black/70 p-0 backdrop-blur-sm sm:place-items-center sm:p-5" role="dialog" aria-modal="true" aria-labelledby="impact-title"><div className="max-h-[92vh] w-full overflow-y-auto rounded-t-3xl border border-[var(--outline-variant)] bg-[var(--surface)] p-5 shadow-2xl sm:max-w-2xl sm:rounded-3xl sm:p-7"><div className="flex items-start justify-between gap-4"><div><Badge tone={impact.impact_level === "high" ? "bad" : impact.impact_level === "medium" ? "warn" : "good"}>Impact {impact.impact_level}</Badge><h2 id="impact-title" className="mt-3 text-xl font-semibold">{String(impact.entity.title)}</h2></div><button type="button" onClick={onClose} className="grid min-h-11 min-w-11 place-items-center rounded-xl border border-[var(--outline-variant)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]" aria-label="Fermer"><XCircle size={20} /></button></div><div className="mt-5 grid grid-cols-2 gap-3 sm:grid-cols-4"><MiniStat label="Utilisateurs 30 j" value={impact.users_30d} /><MiniStat label="Vues 30 j" value={impact.views_30d} /><MiniStat label="Dépendants" value={impact.children} /><MiniStat label="Réponses quiz" value={impact.quiz_answers_30d} /></div><div className="mt-5 space-y-2"><h3 className="text-sm font-semibold">Contrôles avant publication</h3>{impact.checks.map((check) => <div key={check.label} className="flex items-center gap-3 rounded-xl border border-[var(--outline-variant)] p-3">{check.ok ? <CheckCircle2 size={18} className="text-[var(--success)]" /> : <AlertTriangle size={18} className="text-[var(--warning)]" />}<span className="text-sm">{check.label}</span></div>)}</div><p className="mt-5 text-xs leading-5 text-[var(--on-surface-muted)]">Cet aperçu est informatif : la publication continue d’utiliser la logique éditoriale existante et ses confirmations.</p></div></div>
}

function Forecast({ title, points, available, observed, minimum }: { title: string; points: Array<{ date: string; estimate: number; low: number; high: number }>; available: boolean; observed: number; minimum: number }) {
  if (!available) return <div className="rounded-2xl border border-dashed border-[var(--outline-variant)] p-4"><div className="font-semibold">{title}</div><p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">Échantillon insuffisant : {observed} jour(s) observé(s), {minimum} requis. Aucune projection artificielle n’est affichée.</p></div>
  const max = Math.max(1, ...points.map((point) => point.high))
  return <div><div className="font-semibold">{title}</div><div className="mt-4 flex h-28 items-end gap-2" aria-hidden="true">{points.map((point) => <div key={point.date} className="flex min-w-0 flex-1 flex-col items-center justify-end"><div className="w-full rounded-t-md bg-[var(--brand)]/75" style={{ height: `${Math.max(4, point.estimate / max * 100)}%` }} /><span className="mt-1 text-[9px] text-[var(--on-surface-faint)]">{new Date(point.date).toLocaleDateString("fr-FR", { weekday: "short" })}</span></div>)}</div><table className="sr-only"><caption>Prévision {title}</caption><thead><tr><th>Date</th><th>Basse</th><th>Estimation</th><th>Haute</th></tr></thead><tbody>{points.map((point) => <tr key={point.date}><td>{point.date}</td><td>{point.low}</td><td>{point.estimate}</td><td>{point.high}</td></tr>)}</tbody></table></div>
}

function Kpi({ icon: Icon, label, value, note, tone = "neutral" }: { icon: typeof Gauge; label: string; value: string | number; note?: string; tone?: "neutral" | "good" | "warn" }) {
  const color = tone === "good" ? "text-[var(--success)]" : tone === "warn" ? "text-[var(--warning)]" : "text-[var(--brand)]"
  return <Card className="p-5 print:border-gray-300 print:bg-white"><Icon size={20} className={color} /><div className="mt-4 text-2xl font-semibold tabular-nums">{value}</div><div className="mt-1 text-xs font-semibold">{label}</div>{note && <div className="mt-1 text-[11px] text-[var(--on-surface-muted)]">{note}</div>}</Card>
}

function MiniQuality({ label, value }: { label: string; value: number }) { return <Card className="p-4"><div className={`text-xl font-semibold ${value ? "text-[var(--warning)]" : "text-[var(--success)]"}`}>{value}</div><div className="mt-1 text-xs text-[var(--on-surface-muted)]">{label}</div></Card> }
function MiniStat({ label, value }: { label: string; value?: number }) { return <div className="rounded-xl bg-[var(--surface-container)] p-3"><div className="text-lg font-semibold tabular-nums">{value ?? "—"}</div><div className="mt-1 text-[10px] text-[var(--on-surface-muted)]">{label}</div></div> }
function StatRow({ label, value, warn }: { label: string; value: number; warn?: boolean }) { return <div className="flex justify-between gap-3 py-3"><dt className="text-sm text-[var(--on-surface-muted)]">{label}</dt><dd className={`font-semibold tabular-nums ${warn ? "text-[var(--warning)]" : ""}`}>{value}</dd></div> }
function Field({ label, children }: { label: string; children: React.ReactNode }) { return <label><span className="mb-1.5 block text-xs font-semibold">{label}</span>{children}</label> }
function Rule({ ok, children }: { ok?: boolean; children: React.ReactNode }) { return <li className="flex gap-3">{ok ? <CheckCircle2 size={17} className="mt-1 shrink-0 text-[var(--success)]" /> : <AlertTriangle size={17} className="mt-1 shrink-0 text-[var(--warning)]" />}<span>{children}</span></li> }

function SourceBadge({ status }: { status: AdminPremiumControlOverview["sources"][number]["status"] }) {
  const labels = { healthy: "À jour", delayed: "En retard", failed: "Échec", not_connected: "Non raccordée", paused: "En pause" }
  return <Badge tone={status === "healthy" ? "good" : status === "failed" ? "bad" : status === "delayed" ? "warn" : "neutral"}>{labels[status]}</Badge>
}

function TabButton({ active, onClick, icon: Icon, children }: { active: boolean; onClick: () => void; icon: typeof Gauge; children: React.ReactNode }) { return <button role="tab" aria-selected={active} type="button" onClick={onClick} className={`flex min-h-11 shrink-0 items-center gap-2 rounded-xl px-4 text-sm font-semibold transition focus-visible:outline-2 focus-visible:outline-[var(--brand)] ${active ? "bg-[var(--brand)] text-white shadow-lg shadow-blue-600/20" : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"}`}><Icon size={16} />{children}</button> }
function formatMoney(cents: number) { return new Intl.NumberFormat("fr-FR", { style: "currency", currency: "EUR", maximumFractionDigits: 2 }).format(cents / 100) }
function formatDate(value: string | null) { return value ? new Date(value).toLocaleString("fr-FR") : "Jamais" }
function scopeLabel(scope: string) { return ({ gpx: "Scolarité GPX", pa: "Scolarité PA", gpx_school: "Scolarité GPX", pa_school: "Scolarité PA", gpx_exam: "Concours GPX", pa_exam: "Concours PA", active: "Je suis actif" } as Record<string, string>)[scope] ?? scope }
