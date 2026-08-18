"use client"

import { Suspense, useCallback, useMemo, useState } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import { ArrowDown, ArrowUp, Columns3, FilePlus2, Link2, Plus, Save, Trash2, Unlink } from "lucide-react"
import { contentLifecycleApi, coursApi, scolariteContentApi, type CoursRow, type ScolariteEditorData, type ScolariteFragment } from "@/lib/admin/api"
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
  return params.get("new") === "1" ? <NewCoursEditor /> : route ? <CoursEditor route={route} /> : <CoursList />
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

      <div className="mb-4 flex justify-end">
        <Button onClick={() => router.push("/admin/cours/?new=1")}>
          <FilePlus2 className="h-4 w-4" aria-hidden="true" />
          Nouveau cours
        </Button>
      </div>

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

function NewCoursEditor() {
  const router = useRouter()
  const models = useAsync(() => coursApi.list(), [])
  const [modelRoute, setModelRoute] = useState("")
  const [model, setModel] = useState<Record<string, unknown> | null>(null)
  const [modelBusy, setModelBusy] = useState(false)
  const [modelError, setModelError] = useState<unknown>(null)

  async function loadModel() {
    if (!modelRoute) return
    setModelBusy(true)
    setModelError(null)
    try {
      setModel(await coursApi.get(modelRoute))
    } catch (error) {
      setModelError(error)
    } finally {
      setModelBusy(false)
    }
  }

  const initial = model ? {
    ...model,
    id: undefined,
    route: `${String(model.track ?? "gpx") === "pa" ? "/pa" : "/gpx"}/scolarite/nouveau-cours`,
    title: `Copie de ${String(model.title ?? "cours")}`,
    source_path: null,
    source_hash: null,
    parent_route: modelRoute,
    publication_status: "draft",
    is_published: false,
  } : {
    route: "/gpx/scolarite/nouveau-cours",
    track: "gpx",
    module: "nouveau_module",
    section: "",
    title: "Nouveau cours",
    subtitle: "",
    code: "",
    body_md: "",
    content_blocks: [],
    key_points: [],
    legal_refs: [],
    color_hex: "#1147D9",
    parent_route: "",
    publication_status: "draft",
    is_published: false,
  }

  return (
    <>
      <button onClick={() => router.push("/admin/cours/")} className="mb-3 min-h-11 cursor-pointer text-sm text-[var(--on-surface-muted)] hover:text-[var(--brand)]">
        ← Retour aux fiches
      </button>
      <Card className="mb-5 p-4">
        <div className="flex flex-wrap items-end gap-3">
          <L label="Modèle visuel à copier">
            <select value={modelRoute} onChange={(event) => setModelRoute(event.target.value)} className={`${ic} min-w-72`}>
              <option value="">Cours vierge</option>
              {(models.data ?? []).map((row) => <option key={row.route} value={row.route}>{row.track.toUpperCase()} · {row.title}</option>)}
            </select>
          </L>
          <Button onClick={loadModel} disabled={!modelRoute || modelBusy}>{modelBusy ? "Copie…" : "Utiliser ce modèle"}</Button>
          <p className="max-w-xl text-xs leading-relaxed text-[var(--on-surface-muted)]">Le nouveau cours reprend la structure, les blocs et la présentation du modèle. Tu remplaces ensuite librement tous ses textes.</p>
        </div>
        <ErrorBox error={models.error ?? modelError} />
      </Card>
      <EditorForm
        key={modelRoute || "blank"}
        isNew
        data={initial}
        onSaved={() => router.push("/admin/cours/")}
      />
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
      {typeof data.source_path === "string" && data.source_path ? (
        <ExactCourseEditor course={data} sourcePath={data.source_path} />
      ) : (
        <EditorForm data={data} onSaved={reload} />
      )}
    </>
  )
}

function ExactCourseEditor({ course, sourcePath }: { course: Record<string, unknown>; sourcePath: string }) {
  const editor = useAsync(() => scolariteContentApi.editor(sourcePath), [sourcePath])
  const linkedPath = editor.data?.link?.link_status === "linked" ? editor.data.linked_source_path : null
  const linked = useAsync(
    () => linkedPath ? scolariteContentApi.editor(linkedPath) : Promise.resolve(null),
    [linkedPath],
  )
  const [drafts, setDrafts] = useState<Record<string, string>>({})
  const [busyKey, setBusyKey] = useState<string | null>(null)
  const [confirmed, setConfirmed] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [saveError, setSaveError] = useState<unknown>(null)

  if (editor.loading) return <Loading />
  if (editor.error) return <ErrorBox error={editor.error} />
  if (!editor.data) return <Empty>Contenu exact introuvable.</Empty>

  const data = editor.data
  const panels = groupFragments(data.fragments)
  const isLinked = data.link?.link_status === "linked" && Boolean(linkedPath)

  async function save(fragment: ScolariteFragment) {
    if (isLinked && !confirmed) {
      setSaveError(new Error("Compare les deux aperçus puis coche la confirmation avant d’enregistrer."))
      return
    }
    setBusyKey(fragment.fragment_key)
    setSaveError(null)
    setMessage(null)
    try {
      await scolariteContentApi.updateFragment(
        sourcePath,
        fragment.fragment_key,
        drafts[fragment.fragment_key] ?? fragment.text_value,
        isLinked,
      )
      setMessage(isLinked ? "Texte enregistré sur les versions GPX et PA." : "Texte enregistré.")
      await Promise.all([editor.reload(), linked.reload()])
    } catch (error) {
      setSaveError(error)
    } finally {
      setBusyKey(null)
    }
  }

  async function separateVersions() {
    if (!window.confirm("Séparer définitivement les versions GPX et PA ? Les futures modifications ne seront plus recopiées automatiquement.")) return
    setSaveError(null)
    try {
      await scolariteContentApi.separate(sourcePath)
      setConfirmed(false)
      await editor.reload()
      setMessage("Les versions GPX et PA sont maintenant indépendantes.")
    } catch (error) {
      setSaveError(error)
    }
  }

  return (
    <>
      <PageHeader
        title={String(course.title ?? "Cours")}
        subtitle="Chaque caractère est modifiable sans changer le design de l’application."
      />

      <div className={`mb-5 rounded-2xl border p-4 ${isLinked ? "border-[var(--brand)]/30 bg-[var(--brand)]/[.05]" : "border-[var(--outline)] bg-[var(--surface)]"}`}>
        <div className="flex flex-wrap items-start gap-3">
          <div className="grid min-h-11 min-w-11 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]">
            {isLinked ? <Link2 className="h-5 w-5" aria-hidden="true" /> : <Unlink className="h-5 w-5" aria-hidden="true" />}
          </div>
          <div className="min-w-0 flex-1">
            <h2 className="font-semibold">{isLinked ? "Cours commun GPX + PA" : `Version ${data.track.toUpperCase()} indépendante`}</h2>
            <p className="mt-1 break-all text-xs text-[var(--on-surface-muted)]">{sourcePath}</p>
            {isLinked && <p className="mt-1 break-all text-xs text-[var(--on-surface-muted)]">{linkedPath}</p>}
          </div>
          {isLinked && <Button variant="ghost" onClick={separateVersions}><Unlink className="h-4 w-4" />Séparer les versions</Button>}
        </div>
        {isLinked && (
          <label className="mt-4 flex min-h-11 cursor-pointer items-center gap-3 rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm">
            <input type="checkbox" checked={confirmed} onChange={(event) => setConfirmed(event.target.checked)} className="h-5 w-5 accent-[var(--brand)]" />
            J’ai comparé les deux aperçus et je confirme l’application de la modification aux versions GPX et PA.
          </label>
        )}
      </div>

      <ErrorBox error={saveError} />
      {message && <div className="mb-4 rounded-xl border border-[var(--success)]/25 bg-[var(--success)]/[.08] px-4 py-3 text-sm text-[var(--success)]">{message}</div>}

      {isLinked && <LinkedPreviews primary={data} secondary={linked.data} secondaryLoading={linked.loading} />}

      <div className="space-y-4">
        {Object.entries(panels).map(([panel, fragments]) => (
          <Card key={panel} className="overflow-hidden">
            <div className="border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/60 px-4 py-3">
              <h2 className="text-sm font-bold">{panel}</h2>
              <p className="mt-0.5 text-[11px] text-[var(--on-surface-faint)]">{fragments.length} zone{fragments.length > 1 ? "s" : ""} de texte</p>
            </div>
            <div className="divide-y divide-[var(--outline-variant)]">
              {fragments.map((fragment) => {
                const value = drafts[fragment.fragment_key] ?? fragment.text_value
                const changed = value !== fragment.text_value
                return (
                  <div key={fragment.fragment_key} className="p-4">
                    <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
                      <span className="text-[11px] font-semibold uppercase tracking-wide text-[var(--on-surface-faint)]">Texte {fragment.position}</span>
                      <span className="text-[11px] text-[var(--on-surface-faint)]">Révision {fragment.revision}</span>
                    </div>
                    <textarea
                      aria-label={`${panel}, texte ${fragment.position}`}
                      value={value}
                      disabled={!fragment.is_editable}
                      onChange={(event) => setDrafts((current) => ({ ...current, [fragment.fragment_key]: event.target.value }))}
                      rows={Math.min(14, Math.max(2, value.split("\n").length + Math.ceil(value.length / 95)))}
                      className={`${ic} min-h-24 resize-y leading-relaxed`}
                    />
                    <div className="mt-2 flex min-h-11 flex-wrap items-center justify-between gap-2">
                      <span className="text-[11px] text-[var(--on-surface-faint)]">{value.length.toLocaleString("fr-FR")} caractères</span>
                      <Button onClick={() => save(fragment)} disabled={!changed || busyKey === fragment.fragment_key || (isLinked && !confirmed)}>
                        <Save className="h-4 w-4" aria-hidden="true" />
                        {busyKey === fragment.fragment_key ? "Enregistrement…" : "Enregistrer ce texte"}
                      </Button>
                    </div>
                  </div>
                )
              })}
            </div>
          </Card>
        ))}
      </div>
    </>
  )
}

function groupFragments(fragments: ScolariteFragment[]) {
  return fragments.reduce<Record<string, ScolariteFragment[]>>((groups, fragment) => {
    ;(groups[fragment.panel || "Informations générales"] ??= []).push(fragment)
    return groups
  }, {})
}

function LinkedPreviews({ primary, secondary, secondaryLoading }: { primary: ScolariteEditorData; secondary: ScolariteEditorData | null | undefined; secondaryLoading: boolean }) {
  return (
    <Card className="mb-5 overflow-hidden">
      <div className="flex items-center gap-2 border-b border-[var(--outline-variant)] px-4 py-3">
        <Columns3 className="h-4 w-4 text-[var(--brand)]" aria-hidden="true" />
        <h2 className="text-sm font-semibold">Aperçu comparatif obligatoire</h2>
      </div>
      <div className="grid gap-px bg-[var(--outline-variant)] lg:grid-cols-2">
        <FragmentPreview title={primary.track.toUpperCase()} data={primary} />
        {secondaryLoading ? <div className="bg-[var(--surface)] p-6"><Loading /></div> : secondary ? <FragmentPreview title={secondary.track.toUpperCase()} data={secondary} /> : <div className="bg-[var(--surface)] p-6 text-sm">Aperçu lié indisponible.</div>}
      </div>
    </Card>
  )
}

function FragmentPreview({ title, data }: { title: string; data: ScolariteEditorData }) {
  return (
    <div className="max-h-[34rem] overflow-auto bg-[var(--surface)] p-4">
      <div className="sticky top-0 z-10 mb-3 flex items-center justify-between rounded-lg bg-[var(--surface)] py-2">
        <Badge tone="brand">{title}</Badge>
        <span className="text-[11px] text-[var(--on-surface-faint)]">{data.fragments.length} textes</span>
      </div>
      {Object.entries(groupFragments(data.fragments)).map(([panel, fragments]) => (
        <section key={panel} className="mb-3 rounded-xl border border-[var(--outline-variant)] p-3">
          <h3 className="mb-2 text-sm font-bold">{panel}</h3>
          <div className="space-y-2 text-xs leading-relaxed text-[var(--on-surface-muted)]">
            {fragments.map((fragment) => <p key={fragment.fragment_key} className="whitespace-pre-wrap">{fragment.text_value}</p>)}
          </div>
        </section>
      ))}
    </div>
  )
}

function EditorForm({
  data,
  onSaved,
  isNew = false,
}: {
  data: Record<string, unknown>
  onSaved: () => void
  isNew?: boolean
}) {
  const d = data
  const initialStatus = publicationStatusOf({ publication_status: String(d.publication_status ?? ""), is_published: Boolean(d.is_published) })
  const [f, setF] = useState({
    route: String(d.route ?? ""),
    track: String(d.track ?? "gpx"),
    module: String(d.module ?? ""),
    section: String(d.section ?? ""),
    title: String(d.title ?? ""),
    subtitle: String(d.subtitle ?? ""),
    code: String(d.code ?? ""),
    body_md: String(d.body_md ?? ""),
    key_points: (Array.isArray(d.key_points) ? d.key_points : []).join("\n"),
    legal_refs: (Array.isArray(d.legal_refs) ? d.legal_refs : []).join("\n"),
    color_hex: String(d.color_hex ?? "#1147D9"),
    publication_status: initialStatus as PublicationStatus,
    scheduled_at: toLocalDateTime(String(d.scheduled_at ?? "")),
    parent_route: String(d.parent_route ?? ""),
  })
  const initialBlocks = useMemo(() => normalizeBlocks(d.content_blocks, String(d.body_md ?? "")), [d.content_blocks, d.body_md])
  const [blocks, setBlocks] = useState<CourseBlock[]>(initialBlocks)
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
        route: f.route,
        track: f.track,
        module: f.module,
        section: f.section || null,
        title: f.title,
        subtitle: f.subtitle || null,
        code: f.code || null,
        body_md: f.body_md,
        content_blocks: blocks,
        key_points: keyPoints,
        legal_refs: legalRefs,
        color_hex: f.color_hex,
        parent_route: f.parent_route || null,
        is_published: f.publication_status === "published",
      })
      await contentLifecycleApi.set("course", f.route, f.publication_status, toIsoDateTime(f.scheduled_at))
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
      <PageHeader title={f.title || "Fiche"} subtitle={f.route} />

      <div className="grid gap-4 lg:grid-cols-2">
        <Card className="p-5">
          <div className="mb-3 grid gap-3 sm:grid-cols-2">
            <L label="Filière">
              <select value={f.track} onChange={(e) => setF({ ...f, track: e.target.value })} className={ic}>
                <option value="gpx">GPX</option><option value="pa">PA</option>
              </select>
            </L>
            <L label="Module">
              <input value={f.module} onChange={(e) => setF({ ...f, module: e.target.value })} className={ic} required />
            </L>
          </div>
          <div className="mb-3 grid gap-3 sm:grid-cols-2">
            <L label="Route dans l’application">
              <input value={f.route} onChange={(e) => setF({ ...f, route: e.target.value })} className={ic} disabled={!isNew} required />
            </L>
            <L label="Section">
              <input value={f.section} onChange={(e) => setF({ ...f, section: e.target.value })} className={ic} />
            </L>
          </div>
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

        <BlockEditor
          markdown={f.body_md}
          blocks={blocks}
          onMarkdownChange={(body_md) => setF({ ...f, body_md })}
          onBlocksChange={(next) => { setBlocks(next); setF({ ...f, body_md: blocksToMarkdown(next) }) }}
        />
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

type CourseBlock = {
  type: "heading" | "paragraph" | "quote" | "list"
  text: string
  level?: number
}

function normalizeBlocks(value: unknown, markdown: string): CourseBlock[] {
  if (Array.isArray(value)) {
    const valid = value.flatMap((item) => {
      if (!item || typeof item !== "object") return []
      const raw = item as Record<string, unknown>
      const type = String(raw.type ?? "paragraph") as CourseBlock["type"]
      if (!["heading", "paragraph", "quote", "list"].includes(type)) return []
      return [{ type, text: String(raw.text ?? ""), level: Number(raw.level ?? 2) }]
    })
    if (valid.length > 0) return valid
  }
  return markdownToBlocks(markdown)
}

function markdownToBlocks(markdown: string): CourseBlock[] {
  return markdown
    .split(/\n{2,}/)
    .map((part) => part.trim())
    .filter(Boolean)
    .map((part) => {
      const heading = /^(#{1,4})\s+([\s\S]+)$/.exec(part)
      if (heading) return { type: "heading", level: heading[1].length, text: heading[2] }
      if (part.startsWith("> ")) return { type: "quote", text: part.replace(/^>\s?/gm, "") }
      if (/^(?:[-*]\s+)/m.test(part)) return { type: "list", text: part.replace(/^(?:[-*]\s+)/gm, "") }
      return { type: "paragraph", text: part }
    })
}

function blocksToMarkdown(blocks: CourseBlock[]) {
  return blocks.map((block) => {
    if (block.type === "heading") return `${"#".repeat(Math.min(4, Math.max(1, block.level ?? 2)))} ${block.text}`
    if (block.type === "quote") return block.text.split("\n").map((line) => `> ${line}`).join("\n")
    if (block.type === "list") return block.text.split("\n").filter(Boolean).map((line) => `- ${line.replace(/^[-*]\s*/, "")}`).join("\n")
    return block.text
  }).join("\n\n")
}

function BlockEditor({
  markdown,
  blocks,
  onMarkdownChange,
  onBlocksChange,
}: {
  markdown: string
  blocks: CourseBlock[]
  onMarkdownChange: (value: string) => void
  onBlocksChange: (value: CourseBlock[]) => void
}) {
  const [mode, setMode] = useState<"visual" | "markdown">("visual")
  const update = (index: number, patch: Partial<CourseBlock>) =>
    onBlocksChange(blocks.map((block, i) => i === index ? { ...block, ...patch } : block))
  const move = (index: number, direction: -1 | 1) => {
    const target = index + direction
    if (target < 0 || target >= blocks.length) return
    const next = [...blocks]
    ;[next[index], next[target]] = [next[target], next[index]]
    onBlocksChange(next)
  }

  return (
    <Card className="p-5">
      <div className="mb-3 flex flex-wrap items-center justify-between gap-2">
        <h3 className="text-sm font-semibold">Contenu du cours</h3>
        <div className="flex rounded-xl bg-[var(--surface-container)] p-1" role="tablist" aria-label="Mode d’édition">
          {(["visual", "markdown"] as const).map((value) => (
            <button key={value} type="button" role="tab" aria-selected={mode === value} onClick={() => {
              if (value === "visual") onBlocksChange(markdownToBlocks(markdown))
              setMode(value)
            }} className={`min-h-11 cursor-pointer rounded-lg px-3 text-xs font-semibold transition ${mode === value ? "bg-[var(--surface)] text-[var(--brand)] shadow-sm" : "text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]"}`}>
              {value === "visual" ? "Éditeur visuel" : "Markdown"}
            </button>
          ))}
        </div>
      </div>

      {mode === "markdown" ? (
        <>
          <textarea value={markdown} onChange={(e) => onMarkdownChange(e.target.value)} rows={30} spellCheck={false} className={`${ic} font-mono text-[11px] leading-relaxed`} />
          <p className="mt-2 text-xs text-[var(--on-surface-faint)]">Titres, listes, tableaux, citations, séparateurs, gras, italique, code et images Markdown sont pris en charge.</p>
        </>
      ) : (
        <div className="space-y-3">
          {blocks.map((block, index) => (
            <div key={index} className="rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/40 p-3">
              <div className="mb-2 flex flex-wrap items-center gap-2">
                <select aria-label={`Type du bloc ${index + 1}`} value={block.type} onChange={(e) => update(index, { type: e.target.value as CourseBlock["type"] })} className={`${ic} min-h-11 w-auto`}>
                  <option value="heading">Titre</option><option value="paragraph">Paragraphe</option><option value="quote">Encadré / citation</option><option value="list">Liste</option>
                </select>
                <span className="ml-auto text-[11px] text-[var(--on-surface-faint)]">Bloc {index + 1}</span>
                <button type="button" aria-label="Monter le bloc" onClick={() => move(index, -1)} disabled={index === 0} className="grid min-h-11 min-w-11 cursor-pointer place-items-center rounded-lg hover:bg-[var(--surface)] disabled:cursor-not-allowed disabled:opacity-30"><ArrowUp className="h-4 w-4" /></button>
                <button type="button" aria-label="Descendre le bloc" onClick={() => move(index, 1)} disabled={index === blocks.length - 1} className="grid min-h-11 min-w-11 cursor-pointer place-items-center rounded-lg hover:bg-[var(--surface)] disabled:cursor-not-allowed disabled:opacity-30"><ArrowDown className="h-4 w-4" /></button>
                <button type="button" aria-label="Supprimer le bloc" onClick={() => onBlocksChange(blocks.filter((_, i) => i !== index))} className="grid min-h-11 min-w-11 cursor-pointer place-items-center rounded-lg text-[var(--danger)] hover:bg-[var(--danger)]/10"><Trash2 className="h-4 w-4" /></button>
              </div>
              <textarea value={block.text} onChange={(e) => update(index, { text: e.target.value })} rows={block.type === "heading" ? 2 : 5} className={ic} placeholder={block.type === "list" ? "Un élément par ligne" : "Saisissez le contenu…"} />
            </div>
          ))}
          <button type="button" onClick={() => onBlocksChange([...blocks, { type: "paragraph", text: "" }])} className="flex min-h-11 w-full cursor-pointer items-center justify-center gap-2 rounded-xl border border-dashed border-[var(--brand)]/40 text-sm font-semibold text-[var(--brand)] hover:bg-[var(--brand)]/[.06]"><Plus className="h-4 w-4" />Ajouter un bloc</button>
        </div>
      )}
    </Card>
  )
}
