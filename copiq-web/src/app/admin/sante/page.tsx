"use client"

import Link from "next/link"
import { casPratiqueApi } from "@/lib/admin/api"
import {
  Badge,
  Card,
  Empty,
  ErrorBox,
  Loading,
  PageHeader,
  useAsync,
} from "@/components/admin/admin-ui"

const TONE = {
  critique: "bad",
  important: "warn",
  mineur: "neutral",
} as const

export default function SantePage() {
  const { data, error, loading } = useAsync(() => casPratiqueApi.health(), [])

  const groups = (data ?? []).reduce<Record<string, typeof data>>((acc, r) => {
    ;(acc[r.gravite] ??= []).push(r)
    return acc
  }, {})

  return (
    <>
      <PageHeader
        title="Santé du contenu"
        subtitle="Détection automatique des cas pratiques inutilisables ou incomplets"
      />

      {error && <ErrorBox error={error} />}
      {loading && <Loading label="Analyse du contenu…" />}

      {data && data.length === 0 && (
        <Card className="p-8 text-center">
          <div className="text-3xl">✓</div>
          <p className="mt-2 text-sm font-medium text-[var(--success)]">
            Aucune anomalie détectée
          </p>
          <p className="mt-1 text-sm text-[var(--on-surface-muted)]">
            Chaque cas publié possède ses questions, sa grille de correction, ses
            mots-clés et ses réponses modèles.
          </p>
        </Card>
      )}

      {(["critique", "important", "mineur"] as const).map((g) =>
        groups[g]?.length ? (
          <Card key={g} className="mb-4 overflow-hidden">
            <div className="flex items-center gap-2 border-b border-[var(--outline-variant)] px-4 py-3">
              <Badge tone={TONE[g]}>{g}</Badge>
              <span className="text-sm text-[var(--on-surface-muted)]">
                {groups[g]!.length} élément(s)
              </span>
            </div>
            <table className="w-full text-sm">
              <tbody>
                {groups[g]!.map((r, i) => (
                  <tr
                    key={i}
                    className="border-b border-[var(--outline-variant)] last:border-0"
                  >
                    <td className="px-4 py-2.5 font-mono text-xs">{r.objet}</td>
                    <td className="px-3 py-2.5">{r.probleme}</td>
                    <td className="px-4 py-2.5 text-xs text-[var(--on-surface-muted)]">
                      {r.action}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </Card>
        ) : null,
      )}

      {data && data.length > 0 && (
        <Empty>
          <Link
            href="/admin/cas-pratiques/"
            className="font-medium text-[var(--brand)] hover:underline"
          >
            Aller corriger les cas concernés →
          </Link>
        </Empty>
      )}
    </>
  )
}
