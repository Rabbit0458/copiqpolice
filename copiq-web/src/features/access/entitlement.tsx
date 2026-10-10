"use client"

import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from "react"
import { createClient } from "@/lib/supabase/client"
import type { CpTier } from "@/types"

/**
 * Droits d'accès — même source que l'application Flutter.
 *
 * L'app considère un compte Premium si `is_user_premium` le dit (abonnement
 * Stripe, achat App Store / Google Play ou propriétaire). La RPC
 * `get_my_entitlement()` renvoie ce verdict, le plan et le quota gratuit
 * (10 lancements de quiz par 7 jours, table `free_weekly_usage`).
 *
 * Règles reprises de l'app :
 *  - Concours (PA / GPX) : gratuit avec quota ; chaque lancement de quiz
 *    consomme un crédit (`consume_free_request`), illimité en Premium.
 *  - Scolarité (PA / GPX) : réservée aux abonnés Premium.
 */

export type Entitlement = {
  loaded: boolean
  premium: boolean
  tier: CpTier
  plan: string
  role: string
  freeLimit: number
  freeRemaining: number
  freeResetsAt: string | null
}

type Ctx = Entitlement & {
  refresh: () => Promise<void>
  /** Consomme un lancement gratuit (no-op en Premium). */
  consumeFreeRequest: () => Promise<{ allowed: boolean; remaining: number | null; resetsAt: string | null }>
}

const DEFAULT: Entitlement = {
  loaded: false,
  premium: false,
  tier: "free",
  plan: "free",
  role: "user",
  freeLimit: 10,
  freeRemaining: 10,
  freeResetsAt: null,
}

const EntitlementContext = createContext<Ctx | null>(null)

export function EntitlementProvider({ children }: { children: ReactNode }) {
  const supabase = useMemo(() => createClient(), [])
  const [state, setState] = useState<Entitlement>(DEFAULT)

  const refresh = useCallback(async () => {
    const [{ data }, { data: sub }] = await Promise.all([
      supabase.rpc("get_my_entitlement" as never),
      supabase.auth.getUser().then(async ({ data: auth }) =>
        auth.user ? supabase.from("cas_pratique_subscriptions").select("tier").eq("user_id", auth.user.id).maybeSingle() : { data: null },
      ),
    ])
    const e = (data ?? {}) as Record<string, unknown>
    const premium = e.premium === true
    const subTier = String((sub as { tier?: string } | null)?.tier ?? "free")
    setState({
      loaded: true,
      premium,
      tier: premium ? (subTier === "premium_trial" ? "premium_trial" : "premium") : "free",
      plan: String(e.plan ?? "free"),
      role: String(e.role ?? "user"),
      freeLimit: Number(e.free_limit ?? 10) || 10,
      freeRemaining: Math.max(0, Number(e.free_remaining ?? 10)),
      freeResetsAt: e.free_resets_at ? String(e.free_resets_at) : null,
    })
  }, [supabase])

  useEffect(() => {
    // Chargement initial depuis Supabase.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    void refresh().catch(() => setState((s) => ({ ...s, loaded: true })))
  }, [refresh])

  const consumeFreeRequest = useCallback(async () => {
    const { data, error } = await supabase.rpc("consume_free_request")
    if (error) throw error
    const r = (data ?? {}) as Record<string, unknown>
    const remaining = r.remaining === null || r.remaining === undefined ? null : Number(r.remaining)
    if (remaining !== null) setState((s) => ({ ...s, freeRemaining: remaining }))
    return { allowed: r.allowed === true, remaining, resetsAt: r.resets_at ? String(r.resets_at) : null }
  }, [supabase])

  const value = useMemo(() => ({ ...state, refresh, consumeFreeRequest }), [state, refresh, consumeFreeRequest])
  return <EntitlementContext.Provider value={value}>{children}</EntitlementContext.Provider>
}

export function useEntitlement() {
  const ctx = useContext(EntitlementContext)
  if (!ctx) throw new Error("useEntitlement doit être utilisé dans EntitlementProvider")
  return ctx
}

/** Règle d'accès d'un parcours (identique à l'app). */
export function pathwayRequiresPremium(mode: "exam" | "school") {
  return mode === "school"
}
