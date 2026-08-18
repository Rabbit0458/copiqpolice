"use client";

import { useState } from "react";
import { CalendarClock, FilePenLine, Plus, Sparkles } from "lucide-react";
import {
  patchNotesApi,
  type EditorialStatus,
  type PatchNote,
} from "@/lib/admin/api";
import {
  Badge,
  Button,
  Card,
  Empty,
  ErrorBox,
  Loading,
  PageHeader,
  useAsync,
} from "@/components/admin/admin-ui";

const labels: Record<EditorialStatus, string> = {
  draft: "Brouillon",
  scheduled: "Planifiée",
  published: "Publiée",
  archived: "Archivée",
};
const tones: Record<EditorialStatus, "neutral" | "warn" | "good" | "bad"> = {
  draft: "neutral",
  scheduled: "warn",
  published: "good",
  archived: "bad",
};

export default function PatchNotesPage() {
  const [filter, setFilter] = useState<"" | EditorialStatus>("");
  const [editing, setEditing] = useState<PatchNote | "new" | null>(null);
  const { data, error, loading, reload } = useAsync(
    () => patchNotesApi.list(filter || undefined),
    [filter],
  );

  return (
    <>
      <PageHeader
        title="Notes de mise à jour"
        subtitle="Prépare, programme et publie les nouveautés visibles sur le site et dans l’application."
        action={
          <Button onClick={() => setEditing("new")}>
            <Plus size={16} /> Nouvelle note
          </Button>
        }
      />

      {editing && (
        <NoteForm
          note={editing === "new" ? undefined : editing}
          onCancel={() => setEditing(null)}
          onSaved={() => {
            setEditing(null);
            reload();
          }}
        />
      )}

      <div className="mb-5 flex flex-wrap gap-2">
        {(["", "draft", "scheduled", "published", "archived"] as const).map(
          (status) => (
            <button
              key={status}
              onClick={() => setFilter(status)}
              className={`rounded-xl px-3.5 py-2 text-sm font-medium transition ${
                filter === status
                  ? "bg-[var(--brand)] text-white"
                  : "border border-[var(--outline)] text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]"
              }`}
            >
              {status ? labels[status] : "Toutes"}
            </button>
          ),
        )}
      </div>

      {Boolean(error) && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data?.length === 0 && <Empty>Aucune note de mise à jour.</Empty>}

      <div className="grid gap-4 xl:grid-cols-2">
        {(data ?? []).map((note) => (
          <Card key={note.id} className="flex flex-col p-5">
            <div className="flex items-start justify-between gap-3">
              <div className="min-w-0">
                <div className="mb-2 flex items-center gap-2">
                  <Sparkles size={16} className="text-[var(--brand)]" />
                  <h2 className="font-semibold">{note.title}</h2>
                </div>
                {note.summary && (
                  <p className="text-sm text-[var(--on-surface-muted)]">
                    {note.summary}
                  </p>
                )}
              </div>
              <Badge tone={tones[note.publication_status]}>
                {labels[note.publication_status]}
              </Badge>
            </div>
            <div className="mt-4 line-clamp-5 whitespace-pre-wrap rounded-xl bg-[var(--surface-container)] p-4 text-sm leading-relaxed">
              {note.body}
            </div>
            <div className="mt-4 flex flex-wrap items-center justify-between gap-3 text-xs text-[var(--on-surface-faint)]">
              <span className="inline-flex items-center gap-1.5">
                <CalendarClock size={14} />
                {note.publication_status === "scheduled" && note.scheduled_at
                  ? `Prévue le ${new Date(note.scheduled_at).toLocaleString("fr-FR")}`
                  : `Modifiée le ${new Date(note.updated_at).toLocaleString("fr-FR")}`}
              </span>
              <Button
                variant="ghost"
                className="!py-1.5 !text-xs"
                onClick={() => setEditing(note)}
              >
                <FilePenLine size={14} /> Modifier
              </Button>
            </div>
          </Card>
        ))}
      </div>
    </>
  );
}

function NoteForm({
  note,
  onCancel,
  onSaved,
}: {
  note?: PatchNote;
  onCancel: () => void;
  onSaved: () => void;
}) {
  const [title, setTitle] = useState(note?.title ?? "");
  const [summary, setSummary] = useState(note?.summary ?? "");
  const [body, setBody] = useState(note?.body ?? "");
  const [status, setStatus] = useState<EditorialStatus>(
    note?.publication_status ?? "draft",
  );
  const [scheduledAt, setScheduledAt] = useState(
    note?.scheduled_at ? note.scheduled_at.slice(0, 16) : "",
  );
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState<unknown>(null);
  const input =
    "w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3.5 py-2.5 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/10";

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setErr(null);
    try {
      await patchNotesApi.save({
        id: note?.id,
        title,
        summary,
        body,
        status,
        scheduledAt:
          status === "scheduled" && scheduledAt
            ? new Date(scheduledAt).toISOString()
            : null,
      });
      onSaved();
    } catch (caught) {
      setErr(caught);
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card className="mb-6 overflow-hidden">
      <div className="border-b border-[var(--outline)] bg-[var(--surface-container)] px-5 py-4">
        <h2 className="font-semibold">
          {note ? "Modifier la note" : "Créer une note de mise à jour"}
        </h2>
        <p className="mt-1 text-xs text-[var(--on-surface-muted)]">
          Le contenu publié apparaîtra automatiquement dans le centre
          d’information.
        </p>
      </div>
      <form onSubmit={submit} className="grid gap-4 p-5 lg:grid-cols-2">
        <label className="block">
          <span className="mb-1.5 block text-xs font-semibold">Titre</span>
          <input
            className={input}
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            required
          />
        </label>
        <label className="block">
          <span className="mb-1.5 block text-xs font-semibold">Résumé</span>
          <input
            className={input}
            value={summary}
            onChange={(e) => setSummary(e.target.value)}
          />
        </label>
        <label className="block">
          <span className="mb-1.5 block text-xs font-semibold">Visibilité</span>
          <select
            className={input}
            value={status}
            onChange={(e) => setStatus(e.target.value as EditorialStatus)}
          >
            {Object.entries(labels).map(([value, label]) => (
              <option key={value} value={value}>
                {label}
              </option>
            ))}
          </select>
        </label>
        {status === "scheduled" && (
          <label className="block">
            <span className="mb-1.5 block text-xs font-semibold">
              Date de publication
            </span>
            <input
              type="datetime-local"
              className={input}
              value={scheduledAt}
              onChange={(e) => setScheduledAt(e.target.value)}
              required
            />
          </label>
        )}
        <label className="block lg:col-span-2">
          <span className="mb-1.5 block text-xs font-semibold">
            Contenu complet
          </span>
          <textarea
            className={input}
            rows={10}
            value={body}
            onChange={(e) => setBody(e.target.value)}
            required
            placeholder={
              "## Nouveautés\n\n- Première amélioration\n- Deuxième amélioration"
            }
          />
        </label>
        <div className="lg:col-span-2">
          <ErrorBox error={err} />
        </div>
        <div className="flex gap-2 lg:col-span-2">
          <Button type="submit" disabled={busy}>
            {busy ? "Enregistrement…" : "Enregistrer"}
          </Button>
          <Button type="button" variant="ghost" onClick={onCancel}>
            Annuler
          </Button>
        </div>
      </form>
    </Card>
  );
}
