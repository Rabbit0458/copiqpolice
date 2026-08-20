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

import { createClient } from "@/lib/supabase/client";
import type {
  LifecycleAction,
  PublicationStatus,
} from "@/lib/admin/content-lifecycle";

/* ────────────────────────────────────────────────────────────────────────── */
/*  Types                                                                     */
/* ────────────────────────────────────────────────────────────────────────── */

export type AdminRole = "owner" | "superadmin" | "admin" | "moderator";

export interface AdminSession {
  ok: boolean;
  reason?: "no_session" | "not_admin" | "disabled" | "locked" | "expired";
  until?: string;
  admin_id?: string;
  email?: string;
  role?: AdminRole;
  permissions?: Record<string, boolean>;
  totp_enrolled?: boolean;
  aal?: "aal1" | "aal2";
  code_required?: boolean;
}

export interface CpDashboard {
  themes: number;
  cases_total: number;
  cases_published: number;
  questions: number;
  rubric_points: number;
  keywords: number;
  perfect_answers: number;
  attempts_total: number;
  attempts_done: number;
  avg_percent: number | null;
  appeals_pending: number;
  appeals_total: number;
  cases_sans_rubric: number;
  questions_sans_modele: number;
}

export interface AdminDashboardStats {
  users_total: number;
  users_active_30d: number;
  users_24h: number;
  users_premium: number;
  users_trial: number;
  subs_expired_30d: number;
  reports_open_cg: number;
  reports_open_psy: number;
  bug_reports_open: number;
  contact_open: number;
  forum_reports_open: number;
  staff_total: number;
  staff_locked: number;
  audit_logs_24h: number;
  critical_events_7d: number;
  quiz_questions: number;
  app_logs_total: number;
  refreshed_at: string | null;
}

export interface CpCaseRow {
  id: string;
  slug: string;
  title: string;
  year: number | null;
  month: string | null;
  difficulty: string | null;
  theme_slug: string | null;
  theme_label: string | null;
  status: "draft" | "published" | "archived";
  is_free: boolean;
  total_points: number | null;
  expected_minutes: number | null;
  nb_questions: number;
  nb_rubric_points: number;
  nb_perfect: number;
  nb_attempts: number;
  avg_percent: number | null;
  updated_at: string | null;
}

export interface CpKeyword {
  id: string;
  value: string;
  is_phrase: boolean;
  is_negation: boolean;
  fuzzy_max_dist: number;
  auto_added: boolean;
}
export interface CpGroup {
  id: string;
  position: number;
  description: string | null;
  is_optional: boolean;
  keywords: CpKeyword[];
}
export interface CpRubricPoint {
  id: string;
  position: number;
  label: string;
  weight: number;
  is_required: boolean;
  kind: "core" | "bonus";
  explanation_md: string | null;
  groups: CpGroup[];
}
export interface CpQuestion {
  id: string;
  position: number;
  label: string;
  hint: string | null;
  max_points: number;
  char_min: number | null;
  char_recommended: number | null;
  perfect_answer: { body_md: string; references_legal: string[] } | null;
  rubric_points: CpRubricPoint[];
}
export interface CpCaseDetail {
  case: Record<string, unknown> & {
    id: string;
    slug: string;
    title: string;
    situation_md: string | null;
    theme_slug: string | null;
    theme_label: string | null;
    status: string;
  };
  questions: CpQuestion[];
  error?: string;
}

export interface CpAppeal {
  id: string;
  created_at: string;
  status: "pending" | "approved" | "rejected";
  message: string | null;
  admin_response: string | null;
  user_email: string | null;
  case_slug: string | null;
  case_title: string | null;
  question_label: string | null;
  point_label: string | null;
  point_id: string | null;
  user_answer: string | null;
}

export interface CpHealthRow {
  gravite: "critique" | "important" | "mineur";
  objet: string;
  probleme: string;
  action: string;
}

export interface CpTheme {
  id: string;
  slug: string;
  label: string;
  color_hex: string | null;
  icon: string | null;
  sort_order: number | null;
  nb_cases: number;
}

/** Spécification d'une grille de correction (même format que les migrations). */
export interface RubricSpec {
  case: string;
  q: number;
  perfect?: string;
  refs?: string[];
  points: {
    label: string;
    weight?: number;
    kind?: "core" | "bonus";
    required?: boolean;
    expl?: string;
    /** Tableau de groupes. ET entre groupes, OU à l'intérieur d'un groupe. */
    groups: string[][];
  }[];
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Helper d'appel RPC                                                        */
/* ────────────────────────────────────────────────────────────────────────── */

export class AdminApiError extends Error {
  constructor(
    message: string,
    readonly code?: string,
  ) {
    super(message);
    this.name = "AdminApiError";
  }
}

async function rpc<T>(
  fn: string,
  args: Record<string, unknown> = {},
): Promise<T> {
  const supabase = createClient();
  const { data, error } = await supabase.rpc(fn as never, args as never);
  if (error) {
    // 42501 = permission refusée côté PostgreSQL (garde admin)
    const denied =
      error.code === "42501" || /acc[eè]s refus[eé]/i.test(error.message ?? "");
    throw new AdminApiError(
      denied ? error.message : `Erreur ${fn} : ${error.message ?? "inconnue"}`,
      error.code,
    );
  }
  return data as T;
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
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    if (error) throw new AdminApiError(error.message);
  },

  async signOut() {
    const supabase = createClient();
    await supabase.auth.signOut();
  },

  /* ── MFA TOTP (Google Authenticator) ─────────────────────────────────── */

  async listFactors() {
    const supabase = createClient();
    const { data, error } = await supabase.auth.mfa.listFactors();
    if (error) throw new AdminApiError(error.message);
    return data;
  },

  /** Démarre l'enrôlement : renvoie le QR code à scanner + le secret. */
  async enrollTotp() {
    const supabase = createClient();
    const { data, error } = await supabase.auth.mfa.enroll({
      factorType: "totp",
      friendlyName: `COP'IQ Admin — ${new Date().toLocaleDateString("fr-FR")}`,
    });
    if (error) throw new AdminApiError(error.message);
    return data;
  },

  /** Valide un code à 6 chiffres (enrôlement OU connexion) → passe en AAL2. */
  async verifyTotp(factorId: string, code: string) {
    const supabase = createClient();
    const { data: ch, error: e1 } = await supabase.auth.mfa.challenge({
      factorId,
    });
    if (e1) throw new AdminApiError(e1.message);
    const { error: e2 } = await supabase.auth.mfa.verify({
      factorId,
      challengeId: ch.id,
      code,
    });
    if (e2) throw new AdminApiError("Code invalide ou expiré.");
    return true;
  },

  async unenrollTotp(factorId: string) {
    const supabase = createClient();
    const { error } = await supabase.auth.mfa.unenroll({ factorId });
    if (error) throw new AdminApiError(error.message);
  },
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Module Cas Pratique                                                       */
/* ────────────────────────────────────────────────────────────────────────── */

export const casPratiqueApi = {
  dashboard: () => rpc<CpDashboard>("cp_admin_dashboard"),

  health: () => rpc<CpHealthRow[]>("cp_admin_health"),

  listThemes: () => rpc<CpTheme[]>("cp_admin_list_themes"),

  upsertTheme: (data: Partial<CpTheme>) =>
    rpc<{ ok: boolean; id: string }>("cp_admin_upsert_theme", { p_data: data }),

  listCases: (
    opts: {
      search?: string;
      status?: string;
      theme?: string;
      limit?: number;
      offset?: number;
    } = {},
  ) =>
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
    rpc<{ ok: boolean; id: string }>("cp_admin_upsert_question", {
      p_data: data,
    }),

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
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Modules transverses (RPC déjà présentes en base)                          */
/* ────────────────────────────────────────────────────────────────────────── */

/* ────────────────────────────────────────────────────────────────────────── */
/*  Quiz de scolarité (moteur générique)                                      */
/* ────────────────────────────────────────────────────────────────────────── */

export interface QuizModuleRow {
  module: string;
  title: string;
  subtitle: string | null;
  route: string;
  color_hex: string;
  track: string;
  is_active: boolean;
  nb_questions: number;
  nb_facile: number;
  nb_moyenne: number;
  nb_difficile: number;
  nb_sans_explication: number;
}

export interface QuizQuestionRow {
  id: number;
  category: string | null;
  difficulty: "Facile" | "Moyenne" | "Difficile";
  question: string;
  options: string[];
  answer: string;
  explanation: string | null;
  legal_ref: string | null;
  is_active: boolean;
  publication_status: PublicationStatus;
  scheduled_at: string | null;
  published_at: string | null;
  archived_at: string | null;
  archived_previous_status: PublicationStatus | null;
  updated_at: string;
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
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Fiches de cours                                                           */
/* ────────────────────────────────────────────────────────────────────────── */

export interface CoursRow {
  id: number;
  route: string;
  track: string;
  module: string;
  section: string | null;
  code: string | null;
  title: string;
  subtitle: string | null;
  quiz_module: string | null;
  is_published: boolean;
  publication_status: PublicationStatus;
  scheduled_at: string | null;
  published_at: string | null;
  archived_at: string | null;
  archived_previous_status: PublicationStatus | null;
  taille: number;
  updated_at: string;
}

export interface ScolariteFragment {
  source_path: string;
  fragment_key: string;
  panel: string;
  position: number;
  component: string;
  text_value: string;
  original_text: string;
  style_payload: Record<string, unknown>;
  is_editable: boolean;
  revision: number;
  updated_at: string;
}

export interface ScolariteEditorData {
  source_path: string;
  track: "gpx" | "pa";
  fragments: ScolariteFragment[];
  link: {
    id: number;
    link_status: "linked" | "separated";
    gpx_source_path: string;
    pa_source_path: string;
  } | null;
  linked_source_path: string | null;
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
};

export const scolariteContentApi = {
  editor: (sourcePath: string) =>
    rpc<ScolariteEditorData>("scolarite_admin_get_editor", {
      p_source_path: sourcePath,
    }),

  updateFragment: (
    sourcePath: string,
    fragmentKey: string,
    textValue: string,
    applyLinked: boolean,
  ) =>
    rpc<{ ok: boolean; linked_updated: boolean }>(
      "scolarite_admin_update_fragment",
      {
        p_source_path: sourcePath,
        p_fragment_key: fragmentKey,
        p_text_value: textValue,
        p_apply_linked: applyLinked,
      },
    ),

  separate: (sourcePath: string) =>
    rpc<{ ok: boolean; link_id: number }>("scolarite_admin_separate_link", {
      p_source_path: sourcePath,
    }),
};

export const contentLifecycleApi = {
  set: (
    contentType: "course" | "quiz_question",
    contentKey: string | number,
    status: LifecycleAction,
    scheduledAt?: string | null,
  ) =>
    rpc<{ ok: boolean; publication_status: PublicationStatus }>(
      "content_admin_set_lifecycle",
      {
        p_content_type: contentType,
        p_content_key: String(contentKey),
        p_status: status,
        p_scheduled_at: scheduledAt ?? null,
      },
    ),
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Forum — modération                                                        */
/* ────────────────────────────────────────────────────────────────────────── */

export interface ForumReport {
  id: string;
  created_at: string;
  status: string;
  reason: string | null;
  reporter_email: string | null;
  post_id: string | null;
  post_title: string | null;
  post_content: string | null;
  post_author_email: string | null;
  post_author_id: string | null;
  post_created_at: string | null;
  post_supprime: boolean;
  nb_signalements: number;
  auteur_banni: boolean;
}

export interface ForumBan {
  user_id: string;
  email: string | null;
  reason: string | null;
  expires_at: string | null;
  created_at: string;
}

export type CommunityReportStatus =
  "new" | "triaged" | "in_progress" | "resolved" | "rejected" | "appealed";

export type CommunityReportPriority = "normal" | "high" | "urgent";
export type CommunityReportTarget =
  "post" | "comment" | "message" | "profile" | "attachment" | "room";

export interface CommunityModerationDashboard {
  posts_today: number;
  comments_today: number;
  open_reports: number;
  active_sanctions: number;
}

export interface CommunityAdminReport {
  id: string;
  created_at: string;
  status: CommunityReportStatus;
  priority: CommunityReportPriority;
  space_id: string | null;
  space_label: string;
  target_type: CommunityReportTarget;
  target_id: string;
  reason: string;
  details: string | null;
  reporter_id: string;
  reporter_name: string | null;
  reporter_username: string | null;
  reporter_avatar_index: number | null;
  subject_user_id: string | null;
  subject_name: string | null;
  subject_username: string | null;
  subject_avatar_index: number | null;
  target_title: string;
  target_content: string | null;
  target_status: string | null;
  resolution: string | null;
  resolved_at: string | null;
  appealed_at: string | null;
  appeal_text: string | null;
  total_count: number;
}

export interface CommunityMessageEvidence {
  context_position: number;
  message_id: string;
  sender_id: string;
  content: string;
  created_at: string;
  is_reported: boolean;
}

export const communityForumApi = {
  dashboard: (spaceId?: string) =>
    rpc<CommunityModerationDashboard>("community_admin_dashboard", {
      p_space_id: spaceId || null,
    }),

  listReports: (
    opts: {
      status?: CommunityReportStatus;
      targetType?: CommunityReportTarget;
      spaceId?: string;
      priority?: CommunityReportPriority;
      search?: string;
      limit?: number;
      offset?: number;
    } = {},
  ) =>
    rpc<CommunityAdminReport[]>("community_admin_list_reports", {
      p_status: opts.status || null,
      p_target_type: opts.targetType || null,
      p_space_id: opts.spaceId || null,
      p_priority: opts.priority || null,
      p_search: opts.search || null,
      p_limit: opts.limit ?? 30,
      p_offset: opts.offset ?? 0,
    }),

  resolveReport: (
    reportId: string,
    status: "resolved" | "rejected",
    resolution: string,
  ) =>
    rpc<void>("community_resolve_report", {
      p_report_id: reportId,
      p_status: status,
      p_resolution: resolution,
    }),

  moderatePost: (
    postId: string,
    action: "hide" | "restore" | "lock" | "remove" | "pin" | "unpin",
    reason: string,
  ) =>
    rpc<void>("community_moderate_post", {
      p_post_id: postId,
      p_action: action,
      p_reason: reason,
    }),

  openMessageEvidence: (reportId: string, accessReason: string) =>
    rpc<CommunityMessageEvidence[]>("community_open_message_report", {
      p_report_id: reportId,
      p_access_reason: accessReason,
    }),
};

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
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Notes de patch                                                            */
/* ────────────────────────────────────────────────────────────────────────── */

export interface PatchNote {
  id: number;
  title: string;
  summary: string | null;
  body: string;
  publication_status: EditorialStatus;
  scheduled_at: string | null;
  published_at: string | null;
  archived_at: string | null;
  created_at: string;
  updated_at: string;
  author_email: string | null;
}

export const patchNotesApi = {
  list: (status?: EditorialStatus) =>
    rpc<PatchNote[]>("patch_notes_admin_list", {
      p_status: status ?? null,
      p_limit: 100,
    }),

  save: (note: {
    id?: number;
    title: string;
    summary?: string;
    body: string;
    status: EditorialStatus;
    scheduledAt?: string | null;
  }) =>
    rpc<number>("patch_notes_admin_save", {
      p_id: note.id ?? null,
      p_title: note.title,
      p_summary: note.summary ?? null,
      p_body: note.body,
      p_status: note.status,
      p_scheduled_at: note.scheduledAt ?? null,
    }),

  remove: (id: number) =>
    rpc<Record<string, unknown>>("delete_patch_note", { p_id: id }),
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Centre d'information : FAQ, support et documents légaux                  */
/* ────────────────────────────────────────────────────────────────────────── */

export type InformationContentType =
  | "information"
  | "faq"
  | "legal_notice"
  | "privacy"
  | "support"
  | "service_status";

export type EditorialStatus = "draft" | "scheduled" | "published" | "archived";

export interface InformationContent {
  id: string;
  content_type: InformationContentType;
  slug: string;
  title: string;
  summary: string;
  body_md: string;
  category: string;
  sort_order: number;
  status: EditorialStatus;
  scheduled_at: string | null;
  published_at: string | null;
  archived_at: string | null;
  metadata: Record<string, unknown>;
  created_at: string;
  updated_at: string;
}

export interface SupportRequest {
  id: string;
  user_id: string | null;
  name: string;
  email: string;
  category: string;
  subject: string;
  message: string;
  status: "new" | "in_progress" | "waiting_user" | "resolved" | "closed";
  priority: "low" | "normal" | "high" | "urgent";
  admin_note: string;
  resolved_at: string | null;
  created_at: string;
  updated_at: string;
}

export const informationAdminApi = {
  list: (
    type?: InformationContentType,
    status?: EditorialStatus,
    search?: string,
  ) =>
    rpc<InformationContent[]>("information_admin_list", {
      p_type: type ?? null,
      p_status: status ?? null,
      p_search: search || null,
    }),
  save: (
    data: Partial<InformationContent> &
      Pick<InformationContent, "content_type" | "slug" | "title">,
  ) => rpc<InformationContent>("information_admin_save", { p_data: data }),
  remove: (id: string) =>
    rpc<boolean>("information_admin_delete", { p_id: id }),
  listSupport: (status?: SupportRequest["status"], search?: string) =>
    rpc<SupportRequest[]>("support_admin_list", {
      p_status: status ?? null,
      p_search: search || null,
    }),
  updateSupport: (
    id: string,
    status: SupportRequest["status"],
    priority: SupportRequest["priority"],
    adminNote: string,
  ) =>
    rpc<SupportRequest>("support_admin_update", {
      p_id: id,
      p_status: status,
      p_priority: priority,
      p_admin_note: adminNote,
    }),
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Comptes administrateurs                                                   */
/* ────────────────────────────────────────────────────────────────────────── */

export interface AdminStaff {
  id: string;
  email: string;
  role: AdminRole;
  first_name: string | null;
  last_name: string | null;
  username: string | null;
  disabled: boolean;
  second_factor_enabled: boolean;
  permissions: Record<string, boolean>;
  locked_until: string | null;
  expires_at: string | null;
  failed_admin_code_attempts: number;
  last_admin_login_at: string | null;
  last_admin_login_ip: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface CommunityModeratorScope {
  space_id: string;
  space_label: string;
  role: "helper" | "moderator" | "admin" | "owner";
  expires_at: string | null;
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
    email: string;
    role: string;
    first_name?: string;
    last_name?: string;
    username?: string;
    permissions?: Record<string, boolean>;
    expires_at?: string | null;
    notes?: string;
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

  communityScopes: (staffId: string) =>
    rpc<CommunityModeratorScope[]>("community_admin_staff_scopes", {
      p_admin_id: staffId,
    }),

  setCommunityScopes: (
    staffId: string,
    scopes: { space_id: string; role: string; expires_at: string | null }[],
    reason: string,
  ) =>
    rpc<void>("community_admin_set_staff_scopes", {
      p_admin_id: staffId,
      p_scopes: scopes,
      p_reason: reason,
    }),
};

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

  dashboardStats: () => rpc<AdminDashboardStats>("admin_dashboard_stats_fast"),

  users: (search?: string) =>
    rpc<Record<string, unknown>[]>("admin_users_overview", {
      p_search: search || null,
      p_premium: null,
      p_role: null,
      p_limit: 60,
      p_offset: 0,
    }),
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Utilisateurs & sanctions communautaires                                   */
/* ────────────────────────────────────────────────────────────────────────── */

export type CommunitySanctionKind =
  | "warning"
  | "post_restriction"
  | "comment_restriction"
  | "message_restriction"
  | "suspension"
  | "ban";

export interface CommunityAdminUserRow {
  user_id: string;
  email: string | null;
  username: string | null;
  first_name: string | null;
  last_name: string | null;
  avatar_index: number | null;
  user_role: string | null;
  user_track: string | null;
  user_mode: string | null;
  plan: string | null;
  subscription_status: string | null;
  current_period_end: string | null;
  posts_count: number;
  comments_count: number;
  reports_received: number;
  active_sanctions: number;
  last_seen: string | null;
  created_at: string | null;
  total_count: number;
}

export interface CommunitySanction {
  id: string;
  space_id: string;
  kind: CommunitySanctionKind;
  reason: string;
  starts_at: string;
  ends_at: string | null;
  status: "active" | "expired" | "revoked" | "appealed";
  created_at: string;
  revoked_at: string | null;
  imposed_by: string;
  revoked_by: string | null;
  /** Ajoutés par la migration 20260818120000 — peuvent être absents si elle n'est pas appliquée. */
  imposed_by_email?: string | null;
  revoked_by_email?: string | null;
  space_label?: string | null;
}

/**
 * Dossier utilisateur renvoyé par `community_admin_user_detail`.
 *
 * Les champs marqués optionnels sont ceux ajoutés par la migration
 * 20260818120000. L'interface reste donc compatible avec l'ancienne version
 * de la fonction : la page dégrade proprement si la migration n'est pas encore
 * appliquée en production.
 */
export interface CommunityAdminUserDetail {
  profile: {
    user_id: string;
    email: string | null;
    username: string | null;
    first_name: string | null;
    last_name: string | null;
    avatar_index: number | null;
    city: string | null;
    user_role: string | null;
    user_track: string | null;
    user_mode: string | null;
    created_at: string;
    updated_at: string;
    phone?: string | null;
    birthday?: string | null;
    has_passed_exam?: boolean | null;
    cgv_accepted?: boolean | null;
    cgv_accepted_at?: string | null;
  };
  settings?: {
    locale?: string | null;
    theme_dark?: boolean | null;
    onboarding_done_at?: string | null;
    updated_at?: string | null;
  };
  community_profile?: {
    bio?: string | null;
    show_activity?: boolean | null;
    show_joined_at?: boolean | null;
    show_spaces?: boolean | null;
    show_display_name?: boolean | null;
    created_at?: string | null;
  };
  staff?: {
    role?: string | null;
    disabled?: boolean | null;
    last_admin_login_at?: string | null;
    expires_at?: string | null;
  };
  subscription: {
    plan?: string;
    status?: string;
    current_period_start?: string | null;
    current_period_end?: string;
    created_at?: string | null;
    updated_at?: string | null;
  };
  activity: {
    posts: number;
    comments: number;
    messages: number;
    reports_received: number;
    reports_sent: number;
    posts_visible?: number;
    comments_visible?: number;
    rooms?: number;
    reactions_given?: number;
    reports_open?: number;
    sanctions_total?: number;
    sanctions_active?: number;
    quiz_answers?: number;
    psy_tests?: number;
    cp_attempts?: number;
    invoices?: number;
    /** Ajoutés par la migration 20260820100000. */
    badges?: number;
    notifications?: number;
    notifications_unread?: number;
    favorites?: number;
    devices?: number;
    photolangage_attempts?: number;
    placement_done?: boolean;
    content_reports?: number;
  };
  quiz_summary?: {
    answers?: number;
    correct?: number;
    wrong?: number;
    accuracy?: number | null;
    modules?: number;
    first_at?: string | null;
    last_at?: string | null;
  };
  cp_progress?: {
    cases_started?: number;
    cases_finished?: number;
    total_attempts?: number;
    avg_score_percent?: number | null;
    best_score_percent?: number | null;
    last_attempt_at?: string | null;
    streak_days?: number;
  };
  last_activity?: string | null;
  sanctions: CommunitySanction[];
}

/* ---- Sous-listes paginées du dossier utilisateur ------------------------- */

export interface CommunityUserPost {
  id: string;
  space_id: string | null;
  space_label: string | null;
  category_label: string | null;
  type: string | null;
  title: string | null;
  content: string | null;
  status: string;
  is_pinned: boolean;
  is_resolved: boolean;
  reaction_count: number;
  comment_count: number;
  share_count: number;
  view_count: number;
  created_at: string;
  edited_at: string | null;
  deleted_at: string | null;
  reports_count: number;
  total_count: number;
}

export interface CommunityUserComment {
  id: string;
  post_id: string | null;
  post_title: string | null;
  space_id: string | null;
  space_label: string | null;
  content: string | null;
  status: string;
  is_solution: boolean;
  reaction_count: number;
  reply_count: number;
  created_at: string;
  edited_at: string | null;
  deleted_at: string | null;
  is_reply: boolean;
  reports_count: number;
  total_count: number;
}

export interface CommunityUserMessage {
  id: string;
  room_id: string | null;
  room_title: string | null;
  room_kind: string | null;
  space_id: string | null;
  space_label: string | null;
  type: string | null;
  status: string;
  content_length: number;
  /** Renseigné uniquement si le message est une pièce d'un signalement. */
  disclosed_content: string | null;
  is_evidence: boolean;
  created_at: string;
  edited_at: string | null;
  deleted_at: string | null;
  total_count: number;
}

export interface CommunityUserReport {
  id: string;
  direction: "received" | "sent";
  space_id: string | null;
  space_label: string | null;
  target_type: string | null;
  target_id: string | null;
  reason: string;
  details: string | null;
  status: string;
  priority: string | null;
  resolution: string | null;
  reporter_id: string | null;
  reporter_email: string | null;
  subject_user_id: string | null;
  subject_email: string | null;
  assigned_to: string | null;
  assigned_email: string | null;
  created_at: string;
  acknowledged_at: string | null;
  resolved_at: string | null;
  appealed_at: string | null;
  total_count: number;
}

export interface CommunityUserQuizModule {
  track: string | null;
  mode: string | null;
  module_key: string | null;
  answers: number;
  correct: number;
  wrong: number;
  accuracy: number | null;
  avg_response_ms: number | null;
  first_at: string | null;
  last_at: string | null;
}

export interface CommunityUserQuizAnswer {
  id: string;
  track: string | null;
  mode: string | null;
  module_key: string | null;
  quiz_key: string | null;
  question_text: string | null;
  user_answer: string | null;
  correct_answer: string | null;
  is_correct: boolean | null;
  difficulty: string | null;
  response_time_ms: number | null;
  answered_at: string;
  total_count: number;
}

export interface CommunityUserBilling {
  subscriptions: {
    id: string;
    plan: string | null;
    status: string | null;
    current_period_start: string | null;
    current_period_end: string | null;
    created_at: string | null;
    updated_at: string | null;
  }[];
  invoices: {
    id: string;
    invoice_number: string | null;
    amount_cents: number | null;
    currency: string | null;
    status: string | null;
    plan: string | null;
    period_start: string | null;
    period_end: string | null;
    created_at: string | null;
    paid_at: string | null;
    due_at: string | null;
  }[];
  events: {
    id: number;
    event_type: string | null;
    created_at: string | null;
    processed_at: string | null;
  }[];
}

/* ---- Ajouts migration 20260820100000 — Phase A + B User 360 ------------- */

export interface CommunityUserAuth {
  user_id: string;
  email: string | null;
  phone: string | null;
  email_confirmed_at: string | null;
  phone_confirmed_at: string | null;
  confirmation_sent_at: string | null;
  last_sign_in_at: string | null;
  created_at: string | null;
  updated_at: string | null;
  banned_until: string | null;
  deleted_at: string | null;
  is_anonymous: boolean | null;
  is_sso_user: boolean | null;
  provider: string | null;
  providers: string[] | null;
}

export interface CommunityUserBadge {
  slug: string;
  label: string;
  description: string | null;
  icon: string | null;
  color_hex: string | null;
  kind: string | null;
  unlocked_at: string;
  metadata: Record<string, unknown> | null;
}

export interface CommunityUserNotification {
  id: string;
  type: string | null;
  target_type: string | null;
  target_id: string | null;
  space_id: string | null;
  space_label: string | null;
  payload: Record<string, unknown> | null;
  created_at: string;
  read_at: string | null;
  total_count: number;
}

export interface CommunityUserFavorite {
  post_id: string;
  post_title: string | null;
  post_status: string | null;
  space_id: string | null;
  space_label: string | null;
  created_at: string;
  total_count: number;
}

export interface CommunityUserDevice {
  id: number;
  platform: string | null;
  app_version: string | null;
  token_masked: string | null;
  created_at: string;
  updated_at: string;
}

export interface CommunityUserContentReport {
  source: "quiz" | "culture_generale" | "cas_pratique";
  id: string;
  created_at: string;
  report_type: string | null;
  category: string | null;
  content: string | null;
  status: string | null;
  total_count: number;
}

export interface CommunityUserPhotolangage {
  id: string;
  case_id: string | null;
  status: string | null;
  correction_status: string | null;
  character_count: number | null;
  word_count: number | null;
  elapsed_seconds: number | null;
  pedagogical_score: number | null;
  started_at: string | null;
  submitted_at: string | null;
  total_count: number;
}

export interface CommunityUserPlacement {
  results: {
    id: string;
    total_score: number;
    max_score: number;
    score_pct: number;
    created_at: string;
  }[];
  by_domain: { domain: string; total: number; correct: number }[];
}

export interface CommunityUserCpAttempt {
  id: string;
  case_id: string | null;
  status: string | null;
  is_completed: boolean;
  started_at: string | null;
  finished_at: string | null;
  time_spent_ms: number | null;
  total_score: number | null;
  total_max: number | null;
  percent: number | null;
  correction_percent: number | null;
  xp_delta: number;
  total_count: number;
}

/* ---- Ajouts migration 20260821100000 — Phase C, owner only -------------- */

export type AdminUserTableScan = Record<string, { count: number; relation: string }>;

export interface AdminUserRawTableData {
  table: string;
  relation: string;
  total_count: number;
  rows: Record<string, unknown>[];
}

export interface CommunityUserTimelineEvent {
  occurred_at: string;
  kind: string;
  label: string;
  detail: string | null;
  ref_type: string | null;
  ref_id: string | null;
}

export const communityUsersApi = {
  list: (
    opts: {
      search?: string;
      track?: string;
      mode?: string;
      subscription?: string;
      sanctioned?: boolean;
      limit?: number;
      offset?: number;
    } = {},
  ) =>
    rpc<CommunityAdminUserRow[]>("community_admin_list_users", {
      p_search: opts.search || null,
      p_track: opts.track || null,
      p_mode: opts.mode || null,
      p_subscription: opts.subscription || null,
      p_sanctioned: opts.sanctioned ?? null,
      p_limit: opts.limit ?? 40,
      p_offset: opts.offset ?? 0,
    }),

  detail: (userId: string) =>
    rpc<CommunityAdminUserDetail>("community_admin_user_detail", {
      p_user_id: userId,
    }),

  imposeSanction: (data: {
    userId: string;
    kind: CommunitySanctionKind;
    reason: string;
    spaceId: string;
    endsAt?: string | null;
  }) =>
    rpc<string>("community_admin_impose_sanction", {
      p_user_id: data.userId,
      p_kind: data.kind,
      p_reason: data.reason,
      p_space_id: data.spaceId,
      p_ends_at: data.endsAt ?? null,
    }),

  revokeSanction: (sanctionId: string, reason: string) =>
    rpc<void>("community_admin_revoke_sanction", {
      p_sanction_id: sanctionId,
      p_reason: reason,
    }),

  /* ---- Sous-listes du dossier (migration 20260818120000) ---------------- */

  posts: (
    userId: string,
    opts: {
      search?: string;
      status?: string;
      limit?: number;
      offset?: number;
    } = {},
  ) =>
    rpc<CommunityUserPost[]>("community_admin_user_posts", {
      p_user_id: userId,
      p_search: opts.search || null,
      p_status: opts.status || null,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  comments: (
    userId: string,
    opts: {
      search?: string;
      status?: string;
      limit?: number;
      offset?: number;
    } = {},
  ) =>
    rpc<CommunityUserComment[]>("community_admin_user_comments", {
      p_user_id: userId,
      p_search: opts.search || null,
      p_status: opts.status || null,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  messages: (
    userId: string,
    opts: { limit?: number; offset?: number } = {},
  ) =>
    rpc<CommunityUserMessage[]>("community_admin_user_messages", {
      p_user_id: userId,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  reports: (
    userId: string,
    opts: {
      direction?: "received" | "sent";
      status?: string;
      limit?: number;
      offset?: number;
    } = {},
  ) =>
    rpc<CommunityUserReport[]>("community_admin_user_reports", {
      p_user_id: userId,
      p_direction: opts.direction ?? "received",
      p_status: opts.status || null,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  quizSummary: (userId: string) =>
    rpc<CommunityUserQuizModule[]>("community_admin_user_quiz_summary", {
      p_user_id: userId,
    }),

  quiz: (
    userId: string,
    opts: { module?: string; limit?: number; offset?: number } = {},
  ) =>
    rpc<CommunityUserQuizAnswer[]>("community_admin_user_quiz", {
      p_user_id: userId,
      p_module: opts.module || null,
      p_limit: opts.limit ?? 25,
      p_offset: opts.offset ?? 0,
    }),

  billing: (userId: string) =>
    rpc<CommunityUserBilling>("community_admin_user_billing", {
      p_user_id: userId,
    }),

  timeline: (userId: string, opts: { limit?: number; offset?: number } = {}) =>
    rpc<CommunityUserTimelineEvent[]>("community_admin_user_timeline", {
      p_user_id: userId,
      p_limit: opts.limit ?? 40,
      p_offset: opts.offset ?? 0,
    }),

  /* ---- Ajouts migration 20260820100000 ---------------------------------- */

  auth: (userId: string) =>
    rpc<CommunityUserAuth>("community_admin_user_auth", { p_user_id: userId }),

  badges: (userId: string) =>
    rpc<CommunityUserBadge[]>("community_admin_user_badges", {
      p_user_id: userId,
    }),

  notifications: (
    userId: string,
    opts: { unreadOnly?: boolean; limit?: number; offset?: number } = {},
  ) =>
    rpc<CommunityUserNotification[]>("community_admin_user_notifications", {
      p_user_id: userId,
      p_unread_only: opts.unreadOnly ?? null,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  favorites: (userId: string, opts: { limit?: number; offset?: number } = {}) =>
    rpc<CommunityUserFavorite[]>("community_admin_user_favorites", {
      p_user_id: userId,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  devices: (userId: string) =>
    rpc<CommunityUserDevice[]>("community_admin_user_devices", {
      p_user_id: userId,
    }),

  contentReports: (
    userId: string,
    opts: { limit?: number; offset?: number } = {},
  ) =>
    rpc<CommunityUserContentReport[]>("community_admin_user_content_reports", {
      p_user_id: userId,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  photolangage: (
    userId: string,
    opts: { limit?: number; offset?: number } = {},
  ) =>
    rpc<CommunityUserPhotolangage[]>("community_admin_user_photolangage", {
      p_user_id: userId,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  placement: (userId: string) =>
    rpc<CommunityUserPlacement>("community_admin_user_placement", {
      p_user_id: userId,
    }),

  cpAttempts: (
    userId: string,
    opts: { limit?: number; offset?: number } = {},
  ) =>
    rpc<CommunityUserCpAttempt[]>("community_admin_user_cp_attempts", {
      p_user_id: userId,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),

  /* ---- Ajouts migration 20260821100000 — owner only ---------------------- */

  scanTables: (userId: string) =>
    rpc<AdminUserTableScan>("admin_scan_user_tables", { p_user_id: userId }),

  logExport: (userId: string) =>
    rpc<null>("community_admin_log_user_export", { p_user_id: userId }),

  /**
   * Suppression complète d'un compte tiers — owner only, confirmation email
   * exacte, refus si la cible est elle-même staff. Toute la logique de garde
   * vit dans la RPC `admin_delete_user_data_completely` appelée par l'edge
   * function ; celle-ci n'accorde aucun droit de plus.
   */
  async deleteUserAccount(targetUserId: string, confirmEmail: string) {
    const supabase = createClient();
    const { data, error } = await supabase.functions.invoke(
      "admin_delete_user_account",
      { body: { target_user_id: targetUserId, confirm_email: confirmEmail } },
    );
    if (error) {
      const message =
        (data as { message?: string } | null)?.message ?? error.message;
      throw new AdminApiError(message);
    }
    return data as {
      success: boolean;
      partial: boolean;
      message: string;
      report: { ok: boolean; deleted_rows: Record<string, number> };
    };
  },

  rawTableData: (
    userId: string,
    table: string,
    opts: { limit?: number; offset?: number } = {},
  ) =>
    rpc<AdminUserRawTableData>("admin_get_user_raw_table_data", {
      p_user_id: userId,
      p_table: table,
      p_limit: opts.limit ?? 20,
      p_offset: opts.offset ?? 0,
    }),
};
