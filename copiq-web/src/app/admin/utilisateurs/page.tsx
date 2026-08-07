"use client"

import { useDeferredValue, useMemo, useState } from "react"
import {
  AlertTriangle,
  Ban,
  ChevronLeft,
  ChevronRight,
  Clock3,
  FileText,
  MessageSquare,
  Search,
  ShieldAlert,
  UserRound,
  X,
} from "lucide-react"
import {
  communityUsersApi,
  type CommunityAdminUserDetail,
  type CommunityAdminUserRow,
  type CommunitySanction,
  type CommunitySanctionKind,
} from "@/lib/admin/api"
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

const LIMIT = 40
const SANCTION_LABELS: Record<CommunitySanctionKind, string> = {
  warning: "Avertissement",
  post_restriction: "Publication interdite",
  comment_restriction: "Commentaires interdits",
  message_restriction: "Messagerie interdite",
  suspension: "Suspension du forum",
  ban: "Bannissement",
}
const SPACES = [
  ["global", "Toute la communauté"],
  ["pa_exam", "Concours policier adjoint"],
  ["gpx_exam", "Concours gardien de la paix"],
  ["pa_school", "École policier adjoint"],
  ["gpx_school", "École gardien de la paix"],
] as const

export default function UtilisateursPage() {
  const [search, setSearch] = useState("")
  const deferredSearch = useDeferredValue(search)
  const [track, setTrack] = useState("")
  const [mode, setMode] = useState("")
  const [subscription, setSubscription] = useState("")
  const [sanctioned, setSanctioned] = useState(false)
  const [page, setPage] = useState(0)
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const filters = useMemo(() => ({
    search: deferredSearch.trim() || undefined,
    track: track || undefined,
    mode: mode || undefined,
    subscription: subscription || undefined,
    sanctioned: sanctioned || undefined,
    limit: LIMIT,
    offset: page * LIMIT,
  }), [deferredSearch, track, mode, subscription, sanctioned, page])
  const users = useAsync(() => communityUsersApi.list(filters), [filters])
  const total = users.data?.[0]?.total_count ?? 0
  const reset = () => setPage(0)

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
            <Search size={17} className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" />
            <input
              placeholder="E-mail, nom, pseudo ou identifiant"
              value={search}
              onChange={(event) => { setSearch(event.target.value); reset() }}
              className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] pl-10 pr-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15"
            />
          </label>
          <Filter value={track} onChange={(value) => { setTrack(value); reset() }} label="Parcours" options={[["", "Tous les parcours"], ["pa", "Policier adjoint"], ["gpx", "Gardien de la paix"]]} />
          <Filter value={mode} onChange={(value) => { setMode(value); reset() }} label="Mode" options={[["", "Examen et école"], ["exam", "Concours"], ["school", "École"]]} />
          <Filter value={subscription} onChange={(value) => { setSubscription(value); reset() }} label="Abonnement" options={[["", "Tous les abonnements"], ["premium", "Premium"], ["free", "Gratuit"]]} />
        </div>
        <label className="mt-3 inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl px-2 text-sm text-[var(--on-surface-muted)]">
          <input type="checkbox" checked={sanctioned} onChange={(event) => { setSanctioned(event.target.checked); reset() }} className="h-4 w-4 accent-[var(--brand)]" />
          Afficher uniquement les comptes sanctionnés
        </label>
      </Card>

      {users.error != null && <ErrorBox error={users.error} />}
      {users.loading && <Loading />}
      {!users.loading && users.data?.length === 0 && <Empty>Aucun utilisateur trouvé.</Empty>}

      {(users.data?.length ?? 0) > 0 && (
        <Card className="overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full min-w-[880px] text-sm">
              <thead className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/40 text-left text-xs text-[var(--on-surface-faint)]">
                <tr><th className="px-4 py-3 font-medium">Compte</th><th className="px-3 py-3 font-medium">Parcours</th><th className="px-3 py-3 font-medium">Abonnement</th><th className="px-3 py-3 font-medium">Activité</th><th className="px-3 py-3 font-medium">Signalements</th><th className="px-4 py-3 font-medium">État</th></tr>
              </thead>
              <tbody>
                {(users.data ?? []).map((user) => <UserLine key={user.user_id} user={user} onOpen={() => setSelectedId(user.user_id)} />)}
              </tbody>
            </table>
          </div>
          {total > LIMIT && <div className="flex items-center justify-between border-t border-[var(--outline-variant)] px-4 py-3"><span className="text-xs text-[var(--on-surface-muted)]">{page * LIMIT + 1}–{Math.min((page + 1) * LIMIT, total)} sur {total}</span><div className="flex gap-2"><Button variant="ghost" disabled={page === 0} onClick={() => setPage((value) => Math.max(0, value - 1))}><ChevronLeft size={16} /> Précédent</Button><Button variant="ghost" disabled={(page + 1) * LIMIT >= total} onClick={() => setPage((value) => value + 1)}>Suivant <ChevronRight size={16} /></Button></div></div>}
        </Card>
      )}

      {selectedId && <UserPanel userId={selectedId} onClose={() => setSelectedId(null)} onChanged={users.reload} />}
    </>
  )
}

function UserLine({ user, onOpen }: { user: CommunityAdminUserRow; onOpen: () => void }) {
  const name = [user.first_name, user.last_name].filter(Boolean).join(" ") || user.username || "Sans nom"
  const premium = ["active", "trialing"].includes(user.subscription_status ?? "")
  return (
    <tr onClick={onOpen} onKeyDown={(event) => { if (event.key === "Enter" || event.key === " ") onOpen() }} tabIndex={0} className="cursor-pointer border-b border-[var(--outline-variant)] transition last:border-0 hover:bg-[var(--surface-container)]/55 focus-visible:outline-2 focus-visible:outline-inset focus-visible:outline-[var(--brand)]">
      <td className="px-4 py-3"><div className="flex items-center gap-3"><Avatar index={user.avatar_index} name={name} /><div><div className="font-medium">{name}</div><div className="text-xs text-[var(--on-surface-faint)]">{user.username ? `@${user.username} · ` : ""}{user.email}</div></div></div></td>
      <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">{pathLabel(user.user_track, user.user_mode)}</td>
      <td className="px-3 py-3">{premium ? <Badge tone="good">{user.plan ?? "Premium"}</Badge> : <Badge tone="neutral">Gratuit</Badge>}</td>
      <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">{user.posts_count} publ. · {user.comments_count} rép.</td>
      <td className="px-3 py-3"><Badge tone={user.reports_received > 0 ? "warn" : "neutral"}>{user.reports_received}</Badge></td>
      <td className="px-4 py-3">{user.active_sanctions > 0 ? <Badge tone="bad">{user.active_sanctions} active{user.active_sanctions > 1 ? "s" : ""}</Badge> : <Badge tone="good">Normal</Badge>}</td>
    </tr>
  )
}

function UserPanel({ userId, onClose, onChanged }: { userId: string; onClose: () => void; onChanged: () => void }) {
  const detail = useAsync(() => communityUsersApi.detail(userId), [userId])
  return (
    <div className="fixed inset-0 z-50 flex justify-end bg-black/35 backdrop-blur-[2px]" role="dialog" aria-modal="true" aria-label="Fiche utilisateur" onMouseDown={(event) => { if (event.target === event.currentTarget) onClose() }}>
      <div className="h-full w-full max-w-2xl overflow-y-auto border-l border-[var(--outline-variant)] bg-[var(--surface)] shadow-2xl animate-fade-in">
        <div className="sticky top-0 z-10 flex items-center justify-between border-b border-[var(--outline-variant)] bg-[var(--surface)]/95 px-5 py-4 backdrop-blur-xl"><div><h2 className="font-semibold">Fiche utilisateur</h2><p className="text-xs text-[var(--on-surface-muted)]">Données utiles à la modération, sans contenu privé</p></div><button onClick={onClose} className="grid h-11 w-11 place-items-center rounded-xl transition hover:bg-[var(--surface-container)]" aria-label="Fermer"><X size={20} /></button></div>
        <div className="p-5">
          {detail.loading && <Loading />}
          {detail.error != null && <ErrorBox error={detail.error} />}
          {detail.data && <UserDetail detail={detail.data} reload={() => { detail.reload(); onChanged() }} />}
        </div>
      </div>
    </div>
  )
}

function UserDetail({ detail, reload }: { detail: CommunityAdminUserDetail; reload: () => void }) {
  const profile = detail.profile
  const name = [profile.first_name, profile.last_name].filter(Boolean).join(" ") || profile.username || "Sans nom"
  return <div className="space-y-5">
    <div className="flex items-center gap-4"><Avatar index={profile.avatar_index} name={name} large /><div className="min-w-0"><h3 className="truncate text-xl font-semibold">{name}</h3><p className="text-sm text-[var(--on-surface-muted)]">{profile.username ? `@${profile.username} · ` : ""}{profile.email}</p><div className="mt-2 flex flex-wrap gap-2"><Badge tone="neutral">{pathLabel(profile.user_track, profile.user_mode)}</Badge>{["active", "trialing"].includes(detail.subscription.status ?? "") ? <Badge tone="good">{detail.subscription.plan ?? "Premium"}</Badge> : <Badge tone="neutral">Gratuit</Badge>}</div></div></div>

    <div className="grid grid-cols-2 gap-3 sm:grid-cols-5"><SmallMetric icon={FileText} value={detail.activity.posts} label="Publications" /><SmallMetric icon={MessageSquare} value={detail.activity.comments} label="Réponses" /><SmallMetric icon={Clock3} value={detail.activity.messages} label="Messages" /><SmallMetric icon={ShieldAlert} value={detail.activity.reports_received} label="Signalé" /><SmallMetric icon={AlertTriangle} value={detail.sanctions.filter((item) => item.status === "active").length} label="Sanctions" /></div>

    <SanctionForm userId={profile.user_id} onDone={reload} />

    <section><h3 className="mb-3 font-semibold">Historique des sanctions</h3>{detail.sanctions.length === 0 ? <Empty>Aucune sanction enregistrée.</Empty> : <div className="space-y-3">{detail.sanctions.map((sanction) => <SanctionCard key={sanction.id} sanction={sanction} onDone={reload} />)}</div>}</section>
  </div>
}

function SanctionForm({ userId, onDone }: { userId: string; onDone: () => void }) {
  const [kind, setKind] = useState<CommunitySanctionKind>("warning")
  const [spaceId, setSpaceId] = useState("global")
  const [reason, setReason] = useState("")
  const [endsAt, setEndsAt] = useState("")
  const [permanent, setPermanent] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<unknown>(null)
  const deadlineRequired = ["post_restriction", "comment_restriction", "message_restriction", "suspension"].includes(kind)
  const canBePermanent = kind === "ban"

  async function submit() {
    if (reason.trim().length < 10) return setError(new Error("Le motif doit contenir au moins 10 caractères."))
    if (deadlineRequired && !endsAt) return setError(new Error("Une date de fin est obligatoire pour cette restriction."))
    if (canBePermanent && !permanent && !endsAt) return setError(new Error("Choisis une date de fin ou le bannissement permanent."))
    if (!confirm(`Appliquer la sanction « ${SANCTION_LABELS[kind]} » ?`)) return
    setBusy(true); setError(null)
    try {
      await communityUsersApi.imposeSanction({ userId, kind, reason: reason.trim(), spaceId, endsAt: endsAt ? new Date(endsAt).toISOString() : null })
      setReason(""); setEndsAt(""); setPermanent(false); onDone()
    } catch (cause) { setError(cause) } finally { setBusy(false) }
  }

  return <Card className="p-4"><div className="mb-3 flex items-center gap-2"><Ban size={18} className="text-[var(--danger)]" /><h3 className="font-semibold">Appliquer une mesure</h3></div><div className="grid gap-3 sm:grid-cols-2"><Filter value={kind} onChange={(value) => { setKind(value as CommunitySanctionKind); setPermanent(false) }} label="Type de sanction" options={Object.entries(SANCTION_LABELS)} /><Filter value={spaceId} onChange={setSpaceId} label="Périmètre" options={SPACES} /></div><textarea value={reason} onChange={(event) => setReason(event.target.value)} rows={3} placeholder="Motif factuel et précis (obligatoire, journalisé)" className="mt-3 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]" />{kind !== "warning" && <div className="mt-3 flex flex-wrap items-center gap-3"><label className="text-xs text-[var(--on-surface-muted)]">Fin de la mesure<input type="datetime-local" value={endsAt} disabled={permanent} onChange={(event) => setEndsAt(event.target.value)} className="ml-2 min-h-11 rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm disabled:opacity-50" /></label>{canBePermanent && <label className="inline-flex items-center gap-2 text-sm"><input type="checkbox" checked={permanent} onChange={(event) => { setPermanent(event.target.checked); if (event.target.checked) setEndsAt("") }} className="accent-[var(--danger)]" /> Permanent</label>}</div>}{error != null && <ErrorBox error={error} />}<div className="mt-3 flex justify-end"><Button variant={kind === "ban" ? "danger" : "primary"} disabled={busy} onClick={submit}>{busy ? "Application…" : "Appliquer la mesure"}</Button></div><p className="mt-3 text-[11px] text-[var(--on-surface-faint)]">L’action est contrôlée côté base : scope, hiérarchie, auto-sanction et échéance. Elle reste traçable dans le journal d’audit.</p></Card>
}

function SanctionCard({ sanction, onDone }: { sanction: CommunitySanction; onDone: () => void }) {
  const [busy, setBusy] = useState(false)
  async function revoke() {
    const reason = prompt("Motif de levée (10 caractères minimum) :")?.trim()
    if (!reason || reason.length < 10) return
    if (!confirm("Lever cette sanction maintenant ?")) return
    setBusy(true)
    try { await communityUsersApi.revokeSanction(sanction.id, reason); onDone() } finally { setBusy(false) }
  }
  return <Card className="p-4"><div className="flex flex-wrap items-start justify-between gap-3"><div><div className="flex flex-wrap items-center gap-2"><strong className="text-sm">{SANCTION_LABELS[sanction.kind]}</strong><Badge tone={sanction.status === "active" ? "bad" : sanction.status === "appealed" ? "warn" : "neutral"}>{sanction.status}</Badge><Badge tone="neutral">{SPACES.find(([id]) => id === sanction.space_id)?.[1] ?? sanction.space_id}</Badge></div><p className="mt-2 text-sm text-[var(--on-surface-muted)]">{sanction.reason}</p><p className="mt-2 text-xs text-[var(--on-surface-faint)]">Depuis le {new Date(sanction.starts_at).toLocaleString("fr-FR")}{sanction.ends_at ? ` · fin le ${new Date(sanction.ends_at).toLocaleString("fr-FR")}` : " · sans échéance"}</p></div>{sanction.status === "active" && <Button variant="ghost" disabled={busy} onClick={revoke}>Lever</Button>}</div></Card>
}

function Filter({ value, onChange, options, label }: { value: string; onChange: (value: string) => void; options: readonly (readonly [string, string])[]; label: string }) {
  return <label className="block"><span className="sr-only">{label}</span><select aria-label={label} value={value} onChange={(event) => onChange(event.target.value)} className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-2 focus:ring-[var(--brand)]/15">{options.map(([key, text]) => <option key={key} value={key}>{text}</option>)}</select></label>
}

function Avatar({ index, name, large = false }: { index: number | null; name: string; large?: boolean }) {
  const initials = name.split(/\s+/).slice(0, 2).map((part) => part[0]?.toUpperCase()).join("") || "?"
  return <span title={index != null ? `Avatar ${index}` : undefined} className={`grid shrink-0 place-items-center rounded-full bg-[var(--brand)]/12 font-semibold text-[var(--brand)] ${large ? "h-16 w-16 text-lg" : "h-10 w-10 text-xs"}`}>{initials || <UserRound size={18} />}</span>
}

function SmallMetric({ icon: Icon, value, label }: { icon: typeof FileText; value: number; label: string }) {
  return <div className="rounded-xl bg-[var(--surface-container)] p-3"><Icon size={16} className="mb-2 text-[var(--brand)]" /><strong className="block text-lg tabular-nums">{value}</strong><span className="text-[11px] text-[var(--on-surface-muted)]">{label}</span></div>
}

function pathLabel(track: string | null, mode: string | null) {
  const trackLabel = track === "pa" ? "Policier adjoint" : track === "gpx" ? "Gardien de la paix" : "Parcours inconnu"
  const modeLabel = mode === "exam" ? "Concours" : mode === "school" ? "École" : "Mode inconnu"
  return `${modeLabel} · ${trackLabel}`
}
