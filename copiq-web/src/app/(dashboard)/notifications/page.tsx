"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Bell, Info, CheckCircle, AlertCircle } from "lucide-react"

export default function NotificationsPage() {
  const router = useRouter()
  const [notifs, setNotifs] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      const { data: n } = await (supabase as any).from("notifications").select("*").eq("user_id", data.user.id).order("created_at", { ascending: false }).limit(30)
      setNotifs(n ?? [])
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6 flex items-center gap-2"><Bell size={24} />Notifications</h1>
      {notifs.length === 0 ? (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-12 text-center">
          <Bell size={40} className="text-[var(--on-surface-faint)] mx-auto mb-3" />
          <p className="text-[var(--on-surface-muted)]">Aucune notification</p>
        </div>
      ) : (
        <div className="space-y-2">
          {notifs.map((n) => (
            <div key={n.id} className={`rounded-xl border p-4 ${n.read ? "border-[var(--outline)] bg-[var(--surface)]" : "border-[#1147D9]/30 bg-[#1147D9]/5"}`}>
              <div className="flex items-start gap-3">
                <Info size={16} className="text-[#1147D9] mt-0.5 shrink-0" />
                <div className="flex-1">
                  <p className="text-sm font-medium text-[var(--on-surface)]">{n.title}</p>
                  {n.message && <p className="text-xs text-[var(--on-surface-muted)] mt-0.5">{n.message}</p>}
                  <p className="text-xs text-[var(--on-surface-faint)] mt-1">{new Date(n.created_at).toLocaleDateString("fr-FR")}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
