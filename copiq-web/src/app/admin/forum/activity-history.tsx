"use client"

import { useMemo, useState } from "react"
import {
  Ban, ChevronLeft, ChevronRight, FileText, GraduationCap, Heart,
  MessageCircle, Search, ShieldAlert, Trash2, UserRoundCog,
  type LucideIcon,
} from "lucide-react"
import {
  communityForumApi,
  type CommunityActivityEvent,
  type CommunityActivityType,
} from "@/lib/admin/api"
import { Badge, Button, Card, Empty, ErrorBox, Loading, useAsync } from "@/components/admin/admin-ui"

const SPACES = [
  ["", "Vue globale"],
  ["pa_exam", "PA · Concours"],
  ["gpx_exam", "GPX · Concours"],
  ["pa_school", "PA · École"],
  ["gpx_school", "GPX · École"],
] as const

const EVENTS: readonly [CommunityActivityType | "", string][] = [
  ["", "Toute l’activité"], ["post", "Publications"], ["comment", "Réponses"],
  ["like", "Likes"], ["deletion", "Suppressions"], ["report", "Signalements"],
  ["moderation", "Modération"], ["sanction", "Sanctions"],
]

const EVENT_META: Record<CommunityActivityType, { label: string; icon: LucideIcon; tone: "brand" | "neutral" | "warn" | "bad" | "good" }> = {
  post: { label: "Publication", icon: FileText, tone: "brand" },
  comment: { label: "Réponse", icon: MessageCircle, tone: "neutral" },
  like: { label: "Like", icon: Heart, tone: "good" },
  deletion: { label: "Suppression", icon: Trash2, tone: "bad" },
  report: { label: "Signalement", icon: ShieldAlert, tone: "warn" },
  moderation: { label: "Modération", icon: UserRoundCog, tone: "brand" },
  sanction: { label: "Sanction", icon: Ban, tone: "bad" },
}

export function ActivityHistory() {
  const [spaceId, setSpaceId] = useState("")
  const [eventType, setEventType] = useState<CommunityActivityType | "">("")
  const [search, setSearch] = useState("")
  const [page, setPage] = useState(0)
  const limit = 40
  const filters = useMemo(() => ({ spaceId: spaceId || undefined, eventType: eventType || undefined, search: search.trim() || undefined, limit, offset: page * limit }), [spaceId, eventType, search, page])
  const summary = useAsync(() => communityForumApi.spaceSummary(), [])
  const feed = useAsync(() => communityForumApi.activityFeed(filters), [filters])
  const total = feed.data?.[0]?.total_count ?? 0

  function selectSpace(value: string) { setSpaceId(value); setPage(0) }

  return (
    <div className="space-y-6">
      <div className="grid gap-3 md:grid-cols-2 2xl:grid-cols-4">
        {(summary.data ?? []).map((space) => (
          <button key={space.space_id} onClick={() => selectSpace(space.space_id)} className={`group cursor-pointer rounded-2xl border p-5 text-left transition duration-200 hover:-translate-y-1 ${spaceId === space.space_id ? "border-[var(--brand)] bg-[var(--brand)]/8 shadow-[0_18px_45px_rgba(17,71,217,.14)]" : "border-[var(--outline-variant)] bg-[var(--surface)] hover:border-[var(--brand)]/40"}`}>
            <div className="flex items-start justify-between gap-3"><span className="grid h-11 w-11 place-items-center rounded-xl" style={{ backgroundColor: `${space.color_hex}20`, color: space.color_hex }}><GraduationCap size={20} /></span><span className="text-[11px] text-[var(--on-surface-faint)]">{space.last_activity_at ? new Date(space.last_activity_at).toLocaleDateString("fr-FR") : "Aucune activité"}</span></div>
            <h3 className="mt-4 font-semibold">{space.space_label}</h3>
            <div className="mt-3 grid grid-cols-3 gap-2 text-center"><Mini value={space.posts} label="posts" /><Mini value={space.comments} label="réponses" /><Mini value={space.likes} label="likes" /></div>
            <div className="mt-3 flex gap-2"><Badge tone={space.removed ? "bad" : "neutral"}>{space.removed} supprimé(s)</Badge><Badge tone={space.reports ? "warn" : "neutral"}>{space.reports} signalement(s)</Badge></div>
          </button>
        ))}
      </div>
      {summary.loading && <Loading label="Chargement des quatre espaces…" />}
      {summary.error != null && <ErrorBox error={summary.error} />}

      <Card className="p-4 md:p-5">
        <div className="flex flex-wrap gap-2" role="tablist" aria-label="Espaces du forum">
          {SPACES.map(([id, label]) => <button key={id} role="tab" aria-selected={spaceId === id} onClick={() => selectSpace(id)} className={`min-h-11 cursor-pointer rounded-xl px-4 text-sm font-medium transition ${spaceId === id ? "bg-[var(--brand)] text-white shadow-[0_8px_24px_rgba(17,71,217,.2)]" : "bg-[var(--surface-container)] text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]"}`}>{label}</button>)}
        </div>
        <div className="mt-4 grid gap-3 lg:grid-cols-[minmax(260px,1fr)_240px]">
          <label className="relative"><span className="sr-only">Rechercher dans l’historique</span><Search size={17} className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]" /><input value={search} onChange={(e) => { setSearch(e.target.value); setPage(0) }} placeholder="Rechercher un membre, un titre ou un contenu…" className="w-full border border-[var(--outline)] bg-[var(--surface)] pl-10 pr-3 text-sm" /></label>
          <select aria-label="Type d’activité" value={eventType} onChange={(e) => { setEventType(e.target.value as CommunityActivityType | ""); setPage(0) }} className="w-full border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm">{EVENTS.map(([id, label]) => <option key={id} value={id}>{label}</option>)}</select>
        </div>
      </Card>

      {feed.error != null && <ErrorBox error={feed.error} />}
      {feed.loading && <Loading label="Lecture de l’historique Supabase…" />}
      {!feed.loading && feed.data?.length === 0 && <Empty>Aucune activité ne correspond à ces filtres.</Empty>}
      <div className="relative space-y-3 before:absolute before:bottom-4 before:left-[23px] before:top-4 before:w-px before:bg-[var(--outline-variant)]">
        {(feed.data ?? []).map((event) => <ActivityRow key={event.event_id} event={event} />)}
      </div>
      {total > limit && <div className="flex items-center justify-between"><span className="text-sm text-[var(--on-surface-muted)]">{page * limit + 1}–{Math.min((page + 1) * limit, total)} sur {total} événements</span><div className="flex gap-2"><Button variant="ghost" disabled={!page} onClick={() => setPage((p) => Math.max(0, p - 1))}><ChevronLeft size={16} /> Précédent</Button><Button variant="ghost" disabled={(page + 1) * limit >= total} onClick={() => setPage((p) => p + 1)}>Suivant <ChevronRight size={16} /></Button></div></div>}
    </div>
  )
}

function Mini({ value, label }: { value: number; label: string }) { return <span className="rounded-xl bg-[var(--surface-container)] px-2 py-2"><strong className="block text-lg tabular-nums">{value}</strong><small className="text-[10px] uppercase tracking-wide text-[var(--on-surface-faint)]">{label}</small></span> }

function ActivityRow({ event }: { event: CommunityActivityEvent }) {
  const meta = EVENT_META[event.event_type]
  const Icon = meta.icon
  return <Card className="relative ml-12 overflow-hidden p-4 md:p-5"><span className="absolute -left-[42px] top-4 z-[1] grid h-9 w-9 place-items-center rounded-full border-4 border-[var(--surface-container)] bg-[var(--brand)] text-white"><Icon size={15} /></span><div className="flex flex-wrap items-start justify-between gap-3"><div className="flex flex-wrap items-center gap-2"><Badge tone={meta.tone}>{meta.label}</Badge><Badge tone="neutral">{event.space_label}</Badge>{event.status && <Badge tone={event.status === "removed" ? "bad" : "neutral"}>{event.status}</Badge>}</div><time className="text-xs text-[var(--on-surface-faint)]">{new Date(event.event_at).toLocaleString("fr-FR")}</time></div><h3 className="mt-3 text-sm font-semibold">{event.title || `${meta.label} sur ${event.target_type}`}</h3>{event.content && <p className="mt-2 line-clamp-3 whitespace-pre-wrap text-sm leading-6 text-[var(--on-surface-muted)]">{event.content}</p>}<div className="mt-3 flex flex-wrap items-center gap-x-3 gap-y-1 border-t border-[var(--outline-variant)] pt-3 text-xs text-[var(--on-surface-faint)]"><span>{event.actor_name}</span>{event.actor_email && <span>{event.actor_email}</span>}<code className="ml-auto">{event.target_type} · {event.target_id.slice(0, 12)}</code></div></Card>
}
