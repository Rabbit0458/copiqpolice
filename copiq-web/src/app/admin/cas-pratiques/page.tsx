"use client"

import { Suspense, useState } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import {
  casPratiqueApi,
  type CpCaseRow,
  type CpQuestion,
  type RubricSpec,
} from "@/lib/admin/api"
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
      <CasPratiquesScreen />
    </Suspense>
  )
}

function CasPratiquesScreen() {
  const params = useSearchParams()
  const slug = params.get("slug")
  return slug ? <CaseEditor slug={slug} /> : <CaseList />
}

/* ══════════════════════════════════════════════════════════════════════════ */
/*  LISTE DES CAS                                                             */
/* ══════════════════════════════════════════════════════════════════════════ */

function CaseList() {
  const router = useRouter()
  const [search, setSearch] = useState("")
  const [status, setStatus] = useState("")
  const { data, error, loading, reload } = useAsync(
    () => casPratiqueApi.listCases({ search, status }),
    [search, status],
  )
  const [creating, setCreating] = useState(false)

  return (
    <>
      <PageHeader
        title="Cas pratiques"
        subtitle="Épreuve de cas pratique — concours Gardien de la Paix"
        action={<Button onClick={() => setCreating(true)}>+ Nouveau cas</Button>}
      />

      {creating && (
        <NewCaseForm
          onCancel={() => setCreating(false)}
          onCreated={(s) => {
            setCreating(false)
            router.push(`/admin/cas-pratiques/?slug=${encodeURIComponent(s)}`)
          }}
        />
      )}

      <div className="mb-4 flex flex-wrap gap-2">
        <input
          placeholder="Rechercher un cas…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="min-w-52 flex-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
        />
        {[
          ["", "Tous"],
          ["published", "Publiés"],
          ["draft", "Brouillons"],
          ["archived", "Archivés"],
        ].map(([v, l]) => (
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

      {data && data.length === 0 && <Empty>Aucun cas ne correspond à ces critères.</Empty>}

      {data && data.length > 0 && (
        <Card className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="border-b border-[var(--outline-variant)] text-left text-xs uppercase tracking-wide text-[var(--on-surface-faint)]">
              <tr>
                <th className="px-4 py-3 font-medium">Cas</th>
                <th className="px-3 py-3 font-medium">Thème</th>
                <th className="px-3 py-3 text-center font-medium">Q.</th>
                <th className="px-3 py-3 text-center font-medium">Grille</th>
                <th className="px-3 py-3 text-center font-medium">Modèles</th>
                <th className="px-3 py-3 text-center font-medium">Copies</th>
                <th className="px-3 py-3 font-medium">Statut</th>
                <th className="px-4 py-3" />
              </tr>
            </thead>
            <tbody>
              {data.map((c) => (
                <CaseRow key={c.id} c={c} onChanged={reload} />
              ))}
            </tbody>
          </table>
        </Card>
      )}
    </>
  )
}

function CaseRow({ c, onChanged }: { c: CpCaseRow; onChanged: () => void }) {
  const router = useRouter()
  const [busy, setBusy] = useState(false)
  const [msg, setMsg] = useState<string | null>(null)
  const incomplet = c.nb_rubric_points === 0 || c.nb_questions === 0

  async function toggle() {
    setBusy(true)
    setMsg(null)
    try {
      const next = c.status === "published" ? "draft" : "published"
      const r = await casPratiqueApi.setStatus(c.slug, next)
      if (!r.ok) setMsg(r.message ?? "Opération refusée")
      else onChanged()
    } catch (e) {
      setMsg(e instanceof Error ? e.message : "Erreur")
    } finally {
      setBusy(false)
    }
  }

  return (
    <tr className="border-b border-[var(--outline-variant)] last:border-0 hover:bg-[var(--surface-container)]/50">
      <td className="px-4 py-3">
        <div className="font-medium">{c.title}</div>
        <div className="text-xs text-[var(--on-surface-faint)]">
          {c.slug}
          {c.year ? ` · ${c.month ?? ""} ${c.year}` : ""}
        </div>
        {msg && <div className="mt-1 text-xs text-[var(--danger)]">{msg}</div>}
      </td>
      <td className="px-3 py-3 text-xs text-[var(--on-surface-muted)]">
        {c.theme_label ?? "—"}
      </td>
      <td className="px-3 py-3 text-center tabular-nums">{c.nb_questions}</td>
      <td className="px-3 py-3 text-center">
        {c.nb_rubric_points === 0 ? (
          <Badge tone="bad">0</Badge>
        ) : (
          <span className="tabular-nums">{c.nb_rubric_points}</span>
        )}
      </td>
      <td className="px-3 py-3 text-center">
        {c.nb_perfect < c.nb_questions ? (
          <Badge tone="warn">
            {c.nb_perfect}/{c.nb_questions}
          </Badge>
        ) : (
          <span className="tabular-nums">{c.nb_perfect}</span>
        )}
      </td>
      <td className="px-3 py-3 text-center text-xs tabular-nums text-[var(--on-surface-muted)]">
        {c.nb_attempts}
        {c.avg_percent != null && (
          <span className="block text-[10px]">{c.avg_percent} %</span>
        )}
      </td>
      <td className="px-3 py-3">
        {c.status === "published" ? (
          <Badge tone={incomplet ? "bad" : "good"}>
            {incomplet ? "publié · incomplet" : "publié"}
          </Badge>
        ) : (
          <Badge>{c.status}</Badge>
        )}
      </td>
      <td className="whitespace-nowrap px-4 py-3 text-right">
        <button
          onClick={() =>
            router.push(`/admin/cas-pratiques/?slug=${encodeURIComponent(c.slug)}`)
          }
          className="rounded-lg px-2.5 py-1.5 text-xs font-medium text-[var(--brand)] hover:bg-[var(--brand)]/10"
        >
          Éditer
        </button>
        <button
          onClick={toggle}
          disabled={busy}
          className="rounded-lg px-2.5 py-1.5 text-xs text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] disabled:opacity-50"
        >
          {c.status === "published" ? "Dépublier" : "Publier"}
        </button>
      </td>
    </tr>
  )
}

function NewCaseForm({
  onCancel,
  onCreated,
}: {
  onCancel: () => void
  onCreated: (slug: string) => void
}) {
  const themes = useAsync(() => casPratiqueApi.listThemes(), [])
  const [f, setF] = useState({
    slug: "",
    title: "",
    theme_slug: "",
    year: new Date().getFullYear(),
    difficulty: "moyen",
    total_points: 15,
    expected_minutes: 45,
    is_free: false,
  })
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setErr(null)
    try {
      await casPratiqueApi.upsertCase({ ...f, status: "draft" })
      onCreated(f.slug)
    } catch (e2) {
      setErr(e2)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="mb-4 p-5">
      <h2 className="mb-3 text-sm font-semibold">Nouveau cas pratique</h2>
      <form onSubmit={submit} className="grid gap-3 sm:grid-cols-2">
        <Input
          label="Titre"
          value={f.title}
          onChange={(v) =>
            setF({
              ...f,
              title: v,
              slug:
                f.slug ||
                v
                  .toLowerCase()
                  .normalize("NFD")
                  .replace(/[\u0300-\u036f]/g, "")
                  .replace(/[^a-z0-9]+/g, "-")
                  .replace(/^-|-$/g, ""),
            })
          }
          required
        />
        <Input label="Identifiant (slug)" value={f.slug} onChange={(v) => setF({ ...f, slug: v })} required />
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
            Thème
          </span>
          <select
            value={f.theme_slug}
            onChange={(e) => setF({ ...f, theme_slug: e.target.value })}
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm"
          >
            <option value="">— Choisir —</option>
            {(themes.data ?? []).map((t) => (
              <option key={t.slug} value={t.slug}>
                {t.label}
              </option>
            ))}
          </select>
        </label>
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
            Difficulté
          </span>
          <select
            value={f.difficulty}
            onChange={(e) => setF({ ...f, difficulty: e.target.value })}
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm"
          >
            <option value="facile">Facile</option>
            <option value="moyen">Moyen</option>
            <option value="difficile">Difficile</option>
          </select>
        </label>
        <Input
          label="Année"
          type="number"
          value={String(f.year)}
          onChange={(v) => setF({ ...f, year: Number(v) })}
        />
        <Input
          label="Durée conseillée (min)"
          type="number"
          value={String(f.expected_minutes)}
          onChange={(v) => setF({ ...f, expected_minutes: Number(v) })}
        />
        <div className="sm:col-span-2">
          <ErrorBox error={err} />
          <div className="mt-2 flex gap-2">
            <Button type="submit" disabled={busy}>
              {busy ? "Création…" : "Créer le brouillon"}
            </Button>
            <Button type="button" variant="ghost" onClick={onCancel}>
              Annuler
            </Button>
          </div>
        </div>
      </form>
    </Card>
  )
}

/* ══════════════════════════════════════════════════════════════════════════ */
/*  ÉDITEUR D'UN CAS                                                          */
/* ══════════════════════════════════════════════════════════════════════════ */

function CaseEditor({ slug }: { slug: string }) {
  const router = useRouter()
  const { data, error, loading, reload } = useAsync(
    () => casPratiqueApi.getCase(slug),
    [slug],
  )
  const [tab, setTab] = useState<"infos" | "situation" | "questions">("infos")

  if (loading) return <Loading />
  if (error) return <ErrorBox error={error} />
  if (!data || data.error) return <Empty>{data?.error ?? "Cas introuvable"}</Empty>

  const c = data.case

  return (
    <>
      <button
        onClick={() => router.push("/admin/cas-pratiques/")}
        className="mb-3 text-sm text-[var(--on-surface-muted)] hover:text-[var(--brand)]"
      >
        ← Retour à la liste
      </button>

      <PageHeader
        title={c.title}
        subtitle={`${c.slug} · ${c.theme_label ?? "sans thème"} · ${c.status}`}
      />

      <div className="mb-4 flex gap-1 border-b border-[var(--outline-variant)]">
        {(
          [
            ["infos", "Informations"],
            ["situation", "Énoncé"],
            ["questions", `Questions & grille (${data.questions.length})`],
          ] as const
        ).map(([k, l]) => (
          <button
            key={k}
            onClick={() => setTab(k)}
            className={`-mb-px border-b-2 px-3 py-2 text-sm transition ${
              tab === k
                ? "border-[var(--brand)] font-medium text-[var(--brand)]"
                : "border-transparent text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]"
            }`}
          >
            {l}
          </button>
        ))}
      </div>

      {tab === "infos" && <InfosTab detail={data} onSaved={reload} />}
      {tab === "situation" && <SituationTab detail={data} onSaved={reload} />}
      {tab === "questions" && <QuestionsTab detail={data} onSaved={reload} />}
    </>
  )
}

function InfosTab({
  detail,
  onSaved,
}: {
  detail: { case: Record<string, unknown> & { slug: string } }
  onSaved: () => void
}) {
  const c = detail.case as Record<string, string | number | boolean | null> & {
    slug: string
  }
  const themes = useAsync(() => casPratiqueApi.listThemes(), [])
  const [f, setF] = useState({
    title: String(c.title ?? ""),
    theme_slug: String(c.theme_slug ?? ""),
    year: Number(c.year ?? new Date().getFullYear()),
    month: String(c.month ?? ""),
    difficulty: String(c.difficulty ?? "moyen"),
    total_points: Number(c.total_points ?? 15),
    expected_minutes: Number(c.expected_minutes ?? 45),
    is_free: Boolean(c.is_free),
  })
  const [busy, setBusy] = useState(false)
  const [ok, setOk] = useState(false)
  const [err, setErr] = useState<unknown>(null)

  async function save() {
    setBusy(true)
    setErr(null)
    setOk(false)
    try {
      await casPratiqueApi.upsertCase({ slug: c.slug, ...f })
      setOk(true)
      onSaved()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="p-5">
      <div className="grid gap-3 sm:grid-cols-2">
        <Input label="Titre" value={f.title} onChange={(v) => setF({ ...f, title: v })} />
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
            Thème
          </span>
          <select
            value={f.theme_slug}
            onChange={(e) => setF({ ...f, theme_slug: e.target.value })}
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm"
          >
            <option value="">— Aucun —</option>
            {(themes.data ?? []).map((t) => (
              <option key={t.slug} value={t.slug}>
                {t.label}
              </option>
            ))}
          </select>
        </label>
        <Input
          label="Année"
          type="number"
          value={String(f.year)}
          onChange={(v) => setF({ ...f, year: Number(v) })}
        />
        <Input label="Mois / session" value={f.month} onChange={(v) => setF({ ...f, month: v })} />
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
            Difficulté
          </span>
          <select
            value={f.difficulty}
            onChange={(e) => setF({ ...f, difficulty: e.target.value })}
            className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm"
          >
            <option value="facile">Facile</option>
            <option value="moyen">Moyen</option>
            <option value="difficile">Difficile</option>
          </select>
        </label>
        <Input
          label="Barème total (points)"
          type="number"
          value={String(f.total_points)}
          onChange={(v) => setF({ ...f, total_points: Number(v) })}
        />
        <Input
          label="Durée conseillée (min)"
          type="number"
          value={String(f.expected_minutes)}
          onChange={(v) => setF({ ...f, expected_minutes: Number(v) })}
        />
        <label className="flex items-center gap-2 self-end pb-2 text-sm">
          <input
            type="checkbox"
            checked={f.is_free}
            onChange={(e) => setF({ ...f, is_free: e.target.checked })}
            className="h-4 w-4"
          />
          Accessible gratuitement (hors abonnement)
        </label>
      </div>
      <ErrorBox error={err} />
      <div className="mt-4 flex items-center gap-3">
        <Button onClick={save} disabled={busy}>
          {busy ? "Enregistrement…" : "Enregistrer"}
        </Button>
        {ok && <span className="text-sm text-[var(--success)]">✓ Enregistré</span>}
      </div>
    </Card>
  )
}

function SituationTab({
  detail,
  onSaved,
}: {
  detail: { case: Record<string, unknown> & { slug: string } }
  onSaved: () => void
}) {
  const c = detail.case as Record<string, string | null> & { slug: string }
  const [md, setMd] = useState(String(c.situation_md ?? ""))
  const [refs, setRefs] = useState(String(c.legal_refs_md ?? ""))
  const [busy, setBusy] = useState(false)
  const [ok, setOk] = useState(false)
  const [err, setErr] = useState<unknown>(null)

  async function save() {
    setBusy(true)
    setErr(null)
    setOk(false)
    try {
      await casPratiqueApi.upsertCase({
        slug: c.slug,
        situation_md: md,
        situation_text: md,
        legal_refs_md: refs,
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
    <div className="grid gap-4 lg:grid-cols-2">
      <Card className="p-5">
        <h3 className="mb-2 text-sm font-semibold">Énoncé (Markdown)</h3>
        <textarea
          value={md}
          onChange={(e) => setMd(e.target.value)}
          rows={20}
          className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] p-3 font-mono text-xs leading-relaxed outline-none focus:border-[var(--brand)]"
          placeholder="Vous êtes gardien de la paix affecté…"
        />
        <h3 className="mb-2 mt-4 text-sm font-semibold">Références légales</h3>
        <textarea
          value={refs}
          onChange={(e) => setRefs(e.target.value)}
          rows={4}
          className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] p-3 font-mono text-xs outline-none focus:border-[var(--brand)]"
          placeholder="art. 78-2 CPP, art. L435-1 CSI…"
        />
        <ErrorBox error={err} />
        <div className="mt-3 flex items-center gap-3">
          <Button onClick={save} disabled={busy}>
            {busy ? "Enregistrement…" : "Enregistrer"}
          </Button>
          {ok && <span className="text-sm text-[var(--success)]">✓ Enregistré</span>}
        </div>
      </Card>

      <Card className="p-5">
        <h3 className="mb-2 text-sm font-semibold">
          Aperçu <span className="font-normal text-[var(--on-surface-faint)]">(élève)</span>
        </h3>
        <div className="prose prose-sm max-w-none whitespace-pre-wrap text-sm leading-relaxed">
          {md || (
            <span className="text-[var(--on-surface-faint)]">
              L&apos;énoncé apparaîtra ici.
            </span>
          )}
        </div>
      </Card>
    </div>
  )
}

/* ── Onglet Questions & grille de correction ─────────────────────────────── */

function QuestionsTab({
  detail,
  onSaved,
}: {
  detail: { case: { slug: string }; questions: CpQuestion[] }
  onSaved: () => void
}) {
  const [open, setOpen] = useState<number | null>(
    detail.questions.length ? detail.questions[0].position : null,
  )

  if (detail.questions.length === 0) {
    return (
      <Card className="p-5">
        <Empty>
          Ce cas n&apos;a aucune question. Ajoutes-en une depuis l&apos;éditeur de grille
          ci-dessous.
        </Empty>
        <RubricJsonEditor slug={detail.case.slug} position={1} onSaved={onSaved} />
      </Card>
    )
  }

  return (
    <div className="space-y-3">
      {detail.questions.map((q) => {
        const nbKw = q.rubric_points.reduce(
          (a, p) => a + p.groups.reduce((b, g) => b + g.keywords.length, 0),
          0,
        )
        const expanded = open === q.position
        return (
          <Card key={q.id} className="overflow-hidden">
            <button
              onClick={() => setOpen(expanded ? null : q.position)}
              className="flex w-full items-start gap-3 p-4 text-left hover:bg-[var(--surface-container)]/50"
            >
              <span className="mt-0.5 grid h-6 w-6 shrink-0 place-items-center rounded-md bg-[var(--brand)]/10 text-xs font-semibold text-[var(--brand)]">
                {q.position}
              </span>
              <span className="min-w-0 flex-1">
                <span className="block text-sm font-medium">{q.label}</span>
                <span className="mt-1 flex flex-wrap items-center gap-2 text-xs text-[var(--on-surface-muted)]">
                  <span>{q.max_points} pts</span>
                  {q.rubric_points.length === 0 ? (
                    <Badge tone="bad">aucun point de correction</Badge>
                  ) : (
                    <Badge tone="brand">
                      {q.rubric_points.length} points · {nbKw} mots-clés
                    </Badge>
                  )}
                  {q.perfect_answer ? (
                    <Badge tone="good">réponse modèle</Badge>
                  ) : (
                    <Badge tone="warn">sans réponse modèle</Badge>
                  )}
                </span>
              </span>
              <span className="text-[var(--on-surface-faint)]">{expanded ? "▲" : "▼"}</span>
            </button>

            {expanded && (
              <div className="border-t border-[var(--outline-variant)] p-4">
                <div className="mb-4 space-y-3">
                  {q.rubric_points.map((p) => (
                    <div
                      key={p.id}
                      className="rounded-lg border border-[var(--outline-variant)] p-3"
                    >
                      <div className="flex items-start justify-between gap-3">
                        <div className="text-sm font-medium">{p.label}</div>
                        <div className="flex shrink-0 gap-1.5">
                          <Badge tone={p.kind === "bonus" ? "warn" : "brand"}>
                            {p.kind}
                          </Badge>
                          <Badge>{p.weight} pt</Badge>
                        </div>
                      </div>
                      {p.explanation_md && (
                        <p className="mt-1 text-xs text-[var(--on-surface-muted)]">
                          {p.explanation_md}
                        </p>
                      )}
                      <div className="mt-2 space-y-1.5">
                        {p.groups.map((g, i) => (
                          <div key={g.id} className="flex flex-wrap items-center gap-1">
                            {i > 0 && (
                              <span className="mr-1 text-[10px] font-semibold uppercase text-[var(--on-surface-faint)]">
                                et
                              </span>
                            )}
                            {g.keywords.map((k) => (
                              <span
                                key={k.id}
                                title={
                                  k.auto_added
                                    ? "Ajouté automatiquement suite à un appel validé"
                                    : undefined
                                }
                                className={`rounded px-1.5 py-0.5 font-mono text-[11px] ${
                                  k.auto_added
                                    ? "bg-[var(--success)]/12 text-[var(--success)]"
                                    : "bg-[var(--surface-container-hi)] text-[var(--on-surface-muted)]"
                                }`}
                              >
                                {k.value}
                              </span>
                            ))}
                            {g.keywords.length === 0 && (
                              <span className="text-xs text-[var(--danger)]">
                                groupe vide — ce point ne pourra jamais être validé
                              </span>
                            )}
                          </div>
                        ))}
                        {p.groups.length === 0 && (
                          <span className="text-xs text-[var(--danger)]">
                            aucun mot-clé — ce point ne pourra jamais être validé
                          </span>
                        )}
                      </div>
                    </div>
                  ))}
                </div>

                {q.perfect_answer && (
                  <details className="mb-4">
                    <summary className="cursor-pointer text-sm font-medium">
                      Réponse modèle
                    </summary>
                    <div className="mt-2 whitespace-pre-wrap rounded-lg bg-[var(--surface-container)] p-3 text-xs leading-relaxed">
                      {q.perfect_answer.body_md}
                    </div>
                  </details>
                )}

                <RubricJsonEditor
                  slug={detail.case.slug}
                  position={q.position}
                  initial={toSpec(detail.case.slug, q)}
                  onSaved={onSaved}
                />
              </div>
            )}
          </Card>
        )
      })}
      <Card className="p-4">
        <h3 className="mb-2 text-sm font-semibold">Ajouter une question</h3>
        <RubricJsonEditor
          slug={detail.case.slug}
          position={detail.questions.length + 1}
          onSaved={onSaved}
        />
      </Card>
    </div>
  )
}

function toSpec(slug: string, q: CpQuestion): RubricSpec {
  return {
    case: slug,
    q: q.position,
    perfect: q.perfect_answer?.body_md ?? "",
    refs: q.perfect_answer?.references_legal ?? [],
    points: q.rubric_points.map((p) => ({
      label: p.label,
      weight: Number(p.weight),
      kind: p.kind,
      expl: p.explanation_md ?? "",
      groups: p.groups.map((g) => g.keywords.map((k) => k.value)),
    })),
  }
}

/**
 * Éditeur de grille au format JSON — le même que celui utilisé par les
 * migrations SQL et la fonction `fn_cp_seed_question_rubric`.
 * L'enregistrement REMPLACE intégralement la grille de la question.
 */
function RubricJsonEditor({
  slug,
  position,
  initial,
  onSaved,
}: {
  slug: string
  position: number
  initial?: RubricSpec
  onSaved: () => void
}) {
  const template: RubricSpec = initial ?? {
    case: slug,
    q: position,
    perfect: "",
    refs: [],
    points: [
      {
        label: "Intitulé du point attendu",
        weight: 2,
        kind: "core",
        expl: "Explication affichée à l'élève après correction.",
        groups: [["mot-cle", "synonyme"]],
      },
    ],
  }
  const [txt, setTxt] = useState(() => JSON.stringify(template, null, 2))
  const [busy, setBusy] = useState(false)
  const [msg, setMsg] = useState<string | null>(null)
  const [err, setErr] = useState<unknown>(null)
  const [show, setShow] = useState(false)

  async function save() {
    setBusy(true)
    setErr(null)
    setMsg(null)
    try {
      const spec = JSON.parse(txt) as RubricSpec
      spec.case = slug
      const r = await casPratiqueApi.saveRubric(spec)
      setMsg(r.message)
      if (r.ok) onSaved()
    } catch (e) {
      setErr(e instanceof SyntaxError ? new Error(`JSON invalide : ${e.message}`) : e)
    } finally {
      setBusy(false)
    }
  }

  if (!show) {
    return (
      <Button variant="ghost" onClick={() => setShow(true)}>
        {initial ? "Modifier la grille de correction" : "Créer la grille de correction"}
      </Button>
    )
  }

  return (
    <div className="rounded-lg border border-[var(--outline)] p-3">
      <p className="mb-2 text-xs leading-relaxed text-[var(--on-surface-muted)]">
        Un <strong>point</strong> = un élément attendu dans la copie. Il est validé quand{" "}
        <strong>tous ses groupes</strong> matchent (ET), et un groupe matche dès{" "}
        <strong>un seul</strong> de ses mots-clés (OU). Les accents et la casse sont
        ignorés ; les fautes de frappe sont tolérées au-delà de 8 caractères.
        <br />
        <span className="text-[var(--warning)]">
          ⚠ L&apos;enregistrement remplace intégralement la grille de cette question.
        </span>
      </p>
      <textarea
        value={txt}
        onChange={(e) => setTxt(e.target.value)}
        rows={18}
        spellCheck={false}
        className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface-container)] p-3 font-mono text-[11px] leading-relaxed outline-none focus:border-[var(--brand)]"
      />
      <ErrorBox error={err} />
      {msg && (
        <p className="mt-2 text-xs text-[var(--success)]">{msg}</p>
      )}
      <div className="mt-2 flex gap-2">
        <Button onClick={save} disabled={busy}>
          {busy ? "Enregistrement…" : "Enregistrer la grille"}
        </Button>
        <Button variant="ghost" onClick={() => setShow(false)}>
          Fermer
        </Button>
      </div>
    </div>
  )
}

/* ── Champ texte ─────────────────────────────────────────────────────────── */

function Input({
  label,
  value,
  onChange,
  ...rest
}: {
  label: string
  value: string
  onChange: (v: string) => void
} & Omit<React.InputHTMLAttributes<HTMLInputElement>, "value" | "onChange">) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
        {label}
      </span>
      <input
        {...rest}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
      />
    </label>
  )
}
