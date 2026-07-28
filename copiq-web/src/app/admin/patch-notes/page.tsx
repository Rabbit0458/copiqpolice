"use client"

import { useState } from "react"
import { patchNotesApi, type PatchNote } from "@/lib/admin/api"
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

export default function PatchNotesPage() {
  const [filter, setFilter] = useState<"" | "yes" | "no">("")
  const { data, error, loading, reload } = useAsync(
    () => patchNotesApi.list(filter || undefined),
    [filter],
  )
  const [creating, setCreating] = useState(false)

  return (
    <>
      <PageHeader
        title="Notes de patch"
        subtitle="Nouveautés affichées aux utilisateurs après une mise à jour"
        action={<Button onClick={() => setCreating(true)}>+ Nouvelle note</Button>}
      />

      {creating && (
        <NoteForm
          onCancel={() => setCreating(false)}
          onSaved={() => {
            setCreating(false)
            reload()
          }}
        />
      )}

      <div className="mb-4 flex flex-wrap gap-2">
        {(
          [
            ["", "Toutes"],
            ["yes", "Publiées"],
            ["no", "Brouillons"],
          ] as const
        ).map(([v, l]) => (
          <button
            key={v}
            onClick={() => setFilter(v)}
            className={`rounded-lg px-3 py-2 text-sm transition ${
              filter === v
                ? "bg-[var(--brand)] text-white"
                : "border border-[var(--outline)] text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]"
            }`}
          >
            {l}
          </button>
        ))}
      </div>

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data && data.length === 0 && <Empty>Aucune note de patch.</Empty>}

      <div className="space-y-3">
        {(data ?? []).map((n) => (
          <NoteCard key={n.id} n={n} onChanged={reload} />
        ))}
      </div>
    </>
  )
}

function NoteCard({ n, onChanged }: { n: PatchNote; onChanged: () => void }) {
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)

  async function run(fn: () => Promise<unknown>) {
    setBusy(true)
    setErr(null)
    try {
      await fn()
      onChanged()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="p-4">
      <div className="mb-2 flex flex-wrap items-start justify-between gap-2">
        <div className="min-w-0">
          <div className="text-sm font-semibold">{n.title}</div>
          <div className="text-xs text-[var(--on-surface-faint)]">
            {new Date(n.created_at).toLocaleString("fr-FR")}
            {n.author_email ? ` · ${n.author_email}` : ""}
          </div>
        </div>
        <Badge tone={n.is_published ? "good" : "warn"}>
          {n.is_published ? "publiée" : "brouillon"}
        </Badge>
      </div>

      <div className="whitespace-pre-wrap rounded-lg bg-[var(--surface-container)] p-3 text-sm leading-relaxed">
        {n.body}
      </div>

      <ErrorBox error={err} />
      <div className="mt-3 flex flex-wrap gap-2">
        <Button
          variant="ghost"
          disabled={busy}
          onClick={() => run(() => patchNotesApi.setPublished(n.id, !n.is_published))}
          className="!py-1.5 !text-xs"
        >
          {n.is_published ? "Dépublier" : "Publier"}
        </Button>
        <Button
          variant="danger"
          disabled={busy}
          onClick={() => {
            if (!confirm(`Supprimer définitivement « ${n.title} » ?`)) return
            run(() => patchNotesApi.remove(n.id))
          }}
          className="!py-1.5 !text-xs"
        >
          Supprimer
        </Button>
      </div>
    </Card>
  )
}

function NoteForm({
  onCancel,
  onSaved,
}: {
  onCancel: () => void
  onSaved: () => void
}) {
  const [title, setTitle] = useState("")
  const [body, setBody] = useState("")
  const [publish, setPublish] = useState(false)
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setErr(null)
    try {
      await patchNotesApi.create(title, body, publish)
      onSaved()
    } catch (e2) {
      setErr(e2)
    } finally {
      setBusy(false)
    }
  }

  const ic =
    "w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"

  return (
    <Card className="mb-4 p-5">
      <h2 className="mb-3 text-sm font-semibold">Nouvelle note de patch</h2>
      <form onSubmit={submit} className="space-y-3">
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
            Titre
          </span>
          <input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            required
            placeholder="Version 1.2 — Cas pratiques"
            className={ic}
          />
        </label>
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
            Contenu
          </span>
          <textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            rows={8}
            required
            placeholder={"• 5 nouveaux cas pratiques\n• Correction du module psychotechnique\n• Corrections diverses"}
            className={ic}
          />
        </label>
        <label className="flex items-center gap-2 text-sm">
          <input
            type="checkbox"
            checked={publish}
            onChange={(e) => setPublish(e.target.checked)}
            className="h-4 w-4"
          />
          Publier immédiatement
        </label>
        <ErrorBox error={err} />
        <div className="flex gap-2">
          <Button type="submit" disabled={busy}>
            {busy ? "Création…" : "Créer"}
          </Button>
          <Button type="button" variant="ghost" onClick={onCancel}>
            Annuler
          </Button>
        </div>
      </form>
    </Card>
  )
}
