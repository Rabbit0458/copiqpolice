import { createBrowserClient as createSSRBrowserClient } from "@supabase/ssr"
import type { Database } from "@/types/supabase"

function getSupabaseConfig() {
  // Runtime config (loaded from /copiq-config.js in the browser)
  if (typeof window !== "undefined" && (window as any).COPIQ_CONFIG) {
    const cfg = (window as any).COPIQ_CONFIG
    if (cfg.SUPABASE_URL && cfg.SUPABASE_URL !== "VOTRE_URL_SUPABASE_ICI") {
      return { url: cfg.SUPABASE_URL, key: cfg.SUPABASE_ANON_KEY }
    }
  }
  // Fallback to env vars (for development / CI builds with real keys)
  return {
    url: process.env.NEXT_PUBLIC_SUPABASE_URL ?? "https://placeholder.supabase.co",
    key: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? "placeholder",
  }
}

export function createClient() {
  const { url, key } = getSupabaseConfig()
  return createSSRBrowserClient<Database>(url, key)
}

export const createBrowserClient = createClient
