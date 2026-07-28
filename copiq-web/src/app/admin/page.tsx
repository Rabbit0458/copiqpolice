"use client"

import Link from "next/link"
import { casPratiqueApi } from "@/lib/admin/api"
import {
  Card,
  ErrorBox,
  Loading,
  PageHeader,
  Stat,
  useAsync,
  Badge,
} from "@/components/admin/admin-ui"

export default function AdminHome() {
  const { data, error, loading } = useAsync(() => casPratiqueApi.dashboard(), [])
  const health = useAsync(() => casPratiqueApi.health(), [])

  const critiques = (health.data ?? []).filter((h) => h.gravite === "critique").length
  const importants = (health.data ?? []).filter((h) => h.gravite === "important").length

  return (
    <>
      <PageHeader
        title="Vue d'ensemble"
        subtitle="Préparation Gardien de la Paix — module Cas Pratique"
      />

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}

      {data && (
        <>
          <div className="grid grid-cols-2 gap-3 lg:grid-cols-4">
            <Stat
              label="Cas publiés"
              value={data.cases_published}
              hint={`sur ${data.cases_total} au total`}
            />
            <Stat label="Questions" value={data.questions} hint="toutes épreuves" />
            <Stat
              label="Points de correction"
              value={data.rubric_points}
              hint={`${data.keywords} mots-clés`}
            />
            <Stat
              label="Appels en attente"
              value={data.appeals_pending}
              tone={data.appeals_pending > 0 ? "warn" : "good"}
              hint={`${data.appeals_total} au total`}
            />
          </div>

          <div className="mt-3 grid grid-cols-2 gap-3 lg:grid-cols-4">
            <Stat
              label="Tentatives"
              value={data.attempts_total}
              hint={`${data.attempts_done} terminées`}
            />
            <Stat
              label="Score moyen"
              value={data.avg_percent != null ? `${data.avg_percent} %` : "—"}
              hint="sur les copies corrigées"
            />
            <Stat
              label="Cas sans grille"
              value={data.cases_sans_rubric}
              tone={data.cases_sans_rubric > 0 ? "bad" : "good"}
              hint="publiés mais non corrigeables"
            />
            <Stat
              label="Sans réponse modèle"
              value={data.questions_sans_modele}
              tone={data.questions_sans_modele > 0 ? "warn" : "good"}
              hint="questions concernées"
            />
          </div>

          <div className="mt-5 grid gap-4 lg:grid-cols-3">
            <Card className="p-5 lg:col-span-2">
              <h2 className="text-sm font-semibold">État du contenu</h2>
              {health.loading && <Loading label="Analyse…" />}
              {!health.loading && critiques === 0 && importants === 0 && (
                <p className="mt-3 flex items-center gap-2 text-sm text-[var(--success)]">
                  <span>✓</span>
                  Aucune anomalie détectée. Tous les cas publiés ont une grille de
                  correction, des mots-clés et une réponse modèle.
                </p>
              )}
              {!health.loading && (critiques > 0 || importants > 0) && (
                <div className="mt-3 space-y-2 text-sm">
                  {critiques > 0 && (
                    <div className="flex items-center gap-2">
                      <Badge tone="bad">{critiques} critique(s)</Badge>
                      <span className="text-[var(--on-surface-muted)]">
                        cas publiés inutilisables par les élèves
                      </span>
                    </div>
                  )}
                  {importants > 0 && (
                    <div className="flex items-center gap-2">
                      <Badge tone="warn">{importants} à corriger</Badge>
                      <span className="text-[var(--on-surface-muted)]">
                        contenu incomplet
                      </span>
                    </div>
                  )}
                  <Link
                    href="/admin/sante/"
                    className="inline-block pt-1 text-sm font-medium text-[var(--brand)] hover:underline"
                  >
                    Voir le détail →
                  </Link>
                </div>
              )}
            </Card>

            <Card className="p-5">
              <h2 className="text-sm font-semibold">Raccourcis</h2>
              <div className="mt-3 space-y-1.5 text-sm">
                <Link
                  href="/admin/cas-pratiques/"
                  className="block rounded-lg px-2 py-1.5 text-[var(--brand)] hover:bg-[var(--surface-container)]"
                >
                  Gérer les cas pratiques →
                </Link>
                <Link
                  href="/admin/appels/"
                  className="block rounded-lg px-2 py-1.5 text-[var(--brand)] hover:bg-[var(--surface-container)]"
                >
                  Traiter les appels d&apos;élèves →
                </Link>
                <Link
                  href="/admin/signalements/"
                  className="block rounded-lg px-2 py-1.5 text-[var(--brand)] hover:bg-[var(--surface-container)]"
                >
                  Support &amp; signalements →
                </Link>
              </div>
            </Card>
          </div>
        </>
      )}
    </>
  )
}
