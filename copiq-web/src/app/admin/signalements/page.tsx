"use client"

import { useEffect, useState } from "react"
import { Eye, RotateCcw, Search, Trash2 } from "lucide-react"
import toast from "react-hot-toast"
import { supportApi } from "@/lib/admin/api"
import {
  Badge,
  Button,
  Card,
  Empty,
  ErrorBox,
  Loading,
  PageHeader,
  useAsync,
} from "@/components/admin/admin-ui"
import { ContentReportInspector } from "./content-report-inspector"

type Report = {
  kind: string
  id: string
  created_at: string
  status: string
  module?: string | null
  category?: string | null
  question_id?: string | null
  question?: string | null
  message?: string | null
  report_type?: string | null
  email?: string | null
  archived?: boolean
}

const KINDS: [string, string][] = [
  ["", "Tous"],
  ["cas_pratique", "Cas pratiques"],
  ["question", "Questions de quiz"],
  ["culture", "Culture générale"],
  ["psy", "Psychotechniques"],
  ["bug", "Bugs"],
  ["contact", "Contacts"],
  ["forum", "Forum"],
]

export default function SignalementsPage() {
  const [kind, setKind] = useState("")
  const [status, setStatus] = useState("new")
  const [search, setSearch] = useState("")
  const [debouncedSearch, setDebouncedSearch] = useState("")
  const [selected, setSelected] = useState<Report | null>(null)
  useEffect(() => { const timer=setTimeout(()=>setDebouncedSearch(search.trim()),350); return()=>clearTimeout(timer) },[search])
  const { data, error, loading, reload } = useAsync(
    () => supportApi.reports(kind, status, debouncedSearch) as Promise<Report[]>,
    [kind, status, debouncedSearch],
  )

  return (
    <>
      <PageHeader
        title="Centre de correction du contenu"
        subtitle="Identifier, examiner, corriger et clôturer chaque signalement depuis sa ligne Supabase"
      />

      <div className="mb-4 space-y-2">
        <div className="flex flex-wrap gap-2">
          {KINDS.map(([v, l]) => (
            <button
              key={v}
              onClick={() => setKind(v)}
              className={`rounded-lg px-3 py-1.5 text-sm transition ${
                kind === v
                  ? "bg-[var(--brand)] text-white"
                  : "border border-[var(--outline)] text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]"
              }`}
            >
              {l}
            </button>
          ))}
        </div>
        <div className="flex flex-wrap gap-2">
          <label className="relative min-w-52 flex-1"><Search className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" size={17}/><span className="sr-only">Rechercher</span><input placeholder="Question, commentaire, email, ID…" value={search} onChange={(e) => setSearch(e.target.value)} className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] py-2 pl-10 pr-3 text-sm outline-none focus:border-[var(--brand)]" /></label>
          {[
            ["new", "Nouveaux"],
            ["resolved", "Traités"],
            ["archived", "Archivés"],
            ["", "Tous"],
          ].map(([v, l]) => (
            <button
              key={v}
              onClick={() => setStatus(v)}
              className={`rounded-lg px-3 py-2 text-sm transition ${
                status === v
                  ? "bg-[var(--brand)] text-white"
                  : "border border-[var(--outline)] text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]"
              }`}
            >
              {l}
            </button>
          ))}
        </div>
      </div>

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data && data.length === 0 && <Empty>Aucun signalement dans cette catégorie.</Empty>}

      <div className="space-y-3">
        {(data ?? []).map((r) => (
          <ReportCard key={`${r.kind}-${r.id}`} r={r} onDone={reload} onInspect={()=>setSelected(r)} />
        ))}
      </div>
      {selected && <ContentReportInspector report={selected} onClose={()=>setSelected(null)} onChanged={reload}/>} 
    </>
  )
}

function ReportCard({ r, onDone, onInspect }: { r: Report; onDone: () => void; onInspect:()=>void }) {
  const [busy, setBusy] = useState(false)
  const [comment, setComment] = useState("")
  const [err, setErr] = useState<unknown>(null)

  async function resolve(archive: boolean) {
    setBusy(true)
    setErr(null)
    try {
      const result = await supportApi.resolveReportWithEmail(r.kind, r.id, archive, comment || undefined)
      if (result.email_sent) toast.success(archive ? "Signalement traité, archivé et email envoyé." : "Signalement traité et email envoyé.")
      else toast.error("Signalement traité, mais l’email automatique n’a pas pu être envoyé.")
      onDone()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  async function deleteReport() {
    if (!window.confirm(`Supprimer définitivement le signalement #${r.id} de ${r.email ?? "cet utilisateur"} ?\n\nLa ligne du signalement sera supprimée de Supabase. La question restera intacte.`)) return
    setBusy(true)
    setErr(null)
    try {
      const result = await supportApi.deleteReport(r.kind, r.id)
      if (!result.ok) throw new Error("Supabase n’a supprimé aucune ligne.")
      toast.success(`Signalement #${r.id} supprimé de Supabase.`)
      onDone()
    } catch (e) {
      setErr(e)
      toast.error(e instanceof Error ? e.message : "La suppression a échoué.")
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="p-4">
      <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
        <div className="flex items-center gap-2">
          <Badge tone="brand">{r.kind}</Badge>
          {r.module && <Badge>{r.module}</Badge>}
          {r.report_type && <Badge tone="warn">{r.report_type}</Badge>}
        </div>
        <span className="text-xs text-[var(--on-surface-faint)]">
          {new Date(r.created_at).toLocaleString("fr-FR")}
        </span>
      </div>

      {r.question && (
        <p className="mb-1.5 text-sm">
          <span className="text-xs uppercase tracking-wide text-[var(--on-surface-faint)]">
            Question ·{" "}
          </span>
          {r.question}
        </p>
      )}
      {r.message && (
        <p className="mb-1.5 whitespace-pre-wrap rounded-lg bg-[var(--surface-container)] p-2.5 text-sm">
          {r.message}
        </p>
      )}
      <p className="text-xs text-[var(--on-surface-faint)]">
        {r.email ?? "—"}
        {` · signalement #${r.id}`}{r.question_id ? ` · contenu #${r.question_id}` : ""}
      </p>

      {r.status !== "resolved" && (
        <div className="mt-3 space-y-2 border-t border-[var(--outline-variant)] pt-3">
          <input
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            placeholder="Commentaire interne (journalisé)…"
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
          />
          <ErrorBox error={err} />
          <div className="flex flex-wrap gap-2">
            <Button variant="ghost" onClick={onInspect} disabled={busy}><Eye size={16}/>Examiner et corriger</Button>
            <Button onClick={() => resolve(false)} disabled={busy}>
              Marquer traité
            </Button>
            <Button variant="ghost" onClick={() => resolve(true)} disabled={busy}>
              Traiter &amp; archiver
            </Button>
            <Button variant="ghost" onClick={() => void deleteReport()} disabled={busy}><Trash2 size={16}/>Supprimer</Button>
          </div>
        </div>
      )}
      {r.status === "resolved" && <div className="mt-3 flex flex-wrap gap-2 border-t border-[var(--outline-variant)] pt-3"><Button onClick={onInspect}><Eye size={16}/>Voir la correction</Button><Button variant="ghost" disabled={busy} onClick={async()=>{setBusy(true);try{await supportApi.setReportStatus(r.kind,r.id,"new",false);toast.success("Signalement réouvert.");onDone()}catch(e){setErr(e)}finally{setBusy(false)}}}><RotateCcw size={16}/>Réouvrir</Button><Button variant="ghost" onClick={() => void deleteReport()} disabled={busy}><Trash2 size={16}/>Supprimer</Button></div>}
    </Card>
  )
}
