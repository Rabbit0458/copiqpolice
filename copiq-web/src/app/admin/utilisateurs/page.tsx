"use client";

/**
 * COP'IQ — Panel administrateur : liste des utilisateurs.
 *
 * La liste reste volontairement légère (une seule RPC paginée). Le détail
 * complet d'un compte est délégué à `UserDossier` (./user-dossier.tsx), qui
 * charge ses données onglet par onglet.
 */

import { useDeferredValue, useMemo, useState } from "react";
import { ChevronLeft, ChevronRight, Search } from "lucide-react";
import {
  communityUsersApi,
  type CommunityAdminUserRow,
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
import { Avatar, pathLabel, UserDossier } from "./user-dossier";

const LIMIT = 40;

export default function UtilisateursPage() {
  const [search, setSearch] = useState("");
  const deferredSearch = useDeferredValue(search);
  const [track, setTrack] = useState("");
  const [mode, setMode] = useState("");
  const [subscription, setSubscription] = useState("");
  const [sanctioned, setSanctioned] = useState(false);
  const [page, setPage] = useState(0);
  const [selectedId, setSelectedId] = useState<string | null>(null);

  const filters = useMemo(
    () => ({
      search: deferredSearch.trim() || undefined,
      track: track || undefined,
      mode: mode || undefined,
      subscription: subscription || undefined,
      sanctioned: sanctioned || undefined,
      limit: LIMIT,
      offset: page * LIMIT,
    }),
    [deferredSearch, track, mode, subscription, sanctioned, page],
  );

  const users = useAsync(() => communityUsersApi.list(filters), [filters]);
  const total = users.data?.[0]?.total_count ?? 0;
  const reset = () => setPage(0);

  return (
    <>
      <PageHeader
        title="Utilisateurs"
        subtitle="Comptes, activité communautaire et sanctions graduées"
      />

      <Card className="mb-4 p-4">
        <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-5">
          <label className="relative xl:col-span-2">
            <span className="sr-only">Rechercher un utilisateur</span>
            <Search
              size={17}
              className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]"
            />
            <input
              placeholder="E-mail, nom, pseudo ou identifiant"
              value={search}
              onChange={(event) => {
                setSearch(event.target.value);
                reset();
              }}
              className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] pl-10 pr-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15"
            />
          </label>
          <Filter
            value={track}
            onChange={(value) => {
              setTrack(value);
              reset();
            }}
            label="Parcours"
            options={[
              ["", "Tous les parcours"],
              ["pa", "Policier adjoint"],
              ["gpx", "Gardien de la paix"],
            ]}
          />
          <Filter
            value={mode}
            onChange={(value) => {
              setMode(value);
              reset();
            }}
            label="Mode"
            options={[
              ["", "Examen et école"],
              ["exam", "Concours"],
              ["school", "École"],
            ]}
          />
          <Filter
            value={subscription}
            onChange={(value) => {
              setSubscription(value);
              reset();
            }}
            label="Abonnement"
            options={[
              ["", "Tous les abonnements"],
              ["premium", "Premium"],
              ["free", "Gratuit"],
            ]}
          />
        </div>
        <label className="mt-3 inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl px-2 text-sm text-[var(--on-surface-muted)]">
          <input
            type="checkbox"
            checked={sanctioned}
            onChange={(event) => {
              setSanctioned(event.target.checked);
              reset();
            }}
            className="h-4 w-4 accent-[var(--brand)]"
          />
          Afficher uniquement les comptes sanctionnés
        </label>
      </Card>

      {users.error != null && <ErrorBox error={users.error} />}
      {users.loading && <Loading />}
      {!users.loading && users.data?.length === 0 && (
        <Empty>Aucun utilisateur trouvé.</Empty>
      )}

      {(users.data?.length ?? 0) > 0 && (
        <Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full min-w-[880px] text-sm">
              <thead className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/40 text-left text-xs text-[var(--on-surface-faint)]">
                <tr>
                  <th className="px-4 py-3 font-medium">Compte</th>
                  <th className="px-3 py-3 font-medium">Parcours</th>
                  <th className="px-3 py-3 font-medium">Abonnement</th>
                  <th className="px-3 py-3 font-medium">Activité</th>
                  <th className="px-3 py-3 font-medium">Signalements</th>
                  <th className="px-4 py-3 font-medium">État</th>
                </tr>
              </thead>
              <tbody>
                {(users.data ?? []).map((user) => (
                  <UserLine
                    key={user.user_id}
                    user={user}
                    onOpen={() => setSelectedId(user.user_id)}
                  />
                ))}
              </tbody>
            </table>
          </div>
          {total > LIMIT && (
            <div className="flex items-center justify-between border-t border-[var(--outline-variant)] px-4 py-3">
              <span className="text-xs text-[var(--on-surface-muted)]">
                {page * LIMIT + 1}–{Math.min((page + 1) * LIMIT, total)} sur{" "}
                {total}
              </span>
              <div className="flex gap-2">
                <Button
                  variant="ghost"
                  disabled={page === 0}
                  onClick={() => setPage((value) => Math.max(0, value - 1))}
                >
                  <ChevronLeft size={16} /> Précédent
                </Button>
                <Button
                  variant="ghost"
                  disabled={(page + 1) * LIMIT >= total}
                  onClick={() => setPage((value) => value + 1)}
                >
                  Suivant <ChevronRight size={16} />
                </Button>
              </div>
            </div>
          )}
        </Card>
      )}

      {selectedId && (
        <UserDossier
          userId={selectedId}
          onClose={() => setSelectedId(null)}
          onChanged={users.reload}
        />
      )}
    </>
  );
}

function UserLine({
  user,
  onOpen,
}: {
  user: CommunityAdminUserRow;
  onOpen: () => void;
}) {
  const name =
    [user.first_name, user.last_name].filter(Boolean).join(" ") ||
    user.username ||
    "Sans nom";
  const premium = ["active", "trialing"].includes(user.subscription_status ?? "");
  return (
    <tr
      onClick={onOpen}
      onKeyDown={(event) => {
        if (event.key === "Enter" || event.key === " ") onOpen();
      }}
      tabIndex={0}
      className="cursor-pointer border-b border-[var(--outline-variant)] transition last:border-0 hover:bg-[var(--surface-container)]/55 focus-visible:outline-2 focus-visible:outline-inset focus-visible:outline-[var(--brand)]"
    >
      <td className="px-4 py-3">
        <div className="flex items-center gap-3">
          <Avatar index={user.avatar_index} name={name} />
          <div>
            <div className="font-medium">{name}</div>
            <div className="text-xs text-[var(--on-surface-faint)]">
              {user.username ? `@${user.username} · ` : ""}
              {user.email}
            </div>
          </div>
        </div>
      </td>
      <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
        {pathLabel(user.user_track, user.user_mode)}
      </td>
      <td className="px-3 py-3">
        {premium ? (
          <Badge tone="good">{user.plan ?? "Premium"}</Badge>
        ) : (
          <Badge tone="neutral">Gratuit</Badge>
        )}
      </td>
      <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
        {user.posts_count} publ. · {user.comments_count} rép.
      </td>
      <td className="px-3 py-3">
        <Badge tone={user.reports_received > 0 ? "warn" : "neutral"}>
          {user.reports_received}
        </Badge>
      </td>
      <td className="px-4 py-3">
        {user.active_sanctions > 0 ? (
          <Badge tone="bad">
            {user.active_sanctions} active{user.active_sanctions > 1 ? "s" : ""}
          </Badge>
        ) : (
          <Badge tone="good">Normal</Badge>
        )}
      </td>
    </tr>
  );
}

function Filter({
  value,
  onChange,
  options,
  label,
}: {
  value: string;
  onChange: (value: string) => void;
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
