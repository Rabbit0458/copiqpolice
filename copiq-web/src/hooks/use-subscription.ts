"use client"
import { useEffect, useState } from "react"
import { createClient } from "@/lib/supabase/client"

export function useSubscription(userId: string | undefined) {
  const [tier, setTier] = useState<string>("free")
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    if (!userId) { setLoading(false); return }
    supabase.from("cas_pratique_subscriptions" as any)
      .select("tier").eq("user_id", userId).maybeSingle()
      .then(({ data }) => {
        setTier((data as any)?.tier ?? "free")
        setLoading(false)
      })
  }, [userId])

  return { tier, loading }
}
