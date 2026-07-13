"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Settings, Bell, Shield, Trash2 } from "lucide-react"

export default function ParametresPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      setLoading(false)
    })
  }, [])

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    router.replace("/login")
  }

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6">Paramètres</h1>
      <div className="space-y-4">
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
          <h2 className="font-semibold text-[var(--on-surface)] mb-4 flex items-center gap-2"><Shield size={16} />Compte</h2>
          <p className="text-sm text-[var(--on-surface-muted)] mb-2">Connecté en tant que</p>
          <p className="font-medium text-[var(--on-surface)]">{user?.email}</p>
        </div>
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6">
          <h2 className="font-semibold text-[var(--on-surface)] mb-4 flex items-center gap-2"><Bell size={16} />Notifications</h2>
          <p className="text-sm text-[var(--on-surface-muted)]">Gérez vos préférences de notifications dans les paramètres de l'application.</p>
        </div>
        <button onClick={handleSignOut} className="w-full rounded-2xl border border-red-200 bg-red-50 dark:bg-red-950/20 dark:border-red-900 p-4 text-red-600 dark:text-red-400 font-semibold text-sm hover:bg-red-100 dark:hover:bg-red-950/30 transition-all flex items-center justify-center gap-2">
          <Trash2 size={16} />Se déconnecter
        </button>
      </div>
    </div>
  )
}
