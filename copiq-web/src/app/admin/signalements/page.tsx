"use client"

import { useState } from "react"
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
  const { data, error, loading, reload } = useAsync(
    () => supportApi.reports(kind, status, search) as Promise<Report[]>,
    [kind, status, search],
  )

  return (
    <>
      <PageHeader
        title="Signalements & support"
        subtitle="Fautes signalées par les utilisateurs, bugs et messages de contact"
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
          <input
            placeholder="Rechercher…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="min-w-52 flex-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
          />
          {[
            ["new", "Nouveaux"],
            ["resolved", "Traités"],
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
          <ReportCard key={`${r.kind}-${r.id}`} r={r} onDone={reload} />
        ))}
      </div>
    </>
  )
}

function ReportCard({ r, onDone }: { r: Report; onDone: () => void }) {
  const [busy, setBusy] = useState(false)
  const [comment, setComment] = useState("")
  const [err, setErr] = useState<unknown>(null)

  async function resolve(archive: boolean) {
    setBusy(true)
    setErr(null)
    try {
      await supportApi.resolveReport(r.kind, r.id, "resolved", archive, comment || undefined)
      onDone()
    } catch (e) {
      setErr(e)
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
        {r.question_id ? ` · id ${r.question_id}` : ""}
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
          <div className="flex gap-2">
            <Button onClick={() => resolve(false)} disabled={busy}>
              Marquer traité
            </Button>
            <Button variant="ghost" onClick={() => resolve(true)} disabled={busy}>
              Traiter &amp; archiver
            </Button>
          </div>
        </div>
      )}
    </Card>
  )
}
