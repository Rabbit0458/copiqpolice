"use client"

import { Suspense, useState } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import {
  quizApi,
  type QuizModuleRow,
  type QuizQuestionRow,
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
      <QuizScreen />
    </Suspense>
  )
}

function QuizScreen() {
  const params = useSearchParams()
  const module = params.get("module")
  return module ? <QuestionList module={module} /> : <ModuleList />
}

/* ══════════════════════════════════════════════════════════════════════════ */

function ModuleList() {
  const router = useRouter()
  const { data, error, loading } = useAsync(() => quizApi.listModules(), [])

  return (
    <>
      <PageHeader
        title="Quiz de scolarité"
        subtitle="Questions stockées en base : une correction est visible immédiatement dans l'application, sans republication sur les stores."
      />

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data && data.length === 0 && <Empty>Aucun quiz configuré.</Empty>}

      <div className="grid gap-3 md:grid-cols-2">
        {(data ?? []).map((m) => (
          <ModuleCard
            key={m.module}
            m={m}
            onOpen={() =>
              router.push(`/admin/quiz/?module=${encodeURIComponent(m.module)}`)
            }
          />
        ))}
      </div>
    </>
  )
}

function ModuleCard({ m, onOpen }: { m: QuizModuleRow; onOpen: () => void }) {
  const thin = m.nb_questions < 10
  return (
    <Card className="p-4">
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="flex items-center gap-2">
            <span
              className="h-3 w-3 shrink-0 rounded-full"
              style={{ backgroundColor: m.color_hex }}
            />
            <span className="truncate text-sm font-semibold">{m.title}</span>
          </div>
          {m.subtitle && (
            <p className="mt-1 text-xs text-[var(--on-surface-muted)]">
              {m.subtitle}
            </p>
          )}
          <code className="mt-1 block text-[11px] text-[var(--on-surface-faint)]">
            {m.route}
          </code>
        </div>
        <Badge tone={thin ? "warn" : "good"}>{m.nb_questions} q.</Badge>
      </div>

      <div className="mt-3 flex flex-wrap items-center gap-1.5 text-[11px]">
        <Badge>F {m.nb_facile}</Badge>
        <Badge>M {m.nb_moyenne}</Badge>
        <Badge>D {m.nb_difficile}</Badge>
        {m.nb_sans_explication > 0 && (
          <Badge tone="warn">{m.nb_sans_explication} sans explication</Badge>
        )}
        {thin && <Badge tone="warn">à enrichir</Badge>}
      </div>

      <Button variant="ghost" onClick={onOpen} className="mt-3 w-full">
        Gérer les questions
      </Button>
    </Card>
  )
}

/* ══════════════════════════════════════════════════════════════════════════ */

function QuestionList({ module }: { module: string }) {
  const router = useRouter()
  const [search, setSearch] = useState("")
  const { data, error, loading, reload } = useAsync(
    () => quizApi.listQuestions(module, search),
    [module, search],
  )
  const [editing, setEditing] = useState<QuizQuestionRow | "new" | null>(null)

  return (
    <>
      <button
        onClick={() => router.push("/admin/quiz/")}
        className="mb-3 text-sm text-[var(--on-surface-muted)] hover:text-[var(--brand)]"
      >
        ← Retour aux quiz
      </button>

      <PageHeader
        title={module}
        subtitle={`${data?.length ?? 0} question(s)`}
        action={<Button onClick={() => setEditing("new")}>+ Question</Button>}
      />

      {editing && (
        <QuestionForm
          module={module}
          initial={editing === "new" ? null : editing}
          onCancel={() => setEditing(null)}
          onSaved={() => {
            setEditing(null)
            reload()
          }}
        />
      )}

      <input
        placeholder="Rechercher dans les questions…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="mb-4 w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
      />

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data && data.length === 0 && <Empty>Aucune question.</Empty>}

      <div className="space-y-2">
        {(data ?? []).map((q) => (
          <Card key={q.id} className="p-4">
            <div className="flex items-start justify-between gap-3">
              <div className="min-w-0 flex-1">
                <div className="mb-1.5 flex flex-wrap items-center gap-1.5">
                  <Badge
                    tone={
                      q.difficulty === "Facile"
                        ? "good"
                        : q.difficulty === "Difficile"
                          ? "bad"
                          : "warn"
                    }
                  >
                    {q.difficulty}
                  </Badge>
                  {q.category && <Badge>{q.category}</Badge>}
                  {!q.is_active && <Badge tone="bad">désactivée</Badge>}
                  {!q.explanation && <Badge tone="warn">sans explication</Badge>}
                </div>
                <p className="text-sm font-medium">{q.question}</p>
                <ul className="mt-2 space-y-0.5">
                  {q.options.map((o) => (
                    <li
                      key={o}
                      className={`text-xs ${
                        o === q.answer
                          ? "font-semibold text-[var(--success)]"
                          : "text-[var(--on-surface-muted)]"
                      }`}
                    >
                      {o === q.answer ? "✓ " : "· "}
                      {o}
                    </li>
                  ))}
                </ul>
                {q.legal_ref && (
                  <p className="mt-1.5 text-[11px] italic text-[var(--on-surface-faint)]">
                    {q.legal_ref}
                  </p>
                )}
              </div>
              <div className="flex shrink-0 flex-col gap-1">
                <button
                  onClick={() => setEditing(q)}
                  className="rounded-lg px-2.5 py-1.5 text-xs font-medium text-[var(--brand)] hover:bg-[var(--brand)]/10"
                >
                  Modifier
                </button>
                <button
                  onClick={async () => {
                    if (!confirm("Supprimer définitivement cette question ?")) return
                    await quizApi.deleteQuestion(q.id, "Suppression via le panel")
                    reload()
                  }}
                  className="rounded-lg px-2.5 py-1.5 text-xs text-[var(--danger)] hover:bg-[var(--danger)]/10"
                >
                  Supprimer
                </button>
              </div>
            </div>
          </Card>
        ))}
      </div>
    </>
  )
}

function QuestionForm({
  module,
  initial,
  onCancel,
  onSaved,
}: {
  module: string
  initial: QuizQuestionRow | null
  onCancel: () => void
  onSaved: () => void
}) {
  const [f, setF] = useState({
    question: initial?.question ?? "",
    options: (initial?.options ?? ["", "", "", ""]).join("\n"),
    answer: initial?.answer ?? "",
    category: initial?.category ?? "",
    difficulty: initial?.difficulty ?? "Moyenne",
    explanation: initial?.explanation ?? "",
    legal_ref: initial?.legal_ref ?? "",
    is_active: initial?.is_active ?? true,
  })
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)

  const options = f.options
    .split("\n")
    .map((s) => s.trim())
    .filter(Boolean)
  const answerValid = options.includes(f.answer.trim())

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setErr(null)
    try {
      await quizApi.upsertQuestion({
        id: initial?.id,
        module,
        question: f.question,
        options,
        answer: f.answer.trim(),
        category: f.category || null,
        difficulty: f.difficulty,
        explanation: f.explanation || null,
        legal_ref: f.legal_ref || null,
        is_active: f.is_active,
      })
      onSaved()
    } catch (e2) {
      setErr(e2)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="mb-4 p-5">
      <h2 className="mb-3 text-sm font-semibold">
        {initial ? "Modifier la question" : "Nouvelle question"}
      </h2>
      <form onSubmit={submit} className="space-y-3">
        <Field label="Question">
          <textarea
            value={f.question}
            onChange={(e) => setF({ ...f, question: e.target.value })}
            rows={2}
            required
            className={inputCls}
          />
        </Field>

        <Field label="Propositions (une par ligne, 2 minimum)">
          <textarea
            value={f.options}
            onChange={(e) => setF({ ...f, options: e.target.value })}
            rows={4}
            required
            className={`${inputCls} font-mono text-xs`}
          />
        </Field>

        <Field label="Bonne réponse (doit figurer à l'identique ci-dessus)">
          <input
            value={f.answer}
            onChange={(e) => setF({ ...f, answer: e.target.value })}
            required
            className={inputCls}
          />
          {f.answer && !answerValid && (
            <p className="mt-1 text-xs text-[var(--danger)]">
              Cette réponse ne figure pas dans les propositions.
            </p>
          )}
        </Field>

        <div className="grid gap-3 sm:grid-cols-2">
          <Field label="Catégorie">
            <input
              value={f.category}
              onChange={(e) => setF({ ...f, category: e.target.value })}
              className={inputCls}
            />
          </Field>
          <Field label="Difficulté">
            <select
              value={f.difficulty}
              onChange={(e) =>
                setF({ ...f, difficulty: e.target.value as typeof f.difficulty })
              }
              className={inputCls}
            >
              <option>Facile</option>
              <option>Moyenne</option>
              <option>Difficile</option>
            </select>
          </Field>
        </div>

        <Field label="Explication affichée après réponse">
          <textarea
            value={f.explanation}
            onChange={(e) => setF({ ...f, explanation: e.target.value })}
            rows={2}
            className={inputCls}
          />
        </Field>

        <Field label="Référence légale">
          <input
            value={f.legal_ref}
            onChange={(e) => setF({ ...f, legal_ref: e.target.value })}
            placeholder="art. 78-2 CPP"
            className={inputCls}
          />
        </Field>

        <label className="flex items-center gap-2 text-sm">
          <input
            type="checkbox"
            checked={f.is_active}
            onChange={(e) => setF({ ...f, is_active: e.target.checked })}
            className="h-4 w-4"
          />
          Question active (visible dans l&apos;application)
        </label>

        <ErrorBox error={err} />
        <div className="flex gap-2">
          <Button type="submit" disabled={busy || !answerValid}>
            {busy ? "Enregistrement…" : "Enregistrer"}
          </Button>
          <Button type="button" variant="ghost" onClick={onCancel}>
            Annuler
          </Button>
        </div>
      </form>
    </Card>
  )
}

const inputCls =
  "w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"

function Field({
  label,
  children,
}: {
  label: string
  children: React.ReactNode
}) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
        {label}
      </span>
      {children}
    </label>
  )
}
