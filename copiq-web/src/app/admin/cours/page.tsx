"use client"

import { Suspense, useCallback, useState } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import { contentLifecycleApi, coursApi, type CoursRow } from "@/lib/admin/api"
import { ContentLifecycleControl } from "@/components/admin/content-lifecycle-control"
import { lifecycleError, lifecycleLabels, publicationStatusOf, toIsoDateTime, toLocalDateTime, type PublicationStatus } from "@/lib/admin/content-lifecycle"
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
import { CourseContentPreview } from "@/components/admin/content-preview"
import { EditorialReadiness } from "@/components/admin/editorial-readiness"
import { MediaReadiness } from "@/components/admin/media-readiness"
import { blockingIssues, validateCourse, validateCourseMedia } from "@/lib/admin/content-validation"
import type { EditorialIssue } from "@/lib/admin/content-validation"

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
  const params = useSearchParams()
  const status = params.get("status")
  const quality = params.get("quality")
  const [search, setSearch] = useState("")
  const [track, setTrack] = useState("")
  const { data, error, loading } = useAsync(
    () => coursApi.list({ search, track }),
    [search, track],
  )

  const visibleRows = (data ?? []).filter((row) => status !== "draft" || publicationStatusOf(row) === "draft")
  const grouped = visibleRows.reduce<Record<string, CoursRow[]>>((acc, c) => {
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

      {status === "draft" && (
        <div className="mb-4 flex flex-wrap items-center justify-between gap-2 rounded-xl border border-[var(--warning)]/25 bg-[var(--warning)]/[.07] px-3.5 py-3 text-xs">
          <span><strong>File de contrôle :</strong> seules les fiches en brouillon sont affichées.</span>
          <button type="button" onClick={() => router.push("/admin/cours/")} className="min-h-9 cursor-pointer rounded-lg px-2.5 font-semibold text-[var(--brand)] hover:bg-[var(--brand)]/10">Voir toutes les fiches</button>
        </div>
      )}
      {quality === "media" && (
        <div className="mb-4 flex flex-wrap items-center justify-between gap-2 rounded-xl border border-[var(--brand)]/20 bg-[var(--brand)]/[.06] px-3.5 py-3 text-xs">
          <span><strong>Contrôle des médias :</strong> ouvre une fiche pour vérifier automatiquement descriptions, formats et disponibilité.</span>
          <button type="button" onClick={() => router.push("/admin/cours/")} className="min-h-9 cursor-pointer rounded-lg px-2.5 font-semibold text-[var(--brand)] hover:bg-[var(--brand)]/10">Quitter la file</button>
        </div>
      )}

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data && visibleRows.length === 0 && <Empty>Aucune fiche dans cette sélection.</Empty>}

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
                  <Badge tone={publicationStatusOf(c) === "published" ? "good" : publicationStatusOf(c) === "archived" ? "bad" : publicationStatusOf(c) === "scheduled" ? "brand" : "warn"}>{lifecycleLabels[publicationStatusOf(c)]}</Badge>
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
  const initialStatus = publicationStatusOf({ publication_status: String(d.publication_status ?? ""), is_published: Boolean(d.is_published) })
  const [f, setF] = useState({
    title: String(d.title ?? ""),
    subtitle: String(d.subtitle ?? ""),
    code: String(d.code ?? ""),
    body_md: String(d.body_md ?? ""),
    key_points: (Array.isArray(d.key_points) ? d.key_points : []).join("\n"),
    legal_refs: (Array.isArray(d.legal_refs) ? d.legal_refs : []).join("\n"),
    color_hex: String(d.color_hex ?? "#1147D9"),
    publication_status: initialStatus as PublicationStatus,
    scheduled_at: toLocalDateTime(String(d.scheduled_at ?? "")),
  })
  const [busy, setBusy] = useState(false)
  const [ok, setOk] = useState(false)
  const [err, setErr] = useState<unknown>(null)
  const [mediaState, setMediaState] = useState<{ checking: boolean; issues: EditorialIssue[] }>({ checking: false, issues: [] })
  const keyPoints = f.key_points.split("\n").map((item) => item.trim()).filter(Boolean)
  const legalRefs = f.legal_refs.split("\n").map((item) => item.trim()).filter(Boolean)
  const staticMediaIssues = validateCourseMedia(f.body_md)
  const networkMediaIssues = mediaState.issues.filter((issue) => issue.code.startsWith("course-media-unavailable-"))
  const editorialIssues = [...validateCourse({
    title: f.title,
    subtitle: f.subtitle,
    body: f.body_md,
    keyPoints,
    legalRefs,
    color: f.color_hex,
  }), ...staticMediaIssues, ...networkMediaIssues]
  const blockers = blockingIssues(editorialIssues)
  const onMediaChange = useCallback((state: { checking: boolean; issues: EditorialIssue[] }) => setMediaState(state), [])

  async function save() {
    setBusy(true)
    setErr(null)
    setOk(false)
    const goingLive = f.publication_status === "published" || f.publication_status === "scheduled"
    const scheduleIssue = lifecycleError(f.publication_status, f.scheduled_at)
    if (scheduleIssue) { setErr(new Error(scheduleIssue)); setBusy(false); return }
    if (goingLive && (mediaState.checking || blockers.length > 0)) {
      if (mediaState.checking) {
        setErr(new Error("Publication impossible tant que la vérification des médias n’est pas terminée."))
        setBusy(false)
        return
      }
      setErr(new Error(`Publication impossible : ${blockers.map((issue) => issue.label.toLocaleLowerCase("fr-FR")).join(", ")}.`))
      setBusy(false)
      return
    }
    try {
      await coursApi.upsert({
        route: d.route,
        title: f.title,
        subtitle: f.subtitle || null,
        code: f.code || null,
        body_md: f.body_md,
        key_points: keyPoints,
        legal_refs: legalRefs,
        color_hex: f.color_hex,
        is_published: f.publication_status === "published",
      })
      await contentLifecycleApi.set("course", String(d.route), f.publication_status, toIsoDateTime(f.scheduled_at))
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
          <div className="mt-4">
            <EditorialReadiness issues={editorialIssues} />
            <MediaReadiness markdown={f.body_md} onChange={onMediaChange} />
          </div>
          <div className="mt-4"><ContentLifecycleControl status={f.publication_status} scheduledAt={f.scheduled_at} onStatusChange={(value) => setF({ ...f, publication_status: value })} onScheduledAtChange={(value) => setF({ ...f, scheduled_at: value })} onRestore={initialStatus === "archived" ? async () => { setBusy(true); try { await contentLifecycleApi.set("course", String(d.route), "restore"); onSaved() } catch (e) { setErr(e) } finally { setBusy(false) } } : undefined} /></div>

          <ErrorBox error={err} />
          <div className="mt-4 flex flex-wrap items-center gap-3">
            <Button onClick={save} disabled={busy || ((f.publication_status === "published" || f.publication_status === "scheduled") && (mediaState.checking || blockers.length > 0))}>
              {busy ? "Enregistrement…" : "Enregistrer"}
            </Button>
            {(f.publication_status === "published" || f.publication_status === "scheduled") && (mediaState.checking || blockers.length > 0) && <span className="text-xs text-[var(--danger)]">{mediaState.checking ? "Contrôle des médias en cours…" : "Repasse en brouillon ou corrige les erreurs."}</span>}
            {ok && <span className="text-sm text-[var(--success)]">✓ Enregistré</span>}
          </div>
        </Card>

        <Card className="p-5">
          <div className="mb-2 flex items-center justify-between">
            <h3 className="text-sm font-semibold">Contenu (Markdown)</h3>
            <a href="#apercu" className="text-xs font-medium text-[var(--brand)] hover:underline">
              Voir le rendu
            </a>
          </div>
          <textarea
            value={f.body_md}
            onChange={(e) => setF({ ...f, body_md: e.target.value })}
            rows={30}
            spellCheck={false}
            className={`${ic} font-mono text-[11px] leading-relaxed`}
          />
          <p className="mt-2 text-xs text-[var(--on-surface-faint)]">
            Markdown supporté par l&apos;application : titres <code>#</code> à{" "}
            <code>####</code>, listes, tableaux <code>|</code>, citations{" "}
            <code>&gt;</code>, séparateurs <code>---</code>, <code>**gras**</code>,{" "}
            <code>*italique*</code>, <code>`code`</code>.
            Images : <code>![Description accessible](https://…/image.webp)</code>.
          </p>
        </Card>
      </div>

      <div className="mt-5">
        <CourseContentPreview
          title={f.title}
          subtitle={f.subtitle}
          code={f.code}
          body={f.body_md}
          keyPoints={keyPoints}
          legalRefs={legalRefs}
          color={f.color_hex}
        />
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
