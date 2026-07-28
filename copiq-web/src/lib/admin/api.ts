/**
 * COP'IQ — Panel administrateur : couche d'accès aux données.
 *
 * ⚠️ PRINCIPE DE SÉCURITÉ
 * Le site est exporté en statique (`output: "export"`), donc **aucun code
 * serveur ne tourne**. Toute la sécurité repose sur PostgreSQL :
 *   1. Les RPC `cp_admin_*` sont `SECURITY DEFINER` et appellent `cp_admin_guard()`
 *      qui vérifie `has_admin_permission('cas_pratiques')` + le niveau AAL2 (2FA).
 *   2. Les tables sensibles sont protégées par RLS.
 * Ce fichier ne fait donc qu'appeler des RPC : il n'accorde aucun droit.
 * Un utilisateur qui bricolerait le JavaScript ne gagnerait rien.
 */

import { createClient } from "@/lib/supabase/client"

/* ────────────────────────────────────────────────────────────────────────── */
/*  Types                                                                     */
/* ────────────────────────────────────────────────────────────────────────── */

export type AdminRole = "owner" | "superadmin" | "admin" | "moderator"

export interface AdminSession {
  ok: boolean
  reason?: "no_session" | "not_admin" | "disabled" | "locked" | "expired"
  until?: string
  admin_id?: string
  email?: string
  role?: AdminRole
  permissions?: Record<string, boolean>
  totp_enrolled?: boolean
  aal?: "aal1" | "aal2"
  code_required?: boolean
}

export interface CpDashboard {
  themes: number
  cases_total: number
  cases_published: number
  questions: number
  rubric_points: number
  keywords: number
  perfect_answers: number
  attempts_total: number
  attempts_done: number
  avg_percent: number | null
  appeals_pending: number
  appeals_total: number
  cases_sans_rubric: number
  questions_sans_modele: number
}

export interface CpCaseRow {
  id: string
  slug: string
  title: string
  year: number | null
  month: string | null
  difficulty: string | null
  theme_slug: string | null
  theme_label: string | null
  status: "draft" | "published" | "archived"
  is_free: boolean
  total_points: number | null
  expected_minutes: number | null
  nb_questions: number
  nb_rubric_points: number
  nb_perfect: number
  nb_attempts: number
  avg_percent: number | null
  updated_at: string | null
}

export interface CpKeyword {
  id: string
  value: string
  is_phrase: boolean
  is_negation: boolean
  fuzzy_max_dist: number
  auto_added: boolean
}
export interface CpGroup {
  id: string
  position: number
  description: string | null
  is_optional: boolean
  keywords: CpKeyword[]
}
export interface CpRubricPoint {
  id: string
  position: number
  label: string
  weight: number
  is_required: boolean
  kind: "core" | "bonus"
  explanation_md: string | null
  groups: CpGroup[]
}
export interface CpQuestion {
  id: string
  position: number
  label: string
  hint: string | null
  max_points: number
  char_min: number | null
  char_recommended: number | null
  perfect_answer: { body_md: string; references_legal: string[] } | null
  rubric_points: CpRubricPoint[]
}
export interface CpCaseDetail {
  case: Record<string, unknown> & {
    id: string
    slug: string
    title: string
    situation_md: string | null
    theme_slug: string | null
    theme_label: string | null
    status: string
  }
  questions: CpQuestion[]
  error?: string
}

export interface CpAppeal {
  id: string
  created_at: string
  status: "pending" | "approved" | "rejected"
  message: string | null
  admin_response: string | null
  user_email: string | null
  case_slug: string | null
  case_title: string | null
  question_label: string | null
  point_label: string | null
  point_id: string | null
  user_answer: string | null
}

export interface CpHealthRow {
  gravite: "critique" | "important" | "mineur"
  objet: string
  probleme: string
  action: string
}

export interface CpTheme {
  id: string
  slug: string
  label: string
  color_hex: string | null
  icon: string | null
  sort_order: number | null
  nb_cases: number
}

/** Spécification d'une grille de correction (même format que les migrations). */
export interface RubricSpec {
  case: string
  q: number
  perfect?: string
  refs?: string[]
  points: {
    label: string
    weight?: number
    kind?: "core" | "bonus"
    required?: boolean
    expl?: string
    /** Tableau de groupes. ET entre groupes, OU à l'intérieur d'un groupe. */
    groups: string[][]
  }[]
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Helper d'appel RPC                                                        */
/* ────────────────────────────────────────────────────────────────────────── */

export class AdminApiError extends Error {
  constructor(
    message: string,
    readonly code?: string,
  ) {
    super(message)
    this.name = "AdminApiError"
  }
}

async function rpc<T>(fn: string, args: Record<string, unknown> = {}): Promise<T> {
  const supabase = createClient()
  const { data, error } = await supabase.rpc(fn as never, args as never)
  if (error) {
    // 42501 = permission refusée côté PostgreSQL (garde admin)
    const denied =
      error.code === "42501" || /acc[eè]s refus[eé]/i.test(error.message ?? "")
    throw new AdminApiError(
      denied
        ? error.message
        : `Erreur ${fn} : ${error.message ?? "inconnue"}`,
      error.code,
    )
  }
  return data as T
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Session & authentification                                                */
/* ────────────────────────────────────────────────────────────────────────── */

export const adminAuth = {
  /** État complet de l'admin connecté (rôle, permissions, 2FA, AAL). */
  status: () => rpc<AdminSession>("admin_mfa_status"),

  /** Vérifie le code staff (PIN) — comparé à un hash bcrypt côté base. */
  verifyPanelCode: (code: string) =>
    rpc<{ ok: boolean; message: string }>("verify_admin_panel_code_simple", {
      p_code: code,
    }),

  async signIn(email: string, password: string) {
    const supabase = createClient()
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) throw new AdminApiError(error.message)
  },

  async signOut() {
    const supabase = createClient()
    await supabase.auth.signOut()
  },

  /* ── MFA TOTP (Google Authenticator) ─────────────────────────────────── */

  async listFactors() {
    const supabase = createClient()
    const { data, error } = await supabase.auth.mfa.listFactors()
    if (error) throw new AdminApiError(error.message)
    return data
  },

  /** Démarre l'enrôlement : renvoie le QR code à scanner + le secret. */
  async enrollTotp() {
    const supabase = createClient()
    const { data, error } = await supabase.auth.mfa.enroll({
      factorType: "totp",
      friendlyName: `COP'IQ Admin — ${new Date().toLocaleDateString("fr-FR")}`,
    })
    if (error) throw new AdminApiError(error.message)
    return data
  },

  /** Valide un code à 6 chiffres (enrôlement OU connexion) → passe en AAL2. */
  async verifyTotp(factorId: string, code: string) {
    const supabase = createClient()
    const { data: ch, error: e1 } = await supabase.auth.mfa.challenge({ factorId })
    if (e1) throw new AdminApiError(e1.message)
    const { error: e2 } = await supabase.auth.mfa.verify({
      factorId,
      challengeId: ch.id,
      code,
    })
    if (e2) throw new AdminApiError("Code invalide ou expiré.")
    return true
  },

  async unenrollTotp(factorId: string) {
    const supabase = createClient()
    const { error } = await supabase.auth.mfa.unenroll({ factorId })
    if (error) throw new AdminApiError(error.message)
  },
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Module Cas Pratique                                                       */
/* ────────────────────────────────────────────────────────────────────────── */

export const casPratiqueApi = {
  dashboard: () => rpc<CpDashboard>("cp_admin_dashboard"),

  health: () => rpc<CpHealthRow[]>("cp_admin_health"),

  listThemes: () => rpc<CpTheme[]>("cp_admin_list_themes"),

  upsertTheme: (data: Partial<CpTheme>) =>
    rpc<{ ok: boolean; id: string }>("cp_admin_upsert_theme", { p_data: data }),

  listCases: (opts: {
    search?: string
    status?: string
    theme?: string
    limit?: number
    offset?: number
  } = {}) =>
    rpc<CpCaseRow[]>("cp_admin_list_cases", {
      p_search: opts.search || null,
      p_status: opts.status || null,
      p_theme: opts.theme || null,
      p_limit: opts.limit ?? 100,
      p_offset: opts.offset ?? 0,
    }),

  getCase: (slug: string) =>
    rpc<CpCaseDetail>("cp_admin_get_case", { p_slug: slug }),

  upsertCase: (data: Record<string, unknown>) =>
    rpc<{ ok: boolean; id: string; slug: string }>("cp_admin_upsert_case", {
      p_data: data,
    }),

  setStatus: (slug: string, status: "draft" | "published" | "archived") =>
    rpc<{ ok: boolean; status?: string; message?: string }>(
      "cp_admin_set_case_status",
      { p_slug: slug, p_status: status },
    ),

  upsertQuestion: (data: Record<string, unknown>) =>
    rpc<{ ok: boolean; id: string }>("cp_admin_upsert_question", { p_data: data }),

  deleteQuestion: (id: string, reason?: string) =>
    rpc<{ ok: boolean }>("cp_admin_delete_question", {
      p_id: id,
      p_reason: reason ?? null,
    }),

  /** Remplace intégralement la grille de correction d'une question. */
  saveRubric: (spec: RubricSpec) =>
    rpc<{ ok: boolean; message: string }>("cp_admin_save_rubric", {
      p_spec: spec,
    }),

  listAppeals: (status?: string) =>
    rpc<CpAppeal[]>("cp_admin_list_appeals", {
      p_status: status || null,
      p_limit: 200,
      p_offset: 0,
    }),

  /**
   * Traite un appel. Si `keywords` est fourni et le statut est `approved`,
   * les mots-clés sont ajoutés à la grille (marqués `auto_added`) : le moteur
   * les reconnaîtra pour toutes les corrections suivantes.
   */
  resolveAppeal: (
    id: string,
    status: "approved" | "rejected",
    response?: string,
    keywords?: string[],
  ) =>
    rpc<{ ok: boolean; keywords_added: number }>("cp_admin_resolve_appeal", {
      p_id: id,
      p_status: status,
      p_response: response ?? null,
      p_keywords: keywords && keywords.length ? keywords : null,
    }),
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Modules transverses (RPC déjà présentes en base)                          */
/* ────────────────────────────────────────────────────────────────────────── */

/* ────────────────────────────────────────────────────────────────────────── */
/*  Quiz de scolarité (moteur générique)                                      */
/* ────────────────────────────────────────────────────────────────────────── */

export interface QuizModuleRow {
  module: string
  title: string
  subtitle: string | null
  route: string
  color_hex: string
  track: string
  is_active: boolean
  nb_questions: number
  nb_facile: number
  nb_moyenne: number
  nb_difficile: number
  nb_sans_explication: number
}

export interface QuizQuestionRow {
  id: number
  category: string | null
  difficulty: "Facile" | "Moyenne" | "Difficile"
  question: string
  options: string[]
  answer: string
  explanation: string | null
  legal_ref: string | null
  is_active: boolean
  updated_at: string
}

export const quizApi = {
  listModules: () => rpc<QuizModuleRow[]>("quiz_admin_list_modules"),

  listQuestions: (module: string, search?: string) =>
    rpc<QuizQuestionRow[]>("quiz_admin_list_questions", {
      p_module: module,
      p_search: search || null,
    }),

  upsertQuestion: (data: Record<string, unknown>) =>
    rpc<{ ok: boolean; id: number }>("quiz_admin_upsert_question", {
      p_data: data,
    }),

  deleteQuestion: (id: number, reason?: string) =>
    rpc<{ ok: boolean }>("quiz_admin_delete_question", {
      p_id: id,
      p_reason: reason ?? null,
    }),
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Fiches de cours                                                           */
/* ────────────────────────────────────────────────────────────────────────── */

export interface CoursRow {
  id: number
  route: string
  track: string
  module: string
  section: string | null
  code: string | null
  title: string
  subtitle: string | null
  quiz_module: string | null
  is_published: boolean
  taille: number
  updated_at: string
}

export const coursApi = {
  list: (opts: { track?: string; module?: string; search?: string } = {}) =>
    rpc<CoursRow[]>("cours_admin_list", {
      p_track: opts.track || null,
      p_module: opts.module || null,
      p_search: opts.search || null,
    }),

  get: (route: string) =>
    rpc<Record<string, unknown>>("cours_admin_get", { p_route: route }),

  upsert: (data: Record<string, unknown>) =>
    rpc<{ ok: boolean; id: number }>("cours_admin_upsert", { p_data: data }),
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Forum — modération                                                        */
/* ────────────────────────────────────────────────────────────────────────── */

export interface ForumReport {
  id: string
  created_at: string
  status: string
  reason: string | null
  reporter_email: string | null
  post_id: string | null
  post_title: string | null
  post_content: string | null
  post_author_email: string | null
  post_author_id: string | null
  post_created_at: string | null
  post_supprime: boolean
  nb_signalements: number
  auteur_banni: boolean
}

export interface ForumBan {
  user_id: string
  email: string | null
  reason: string | null
  expires_at: string | null
  created_at: string
}

export const forumApi = {
  listReports: (status?: string) =>
    rpc<ForumReport[]>("forum_admin_list_reports", {
      p_status: status || null,
      p_limit: 100,
      p_offset: 0,
    }),

  /**
   * `delete_post` et `delete_and_ban` font un **soft-delete** : le contenu
   * disparaît pour les utilisateurs mais reste consultable en cas de
   * contestation ou de réquisition judiciaire.
   */
  resolveReport: (
    id: string,
    action: "dismiss" | "delete_post" | "delete_and_ban",
    reason?: string,
    banDays?: number | null,
  ) =>
    rpc<{ ok: boolean; post_supprime: boolean; auteur_banni: boolean }>(
      "forum_admin_resolve_report",
      {
        p_id: id,
        p_action: action,
        p_reason: reason ?? null,
        p_ban_days: banDays ?? null,
      },
    ),

  listBans: () => rpc<ForumBan[]>("forum_admin_list_bans"),

  unban: (userId: string, reason?: string) =>
    rpc<{ ok: boolean; bannissements_leves: number }>("forum_admin_unban", {
      p_user_id: userId,
      p_reason: reason ?? null,
    }),
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Notes de patch                                                            */
/* ────────────────────────────────────────────────────────────────────────── */

export interface PatchNote {
  id: number
  title: string
  body: string
  is_published: boolean
  created_at: string
  author_email: string | null
}

export const patchNotesApi = {
  list: (published?: "yes" | "no") =>
    rpc<PatchNote[]>("list_patch_notes", {
      p_published: published ?? null,
      p_limit: 100,
    }),

  create: (title: string, body: string, published = false) =>
    rpc<Record<string, unknown>>("create_patch_note", {
      p_title: title,
      p_body: body,
      p_published: published,
    }),

  setPublished: (id: number, published: boolean) =>
    rpc<Record<string, unknown>>("set_patch_note_published", {
      p_id: id,
      p_published: published,
    }),

  remove: (id: number) =>
    rpc<Record<string, unknown>>("delete_patch_note", { p_id: id }),
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Comptes administrateurs                                                   */
/* ────────────────────────────────────────────────────────────────────────── */

export interface AdminStaff {
  id: string
  email: string
  role: AdminRole
  first_name: string | null
  last_name: string | null
  username: string | null
  disabled: boolean
  second_factor_enabled: boolean
  permissions: Record<string, boolean>
  locked_until: string | null
  expires_at: string | null
  failed_admin_code_attempts: number
  last_admin_login_at: string | null
  last_admin_login_ip: string | null
  notes: string | null
  created_at: string
  updated_at: string
}

export const staffApi = {
  list: (search?: string, role?: string, status?: string) =>
    rpc<AdminStaff[]>("list_admin_staff", {
      p_search: search || null,
      p_role: role || null,
      p_status: status || null,
      p_limit: 100,
      p_offset: 0,
    }),

  create: (data: {
    email: string
    role: string
    first_name?: string
    last_name?: string
    username?: string
    permissions?: Record<string, boolean>
    expires_at?: string | null
    notes?: string
  }) =>
    rpc<Record<string, unknown>>("create_admin_staff", {
      p_email: data.email,
      p_role: data.role,
      p_first_name: data.first_name ?? null,
      p_last_name: data.last_name ?? null,
      p_username: data.username ?? null,
      p_permissions: data.permissions ?? null,
      p_second_factor_enabled: true,
      p_disabled: false,
      p_expires_at: data.expires_at ?? null,
      p_notes: data.notes ?? null,
    }),

  updateRole: (
    staffId: string,
    role: string,
    permissions?: Record<string, boolean>,
    reason?: string,
  ) =>
    rpc<Record<string, unknown>>("update_admin_staff_role", {
      p_staff_id: staffId,
      p_new_role: role,
      p_new_permissions: permissions ?? null,
      p_reason: reason ?? null,
    }),

  suspend: (staffId: string, until?: string | null, reason?: string) =>
    rpc<Record<string, unknown>>("suspend_admin_staff", {
      p_staff_id: staffId,
      p_until: until ?? null,
      p_reason: reason ?? null,
    }),

  reactivate: (staffId: string, reason?: string) =>
    rpc<Record<string, unknown>>("reactivate_admin_staff", {
      p_staff_id: staffId,
      p_reason: reason ?? null,
    }),

  resetCode: (staffId: string, newCode: string, reason?: string) =>
    rpc<Record<string, unknown>>("reset_admin_staff_code", {
      p_staff_id: staffId,
      p_new_code: newCode,
      p_reason: reason ?? null,
    }),
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Modules transverses (RPC déjà présentes en base)                          */
/* ────────────────────────────────────────────────────────────────────────── */

export const supportApi = {
  reports: (kind?: string, status?: string, search?: string) =>
    rpc<Record<string, unknown>[]>("admin_reports_unified", {
      p_kind: kind || null,
      p_status: status || null,
      p_search: search || null,
      p_limit: 150,
      p_offset: 0,
    }),

  resolveReport: (
    kind: string,
    id: string,
    status: string,
    archive = false,
    comment?: string,
  ) =>
    rpc<Record<string, unknown>>("admin_resolve_report", {
      p_kind: kind,
      p_id: id,
      p_status: status,
      p_archive: archive,
      p_comment: comment ?? null,
    }),

  auditLogs: (action?: string, severity?: string) =>
    rpc<Record<string, unknown>[]>("admin_recent_audit_logs", {
      p_action: action || null,
      p_severity: severity || null,
      p_limit: 150,
      p_offset: 0,
    }),

  dashboardStats: () => rpc<Record<string, unknown>>("admin_dashboard_stats_fast"),

  users: (search?: string) =>
    rpc<Record<string, unknown>[]>("admin_users_overview", {
      p_search: search || null,
      p_premium: null,
      p_role: null,
      p_limit: 60,
      p_offset: 0,
    }),
}
