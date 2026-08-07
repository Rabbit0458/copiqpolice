"use client"

import { useMemo, useState } from "react"
import {
  AlertTriangle,
  CheckCircle2,
  ChevronLeft,
  ChevronRight,
  Eye,
  FileWarning,
  LockKeyhole,
  MessageSquareMore,
  Search,
  ShieldAlert,
  Users,
  XCircle,
  type LucideIcon,
} from "lucide-react"
import {
  communityForumApi,
  type CommunityAdminReport,
  type CommunityMessageEvidence,
  type CommunityReportPriority,
  type CommunityReportStatus,
  type CommunityReportTarget,
} from "@/lib/admin/api"
import {
  Badge,
  Button,
  Card,
  Empty,
  ErrorBox,
  Loading,
  useAsync,
} from "@/components/admin/admin-ui"

const SPACES = [
  ["", "Tous les espaces"],
  ["global", "Tout le monde"],
  ["pa_exam", "Concours policier adjoint"],
  ["gpx_exam", "Concours gardien de la paix"],
  ["pa_school", "École policier adjoint"],
  ["gpx_school", "École gardien de la paix"],
] as const

const STATUS_LABELS: Record<CommunityReportStatus, string> = {
  new: "Nouveau",
  triaged: "Qualifié",
  in_progress: "En cours",
  resolved: "Résolu",
  rejected: "Classé sans suite",
  appealed: "Contesté",
}

export function CommunityModeration() {
  const [status, setStatus] = useState<CommunityReportStatus | "">("new")
  const [priority, setPriority] = useState<CommunityReportPriority | "">("")
  const [targetType, setTargetType] = useState<CommunityReportTarget | "">("")
  const [spaceId, setSpaceId] = useState("")
  const [search, setSearch] = useState("")
  const [page, setPage] = useState(0)
  const limit = 30
  const filters = useMemo(
    () => ({
      status: status || undefined,
      priority: priority || undefined,
      targetType: targetType || undefined,
      spaceId: spaceId || undefined,
      search: search.trim() || undefined,
      limit,
      offset: page * limit,
    }),
    [status, priority, targetType, spaceId, search, page],
  )
  const reports = useAsync(
    () => communityForumApi.listReports(filters),
    [filters],
  )
  const dashboard = useAsync(
    () => communityForumApi.dashboard(spaceId || undefined),
    [spaceId],
  )
  const total = reports.data?.[0]?.total_count ?? 0
  const resetPage = () => setPage(0)

  return (
    <div className="space-y-5">
      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
        <Metric icon={MessageSquareMore} label="Publications aujourd'hui" value={dashboard.data?.posts_today} />
        <Metric icon={Users} label="Réponses aujourd'hui" value={dashboard.data?.comments_today} />
        <Metric icon={ShieldAlert} label="Signalements ouverts" value={dashboard.data?.open_reports} tone="bad" />
        <Metric icon={AlertTriangle} label="Sanctions actives" value={dashboard.data?.active_sanctions} tone="warn" />
      </div>

      <Card className="p-4">
        <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-5">
          <label className="relative xl:col-span-2">
            <span className="sr-only">Rechercher</span>
            <Search size={17} className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" />
            <input
              value={search}
              onChange={(event) => { setSearch(event.target.value); resetPage() }}
              placeholder="Motif, membre ou contenu"
              className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] pl-10 pr-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15"
            />
          </label>
          <Select label="Statut" value={status} onChange={(value) => { setStatus(value as CommunityReportStatus | ""); resetPage() }} options={[["", "Tous les statuts"], ...Object.entries(STATUS_LABELS)]} />
          <Select label="Priorité" value={priority} onChange={(value) => { setPriority(value as CommunityReportPriority | ""); resetPage() }} options={[["", "Toutes priorités"], ["urgent", "Urgente"], ["high", "Haute"], ["normal", "Normale"]]} />
          <Select label="Type" value={targetType} onChange={(value) => { setTargetType(value as CommunityReportTarget | ""); resetPage() }} options={[["", "Tous les contenus"], ["post", "Publications"], ["comment", "Réponses"], ["message", "Messages privés"], ["profile", "Profils"], ["room", "Conversations"]]} />
        </div>
        <div className="mt-3 max-w-md">
          <Select label="Espace communautaire" value={spaceId} onChange={(value) => { setSpaceId(value); resetPage() }} options={SPACES} />
        </div>
      </Card>

      {dashboard.error != null && <ErrorBox error={dashboard.error} />}
      {reports.error != null && <ErrorBox error={reports.error} />}
      {reports.loading && <Loading />}
      {!reports.loading && reports.data?.length === 0 && (
        <Empty>Aucun signalement ne correspond à ces filtres.</Empty>
      )}
      <div className="space-y-3">
        {(reports.data ?? []).map((report) => (
          <ReportCard
            key={report.id}
            report={report}
            onDone={() => { reports.reload(); dashboard.reload() }}
          />
        ))}
      </div>

      {total > limit && (
        <div className="flex items-center justify-between rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] px-4 py-3">
          <span className="text-sm text-[var(--on-surface-muted)]">
            {page * limit + 1}–{Math.min((page + 1) * limit, total)} sur {total}
          </span>
          <div className="flex gap-2">
            <Button variant="ghost" disabled={page === 0} onClick={() => setPage((value) => Math.max(0, value - 1))}>
              <ChevronLeft size={16} /> Précédent
            </Button>
            <Button variant="ghost" disabled={(page + 1) * limit >= total} onClick={() => setPage((value) => value + 1)}>
              Suivant <ChevronRight size={16} />
            </Button>
          </div>
        </div>
      )}
    </div>
  )
}

function Metric({ icon: Icon, label, value, tone }: { icon: LucideIcon; label: string; value?: number; tone?: "bad" | "warn" }) {
  const color = tone === "bad" ? "bg-[var(--danger)]/10 text-[var(--danger)]" : tone === "warn" ? "bg-amber-500/10 text-amber-600" : "bg-[var(--brand)]/10 text-[var(--brand)]"
  return (
    <Card className="flex items-center gap-3 p-4">
      <span className={`grid h-10 w-10 place-items-center rounded-xl ${color}`}><Icon size={19} /></span>
      <span><strong className="block text-xl tabular-nums">{value ?? "—"}</strong><span className="text-xs text-[var(--on-surface-muted)]">{label}</span></span>
    </Card>
  )
}

function Select({ value, onChange, options, label }: { value: string; onChange: (value: string) => void; options: readonly (readonly [string, string])[]; label: string }) {
  return (
    <label className="block">
      <span className="sr-only">{label}</span>
      <select aria-label={label} value={value} onChange={(event) => onChange(event.target.value)} className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15">
        {options.map(([key, text]) => <option key={key} value={key}>{text}</option>)}
      </select>
    </label>
  )
}

function ReportCard({ report, onDone }: { report: CommunityAdminReport; onDone: () => void }) {
  const [resolution, setResolution] = useState("")
  const [accessReason, setAccessReason] = useState("")
  const [evidence, setEvidence] = useState<CommunityMessageEvidence[] | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<unknown>(null)
  const open = ["new", "triaged", "in_progress", "appealed"].includes(report.status)
  const subject = report.subject_name || (report.subject_username ? `@${report.subject_username}` : "Membre inconnu")
  const reporter = report.reporter_name || (report.reporter_username ? `@${report.reporter_username}` : "Membre")

  async function resolve(status: "resolved" | "rejected") {
    if (resolution.trim().length < 3) return setError(new Error("Ajoute une décision d'au moins 3 caractères."))
    if (!confirm(status === "resolved" ? "Confirmer la résolution ?" : "Classer sans suite ?")) return
    setBusy(true); setError(null)
    try { await communityForumApi.resolveReport(report.id, status, resolution.trim()); onDone() } catch (cause) { setError(cause) } finally { setBusy(false) }
  }

  async function moderate(action: "hide" | "lock" | "remove") {
    if (resolution.trim().length < 3) return setError(new Error("Indique d'abord le motif de modération."))
    if (!confirm(`Confirmer l'action « ${action} » sur cette publication ?`)) return
    setBusy(true); setError(null)
    try { await communityForumApi.moderatePost(report.target_id, action, resolution.trim()); onDone() } catch (cause) { setError(cause) } finally { setBusy(false) }
  }

  async function openEvidence() {
    if (accessReason.trim().length < 10) return setError(new Error("Le motif de consultation doit contenir au moins 10 caractères."))
    setBusy(true); setError(null)
    try { setEvidence(await communityForumApi.openMessageEvidence(report.id, accessReason.trim())) } catch (cause) { setError(cause) } finally { setBusy(false) }
  }

  return (
    <Card className={`overflow-hidden ${report.priority === "urgent" ? "border-[var(--danger)]/50" : ""}`}>
      <div className="p-4 md:p-5">
        <div className="flex flex-wrap items-start justify-between gap-3">
          <div className="flex flex-wrap items-center gap-2">
            <Badge tone={report.priority === "urgent" ? "bad" : report.priority === "high" ? "warn" : "neutral"}>{report.priority === "urgent" ? "Urgent" : report.priority === "high" ? "Priorité haute" : "Priorité normale"}</Badge>
            <Badge tone={open ? "warn" : "good"}>{STATUS_LABELS[report.status]}</Badge>
            <Badge tone="neutral">{report.space_label}</Badge>
          </div>
          <span className="text-xs text-[var(--on-surface-faint)]">{new Date(report.created_at).toLocaleString("fr-FR")}</span>
        </div>

        <div className="mt-4 grid gap-4 lg:grid-cols-[minmax(0,1fr)_260px]">
          <div>
            <div className="flex items-center gap-2 text-sm font-semibold"><FileWarning size={17} className="text-[var(--danger)]" /> {report.reason}</div>
            {report.details && <p className="mt-2 whitespace-pre-wrap text-sm text-[var(--on-surface-muted)]">{report.details}</p>}
            <div className="mt-3 rounded-xl bg-[var(--surface-container)] p-3">
              <div className="text-sm font-semibold">{report.target_title}</div>
              {report.target_content ? (
                <p className="mt-1 whitespace-pre-wrap text-sm text-[var(--on-surface-muted)]">{report.target_content}</p>
              ) : report.target_type === "message" ? (
                <p className="mt-1 flex items-center gap-2 text-xs text-[var(--on-surface-muted)]"><LockKeyhole size={14} /> Contenu privé masqué. Consultation limitée, motivée et journalisée.</p>
              ) : null}
            </div>
          </div>
          <dl className="space-y-2 rounded-xl border border-[var(--outline-variant)] p-3 text-xs">
            <Identity label="Compte signalé" value={subject} username={report.subject_username} />
            <Identity label="Signalé par" value={reporter} username={report.reporter_username} />
            <Identity label="Type" value={report.target_type} />
            {report.target_status && <Identity label="État du contenu" value={report.target_status} />}
          </dl>
        </div>

        {report.appeal_text && <div className="mt-4 rounded-xl border border-amber-500/30 bg-amber-500/5 p-3 text-sm"><strong>Contestation du membre</strong><p className="mt-1 text-[var(--on-surface-muted)]">{report.appeal_text}</p></div>}

        {report.target_type === "message" && open && (
          <div className="mt-4 rounded-xl border border-[var(--outline-variant)] p-3">
            <div className="flex flex-col gap-2 sm:flex-row">
              <input value={accessReason} onChange={(event) => setAccessReason(event.target.value)} placeholder="Motif précis de consultation (obligatoire et audité)" className="min-h-11 flex-1 rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm outline-none focus:border-[var(--brand)]" />
              <Button variant="ghost" onClick={openEvidence} disabled={busy}><Eye size={16} /> Consulter les preuves</Button>
            </div>
            {evidence && <EvidenceList rows={evidence} />}
          </div>
        )}

        {open ? (
          <div className="mt-4 border-t border-[var(--outline-variant)] pt-4">
            <textarea value={resolution} onChange={(event) => setResolution(event.target.value)} rows={2} placeholder="Décision et justification — enregistrées dans le journal d'audit" className="w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]" />
            {error != null && <ErrorBox error={error} />}
            <div className="mt-3 flex flex-wrap gap-2">
              {report.target_type === "post" && <><Button variant="ghost" disabled={busy} onClick={() => moderate("hide")}>Masquer</Button><Button variant="ghost" disabled={busy} onClick={() => moderate("lock")}>Verrouiller</Button><Button variant="danger" disabled={busy} onClick={() => moderate("remove")}>Retirer</Button></>}
              <span className="flex-1" />
              <Button variant="ghost" disabled={busy} onClick={() => resolve("rejected")}><XCircle size={16} /> Sans suite</Button>
              <Button disabled={busy} onClick={() => resolve("resolved")}><CheckCircle2 size={16} /> Résoudre</Button>
            </div>
          </div>
        ) : report.resolution ? (
          <p className="mt-4 rounded-xl bg-[var(--success)]/5 p-3 text-sm"><strong>Décision :</strong> {report.resolution}</p>
        ) : null}
      </div>
    </Card>
  )
}

function Identity({ label, value, username }: { label: string; value: string; username?: string | null }) {
  return <div><dt className="text-[var(--on-surface-faint)]">{label}</dt><dd className="mt-0.5 font-medium">{value}</dd>{username && !value.includes(`@${username}`) && <dd className="text-[var(--on-surface-faint)]">@{username}</dd>}</div>
}

function EvidenceList({ rows }: { rows: CommunityMessageEvidence[] }) {
  return (
    <div className="mt-3 space-y-2 border-t border-[var(--outline-variant)] pt-3">
      <div className="flex items-center gap-2 text-xs font-medium text-[var(--on-surface-muted)]"><LockKeyhole size={14} /> Extrait borné : trois messages avant et après au maximum</div>
      {rows.map((row) => (
        <div key={row.message_id} className={`rounded-xl p-3 text-sm ${row.is_reported ? "border border-[var(--danger)]/40 bg-[var(--danger)]/5" : "bg-[var(--surface-container)]"}`}>
          <div className="mb-1 flex justify-between gap-2 text-[11px] text-[var(--on-surface-faint)]"><span>{row.is_reported ? "Message signalé" : `Contexte ${row.context_position}`}</span><span>{new Date(row.created_at).toLocaleString("fr-FR")}</span></div>
          <p className="whitespace-pre-wrap">{row.content}</p>
        </div>
      ))}
    </div>
  )
}
