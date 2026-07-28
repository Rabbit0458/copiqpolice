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

type LogRow = {
  id: number
  created_at: string
  actor_email: string | null
  actor_role: string | null
  action: string
  severity: string | null
  success: boolean
  target_table: string | null
  target_id: string | null
  old_value: unknown
  new_value: unknown
  comment: string | null
}

const TONE: Record<string, "neutral" | "good" | "warn" | "bad"> = {
  info: "neutral",
  warning: "warn",
  critical: "bad",
}

export default function JournalPage() {
  const [severity, setSeverity] = useState("")
  const { data, error, loading } = useAsync(
    () => supportApi.auditLogs(undefined, severity) as Promise<LogRow[]>,
    [severity],
  )

  return (
    <>
      <PageHeader
        title="Journal d'audit"
        subtitle="Toute action d'administration est enregistrée de façon immuable"
      />

      <div className="mb-4 flex flex-wrap gap-2">
        {[
          ["", "Tout"],
          ["info", "Info"],
          ["warning", "Avertissement"],
          ["critical", "Critique"],
        ].map(([v, l]) => (
          <button
            key={v}
            onClick={() => setSeverity(v)}
            className={`rounded-lg px-3 py-2 text-sm transition ${
              severity === v
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
      {data && data.length === 0 && <Empty>Aucune entrée.</Empty>}

      <div className="space-y-2">
        {(data ?? []).map((l) => (
          <Card key={l.id} className="p-3">
            <div className="flex flex-wrap items-center gap-2">
              <Badge tone={TONE[l.severity ?? "info"] ?? "neutral"}>
                {l.severity ?? "info"}
              </Badge>
              <code className="text-xs font-medium">{l.action}</code>
              {!l.success && <Badge tone="bad">échec</Badge>}
              <span className="ml-auto text-xs text-[var(--on-surface-faint)]">
                {new Date(l.created_at).toLocaleString("fr-FR")}
              </span>
            </div>
            <div className="mt-1 text-xs text-[var(--on-surface-muted)]">
              {l.actor_email ?? "système"}
              {l.actor_role ? ` (${l.actor_role})` : ""}
              {l.target_table ? ` → ${l.target_table}` : ""}
              {l.target_id ? ` #${l.target_id}` : ""}
            </div>
            {l.comment && (
              <div className="mt-1 text-xs text-[var(--on-surface-muted)]">{l.comment}</div>
            )}
            {(l.old_value || l.new_value) && (
              <details className="mt-1.5">
                <summary className="cursor-pointer text-[11px] text-[var(--on-surface-faint)]">
                  Voir le détail
                </summary>
                <pre className="mt-1 max-h-52 overflow-auto rounded-lg bg-[var(--surface-container)] p-2 text-[10px] leading-relaxed">
                  {JSON.stringify({ avant: l.old_value, apres: l.new_value }, null, 2)}
                </pre>
              </details>
            )}
          </Card>
        ))}
      </div>
    </>
  )
}
