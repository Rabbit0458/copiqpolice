import type { SupabaseClient } from "@supabase/supabase-js"
import type { PathwayDefinition } from "@/config/pathways"

/**
 * Sessions d'entraînement jouées sur le site — synchronisées avec l'application.
 *
 * Contrat d'écriture identique à l'app Flutter
 * (pa_quiz_culture_generale_*.dart + learning_answer_history_service.dart) :
 *  1. une ligne `quiz_history` par tentative (créée à la première réponse,
 *     puis mise à jour à la fin ou à l'abandon) ;
 *  2. chaque réponse passe par la RPC `record_learning_answer`
 *     (idempotente grâce à `p_client_event_id`).
 * Les noms de module et de quiz suivent ceux de l'app, si bien que la
 * progression calculée (features/home/progress.ts) range la session dans la
 * bonne matière, sur le site comme dans l'application.
 */

export type SessionQuestion = {
  id: string
  question: string
  options: string[]
  answer: string
  explanation: string
  difficulty: string | null
  /** Catégorie (concours) ou module (scolarité) : clé envoyée à l'app. */
  sourceKey: string
  sourceLabel: string
}

export type SessionTheme = {
  key: string
  label: string
  /** Catégories `quiz_questions` (concours) ; vide pour la scolarité. */
  categories: string[]
  /** Suffixe du nom de quiz, comme dans l'app (« Quiz culture générale géographie »). */
  quizSuffix: string
  hint: string
  /** Module `quiz_scolarite_questions` (scolarité). */
  module?: string
  group?: string
  /** Noms écrits dans quiz_history, repris tels quels de l'app quand ils sont connus. */
  names?: { moduleName: string; quizName: string; quizKey: string }
}

export type Difficulty = "Facile" | "Moyenne" | "Difficile"

export type SessionPlan = {
  theme: SessionTheme
  count: number
  kind: "exam" | "school"
  express?: boolean
  /** Niveau choisi (comme l'écran « Sélectionne le niveau » de l'app) ; absent = mélange des 3. */
  difficulty?: Difficulty | null
}

type Row = Record<string, unknown>

/* ─── Concours : culture générale (`quiz_questions`) ──────────────────────── */

const CATEGORY_LABEL: Record<string, string> = {
  Geographie: "Géographie",
  France: "Histoire de France",
  Actualite: "Actualité",
  Institutions: "Institutions",
  Sciences: "Sciences",
  Sante: "Santé",
  Mythologie: "Mythologie",
  Cinema: "Cinéma",
  Musique: "Musique",
  Police: "Police",
  Securite: "Sécurité",
  Droit: "Droit",
  Sport: "Sport",
}

const MIX = ["Geographie", "France", "Actualite", "Institutions", "Sciences", "Sante", "Mythologie", "Cinema", "Musique"]

export const EXAM_THEMES: SessionTheme[] = [
  { key: "mix", label: "Session mixte", categories: MIX, quizSuffix: "mixte", hint: "Un peu de tout, comme le jour J" },
  { key: "Geographie", label: "Géographie", categories: ["Geographie"], quizSuffix: "géographie", hint: "Pays, capitales, reliefs" },
  { key: "France", label: "Histoire de France", categories: ["France"], quizSuffix: "France", hint: "Dates et grandes figures" },
  { key: "Actualite", label: "Actualité", categories: ["Actualite"], quizSuffix: "actualité", hint: "Les faits qui comptent" },
  { key: "Institutions", label: "Institutions", categories: ["Institutions"], quizSuffix: "institutions", hint: "République et pouvoirs publics" },
  { key: "Sciences", label: "Sciences", categories: ["Sciences"], quizSuffix: "sciences", hint: "Physique, vivant, techniques" },
  { key: "Sante", label: "Santé", categories: ["Sante"], quizSuffix: "santé", hint: "Corps humain et secours" },
  { key: "Police", label: "Police & sécurité", categories: ["Police", "Securite", "Droit"], quizSuffix: "police", hint: "Services, missions, droit" },
  { key: "Mythologie", label: "Mythologie", categories: ["Mythologie"], quizSuffix: "mythologie", hint: "Dieux, héros, légendes" },
  { key: "Cinema", label: "Cinéma", categories: ["Cinema"], quizSuffix: "cinéma", hint: "Films et réalisateurs" },
  { key: "Musique", label: "Musique", categories: ["Musique"], quizSuffix: "musique", hint: "Œuvres et artistes" },
  { key: "Sport", label: "Sport", categories: ["Sport"], quizSuffix: "sport", hint: "Compétitions et records" },
]

function shuffle<T>(list: T[]): T[] {
  const a = [...list]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

function toOptions(raw: unknown): string[] {
  const list = Array.isArray(raw) ? raw : typeof raw === "string" ? safeJson(raw) : []
  return (Array.isArray(list) ? list : []).map((o) => String(o ?? "").trim()).filter(Boolean)
}

function safeJson(s: string): unknown {
  try {
    return JSON.parse(s)
  } catch {
    return []
  }
}

function toQuestion(row: Row, sourceKey: string, sourceLabel: string): SessionQuestion | null {
  const options = toOptions(row.options)
  const answer = String(row.answer ?? "").trim()
  const question = String(row.question ?? "").trim()
  if (!question || options.length < 2 || !options.includes(answer)) return null
  return {
    id: String(row.id),
    question,
    options,
    answer,
    explanation: String(row.explanation ?? "").trim(),
    difficulty: row.difficulty ? String(row.difficulty) : null,
    sourceKey,
    sourceLabel,
  }
}

const QUESTION_COLUMNS = "id, category, question, options, answer, explanation, difficulty"

/** Tirage aléatoire par `rand_key` (même méthode que l'app : seuil puis bouclage). */
async function sampleCategory(supabase: SupabaseClient, category: string, count: number, seed = Math.random(), difficulty: Difficulty | null = null): Promise<Row[]> {
  // Même requête que l'app : filtre sur la catégorie (et le niveau), sans filtre de module.
  const base = () => {
    const q = supabase.from("quiz_questions").select(QUESTION_COLUMNS).eq("category", category)
    return difficulty ? q.eq("difficulty", difficulty) : q
  }
  const first = await base().gte("rand_key", seed).order("rand_key", { ascending: true }).limit(count)
  if (first.error) throw first.error
  const rows = (first.data ?? []) as Row[]
  if (rows.length >= count) return rows
  const wrap = await base().lt("rand_key", seed).order("rand_key", { ascending: true }).limit(count - rows.length)
  if (wrap.error) throw wrap.error
  return [...rows, ...((wrap.data ?? []) as Row[])]
}

export async function loadExamQuestions(supabase: SupabaseClient, theme: SessionTheme, count: number, difficulty: Difficulty | null = null): Promise<SessionQuestion[]> {
  // Répartition des questions entre les catégories du thème.
  const wanted = new Map<string, number>()
  for (let i = 0; i < count; i++) {
    const c = theme.categories.length === 1 ? theme.categories[0] : theme.categories[Math.floor(Math.random() * theme.categories.length)]
    wanted.set(c, (wanted.get(c) ?? 0) + 1)
  }
  const batches = await Promise.all(
    [...wanted.entries()].map(async ([category, n]) => {
      // Une marge pour écarter une éventuelle question mal formée.
      let rows = await sampleCategory(supabase, category, n + 2, Math.random(), difficulty)
      // Niveau peu fourni dans une catégorie : on complète avec les autres niveaux.
      if (difficulty && rows.length < n) rows = [...rows, ...(await sampleCategory(supabase, category, n + 2 - rows.length))]
      return rows
        .map((r) => toQuestion(r, category, CATEGORY_LABEL[category] ?? category))
        .filter((q): q is SessionQuestion => q !== null)
        .slice(0, n)
    }),
  )
  const seen = new Set<string>()
  const out = shuffle(batches.flat()).filter((q) => (seen.has(q.id) ? false : (seen.add(q.id), true)))
  if (out.length === 0) throw new Error("Aucune question disponible pour ce thème.")
  return out.slice(0, count)
}

/* ─── Scolarité (`quiz_scolarite_questions`) ─────────────────────────────── */

const ACCENTS: Record<string, string> = {
  delits: "délits", penale: "pénale", penal: "pénal", integrite: "intégrité", personnalite: "personnalité",
  dignite: "dignité", generalite: "généralités", libertes: "libertés", enquete: "enquête", preliminaire: "préliminaire",
  detention: "détention", legitime: "légitime", defense: "défense", hierarchie: "hiérarchie", probite: "probité",
  autorite: "autorité", nullite: "nullité", criminalite: "criminalité", organisee: "organisée", inquietantes: "inquiétantes",
  degradations: "dégradations", peril: "péril", deontologie: "déontologie", responsabilite: "responsabilité",
  retention: "rétention", electronique: "électronique", controle: "contrôle", identite: "identité", routiere: "routière",
  stad: "STAD", jaf: "JAF", complicite: "complicité", pluralite: "pluralité", stupefiants: "stupéfiants",
  securite: "sécurité", procedure: "procédure", ordonnances: "ordonnances", publiques: "publiques",
}

/** « Quiz Crimes Delits Bien.dart » → « Crimes délits bien ». */
export function prettyModuleTitle(title: string) {
  const raw = title.trim()
  if (!/\.dart$/i.test(raw)) return raw
  const words = raw
    .replace(/\.dart$/i, "")
    .replace(/^(Gpx|Pa)\s+/i, "")
    .replace(/^Quiz\s+/i, "")
    .replace(/\s+Pages?$/i, "")
    .split(/\s+/)
    .map((w) => ACCENTS[w.toLowerCase()] ?? w.toLowerCase())
  const text = words.join(" ")
  return text.charAt(0).toUpperCase() + text.slice(1)
}

/** Famille du module : sert à classer la session dans la bonne matière (règles de l'app). */
export function moduleGroup(module: string) {
  const m = module.toLowerCase()
  if (m.includes("institution")) return "Institution"
  if (m.includes("circulation") || m.includes("routier")) return "Circulation routière"
  if (m.includes("intervention")) return "Intervention"
  if (m.includes("_dh_")) return "Dimension humaine"
  return "Droit pénal"
}

export async function loadSchoolThemes(supabase: SupabaseClient, track: string): Promise<SessionTheme[]> {
  const { data, error } = await supabase
    .from("quiz_scolarite_modules")
    .select("module, title, sort_order")
    .eq("track", track)
    .eq("is_active", true)
    .order("sort_order", { ascending: true })
  if (error) throw error
  const seen = new Set<string>()
  const out: SessionTheme[] = []
  for (const row of (data ?? []) as Row[]) {
    const moduleKey = String(row.module ?? "")
    if (!moduleKey.startsWith(`${track}_`)) continue
    const label = prettyModuleTitle(String(row.title ?? moduleKey))
    const k = label.toLowerCase()
    if (seen.has(k)) continue
    seen.add(k)
    const group = moduleGroup(moduleKey)
    out.push({ key: moduleKey, label, categories: [], quizSuffix: label, hint: group, module: moduleKey, group })
  }
  return out
}

export async function loadSchoolQuestions(supabase: SupabaseClient, theme: SessionTheme, count: number, difficulty: Difficulty | null = null): Promise<SessionQuestion[]> {
  const moduleKey = theme.module ?? theme.key
  const base = () =>
    supabase
      .from("quiz_scolarite_questions")
      .select("id, module, question, options, answer, explanation, difficulty, position")
      .eq("module", moduleKey)
      .eq("is_active", true)
      .eq("publication_status", "published")
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const withLevel = (q: any) => (difficulty ? q.eq("difficulty", difficulty) : q)
  const head = await withLevel(
    supabase
      .from("quiz_scolarite_questions")
      .select("id", { count: "exact", head: true })
      .eq("module", moduleKey)
      .eq("is_active", true)
      .eq("publication_status", "published"),
  )
  if (head.error) throw head.error
  const total = head.count ?? 0
  if (total === 0) throw new Error("Aucune question disponible pour ce module.")
  const window = Math.min(total, Math.max(count * 4, 30))
  const offset = Math.floor(Math.random() * Math.max(1, total - window + 1))
  const { data, error } = await withLevel(base()).order("position", { ascending: true }).range(offset, offset + window - 1)
  if (error) throw error
  const list = shuffle(((data ?? []) as Row[]).map((r) => toQuestion(r, moduleKey, theme.label)).filter((q): q is SessionQuestion => q !== null))
  if (list.length === 0) throw new Error("Aucune question disponible pour ce module.")
  return list.slice(0, count)
}

export function loadQuestions(supabase: SupabaseClient, plan: SessionPlan) {
  return plan.kind === "exam"
    ? loadExamQuestions(supabase, plan.theme, plan.count, plan.difficulty ?? null)
    : loadSchoolQuestions(supabase, plan.theme, plan.count, plan.difficulty ?? null)
}

/* ─── Question du jour ────────────────────────────────────────────────────── */

export function todayKey(d = new Date()) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`
}

function hashSeed(s: string) {
  let h = 2166136261
  for (let i = 0; i < s.length; i++) {
    h ^= s.charCodeAt(i)
    h = Math.imul(h, 16777619)
  }
  return (h >>> 0) / 4294967296
}

/** Même question pour tout le monde, chaque jour, selon le parcours. */
export async function loadQuestionOfTheDay(supabase: SupabaseClient, pathway: PathwayDefinition, schoolThemes: SessionTheme[]): Promise<SessionQuestion | null> {
  const key = `${todayKey()}:${pathway.id}`
  const seed = hashSeed(key)
  if (pathway.mode === "exam") {
    const category = MIX[Math.floor(seed * MIX.length)]
    const rows = await sampleCategory(supabase, category, 3, hashSeed(`${key}:q`))
    for (const r of rows) {
      const q = toQuestion(r, category, CATEGORY_LABEL[category] ?? category)
      if (q) return q
    }
    return null
  }
  if (schoolThemes.length === 0) return null
  const theme = schoolThemes[Math.floor(seed * schoolThemes.length)]
  const { data, error } = await supabase
    .from("quiz_scolarite_questions")
    .select("id, module, question, options, answer, explanation, difficulty, position")
    .eq("module", theme.module ?? theme.key)
    .eq("is_active", true)
    .eq("publication_status", "published")
    .order("position", { ascending: true })
    .limit(40)
  if (error) throw error
  const list = ((data ?? []) as Row[]).map((r) => toQuestion(r, theme.key, theme.label)).filter((q): q is SessionQuestion => q !== null)
  return list.length ? list[Math.floor(hashSeed(`${key}:s`) * list.length)] : null
}

/* ─── Enregistrement synchronisé avec l'app ───────────────────────────────── */

export type SyncState = "idle" | "saving" | "saved" | "error"

export class SessionRecorder {
  private historyId: number | null = null
  private creating: Promise<number | null> | null = null
  private readonly startedAt = new Date().toISOString()
  private pending = new Set<Promise<unknown>>()
  failed = false

  constructor(
    private readonly supabase: SupabaseClient,
    private readonly meta: { userId: string; email: string | null; pathway: PathwayDefinition; plan: SessionPlan; total: number },
  ) {}

  private get names() {
    const { pathway, plan } = this.meta
    if (plan.theme.names) return plan.theme.names
    if (plan.kind === "exam") {
      const prefix = pathway.track === "pa" ? "PA - " : ""
      return {
        moduleName: `${prefix}Culture générale`,
        quizName: `${prefix}Quiz culture générale ${plan.theme.quizSuffix}`,
        quizKey: `${pathway.track}_web_culture_generale_${plan.theme.key.toLowerCase()}`,
      }
    }
    return {
      moduleName: plan.theme.label,
      quizName: `${plan.theme.group ?? moduleGroup(plan.theme.key)} · ${plan.theme.label}`,
      quizKey: plan.theme.module ?? plan.theme.key,
    }
  }

  /** Crée la tentative à la première réponse (aucune ligne vide si l'on quitte sans jouer). */
  private ensure(): Promise<number | null> {
    if (this.historyId !== null) return Promise.resolve(this.historyId)
    if (this.creating) return this.creating
    const { userId, email, pathway, total } = this.meta
    const { moduleName, quizName } = this.names
    this.creating = (async () => {
      const { data, error } = await this.supabase
        .from("quiz_history")
        .insert({
          uid: userId,
          email,
          module_name: moduleName,
          quiz_name: quizName,
          score: 0,
          correct_count: 0,
          total_questions: total,
          mode: pathway.mode,
          track: pathway.track,
          started_at: this.startedAt,
          finished_at: this.startedAt,
          completed_at: null,
        })
        .select("id")
        .single()
      if (error) throw error
      this.historyId = Number((data as { id: number }).id)
      return this.historyId
    })()
    this.creating.catch(() => {
      this.creating = null
    })
    return this.creating
  }

  private track<T>(p: Promise<T>) {
    this.pending.add(p)
    p.finally(() => this.pending.delete(p)).catch(() => undefined)
    return p
  }

  async answer(q: SessionQuestion, userAnswer: string, responseMs: number, position: number) {
    const { pathway } = this.meta
    const run = (async () => {
      const historyId = await this.ensure()
      const { error } = await this.supabase.rpc("record_learning_answer", {
        p_history_id: historyId,
        p_track: pathway.track,
        p_mode: pathway.mode,
        p_module_key: q.sourceKey,
        p_quiz_key: this.names.quizKey,
        p_question_id: `${q.sourceKey}:${q.id}`,
        p_question_text: q.question,
        p_options: q.options,
        p_user_answer: userAnswer,
        p_correct_answer: q.answer,
        p_is_correct: userAnswer === q.answer,
        p_explanation: q.explanation || null,
        p_difficulty: q.difficulty,
        p_response_time_ms: Math.max(0, Math.round(responseMs)),
        p_question_position: position,
        p_client_event_id: crypto.randomUUID(),
        p_question_version: null,
      })
      if (error) throw error
    })()
    try {
      await this.track(run)
    } catch (e) {
      this.failed = true
      throw e
    }
  }

  /** Clôture la tentative (fin de session ou abandon après au moins une réponse). */
  async finish(answered: number, correct: number) {
    await Promise.allSettled([...this.pending])
    if (answered <= 0) return
    const historyId = this.historyId ?? (await this.ensure().catch(() => null))
    if (historyId === null) {
      this.failed = true
      return
    }
    const now = new Date().toISOString()
    const { error } = await this.supabase
      .from("quiz_history")
      .update({
        total_questions: answered,
        score: Math.round((correct / answered) * 100),
        correct_count: correct,
        finished_at: now,
        completed_at: now,
        mode: this.meta.pathway.mode,
        track: this.meta.pathway.track,
      })
      .eq("id", historyId)
      .eq("uid", this.meta.userId)
    if (error) {
      this.failed = true
      throw error
    }
  }
}
