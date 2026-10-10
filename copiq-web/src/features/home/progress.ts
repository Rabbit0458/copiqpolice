import type { SupabaseClient } from "@supabase/supabase-js"
import type { PathwayDefinition } from "@/config/pathways"

/**
 * Progression COP'IQ — portage fidèle du calcul de l'application
 * (lib/features/home/pa_exam_progress_calculator.dart et des dépôts
 * gpx_/pa_exam_progress_repository.dart, gpx_/pa_school_progress_service.dart).
 *
 * Mêmes sources, mêmes filtres et mêmes règles : le pourcentage affiché sur
 * le site est celui de l'application.
 *  - global = bonnes réponses / réponses, toutes activités scorées ;
 *  - une tentative de quiz sans aucune réponse enregistrée n'est jamais un 0 %
 *    (enrichissement par quiz_answer_history, comme dans l'app) ;
 *  - série = jours consécutifs avec au moins une activité (aujourd'hui ou hier) ;
 *  - recommandation = matière la moins maîtrisée parmi celles qui ont au moins
 *    10 réponses (sinon parmi toutes).
 */

export type Activity = {
  id: string
  source: "quiz" | "psy" | "case" | "photo"
  moduleKey: string
  moduleLabel: string
  title: string
  correct: number
  total: number
  finishedAt: Date
}

export type Subject = {
  key: string
  label: string
  color: string
  activities: number
  correct: number
  total: number
  averagePercent: number
  lastPercent: number
  lastActivityAt: Date
}

export type CompetitionEvent = {
  type: string
  typeLabel: string
  session: string
  dateText: string
  startsOn: Date | null
  endsOn: Date | null
}

export type HomeSnapshot = {
  globalPercent: number
  totalQuestions: number
  totalCorrect: number
  /** Entraînements scorés (quiz, exercices, cas, photolangage). */
  totalActivities: number
  streakDays: number
  doneToday: number
  doneThisWeek: number
  week: { day: Date; count: number }[]
  subjects: Subject[]
  recommendation: { subject: Subject; reason: string } | null
  recent: Activity[]
  placementPercent: number | null
  nextEvent: CompetitionEvent | null
  /** Échéances officielles à venir (calendrier du concours). */
  upcoming: CompetitionEvent[]
  warnings: string[]
}

/* ─── Modules (libellés et couleurs de l'app) ─────────────────────────────── */

type Meta = { label: string; color: string }

const GPX_EXAM: Record<string, Meta> = {
  culture_generale: { label: "Culture générale", color: "#2563EB" },
  psychotechnique: { label: "Tests psychotechniques", color: "#7C3AED" },
  langue_etrangere: { label: "Langue étrangère", color: "#DB2777" },
  institution: { label: "Institution policière", color: "#0F766E" },
  cas_pratique: { label: "Cas pratiques", color: "#EA580C" },
}
const PA_EXAM: Record<string, Meta> = {
  culture_generale: { label: "Culture générale", color: "#2563EB" },
  psychotechnique: { label: "Tests psychotechniques", color: "#7C3AED" },
  francais: { label: "Français", color: "#DB2777" },
  institution: { label: "Institution policière", color: "#0F766E" },
  photolangage: { label: "Photolangage", color: "#EA580C" },
}
const GPX_SCHOOL: Record<string, Meta> = {
  institution_organisation: { label: "Institution & organisation", color: "#2563EB" },
  police_judiciaire: { label: "Police judiciaire & droit pénal", color: "#7C3AED" },
  securite_routiere: { label: "Sécurité routière", color: "#0F766E" },
  intervention: { label: "Intervention professionnelle", color: "#EA580C" },
  public_victimes: { label: "Accueil du public & victimes", color: "#DB2777" },
  fondamentaux: { label: "Fondamentaux de scolarité", color: "#64748B" },
}
const PA_SCHOOL: Record<string, Meta> = {
  institutions_valeurs: { label: "Institution & valeurs", color: "#2563EB" },
  circulation_routiere: { label: "Circulation routière", color: "#0F766E" },
  dps_dpg: { label: "DPS / DPG", color: "#7C3AED" },
  intervention: { label: "Intervention professionnelle", color: "#EA580C" },
  fondamentaux: { label: "Fondamentaux de scolarité", color: "#64748B" },
}
const OTHER: Meta = { label: "Autres entraînements", color: "#64748B" }

function metaFor(pathway: PathwayDefinition, key: string): Meta {
  const table =
    pathway.id === "gpx_exam" ? GPX_EXAM : pathway.id === "pa_exam" ? PA_EXAM : pathway.id === "gpx_school" ? GPX_SCHOOL : PA_SCHOOL
  return table[key] ?? (pathway.mode === "school" ? table.fondamentaux ?? OTHER : OTHER)
}

const noAccent = (s: string) => s.toLowerCase().replace(/[éèê]/g, "e")

function gpxExamKey(moduleName: string, quizName: string) {
  const v = noAccent(`${moduleName} ${quizName}`)
  if (v.includes("cas pratique")) return "cas_pratique"
  if (["psycho", "logique", "calcul", "concentration", "attention", "spatial"].some((w) => v.includes(w))) return "psychotechnique"
  if (["langue", "anglais", "espagnol", "allemand"].some((w) => v.includes(w))) return "langue_etrangere"
  if (v.includes("police") || v.includes("institution")) return "institution"
  if (["culture", "histoire", "geograph", "science", "droit", "actualite", "sport"].some((w) => v.includes(w))) return "culture_generale"
  return "autres"
}

function paExamKey(moduleName: string, quizName: string) {
  const v = `${moduleName} ${quizName}`.toLowerCase()
  if (v.includes("photo")) return "photolangage"
  if (["psycho", "logique", "calcul", "concentration", "attention"].some((w) => v.includes(w))) return "psychotechnique"
  if (v.includes("fran") || v.includes("verbal")) return "francais"
  if (v.includes("police") || v.includes("institution")) return "institution"
  if (v.includes("culture") || v.includes("connaissance")) return "culture_generale"
  return "autres"
}

function gpxSchoolKey(value: string) {
  const v = value.toLowerCase()
  if (["institution", "organisation", "déontolog", "deontolog", "hiérarch"].some((w) => v.includes(w))) return "institution_organisation"
  if (["judiciaire", "pénal", "penal", "enquête", "enquete"].some((w) => v.includes(w))) return "police_judiciaire"
  if (v.includes("rout") || v.includes("circulation")) return "securite_routiere"
  if (["intervention", "patrouille", "violence", "arme"].some((w) => v.includes(w))) return "intervention"
  if (["accueil", "victime", "public"].some((w) => v.includes(w))) return "public_victimes"
  return "fondamentaux"
}

function paSchoolKey(value: string) {
  const v = value.toLowerCase()
  if (["institution", "déontolog", "deontolog", "hiérarch", "hierarch"].some((w) => v.includes(w))) return "institutions_valeurs"
  if (["rout", "circulation", "véhicule"].some((w) => v.includes(w))) return "circulation_routiere"
  if (["pénal", "penal", "dps", "dpg", "enquête", "enquete"].some((w) => v.includes(w))) return "dps_dpg"
  if (["intervention", "patrouille", "radio"].some((w) => v.includes(w))) return "intervention"
  return "fondamentaux"
}

const PSY_TITLES: Record<string, string> = {
  attention_visuelle: "Attention visuelle",
  suite_logique: "Suites logiques",
  calcul: "Calcul mental",
  calcul_mental: "Calcul mental",
  concentration: "Concentration",
  verbal: "Logique verbale",
  logique_verbale: "Logique verbale",
  raisonnement: "Raisonnement logique",
  raisonnement_logique: "Raisonnement logique",
  spatial: "Raisonnement spatial",
  raisonnement_spatial: "Raisonnement spatial",
  rotations: "Rotations et symétries",
  mode_concours_global: "Mode concours",
}

/* ─── Utilitaires ─────────────────────────────────────────────────────────── */

const int = (v: unknown) => (typeof v === "number" ? Math.round(v) : Number.parseInt(String(v ?? ""), 10) || 0)
const date = (v: unknown) => {
  const d = v ? new Date(String(v)) : new Date(0)
  return Number.isNaN(d.getTime()) ? new Date(0) : d
}
const day = (d: Date) => new Date(d.getFullYear(), d.getMonth(), d.getDate())
const dayKey = (d: Date) => `${d.getFullYear()}-${d.getMonth()}-${d.getDate()}`
const pct = (correct: number, total: number) => (total <= 0 ? 0 : Math.max(0, Math.min(100, Math.round((correct / total) * 100))))
const cleanTitle = (s: string) => s.replace(/^(GPX|PA)\s*-\s*/i, "").replace(/^Quiz\s+/i, "").trim()

type Row = Record<string, unknown>

/* ─── Chargement ──────────────────────────────────────────────────────────── */

export async function loadHomeSnapshot(supabase: SupabaseClient, userId: string, pathway: PathwayDefinition): Promise<HomeSnapshot> {
  const { track, mode } = pathway
  const warnings: string[] = []

  async function optional<T>(label: string, run: () => Promise<T>, fallback: T): Promise<T> {
    try {
      return await run()
    } catch {
      warnings.push(label)
      return fallback
    }
  }

  // 1. Quiz (source principale) + réponses détaillées pour l'enrichissement.
  const quizPromise = supabase
    .from("quiz_history")
    .select("id, module_name, quiz_name, correct_count, total_questions, started_at, finished_at, completed_at")
    .eq("uid", userId)
    .eq("track", track)
    .eq("mode", mode)
    .order("started_at", { ascending: false })
    .limit(mode === "school" ? 750 : 500)

  const answersPromise = optional("réponses détaillées", async () => {
    const { data, error } = await supabase
      .from("quiz_answer_history")
      .select("history_id, is_correct")
      .eq("user_id", userId)
      .eq("track", track)
      .eq("mode", mode)
      .order("answered_at", { ascending: true })
      .limit(10000)
    if (error) throw error
    return (data ?? []) as Row[]
  }, [] as Row[])

  const psyPromise =
    mode === "exam"
      ? optional("psychotechniques", async () => {
          let q = supabase
            .from("tests_psychotechnique_history")
            .select("id, exercise_type, correct_answers, total_questions, created_at")
            .eq("user_id", userId)
          q = track === "gpx" ? q.eq("module", "psychotechnique").in("mode", ["concours", "concours_global"]) : q.eq("module", "pa_psychotechnique").eq("mode", "concours")
          const { data, error } = await q.order("created_at", { ascending: false }).limit(300)
          if (error) throw error
          return (data ?? []) as Row[]
        }, [] as Row[])
      : Promise.resolve([] as Row[])

  const casePromise =
    mode === "exam" && track === "gpx"
      ? optional("cas pratiques", async () => {
          const { data, error } = await supabase
            .from("cas_pratique_attempts")
            .select("id, percent, finished_at, status, cas_pratique_cases(title)")
            .eq("user_id", userId)
            .eq("status", "completed")
            .not("finished_at", "is", null)
            .order("finished_at", { ascending: false })
            .limit(200)
          if (error) throw error
          return (data ?? []) as Row[]
        }, [] as Row[])
      : Promise.resolve([] as Row[])

  const photoPromise =
    mode === "exam" && track === "pa"
      ? optional("photolangage", async () => {
          const { data, error } = await supabase
            .from("photolangage_attempts")
            .select("id, pedagogical_score, submitted_at, created_at, status")
            .eq("user_id", userId)
            .eq("track", "pa")
            .eq("mode", "exam")
            .eq("status", "submitted")
            .order("submitted_at", { ascending: false })
            .limit(100)
          if (error) throw error
          return (data ?? []) as Row[]
        }, [] as Row[])
      : Promise.resolve([] as Row[])

  const placementPromise = optional("test de niveau", async () => {
    const { data, error } = await supabase
      .from("placement_results")
      .select("score_pct, created_at")
      .eq("user_id", userId)
      .order("created_at", { ascending: false })
      .limit(1)
    if (error) throw error
    const row = (data ?? [])[0] as Row | undefined
    return row ? Math.max(0, Math.min(100, int(row.score_pct))) : null
  }, null as number | null)

  const eventsPromise =
    mode === "exam"
      ? optional("calendrier", async () => {
          const { data, error } = await supabase
            .from("official_competition_events")
            .select("event_type, session_label, date_text, starts_on, ends_on")
            .eq("track", track)
            .eq("is_active", true)
            .order("starts_on", { ascending: true })
          if (error) throw error
          return (data ?? []) as Row[]
        }, [] as Row[])
      : Promise.resolve([] as Row[])

  const [quizRes, answers, psyRows, caseRows, photoRows, placementPercent, eventRows] = await Promise.all([
    quizPromise,
    answersPromise,
    psyPromise,
    casePromise,
    photoPromise,
    placementPromise,
    eventsPromise,
  ])
  if (quizRes.error) throw quizRes.error

  // Réponses par tentative (history_id).
  const byHistory = new Map<string, { answered: number; correct: number }>()
  for (const a of answers) {
    const id = a.history_id == null ? null : String(a.history_id)
    if (!id) continue
    const g = byHistory.get(id) ?? { answered: 0, correct: 0 }
    g.answered++
    if (a.is_correct === true) g.correct++
    byHistory.set(id, g)
  }

  const activities: Activity[] = []
  for (const row of (quizRes.data ?? []) as Row[]) {
    const moduleName = String(row.module_name ?? "").trim()
    const quizName = String(row.quiz_name ?? "").trim()
    const key =
      pathway.id === "gpx_exam"
        ? gpxExamKey(moduleName, quizName)
        : pathway.id === "pa_exam"
          ? paExamKey(moduleName, quizName)
          : pathway.id === "gpx_school"
            ? gpxSchoolKey(quizName || moduleName)
            : paSchoolKey(quizName || moduleName)
    const finishedAt = date(row.finished_at ?? row.completed_at ?? row.started_at)
    if (finishedAt.getFullYear() <= 2000) continue
    const rawCorrect = int(row.correct_count)
    const rawTotal = int(row.total_questions)
    const evidence = byHistory.get(String(row.id))
    // Même règle que l'app : sans réponse enregistrée, un 0 n'est pas un score.
    const correct = evidence ? evidence.correct : rawCorrect
    const total = evidence ? evidence.answered : rawCorrect > 0 ? rawTotal : 0
    const title = mode === "school" ? quizName || moduleName || "Quiz de scolarité" : cleanTitle(quizName || moduleName) || "Quiz"
    activities.push({ id: `quiz:${row.id}`, source: "quiz", moduleKey: key, moduleLabel: metaFor(pathway, key).label, title, correct, total, finishedAt })
  }
  for (const row of psyRows) {
    const finishedAt = date(row.created_at)
    if (finishedAt.getFullYear() <= 2000) continue
    activities.push({
      id: `psy:${row.id}`,
      source: "psy",
      moduleKey: "psychotechnique",
      moduleLabel: metaFor(pathway, "psychotechnique").label,
      title: PSY_TITLES[String(row.exercise_type ?? "")] ?? "Exercice psychotechnique",
      correct: int(row.correct_answers),
      total: int(row.total_questions),
      finishedAt,
    })
  }
  for (const row of caseRows) {
    const finishedAt = date(row.finished_at)
    if (finishedAt.getFullYear() <= 2000) continue
    const c = row.cas_pratique_cases as { title?: string } | null
    activities.push({
      id: `case:${row.id}`,
      source: "case",
      moduleKey: "cas_pratique",
      moduleLabel: metaFor(pathway, "cas_pratique").label,
      title: (c?.title ?? "").trim() || "Cas pratique",
      correct: Math.max(0, Math.min(100, int(row.percent))),
      total: 100,
      finishedAt,
    })
  }
  for (const row of photoRows) {
    const finishedAt = date(row.submitted_at ?? row.created_at)
    if (finishedAt.getFullYear() <= 2000) continue
    activities.push({
      id: `photo:${row.id}`,
      source: "photo",
      moduleKey: "photolangage",
      moduleLabel: metaFor(pathway, "photolangage").label,
      title: "Exercice de photolangage",
      correct: Math.max(0, Math.min(100, int(row.pedagogical_score))),
      total: 100,
      finishedAt,
    })
  }

  return {
    ...compute(activities, pathway),
    placementPercent,
    nextEvent: nextEvent(eventRows),
    upcoming: upcomingEvents(eventRows),
    warnings,
  }
}

/* ─── Calcul (identique à PaExamProgressCalculator.build) ─────────────────── */

function compute(activities: Activity[], pathway: PathwayDefinition) {
  const sorted = [...activities].sort((a, b) => b.finishedAt.getTime() - a.finishedAt.getTime())
  const scored = sorted.filter((a) => a.total > 0)
  let total = 0
  let correct = 0
  for (const a of scored) {
    total += a.total
    correct += Math.max(0, Math.min(a.correct, a.total))
  }

  const today = day(new Date())
  const counts = new Map<string, number>()
  for (const a of scored) {
    const k = dayKey(day(a.finishedAt))
    counts.set(k, (counts.get(k) ?? 0) + 1)
  }
  const week = Array.from({ length: 7 }, (_, i) => {
    const d = new Date(today)
    d.setDate(today.getDate() - (6 - i))
    return { day: d, count: counts.get(dayKey(d)) ?? 0 }
  })

  // Lundi de la semaine en cours.
  const startOfWeek = new Date(today)
  startOfWeek.setDate(today.getDate() - ((today.getDay() + 6) % 7))
  const doneThisWeek = scored.filter((a) => a.finishedAt >= startOfWeek).length

  // Série : aujourd'hui ou hier, puis jours consécutifs.
  let streakDays = 0
  const cursor = new Date(today)
  if (!counts.has(dayKey(cursor))) cursor.setDate(cursor.getDate() - 1)
  while (counts.has(dayKey(cursor))) {
    streakDays++
    cursor.setDate(cursor.getDate() - 1)
  }

  // Matières.
  const grouped = new Map<string, Activity[]>()
  for (const a of scored) grouped.set(a.moduleKey, [...(grouped.get(a.moduleKey) ?? []), a])
  const subjects: Subject[] = [...grouped.entries()].map(([key, list]) => {
    let t = 0
    let c = 0
    for (const a of list) {
      t += a.total
      c += Math.max(0, Math.min(a.correct, a.total))
    }
    const meta = metaFor(pathway, key)
    return {
      key,
      label: meta.label,
      color: meta.color,
      activities: list.length,
      correct: c,
      total: t,
      averagePercent: pct(c, t),
      lastPercent: pct(list[0].correct, list[0].total),
      lastActivityAt: list[0].finishedAt,
    }
  })
  subjects.sort((a, b) => a.averagePercent - b.averagePercent)

  let recommendation: HomeSnapshot["recommendation"] = null
  if (subjects.length) {
    const reliable = subjects.filter((s) => s.total >= 10)
    const pool = [...(reliable.length ? reliable : subjects)].sort(
      (a, b) => a.averagePercent - b.averagePercent || a.lastActivityAt.getTime() - b.lastActivityAt.getTime(),
    )
    const s = pool[0]
    recommendation = {
      subject: s,
      reason:
        s.total < 10
          ? "Encore peu de données : quelques exercices supplémentaires permettront de préciser ton niveau."
          : s.averagePercent < 60
            ? `C’est actuellement ta matière la moins maîtrisée (${s.averagePercent} % de moyenne).`
            : "C’est la matière qui offre aujourd’hui la meilleure marge de progression.",
    }
  }

  return {
    globalPercent: pct(correct, total),
    totalQuestions: total,
    totalCorrect: correct,
    totalActivities: scored.length,
    streakDays,
    doneToday: counts.get(dayKey(today)) ?? 0,
    doneThisWeek,
    week,
    subjects,
    recommendation,
    recent: sorted.slice(0, 4),
  }
}

const EVENT_LABEL: Record<string, string> = {
  registration: "Inscriptions",
  written: "Épreuves écrites",
  sport: "Épreuves sportives",
  oral: "Épreuves orales",
  other: "Épreuves orales",
  result: "Résultats",
}

function parseEvents(rows: Row[]): CompetitionEvent[] {
  return rows.map((r) => ({
    type: String(r.event_type ?? ""),
    typeLabel: EVENT_LABEL[String(r.event_type ?? "")] ?? "Échéance",
    session: String(r.session_label ?? ""),
    dateText: String(r.date_text ?? ""),
    startsOn: r.starts_on ? new Date(`${r.starts_on}T00:00:00`) : null,
    endsOn: r.ends_on ? new Date(`${r.ends_on}T00:00:00`) : null,
  }))
}

/** Échéances encore à venir (ou en cours), dans l'ordre chronologique. */
function upcomingEvents(rows: Row[]): CompetitionEvent[] {
  const today = day(new Date())
  return parseEvents(rows)
    .filter((e) => (e.endsOn ?? e.startsOn) && (e.endsOn ?? e.startsOn)! >= today)
    .sort((a, b) => (a.startsOn?.getTime() ?? 0) - (b.startsOn?.getTime() ?? 0))
}

/** Prochaine échéance officielle : une épreuve à venir en priorité, sinon une clôture d'inscriptions. */
function nextEvent(rows: Row[]): CompetitionEvent | null {
  const today = day(new Date())
  const events = parseEvents(rows)
  const exams = events
    .filter((e) => e.type !== "registration" && e.type !== "result" && e.startsOn && e.startsOn >= today)
    .sort((a, b) => a.startsOn!.getTime() - b.startsOn!.getTime())
  if (exams[0]) return exams[0]
  const regs = events
    .filter((e) => e.type === "registration" && e.endsOn && e.endsOn >= today)
    .sort((a, b) => a.endsOn!.getTime() - b.endsOn!.getTime())
  return regs[0] ?? null
}

export function daysUntil(d: Date) {
  const ms = day(d).getTime() - day(new Date()).getTime()
  return Math.round(ms / 86400000)
}
