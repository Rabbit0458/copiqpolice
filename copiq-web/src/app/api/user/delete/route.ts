import { NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"
import { createClient as createAdminClient } from "@supabase/supabase-js"
import type { Database } from "@/types/supabase"

function getAdminClient() {
  return createAdminClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    { auth: { autoRefreshToken: false, persistSession: false } }
  )
}

export async function DELETE() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  const admin = getAdminClient()
  const tables = ["cas_pratique_subscriptions", "cas_pratique_attempts", "cas_pratique_user_progress", "cas_pratique_user_bookmarks", "cas_pratique_xp_ledger", "cas_pratique_user_badges", "free_weekly_usage"] as const
  for (const table of tables) {
    await admin.from(table as any).delete().eq("user_id", user.id)
  }
  await admin.auth.admin.deleteUser(user.id)
  return NextResponse.json({ success: true })
}
