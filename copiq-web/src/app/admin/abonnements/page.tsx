"use client"

import { useState } from "react"
import { RefreshCw } from "lucide-react"
import { createClient } from "@/lib/supabase/client"
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

type SubRow = {
  manual_active: boolean
  sources: { source: string; environment: string; plan: string; product_id?: string; status: string; expires_at: string | null; verified_at: string | null; cancel_at_period_end: boolean; grants_access: boolean }[]
  user_id: string
  email: string | null
  first_name: string | null
  last_name: string | null
  username: string | null
  plan: string | null
  status: string | null
  current_period_start: string | null
  current_period_end: string | null
  is_premium: boolean
  is_expired: boolean
  is_free: boolean
  stripe_customer_id: string | null
  created_at: string | null
}

async function rpc<T>(fn: string, args: Record<string, unknown> = {}) {
  const { data, error } = await createClient().rpc(fn as never, args as never)
  if (error) throw new Error(error.message)
  return data as T
}

const FILTERS: [string, string][] = [
  ["", "Tous"],
  ["paid", "Premium actifs"],
  ["expired", "Expirés"],
  ["free", "Gratuits"],
]

export default function AbonnementsPage() {
  const [search, setSearch] = useState("")
  const [filter, setFilter] = useState("")
  const [page, setPage] = useState(0)
  const { data, error, loading, reload } = useAsync(
    () =>
      rpc<SubRow[]>("admin_subscription_sources", {
        p_search: search || null,
        p_filter: filter || null,
        p_limit: 100,
        p_offset: page * 100,
      }).then(rows => rows.map(s => ({ ...s, is_free: !s.is_premium,
        is_expired: !s.is_premium && s.sources.some(source => ["expired", "revoked", "canceled", "cancelled"].includes(source.status)),
        stripe_customer_id: s.sources.some(x => x.source === "STRIPE") ? "Stripe" : null,
        plan: s.is_premium ? "Premium" : "Gratuit",
      }))),
    [search, filter, page],
  )

  return (
    <>
      <PageHeader
        title="Abonnements & facturation"
        action={<Button onClick={reload} disabled={loading}><RefreshCw size={16} /> Actualiser</Button>}
      />

      <div className="mb-4 flex flex-wrap gap-2">
        <input
          placeholder="Rechercher un compte…"
          value={search}
          onChange={(e) => { setSearch(e.target.value); setPage(0) }}
          className="min-w-52 flex-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
        />
        {FILTERS.map(([v, l]) => (
          <button
            key={v}
            onClick={() => { setFilter(v); setPage(0) }}
            className={`rounded-lg px-3 py-2 text-sm transition ${
              filter === v
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
      {data && data.length === 0 && <Empty>Aucun abonnement dans ce filtre.</Empty>}

      <div className="space-y-2">
        {!loading && !error && (data ?? []).map((s) => (
          <SubCard key={s.user_id} s={s} onChanged={reload} />
        ))}
      </div>
      <div className="mt-4 flex items-center justify-between gap-3">
        <Button variant="ghost" disabled={loading || page === 0} onClick={() => setPage(p => p - 1)}>Précédent</Button>
        <span className="text-sm">Page {page + 1}</span>
        <Button variant="ghost" disabled={loading || !!error || (data?.length ?? 0) < 100} onClick={() => setPage(p => p + 1)}>Suivant</Button>
      </div>
    </>
  )
}

function SubCard({ s, onChanged }: { s: SubRow; onChanged: () => void }) {
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)
  const [days, setDays] = useState(30)
  const [plan, setPlan] = useState("premium")

  async function grant() {
    if (!Number.isInteger(days) || days < 1 || days > 3660) {
      setErr(new Error("La durée doit être comprise entre 1 et 3660 jours.")); return
    }
    if (!confirm(`Accorder ${days} jours de « ${plan} » à ${s.email} ?`)) return
    setBusy(true)
    setErr(null)
    try {
      await rpc("admin_grant_access", {
        p_user_id: s.user_id,
        p_plan: plan,
        p_duration_days: days,
      })
      onChanged()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  async function revoke() {
    if (!confirm(`Retirer l'accès offert à ${s.email} ? Les achats Apple et Google seront conservés.`)) return
    setBusy(true)
    setErr(null)
    try {
      await rpc("admin_revoke_access", { p_user_id: s.user_id })
      onChanged()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="!rounded-lg p-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="text-sm font-medium">
            {[s.first_name, s.last_name].filter(Boolean).join(" ") ||
              s.username ||
              "—"}
          </div>
          <div className="break-all text-xs text-[var(--on-surface-faint)]">{s.email}</div>
          {s.current_period_end && (
            <div className="mt-1 text-[11px] text-[var(--on-surface-muted)]">
              Période jusqu&apos;au{" "}
              {new Date(s.current_period_end).toLocaleDateString("fr-FR")}
            </div>
          )}
        </div>
        <div className="flex shrink-0 flex-wrap items-center gap-1.5">
          {s.is_expired ? (
            <Badge tone="bad">expiré</Badge>
          ) : s.is_premium ? (
            <Badge tone="good">{s.plan ?? "premium"}</Badge>
          ) : (
            <Badge>gratuit</Badge>
          )}
          {s.stripe_customer_id && <Badge tone="brand">Stripe</Badge>}
        </div>
      </div>

      <div className="mt-3 divide-y divide-[var(--outline-variant)]">
        {s.sources.map((source, index) => <div key={index} className="grid gap-2 py-3 text-sm sm:grid-cols-2">
          <div className="min-w-0">
            <strong>{{ APP_STORE: "Apple App Store", PLAY_STORE: "Google Play", STRIPE: "Stripe", MANUAL: "Accès offert" }[source.source] ?? source.source}</strong>{" "}
            <Badge tone={source.environment === "SANDBOX" ? "warn" : "neutral"}>{source.environment === "SANDBOX" ? "Test Sandbox" : "Production"}</Badge>
            <div className="mt-1 break-all text-xs text-[var(--on-surface-muted)]">{source.product_id ?? source.plan}</div>
          </div>
          <div>
            <div>{source.status === "revoked" ? "Révoqué" : source.status === "expired" ? "Expiré" : source.cancel_at_period_end ? "Renouvellement arrêté" : source.status === "active" ? "Actif" : source.status}{source.environment === "SANDBOX" && !source.grants_access ? " · sans droit Premium" : ""}</div>
            <div>Échéance : {source.expires_at ? new Date(source.expires_at).toLocaleString("fr-FR") : "—"}</div>
            <div className="text-xs text-[var(--on-surface-muted)]">Dernière vérification : {source.verified_at ? new Date(source.verified_at).toLocaleString("fr-FR") : "—"}</div>
          </div>
        </div>)}
      </div>
      {!s.stripe_customer_id && <div className="mt-3 flex flex-wrap items-center gap-2 border-t border-[var(--outline-variant)] pt-3">
        <select
          value={plan}
          onChange={(e) => setPlan(e.target.value)}
          className="rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-2.5 py-1.5 text-xs"
        >
          <option value="premium">Accès offert</option>
          <option value="trial">Essai offert</option>
        </select>
        <input
          type="number"
          min={1}
          max={3660}
          aria-label="Durée du cadeau en jours"
          value={days}
          onChange={(e) => setDays(Number(e.target.value))}
          className="w-20 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-2.5 py-1.5 text-xs"
        />
        <span className="text-xs text-[var(--on-surface-faint)]">jours</span>
        <Button onClick={grant} disabled={busy} className="!py-1.5 !text-xs">
          Offrir
        </Button>
        <Button
          variant="ghost"
          onClick={revoke}
          disabled={busy || !s.manual_active}
          className="!py-1.5 !text-xs"
        >
          Retirer le cadeau
        </Button>
      </div>}
      <ErrorBox error={err} />
    </Card>
  )
}
