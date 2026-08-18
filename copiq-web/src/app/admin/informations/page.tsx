"use client";

import { useMemo, useState } from "react";
import { BookOpen, Headphones, Plus, Search, ShieldCheck } from "lucide-react";
import {
  informationAdminApi,
  type EditorialStatus,
  type InformationContent,
  type InformationContentType,
  type SupportRequest,
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

const labels: Record<InformationContentType, string> = {
  information: "Informations",
  faq: "FAQ",
  legal_notice: "Mentions légales",
  privacy: "Confidentialité",
  support: "Présentation du support",
  service_status: "État des services",
};
const blank: Omit<InformationContent, "id" | "created_at" | "updated_at"> = {
  content_type: "faq",
  slug: "",
  title: "",
  summary: "",
  body_md: "",
  category: "Général",
  sort_order: 0,
  status: "draft",
  scheduled_at: null,
  published_at: null,
  archived_at: null,
  metadata: {},
};

export default function InformationAdminPage() {
  const [tab, setTab] = useState<"contents" | "support">("contents");
  return (
    <>
      <PageHeader
        title="Centre d'information"
        subtitle="FAQ, assistance, documents légaux et communication utilisateurs — modifiables sans republier l'application."
      />
      <div className="mb-6 grid gap-3 sm:grid-cols-2">
        <TabCard
          active={tab === "contents"}
          icon={BookOpen}
          title="Contenus publics"
          subtitle="Rédiger, programmer, publier ou archiver"
          onClick={() => setTab("contents")}
        />
        <TabCard
          active={tab === "support"}
          icon={Headphones}
          title="Demandes de support"
          subtitle="Lire, prioriser et suivre les réponses"
          onClick={() => setTab("support")}
        />
      </div>
      {tab === "contents" ? <ContentsManager /> : <SupportManager />}
    </>
  );
}

function TabCard({
  active,
  icon: Icon,
  title,
  subtitle,
  onClick,
}: {
  active: boolean;
  icon: typeof BookOpen;
  title: string;
  subtitle: string;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className={`cursor-pointer rounded-2xl border p-4 text-left transition-colors duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${active ? "border-[var(--brand)] bg-[var(--brand)]/8" : "border-[var(--outline)] bg-[var(--surface)] hover:bg-[var(--surface-container)]"}`}
    >
      <div className="flex items-center gap-3">
        <span
          className={`grid h-10 w-10 place-items-center rounded-xl ${active ? "bg-[var(--brand)] text-white" : "bg-[var(--surface-container)] text-[var(--on-surface-muted)]"}`}
        >
          <Icon size={19} />
        </span>
        <div>
          <div className="font-semibold">{title}</div>
          <div className="text-xs text-[var(--on-surface-muted)]">
            {subtitle}
          </div>
        </div>
      </div>
    </button>
  );
}

function ContentsManager() {
  const [type, setType] = useState<InformationContentType | "">("");
  const [status, setStatus] = useState<EditorialStatus | "">("");
  const [search, setSearch] = useState("");
  const [editing, setEditing] = useState<Partial<InformationContent> | null>(
    null,
  );
  const { data, error, loading, reload } = useAsync(
    () =>
      informationAdminApi.list(type || undefined, status || undefined, search),
    [type, status, search],
  );
  return (
    <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_minmax(420px,.85fr)]">
      <section>
        <div className="mb-4 flex flex-wrap gap-2">
          <label className="relative min-w-56 flex-1">
            <Search
              className="absolute left-3 top-2.5 text-[var(--on-surface-faint)]"
              size={17}
            />
            <span className="sr-only">Rechercher</span>
            <input
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Rechercher un contenu…"
              className={`${inputClass} pl-10`}
            />
          </label>
          <select
            aria-label="Type de contenu"
            value={type}
            onChange={(e) =>
              setType(e.target.value as InformationContentType | "")
            }
            className={inputClass}
          >
            <option value="">Tous les types</option>
            {Object.entries(labels).map(([v, l]) => (
              <option value={v} key={v}>
                {l}
              </option>
            ))}
          </select>
          <select
            aria-label="Statut"
            value={status}
            onChange={(e) => setStatus(e.target.value as EditorialStatus | "")}
            className={inputClass}
          >
            <option value="">Tous les statuts</option>
            <option value="draft">Brouillons</option>
            <option value="scheduled">Programmés</option>
            <option value="published">Publiés</option>
            <option value="archived">Archivés</option>
          </select>
          <Button onClick={() => setEditing({ ...blank })}>
            <Plus size={16} /> Nouveau
          </Button>
        </div>
        {Boolean(error) && <ErrorBox error={error} />}
        {loading && <Loading />}
        {data?.length === 0 && (
          <Empty>Aucun contenu ne correspond aux filtres.</Empty>
        )}
        <div className="space-y-3">
          {data?.map((item) => (
            <button
              key={item.id}
              onClick={() => setEditing(item)}
              className="block w-full cursor-pointer rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-4 text-left transition-colors hover:bg-[var(--surface-container)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
            >
              <div className="flex items-start justify-between gap-3">
                <div>
                  <div className="mb-1 flex flex-wrap items-center gap-2">
                    <Badge>{labels[item.content_type]}</Badge>
                    <StatusBadge status={item.status} />
                  </div>
                  <h2 className="font-semibold">{item.title}</h2>
                  <p className="mt-1 line-clamp-2 text-sm text-[var(--on-surface-muted)]">
                    {item.summary || item.body_md}
                  </p>
                </div>
                <span className="shrink-0 text-xs text-[var(--on-surface-faint)]">
                  {new Date(item.updated_at).toLocaleDateString("fr-FR")}
                </span>
              </div>
            </button>
          ))}
        </div>
      </section>
      <aside className="xl:sticky xl:top-24 xl:self-start">
        {editing ? (
          <ContentEditor
            value={editing}
            onClose={() => setEditing(null)}
            onSaved={() => {
              setEditing(null);
              reload();
            }}
          />
        ) : (
          <Card className="p-8 text-center">
            <ShieldCheck
              className="mx-auto mb-3 text-[var(--brand)]"
              size={28}
            />
            <h2 className="font-semibold">Édition sécurisée</h2>
            <p className="mt-2 text-sm text-[var(--on-surface-muted)]">
              Sélectionne un contenu ou crée-en un nouveau. Les modifications ne
              deviennent visibles qu&apos;après publication.
            </p>
          </Card>
        )}
      </aside>
    </div>
  );
}

function ContentEditor({
  value,
  onClose,
  onSaved,
}: {
  value: Partial<InformationContent>;
  onClose: () => void;
  onSaved: () => void;
}) {
  const [form, setForm] = useState({ ...blank, ...value });
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);
  const set = <K extends keyof typeof form>(key: K, val: (typeof form)[K]) =>
    setForm((f) => ({ ...f, [key]: val }));
  async function save(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await informationAdminApi.save(form as InformationContent);
      onSaved();
    } catch (err) {
      setError(err);
    } finally {
      setBusy(false);
    }
  }
  async function remove() {
    if (!form.id || !confirm("Supprimer définitivement ce brouillon ?")) return;
    setBusy(true);
    try {
      await informationAdminApi.remove(form.id);
      onSaved();
    } catch (err) {
      setError(err);
      setBusy(false);
    }
  }
  return (
    <Card className="overflow-hidden">
      <div className="border-b border-[var(--outline)] bg-[var(--surface-container)] px-5 py-4">
        <h2 className="font-semibold">
          {form.id ? "Modifier le contenu" : "Nouveau contenu"}
        </h2>
        <p className="text-xs text-[var(--on-surface-muted)]">
          Markdown simple accepté : titres, listes et texte en gras.
        </p>
      </div>
      <form onSubmit={save} className="space-y-4 p-5">
        <div className="grid gap-3 sm:grid-cols-2">
          <Field label="Type">
            <select
              value={form.content_type}
              onChange={(e) =>
                set("content_type", e.target.value as InformationContentType)
              }
              className={inputClass}
            >
              {Object.entries(labels).map(([v, l]) => (
                <option value={v} key={v}>
                  {l}
                </option>
              ))}
            </select>
          </Field>
          <Field label="Catégorie">
            <input
              value={form.category}
              onChange={(e) => set("category", e.target.value)}
              className={inputClass}
            />
          </Field>
        </div>
        <Field label="Titre">
          <input
            required
            value={form.title}
            onChange={(e) => set("title", e.target.value)}
            className={inputClass}
          />
        </Field>
        <Field label="Identifiant URL">
          <input
            required
            value={form.slug}
            onChange={(e) => set("slug", e.target.value)}
            placeholder="question-abonnement"
            className={inputClass}
          />
        </Field>
        <Field label="Résumé">
          <textarea
            value={form.summary}
            onChange={(e) => set("summary", e.target.value)}
            rows={2}
            className={inputClass}
          />
        </Field>
        <Field label="Contenu complet">
          <textarea
            required
            value={form.body_md}
            onChange={(e) => set("body_md", e.target.value)}
            rows={13}
            className={`${inputClass} font-mono text-xs leading-relaxed`}
          />
        </Field>
        <div className="grid gap-3 sm:grid-cols-2">
          <Field label="Position">
            <input
              type="number"
              value={form.sort_order}
              onChange={(e) => set("sort_order", Number(e.target.value))}
              className={inputClass}
            />
          </Field>
          <Field label="Visibilité">
            <select
              value={form.status}
              onChange={(e) => set("status", e.target.value as EditorialStatus)}
              className={inputClass}
            >
              <option value="draft">Brouillon</option>
              <option value="scheduled">Planifiée</option>
              <option value="published">Publiée</option>
              <option value="archived">Archivée</option>
            </select>
          </Field>
        </div>
        {form.status === "scheduled" && (
          <Field label="Date de publication">
            <input
              required
              type="datetime-local"
              value={form.scheduled_at?.slice(0, 16) ?? ""}
              onChange={(e) =>
                set(
                  "scheduled_at",
                  e.target.value
                    ? new Date(e.target.value).toISOString()
                    : null,
                )
              }
              className={inputClass}
            />
          </Field>
        )}
        <ErrorBox error={error} />
        <div className="flex flex-wrap justify-between gap-2">
          <div>
            {form.id && form.status !== "published" && (
              <Button
                type="button"
                variant="danger"
                onClick={remove}
                disabled={busy}
              >
                Supprimer
              </Button>
            )}
          </div>
          <div className="flex gap-2">
            <Button type="button" variant="ghost" onClick={onClose}>
              Annuler
            </Button>
            <Button type="submit" disabled={busy}>
              {busy ? "Enregistrement…" : "Enregistrer"}
            </Button>
          </div>
        </div>
      </form>
    </Card>
  );
}

function SupportManager() {
  const [status, setStatus] = useState<SupportRequest["status"] | "">("");
  const [search, setSearch] = useState("");
  const [selected, setSelected] = useState<SupportRequest | null>(null);
  const { data, error, loading, reload } = useAsync(
    () => informationAdminApi.listSupport(status || undefined, search),
    [status, search],
  );
  const counts = useMemo(
    () => ({
      open:
        data?.filter((x) => !["resolved", "closed"].includes(x.status))
          .length ?? 0,
      urgent: data?.filter((x) => x.priority === "urgent").length ?? 0,
    }),
    [data],
  );
  return (
    <>
      <div className="mb-4 grid gap-3 sm:grid-cols-2">
        <Card className="p-4">
          <div className="text-2xl font-bold">{counts.open}</div>
          <div className="text-sm text-[var(--on-surface-muted)]">
            demandes ouvertes
          </div>
        </Card>
        <Card className="p-4">
          <div className="text-2xl font-bold text-[var(--danger)]">
            {counts.urgent}
          </div>
          <div className="text-sm text-[var(--on-surface-muted)]">
            priorités urgentes
          </div>
        </Card>
      </div>
      <div className="mb-4 flex flex-wrap gap-2">
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Email, sujet ou message…"
          className={`${inputClass} min-w-64 flex-1`}
        />
        <select
          value={status}
          onChange={(e) =>
            setStatus(e.target.value as SupportRequest["status"] | "")
          }
          className={inputClass}
        >
          <option value="">Tous les statuts</option>
          <option value="new">Nouvelles</option>
          <option value="in_progress">En traitement</option>
          <option value="waiting_user">Attente utilisateur</option>
          <option value="resolved">Résolues</option>
          <option value="closed">Fermées</option>
        </select>
      </div>
      {Boolean(error) && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data?.length === 0 && <Empty>Aucune demande.</Empty>}
      <div className="space-y-3">
        {data?.map((request) => (
          <SupportCard
            key={request.id}
            value={request}
            expanded={selected?.id === request.id}
            onOpen={() =>
              setSelected(selected?.id === request.id ? null : request)
            }
            onSaved={() => {
              setSelected(null);
              reload();
            }}
          />
        ))}
      </div>
    </>
  );
}

function SupportCard({
  value,
  expanded,
  onOpen,
  onSaved,
}: {
  value: SupportRequest;
  expanded: boolean;
  onOpen: () => void;
  onSaved: () => void;
}) {
  const [status, setStatus] = useState(value.status),
    [priority, setPriority] = useState(value.priority),
    [note, setNote] = useState(value.admin_note),
    [busy, setBusy] = useState(false),
    [error, setError] = useState<unknown>(null);
  return (
    <Card className="overflow-hidden">
      <button
        onClick={onOpen}
        className="w-full cursor-pointer p-4 text-left focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-[var(--brand)]"
      >
        <div className="flex flex-wrap items-start justify-between gap-2">
          <div>
            <div className="mb-1 flex gap-2">
              <StatusBadge status={value.status} />
              <Badge
                tone={
                  value.priority === "urgent"
                    ? "bad"
                    : value.priority === "high"
                      ? "warn"
                      : "neutral"
                }
              >
                {value.priority}
              </Badge>
            </div>
            <h2 className="font-semibold">{value.subject}</h2>
            <p className="text-sm text-[var(--on-surface-muted)]">
              {value.name} · {value.email} ·{" "}
              {new Date(value.created_at).toLocaleString("fr-FR")}
            </p>
          </div>
        </div>
      </button>
      {expanded && (
        <div className="space-y-4 border-t border-[var(--outline)] p-4">
          <p className="whitespace-pre-wrap rounded-xl bg-[var(--surface-container)] p-4 text-sm leading-relaxed">
            {value.message}
          </p>
          <div className="grid gap-3 sm:grid-cols-2">
            <Field label="Statut">
              <select
                value={status}
                onChange={(e) =>
                  setStatus(e.target.value as SupportRequest["status"])
                }
                className={inputClass}
              >
                <option value="new">Nouvelle</option>
                <option value="in_progress">En traitement</option>
                <option value="waiting_user">Attente utilisateur</option>
                <option value="resolved">Résolue</option>
                <option value="closed">Fermée</option>
              </select>
            </Field>
            <Field label="Priorité">
              <select
                value={priority}
                onChange={(e) =>
                  setPriority(e.target.value as SupportRequest["priority"])
                }
                className={inputClass}
              >
                <option value="low">Basse</option>
                <option value="normal">Normale</option>
                <option value="high">Haute</option>
                <option value="urgent">Urgente</option>
              </select>
            </Field>
          </div>
          <Field label="Note interne">
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              rows={4}
              className={inputClass}
            />
          </Field>
          <ErrorBox error={error} />
          <div className="flex justify-between">
            <a
              href={`mailto:${value.email}?subject=${encodeURIComponent(`Re: ${value.subject}`)}`}
              className="inline-flex min-h-10 items-center rounded-xl border border-[var(--outline)] px-4 text-sm font-medium transition hover:bg-[var(--surface-container)]"
            >
              Répondre par e-mail
            </a>
            <Button
              disabled={busy}
              onClick={async () => {
                setBusy(true);
                setError(null);
                try {
                  await informationAdminApi.updateSupport(
                    value.id,
                    status,
                    priority,
                    note,
                  );
                  onSaved();
                } catch (e) {
                  setError(e);
                  setBusy(false);
                }
              }}
            >
              {busy ? "Enregistrement…" : "Enregistrer le suivi"}
            </Button>
          </div>
        </div>
      )}
    </Card>
  );
}

function Field({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <label className="block">
      <span className="mb-1.5 block text-xs font-medium text-[var(--on-surface-muted)]">
        {label}
      </span>
      {children}
    </label>
  );
}
function StatusBadge({ status }: { status: string }) {
  const tone =
    status === "published" || status === "resolved"
      ? "good"
      : status === "archived" || status === "closed"
        ? "neutral"
        : status === "scheduled" || status === "in_progress"
          ? "warn"
          : "neutral";
  const label: Record<string, string> = {
    draft: "brouillon",
    scheduled: "planifiée",
    published: "publiée",
    archived: "archivée",
    new: "nouvelle",
    in_progress: "en traitement",
    waiting_user: "attente utilisateur",
    resolved: "résolue",
    closed: "fermée",
  };
  return <Badge tone={tone}>{label[status] ?? status}</Badge>;
}
const inputClass =
  "min-h-10 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm text-[var(--on-surface)] outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15";
