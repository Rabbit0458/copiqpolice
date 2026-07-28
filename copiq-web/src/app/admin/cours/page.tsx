"use client"

import { Suspense, useState } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import { coursApi, type CoursRow } from "@/lib/admin/api"
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

export default function Page() {
  return (
    <Suspense fallback={<Loading />}>
      <CoursScreen />
    </Suspense>
  )
}

function CoursScreen() {
  const params = useSearchParams()
  const route = params.get("route")
  return route ? <CoursEditor route={route} /> : <CoursList />
}

function CoursList() {
  const router = useRouter()
  const [search, setSearch] = useState("")
  const [track, setTrack] = useState("")
  const { data, error, loading } = useAsync(
    () => coursApi.list({ search, track }),
    [search, track],
  )

  const grouped = (data ?? []).reduce<Record<string, CoursRow[]>>((acc, c) => {
    const key = `${c.track} · ${c.module}${c.section ? ` · ${c.section}` : ""}`
    ;(acc[key] ??= []).push(c)
    return acc
  }, {})

  return (
    <>
      <PageHeader
        title="Fiches de cours"
        subtitle="Contenu pédagogique stocké en base : modifiable en direct, sans republier l'application."
      />

      <div className="mb-4 flex flex-wrap gap-2">
        <input
          placeholder="Rechercher une fiche…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="min-w-52 flex-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
        />
        {[
          ["", "Tous"],
          ["gpx", "GPX"],
          ["pa", "PA"],
        ].map(([v, l]) => (
          <button
            key={v}
            onClick={() => setTrack(v)}
            className={`rounded-lg px-3 py-2 text-sm transition ${
              track === v
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
      {data && data.length === 0 && <Empty>Aucune fiche.</Empty>}

      {(Object.entries(grouped) as [string, CoursRow[]][]).map(([group, rows]) => (
        <div key={group} className="mb-5">
          <h2 className="mb-2 text-xs font-semibold uppercase tracking-wide text-[var(--on-surface-faint)]">
            {group}
          </h2>
          <Card className="divide-y divide-[var(--outline-variant)]">
            {rows.map((c) => (
              <button
                key={c.id}
                onClick={() =>
                  router.push(`/admin/cours/?route=${encodeURIComponent(c.route)}`)
                }
                className="flex w-full items-center gap-3 p-3.5 text-left hover:bg-[var(--surface-container)]/50"
              >
                {c.code && (
                  <span className="shrink-0 rounded-md bg-[var(--brand)]/10 px-2 py-1 text-[11px] font-bold text-[var(--brand)]">
                    {c.code}
                  </span>
                )}
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-sm font-medium">
                    {c.title}
                  </span>
                  <span className="block truncate text-[11px] text-[var(--on-surface-faint)]">
                    {c.route}
                  </span>
                </span>
                <span className="flex shrink-0 items-center gap-1.5">
                  {!c.is_published && <Badge tone="warn">brouillon</Badge>}
                  {c.quiz_module && <Badge tone="brand">quiz</Badge>}
                  <span className="text-[11px] tabular-nums text-[var(--on-surface-faint)]">
                    {(c.taille / 1000).toFixed(1)} k
                  </span>
                </span>
              </button>
            ))}
          </Card>
        </div>
      ))}
    </>
  )
}

function CoursEditor({ route }: { route: string }) {
  const router = useRouter()
  const { data, error, loading, reload } = useAsync(
    () => coursApi.get(route),
    [route],
  )

  if (loading) return <Loading />
  if (error) return <ErrorBox error={error} />
  if (!data || data.error) return <Empty>{String(data?.error ?? "Introuvable")}</Empty>

  return (
    <>
      <button
        onClick={() => router.push("/admin/cours/")}
        className="mb-3 text-sm text-[var(--on-surface-muted)] hover:text-[var(--brand)]"
      >
        ← Retour aux fiches
      </button>
      <EditorForm data={data} onSaved={reload} />
    </>
  )
}

function EditorForm({
  data,
  onSaved,
}: {
  data: Record<string, unknown>
  onSaved: () => void
}) {
  const d = data as Record<string, string | boolean | string[] | null>
  const [f, setF] = useState({
    title: String(d.title ?? ""),
    subtitle: String(d.subtitle ?? ""),
    code: String(d.code ?? ""),
    body_md: String(d.body_md ?? ""),
    key_points: (Array.isArray(d.key_points) ? d.key_points : []).join("\n"),
    legal_refs: (Array.isArray(d.legal_refs) ? d.legal_refs : []).join("\n"),
    color_hex: String(d.color_hex ?? "#1147D9"),
    is_published: Boolean(d.is_published),
  })
  const [busy, setBusy] = useState(false)
  const [ok, setOk] = useState(false)
  const [err, setErr] = useState<unknown>(null)
  const [preview, setPreview] = useState(false)

  async function save() {
    setBusy(true)
    setErr(null)
    setOk(false)
    try {
      await coursApi.upsert({
        route: d.route,
        title: f.title,
        subtitle: f.subtitle || null,
        code: f.code || null,
        body_md: f.body_md,
        key_points: f.key_points.split("\n").map((s) => s.trim()).filter(Boolean),
        legal_refs: f.legal_refs.split("\n").map((s) => s.trim()).filter(Boolean),
        color_hex: f.color_hex,
        is_published: f.is_published,
      })
      setOk(true)
      onSaved()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  return (
    <>
      <PageHeader title={f.title || "Fiche"} subtitle={String(d.route)} />

      <div className="grid gap-4 lg:grid-cols-2">
        <Card className="p-5">
          <div className="grid gap-3 sm:grid-cols-2">
            <L label="Code">
              <input
                value={f.code}
                onChange={(e) => setF({ ...f, code: e.target.value })}
                className={ic}
              />
            </L>
            <L label="Couleur (hex)">
              <input
                value={f.color_hex}
                onChange={(e) => setF({ ...f, color_hex: e.target.value })}
                className={ic}
              />
            </L>
          </div>
          <div className="mt-3">
            <L label="Titre">
              <input
                value={f.title}
                onChange={(e) => setF({ ...f, title: e.target.value })}
                className={ic}
              />
            </L>
          </div>
          <div className="mt-3">
            <L label="Sous-titre">
              <input
                value={f.subtitle}
                onChange={(e) => setF({ ...f, subtitle: e.target.value })}
                className={ic}
              />
            </L>
          </div>
          <div className="mt-3">
            <L label="Points « à retenir » (un par ligne)">
              <textarea
                value={f.key_points}
                onChange={(e) => setF({ ...f, key_points: e.target.value })}
                rows={4}
                className={`${ic} text-xs`}
              />
            </L>
          </div>
          <div className="mt-3">
            <L label="Références légales (une par ligne)">
              <textarea
                value={f.legal_refs}
                onChange={(e) => setF({ ...f, legal_refs: e.target.value })}
                rows={3}
                className={`${ic} text-xs`}
              />
            </L>
          </div>
          <label className="mt-3 flex items-center gap-2 text-sm">
            <input
              type="checkbox"
              checked={f.is_published}
              onChange={(e) => setF({ ...f, is_published: e.target.checked })}
              className="h-4 w-4"
            />
            Publiée (visible dans l&apos;application)
          </label>

          <ErrorBox error={err} />
          <div className="mt-4 flex items-center gap-3">
            <Button onClick={save} disabled={busy}>
              {busy ? "Enregistrement…" : "Enregistrer"}
            </Button>
            {ok && <span className="text-sm text-[var(--success)]">✓ Enregistré</span>}
          </div>
        </Card>

        <Card className="p-5">
          <div className="mb-2 flex items-center justify-between">
            <h3 className="text-sm font-semibold">Contenu (Markdown)</h3>
            <button
              onClick={() => setPreview((v) => !v)}
              className="text-xs text-[var(--brand)] hover:underline"
            >
              {preview ? "Éditer" : "Aperçu"}
            </button>
          </div>
          {preview ? (
            <div className="max-h-[70vh] overflow-auto whitespace-pre-wrap rounded-lg bg-[var(--surface-container)] p-3 text-sm leading-relaxed">
              {f.body_md}
            </div>
          ) : (
            <textarea
              value={f.body_md}
              onChange={(e) => setF({ ...f, body_md: e.target.value })}
              rows={30}
              spellCheck={false}
              className={`${ic} font-mono text-[11px] leading-relaxed`}
            />
          )}
          <p className="mt-2 text-xs text-[var(--on-surface-faint)]">
            Markdown supporté par l&apos;application : titres <code>#</code> à{" "}
            <code>####</code>, listes, tableaux <code>|</code>, citations{" "}
            <code>&gt;</code>, séparateurs <code>---</code>, <code>**gras**</code>,{" "}
            <code>*italique*</code>, <code>`code`</code>.
          </p>
        </Card>
      </div>
    </>
  )
}

const ic =
  "w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"

function L({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
        {label}
      </span>
      {children}
    </label>
  )
}
