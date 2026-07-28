"use client"

import { useState } from "react"
import { supportApi } from "@/lib/admin/api"
import {
  Badge,
  Card,
  Empty,
  ErrorBox,
  Loading,
  PageHeader,
  useAsync,
} from "@/components/admin/admin-ui"

type UserRow = {
  user_id: string
  email: string | null
  username: string | null
  first_name: string | null
  last_name: string | null
  user_role: string | null
  user_track: string | null
  plan: string | null
  status: string | null
  current_period_end: string | null
  free_used: number | null
  last_seen: string | null
  created_at: string | null
}

export default function UtilisateursPage() {
  const [search, setSearch] = useState("")
  const { data, error, loading } = useAsync(
    () => supportApi.users(search) as Promise<UserRow[]>,
    [search],
  )

  return (
    <>
      <PageHeader
        title="Utilisateurs"
        subtitle="Consultation des comptes, abonnements et activité"
      />

      <input
        placeholder="Rechercher par e-mail, nom, pseudo…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="mb-4 w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
      />

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data && data.length === 0 && <Empty>Aucun utilisateur trouvé.</Empty>}

      {data && data.length > 0 && (
        <Card className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="border-b border-[var(--outline-variant)] text-left text-xs uppercase tracking-wide text-[var(--on-surface-faint)]">
              <tr>
                <th className="px-4 py-3 font-medium">Compte</th>
                <th className="px-3 py-3 font-medium">Parcours</th>
                <th className="px-3 py-3 font-medium">Abonnement</th>
                <th className="px-3 py-3 font-medium">Dernière visite</th>
                <th className="px-4 py-3 font-medium">Inscription</th>
              </tr>
            </thead>
            <tbody>
              {data.map((u) => (
                <tr
                  key={u.user_id}
                  className="border-b border-[var(--outline-variant)] last:border-0 hover:bg-[var(--surface-container)]/50"
                >
                  <td className="px-4 py-3">
                    <div className="font-medium">
                      {[u.first_name, u.last_name].filter(Boolean).join(" ") ||
                        u.username ||
                        "—"}
                    </div>
                    <div className="text-xs text-[var(--on-surface-faint)]">{u.email}</div>
                  </td>
                  <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
                    {u.user_track ?? "—"}
                    {u.user_role ? ` · ${u.user_role}` : ""}
                  </td>
                  <td className="px-3 py-3">
                    {u.status === "active" ? (
                      <Badge tone="good">{u.plan ?? "premium"}</Badge>
                    ) : (
                      <Badge>gratuit</Badge>
                    )}
                    {u.current_period_end && (
                      <div className="mt-0.5 text-[11px] text-[var(--on-surface-faint)]">
                        jusqu&apos;au{" "}
                        {new Date(u.current_period_end).toLocaleDateString("fr-FR")}
                      </div>
                    )}
                  </td>
                  <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
                    {u.last_seen ? new Date(u.last_seen).toLocaleDateString("fr-FR") : "—"}
                  </td>
                  <td className="px-4 py-3 text-xs text-[var(--on-surface-muted)]">
                    {u.created_at
                      ? new Date(u.created_at).toLocaleDateString("fr-FR")
                      : "—"}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </Card>
      )}
    </>
  )
}
