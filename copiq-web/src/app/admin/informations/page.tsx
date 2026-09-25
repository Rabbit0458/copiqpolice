"use client";

import { useMemo, useState } from "react";
import {
  BookOpen,
  CalendarClock,
  CheckCircle2,
  ChevronRight,
  CircleDot,
  FilePenLine,
  Headphones,
  Inbox,
  Mail,
  Plus,
  Search,
  ShieldCheck,
  Sparkles,
  TriangleAlert,
} from "lucide-react";
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
  const [tab, setTab] = useState<"contents" | "support" | "warning">("contents");
  return (
    <>
      <PageHeader
        title="Centre d'information"
        subtitle="Pilotez les contenus publics et les demandes d’assistance depuis un espace éditorial sécurisé."
        action={
          <div className="hidden items-center gap-2 rounded-full border border-[var(--outline-variant)] bg-[var(--surface)]/70 px-3 py-2 text-xs text-[var(--on-surface-muted)] shadow-sm lg:flex">
            <span className="relative flex h-2 w-2"><span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-[var(--success)] opacity-60"/><span className="relative h-2 w-2 rounded-full bg-[var(--success)]"/></span>
            Contenus synchronisés
          </div>
        }
      />
      <Card className="relative mb-5 overflow-hidden p-5 md:p-6">
        <div className="pointer-events-none absolute -right-12 -top-20 h-60 w-60 rounded-full bg-[var(--brand)]/12 blur-3xl" />
        <div className="relative flex flex-col justify-between gap-5 md:flex-row md:items-center">
          <div className="flex items-start gap-3.5"><span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-[var(--brand)]/12 text-[var(--brand)]"><Sparkles size={22}/></span><div><h2 className="text-lg font-semibold tracking-[-.02em]">Votre tour de contrôle éditorial</h2><p className="mt-1 max-w-2xl text-sm leading-6 text-[var(--on-surface-muted)]">Préparez les informations, contrôlez leur visibilité puis publiez-les sans nouvelle mise en ligne de l’application.</p></div></div>
          <div className="flex items-center gap-2 text-xs font-medium text-[var(--on-surface-muted)]"><span className="rounded-full bg-[var(--brand)]/10 px-3 py-2 text-[var(--brand)]">Rédiger</span><ChevronRight size={14}/><span className="rounded-full bg-[var(--surface-container)] px-3 py-2">Vérifier</span><ChevronRight size={14}/><span className="rounded-full bg-[var(--surface-container)] px-3 py-2">Publier</span></div>
        </div>
      </Card>
      <div className="mb-6 grid gap-3 sm:grid-cols-3" role="tablist" aria-label="Sections du centre d’information">
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
        <TabCard
          active={tab === "warning"}
          icon={TriangleAlert}
          title="Avertissement de l’application"
          subtitle="Modifier, désactiver ou réafficher à tous"
          onClick={() => setTab("warning")}
        />
      </div>
      {tab === "contents" ? <ContentsManager /> : tab === "support" ? <SupportManager /> : <WarningManager />}
    </>
  );
}

function WarningManager() {
  const config = useAsync(() => informationAdminApi.runtimeConfig(), []);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");
  const [form, setForm] = useState<null | { enabled: boolean; title: string; content: string }>(null);
  const current = form ?? (config.data ? {
    enabled: config.data.legal_warning_enabled,
    title: config.data.legal_warning_title,
    content: config.data.legal_warning_content,
  } : null);

  const save = async (redisplayToAll: boolean) => {
    if (!current || saving) return;
    if (redisplayToAll && !window.confirm("Afficher cette nouvelle révision à tous les utilisateurs lors de leur prochain lancement ?")) return;
    setSaving(true);
    setMessage("");
    try {
      await informationAdminApi.updateRuntimeConfig({ ...current, redisplayToAll });
      setForm(null);
      await config.reload();
      setMessage(redisplayToAll ? "Nouvelle révision publiée : elle sera réaffichée à tous." : "Configuration enregistrée.");
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Enregistrement impossible.");
    } finally {
      setSaving(false);
    }
  };

  if (config.loading) return <Card><Loading label="Chargement de l’avertissement…" /></Card>;
  if (config.error) return <ErrorBox error={config.error} />;
  if (!current || !config.data) return null;
  return <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_380px]">
    <Card className="p-5 md:p-6">
      <div className="mb-5 flex items-start justify-between gap-4">
        <div><h2 className="font-semibold">Avertissement au démarrage</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">La révision actuelle est la n° {config.data.legal_warning_revision}.</p></div>
        <label className="flex cursor-pointer items-center gap-2 text-sm"><input type="checkbox" checked={current.enabled} onChange={(e) => setForm({ ...current, enabled: e.target.checked })}/>Actif</label>
      </div>
      <label className="block text-sm font-medium">Titre<input className={`${inputClass} mt-2`} value={current.title} onChange={(e) => setForm({ ...current, title: e.target.value })}/></label>
      <label className="mt-4 block text-sm font-medium">Message<textarea className={`${inputClass} mt-2 min-h-40 resize-y`} value={current.content} onChange={(e) => setForm({ ...current, content: e.target.value })}/></label>
      {message && <p className="mt-3 text-sm text-[var(--on-surface-muted)]">{message}</p>}
      <div className="mt-5 flex flex-wrap gap-3"><Button disabled={saving} onClick={() => save(false)}><ShieldCheck size={16}/>Enregistrer</Button><Button disabled={saving} onClick={() => save(true)}><TriangleAlert size={16}/>Enregistrer et réafficher à tous</Button></div>
    </Card>
    <Card className="p-5"><h3 className="font-semibold">Fonctionnement</h3><div className="mt-4 space-y-3 text-sm leading-6 text-[var(--on-surface-muted)]"><p>Une modification simple met le texte à jour sans interrompre les utilisateurs qui l’ont déjà accepté.</p><p>« Réafficher à tous » augmente la révision. Chaque appareil devra alors accepter le nouveau message une seule fois.</p><p>En cas de coupure réseau, l’application utilise la dernière configuration connue.</p></div></Card>
  </div>;
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
      type="button"
      role="tab"
      aria-selected={active}
      onClick={onClick}
      className={`group min-h-24 cursor-pointer rounded-2xl border p-4 text-left transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${active ? "border-[var(--brand)]/60 bg-[var(--brand)]/8 shadow-lg shadow-blue-950/10" : "border-[var(--outline-variant)] bg-[var(--surface)] hover:-translate-y-0.5 hover:border-[var(--brand)]/25 hover:bg-[var(--surface-container)]"}`}
    >
      <div className="flex items-center gap-3">
        <span
          className={`grid h-10 w-10 place-items-center rounded-xl ${active ? "bg-[var(--brand)] text-white" : "bg-[var(--surface-container)] text-[var(--on-surface-muted)]"}`}
        >
          <Icon size={19} />
        </span>
        <div className="min-w-0 flex-1">
          <div className="font-semibold">{title}</div>
          <div className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
            {subtitle}
          </div>
        </div>
        <ChevronRight size={18} className={`transition group-hover:translate-x-0.5 ${active ? "text-[var(--brand)]" : "text-[var(--on-surface-faint)]"}`}/>
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
  const contentCounts = useMemo(() => ({
    total: data?.length ?? 0,
    published: data?.filter((item) => item.status === "published").length ?? 0,
    draft: data?.filter((item) => item.status === "draft").length ?? 0,
    scheduled: data?.filter((item) => item.status === "scheduled").length ?? 0,
  }), [data]);
  return (
    <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_minmax(430px,.82fr)]">
      <section>
        <div className="mb-4 grid grid-cols-2 gap-2 md:grid-cols-4">
          <MiniStat icon={BookOpen} value={contentCounts.total} label="Contenus affichés" />
          <MiniStat icon={CheckCircle2} value={contentCounts.published} label="Publiés" tone="good" />
          <MiniStat icon={FilePenLine} value={contentCounts.draft} label="Brouillons" />
          <MiniStat icon={CalendarClock} value={contentCounts.scheduled} label="Programmés" tone="warn" />
        </div>
        <Card className="mb-4 p-3">
        <div className="grid gap-2 lg:grid-cols-[minmax(230px,1fr)_180px_170px_auto]">
          <label className="relative min-w-56 flex-1">
            <Search
              className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]"
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
        </Card>
        {Boolean(error) && <ErrorBox error={error} />}
        {loading && <Card><Loading label="Chargement des contenus…" /></Card>}
        {data?.length === 0 && (
          <Card className="px-6 py-12 text-center"><Inbox className="mx-auto text-[var(--brand)]" size={30}/><h3 className="mt-3 font-semibold">Aucun contenu trouvé</h3><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Aucun élément ne correspond aux filtres actuels.</p></Card>
        )}
        <div className="space-y-3">
          {data?.map((item) => (
            <button
              key={item.id}
              onClick={() => setEditing(item)}
              className={`group block w-full cursor-pointer rounded-2xl border bg-[var(--surface)] p-4 text-left transition duration-200 hover:-translate-y-0.5 hover:border-[var(--brand)]/30 hover:shadow-lg focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${editing?.id === item.id ? "border-[var(--brand)] ring-4 ring-[var(--brand)]/8" : "border-[var(--outline-variant)]"}`}
            >
              <div className="flex items-start justify-between gap-3">
                <div className="flex min-w-0 gap-3">
                  <span className="mt-0.5 grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><BookOpen size={18}/></span>
                  <div className="min-w-0">
                  <div className="mb-1 flex flex-wrap items-center gap-2">
                    <Badge>{labels[item.content_type]}</Badge>
                    <StatusBadge status={item.status} />
                  </div>
                  <h2 className="font-semibold">{item.title}</h2>
                  <p className="mt-1 line-clamp-2 text-sm text-[var(--on-surface-muted)]">
                    {item.summary || item.body_md}
                  </p>
                  </div>
                </div>
                <span className="shrink-0 rounded-lg bg-[var(--surface-container)] px-2 py-1 text-xs text-[var(--on-surface-faint)]">
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
          <Card className="relative overflow-hidden p-10 text-center"><div className="pointer-events-none absolute inset-x-0 top-0 mx-auto h-32 w-64 rounded-full bg-[var(--brand)]/10 blur-3xl"/>
            <span className="relative mx-auto grid h-16 w-16 place-items-center rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] text-[var(--brand)] shadow-lg"><ShieldCheck size={28}/></span>
            <h2 className="relative mt-5 text-lg font-semibold">Édition sécurisée</h2>
            <p className="relative mx-auto mt-2 max-w-sm text-sm leading-6 text-[var(--on-surface-muted)]">
              Sélectionne un contenu ou crée-en un nouveau. Les modifications ne
              deviennent visibles qu&apos;après publication.
            </p>
            <Button className="relative mt-5" onClick={() => setEditing({ ...blank })}><Plus size={16}/>Créer un contenu</Button>
          </Card>
        )}
      </aside>
    </div>
  );
}

function MiniStat({ icon: Icon, value, label, tone = "brand" }: { icon: typeof BookOpen; value: number; label: string; tone?: "brand" | "good" | "warn" }) {
  const color = tone === "good" ? "text-[var(--success)] bg-[var(--success)]/10" : tone === "warn" ? "text-[var(--warning)] bg-[var(--warning)]/10" : "text-[var(--brand)] bg-[var(--brand)]/10";
  return <Card className="flex min-h-20 items-center gap-3 p-3.5"><span className={`grid h-10 w-10 shrink-0 place-items-center rounded-xl ${color}`}><Icon size={18}/></span><div><strong className="block text-xl font-semibold tabular-nums">{value}</strong><span className="text-[11px] text-[var(--on-surface-muted)]">{label}</span></div></Card>;
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
    <Card className="overflow-hidden shadow-xl shadow-blue-950/10">
      <div className="relative overflow-hidden border-b border-[var(--outline-variant)] bg-[var(--surface-container)] px-5 py-4"><div className="absolute inset-y-0 left-0 w-1 bg-[var(--brand)]"/>
        <div className="flex items-start gap-3"><span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><FilePenLine size={18}/></span><div><h2 className="font-semibold">
          {form.id ? "Modifier le contenu" : "Nouveau contenu"}
        </h2>
        <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
          Markdown simple accepté : titres, listes et texte en gras.
        </p></div></div>
      </div>
      <form onSubmit={save} className="space-y-5 p-5">
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
        <div className="sticky bottom-0 -mx-5 -mb-5 flex flex-wrap justify-between gap-2 border-t border-[var(--outline-variant)] bg-[var(--surface)]/95 p-4 backdrop-blur-xl">
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
        <Card className="relative overflow-hidden p-5"><div className="absolute inset-y-0 left-0 w-1 bg-[var(--brand)]"/><div className="flex items-center gap-3"><span className="grid h-11 w-11 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><Inbox size={20}/></span><div><div className="text-2xl font-bold tabular-nums">{counts.open}</div><div className="text-sm text-[var(--on-surface-muted)]">demandes ouvertes</div></div></div></Card>
        <Card className="relative overflow-hidden p-5"><div className="absolute inset-y-0 left-0 w-1 bg-[var(--danger)]"/><div className="flex items-center gap-3"><span className="grid h-11 w-11 place-items-center rounded-xl bg-[var(--danger)]/10 text-[var(--danger)]"><CircleDot size={20}/></span><div><div className="text-2xl font-bold tabular-nums text-[var(--danger)]">{counts.urgent}</div><div className="text-sm text-[var(--on-surface-muted)]">priorités urgentes</div></div></div></Card>
      </div>
      <Card className="mb-4 p-3"><div className="grid gap-2 md:grid-cols-[1fr_220px]">
        <label className="relative"><Search className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" size={17}/><span className="sr-only">Rechercher une demande</span><input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Email, sujet ou message…"
          className={`${inputClass} pl-10`}
        /></label>
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
      </div></Card>
      {Boolean(error) && <ErrorBox error={error} />}
      {loading && <Card><Loading label="Chargement des demandes…" /></Card>}
      {data?.length === 0 && <Card className="px-6 py-12 text-center"><Headphones className="mx-auto text-[var(--brand)]" size={30}/><h3 className="mt-3 font-semibold">Aucune demande de support</h3><p className="mt-1 text-sm text-[var(--on-surface-muted)]">La file est vide pour les filtres sélectionnés.</p></Card>}
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
    <Card className={`group overflow-hidden transition duration-200 hover:border-[var(--brand)]/25 ${expanded ? "border-[var(--brand)]/50 shadow-xl shadow-blue-950/10" : ""}`}>
      <button
        onClick={onOpen}
        className="w-full cursor-pointer p-4 text-left transition hover:bg-[var(--surface-container)]/50 focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-[var(--brand)]"
      >
        <div className="flex flex-wrap items-start justify-between gap-2">
          <div className="flex min-w-0 gap-3"><span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><Mail size={18}/></span><div className="min-w-0">
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
          </div></div>
          <ChevronRight size={18} className={`mt-2 shrink-0 text-[var(--on-surface-faint)] transition ${expanded ? "rotate-90 text-[var(--brand)]" : "group-hover:translate-x-0.5"}`}/>
        </div>
      </button>
      {expanded && (
        <div className="space-y-4 border-t border-[var(--outline-variant)] bg-[var(--surface-container)]/25 p-4 md:p-5">
          <div className="rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)] p-4"><p className="mb-1.5 text-[10px] font-semibold uppercase tracking-[.14em] text-[var(--on-surface-faint)]">Message reçu</p><p className="whitespace-pre-wrap text-sm leading-6">
            {value.message}
          </p></div>
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
          <div className="flex flex-wrap justify-between gap-2 border-t border-[var(--outline-variant)] pt-4">
            <a
              href={`mailto:${value.email}?subject=${encodeURIComponent(`Re: ${value.subject}`)}`}
              className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border border-[var(--outline)] px-4 text-sm font-medium transition hover:-translate-y-0.5 hover:bg-[var(--surface-container)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
            >
              <Mail size={16}/>Répondre par e-mail
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
  "min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-2.5 text-sm text-[var(--on-surface)] outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10";
