"use client";

import { useDeferredValue, useMemo, useState } from "react";
import {
  CheckCircle2,
  Clock3,
  KeyRound,
  RefreshCw,
  Search,
  ShieldCheck,
  ShieldOff,
  UserRoundCheck,
} from "lucide-react";
import {
  activeAccessAdminApi,
  type ActiveAccessAttempt,
  type ActiveAccessRow,
  type ActiveAccessStatus,
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
import { ActiveContentManager } from "./active-content-manager";

const date = (value?: string | null) =>
  value
    ? new Intl.DateTimeFormat("fr-FR", {
        dateStyle: "medium",
        timeStyle: "short",
      }).format(new Date(value))
    : "—";

const tone = (status: ActiveAccessStatus) =>
  status === "granted" ? "good" : status === "revoked" ? "bad" : "warn";

const label = (status: ActiveAccessStatus) =>
  status === "granted" ? "Accès accordé" : status === "revoked" ? "Révoqué" : "En attente";

export default function ActiveAccessPage() {
  const [search, setSearch] = useState("");
  const deferredSearch = useDeferredValue(search);
  const [status, setStatus] = useState("");
  const [selected, setSelected] = useState<ActiveAccessRow | null>(null);
  const filters = useMemo(
    () => ({ status: status || undefined, search: deferredSearch.trim() || undefined }),
    [deferredSearch, status],
  );
  const users = useAsync(() => activeAccessAdminApi.list(filters), [filters]);

  return (
    <>
      <PageHeader
        title="Module Je suis actif"
        subtitle="Publiez les catégories et les cours, puis contrôlez les accès professionnels."
        action={
          <Button variant="ghost" onClick={users.reload} disabled={users.loading}>
            <RefreshCw size={16} className="mr-2 inline" /> Actualiser
          </Button>
        }
      />

      <ActiveContentManager />

      <Card className="relative mb-4 overflow-hidden p-5 md:p-6">
        <div className="pointer-events-none absolute -right-20 -top-24 h-64 w-64 rounded-full bg-[var(--brand)]/12 blur-3xl" />
        <div className="relative flex items-start gap-4">
          <span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-[var(--brand)]/12 text-[var(--brand)]">
            <ShieldCheck size={24} />
          </span>
          <div>
            <h2 className="text-lg font-semibold">Parcours protégé côté serveur</h2>
            <p className="mt-1 max-w-3xl text-sm leading-6 text-[var(--on-surface-muted)]">
              Les réponses attendues ne sont jamais envoyées au navigateur. Toute attribution,
              restauration ou révocation exige un compte propriétaire en AAL2 et produit une trace d’audit.
            </p>
          </div>
        </div>
      </Card>

      <Card className="mb-4 p-4">
        <div className="grid gap-3 md:grid-cols-[1fr_240px]">
          <label className="relative">
            <Search size={17} className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" />
            <input
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              placeholder="Rechercher par e-mail ou identifiant"
              className="min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] pl-10 pr-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"
            />
          </label>
          <select
            value={status}
            onChange={(event) => setStatus(event.target.value)}
            className="min-h-12 rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] px-3 text-sm outline-none focus:border-[var(--brand)]"
          >
            <option value="">Tous les statuts</option>
            <option value="pending">En attente</option>
            <option value="granted">Accès accordé</option>
            <option value="revoked">Révoqué</option>
          </select>
        </div>
      </Card>

      {users.error != null && <ErrorBox error={users.error} />}
      {users.loading && <Card><Loading label="Chargement des validations…" /></Card>}
      {!users.loading && users.data?.length === 0 && (
        <Card className="p-12 text-center">
          <KeyRound className="mx-auto text-[var(--brand)]" size={34} />
          <h2 className="mt-4 font-semibold">Aucune validation trouvée</h2>
          <p className="mt-1 text-sm text-[var(--on-surface-muted)]">Aucun utilisateur n’a encore engagé ce parcours.</p>
        </Card>
      )}
      {(users.data?.length ?? 0) > 0 && (
        <Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full min-w-[880px] text-sm">
              <thead className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/50 text-left text-xs text-[var(--on-surface-faint)]">
                <tr>
                  <th className="px-4 py-3 font-medium">Utilisateur</th>
                  <th className="px-3 py-3 font-medium">Statut</th>
                  <th className="px-3 py-3 font-medium">Tentatives</th>
                  <th className="px-3 py-3 font-medium">Dernier score</th>
                  <th className="px-3 py-3 font-medium">Dernière tentative</th>
                  <th className="px-4 py-3" />
                </tr>
              </thead>
              <tbody>
                {users.data?.map((user) => (
                  <tr key={user.user_id} className="border-b border-[var(--outline-variant)]/70 transition hover:bg-[var(--brand)]/5">
                    <td className="px-4 py-4">
                      <div className="font-medium">{user.email || "E-mail indisponible"}</div>
                      <div className="mt-0.5 font-mono text-[11px] text-[var(--on-surface-faint)]">{user.user_id}</div>
                    </td>
                    <td className="px-3 py-4"><Badge tone={tone(user.status)}>{label(user.status)}</Badge></td>
                    <td className="px-3 py-4 tabular-nums">{user.attempts}</td>
                    <td className="px-3 py-4 tabular-nums">{user.last_score == null ? "—" : `${user.last_score}/4`}</td>
                    <td className="px-3 py-4 text-[var(--on-surface-muted)]">{date(user.last_attempt_at)}</td>
                    <td className="px-4 py-4 text-right"><Button variant="ghost" onClick={() => setSelected(user)}>Examiner</Button></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>
      )}

      {selected && (
        <AccessDrawer
          user={selected}
          onClose={() => setSelected(null)}
          onChanged={() => {
            users.reload();
            setSelected(null);
          }}
        />
      )}
    </>
  );
}

function AccessDrawer({ user, onClose, onChanged }: { user: ActiveAccessRow; onClose: () => void; onChanged: () => void }) {
  const detail = useAsync(() => activeAccessAdminApi.detail(user.user_id), [user.user_id]);
  const [busy, setBusy] = useState(false);
  const [actionError, setActionError] = useState<unknown>(null);

  const change = async (action: "grant" | "restore" | "revoke") => {
    const reason = window.prompt(
      action === "revoke" ? "Motif obligatoire de la révocation :" : "Commentaire de journalisation (facultatif) :",
    );
    if (reason === null || (action === "revoke" && !reason.trim())) return;
    if (!window.confirm(`Confirmer l’action « ${action} » pour ${user.email || user.user_id} ?`)) return;
    setBusy(true);
    setActionError(null);
    try {
      await activeAccessAdminApi.setAccess(user.user_id, action, reason);
      onChanged();
    } catch (error) {
      setActionError(error);
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex justify-end bg-slate-950/65 backdrop-blur-sm" role="dialog" aria-modal="true">
      <button aria-label="Fermer" className="absolute inset-0 cursor-default" onClick={onClose} />
      <aside className="relative h-full w-full max-w-2xl overflow-y-auto border-l border-[var(--outline-variant)] bg-[var(--background)] p-5 shadow-2xl md:p-7">
        <div className="flex items-start justify-between gap-4">
          <div><Badge tone={tone(user.status)}>{label(user.status)}</Badge><h2 className="mt-3 text-xl font-semibold">{user.email || "Utilisateur"}</h2><p className="mt-1 break-all font-mono text-xs text-[var(--on-surface-faint)]">{user.user_id}</p></div>
          <Button variant="ghost" onClick={onClose}>Fermer</Button>
        </div>

        <div className="mt-5 flex flex-wrap gap-2">
          {user.status === "revoked" ? (
            <Button onClick={() => change("restore")} disabled={busy}><UserRoundCheck size={16} className="mr-2 inline" />Restaurer</Button>
          ) : user.status === "granted" ? (
            <Button variant="danger" onClick={() => change("revoke")} disabled={busy}><ShieldOff size={16} className="mr-2 inline" />Révoquer</Button>
          ) : (
            <Button onClick={() => change("grant")} disabled={busy}><ShieldCheck size={16} className="mr-2 inline" />Accorder manuellement</Button>
          )}
        </div>
        {actionError != null && <div className="mt-4"><ErrorBox error={actionError} /></div>}
        {detail.error != null && <div className="mt-4"><ErrorBox error={detail.error} /></div>}
        {detail.loading && <Loading label="Chargement de l’historique…" />}
        {!detail.loading && (
          <div className="mt-7 space-y-4">
            <div className="flex items-center gap-2"><Clock3 size={18} className="text-[var(--brand)]" /><h3 className="font-semibold">Historique des tentatives</h3></div>
            {detail.data?.attempts.length === 0 && <Card className="p-5 text-sm text-[var(--on-surface-muted)]">Aucune tentative enregistrée.</Card>}
            {detail.data?.attempts.map((attempt) => <AttemptCard key={attempt.id} attempt={attempt} />)}
          </div>
        )}
      </aside>
    </div>
  );
}

function AttemptCard({ attempt }: { attempt: ActiveAccessAttempt }) {
  return (
    <Card className="p-4">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex items-center gap-2">
          {attempt.passed ? <CheckCircle2 size={18} className="text-[var(--success)]" /> : <ShieldOff size={18} className="text-[var(--danger)]" />}
          <span className="font-semibold">Score {attempt.score}/4</span>
          <Badge tone={attempt.passed ? "good" : "bad"}>{attempt.passed ? "Réussie" : "Échouée"}</Badge>
        </div>
        <span className="text-xs text-[var(--on-surface-faint)]">{date(attempt.completed_at)}</span>
      </div>
      <div className="mt-4 space-y-3">
        {attempt.answers.map((answer) => (
          <div key={answer.position} className="rounded-xl bg-[var(--surface-container)] p-3">
            <div className="flex items-start justify-between gap-3"><p className="text-sm font-medium">{answer.position}. {answer.prompt}</p><Badge tone={answer.correct ? "good" : "bad"}>{answer.correct ? "Correct" : "Incorrect"}</Badge></div>
            <p className="mt-2 text-sm text-[var(--on-surface-muted)]"><span className="font-medium">Réponse saisie :</span> {answer.answer || "Aucune"}</p>
          </div>
        ))}
      </div>
    </Card>
  );
}
