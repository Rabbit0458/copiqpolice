export type ReportKind =
  | "cas_pratique"
  | "question"
  | "culture"
  | "psy"
  | "bug"
  | "contact"
  | "forum"

export type TargetIdKind = "bigint" | "uuid" | "text" | "none"

export type ReportTargetDefinition = {
  reportKind: ReportKind
  reportTable: string
  targetTable: string | null
  targetIdColumn: string | null
  targetIdKind: TargetIdKind
  editor: "practical-case" | "quiz" | "psychotechnique" | "bug" | "contact" | "forum" | "unresolved"
  editable: boolean
  deletable: boolean
  reason?: string
}

/**
 * Liste blanche des tables accessibles depuis un signalement.
 *
 * Aucun nom de table provenant d'une ligne utilisateur ne doit être utilisé
 * directement dans une requête. Toute résolution passe par ce registre.
 */
export const REPORT_TARGETS: Record<ReportKind, ReportTargetDefinition> = {
  cas_pratique: {
    reportKind: "cas_pratique",
    reportTable: "cas_pratique_question_reports",
    targetTable: "cas_pratique_questions",
    targetIdColumn: "question_id",
    targetIdKind: "uuid",
    editor: "practical-case",
    editable: true,
    deletable: true,
  },
  question: {
    reportKind: "question",
    reportTable: "report_question",
    targetTable: null,
    targetIdColumn: null,
    targetIdKind: "none",
    editor: "unresolved",
    editable: false,
    deletable: false,
    reason: "Le schéma versionné de report_question ne contient pas de question_id.",
  },
  culture: {
    reportKind: "culture",
    reportTable: "report_culture_generale",
    targetTable: "quiz_questions",
    targetIdColumn: "question_id",
    targetIdKind: "bigint",
    editor: "quiz",
    editable: true,
    deletable: true,
  },
  psy: {
    reportKind: "psy",
    reportTable: "tests_psycotechnique_report",
    targetTable: null,
    targetIdColumn: "question_id",
    targetIdKind: "text",
    editor: "psychotechnique",
    editable: true,
    deletable: true,
    reason: "La table cible est résolue par la liste blanche des catégories psychotechniques.",
  },
  bug: {
    reportKind: "bug",
    reportTable: "bug_reports",
    targetTable: "bug_reports",
    targetIdColumn: "id",
    targetIdKind: "bigint",
    editor: "bug",
    editable: true,
    deletable: false,
  },
  contact: {
    reportKind: "contact",
    reportTable: "contact_messages",
    targetTable: "contact_messages",
    targetIdColumn: "id",
    targetIdKind: "bigint",
    editor: "contact",
    editable: true,
    deletable: false,
  },
  forum: {
    reportKind: "forum",
    reportTable: "community_reports",
    targetTable: null,
    targetIdColumn: "target_id",
    targetIdKind: "uuid",
    editor: "forum",
    editable: true,
    deletable: false,
    reason: "La cible dépend du target_type et doit passer par les RPC de modération communautaire.",
  },
}

export const PSYCHOTECHNIQUE_TARGET_TABLES = {
  attention_visuelle: "tests_psyco_attention_visuelle",
  calcul_mental: "tests_psyco_calcul_mental",
  concentration: "tests_psyco_concentration",
  logique_verbale: "tests_psyco_logique_verbale",
  raisonnement_logique: "tests_psyco_raisonnement_logique",
  raisonnement_spatial: "tests_psyco_raisonnement_spatial",
  rotations_symetries: "tests_psyco_rotations_symetries",
  suite_logique: "tests_psyco_suite_logique",
  // Valeur historique encore envoyée par l'écran PA Exam.
  suites_logiques: "tests_psyco_suite_logique",
} as const

export type PsychotechniqueCategory = keyof typeof PSYCHOTECHNIQUE_TARGET_TABLES

const REPORT_KIND_ALIASES: Record<string, ReportKind> = {
  cas_pratique: "cas_pratique",
  question: "question",
  culture: "culture",
  cg: "culture",
  psy: "psy",
  psychotechnique: "psy",
  pa_psychotechnique: "psy",
  bug: "bug",
  contact: "contact",
  forum: "forum",
}

export function normalizeReportKind(value: unknown): ReportKind | null {
  if (typeof value !== "string") return null
  return REPORT_KIND_ALIASES[value.trim().toLowerCase()] ?? null
}

export function resolvePsychotechniqueTable(category: unknown): string | null {
  if (typeof category !== "string") return null
  const normalized = category.trim().toLowerCase() as PsychotechniqueCategory
  return PSYCHOTECHNIQUE_TARGET_TABLES[normalized] ?? null
}

export function resolveReportTarget(input: {
  kind: unknown
  category?: unknown
}): ReportTargetDefinition | null {
  const kind = normalizeReportKind(input.kind)
  if (!kind) return null

  const base = REPORT_TARGETS[kind]
  if (kind !== "psy") return base

  const targetTable = resolvePsychotechniqueTable(input.category)
  if (!targetTable) {
    return {
      ...base,
      editable: false,
      deletable: false,
      reason: "Catégorie psychotechnique inconnue : aucune table ne sera interrogée.",
    }
  }

  return { ...base, targetTable }
}

