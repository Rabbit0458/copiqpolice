"use client"

import { useState } from "react"
import { forumApi, type ForumReport } from "@/lib/admin/api"
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

export default function ForumPage() {
  const [tab, setTab] = useState<"reports" | "bans">("reports")

  return (
    <>
      <PageHeader
        title="Modération du forum"
        subtitle="Signalements de contenus et bannissements en cours"
      />

      <div className="mb-4 flex gap-1 border-b border-[var(--outline-variant)]">
        {(
          [
            ["reports", "Signalements"],
            ["bans", "Bannissements"],
          ] as const
        ).map(([k, l]) => (
          <button
            key={k}
            onClick={() => setTab(k)}
            className={`-mb-px border-b-2 px-3 py-2 text-sm transition ${
              tab === k
                ? "border-[var(--brand)] font-medium text-[var(--brand)]"
                : "border-transparent text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]"
            }`}
          >
            {l}
          </button>
        ))}
      </div>

      {tab === "reports" ? <Reports /> : <Bans />}
    </>
  )
}

/* ══════════════════════════════════════════════════════════════════════════ */

function Reports() {
  const [status, setStatus] = useState("open")
  const { data, error, loading, reload } = useAsync(
    () => forumApi.listReports(status),
    [status],
  )

  return (
    <>
      <div className="mb-4 flex flex-wrap gap-2">
        {[
          ["open", "À traiter"],
          ["resolved", "Traités"],
          ["", "Tous"],
        ].map(([v, l]) => (
          <button
            key={v}
            onClick={() => setStatus(v)}
            className={`rounded-lg px-3 py-2 text-sm transition ${
              status === v
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
      {data && data.length === 0 && (
        <Empty>
          {status === "open"
            ? "Aucun signalement en attente. 🎉"
            : "Aucun signalement dans cette catégorie."}
        </Empty>
      )}

      <div className="space-y-3">
        {(data ?? []).map((r) => (
          <ReportCard key={r.id} r={r} onDone={reload} />
        ))}
      </div>
    </>
  )
}

function ReportCard({ r, onDone }: { r: ForumReport; onDone: () => void }) {
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)
  const [reason, setReason] = useState("")
  const [banDays, setBanDays] = useState<string>("7")
  const open = r.status === "open"

  async function act(action: "dismiss" | "delete_post" | "delete_and_ban") {
    const labels = {
      dismiss: "Classer ce signalement sans suite ?",
      delete_post: "Supprimer ce message du forum ?",
      delete_and_ban: `Supprimer le message et bannir son auteur${
        banDays ? ` pendant ${banDays} jours` : " définitivement"
      } ?`,
    }
    if (!confirm(labels[action])) return
    setBusy(true)
    setErr(null)
    try {
      await forumApi.resolveReport(
        r.id,
        action,
        reason || undefined,
        action === "delete_and_ban" && banDays ? Number(banDays) : null,
      )
      onDone()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="p-4">
      <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
        <div className="flex flex-wrap items-center gap-1.5">
          <Badge tone={open ? "warn" : "good"}>
            {open ? "à traiter" : "traité"}
          </Badge>
          {r.nb_signalements > 1 && (
            <Badge tone="bad">{r.nb_signalements} signalements</Badge>
          )}
          {r.post_supprime && <Badge tone="bad">message supprimé</Badge>}
          {r.auteur_banni && <Badge tone="bad">auteur banni</Badge>}
        </div>
        <span className="text-xs text-[var(--on-surface-faint)]">
          {new Date(r.created_at).toLocaleString("fr-FR")}
        </span>
      </div>

      {r.reason && (
        <p className="mb-2 text-sm">
          <span className="text-xs uppercase tracking-wide text-[var(--on-surface-faint)]">
            Motif ·{" "}
          </span>
          {r.reason}
        </p>
      )}

      {(r.post_title || r.post_content) && (
        <div className="mb-2 rounded-lg bg-[var(--surface-container)] p-3">
          {r.post_title && (
            <div className="mb-1 text-sm font-semibold">{r.post_title}</div>
          )}
          <div className="whitespace-pre-wrap text-sm">
            {r.post_content ?? "— contenu indisponible —"}
          </div>
        </div>
      )}

      <p className="text-xs text-[var(--on-surface-faint)]">
        Auteur : {r.post_author_email ?? "inconnu"} · Signalé par&nbsp;
        {r.reporter_email ?? "inconnu"}
      </p>

      {open && (
        <div className="mt-3 space-y-2 border-t border-[var(--outline-variant)] pt-3">
          <input
            value={reason}
            onChange={(e) => setReason(e.target.value)}
            placeholder="Motif de la décision (journalisé)…"
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
          />
          <ErrorBox error={err} />
          <div className="flex flex-wrap items-center gap-2">
            <Button
              variant="ghost"
              onClick={() => act("dismiss")}
              disabled={busy}
              className="!py-1.5 !text-xs"
            >
              Classer sans suite
            </Button>
            <Button
              onClick={() => act("delete_post")}
              disabled={busy}
              className="!py-1.5 !text-xs"
            >
              Supprimer le message
            </Button>
            <span className="ml-auto flex items-center gap-1.5">
              <input
                type="number"
                min={0}
                value={banDays}
                onChange={(e) => setBanDays(e.target.value)}
                placeholder="jours"
                className="w-16 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-2 py-1.5 text-xs"
              />
              <span className="text-xs text-[var(--on-surface-faint)]">
                j. (vide = définitif)
              </span>
              <Button
                variant="danger"
                onClick={() => act("delete_and_ban")}
                disabled={busy}
                className="!py-1.5 !text-xs"
              >
                Supprimer &amp; bannir
              </Button>
            </span>
          </div>
          <p className="text-[11px] text-[var(--on-surface-faint)]">
            La suppression est réversible côté base : le message est masqué mais
            conservé, ce qui permet de répondre à une contestation ou à une
            réquisition judiciaire.
          </p>
        </div>
      )}
    </Card>
  )
}

/* ══════════════════════════════════════════════════════════════════════════ */

function Bans() {
  const { data, error, loading, reload } = useAsync(() => forumApi.listBans(), [])
  const [busy, setBusy] = useState<string | null>(null)

  async function unban(userId: string, email: string | null) {
    if (!confirm(`Lever le bannissement de ${email ?? userId} ?`)) return
    setBusy(userId)
    try {
      await forumApi.unban(userId, "Levée depuis le panel admin")
      reload()
    } finally {
      setBusy(null)
    }
  }

  if (loading) return <Loading />
  if (error) return <ErrorBox error={error} />
  if (!data || data.length === 0)
    return <Empty>Aucun bannissement en cours.</Empty>

  return (
    <Card className="divide-y divide-[var(--outline-variant)]">
      {data.map((b) => (
        <div
          key={b.user_id}
          className="flex flex-wrap items-center gap-3 p-4"
        >
          <div className="min-w-0 flex-1">
            <div className="text-sm font-medium">{b.email ?? b.user_id}</div>
            <div className="text-xs text-[var(--on-surface-muted)]">
              {b.reason ?? "sans motif"} · depuis le{" "}
              {new Date(b.created_at).toLocaleDateString("fr-FR")}
            </div>
          </div>
          <Badge tone={b.expires_at ? "warn" : "bad"}>
            {b.expires_at
              ? `jusqu'au ${new Date(b.expires_at).toLocaleDateString("fr-FR")}`
              : "définitif"}
          </Badge>
          <Button
            variant="ghost"
            onClick={() => unban(b.user_id, b.email)}
            disabled={busy === b.user_id}
            className="!py-1.5 !text-xs"
          >
            Lever
          </Button>
        </div>
      ))}
    </Card>
  )
}
