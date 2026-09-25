"use client";

/**
 * COP'IQ — Panel administrateur : liste des utilisateurs.
 *
 * La liste reste volontairement légère (une seule RPC paginée). Le détail
 * complet d'un compte est délégué à `UserDossier` (./user-dossier.tsx), qui
 * charge ses données onglet par onglet.
 */

import { useDeferredValue, useEffect, useMemo, useRef, useState } from "react";
import { Activity, Apple, Check, ChevronDown, ChevronLeft, ChevronRight, Crown, Database, MonitorSmartphone, Search, ShieldAlert, Sparkles, UserRoundCheck, UsersRound } from "lucide-react";
import {
  communityUsersApi,
  type CommunityAdminUserRow,
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
  const visibleStats = useMemo(() => ({
    premium: users.data?.filter((user) => ["active", "trialing"].includes(user.subscription_status ?? "")).length ?? 0,
    sanctioned: users.data?.filter((user) => user.active_sanctions > 0).length ?? 0,
    active: users.data?.filter((user) => Boolean(user.last_seen)).length ?? 0,
  }), [users.data]);
  const reset = () => setPage(0);

  return (
    <>
      <PageHeader
        title="Utilisateurs"
        subtitle="Identité, parcours, progression, communauté, abonnement et historique réunis dans un dossier 360°."
        action={<div className="hidden items-center gap-2 rounded-full border border-[var(--outline-variant)] bg-[var(--surface)]/70 px-3 py-2 text-xs text-[var(--on-surface-muted)] shadow-sm lg:flex"><Database size={15} className="text-[var(--brand)]"/>Toutes les tables connectées</div>}
      />

      <Card className="relative mb-4 overflow-hidden p-5 md:p-6">
        <div className="pointer-events-none absolute -right-16 -top-24 h-64 w-64 rounded-full bg-[var(--brand)]/12 blur-3xl"/>
        <div className="relative flex flex-col justify-between gap-5 lg:flex-row lg:items-center">
          <div className="flex items-start gap-3.5"><span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-[var(--brand)]/12 text-[var(--brand)]"><Sparkles size={22}/></span><div><h2 className="text-lg font-semibold tracking-[-.02em]">Vision complète de chaque compte</h2><p className="mt-1 max-w-2xl text-sm leading-6 text-[var(--on-surface-muted)]">Ouvrez un utilisateur pour consulter toutes ses données liées, de l’inscription jusqu’à sa dernière activité.</p></div></div>
          <div className="flex flex-wrap gap-2"><span className="rounded-full bg-[var(--brand)]/10 px-3 py-2 text-xs font-medium text-[var(--brand)]">GPX</span><span className="rounded-full bg-[var(--brand)]/10 px-3 py-2 text-xs font-medium text-[var(--brand)]">PA</span><span className="rounded-full bg-[var(--surface-container)] px-3 py-2 text-xs font-medium text-[var(--on-surface-muted)]">École</span><span className="rounded-full bg-[var(--surface-container)] px-3 py-2 text-xs font-medium text-[var(--on-surface-muted)]">Concours</span></div>
        </div>
      </Card>

      <div className="mb-4 grid grid-cols-2 gap-2 lg:grid-cols-4">
        <UserStat icon={UsersRound} value={total} label="Comptes trouvés" />
        <UserStat icon={Activity} value={visibleStats.active} label="Avec activité enregistrée" tone="good" />
        <UserStat icon={Crown} value={visibleStats.premium} label="Premium sur cette page" tone="warn" />
        <UserStat icon={ShieldAlert} value={visibleStats.sanctioned} label="Sanctionnés sur cette page" tone={visibleStats.sanctioned ? "bad" : "good"} />
      </div>

      <Card className="mb-4 p-3 md:p-4">
        <div className="mb-3 flex items-center justify-between"><div><h2 className="text-sm font-semibold">Rechercher et filtrer</h2><p className="text-xs text-[var(--on-surface-faint)]">Les résultats s’actualisent automatiquement.</p></div><UserRoundCheck size={20} className="text-[var(--brand)]"/></div>
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
              className="min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] pl-10 pr-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"
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
      {users.loading && <Card><Loading label="Chargement des comptes…" /></Card>}
      {!users.loading && users.data?.length === 0 && (
        <Card className="px-6 py-14 text-center"><UsersRound className="mx-auto text-[var(--brand)]" size={32}/><h2 className="mt-4 text-lg font-semibold">Aucun utilisateur trouvé</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Modifiez la recherche ou les filtres pour élargir les résultats.</p></Card>
      )}

      {(users.data?.length ?? 0) > 0 && (
        <Card className="overflow-hidden shadow-xl shadow-blue-950/10">
          <div className="flex items-center justify-between border-b border-[var(--outline-variant)] px-4 py-3"><div><h2 className="text-sm font-semibold">Répertoire des utilisateurs</h2><p className="text-xs text-[var(--on-surface-faint)]">Cliquez sur une ligne pour ouvrir le dossier complet.</p></div><Badge tone="brand">{total} compte{total>1?"s":""}</Badge></div>
          <div className="overflow-x-auto">
            <table className="w-full min-w-[960px] text-sm">
              <thead className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/40 text-left text-xs text-[var(--on-surface-faint)]">
                <tr>
                  <th className="w-20 px-4 py-3 text-center font-medium">Plateforme</th>
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

function UserStat({ icon: Icon, value, label, tone = "brand" }: { icon: typeof UsersRound; value: number; label: string; tone?: "brand"|"good"|"warn"|"bad" }) {
  const color = tone === "good" ? "bg-[var(--success)]/10 text-[var(--success)]" : tone === "warn" ? "bg-[var(--warning)]/10 text-[var(--warning)]" : tone === "bad" ? "bg-[var(--danger)]/10 text-[var(--danger)]" : "bg-[var(--brand)]/10 text-[var(--brand)]";
  return <Card className="flex min-h-24 items-center gap-3 p-4"><span className={`grid h-11 w-11 shrink-0 place-items-center rounded-xl ${color}`}><Icon size={20}/></span><div><strong className="block text-2xl font-semibold tracking-[-.03em] tabular-nums">{value}</strong><span className="text-xs text-[var(--on-surface-muted)]">{label}</span></div></Card>;
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
      className="group cursor-pointer border-b border-[var(--outline-variant)] transition duration-200 last:border-0 hover:bg-[var(--brand)]/5 focus-visible:outline-2 focus-visible:outline-inset focus-visible:outline-[var(--brand)]"
    >
      <td className="px-4 py-3"><PlatformBadge platform={user.platform}/></td>
      <td className="px-4 py-3">
        <div className="flex items-center gap-3">
          <Avatar index={user.avatar_index} name={name} />
          <div className="min-w-0">
            <div className="font-medium transition group-hover:text-[var(--brand)]">{name}</div>
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
        <div className="flex items-center justify-between gap-2">{user.active_sanctions > 0 ? (
          <Badge tone="bad">
            {user.active_sanctions} active{user.active_sanctions > 1 ? "s" : ""}
          </Badge>
        ) : (
          <Badge tone="good">Normal</Badge>
        )}<ChevronRight size={16} className="text-[var(--on-surface-faint)] transition group-hover:translate-x-0.5 group-hover:text-[var(--brand)]"/></div>
      </td>
    </tr>
  );
}

function PlatformBadge({ platform }: { platform: string | null }) {
  const normalized = platform?.toLowerCase();
  if (normalized === "ios") return <span title="iOS" aria-label="iOS" className="mx-auto grid h-10 w-10 place-items-center rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)] text-[var(--on-surface)]"><Apple size={20}/></span>;
  if (normalized === "android") return <span title="Android" aria-label="Android" className="mx-auto grid h-10 w-10 place-items-center rounded-xl border border-emerald-500/20 bg-emerald-500/10 text-emerald-400"><AndroidLogo/></span>;
  if (normalized === "web") return <span title="Web" aria-label="Web" className="mx-auto grid h-10 w-10 place-items-center rounded-xl border border-blue-500/20 bg-blue-500/10 text-blue-400"><MonitorSmartphone size={19}/></span>;
  return <span title="Plateforme inconnue" aria-label="Plateforme inconnue" className="mx-auto grid h-10 w-10 place-items-center rounded-xl border border-dashed border-[var(--outline)] text-sm text-[var(--on-surface-faint)]">—</span>;
}

function AndroidLogo() {
  return <svg aria-hidden="true" viewBox="0 0 24 24" className="h-5 w-5 fill-current"><path d="M17.6 9.48l1.84-3.18a.38.38 0 0 0-.66-.38l-1.86 3.22A11.1 11.1 0 0 0 12 8a11.1 11.1 0 0 0-4.92 1.14L5.22 5.92a.38.38 0 1 0-.66.38L6.4 9.48A8.53 8.53 0 0 0 3 16h18a8.53 8.53 0 0 0-3.4-6.52ZM8 13.25a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5Zm8 0a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5Z"/></svg>;
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
  const [open, setOpen] = useState(false);
  const root = useRef<HTMLDivElement>(null);
  const selected = options.find(([key]) => key === value)?.[1] ?? label;
  useEffect(() => {
    const close = (event: MouseEvent) => {
      if (root.current && !root.current.contains(event.target as Node)) setOpen(false);
    };
    document.addEventListener("mousedown", close);
    return () => document.removeEventListener("mousedown", close);
  }, []);
  return (
    <div ref={root} className="relative">
      <button type="button" aria-label={label} aria-haspopup="listbox" aria-expanded={open} onClick={() => setOpen((current) => !current)} onKeyDown={(event) => { if (event.key === "Escape") setOpen(false); }} className={`flex min-h-12 w-full cursor-pointer items-center justify-between gap-3 rounded-xl border px-3.5 text-left text-sm font-medium outline-none transition duration-200 ${open ? "border-[var(--brand)] bg-[var(--brand)]/8 ring-4 ring-[var(--brand)]/10" : "border-[var(--outline)] bg-[var(--surface-container)] hover:border-[var(--brand)]/35 hover:bg-[var(--surface-container-hi)]"}`}>
        <span className="min-w-0"><span className="block text-[10px] font-semibold uppercase tracking-[.12em] text-[var(--on-surface-faint)]">{label}</span><span className="block truncate text-[var(--on-surface)]">{selected}</span></span>
        <ChevronDown size={17} className={`shrink-0 text-[var(--on-surface-faint)] transition-transform ${open ? "rotate-180 text-[var(--brand)]" : ""}`}/>
      </button>
      {open && <div role="listbox" aria-label={label} className="absolute left-0 right-0 z-30 mt-2 overflow-hidden rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-1.5 shadow-2xl shadow-black/30 backdrop-blur-xl">
        {options.map(([key,text]) => <button key={key} type="button" role="option" aria-selected={value===key} onClick={() => { onChange(key); setOpen(false); }} className={`flex min-h-11 w-full cursor-pointer items-center justify-between rounded-lg px-3 text-left text-sm transition ${value===key ? "bg-[var(--brand)]/12 font-medium text-[var(--brand)]" : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"}`}><span>{text}</span>{value===key&&<Check size={16}/>}</button>)}
      </div>}
    </div>
  );
}
