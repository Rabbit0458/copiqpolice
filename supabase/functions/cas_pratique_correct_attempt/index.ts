// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Edge function : correction d'une tentative    ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md             ║
// ║  Tâche      : CODE-051                                                  ║
// ║                                                                         ║
// ║  Le moteur de correction (port TS du moteur Dart) vit dans `_engine.ts`║
// ║  pour pouvoir être réutilisé par le test de parité CODE-052.            ║
// ║                                                                         ║
// ║  Endpoint :                                                             ║
// ║    POST /functions/v1/cas_pratique_correct_attempt                      ║
// ║    Body : { attempt_id, case_id, answers: Record<questionId,string>,    ║
// ║             time_spent_ms?: number }                                    ║
// ║    Headers : Authorization: Bearer <user JWT>                           ║
// ║                                                                         ║
// ║  Codes d'erreur :                                                       ║
// ║    400 invalid_input  401 not_authenticated  403 attempt_not_owned     ║
// ║    404 case_not_found / attempt_not_found  409 attempt_already_finished║
// ║    500 engine_crashed                                                   ║
// ╚════════════════════════════════════════════════════════════════════════╝

// deno-lint-ignore-file no-explicit-any
// @ts-ignore — Deno-only standard import
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
// @ts-ignore — Deno-only module
import { createClient, SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.39.7";

import {
  ENGINE_VERSION,
  PARTIAL_THRESHOLD,
  scoreAttempt,
  type EngineKeywordGroup,
  type EngineRubricPoint,
  type EngineSynDict,
  type QuestionSpec,
} from "./_engine.ts";

import {
  consumeRateLimit,
  rateLimitedResponse,
  RATE_PROFILES,
} from "../_shared/rate_limit.ts";

interface RequestBody {
  attempt_id?: string;
  case_id?: string;
  answers?: Record<string, string>;
  time_spent_ms?: number;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      "content-type": "application/json; charset=utf-8",
      "cache-control": "no-store",
    },
  });
}

function errorResponse(error: string, status: number, detail?: unknown): Response {
  return jsonResponse({ error, ...(detail !== undefined ? { detail } : {}) }, status);
}

async function loadRubric(
  service: SupabaseClient,
  caseId: string,
): Promise<{
  specs: QuestionSpec[];
  dictById: Map<string, EngineSynDict>;
  pointById: Map<string, EngineRubricPoint>;
}> {
  const { data: questionsRows, error: qErr } = await service
    .from("cas_pratique_questions")
    .select("id, max_points, position")
    .eq("case_id", caseId)
    .order("position", { ascending: true });
  if (qErr) throw qErr;
  if (!questionsRows || questionsRows.length === 0) {
    throw new Error("case_not_found");
  }
  const qIds = questionsRows.map((q: any) => q.id as string);

  const { data: pointRows, error: pErr } = await service
    .from("cas_pratique_rubric_points")
    .select("id, question_id, position, label, weight, is_required, kind, explanation_md")
    .in("question_id", qIds)
    .order("position", { ascending: true });
  if (pErr) throw pErr;

  const pointsByQuestion = new Map<string, EngineRubricPoint[]>();
  const pointById = new Map<string, EngineRubricPoint>();
  const allPointIds: string[] = [];
  for (const r of pointRows ?? []) {
    const point: EngineRubricPoint = {
      id: r.id,
      question_id: r.question_id,
      position: r.position ?? 0,
      label: r.label ?? "",
      weight: Number(r.weight ?? 1),
      is_required: r.is_required ?? true,
      kind: r.kind ?? "core",
      explanation_md: r.explanation_md ?? null,
    };
    if (!pointsByQuestion.has(point.question_id)) {
      pointsByQuestion.set(point.question_id, []);
    }
    pointsByQuestion.get(point.question_id)!.push(point);
    pointById.set(point.id, point);
    allPointIds.push(point.id);
  }

  const groupsByPoint = new Map<string, EngineKeywordGroup[]>();
  const allGroupIds: string[] = [];
  if (allPointIds.length > 0) {
    const { data: groupRows, error: gErr } = await service
      .from("cas_pratique_keyword_groups")
      .select("id, point_id, position, description, is_optional")
      .in("point_id", allPointIds)
      .order("position", { ascending: true });
    if (gErr) throw gErr;

    const tempGroups = new Map<string, EngineKeywordGroup & { point_id: string }>();
    for (const g of groupRows ?? []) {
      tempGroups.set(g.id, {
        id: g.id,
        position: g.position ?? 0,
        description: g.description ?? null,
        is_optional: g.is_optional ?? false,
        keywords: [],
        point_id: g.point_id,
      });
      allGroupIds.push(g.id);
    }

    if (allGroupIds.length > 0) {
      const { data: kwRows, error: kwErr } = await service
        .from("cas_pratique_keywords")
        .select("id, group_id, syn_dict_id, value, is_phrase, is_negation, fuzzy_max_dist, position")
        .in("group_id", allGroupIds)
        .order("position", { ascending: true });
      if (kwErr) throw kwErr;
      for (const k of kwRows ?? []) {
        const target = tempGroups.get(k.group_id);
        if (!target) continue;
        target.keywords.push({
          value: k.value ?? null,
          syn_dict_id: k.syn_dict_id ?? null,
          is_phrase: k.is_phrase ?? false,
          is_negation: k.is_negation ?? false,
          fuzzy_max_dist: k.fuzzy_max_dist ?? 1,
        });
      }
    }

    for (const tg of tempGroups.values()) {
      const arr = groupsByPoint.get(tg.point_id) ?? [];
      arr.push({
        id: tg.id,
        position: tg.position,
        description: tg.description,
        is_optional: tg.is_optional,
        keywords: tg.keywords,
      });
      groupsByPoint.set(tg.point_id, arr);
    }
  }

  const synDictIds = new Set<string>();
  for (const groups of groupsByPoint.values()) {
    for (const g of groups) {
      for (const kw of g.keywords) {
        if (kw.syn_dict_id) synDictIds.add(kw.syn_dict_id);
      }
    }
  }
  const dictById = new Map<string, EngineSynDict>();
  if (synDictIds.size > 0) {
    const { data: dictRows, error: dErr } = await service
      .from("cas_pratique_synonyms_dictionary")
      .select("id, slug, terms")
      .in("id", Array.from(synDictIds));
    if (dErr) throw dErr;
    for (const d of dictRows ?? []) {
      dictById.set(d.id, {
        id: d.id,
        slug: d.slug,
        terms: Array.isArray(d.terms) ? d.terms.map(String) : [],
      });
    }
  }

  const specs: QuestionSpec[] = questionsRows.map((q: any) => ({
    questionId: q.id as string,
    maxPoints: (q.max_points as number) ?? 5,
    points: pointsByQuestion.get(q.id) ?? [],
    groupsByPoint,
  }));

  return { specs, dictById, pointById };
}

serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 204,
      headers: {
        "access-control-allow-origin": "*",
        "access-control-allow-methods": "POST, OPTIONS",
        "access-control-allow-headers": "authorization, x-client-info, content-type",
      },
    });
  }
  if (req.method !== "POST") return errorResponse("method_not_allowed", 405);

  // @ts-ignore — Deno global
  const SUPABASE_URL = Deno.env.get("SUPABASE_URL");
  // @ts-ignore — Deno global
  const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!SUPABASE_URL || !SERVICE_ROLE_KEY) {
    return errorResponse("server_misconfigured", 500);
  }

  const authHeader = req.headers.get("authorization") ?? "";
  if (!authHeader.toLowerCase().startsWith("bearer ")) {
    return errorResponse("not_authenticated", 401);
  }
  const userToken = authHeader.substring(7).trim();

  const callerClient = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
    global: { headers: { Authorization: `Bearer ${userToken}` } },
    auth: { persistSession: false },
  });
  const service = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
    auth: { persistSession: false },
  });

  const { data: userData, error: userErr } = await callerClient.auth.getUser(userToken);
  if (userErr || !userData?.user) return errorResponse("not_authenticated", 401);
  const userId = userData.user.id;

  // CODE-054 — rate limit avant tout travail coûteux. On utilise le `caller`
  // (JWT user) pour que `auth.uid()` dans la fonction SQL lise l'identité
  // réelle de l'appelant.
  const rl = await consumeRateLimit(callerClient, RATE_PROFILES.finishCorrect);
  if (!rl.allowed) return rateLimitedResponse(rl);

  let body: RequestBody;
  try {
    body = await req.json();
  } catch {
    return errorResponse("invalid_input", 400, "body must be JSON");
  }
  const attemptId = body.attempt_id;
  const caseId = body.case_id;
  const answers = body.answers ?? {};
  const timeSpentMs = Number(body.time_spent_ms ?? 0);
  if (!attemptId || !caseId) {
    return errorResponse("invalid_input", 400, "attempt_id and case_id required");
  }

  try {
    const { data: attempt, error: aErr } = await service
      .from("cas_pratique_attempts")
      .select("id, user_id, case_id, status")
      .eq("id", attemptId)
      .maybeSingle();
    if (aErr) throw aErr;
    if (!attempt) return errorResponse("attempt_not_found", 404);
    if (attempt.user_id !== userId) return errorResponse("attempt_not_owned", 403);
    if (attempt.case_id !== caseId) {
      return errorResponse("invalid_input", 400, "case_id mismatch with attempt");
    }
    if (attempt.status === "completed") {
      return errorResponse("attempt_already_finished", 409);
    }

    const { specs, dictById, pointById } = await loadRubric(service, caseId);
    const result = scoreAttempt(specs, answers, dictById);

    const { data: corrInsert, error: ciErr } = await service
      .from("cas_pratique_corrections")
      .insert({
        attempt_id: attemptId,
        total_score: result.totalScore,
        total_max: result.totalMax,
        percent: result.percent,
        engine_version: ENGINE_VERSION,
        engine_settings: {
          normalizer: "v1",
          fuzzy: true,
          ngrams: true,
          lemma: true,
          partial_threshold: PARTIAL_THRESHOLD,
        },
      })
      .select("id")
      .single();
    if (ciErr) throw ciErr;
    const corrId = corrInsert.id as string;

    const detailsPayload = [];
    for (const qr of result.questionResults) {
      for (const pe of qr.points) {
        detailsPayload.push({
          correction_id: corrId,
          question_id: qr.questionId,
          point_id: pe.point_id,
          status: pe.status,
          score: pe.score,
          weight: pe.weight,
          group_matches: pe.group_matches,
        });
      }
    }
    let inserted: any[] = [];
    if (detailsPayload.length > 0) {
      const { data, error: diErr } = await service
        .from("cas_pratique_correction_details")
        .insert(detailsPayload)
        .select("id, correction_id, question_id, point_id, status, score, weight, group_matches");
      if (diErr) throw diErr;
      inserted = data ?? [];
    }

    const { error: upErr } = await service
      .from("cas_pratique_attempts")
      .update({
        status: "completed",
        total_score: result.totalScore,
        total_max: result.totalMax,
        percent: result.percent,
        finished_at: new Date().toISOString(),
        time_spent_ms: timeSpentMs,
      })
      .eq("id", attemptId);
    if (upErr) throw upErr;

    const details = inserted.map((d: any) => {
      const p = pointById.get(d.point_id);
      return {
        id: d.id,
        question_id: d.question_id,
        point_id: d.point_id,
        point_label: p?.label ?? "",
        point_kind: p?.kind ?? "core",
        status: d.status,
        score: d.score,
        weight: d.weight,
        explanation_md: p?.explanation_md ?? null,
        group_matches: d.group_matches ?? [],
      };
    });

    return jsonResponse({
      correction: {
        id: corrId,
        attempt_id: attemptId,
        total_score: result.totalScore,
        total_max: result.totalMax,
        percent: result.percent,
        evaluated_at: new Date().toISOString(),
        engine_version: ENGINE_VERSION,
        details,
      },
      engine_version: ENGINE_VERSION,
    });
  } catch (e: any) {
    if (e && (e === "case_not_found" || e?.message === "case_not_found")) {
      return errorResponse("case_not_found", 404);
    }
    const msg = e?.message ?? String(e);
    console.error("[cas_pratique_correct_attempt] crash:", msg, e);
    return errorResponse("engine_crashed", 500, msg);
  }
});
