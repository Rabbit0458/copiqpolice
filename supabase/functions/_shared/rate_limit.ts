// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Helper rate limit (token bucket)              ║
// ║  Tâche      : CODE-054                                                  ║
// ║                                                                         ║
// ║  Wrapper sur la fonction Postgres `fn_cp_consume_token(...)` créée par ║
// ║  la migration 20260518000001. À importer depuis n'importe quelle edge  ║
// ║  function pour gater l'accès aux endpoints critiques.                  ║
// ║                                                                         ║
// ║  Usage type :                                                           ║
// ║    const rl = await consumeRateLimit(callerClient, 'cp.finish_correct', ║
// ║                                       RATE_PROFILES.finishCorrect);     ║
// ║    if (!rl.allowed) return rateLimitedResponse(rl);                     ║
// ╚════════════════════════════════════════════════════════════════════════╝

// deno-lint-ignore-file no-explicit-any
import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.39.7";

export interface RateProfile {
  /** Identifiant logique pour la table buckets, ex "cp.finish_correct" */
  scope: string;
  capacity: number;
  refillPerWindow: number;
  windowSeconds: number;
}

/** Catalogue des rates par défaut (à respecter dans tout le code client + edge). */
export const RATE_PROFILES = {
  // 60 req / minute
  listCases: {
    scope: "cp.list_cases",
    capacity: 60,
    refillPerWindow: 60,
    windowSeconds: 60,
  } satisfies RateProfile,
  // 600 req / minute (autosave debounce 1.5s × n questions → marge confortable)
  saveDraft: {
    scope: "cp.save_draft",
    capacity: 600,
    refillPerWindow: 600,
    windowSeconds: 60,
  } satisfies RateProfile,
  // 30 req / minute
  validateAnswer: {
    scope: "cp.validate_answer",
    capacity: 30,
    refillPerWindow: 30,
    windowSeconds: 60,
  } satisfies RateProfile,
  // 10 req / minute
  finishCorrect: {
    scope: "cp.finish_correct",
    capacity: 10,
    refillPerWindow: 10,
    windowSeconds: 60,
  } satisfies RateProfile,
  // 20 req / jour
  createAppeal: {
    scope: "cp.create_appeal",
    capacity: 20,
    refillPerWindow: 20,
    windowSeconds: 24 * 60 * 60,
  } satisfies RateProfile,
} as const;

export type RateLimitOk = {
  allowed: true;
  tokensRemaining: number;
  capacity: number;
};
export type RateLimitDenied = {
  allowed: false;
  retryAfterSeconds: number;
  capacity: number;
};
export type RateLimitResult = RateLimitOk | RateLimitDenied;

/**
 * Tente de consommer 1 token. Le client doit être authentifié (caller JWT) :
 * `auth.uid()` côté Postgres lit l'identité réelle de l'appelant.
 */
export async function consumeRateLimit(
  caller: SupabaseClient,
  profile: RateProfile,
): Promise<RateLimitResult> {
  const { data, error } = await caller.rpc("fn_cp_consume_token", {
    p_scope: profile.scope,
    p_capacity: profile.capacity,
    p_refill_per_window: profile.refillPerWindow,
    p_window_seconds: profile.windowSeconds,
  });
  if (error) {
    // En cas d'erreur côté DB : on refuse — fail-closed.
    return {
      allowed: false,
      retryAfterSeconds: 1,
      capacity: profile.capacity,
    };
  }
  const r = (data ?? {}) as Record<string, any>;
  if (r.allowed === true) {
    return {
      allowed: true,
      tokensRemaining: Number(r.tokens_remaining ?? 0),
      capacity: Number(r.capacity ?? profile.capacity),
    };
  }
  return {
    allowed: false,
    retryAfterSeconds: Number(r.retry_after_seconds ?? 1),
    capacity: Number(r.capacity ?? profile.capacity),
  };
}

/** Construit une Response HTTP 429 propre avec `Retry-After`. */
export function rateLimitedResponse(denied: RateLimitDenied): Response {
  const body = JSON.stringify({
    error: "rate_limited",
    retry_after_seconds: denied.retryAfterSeconds,
    capacity: denied.capacity,
  });
  return new Response(body, {
    status: 429,
    headers: {
      "content-type": "application/json; charset=utf-8",
      "retry-after": String(Math.max(1, Math.ceil(denied.retryAfterSeconds))),
      "x-ratelimit-capacity": String(denied.capacity),
      "cache-control": "no-store",
    },
  });
}
