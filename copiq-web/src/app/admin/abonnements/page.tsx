"use client"

import { useState } from "react"
import { createClient } from "@/lib/supabase/client"
import {
  Badge,
  Button,
  Card,
  Empty,
  ErrorBox,
  Loading,
  PageHeader,
  Stat,
  useAsync,
} from "@/components/admin/admin-ui"

type SubRow = {
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
  ["premium", "Premium actifs"],
  ["expired", "Expirés"],
  ["free", "Gratuits"],
]

export default function AbonnementsPage() {
  const [search, setSearch] = useState("")
  const [filter, setFilter] = useState("premium")
  const { data, error, loading, reload } = useAsync(
    () =>
      rpc<SubRow[]>("admin_subscriptions_overview", {
        p_search: search || null,
        p_filter: filter || null,
        p_limit: 100,
        p_offset: 0,
      }),
    [search, filter],
  )

  const actifs = (data ?? []).filter((s) => s.is_premium && !s.is_expired).length
  const expires = (data ?? []).filter((s) => s.is_expired).length

  return (
    <>
      <PageHeader
        title="Abonnements & facturation"
        subtitle="Consultation des abonnements, octroi et révocation d'accès premium"
      />

      <div className="mb-4 grid grid-cols-2 gap-3 lg:grid-cols-4">
        <Stat label="Affichés" value={data?.length ?? 0} />
        <Stat label="Premium actifs" value={actifs} tone="good" />
        <Stat label="Expirés" value={expires} tone={expires ? "warn" : "neutral"} />
        <Stat
          label="Via Stripe"
          value={(data ?? []).filter((s) => s.stripe_customer_id).length}
        />
      </div>

      <div className="mb-4 flex flex-wrap gap-2">
        <input
          placeholder="Rechercher un compte…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="min-w-52 flex-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
        />
        {FILTERS.map(([v, l]) => (
          <button
            key={v}
            onClick={() => setFilter(v)}
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
        {(data ?? []).map((s) => (
          <SubCard key={s.user_id} s={s} onChanged={reload} />
        ))}
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
    if (!confirm(`Révoquer l'accès premium de ${s.email} ?`)) return
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
    <Card className="p-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="text-sm font-medium">
            {[s.first_name, s.last_name].filter(Boolean).join(" ") ||
              s.username ||
              "—"}
          </div>
          <div className="text-xs text-[var(--on-surface-faint)]">{s.email}</div>
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

      <div className="mt-3 flex flex-wrap items-center gap-2 border-t border-[var(--outline-variant)] pt-3">
        <select
          value={plan}
          onChange={(e) => setPlan(e.target.value)}
          className="rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-2.5 py-1.5 text-xs"
        >
          <option value="premium">premium</option>
          <option value="premium_annual">premium_annual</option>
          <option value="trial">trial</option>
        </select>
        <input
          type="number"
          min={1}
          value={days}
          onChange={(e) => setDays(Number(e.target.value))}
          className="w-20 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-2.5 py-1.5 text-xs"
        />
        <span className="text-xs text-[var(--on-surface-faint)]">jours</span>
        <Button onClick={grant} disabled={busy} className="!py-1.5 !text-xs">
          Accorder
        </Button>
        <Button
          variant="ghost"
          onClick={revoke}
          disabled={busy}
          className="!py-1.5 !text-xs"
        >
          Révoquer
        </Button>
      </div>
      <ErrorBox error={err} />
    </Card>
  )
}
