"use client"

import { BrainCircuit, CalendarCheck2, CheckCircle2, MessagesSquare, Target, Users } from "lucide-react"
import { coachAdminApi } from "@/lib/admin/api"
import { Badge, Card, ErrorBox, Loading, PageHeader, useAsync } from "@/components/admin/admin-ui"

export default function CoachAdminPage() {
  const query = useAsync(() => coachAdminApi.overview(), [])
  if (query.loading) return <Loading label="Chargement du Coach pédagogique…" />
  if (query.error || !query.data) return <ErrorBox error={query.error ?? new Error("Données indisponibles")} />
  const data = query.data
  const run = data.calendar_last_run
  const cards = [
    { icon: Users, label: "Profils Coach", value: data.users_configured },
    { icon: Target, label: "Dates de concours définies", value: data.users_with_exam_date },
    { icon: MessagesSquare, label: "Auto-évaluations", value: data.reflections },
    { icon: CalendarCheck2, label: "Échéances officielles", value: data.calendar_events },
  ]
  return <>
    <PageHeader title="Coach pédagogique" subtitle="Pilotage sécurisé de l’accompagnement personnalisé et du calendrier officiel" />
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {cards.map(({ icon: Icon, label, value }) => <Card key={label} className="p-5"><Icon className="text-[var(--brand)]" /><div className="mt-4 text-3xl font-semibold tabular-nums">{value}</div><div className="mt-1 text-sm text-[var(--on-surface-muted)]">{label}</div></Card>)}
    </div>
    <Card className="mt-5 p-5">
      <div className="flex flex-wrap items-start justify-between gap-3"><div><h2 className="flex items-center gap-2 font-semibold"><BrainCircuit size={19} /> Synchronisation Police nationale</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Contrôle automatique quotidien. La dernière copie valide reste active en cas d’indisponibilité de la source.</p></div><Badge tone={run?.status === "success" ? "good" : "warn"}>{run?.status === "success" ? "Opérationnelle" : run?.status ?? "Jamais exécutée"}</Badge></div>
      <div className="mt-5 grid gap-4 md:grid-cols-3"><Metric label="Événements trouvés" value={run?.events_found ?? 0} /><Metric label="Dernière exécution" value={run?.finished_at ? new Date(run.finished_at).toLocaleString("fr-FR") : "—"} /><Metric label="Bilans hebdomadaires" value={data.weekly_summaries} /></div>
      {run?.status === "success" && <div className="mt-4 flex items-center gap-2 rounded-xl bg-[var(--success)]/10 p-3 text-sm text-[var(--success)]"><CheckCircle2 size={18} /> Le calendrier GPX et PA est à jour.</div>}
      {run?.error_message && <div className="mt-4 rounded-xl bg-[var(--danger)]/10 p-3 text-sm text-[var(--danger)]">{run.error_message}</div>}
    </Card>
  </>
}

function Metric({ label, value }: { label: string; value: React.ReactNode }) { return <div className="rounded-2xl border border-[var(--outline-variant)] p-4"><div className="text-xs text-[var(--on-surface-muted)]">{label}</div><div className="mt-1 font-semibold">{value}</div></div> }
