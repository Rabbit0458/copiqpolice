"use client";

/**
 * COP'IQ — Panel administrateur : dossier utilisateur complet.
 *
 * Panneau latéral à onglets ouvert depuis la liste des utilisateurs.
 * Chaque onglet monte son propre composant : les données ne sont donc chargées
 * que lorsque l'onglet est réellement consulté (pas de requête inutile).
 *
 * SÉCURITÉ — le site est exporté en statique, aucun code serveur ne tourne.
 * Toutes les données viennent de RPC PostgreSQL `SECURITY DEFINER` qui
 * revalident le rôle admin. Ce fichier n'accorde aucun droit : masquer un
 * bouton n'est pas une protection, la garde est en base.
 *
 * Aucune donnée n'est simulée : tous les compteurs et listes proviennent des
 * RPC. Les champs absents de la base ne sont simplement pas affichés.
 */

import { useDeferredValue, useMemo, useState } from "react";
import {
  AlertTriangle,
  Ban,
  BookOpenCheck,
  CreditCard,
  FileText,
  History,
  Info,
  LayoutGrid,
  MessageSquare,
  ShieldAlert,
  ShieldCheck,
  Trash2,
  UserRound,
  X,
} from "lucide-react";
import {
  communityUsersApi,
  type CommunityAdminUserDetail,
  type CommunitySanction,
  type CommunitySanctionKind,
} from "@/lib/admin/api";
import {
  Badge,
  Button,
  Card,
  Empty,
  ErrorBox,
  Loading,
  useAsync,
} from "@/components/admin/admin-ui";

/* ═══════════════════════════════════════════════════════════════════════════
   Constantes partagées
   ═══════════════════════════════════════════════════════════════════════════ */

export const SANCTION_LABELS: Record<CommunitySanctionKind, string> = {
  warning: "Avertissement",
  post_restriction: "Publication interdite",
  comment_restriction: "Commentaires interdits",
  message_restriction: "Messagerie interdite",
  suspension: "Suspension du forum",
  ban: "Bannissement",
};

export const SPACES = [
  ["global", "Toute la communauté"],
  ["pa_exam", "Concours policier adjoint"],
  ["gpx_exam", "Concours gardien de la paix"],
  ["pa_school", "École policier adjoint"],
  ["gpx_school", "École gardien de la paix"],
] as const;

/** Statuts réels de community_posts / community_comments / community_messages. */
const CONTENT_STATUS: Record<string, { label: string; tone: BadgeTone }> = {
  draft: { label: "Brouillon", tone: "neutral" },
  published: { label: "Publié", tone: "good" },
  pending_review: { label: "En attente de revue", tone: "warn" },
  hidden: { label: "Masqué", tone: "warn" },
  locked: { label: "Verrouillé", tone: "warn" },
  removed_by_moderator: { label: "Retiré par la modération", tone: "bad" },
  deleted_by_author: { label: "Supprimé par l'auteur", tone: "neutral" },
  archived: { label: "Archivé", tone: "neutral" },
};

/** Statuts réels de community_reports. */
const REPORT_STATUS: Record<string, { label: string; tone: BadgeTone }> = {
  new: { label: "Nouveau", tone: "warn" },
  triaged: { label: "Trié", tone: "warn" },
  in_progress: { label: "En traitement", tone: "warn" },
  resolved: { label: "Résolu", tone: "good" },
  rejected: { label: "Rejeté", tone: "neutral" },
  appealed: { label: "Contesté", tone: "bad" },
};

type BadgeTone = "neutral" | "good" | "warn" | "bad" | "brand";

type TabId =
  | "overview"
  | "account"
  | "posts"
  | "comments"
  | "messages"
  | "reports"
  | "sanctions"
  | "quiz"
  | "billing"
  | "timeline";

const PAGE_SIZE = 20;

/* ═══════════════════════════════════════════════════════════════════════════
   Utilitaires d'affichage
   ═══════════════════════════════════════════════════════════════════════════ */

function fmtDateTime(value: string | null | undefined) {
  if (!value) return "—";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "—";
  return date.toLocaleString("fr-FR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function fmtDate(value: string | null | undefined) {
  if (!value) return "—";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "—";
  return date.toLocaleDateString("fr-FR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
}

function fmtMoney(cents: number | null | undefined, currency: string | null) {
  if (cents == null) return "—";
  return new Intl.NumberFormat("fr-FR", {
    style: "currency",
    currency: (currency || "eur").toUpperCase(),
  }).format(cents / 100);
}

function fmtDuration(ms: number | null | undefined) {
  if (ms == null) return "—";
  if (ms < 1000) return `${Math.round(ms)} ms`;
  return `${(ms / 1000).toFixed(1)} s`;
}

export function pathLabel(track: string | null, mode: string | null) {
  const trackLabel =
    track === "pa"
      ? "Policier adjoint"
      : track === "gpx"
        ? "Gardien de la paix"
        : "Parcours inconnu";
  const modeLabel =
    mode === "exam" ? "Concours" : mode === "school" ? "École" : "Mode inconnu";
  return `${modeLabel} · ${trackLabel}`;
}

function displayName(profile: {
  first_name: string | null;
  last_name: string | null;
  username: string | null;
}) {
  return (
    [profile.first_name, profile.last_name].filter(Boolean).join(" ") ||
    profile.username ||
    "Sans nom"
  );
}

function isPremium(status: string | null | undefined) {
  return ["active", "trialing"].includes(status ?? "");
}

/** Sanction considérée comme réellement en cours (statut + échéance). */
function isSanctionLive(sanction: CommunitySanction) {
  if (sanction.status !== "active") return false;
  if (!sanction.ends_at) return true;
  return new Date(sanction.ends_at).getTime() > Date.now();
}

/* ═══════════════════════════════════════════════════════════════════════════
   Primitives d'interface réutilisées dans les onglets
   ═══════════════════════════════════════════════════════════════════════════ */

export function Avatar({
  index,
  name,
  large = false,
}: {
  index: number | null;
  name: string;
  large?: boolean;
}) {
  const initials =
    name
      .split(/\s+/)
      .slice(0, 2)
      .map((part) => part[0]?.toUpperCase())
      .join("") || "";
  return (
    <span
      title={index != null ? `Avatar ${index}` : undefined}
      className={`grid shrink-0 place-items-center rounded-full bg-[var(--brand)]/12 font-semibold text-[var(--brand)] ${
        large ? "h-16 w-16 text-lg" : "h-10 w-10 text-xs"
      }`}
    >
      {initials || <UserRound size={large ? 26 : 18} />}
    </span>
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
    <div className="min-w-0">
      <dt className="text-[11px] font-medium uppercase tracking-wide text-[var(--on-surface-faint)]">
        {label}
      </dt>
      <dd className="mt-0.5 break-words text-sm text-[var(--on-surface)]">
        {children ?? "—"}
      </dd>
    </div>
  );
}

function SectionTitle({
  icon: Icon,
  children,
  hint,
}: {
  icon?: React.ComponentType<{ size?: number; className?: string }>;
  children: React.ReactNode;
  hint?: string;
}) {
  return (
    <div className="mb-3">
      <h3 className="flex items-center gap-2 font-semibold">
        {Icon && <Icon size={17} className="text-[var(--brand)]" />}
        {children}
      </h3>
      {hint && (
        <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">{hint}</p>
      )}
    </div>
  );
}

function StatusBadge({
  status,
  map,
}: {
  status: string | null;
  map: Record<string, { label: string; tone: BadgeTone }>;
}) {
  if (!status) return <Badge tone="neutral">Inconnu</Badge>;
  const entry = map[status];
  return <Badge tone={entry?.tone ?? "neutral"}>{entry?.label ?? status}</Badge>;
}

/** Carte de statistique cliquable qui bascule vers l'onglet correspondant. */
function MetricCard({
  icon: Icon,
  value,
  label,
  hint,
  onClick,
  tone = "neutral",
}: {
  icon: React.ComponentType<{ size?: number; className?: string }>;
  value: number | string;
  label: string;
  hint?: string;
  onClick?: () => void;
  tone?: BadgeTone;
}) {
  const toneClass =
    tone === "bad"
      ? "text-[var(--danger)]"
      : tone === "warn"
        ? "text-[var(--warning)]"
        : tone === "good"
          ? "text-[var(--success)]"
          : "text-[var(--on-surface)]";
  const interactive = typeof onClick === "function";
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={!interactive}
      className={`rounded-xl bg-[var(--surface-container)] p-3 text-left transition ${
        interactive
          ? "cursor-pointer hover:bg-[var(--surface-container-hi)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
          : "cursor-default"
      }`}
    >
      <Icon size={16} className="mb-2 text-[var(--brand)]" />
      <strong className={`block text-lg tabular-nums ${toneClass}`}>
        {value}
      </strong>
      <span className="text-[11px] text-[var(--on-surface-muted)]">{label}</span>
      {hint && (
        <span className="mt-0.5 block text-[10px] text-[var(--on-surface-faint)]">
          {hint}
        </span>
      )}
    </button>
  );
}

function Paginator({
  page,
  total,
  size,
  onPage,
}: {
  page: number;
  total: number;
  size: number;
  onPage: (next: number) => void;
}) {
  if (total <= size) return null;
  const from = page * size + 1;
  const to = Math.min((page + 1) * size, total);
  return (
    <div className="mt-3 flex items-center justify-between gap-3">
      <span className="text-xs text-[var(--on-surface-muted)]">
        {from}–{to} sur {total}
      </span>
      <div className="flex gap-2">
        <Button
          variant="ghost"
          disabled={page === 0}
          onClick={() => onPage(Math.max(0, page - 1))}
        >
          Précédent
        </Button>
        <Button
          variant="ghost"
          disabled={(page + 1) * size >= total}
          onClick={() => onPage(page + 1)}
        >
          Suivant
        </Button>
      </div>
    </div>
  );
}

function SearchInput({
  value,
  onChange,
  placeholder,
}: {
  value: string;
  onChange: (next: string) => void;
  placeholder: string;
}) {
  return (
    <input
      value={value}
      onChange={(event) => onChange(event.target.value)}
      placeholder={placeholder}
      className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15"
    />
  );
}

function Select({
  value,
  onChange,
  options,
  label,
}: {
  value: string;
  onChange: (next: string) => void;
  options: readonly (readonly [string, string])[];
  label: string;
}) {
  return (
    <label className="block">
      <span className="sr-only">{label}</span>
      <select
        aria-label={label}
        value={value}
        onChange={(event) => onChange(event.target.value)}
        className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15"
      >
        {options.map(([key, text]) => (
          <option key={key} value={key}>
            {text}
          </option>
        ))}
      </select>
    </label>
  );
}

/**
 * Enveloppe standard d'un onglet piloté par `useAsync` :
 * chargement, erreur, vide, puis contenu. Évite de réécrire ces 4 états
 * dans chaque onglet et garantit qu'aucun ne rende `undefined`.
 */
function AsyncList<T>({
  state,
  empty,
  children,
}: {
  state: { data: T[] | null; error: unknown; loading: boolean };
  empty: string;
  children: (rows: T[]) => React.ReactNode;
}) {
  if (state.loading) return <Loading />;
  if (state.error != null) return <ErrorBox error={state.error} />;
  const rows = state.data ?? [];
  if (rows.length === 0) return <Empty>{empty}</Empty>;
  return <>{children(rows)}</>;
}

/* ═══════════════════════════════════════════════════════════════════════════
   Panneau principal
   ═══════════════════════════════════════════════════════════════════════════ */

const TABS: { id: TabId; label: string }[] = [
  { id: "overview", label: "Vue d'ensemble" },
  { id: "account", label: "Compte" },
  { id: "posts", label: "Publications" },
  { id: "comments", label: "Réponses" },
  { id: "messages", label: "Messages" },
  { id: "reports", label: "Signalements" },
  { id: "sanctions", label: "Sanctions" },
  { id: "quiz", label: "Quiz" },
  { id: "billing", label: "Abonnement" },
  { id: "timeline", label: "Activité" },
];

export function UserDossier({
  userId,
  onClose,
  onChanged,
}: {
  userId: string;
  onClose: () => void;
  onChanged: () => void;
}) {
  const [tab, setTab] = useState<TabId>("overview");
  const detail = useAsync(() => communityUsersApi.detail(userId), [userId]);

  const reload = () => {
    detail.reload();
    onChanged();
  };

  return (
    <div
      className="fixed inset-0 z-50 flex justify-end bg-black/35 backdrop-blur-[2px]"
      role="dialog"
      aria-modal="true"
      aria-label="Dossier utilisateur"
      onMouseDown={(event) => {
        if (event.target === event.currentTarget) onClose();
      }}
    >
      <div className="flex h-full w-full max-w-4xl flex-col border-l border-[var(--outline-variant)] bg-[var(--surface)] shadow-2xl animate-fade-in">
        {/* En-tête fixe */}
        <div className="shrink-0 border-b border-[var(--outline-variant)] bg-[var(--surface)]/95 backdrop-blur-xl">
          <div className="flex items-start justify-between gap-3 px-5 py-4">
            <div className="min-w-0">
              <h2 className="font-semibold">Dossier utilisateur</h2>
              <p className="text-xs text-[var(--on-surface-muted)]">
                Données de modération et d&apos;administration · contenu des
                messages privés non exposé
              </p>
            </div>
            <button
              onClick={onClose}
              className="grid h-11 w-11 shrink-0 place-items-center rounded-xl transition hover:bg-[var(--surface-container)]"
              aria-label="Fermer"
            >
              <X size={20} />
            </button>
          </div>

          {detail.data && (
            <>
              <DossierHeader detail={detail.data} />
              <nav
                className="flex gap-1 overflow-x-auto px-4 pb-1"
                aria-label="Sections du dossier"
              >
                {TABS.map((item) => (
                  <button
                    key={item.id}
                    onClick={() => setTab(item.id)}
                    aria-current={tab === item.id ? "page" : undefined}
                    className={`shrink-0 border-b-2 px-3 py-2.5 text-sm font-medium transition ${
                      tab === item.id
                        ? "border-[var(--brand)] text-[var(--brand)]"
                        : "border-transparent text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]"
                    }`}
                  >
                    {item.label}
                  </button>
                ))}
              </nav>
            </>
          )}
        </div>

        {/* Contenu scrollable */}
        <div className="min-h-0 flex-1 overflow-y-auto p-5">
          {detail.loading && <Loading label="Chargement du dossier…" />}
          {detail.error != null && <ErrorBox error={detail.error} />}
          {detail.data && (
            <DossierBody
              tab={tab}
              setTab={setTab}
              userId={userId}
              detail={detail.data}
              reload={reload}
            />
          )}
        </div>
      </div>
    </div>
  );
}

/* ── En-tête identité ──────────────────────────────────────────────────── */

function DossierHeader({ detail }: { detail: CommunityAdminUserDetail }) {
  const profile = detail.profile;
  const name = displayName(profile);
  const activeSanctions = detail.sanctions.filter(isSanctionLive);
  const banned = activeSanctions.some((item) => item.kind === "ban");
  const staffRole = detail.staff?.role;

  return (
    <div className="flex flex-wrap items-center gap-4 px-5 pb-4">
      <Avatar index={profile.avatar_index} name={name} large />
      <div className="min-w-0 flex-1">
        <h3 className="truncate text-xl font-semibold">{name}</h3>
        <p className="truncate text-sm text-[var(--on-surface-muted)]">
          {profile.username ? `@${profile.username} · ` : ""}
          {profile.email ?? "e-mail inconnu"}
        </p>
        <div className="mt-2 flex flex-wrap gap-2">
          {banned ? (
            <Badge tone="bad">Compte banni</Badge>
          ) : activeSanctions.length > 0 ? (
            <Badge tone="warn">
              {activeSanctions.length} sanction
              {activeSanctions.length > 1 ? "s" : ""} active
              {activeSanctions.length > 1 ? "s" : ""}
            </Badge>
          ) : (
            <Badge tone="good">Compte actif</Badge>
          )}
          {staffRole && (
            <Badge tone="brand">
              Staff · {staffRole}
              {detail.staff?.disabled ? " (désactivé)" : ""}
            </Badge>
          )}
          <Badge tone="neutral">
            {pathLabel(profile.user_track, profile.user_mode)}
          </Badge>
          {isPremium(detail.subscription.status) ? (
            <Badge tone="good">{detail.subscription.plan ?? "Premium"}</Badge>
          ) : (
            <Badge tone="neutral">Gratuit</Badge>
          )}
          <Badge tone="neutral">Inscrit le {fmtDate(profile.created_at)}</Badge>
        </div>
      </div>
    </div>
  );
}

/* ── Routeur d'onglets ─────────────────────────────────────────────────── */

function DossierBody({
  tab,
  setTab,
  userId,
  detail,
  reload,
}: {
  tab: TabId;
  setTab: (next: TabId) => void;
  userId: string;
  detail: CommunityAdminUserDetail;
  reload: () => void;
}) {
  switch (tab) {
    case "overview":
      return <OverviewTab detail={detail} setTab={setTab} reload={reload} />;
    case "account":
      return <AccountTab detail={detail} />;
    case "posts":
      return <PostsTab userId={userId} />;
    case "comments":
      return <CommentsTab userId={userId} />;
    case "messages":
      return <MessagesTab userId={userId} />;
    case "reports":
      return <ReportsTab userId={userId} />;
    case "sanctions":
      return <SanctionsTab detail={detail} reload={reload} />;
    case "quiz":
      return <QuizTab userId={userId} detail={detail} />;
    case "billing":
      return <BillingTab userId={userId} />;
    case "timeline":
      return <TimelineTab userId={userId} />;
    default:
      return null;
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Vue d'ensemble
   ═══════════════════════════════════════════════════════════════════════════ */

function OverviewTab({
  detail,
  setTab,
  reload,
}: {
  detail: CommunityAdminUserDetail;
  setTab: (next: TabId) => void;
  reload: () => void;
}) {
  const a = detail.activity;
  const liveSanctions = detail.sanctions.filter(isSanctionLive);

  return (
    <div className="space-y-5">
      <section>
        <SectionTitle
          icon={LayoutGrid}
          hint="Compteurs calculés en base. Cliquez pour ouvrir le détail."
        >
          Statistiques
        </SectionTitle>
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          <MetricCard
            icon={FileText}
            value={a.posts}
            label="Publications"
            hint={
              a.posts_visible != null
                ? `${a.posts_visible} visible${a.posts_visible > 1 ? "s" : ""}`
                : undefined
            }
            onClick={() => setTab("posts")}
          />
          <MetricCard
            icon={MessageSquare}
            value={a.comments}
            label="Réponses"
            hint={
              a.comments_visible != null
                ? `${a.comments_visible} visible${a.comments_visible > 1 ? "s" : ""}`
                : undefined
            }
            onClick={() => setTab("comments")}
          />
          <MetricCard
            icon={MessageSquare}
            value={a.messages}
            label="Messages"
            hint={a.rooms != null ? `${a.rooms} salon(s)` : undefined}
            onClick={() => setTab("messages")}
          />
          <MetricCard
            icon={ShieldAlert}
            value={a.reports_received}
            label="Signalé"
            hint={
              a.reports_open != null ? `${a.reports_open} en cours` : undefined
            }
            tone={a.reports_received > 0 ? "warn" : "neutral"}
            onClick={() => setTab("reports")}
          />
          <MetricCard
            icon={AlertTriangle}
            value={liveSanctions.length}
            label="Sanctions actives"
            hint={`${detail.sanctions.length} au total`}
            tone={liveSanctions.length > 0 ? "bad" : "good"}
            onClick={() => setTab("sanctions")}
          />
          <MetricCard
            icon={BookOpenCheck}
            value={a.quiz_answers ?? 0}
            label="Réponses quiz"
            hint={
              detail.quiz_summary?.accuracy != null
                ? `${detail.quiz_summary.accuracy} % de réussite`
                : undefined
            }
            onClick={() => setTab("quiz")}
          />
          <MetricCard
            icon={BookOpenCheck}
            value={a.cp_attempts ?? 0}
            label="Cas pratiques"
            hint={
              detail.cp_progress?.cases_finished != null
                ? `${detail.cp_progress.cases_finished} terminé(s)`
                : undefined
            }
            onClick={() => setTab("quiz")}
          />
          <MetricCard
            icon={CreditCard}
            value={a.invoices ?? 0}
            label="Factures"
            onClick={() => setTab("billing")}
          />
        </div>
      </section>

      <Card className="p-4">
        <dl className="grid gap-4 sm:grid-cols-3">
          <Field label="Dernière activité">
            {fmtDateTime(detail.last_activity)}
          </Field>
          <Field label="Compte créé le">
            {fmtDateTime(detail.profile.created_at)}
          </Field>
          <Field label="Profil modifié le">
            {fmtDateTime(detail.profile.updated_at)}
          </Field>
        </dl>
      </Card>

      <AdminActions detail={detail} reload={reload} setTab={setTab} />
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Zone d'actions administratives
   ═══════════════════════════════════════════════════════════════════════════ */

function AdminActions({
  detail,
  reload,
  setTab,
}: {
  detail: CommunityAdminUserDetail;
  reload: () => void;
  setTab: (next: TabId) => void;
}) {
  const live = detail.sanctions.filter(isSanctionLive);
  const ban = live.find((item) => item.kind === "ban");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);

  async function lift(sanction: CommunitySanction) {
    const reason = prompt(
      `Motif de levée de la mesure « ${SANCTION_LABELS[sanction.kind]} » (10 caractères minimum) :`,
    )?.trim();
    if (!reason) return;
    if (reason.length < 10) {
      setError(new Error("Le motif doit contenir au moins 10 caractères."));
      return;
    }
    if (!confirm("Lever cette mesure maintenant ?")) return;
    setBusy(true);
    setError(null);
    try {
      await communityUsersApi.revokeSanction(sanction.id, reason);
      reload();
    } catch (cause) {
      setError(cause);
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card className="p-4">
      <SectionTitle
        icon={ShieldCheck}
        hint="Chaque action est revalidée en base (rôle, hiérarchie, périmètre) et inscrite au journal de modération."
      >
        Actions administratives
      </SectionTitle>

      <div className="flex flex-wrap gap-2">
        <Button variant="ghost" onClick={() => setTab("sanctions")}>
          <span className="inline-flex items-center gap-2">
            <Ban size={16} /> Appliquer une mesure
          </span>
        </Button>

        {ban ? (
          <Button variant="primary" disabled={busy} onClick={() => lift(ban)}>
            {busy ? "Traitement…" : "Débannir ce compte"}
          </Button>
        ) : (
          <Button variant="danger" onClick={() => setTab("sanctions")}>
            <span className="inline-flex items-center gap-2">
              <Ban size={16} /> Bannir ce compte
            </span>
          </Button>
        )}

        {live.length > 0 && !ban && (
          <Button variant="ghost" disabled={busy} onClick={() => lift(live[0])}>
            Lever la mesure en cours
          </Button>
        )}
      </div>

      {error != null && (
        <div className="mt-3">
          <ErrorBox error={error} />
        </div>
      )}

      {/* Suppression de compte : volontairement non exposée — voir note. */}
      <div className="mt-4 rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/50 p-3">
        <div className="flex items-start gap-2.5">
          <Trash2
            size={16}
            className="mt-0.5 shrink-0 text-[var(--on-surface-faint)]"
          />
          <div className="text-xs text-[var(--on-surface-muted)]">
            <strong className="text-[var(--on-surface)]">
              Suppression du compte — indisponible depuis le panel.
            </strong>
            <p className="mt-1">
              Les deux mécanismes de suppression existants (
              <code>cas_pratique_delete_user_data</code> et{" "}
              <code>/api/user/delete</code>) sont strictement auto-service : ils
              ne suppriment que le compte de l&apos;appelant. Aucune RPC ne
              permet aujourd&apos;hui à un administrateur de supprimer le compte
              d&apos;un tiers, et le site étant exporté en statique, aucune route
              serveur ne peut porter la clé <code>service_role</code>.
            </p>
            <p className="mt-1">
              Exposer un bouton ici supposerait de créer une edge function
              dédiée. En attendant, le bannissement permanent produit
              l&apos;effet opérationnel recherché sans perte de données.
            </p>
          </div>
        </div>
      </div>
    </Card>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Compte
   ═══════════════════════════════════════════════════════════════════════════ */

function AccountTab({ detail }: { detail: CommunityAdminUserDetail }) {
  const p = detail.profile;
  const s = detail.settings ?? {};
  const cp = detail.community_profile ?? {};
  const staff = detail.staff ?? {};

  return (
    <div className="space-y-4">
      <Card className="p-4">
        <SectionTitle icon={Info}>Identité</SectionTitle>
        <dl className="grid gap-4 sm:grid-cols-3">
          <Field label="Identifiant">
            <code className="text-xs">{p.user_id}</code>
          </Field>
          <Field label="E-mail">{p.email ?? "—"}</Field>
          <Field label="Pseudo">{p.username ? `@${p.username}` : "—"}</Field>
          <Field label="Prénom">{p.first_name ?? "—"}</Field>
          <Field label="Nom">{p.last_name ?? "—"}</Field>
          <Field label="Téléphone">{p.phone ?? "—"}</Field>
          <Field label="Ville">{p.city ?? "—"}</Field>
          <Field label="Date de naissance">{fmtDate(p.birthday)}</Field>
          <Field label="Rôle applicatif">{p.user_role ?? "—"}</Field>
        </dl>
      </Card>

      <Card className="p-4">
        <SectionTitle icon={Info}>Parcours et statut</SectionTitle>
        <dl className="grid gap-4 sm:grid-cols-3">
          <Field label="Parcours">{pathLabel(p.user_track, p.user_mode)}</Field>
          <Field label="Concours déjà passé">
            {p.has_passed_exam == null ? "—" : p.has_passed_exam ? "Oui" : "Non"}
          </Field>
          <Field label="CGV acceptées">
            {p.cgv_accepted == null ? (
              "—"
            ) : p.cgv_accepted ? (
              <Badge tone="good">Le {fmtDate(p.cgv_accepted_at)}</Badge>
            ) : (
              <Badge tone="warn">Non acceptées</Badge>
            )}
          </Field>
          <Field label="Compte créé le">{fmtDateTime(p.created_at)}</Field>
          <Field label="Profil modifié le">{fmtDateTime(p.updated_at)}</Field>
          <Field label="Dernière activité">
            {fmtDateTime(detail.last_activity)}
          </Field>
        </dl>
      </Card>

      <Card className="p-4">
        <SectionTitle icon={Info}>Préférences</SectionTitle>
        <dl className="grid gap-4 sm:grid-cols-3">
          <Field label="Langue">{s.locale ?? "—"}</Field>
          <Field label="Thème">
            {s.theme_dark == null ? "—" : s.theme_dark ? "Sombre" : "Clair"}
          </Field>
          <Field label="Onboarding terminé">
            {fmtDateTime(s.onboarding_done_at)}
          </Field>
          <Field label="Biographie">{cp.bio ?? "—"}</Field>
          <Field label="Activité publique">
            {cp.show_activity == null ? "—" : cp.show_activity ? "Oui" : "Non"}
          </Field>
          <Field label="Nom affiché">
            {cp.show_display_name == null
              ? "—"
              : cp.show_display_name
                ? "Oui"
                : "Non"}
          </Field>
        </dl>
      </Card>

      {staff.role && (
        <Card className="p-4">
          <SectionTitle icon={ShieldCheck} hint="Ce compte dispose d'un accès au panel administrateur.">
            Accès administrateur
          </SectionTitle>
          <dl className="grid gap-4 sm:grid-cols-3">
            <Field label="Rôle staff">
              <Badge tone="brand">{staff.role}</Badge>
            </Field>
            <Field label="État">
              {staff.disabled ? (
                <Badge tone="bad">Désactivé</Badge>
              ) : (
                <Badge tone="good">Actif</Badge>
              )}
            </Field>
            <Field label="Dernière connexion admin">
              {fmtDateTime(staff.last_admin_login_at)}
            </Field>
            <Field label="Expiration de l'accès">
              {fmtDateTime(staff.expires_at)}
            </Field>
          </dl>
        </Card>
      )}

      <p className="px-1 text-xs text-[var(--on-surface-faint)]">
        Mots de passe, hachages, jetons, identifiants Stripe et moyens de
        paiement ne sont jamais renvoyés par les RPC : ils n&apos;existent pas
        dans les données reçues par cette page.
      </p>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Publications
   ═══════════════════════════════════════════════════════════════════════════ */

const POST_STATUS_OPTIONS = [
  ["", "Tous les statuts"],
  ["published", "Publié"],
  ["pending_review", "En attente de revue"],
  ["hidden", "Masqué"],
  ["locked", "Verrouillé"],
  ["removed_by_moderator", "Retiré par la modération"],
  ["deleted_by_author", "Supprimé par l'auteur"],
  ["archived", "Archivé"],
  ["draft", "Brouillon"],
] as const;

function PostsTab({ userId }: { userId: string }) {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("");
  const [page, setPage] = useState(0);
  const [openId, setOpenId] = useState<string | null>(null);
  const deferred = useDeferredValue(search);

  const state = useAsync(
    () =>
      communityUsersApi.posts(userId, {
        search: deferred.trim() || undefined,
        status: status || undefined,
        limit: PAGE_SIZE,
        offset: page * PAGE_SIZE,
      }),
    [userId, deferred, status, page],
  );
  const total = state.data?.[0]?.total_count ?? 0;

  return (
    <div className="space-y-4">
      <div className="grid gap-3 sm:grid-cols-[1fr_auto]">
        <SearchInput
          value={search}
          onChange={(next) => {
            setSearch(next);
            setPage(0);
          }}
          placeholder="Rechercher dans le titre ou le contenu"
        />
        <Select
          label="Statut"
          value={status}
          onChange={(next) => {
            setStatus(next);
            setPage(0);
          }}
          options={POST_STATUS_OPTIONS}
        />
      </div>

      <AsyncList state={state} empty="Aucune publication pour cet utilisateur.">
        {(rows) => (
          <div className="space-y-3">
            {rows.map((post) => {
              const open = openId === post.id;
              return (
                <Card key={post.id} className="p-4">
                  <div className="flex flex-wrap items-start justify-between gap-3">
                    <div className="min-w-0 flex-1">
                      <div className="flex flex-wrap items-center gap-2">
                        <strong className="text-sm">
                          {post.title || "Sans titre"}
                        </strong>
                        <StatusBadge
                          status={post.status}
                          map={CONTENT_STATUS}
                        />
                        {post.is_pinned && <Badge tone="brand">Épinglé</Badge>}
                        {post.is_resolved && <Badge tone="good">Résolu</Badge>}
                        {post.reports_count > 0 && (
                          <Badge tone="warn">
                            {post.reports_count} signalement
                            {post.reports_count > 1 ? "s" : ""}
                          </Badge>
                        )}
                      </div>
                      <p className="mt-1 text-xs text-[var(--on-surface-faint)]">
                        {[post.space_label, post.category_label, post.type]
                          .filter(Boolean)
                          .join(" · ") || "Sans catégorie"}
                      </p>
                      <p className="mt-2 whitespace-pre-wrap text-sm text-[var(--on-surface-muted)]">
                        {open
                          ? (post.content ?? "—")
                          : (post.content ?? "").slice(0, 220) +
                            ((post.content ?? "").length > 220 ? "…" : "")}
                      </p>
                    </div>
                    {(post.content ?? "").length > 220 && (
                      <Button
                        variant="ghost"
                        onClick={() => setOpenId(open ? null : post.id)}
                      >
                        {open ? "Réduire" : "Ouvrir"}
                      </Button>
                    )}
                  </div>
                  <div className="mt-3 flex flex-wrap gap-x-4 gap-y-1 text-xs text-[var(--on-surface-faint)]">
                    <span>Publié le {fmtDateTime(post.created_at)}</span>
                    {post.edited_at && (
                      <span>Modifié le {fmtDateTime(post.edited_at)}</span>
                    )}
                    {post.deleted_at && (
                      <span className="text-[var(--danger)]">
                        Supprimé le {fmtDateTime(post.deleted_at)}
                      </span>
                    )}
                    <span>{post.comment_count} réponse(s)</span>
                    <span>{post.reaction_count} réaction(s)</span>
                    <span>{post.view_count} vue(s)</span>
                    <span>{post.share_count} partage(s)</span>
                  </div>
                </Card>
              );
            })}
            <Paginator
              page={page}
              total={total}
              size={PAGE_SIZE}
              onPage={setPage}
            />
          </div>
        )}
      </AsyncList>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Réponses
   ═══════════════════════════════════════════════════════════════════════════ */

const COMMENT_STATUS_OPTIONS = [
  ["", "Tous les statuts"],
  ["published", "Publié"],
  ["pending_review", "En attente de revue"],
  ["hidden", "Masqué"],
  ["removed_by_moderator", "Retiré par la modération"],
  ["deleted_by_author", "Supprimé par l'auteur"],
] as const;

function CommentsTab({ userId }: { userId: string }) {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("");
  const [page, setPage] = useState(0);
  const deferred = useDeferredValue(search);

  const state = useAsync(
    () =>
      communityUsersApi.comments(userId, {
        search: deferred.trim() || undefined,
        status: status || undefined,
        limit: PAGE_SIZE,
        offset: page * PAGE_SIZE,
      }),
    [userId, deferred, status, page],
  );
  const total = state.data?.[0]?.total_count ?? 0;

  return (
    <div className="space-y-4">
      <div className="grid gap-3 sm:grid-cols-[1fr_auto]">
        <SearchInput
          value={search}
          onChange={(next) => {
            setSearch(next);
            setPage(0);
          }}
          placeholder="Rechercher dans les réponses"
        />
        <Select
          label="Statut"
          value={status}
          onChange={(next) => {
            setStatus(next);
            setPage(0);
          }}
          options={COMMENT_STATUS_OPTIONS}
        />
      </div>

      <AsyncList state={state} empty="Aucune réponse pour cet utilisateur.">
        {(rows) => (
          <div className="space-y-3">
            {rows.map((comment) => (
              <Card key={comment.id} className="p-4">
                <div className="flex flex-wrap items-center gap-2">
                  <StatusBadge status={comment.status} map={CONTENT_STATUS} />
                  {comment.is_solution && (
                    <Badge tone="good">Réponse retenue</Badge>
                  )}
                  {comment.is_reply && (
                    <Badge tone="neutral">Réponse imbriquée</Badge>
                  )}
                  {comment.reports_count > 0 && (
                    <Badge tone="warn">
                      {comment.reports_count} signalement
                      {comment.reports_count > 1 ? "s" : ""}
                    </Badge>
                  )}
                </div>
                <p className="mt-2 whitespace-pre-wrap text-sm">
                  {comment.content ?? "—"}
                </p>
                <p className="mt-2 text-xs text-[var(--on-surface-faint)]">
                  Sur «{" "}
                  <span className="text-[var(--on-surface-muted)]">
                    {comment.post_title || "publication supprimée"}
                  </span>{" "}
                  »{comment.space_label ? ` · ${comment.space_label}` : ""}
                </p>
                <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-xs text-[var(--on-surface-faint)]">
                  <span>Écrit le {fmtDateTime(comment.created_at)}</span>
                  {comment.edited_at && (
                    <span>Modifié le {fmtDateTime(comment.edited_at)}</span>
                  )}
                  {comment.deleted_at && (
                    <span className="text-[var(--danger)]">
                      Supprimé le {fmtDateTime(comment.deleted_at)}
                    </span>
                  )}
                  <span>{comment.reaction_count} réaction(s)</span>
                  <span>{comment.reply_count} réponse(s)</span>
                </div>
              </Card>
            ))}
            <Paginator
              page={page}
              total={total}
              size={PAGE_SIZE}
              onPage={setPage}
            />
          </div>
        )}
      </AsyncList>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Messages privés
   ═══════════════════════════════════════════════════════════════════════════ */

function MessagesTab({ userId }: { userId: string }) {
  const [page, setPage] = useState(0);
  const state = useAsync(
    () =>
      communityUsersApi.messages(userId, {
        limit: PAGE_SIZE,
        offset: page * PAGE_SIZE,
      }),
    [userId, page],
  );
  const total = state.data?.[0]?.total_count ?? 0;

  return (
    <div className="space-y-4">
      <Card className="border-[var(--brand)]/25 bg-[var(--brand)]/5 p-3">
        <p className="text-xs text-[var(--on-surface-muted)]">
          <strong className="text-[var(--on-surface)]">
            Confidentialité des messages privés.
          </strong>{" "}
          Seules les métadonnées sont affichées. Le contenu d&apos;un message
          n&apos;apparaît que s&apos;il a déjà été versé comme pièce à un
          signalement, donc légitimement porté au dossier de modération.
        </p>
      </Card>

      <AsyncList state={state} empty="Aucun message envoyé par cet utilisateur.">
        {(rows) => (
          <div className="space-y-3">
            {rows.map((message) => (
              <Card key={message.id} className="p-4">
                <div className="flex flex-wrap items-center gap-2">
                  <strong className="text-sm">
                    {message.room_title || "Salon sans titre"}
                  </strong>
                  <StatusBadge status={message.status} map={CONTENT_STATUS} />
                  {message.room_kind && (
                    <Badge tone="neutral">{message.room_kind}</Badge>
                  )}
                  {message.is_evidence && (
                    <Badge tone="warn">Pièce d&apos;un signalement</Badge>
                  )}
                </div>

                {message.is_evidence && message.disclosed_content ? (
                  <p className="mt-2 whitespace-pre-wrap rounded-lg bg-[var(--surface-container)] p-3 text-sm">
                    {message.disclosed_content}
                  </p>
                ) : (
                  <p className="mt-2 text-sm italic text-[var(--on-surface-faint)]">
                    Contenu non divulgué · {message.content_length} caractère
                    {message.content_length > 1 ? "s" : ""}
                  </p>
                )}

                <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-xs text-[var(--on-surface-faint)]">
                  <span>Envoyé le {fmtDateTime(message.created_at)}</span>
                  {message.space_label && <span>{message.space_label}</span>}
                  {message.edited_at && (
                    <span>Modifié le {fmtDateTime(message.edited_at)}</span>
                  )}
                  {message.deleted_at && (
                    <span className="text-[var(--danger)]">
                      Supprimé le {fmtDateTime(message.deleted_at)}
                    </span>
                  )}
                </div>
              </Card>
            ))}
            <Paginator
              page={page}
              total={total}
              size={PAGE_SIZE}
              onPage={setPage}
            />
          </div>
        )}
      </AsyncList>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Signalements
   ═══════════════════════════════════════════════════════════════════════════ */

const REPORT_STATUS_OPTIONS = [
  ["", "Tous les statuts"],
  ["new", "Nouveau"],
  ["triaged", "Trié"],
  ["in_progress", "En traitement"],
  ["resolved", "Résolu"],
  ["rejected", "Rejeté"],
  ["appealed", "Contesté"],
] as const;

function ReportsTab({ userId }: { userId: string }) {
  const [direction, setDirection] = useState<"received" | "sent">("received");
  const [status, setStatus] = useState("");
  const [page, setPage] = useState(0);

  const state = useAsync(
    () =>
      communityUsersApi.reports(userId, {
        direction,
        status: status || undefined,
        limit: PAGE_SIZE,
        offset: page * PAGE_SIZE,
      }),
    [userId, direction, status, page],
  );
  const total = state.data?.[0]?.total_count ?? 0;

  return (
    <div className="space-y-4">
      <div className="grid gap-3 sm:grid-cols-2">
        <Select
          label="Direction"
          value={direction}
          onChange={(next) => {
            setDirection(next as "received" | "sent");
            setPage(0);
          }}
          options={[
            ["received", "Signalements reçus (utilisateur visé)"],
            ["sent", "Signalements émis (utilisateur rapporteur)"],
          ]}
        />
        <Select
          label="Statut"
          value={status}
          onChange={(next) => {
            setStatus(next);
            setPage(0);
          }}
          options={REPORT_STATUS_OPTIONS}
        />
      </div>

      <AsyncList
        state={state}
        empty={
          direction === "received"
            ? "Aucun signalement reçu."
            : "Aucun signalement émis."
        }
      >
        {(rows) => (
          <div className="space-y-3">
            {rows.map((report) => (
              <Card key={report.id} className="p-4">
                <div className="flex flex-wrap items-center gap-2">
                  <strong className="text-sm">{report.reason}</strong>
                  <StatusBadge status={report.status} map={REPORT_STATUS} />
                  {report.priority && (
                    <Badge tone="neutral">Priorité {report.priority}</Badge>
                  )}
                  {report.target_type && (
                    <Badge tone="neutral">
                      {report.target_type === "post"
                        ? "Contenu signalé · publication"
                        : report.target_type === "comment"
                          ? "Contenu signalé · réponse"
                          : report.target_type === "user"
                            ? "Utilisateur signalé"
                            : `Cible · ${report.target_type}`}
                    </Badge>
                  )}
                </div>

                {report.details && (
                  <p className="mt-2 whitespace-pre-wrap text-sm text-[var(--on-surface-muted)]">
                    {report.details}
                  </p>
                )}
                {report.resolution && (
                  <p className="mt-2 rounded-lg bg-[var(--surface-container)] p-3 text-sm">
                    <span className="text-[var(--on-surface-faint)]">
                      Décision :{" "}
                    </span>
                    {report.resolution}
                  </p>
                )}

                <dl className="mt-3 grid gap-3 sm:grid-cols-3">
                  <Field label="Signalé le">
                    {fmtDateTime(report.created_at)}
                  </Field>
                  <Field label="Pris en compte le">
                    {fmtDateTime(report.acknowledged_at)}
                  </Field>
                  <Field label="Traité le">
                    {fmtDateTime(report.resolved_at)}
                  </Field>
                  <Field label="Auteur du signalement">
                    {report.reporter_email ?? "—"}
                  </Field>
                  <Field label="Utilisateur visé">
                    {report.subject_email ?? "—"}
                  </Field>
                  <Field label="Traité par">
                    {report.assigned_email ?? "—"}
                  </Field>
                </dl>

                {report.appealed_at && (
                  <p className="mt-2 text-xs text-[var(--warning)]">
                    Contesté le {fmtDateTime(report.appealed_at)}
                  </p>
                )}
                {report.space_label && (
                  <p className="mt-1 text-xs text-[var(--on-surface-faint)]">
                    {report.space_label}
                  </p>
                )}
              </Card>
            ))}
            <Paginator
              page={page}
              total={total}
              size={PAGE_SIZE}
              onPage={setPage}
            />
          </div>
        )}
      </AsyncList>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Sanctions (historique + application d'une mesure)
   ═══════════════════════════════════════════════════════════════════════════ */

function SanctionsTab({
  detail,
  reload,
}: {
  detail: CommunityAdminUserDetail;
  reload: () => void;
}) {
  const groups = useMemo(() => {
    const live: CommunitySanction[] = [];
    const expired: CommunitySanction[] = [];
    const revoked: CommunitySanction[] = [];
    for (const sanction of detail.sanctions) {
      if (sanction.status === "revoked") revoked.push(sanction);
      else if (isSanctionLive(sanction)) live.push(sanction);
      else expired.push(sanction);
    }
    return { live, expired, revoked };
  }, [detail.sanctions]);

  return (
    <div className="space-y-5">
      <SanctionForm userId={detail.profile.user_id} onDone={reload} />

      <section>
        <SectionTitle icon={AlertTriangle}>Mesures en cours</SectionTitle>
        {groups.live.length === 0 ? (
          <Empty>Aucune mesure active.</Empty>
        ) : (
          <div className="space-y-3">
            {groups.live.map((sanction) => (
              <SanctionCard
                key={sanction.id}
                sanction={sanction}
                onDone={reload}
              />
            ))}
          </div>
        )}
      </section>

      {groups.expired.length > 0 && (
        <section>
          <SectionTitle>Mesures expirées</SectionTitle>
          <div className="space-y-3">
            {groups.expired.map((sanction) => (
              <SanctionCard
                key={sanction.id}
                sanction={sanction}
                onDone={reload}
              />
            ))}
          </div>
        </section>
      )}

      {groups.revoked.length > 0 && (
        <section>
          <SectionTitle>Mesures levées</SectionTitle>
          <div className="space-y-3">
            {groups.revoked.map((sanction) => (
              <SanctionCard
                key={sanction.id}
                sanction={sanction}
                onDone={reload}
              />
            ))}
          </div>
        </section>
      )}

      {detail.sanctions.length === 0 && (
        <Empty>Aucune sanction enregistrée pour cet utilisateur.</Empty>
      )}
    </div>
  );
}

function SanctionForm({
  userId,
  onDone,
}: {
  userId: string;
  onDone: () => void;
}) {
  const [kind, setKind] = useState<CommunitySanctionKind>("warning");
  const [spaceId, setSpaceId] = useState("global");
  const [reason, setReason] = useState("");
  const [endsAt, setEndsAt] = useState("");
  const [permanent, setPermanent] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);

  const deadlineRequired = [
    "post_restriction",
    "comment_restriction",
    "message_restriction",
    "suspension",
  ].includes(kind);
  const canBePermanent = kind === "ban";

  async function submit() {
    if (reason.trim().length < 10) {
      setError(new Error("Le motif doit contenir au moins 10 caractères."));
      return;
    }
    if (deadlineRequired && !endsAt) {
      setError(
        new Error("Une date de fin est obligatoire pour cette restriction."),
      );
      return;
    }
    if (canBePermanent && !permanent && !endsAt) {
      setError(
        new Error("Choisis une date de fin ou le bannissement permanent."),
      );
      return;
    }
    if (!confirm(`Appliquer la sanction « ${SANCTION_LABELS[kind]} » ?`)) return;

    setBusy(true);
    setError(null);
    try {
      await communityUsersApi.imposeSanction({
        userId,
        kind,
        reason: reason.trim(),
        spaceId,
        endsAt: endsAt ? new Date(endsAt).toISOString() : null,
      });
      setReason("");
      setEndsAt("");
      setPermanent(false);
      onDone();
    } catch (cause) {
      setError(cause);
    } finally {
      setBusy(false);
    }
  }

  return (
    <Card className="p-4">
      <SectionTitle icon={Ban}>Appliquer une mesure</SectionTitle>
      <div className="grid gap-3 sm:grid-cols-2">
        <Select
          label="Type de sanction"
          value={kind}
          onChange={(next) => {
            setKind(next as CommunitySanctionKind);
            setPermanent(false);
          }}
          options={Object.entries(SANCTION_LABELS) as [string, string][]}
        />
        <Select
          label="Périmètre"
          value={spaceId}
          onChange={setSpaceId}
          options={SPACES}
        />
      </div>

      <textarea
        value={reason}
        onChange={(event) => setReason(event.target.value)}
        rows={3}
        placeholder="Motif factuel et précis (obligatoire, journalisé)"
        className="mt-3 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
      />

      {kind !== "warning" && (
        <div className="mt-3 flex flex-wrap items-center gap-3">
          <label className="text-xs text-[var(--on-surface-muted)]">
            Fin de la mesure
            <input
              type="datetime-local"
              value={endsAt}
              disabled={permanent}
              onChange={(event) => setEndsAt(event.target.value)}
              className="ml-2 min-h-11 rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm disabled:opacity-50"
            />
          </label>
          {canBePermanent && (
            <label className="inline-flex items-center gap-2 text-sm">
              <input
                type="checkbox"
                checked={permanent}
                onChange={(event) => {
                  setPermanent(event.target.checked);
                  if (event.target.checked) setEndsAt("");
                }}
                className="accent-[var(--danger)]"
              />
              Permanent
            </label>
          )}
        </div>
      )}

      {error != null && (
        <div className="mt-3">
          <ErrorBox error={error} />
        </div>
      )}

      <div className="mt-3 flex justify-end">
        <Button
          variant={kind === "ban" ? "danger" : "primary"}
          disabled={busy}
          onClick={submit}
        >
          {busy ? "Application…" : "Appliquer la mesure"}
        </Button>
      </div>

      <p className="mt-3 text-[11px] text-[var(--on-surface-faint)]">
        L&apos;action est contrôlée côté base : périmètre, hiérarchie,
        auto-sanction et échéance. Elle reste traçable dans le journal
        d&apos;audit.
      </p>
    </Card>
  );
}

function SanctionCard({
  sanction,
  onDone,
}: {
  sanction: CommunitySanction;
  onDone: () => void;
}) {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);

  async function revoke() {
    const reason = prompt("Motif de levée (10 caractères minimum) :")?.trim();
    if (!reason) return;
    if (reason.length < 10) {
      setError(new Error("Le motif doit contenir au moins 10 caractères."));
      return;
    }
    if (!confirm("Lever cette sanction maintenant ?")) return;
    setBusy(true);
    setError(null);
    try {
      await communityUsersApi.revokeSanction(sanction.id, reason);
      onDone();
    } catch (cause) {
      setError(cause);
    } finally {
      setBusy(false);
    }
  }

  const tone: BadgeTone =
    sanction.status === "active"
      ? "bad"
      : sanction.status === "appealed"
        ? "warn"
        : "neutral";
  const statusLabel =
    sanction.status === "active"
      ? "Active"
      : sanction.status === "expired"
        ? "Expirée"
        : sanction.status === "revoked"
          ? "Levée"
          : "Contestée";

  return (
    <Card className="p-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            <strong className="text-sm">
              {SANCTION_LABELS[sanction.kind] ?? sanction.kind}
            </strong>
            <Badge tone={tone}>{statusLabel}</Badge>
            <Badge tone="neutral">
              {sanction.space_label ??
                SPACES.find(([id]) => id === sanction.space_id)?.[1] ??
                sanction.space_id}
            </Badge>
          </div>
          <p className="mt-2 text-sm text-[var(--on-surface-muted)]">
            {sanction.reason}
          </p>
          <dl className="mt-3 grid gap-3 sm:grid-cols-3">
            <Field label="Début">{fmtDateTime(sanction.starts_at)}</Field>
            <Field label="Fin prévue">
              {sanction.ends_at ? fmtDateTime(sanction.ends_at) : "Sans échéance"}
            </Field>
            <Field label="Appliquée par">
              {sanction.imposed_by_email ?? sanction.imposed_by ?? "—"}
            </Field>
            {sanction.revoked_at && (
              <>
                <Field label="Levée le">
                  {fmtDateTime(sanction.revoked_at)}
                </Field>
                <Field label="Levée par">
                  {sanction.revoked_by_email ?? sanction.revoked_by ?? "—"}
                </Field>
              </>
            )}
          </dl>
        </div>
        {isSanctionLive(sanction) && (
          <Button variant="ghost" disabled={busy} onClick={revoke}>
            {busy ? "Levée…" : "Lever"}
          </Button>
        )}
      </div>
      {error != null && (
        <div className="mt-3">
          <ErrorBox error={error} />
        </div>
      )}
    </Card>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Quiz et progression
   ═══════════════════════════════════════════════════════════════════════════ */

function QuizTab({
  userId,
  detail,
}: {
  userId: string;
  detail: CommunityAdminUserDetail;
}) {
  const [module, setModule] = useState("");
  const [page, setPage] = useState(0);

  const summary = useAsync(
    () => communityUsersApi.quizSummary(userId),
    [userId],
  );
  const answers = useAsync(
    () =>
      communityUsersApi.quiz(userId, {
        module: module || undefined,
        limit: PAGE_SIZE,
        offset: page * PAGE_SIZE,
      }),
    [userId, module, page],
  );
  const total = answers.data?.[0]?.total_count ?? 0;
  const progress = detail.cp_progress ?? {};

  const moduleOptions = useMemo(() => {
    const base: [string, string][] = [["", "Tous les modules"]];
    for (const row of summary.data ?? []) {
      if (row.module_key) base.push([row.module_key, row.module_key]);
    }
    return base;
  }, [summary.data]);

  return (
    <div className="space-y-5">
      {/* Progression cas pratique */}
      {Object.keys(progress).length > 0 && (
        <Card className="p-4">
          <SectionTitle icon={BookOpenCheck}>
            Progression cas pratique
          </SectionTitle>
          <dl className="grid gap-4 sm:grid-cols-4">
            <Field label="Cas commencés">{progress.cases_started ?? 0}</Field>
            <Field label="Cas terminés">{progress.cases_finished ?? 0}</Field>
            <Field label="Tentatives">{progress.total_attempts ?? 0}</Field>
            <Field label="Série en cours">
              {progress.streak_days ?? 0} jour(s)
            </Field>
            <Field label="Score moyen">
              {progress.avg_score_percent != null
                ? `${progress.avg_score_percent} %`
                : "—"}
            </Field>
            <Field label="Meilleur score">
              {progress.best_score_percent != null
                ? `${progress.best_score_percent} %`
                : "—"}
            </Field>
            <Field label="Dernière tentative">
              {fmtDateTime(progress.last_attempt_at)}
            </Field>
          </dl>
        </Card>
      )}

      {/* Synthèse quiz par module */}
      <section>
        <SectionTitle icon={BookOpenCheck}>Quiz par module</SectionTitle>
        <AsyncList
          state={summary}
          empty="Aucun historique de quiz pour cet utilisateur."
        >
          {(rows) => (
            <Card className="overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full min-w-[640px] text-sm">
                  <thead className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/40 text-left text-xs text-[var(--on-surface-faint)]">
                    <tr>
                      <th className="px-4 py-3 font-medium">Module</th>
                      <th className="px-3 py-3 font-medium">Parcours</th>
                      <th className="px-3 py-3 font-medium">Réponses</th>
                      <th className="px-3 py-3 font-medium">Bonnes</th>
                      <th className="px-3 py-3 font-medium">Mauvaises</th>
                      <th className="px-3 py-3 font-medium">Réussite</th>
                      <th className="px-3 py-3 font-medium">Temps moyen</th>
                      <th className="px-4 py-3 font-medium">Dernière</th>
                    </tr>
                  </thead>
                  <tbody>
                    {rows.map((row) => (
                      <tr
                        key={`${row.track}-${row.mode}-${row.module_key}`}
                        className="border-b border-[var(--outline-variant)] last:border-0"
                      >
                        <td className="px-4 py-3 font-medium">
                          {row.module_key ?? "—"}
                        </td>
                        <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
                          {pathLabel(row.track, row.mode)}
                        </td>
                        <td className="px-3 py-3 tabular-nums">{row.answers}</td>
                        <td className="px-3 py-3 tabular-nums text-[var(--success)]">
                          {row.correct}
                        </td>
                        <td className="px-3 py-3 tabular-nums text-[var(--danger)]">
                          {row.wrong}
                        </td>
                        <td className="px-3 py-3">
                          <Badge
                            tone={
                              (row.accuracy ?? 0) >= 70
                                ? "good"
                                : (row.accuracy ?? 0) >= 50
                                  ? "warn"
                                  : "bad"
                            }
                          >
                            {row.accuracy != null ? `${row.accuracy} %` : "—"}
                          </Badge>
                        </td>
                        <td className="px-3 py-3 text-xs tabular-nums text-[var(--on-surface-muted)]">
                          {fmtDuration(row.avg_response_ms)}
                        </td>
                        <td className="px-4 py-3 text-xs text-[var(--on-surface-muted)]">
                          {fmtDate(row.last_at)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </Card>
          )}
        </AsyncList>
      </section>

      {/* Historique détaillé */}
      <section>
        <SectionTitle>Historique des réponses</SectionTitle>
        {moduleOptions.length > 1 && (
          <div className="mb-3 max-w-xs">
            <Select
              label="Module"
              value={module}
              onChange={(next) => {
                setModule(next);
                setPage(0);
              }}
              options={moduleOptions}
            />
          </div>
        )}
        <AsyncList state={answers} empty="Aucune réponse enregistrée.">
          {(rows) => (
            <div className="space-y-3">
              {rows.map((row) => (
                <Card key={row.id} className="p-4">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge tone={row.is_correct ? "good" : "bad"}>
                      {row.is_correct ? "Bonne réponse" : "Mauvaise réponse"}
                    </Badge>
                    {row.module_key && (
                      <Badge tone="neutral">{row.module_key}</Badge>
                    )}
                    {row.difficulty && (
                      <Badge tone="neutral">{row.difficulty}</Badge>
                    )}
                  </div>
                  <p className="mt-2 text-sm">{row.question_text ?? "—"}</p>
                  <dl className="mt-2 grid gap-3 sm:grid-cols-3">
                    <Field label="Réponse donnée">{row.user_answer ?? "—"}</Field>
                    <Field label="Réponse attendue">
                      {row.correct_answer ?? "—"}
                    </Field>
                    <Field label="Temps de réponse">
                      {fmtDuration(row.response_time_ms)}
                    </Field>
                  </dl>
                  <p className="mt-2 text-xs text-[var(--on-surface-faint)]">
                    Répondu le {fmtDateTime(row.answered_at)}
                  </p>
                </Card>
              ))}
              <Paginator
                page={page}
                total={total}
                size={PAGE_SIZE}
                onPage={setPage}
              />
            </div>
          )}
        </AsyncList>
      </section>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Abonnement et facturation
   ═══════════════════════════════════════════════════════════════════════════ */

function BillingTab({ userId }: { userId: string }) {
  const state = useAsync(() => communityUsersApi.billing(userId), [userId]);

  if (state.loading) return <Loading />;
  if (state.error != null) return <ErrorBox error={state.error} />;

  const data = state.data;
  if (!data) return <Empty>Aucune donnée de facturation.</Empty>;

  return (
    <div className="space-y-5">
      <section>
        <SectionTitle icon={CreditCard}>Abonnements</SectionTitle>
        {data.subscriptions.length === 0 ? (
          <Empty>Aucun abonnement enregistré.</Empty>
        ) : (
          <div className="space-y-3">
            {data.subscriptions.map((sub) => (
              <Card key={sub.id} className="p-4">
                <div className="flex flex-wrap items-center gap-2">
                  <strong className="text-sm">{sub.plan ?? "Plan inconnu"}</strong>
                  <Badge tone={isPremium(sub.status) ? "good" : "neutral"}>
                    {sub.status ?? "statut inconnu"}
                  </Badge>
                </div>
                <dl className="mt-3 grid gap-3 sm:grid-cols-4">
                  <Field label="Début de période">
                    {fmtDate(sub.current_period_start)}
                  </Field>
                  <Field label="Fin de période">
                    {fmtDate(sub.current_period_end)}
                  </Field>
                  <Field label="Créé le">{fmtDateTime(sub.created_at)}</Field>
                  <Field label="Modifié le">{fmtDateTime(sub.updated_at)}</Field>
                </dl>
              </Card>
            ))}
          </div>
        )}
      </section>

      <section>
        <SectionTitle icon={CreditCard} hint="Identifiants Stripe volontairement non exposés.">
          Factures
        </SectionTitle>
        {data.invoices.length === 0 ? (
          <Empty>Aucune facture enregistrée.</Empty>
        ) : (
          <Card className="overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full min-w-[640px] text-sm">
                <thead className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/40 text-left text-xs text-[var(--on-surface-faint)]">
                  <tr>
                    <th className="px-4 py-3 font-medium">Numéro</th>
                    <th className="px-3 py-3 font-medium">Plan</th>
                    <th className="px-3 py-3 font-medium">Montant</th>
                    <th className="px-3 py-3 font-medium">Statut</th>
                    <th className="px-3 py-3 font-medium">Période</th>
                    <th className="px-4 py-3 font-medium">Payée le</th>
                  </tr>
                </thead>
                <tbody>
                  {data.invoices.map((invoice) => (
                    <tr
                      key={invoice.id}
                      className="border-b border-[var(--outline-variant)] last:border-0"
                    >
                      <td className="px-4 py-3 font-medium">
                        {invoice.invoice_number ?? "—"}
                      </td>
                      <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
                        {invoice.plan ?? "—"}
                      </td>
                      <td className="px-3 py-3 tabular-nums">
                        {fmtMoney(invoice.amount_cents, invoice.currency)}
                      </td>
                      <td className="px-3 py-3">
                        <Badge
                          tone={invoice.status === "paid" ? "good" : "neutral"}
                        >
                          {invoice.status ?? "—"}
                        </Badge>
                      </td>
                      <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
                        {fmtDate(invoice.period_start)} →{" "}
                        {fmtDate(invoice.period_end)}
                      </td>
                      <td className="px-4 py-3 text-xs text-[var(--on-surface-muted)]">
                        {fmtDate(invoice.paid_at)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </Card>
        )}
      </section>

      {data.events.length > 0 && (
        <section>
          <SectionTitle hint="Payload Stripe volontairement non exposé.">
            Évènements de facturation
          </SectionTitle>
          <Card className="divide-y divide-[var(--outline-variant)]">
            {data.events.map((event) => (
              <div
                key={event.id}
                className="flex flex-wrap items-center justify-between gap-2 px-4 py-2.5 text-sm"
              >
                <span>{event.event_type ?? "—"}</span>
                <span className="text-xs text-[var(--on-surface-faint)]">
                  {fmtDateTime(event.created_at)}
                </span>
              </div>
            ))}
          </Card>
        </section>
      )}
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Onglet — Timeline
   ═══════════════════════════════════════════════════════════════════════════ */

const TIMELINE_TONE: Record<string, BadgeTone> = {
  account_created: "brand",
  post: "neutral",
  comment: "neutral",
  message: "neutral",
  report_received: "warn",
  report_sent: "neutral",
  sanction: "bad",
  sanction_revoked: "good",
  cp_attempt: "neutral",
  psy_test: "neutral",
  subscription: "good",
  invoice: "good",
  moderation: "warn",
};

const TIMELINE_PAGE = 40;

function TimelineTab({ userId }: { userId: string }) {
  const [page, setPage] = useState(0);
  const state = useAsync(
    () =>
      communityUsersApi.timeline(userId, {
        limit: TIMELINE_PAGE,
        offset: page * TIMELINE_PAGE,
      }),
    [userId, page],
  );

  return (
    <div className="space-y-4">
      <SectionTitle
        icon={History}
        hint="Évènements réellement présents en base, tous domaines confondus."
      >
        Historique utilisateur
      </SectionTitle>

      <AsyncList state={state} empty="Aucun évènement enregistré.">
        {(rows) => (
          <>
            <ol className="relative space-y-4 border-l border-[var(--outline-variant)] pl-5">
              {rows.map((event, index) => (
                <li key={`${event.kind}-${event.ref_id}-${index}`}>
                  <span className="absolute -left-[5px] mt-1.5 h-2.5 w-2.5 rounded-full bg-[var(--brand)]" />
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge tone={TIMELINE_TONE[event.kind] ?? "neutral"}>
                      {event.label}
                    </Badge>
                    <span className="text-xs text-[var(--on-surface-faint)]">
                      {fmtDateTime(event.occurred_at)}
                    </span>
                  </div>
                  {event.detail && (
                    <p className="mt-1 break-words text-sm text-[var(--on-surface-muted)]">
                      {event.detail}
                    </p>
                  )}
                </li>
              ))}
            </ol>

            <div className="flex justify-between gap-2 pt-2">
              <Button
                variant="ghost"
                disabled={page === 0}
                onClick={() => setPage((value) => Math.max(0, value - 1))}
              >
                Plus récents
              </Button>
              <Button
                variant="ghost"
                disabled={rows.length < TIMELINE_PAGE}
                onClick={() => setPage((value) => value + 1)}
              >
                Plus anciens
              </Button>
            </div>
          </>
        )}
      </AsyncList>
    </div>
  );
}
