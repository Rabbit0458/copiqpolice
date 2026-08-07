"use client"
import { useEffect, useState } from "react"
import { createClient } from "@/lib/supabase/client"

export function useSubscription(userId: string | undefined) {
  const [tier, setTier] = useState<string>("free")
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    if (!userId) { setLoading(false); return }
    const load = () => supabase.from("cas_pratique_subscriptions" as any)
      .select("tier,status,current_period_end").eq("user_id", userId).maybeSingle()
      .then(({ data }) => {
        setTier((data as any)?.tier ?? "free")
        setLoading(false)
      })
    load()
    const channel = supabase.channel(`subscription:${userId}`).on(
      "postgres_changes",
      { event: "*", schema: "public", table: "cas_pratique_subscriptions", filter: `user_id=eq.${userId}` },
      load,
    ).subscribe()
    return () => { void supabase.removeChannel(channel) }
  }, [userId])

  return { tier, loading }
}
