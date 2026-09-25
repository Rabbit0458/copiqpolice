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

export type AdminEmailCampaignType =
  | "product_update"
  | "service_information"
  | "individual_message";

export type AdminEmailAudienceKind = "all" | "individual";

export interface AdminEmailCampaign {
  id: string;
  campaign_type: AdminEmailCampaignType;
  audience_kind: AdminEmailAudienceKind;
  target_user_id: string | null;
  subject: string;
  headline: string;
  body_text: string;
  cta_label: string | null;
  cta_url: string | null;
  status: "draft" | "sending" | "sent" | "partial" | "failed" | "cancelled";
  recipient_count: number;
  submitted_count: number;
  failed_count: number;
  created_at: string;
  completed_at: string | null;
}

export interface AdminEmailUserResult {
  user_id: string;
  email: string;
  name: string;
}

export type ActiveAccessStatus = "pending" | "granted" | "revoked";

export interface ActiveAccessRow {
  user_id: string;
  email: string | null;
  status: ActiveAccessStatus;
  verification_version: number | null;
  granted_at: string | null;
  revoked_at: string | null;
  last_attempt_at: string | null;
  attempts: number;
  last_score: number | null;
}

export interface ActiveAccessAnswer {
  position: number;
  prompt: string;
  answer: string;
  correct: boolean;
}

export interface ActiveAccessAttempt {
  id: string;
  score: number;
  passed: boolean;
  completed_at: string;
  cooldown_until: string | null;
  answers: ActiveAccessAnswer[];
}

export interface ActiveAccessDetail {
  access: {
    user_id: string;
    status: ActiveAccessStatus;
    verification_version: number | null;
    granted_at: string | null;
    revoked_at: string | null;
    revoke_reason: string | null;
    last_attempt_at: string | null;
    updated_at: string;
  } | null;
  attempts: ActiveAccessAttempt[];
}

export type ActiveNodeType = "category" | "subcategory" | "course";
export type ActiveContentBlockType =
  "heading" | "paragraph" | "card" | "article" | "circular" | "divider";
export interface ActiveContentBlock {
  type: ActiveContentBlockType;
  text: string;
  color?: string;
}
export interface ActiveContentNode {
  id: string;
  parent_id: string | null;
  node_type: ActiveNodeType;
  title: string;
  subtitle: string | null;
  image_url: string | null;
  icon: string | null;
  sort_order: number;
  draft_content: ActiveContentBlock[];
  published_content: ActiveContentBlock[] | null;
  status: "draft" | "published" | "archived";
  updated_at: string;
}
export interface ActiveContentState {
  config: {
    enabled: boolean;
    owner_preview_enabled: boolean;
    revision: number;
    disable_message: string;
    countdown_seconds: number;
    updated_at: string;
  };
  nodes: ActiveContentNode[];
}

export interface GradePickerConfig {
  id: boolean;
  reserve_enabled: boolean;
  revision: number;
  updated_at: string;
  updated_by: string | null;
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

export interface AdminAppAnalytics {
  days: 7 | 30 | 90;
  refreshed_at: string;
  activity_definition: string;
  daily: Array<{
    date: string;
    active_users: number;
    registrations: number;
    quiz_sessions: number;
  }>;
  retention: Array<{
    day: 1 | 7 | 30;
    eligible: number;
    returned: number;
    rate: number | null;
  }>;
  funnel: {
    registered: number;
    opened_app: number;
    practiced_quiz: number;
    paying_active_after_quiz: number;
  };
  engagement: {
    active_1d: number;
    active_7d: number;
    active_30d: number;
    logged_sessions: number;
    quiz_sessions: number;
    quiz_learners: number;
    answers_saved: number;
    practical_attempts: number;
    paywall_visitors: number;
    paid_active: number;
    trials_active: number;
  };
  journeys: Array<{
    track: string;
    mode: string;
    label: string;
    current_users: number;
    quiz_sessions: number;
    quiz_learners: number;
  }>;
  platforms: Array<{ platform: string; users: number; sessions: number }>;
  top_content: Array<{ route: string; users: number; views: number }>;
  stores: Array<{ store: string; paid_active: number }>;
}

export interface AdminPeriodComparisonMetric {
  current: number;
  previous: number;
  delta: number;
  change_pct: number | null;
}

export interface AdminPeriodComparison {
  days: 7 | 30 | 90;
  refreshed_at: string;
  current_start: string;
  current_end: string;
  previous_start: string;
  previous_end: string;
  definition: string;
  metrics: {
    active_users: AdminPeriodComparisonMetric;
    registrations: AdminPeriodComparisonMetric;
    quiz_sessions: AdminPeriodComparisonMetric;
    answers_saved: AdminPeriodComparisonMetric;
    correct_answers: AdminPeriodComparisonMetric;
    incident_events: AdminPeriodComparisonMetric;
    community_contributions: AdminPeriodComparisonMetric;
  };
}

export interface AdminLearningAnalytics {
  days: 7 | 30 | 90;
  refreshed_at: string;
  definition: string;
  summary: { saved: number; correct: number; learners: number; accuracy: number | null };
  journeys: Array<{ track: string; mode: string; label: string; saved: number; correct: number; learners: number; accuracy: number | null }>;
  difficulty: Array<{ label: string; saved: number; correct: number; learners: number; accuracy: number | null }>;
  daily: Array<{ date: string; saved: number; correct: number; accuracy: number | null }>;
  psychotechnique: { exercises: number; learners: number; accuracy: number | null; total_answered: number | null };
  practical: { attempts: number; learners: number; scored: number; average_percent: number | null };
}

export interface AdminQualityAnalytics {
  days: 7 | 30 | 90;
  refreshed_at: string;
  definition: string;
  summary: { events: number; incident_events: number; affected_users: number; sessions: number; affected_sessions: number };
  daily: Array<{ date: string; incidents: number; affected_users: number }>;
  versions: Array<{ version: string; users: number; events: number; incidents: number }>;
  platforms: Array<{ platform: string; users: number; affected_users: number; incidents: number }>;
  os_versions: Array<{ platform: string; os_version: string; users: number; affected_users: number; incidents: number }>;
  incident_types: Array<{ type: string; events: number; users: number }>;
}

export interface AdminCommunityAnalytics {
  days: 7 | 30 | 90;
  refreshed_at: string;
  definition: string;
  summary: {
    visible_posts: number;
    new_posts: number;
    new_comments: number;
    new_messages: number;
    new_reactions: number;
    contributors: number;
    visible_post_views: number;
    active_spaces: number;
  };
}

export type AdminOperationKind =
  | "task" | "incident" | "objective" | "notification"
  | "synchronization" | "cost" | "store_review" | "experiment"
  | "recommendation" | "production_check" | "restore_test"
  | "documentation" | "health_event" | "feedback";

export type AdminOperationStatus =
  | "new" | "planned" | "in_progress" | "monitoring"
  | "blocked" | "done" | "ignored" | "archived";

export type AdminOperationPriority = "low" | "normal" | "high" | "critical";

export type AdminOperationScope =
  | "global" | "gpx_school" | "pa_school" | "gpx_exam" | "pa_exam"
  | "active" | "web" | "ios" | "android";

export interface AdminOperationItem {
  id: string;
  kind: AdminOperationKind;
  title: string;
  description: string;
  status: AdminOperationStatus;
  priority: AdminOperationPriority;
  scope: AdminOperationScope;
  source_type: string | null;
  source_id: string | null;
  assigned_admin_id: string | null;
  due_at: string | null;
  started_at: string | null;
  completed_at: string | null;
  progress: number;
  score: number | null;
  metadata: Record<string, unknown>;
  created_by: string | null;
  updated_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface AdminOperationsOverview {
  refreshed_at: string;
  open_total: number;
  overdue: number;
  critical: number;
  owner_actions: number;
  incidents_open: number;
  sync_failures: number;
  objectives_active: number;
  restore_tests_due: number;
  by_kind: Array<{ kind: AdminOperationKind; open: number }>;
}

export interface AdminOperationHistory {
  id: number;
  item_id: string;
  action: string;
  from_status: AdminOperationStatus | null;
  to_status: AdminOperationStatus | null;
  note: string | null;
  snapshot: Record<string, unknown>;
  actor_id: string | null;
  created_at: string;
}

export interface AdminMetricDefinition {
  metric_key: string;
  label: string;
  definition: string;
  formula: string;
  source: string;
  unit: string;
  cadence: string;
  timezone: string;
  minimum_sample: number;
  interpretation_limit: string;
  version: number;
  updated_by: string | null;
  updated_at: string;
}

export interface AdminFeatureFlag {
  key: string;
  description: string | null;
  value_type: "bool" | "string" | "int" | "double" | "variant";
  value_default: unknown;
  rollout_percent: number | null;
  is_active: boolean;
  segment: string | null;
  updated_at: string;
}

export interface AdminDataSourceStatus {
  key: string;
  label: string;
  category: "product" | "learning" | "billing" | "store" | "email" | "infrastructure" | "analytics";
  mode: "realtime" | "calculated" | "imported" | "manual";
  status: "healthy" | "delayed" | "failed" | "not_connected" | "paused";
  freshness_target_minutes: number;
  last_success_at: string | null;
  last_failure_at: string | null;
  next_check_at: string | null;
  record_count: number;
  last_error: string | null;
  public_config: Record<string, unknown>;
  latest_run: Record<string, unknown> | null;
}

export interface AdminPremiumControlOverview {
  refreshed_at: string;
  days: number;
  sources: AdminDataSourceStatus[];
  economy: {
    gross_revenue_cents: number;
    paid_invoices: number;
    active_subscriptions: number;
    trials: number;
    cancel_at_period_end: number;
    past_due: number;
    expired: number;
    by_store: Array<{ store: string; total: number }>;
    external_metrics_available: number;
  };
  content_quality: {
    courses_total: number;
    courses_published: number;
    courses_without_body: number;
    courses_without_media_alt: number;
    orphan_courses: number;
    active_nodes_total: number;
    active_nodes_without_image: number;
    translations: { total: number; approved: number; missing: number };
  };
  store_reviews: {
    total: number;
    unprocessed: number;
    average_rating: number | null;
    by_platform: Array<{ platform: string; reviews: number; rating: number }>;
  };
  forecast: {
    method: string;
    minimum_observed_days: number;
    activity_available: boolean;
    answers_available: boolean;
    activity_observed_days: number;
    answers_observed_days: number;
    activity: AdminForecastPoint[];
    answers: AdminForecastPoint[];
  };
  saved_views: number;
  report_schedules: number;
  restore_exercises: {
    total: number;
    passed: number;
    failed: number;
    last: AdminRestoreExercise | null;
  };
}

export interface AdminForecastPoint {
  date: string;
  estimate: number;
  low: number;
  high: number;
}

export interface AdminContentGraphNode {
  id: string;
  entity_type: "course" | "active_node";
  entity_id: string;
  label: string;
  route: string | null;
  scope: string;
  status: string;
  warnings: Array<string | null>;
}

export interface AdminContentDependencyGraph {
  nodes: AdminContentGraphNode[];
  edges: Array<{ from: string; to: string; relation: string }>;
}

export interface AdminContentImpactPreview {
  entity: Record<string, unknown> & { type: string; id: string | number; title: string };
  impact_level: "low" | "medium" | "high";
  users_30d?: number;
  views_30d?: number;
  children: number;
  media?: number;
  versions?: number;
  quiz_answers_30d?: number;
  checks: Array<{ label: string; ok: boolean }>;
}

export interface AdminSavedView {
  id: string;
  owner_id: string;
  name: string;
  page_key: string;
  filters: Record<string, unknown>;
  is_default: boolean;
  created_at: string;
  updated_at: string;
}

export interface AdminRestoreExercise {
  id: string;
  environment: "isolated" | "staging" | "disaster-recovery";
  backup_reference: string;
  status: "planned" | "running" | "passed" | "failed" | "cancelled";
  started_at: string | null;
  finished_at: string | null;
  recovery_time_minutes: number | null;
  data_loss_minutes: number | null;
  integrity_checks: Array<{ label: string; ok: boolean }>;
  result_notes: string;
  evidence_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface AdminStoreReview {
  id: string;
  source_key: string;
  provider_review_id: string;
  platform: "ios" | "android";
  rating: number;
  title: string | null;
  review_text: string;
  app_version: string | null;
  country_code: string | null;
  theme: string | null;
  internal_status: "new" | "analysed" | "planned" | "resolved" | "ignored";
  public_created_at: string | null;
  imported_at: string;
}

export interface AdminReportSchedule {
  id: string;
  name: string;
  report_key: string;
  format: "pdf" | "csv" | "json";
  cadence: "daily" | "weekly" | "monthly" | "manual";
  filters: Record<string, unknown>;
  recipients: string[];
  active: boolean;
  next_run_at: string | null;
  last_run_at: string | null;
  last_status: string | null;
  last_error: string | null;
  created_at: string;
  updated_at: string;
}

export interface AdminDataSourceRun {
  id: number;
  source_key: string;
  run_key: string;
  status: "running" | "succeeded" | "partial" | "failed" | "cancelled";
  started_at: string;
  finished_at: string | null;
  input_count: number;
  output_count: number;
  duplicate_count: number;
  duration_ms: number | null;
  error_code: string | null;
  error_message: string | null;
  metadata: Record<string, unknown>;
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
    const { data: factors, error: factorsError } =
      await supabase.auth.mfa.listFactors();
    if (factorsError) throw new AdminApiError(factorsError.message);
    // Supprime seulement les enrôlements interrompus afin qu'un nouveau QR
    // code puisse être généré. Un facteur vérifié n'est jamais touché.
    for (const factor of (factors.all ?? []).filter(
      (item) => item.factor_type === "totp" && item.status === "unverified",
    )) {
      const { error: cleanupError } = await supabase.auth.mfa.unenroll({
        factorId: factor.id,
      });
      if (cleanupError) throw new AdminApiError(cleanupError.message);
    }
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

export type CommunityActivityType =
  | "post"
  | "comment"
  | "like"
  | "deletion"
  | "report"
  | "moderation"
  | "sanction";

export interface CommunitySpaceSummary {
  space_id: string;
  space_label: string;
  color_hex: string;
  posts: number;
  comments: number;
  likes: number;
  reports: number;
  removed: number;
  active_sanctions: number;
  last_activity_at: string | null;
}

export interface CommunityActivityEvent {
  event_id: string;
  event_type: CommunityActivityType;
  event_at: string;
  space_id: string;
  space_label: string;
  actor_id: string | null;
  actor_name: string;
  actor_email: string | null;
  target_type: string;
  target_id: string;
  title: string | null;
  content: string | null;
  status: string | null;
  metadata: Record<string, unknown>;
  total_count: number;
}

export const communityForumApi = {
  spaceSummary: () =>
    rpc<CommunitySpaceSummary[]>("community_admin_space_summary"),

  activityFeed: (
    opts: {
      spaceId?: string;
      eventType?: CommunityActivityType;
      search?: string;
      limit?: number;
      offset?: number;
    } = {},
  ) =>
    rpc<CommunityActivityEvent[]>("community_admin_activity_feed", {
      p_space_id: opts.spaceId || null,
      p_event_type: opts.eventType || null,
      p_search: opts.search || null,
      p_limit: opts.limit ?? 50,
      p_offset: opts.offset ?? 0,
    }),

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

export interface AppRuntimeConfig {
  id: number;
  legal_warning_enabled: boolean;
  legal_warning_revision: number;
  legal_warning_title: string;
  legal_warning_content: string;
  updated_at: string;
  updated_by: string | null;
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
  runtimeConfig: () => rpc<AppRuntimeConfig>("app_runtime_config_admin_get"),
  updateRuntimeConfig: (data: {
    enabled: boolean;
    title: string;
    content: string;
    redisplayToAll: boolean;
  }) =>
    rpc<AppRuntimeConfig>("app_runtime_config_admin_update", {
      p_enabled: data.enabled,
      p_title: data.title,
      p_content: data.content,
      p_redisplay_to_all: data.redisplayToAll,
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
/*  Versions mobiles — mutations atomiques et contrôlées côté PostgreSQL      */
/* ────────────────────────────────────────────────────────────────────────── */

export interface MobileReleaseConfig {
  platform: "ios" | "android";
  min_version: string;
  latest_version: string;
  min_build_number: number;
  latest_build_number: number;
  store_url: string;
  force_update: boolean;
  message: string;
  release_available: boolean;
  available_build_number: number | null;
  availability_confirmed_at: string | null;
  availability_confirmed_by: string | null;
  updated_at: string;
}

export const mobileReleaseApi = {
  list: () => rpc<MobileReleaseConfig[]>("admin_mobile_release_list"),
  prepare: (data: {
    build: number;
    version: string;
    message: string;
    iosUrl: string;
    androidUrl: string;
  }) =>
    rpc<{ ok: boolean; build: number; version: string }>(
      "admin_mobile_release_prepare",
      {
        p_build: data.build,
        p_version: data.version,
        p_message: data.message,
        p_ios_url: data.iosUrl,
        p_android_url: data.androidUrl,
      },
    ),
  markAvailable: (platform: "ios" | "android", build: number) =>
    rpc<{ ok: boolean; platform: string; build: number }>(
      "admin_mobile_release_mark_available",
      {
        p_platform: platform,
        p_build: build,
      },
    ),
  activate: (build: number) =>
    rpc<{ ok: boolean; build: number; forced: boolean }>(
      "admin_mobile_release_activate",
      {
        p_build: build,
      },
    ),
  disableForce: () =>
    rpc<{ ok: boolean; forced: boolean }>("admin_mobile_release_disable_force"),
};

export interface CoachAdminOverview {
  users_configured: number;
  users_with_exam_date: number;
  reflections: number;
  weekly_summaries: number;
  calendar_events: number;
  generated_at: string;
  calendar_last_run: null | {
    status: "running" | "success" | "partial" | "failed";
    events_found: number;
    started_at: string;
    finished_at: string | null;
    error_message: string | null;
    source_status: Record<
      string,
      { ok?: boolean; events?: number; url?: string }
    >;
  };
}

export const coachAdminApi = {
  overview: () => rpc<CoachAdminOverview>("admin_coach_overview"),
};

/* ────────────────────────────────────────────────────────────────────────── */
/*  Modules transverses (RPC déjà présentes en base)                          */
/* ────────────────────────────────────────────────────────────────────────── */

export const supportApi = {
  reports: (kind?: string, status?: string, search?: string) =>
    rpc<Record<string, unknown>[]>("admin_report_center_list", {
      p_kind: kind || null,
      p_status: status || null,
      p_search: search || null,
      p_limit: 150,
      p_offset: 0,
    }),

  inspectReport: (kind: string, id: string) =>
    rpc<ReportInspection>("admin_report_inspect", { p_kind: kind, p_id: id }),

  addReportNote: (kind: string, id: string, note: string) =>
    rpc<Record<string, unknown>>("admin_report_add_note", {
      p_kind: kind,
      p_id: id,
      p_note: note,
    }),

  setReportStatus: (
    kind: string,
    id: string,
    status: string,
    archive = false,
    note?: string,
  ) =>
    rpc<Record<string, unknown>>("admin_report_set_status", {
      p_kind: kind,
      p_id: id,
      p_status: status,
      p_archive: archive,
      p_note: note ?? null,
    }),

  async resolveReportWithEmail(
    kind: string,
    id: string,
    archive = false,
    note?: string,
  ) {
    const supabase = createClient();
    const { data, error } = await supabase.functions.invoke(
      "admin_report_resolved_email",
      { body: { kind, id, archive, note: note ?? null } },
    );
    if (error) {
      const message =
        (data as { message?: string } | null)?.message ?? error.message;
      throw new AdminApiError(message);
    }
    return data as {
      ok: boolean;
      report: Record<string, unknown>;
      email_sent: boolean;
      already_sent?: boolean;
      email_reason?: string;
      reference?: string;
    };
  },

  updateReportTarget: (
    kind: string,
    id: string,
    expected: Record<string, unknown>,
    patch: Record<string, unknown>,
    resolve = false,
  ) =>
    rpc<{
      ok: boolean;
      target: Record<string, unknown>;
      report_resolved: boolean;
    }>("admin_report_update_target", {
      p_kind: kind,
      p_id: id,
      p_expected: expected,
      p_patch: patch,
      p_resolve: resolve,
    }),

  deleteReport: (kind: string, id: string) =>
    rpc<{ ok: boolean }>("admin_report_delete", { p_kind: kind, p_id: id }),

  deleteReportTarget: (kind: string, id: string) =>
    rpc<{ ok: boolean; deleted_table: string; deleted_id: string }>(
      "admin_report_delete_target",
      { p_kind: kind, p_id: id },
    ),

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

  dashboardStats: () => rpc<AdminDashboardStats>("admin_dashboard_stats_live"),

  appAnalytics: (days: 7 | 30 | 90) =>
    rpc<AdminAppAnalytics>("admin_app_analytics", { p_days: days }),
  periodComparison: (days: 7 | 30 | 90) =>
    rpc<AdminPeriodComparison>("admin_period_comparison", { p_days: days }),
  learningAnalytics: (days: 7 | 30 | 90) =>
    rpc<AdminLearningAnalytics>("admin_learning_analytics", { p_days: days }),
  qualityAnalytics: (days: 7 | 30 | 90) =>
    rpc<AdminQualityAnalytics>("admin_quality_analytics", { p_days: days }),
  communityAnalytics: (days: 7 | 30 | 90) =>
    rpc<AdminCommunityAnalytics>("admin_community_analytics", { p_days: days }),

  operationsOverview: () =>
    rpc<AdminOperationsOverview>("admin_operations_overview"),
  operationsList: (opts: { kind?: AdminOperationKind; status?: AdminOperationStatus; search?: string; limit?: number } = {}) =>
    rpc<AdminOperationItem[]>("admin_operations_list", {
      p_kind: opts.kind ?? null,
      p_status: opts.status ?? null,
      p_search: opts.search || null,
      p_limit: opts.limit ?? 200,
    }),
  operationSave: (data: Partial<AdminOperationItem> & Pick<AdminOperationItem, "title">) =>
    rpc<AdminOperationItem>("admin_operations_save", { p_data: data }),
  operationTransition: (id: string, status: AdminOperationStatus, note?: string) =>
    rpc<AdminOperationItem>("admin_operations_transition", {
      p_id: id,
      p_status: status,
      p_note: note ?? null,
    }),
  operationHistory: (id: string) =>
    rpc<AdminOperationHistory[]>("admin_operations_history_list", { p_item_id: id }),
  metricDictionary: () =>
    rpc<AdminMetricDefinition[]>("admin_metric_dictionary"),
  featureFlags: () =>
    rpc<AdminFeatureFlag[]>("admin_feature_flags_list"),
  featureFlagUpdate: (data: { key: string; active: boolean; rollout?: number | null; segment?: string | null; confirmation: string }) =>
    rpc<AdminFeatureFlag>("admin_feature_flag_update", {
      p_key: data.key,
      p_active: data.active,
      p_rollout: data.rollout ?? null,
      p_segment: data.segment ?? null,
      p_confirmation: data.confirmation,
    }),

  premiumControlOverview: (days: 7 | 30 | 90 = 30) =>
    rpc<AdminPremiumControlOverview>("admin_premium_control_overview", { p_days: days }),
  refreshInternalSources: () =>
    rpc<{ refreshed_at: string; sources: number }>("admin_data_sources_refresh_internal"),
  contentDependencyGraph: (search?: string) =>
    rpc<AdminContentDependencyGraph>("admin_content_dependency_graph", { p_search: search || null }),
  contentImpactPreview: (entityType: "course" | "active_node", entityId: string) =>
    rpc<AdminContentImpactPreview>("admin_content_impact_preview", {
      p_entity_type: entityType,
      p_entity_id: entityId,
    }),
  bulkOperationsPreview: (action: "operations_start" | "operations_complete" | "operations_archive", targetIds: string[]) =>
    rpc<{ action: "operations_start" | "operations_complete" | "operations_archive"; target_count: number; targets: Array<Record<string, unknown>>; confirmation: string; effects: string }>("admin_bulk_operations_preview", {
      p_action: action,
      p_target_ids: targetIds,
    }),
  bulkOperationsExecute: (action: "operations_start" | "operations_complete" | "operations_archive", targetIds: string[], confirmation: string) =>
    rpc<{ job_id: string; updated: number; status: string }>("admin_bulk_operations_execute", {
      p_action: action,
      p_target_ids: targetIds,
      p_confirmation: confirmation,
    }),
  savedViews: (pageKey?: string) =>
    rpc<AdminSavedView[]>("admin_saved_views_list", { p_page_key: pageKey ?? null }),
  saveView: (data: { id?: string; name: string; pageKey: string; filters: Record<string, unknown>; isDefault?: boolean }) =>
    rpc<AdminSavedView>("admin_saved_view_save", {
      p_id: data.id ?? null,
      p_name: data.name,
      p_page_key: data.pageKey,
      p_filters: data.filters,
      p_is_default: data.isDefault ?? false,
    }),
  restoreExercises: () =>
    rpc<AdminRestoreExercise[]>("admin_restore_exercises_list"),
  saveRestoreExercise: (data: Partial<AdminRestoreExercise> & Pick<AdminRestoreExercise, "backup_reference">) =>
    rpc<AdminRestoreExercise>("admin_restore_exercise_save", { p_data: data }),
  translationOverview: () =>
    rpc<{ items: Array<Record<string, unknown>>; by_locale: Array<{ locale: string; total: number; approved: number; missing: number }> }>("admin_translation_overview"),
  storeReviews: (status?: string, platform?: string) =>
    rpc<AdminStoreReview[]>("admin_store_reviews_list", {
      p_status: status ?? null,
      p_platform: platform ?? null,
    }),
  reportSchedules: () =>
    rpc<AdminReportSchedule[]>("admin_report_schedules_list"),
  saveReportSchedule: (data: Partial<AdminReportSchedule> & Pick<AdminReportSchedule, "name">) =>
    rpc<AdminReportSchedule>("admin_report_schedule_save", { p_data: data }),
  dataSourceRuns: (sourceKey?: string, limit = 100) =>
    rpc<AdminDataSourceRun[]>("admin_data_source_runs_list", {
      p_source_key: sourceKey ?? null,
      p_limit: limit,
    }),

  users: (search?: string) =>
    rpc<Record<string, unknown>[]>("admin_users_overview", {
      p_search: search || null,
      p_premium: null,
      p_role: null,
      p_limit: 60,
      p_offset: 0,
    }),
};

export interface ReportInspection {
  report: Record<string, unknown>;
  target: Record<string, unknown> | null;
  target_table: string | null;
  target_found: boolean;
  can_edit: boolean;
  can_delete_report: boolean;
  can_delete_target: boolean;
  notes: Record<string, unknown>[];
  history: Record<string, unknown>[];
}

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
  platform: string | null;
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
  cgv_audit?: {
    accepted?: boolean | null;
    accepted_at?: string | null;
    version?: string | null;
    source?: string | null;
    recorded_at?: string | null;
    historical_inference?: boolean;
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

export type AdminUserTableScan = Record<
  string,
  { count: number; relation: string }
>;

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

  detail: async (userId: string) => {
    const [detail, cgv] = await Promise.all([
      rpc<CommunityAdminUserDetail>("community_admin_user_detail", {
        p_user_id: userId,
      }),
      rpc<NonNullable<CommunityAdminUserDetail["cgv_audit"]>>(
        "community_admin_user_cgv_status",
        { p_user_id: userId },
      ),
    ]);
    return { ...detail, cgv_audit: cgv };
  },

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

  messages: (userId: string, opts: { limit?: number; offset?: number } = {}) =>
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

/** Accès professionnels « Je suis actif » — toutes les RPC restent gardées côté serveur. */
export const activeAccessAdminApi = {
  list: (filters: { status?: string; search?: string } = {}) =>
    rpc<ActiveAccessRow[]>("admin_active_access_list", {
      p_status: filters.status ?? null,
      p_search: filters.search ?? null,
    }),

  detail: (userId: string) =>
    rpc<ActiveAccessDetail>("admin_active_access_detail", {
      p_user_id: userId,
    }),

  setAccess: (
    userId: string,
    action: "grant" | "restore" | "revoke",
    reason?: string,
  ) =>
    rpc<ActiveAccessDetail["access"]>("admin_active_access_set", {
      p_user_id: userId,
      p_action: action,
      p_reason: reason?.trim() || null,
    }),
};

export const activeContentAdminApi = {
  state: () => rpc<ActiveContentState>("admin_active_content_state"),
  gradePickerState: () =>
    rpc<GradePickerConfig>("admin_grade_picker_config_state"),
  setReserveVisibility: (enabled: boolean) =>
    rpc<GradePickerConfig>("admin_grade_picker_reserve_set", {
      p_enabled: enabled,
    }),
  setEnabled: (enabled: boolean, message?: string) =>
    rpc<ActiveContentState["config"]>("admin_active_config_set", {
      p_enabled: enabled,
      p_message: message?.trim() || null,
    }),
  setOwnerPreview: (enabled: boolean) =>
    rpc<ActiveContentState["config"]>("admin_active_owner_preview_set", {
      p_enabled: enabled,
    }),
  save: (
    node: Partial<ActiveContentNode> &
      Pick<ActiveContentNode, "node_type" | "title">,
  ) =>
    rpc<ActiveContentNode>("admin_active_content_save", {
      p_id: node.id ?? null,
      p_parent_id: node.parent_id ?? null,
      p_node_type: node.node_type,
      p_title: node.title,
      p_subtitle: node.subtitle ?? null,
      p_image_url: node.image_url ?? null,
      p_icon: node.icon ?? null,
      p_sort_order: node.sort_order ?? 0,
      p_content: node.draft_content ?? [],
    }),
  publish: (id: string) =>
    rpc<ActiveContentNode>("admin_active_content_publish", { p_id: id }),
  archive: (id: string, title: string) =>
    rpc<void>("admin_active_content_archive", {
      p_id: id,
      p_confirmation: `ARCHIVER ${title}`,
    }),
};

type AdminContactResponse = {
  ok: boolean;
  message?: string;
  emailable_count?: number;
  sender?: string;
  campaigns?: AdminEmailCampaign[];
  users?: AdminEmailUserResult[];
  campaign?: AdminEmailCampaign;
  sent_to?: string;
  status?: AdminEmailCampaign["status"];
  submitted_count?: number;
  failed_count?: number;
};

async function contactEmailInvoke(
  body: Record<string, unknown>,
): Promise<AdminContactResponse> {
  const supabase = createClient();
  const { data, error } = await supabase.functions.invoke(
    "admin_contact_email",
    { body },
  );
  if (error) {
    const message =
      (data as { message?: string } | null)?.message ?? error.message;
    throw new AdminApiError(message);
  }
  const response = data as AdminContactResponse & { error?: string };
  if (response.error) throw new AdminApiError(response.message ?? response.error);
  return response;
}

/** Centre de contact owner : les adresses et l'envoi restent dans l'Edge Function. */
export const contactEmailAdminApi = {
  overview: () => contactEmailInvoke({ action: "overview" }),
  searchUsers: (query: string) =>
    contactEmailInvoke({ action: "search_users", query }),
  createDraft: (campaign: {
    campaign_type: AdminEmailCampaignType;
    audience_kind: AdminEmailAudienceKind;
    target_user_id?: string | null;
    subject: string;
    headline: string;
    body_text: string;
    cta_label?: string | null;
    cta_url?: string | null;
  }) => contactEmailInvoke({ action: "create_draft", campaign }),
  sendTest: (campaignId: string) =>
    contactEmailInvoke({ action: "send_test", campaign_id: campaignId }),
  cancel: (campaignId: string) =>
    contactEmailInvoke({ action: "cancel", campaign_id: campaignId }),
  launch: (campaignId: string, recipientCount: number, confirmation: string) =>
    contactEmailInvoke({
      action: "launch",
      campaign_id: campaignId,
      confirmed_recipient_count: recipientCount,
      confirmation,
    }),
};
