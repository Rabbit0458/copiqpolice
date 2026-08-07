"use client"

import Link from "next/link"
import {
  AlertTriangle,
  ArrowUpRight,
  BookOpenText,
  CheckCircle2,
  CircleDashed,
  GraduationCap,
  RefreshCw,
  type LucideIcon,
} from "lucide-react"
import { PATHWAY_LIST, type PathwayDefinition, type UserMode, type UserTrack } from "@/config/pathways"
import { coursApi, quizApi, type CoursRow, type QuizModuleRow } from "@/lib/admin/api"
import { Badge, Card, ErrorBox, Loading, PageHeader, useAsync } from "@/components/admin/admin-ui"

type ContentMode = UserMode | "unclassified"

export default function ContentOperationsPage() {
  const courses = useAsync(() => coursApi.list(), [])
  const quizzes = useAsync(() => quizApi.listModules(), [])
  const loading = courses.loading || quizzes.loading
  const courseRows = courses.data ?? []
  const quizRows = quizzes.data ?? []
  const anomalies = countAnomalies(courseRows, quizRows)

  return (
    <>
      <PageHeader
        title="Pilotage pédagogique"
        subtitle="Une vue fiable des cours et quiz disponibles dans les quatre parcours COP’IQ."
        action={
          <button
            type="button"
            onClick={() => { courses.reload(); quizzes.reload() }}
            disabled={loading}
            className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] px-3.5 text-sm font-semibold text-[var(--on-surface-muted)] transition duration-200 hover:border-[var(--brand)]/35 hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] disabled:cursor-wait disabled:opacity-50"
          >
            <RefreshCw size={16} className={loading ? "animate-spin" : ""} /> Actualiser
          </button>
        }
      />

      {courses.error && <ErrorBox error={courses.error} />}
      {quizzes.error && <ErrorBox error={quizzes.error} />}
      {loading && !courses.data && !quizzes.data && <Loading label="Analyse des contenus…" />}

      <section aria-label="Indicateurs pédagogiques" className="mb-6 grid grid-cols-2 gap-3 lg:grid-cols-4">
        <Metric icon={BookOpenText} label="Fiches" value={courseRows.length} hint={`${courseRows.filter((row) => row.is_published).length} publiées`} />
        <Metric icon={GraduationCap} label="Modules de quiz" value={quizRows.length} hint={`${quizRows.reduce((sum, row) => sum + row.nb_questions, 0)} questions`} />
        <Metric icon={CheckCircle2} label="Contenus actifs" value={courseRows.filter((row) => row.is_published).length + quizRows.filter((row) => row.is_active).length} hint="visibles ou utilisables" />
        <Metric icon={AlertTriangle} label="À vérifier" value={anomalies.total} hint="brouillons, explications ou classement" tone={anomalies.total > 0 ? "warn" : "good"} />
      </section>

      <section aria-labelledby="quality-title" className="mb-6">
        <div className="mb-3">
          <h2 id="quality-title" className="text-sm font-semibold">File de contrôle éditorial</h2>
          <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Chaque alerte ouvre directement le périmètre à corriger.</p>
        </div>
        <Card className="divide-y divide-[var(--outline-variant)] overflow-hidden">
          <QualityRow
            href="/admin/cours/?status=draft"
            label="Fiches en brouillon"
            detail="Contrôler le contenu et les rendre publiables lorsqu’elles sont complètes."
            count={anomalies.drafts}
          />
          <QualityRow
            href="/admin/quiz/?quality=missing-explanation"
            label="Questions sans correction"
            detail="Une explication est désormais obligatoire avant activation."
            count={anomalies.missingExplanations}
          />
          <QualityRow
            href="#pathways-title"
            label="Contenus à classifier"
            detail="Identifier le mode Concours ou École sans attribution automatique."
            count={anomalies.unclassified}
          />
          <QualityRow
            href="/admin/cours/?quality=media"
            label="Médias des fiches"
            detail="Contrôler automatiquement description, format sécurisé et disponibilité à l’ouverture."
            statusLabel="à l’ouverture"
          />
        </Card>
      </section>

      <section aria-labelledby="pathways-title">
        <div className="mb-3 flex flex-wrap items-end justify-between gap-2">
          <div>
            <h2 id="pathways-title" className="text-sm font-semibold">Couverture des quatre parcours</h2>
            <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Les volumes ambigus restent signalés, jamais attribués arbitrairement.</p>
          </div>
          <Badge tone={anomalies.unclassified > 0 ? "warn" : "good"}>{anomalies.unclassified} contenu{anomalies.unclassified > 1 ? "s" : ""} à classifier</Badge>
        </div>
        <div className="grid gap-4 xl:grid-cols-2">
          {PATHWAY_LIST.map((pathway) => (
            <PathwayCard key={pathway.id} pathway={pathway} courses={courseRows} quizzes={quizRows} />
          ))}
        </div>
      </section>

      <section aria-labelledby="actions-title" className="mt-6">
        <h2 id="actions-title" className="mb-3 text-sm font-semibold">Actions pédagogiques</h2>
        <div className="grid gap-3 sm:grid-cols-2">
          <Action href="/admin/cours/" icon={BookOpenText} title="Gérer les fiches de cours" hint="Modifier le contenu, le statut de publication et les références." />
          <Action href="/admin/quiz/" icon={GraduationCap} title="Gérer les quiz" hint="Contrôler les réponses, explications et niveaux de difficulté." />
        </div>
      </section>
    </>
  )
}

function PathwayCard({ pathway, courses, quizzes }: { pathway: PathwayDefinition; courses: CoursRow[]; quizzes: QuizModuleRow[] }) {
  const pathwayCourses = courses.filter((row) => normalizeTrack(row.track) === pathway.track && inferMode(row.route) === pathway.mode)
  const pathwayQuizzes = quizzes.filter((row) => normalizeTrack(row.track) === pathway.track && inferMode(`${row.route} ${row.module}`) === pathway.mode)
  const sharedCourses = courses.filter((row) => normalizeTrack(row.track) === pathway.track && inferMode(row.route) === "unclassified").length
  const sharedQuizzes = quizzes.filter((row) => normalizeTrack(row.track) === pathway.track && inferMode(`${row.route} ${row.module}`) === "unclassified").length
  const problems = pathwayCourses.filter((row) => !row.is_published).length + pathwayQuizzes.reduce((sum, row) => sum + row.nb_sans_explication, 0)

  return (
    <Card className="overflow-hidden transition duration-200 hover:border-[var(--brand)]/25 hover:shadow-[0_16px_40px_rgba(15,23,42,.06)]">
      <div className="h-1" style={{ backgroundColor: pathway.color }} />
      <div className="p-5">
        <div className="flex items-start justify-between gap-4">
          <div className="min-w-0">
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em]" style={{ color: pathway.color }}>{pathway.shortLabel}</p>
            <h3 className="mt-1 truncate text-base font-semibold">{pathway.label}</h3>
            <p className="mt-1 text-xs leading-relaxed text-[var(--on-surface-muted)]">{pathway.description}</p>
          </div>
          <span className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl" style={{ backgroundColor: pathway.softColor, color: pathway.color }}>
            {pathway.mode === "school" ? <GraduationCap size={20} /> : <BookOpenText size={20} />}
          </span>
        </div>
        <div className="mt-5 grid grid-cols-3 gap-2">
          <SmallStat label="Fiches certaines" value={pathwayCourses.length} />
          <SmallStat label="Quiz certains" value={pathwayQuizzes.length} />
          <SmallStat label="Alertes" value={problems} warning={problems > 0} />
        </div>
        {(sharedCourses + sharedQuizzes) > 0 && (
          <div className="mt-3 flex items-start gap-2 rounded-xl bg-[var(--warning)]/8 px-3 py-2.5 text-xs text-[var(--on-surface-muted)]">
            <CircleDashed size={15} className="mt-0.5 shrink-0 text-[var(--warning)]" />
            <span>{sharedCourses + sharedQuizzes} contenu{sharedCourses + sharedQuizzes > 1 ? "s" : ""} {pathway.track.toUpperCase()} sans mode explicite restent à classifier.</span>
          </div>
        )}
      </div>
    </Card>
  )
}

function Metric({ icon: Icon, label, value, hint, tone = "neutral" }: { icon: LucideIcon; label: string; value: number; hint: string; tone?: "neutral" | "warn" | "good" }) {
  const toneClass = tone === "warn" ? "bg-[var(--warning)]/12 text-[var(--warning)]" : tone === "good" ? "bg-[var(--success)]/12 text-[var(--success)]" : "bg-[var(--brand)]/10 text-[var(--brand)]"
  return <Card className="p-4"><span className={`grid h-9 w-9 place-items-center rounded-xl ${toneClass}`}><Icon size={17} /></span><p className="mt-3 text-2xl font-semibold tabular-nums">{value.toLocaleString("fr-FR")}</p><p className="text-xs font-semibold">{label}</p><p className="mt-1 text-[11px] text-[var(--on-surface-muted)]">{hint}</p></Card>
}

function SmallStat({ label, value, warning = false }: { label: string; value: number; warning?: boolean }) {
  return <div className="rounded-xl bg-[var(--surface-container)] px-3 py-3"><p className={`text-lg font-semibold tabular-nums ${warning ? "text-[var(--warning)]" : ""}`}>{value}</p><p className="mt-0.5 text-[10px] leading-tight text-[var(--on-surface-muted)]">{label}</p></div>
}

function Action({ href, icon: Icon, title, hint }: { href: string; icon: LucideIcon; title: string; hint: string }) {
  return <Link href={href} className="group flex min-h-24 cursor-pointer items-center gap-4 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-4 transition duration-200 hover:-translate-y-0.5 hover:border-[var(--brand)]/35 hover:shadow-[0_14px_30px_rgba(15,23,42,.06)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"><span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><Icon size={19} /></span><span className="min-w-0 flex-1"><span className="block text-sm font-semibold">{title}</span><span className="mt-1 block text-xs leading-relaxed text-[var(--on-surface-muted)]">{hint}</span></span><ArrowUpRight size={17} className="shrink-0 text-[var(--on-surface-faint)] transition group-hover:text-[var(--brand)]" /></Link>
}

function QualityRow({ href, label, detail, count, statusLabel }: { href: string; label: string; detail: string; count?: number; statusLabel?: string }) {
  const needsAttention = typeof count === "number" && count > 0
  return (
    <Link href={href} className="group flex min-h-20 cursor-pointer items-center gap-3 px-4 py-3 transition duration-200 hover:bg-[var(--surface-container)]/60 focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-[var(--brand)]">
      <span className={`grid h-9 w-9 shrink-0 place-items-center rounded-xl ${needsAttention ? "bg-[var(--warning)]/12 text-[var(--warning)]" : "bg-[var(--brand)]/10 text-[var(--brand)]"}`}>
        {needsAttention ? <AlertTriangle size={17} /> : typeof count === "number" ? <CheckCircle2 size={17} /> : <BookOpenText size={17} />}
      </span>
      <span className="min-w-0 flex-1">
        <span className="block text-sm font-semibold">{label}</span>
        <span className="mt-0.5 block text-xs leading-relaxed text-[var(--on-surface-muted)]">{detail}</span>
      </span>
      <span className={`rounded-full px-2.5 py-1 text-xs font-semibold tabular-nums ${needsAttention ? "bg-[var(--warning)]/10 text-[var(--warning)]" : "bg-[var(--brand)]/10 text-[var(--brand)]"}`}>{statusLabel ?? count}</span>
      <ArrowUpRight size={16} className="shrink-0 text-[var(--on-surface-faint)] transition group-hover:text-[var(--brand)]" />
    </Link>
  )
}

function normalizeTrack(value: string): UserTrack | null {
  const normalized = value.toLowerCase()
  if (normalized.includes("gpx")) return "gpx"
  if (normalized.includes("pa")) return "pa"
  return null
}

function inferMode(value: string): ContentMode {
  const normalized = value.toLowerCase()
  if (/(scolar|school|ecole|école|formation|initiale)/.test(normalized)) return "school"
  if (/(exam|concours|psychotech|culture.generale|langue|cas.pratique)/.test(normalized)) return "exam"
  return "unclassified"
}

function countAnomalies(courses: CoursRow[], quizzes: QuizModuleRow[]) {
  const drafts = courses.filter((row) => !row.is_published).length
  const missingExplanations = quizzes.reduce((sum, row) => sum + row.nb_sans_explication, 0)
  const unclassified = courses.filter((row) => inferMode(row.route) === "unclassified").length + quizzes.filter((row) => inferMode(`${row.route} ${row.module}`) === "unclassified").length
  return { drafts, missingExplanations, unclassified, total: drafts + missingExplanations + unclassified }
}
