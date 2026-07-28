"use client"

import { useState } from "react"
import { casPratiqueApi, type CpAppeal } from "@/lib/admin/api"
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

const FILTERS: [string, string][] = [
  ["pending", "En attente"],
  ["approved", "Validés"],
  ["rejected", "Rejetés"],
  ["", "Tous"],
]

export default function AppealsPage() {
  const [status, setStatus] = useState("pending")
  const { data, error, loading, reload } = useAsync(
    () => casPratiqueApi.listAppeals(status),
    [status],
  )

  return (
    <>
      <PageHeader
        title="Appels des élèves"
        subtitle="Contestations « ma réponse était correcte ». Valider un appel enrichit définitivement la grille de correction."
      />

      <div className="mb-4 flex flex-wrap gap-2">
        {FILTERS.map(([v, l]) => (
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
          {status === "pending"
            ? "Aucun appel en attente. 🎉"
            : "Aucun appel dans cette catégorie."}
        </Empty>
      )}

      <div className="space-y-3">
        {(data ?? []).map((a) => (
          <AppealCard key={a.id} a={a} onDone={reload} />
        ))}
      </div>
    </>
  )
}

function AppealCard({ a, onDone }: { a: CpAppeal; onDone: () => void }) {
  const [response, setResponse] = useState("")
  const [keywords, setKeywords] = useState("")
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)
  const pending = a.status === "pending"

  async function resolve(status: "approved" | "rejected") {
    setBusy(true)
    setErr(null)
    try {
      const kws =
        status === "approved"
          ? keywords
              .split(/[,\n;]/)
              .map((s) => s.trim())
              .filter((s) => s.length > 1)
          : undefined
      await casPratiqueApi.resolveAppeal(a.id, status, response || undefined, kws)
      onDone()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="p-4">
      <div className="mb-3 flex flex-wrap items-center justify-between gap-2">
        <div className="min-w-0">
          <div className="text-sm font-medium">{a.case_title ?? "Cas supprimé"}</div>
          <div className="text-xs text-[var(--on-surface-faint)]">
            {a.user_email ?? "utilisateur inconnu"} ·{" "}
            {new Date(a.created_at).toLocaleString("fr-FR")}
          </div>
        </div>
        <Badge
          tone={
            a.status === "approved" ? "good" : a.status === "rejected" ? "bad" : "warn"
          }
        >
          {a.status === "approved"
            ? "validé"
            : a.status === "rejected"
              ? "rejeté"
              : "en attente"}
        </Badge>
      </div>

      <dl className="mb-3 space-y-2 text-sm">
        {a.question_label && (
          <Row label="Question">{a.question_label}</Row>
        )}
        {a.point_label && (
          <Row label="Point contesté">
            <span className="rounded bg-[var(--surface-container-hi)] px-1.5 py-0.5">
              {a.point_label}
            </span>
          </Row>
        )}
        {a.user_answer && (
          <Row label="Réponse de l'élève">
            <span className="block whitespace-pre-wrap rounded-lg bg-[var(--surface-container)] p-2 text-xs leading-relaxed">
              {a.user_answer}
            </span>
          </Row>
        )}
        {a.message && <Row label="Argument">{a.message}</Row>}
        {a.admin_response && <Row label="Ta réponse">{a.admin_response}</Row>}
      </dl>

      {pending && (
        <div className="space-y-2 border-t border-[var(--outline-variant)] pt-3">
          <textarea
            value={response}
            onChange={(e) => setResponse(e.target.value)}
            rows={2}
            placeholder="Réponse à l'élève (visible dans l'application)…"
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] p-2.5 text-sm outline-none focus:border-[var(--brand)]"
          />
          <input
            value={keywords}
            onChange={(e) => setKeywords(e.target.value)}
            placeholder="Mots-clés à ajouter à la grille si tu valides (séparés par des virgules)"
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] p-2.5 text-sm outline-none focus:border-[var(--brand)]"
          />
          <p className="text-xs text-[var(--on-surface-faint)]">
            Les mots-clés ajoutés sont marqués « ajout automatique » et seront reconnus
            par le moteur pour toutes les corrections suivantes.
          </p>
          <ErrorBox error={err} />
          <div className="flex gap-2">
            <Button onClick={() => resolve("approved")} disabled={busy}>
              Valider l&apos;appel
            </Button>
            <Button variant="ghost" onClick={() => resolve("rejected")} disabled={busy}>
              Rejeter
            </Button>
          </div>
        </div>
      )}
    </Card>
  )
}

function Row({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="grid gap-1 sm:grid-cols-[150px_1fr]">
      <dt className="text-xs font-medium uppercase tracking-wide text-[var(--on-surface-faint)]">
        {label}
      </dt>
      <dd className="text-[var(--on-surface-muted)]">{children}</dd>
    </div>
  )
}
