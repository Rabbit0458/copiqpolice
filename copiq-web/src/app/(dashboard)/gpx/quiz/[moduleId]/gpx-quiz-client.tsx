"use client"
import { useParams, useRouter } from "next/navigation"
import { useState, useEffect } from "react"
import { createClient } from "@/lib/supabase/client"
import { getModuleById } from "@/data/modules"
import { QuizEngine } from "@/features/quiz/quiz-engine"
import Link from "next/link"
import { ArrowLeft } from "lucide-react"
import type { CpTier } from "@/types"

export default function GPXQuizClient() {
  const params = useParams()
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [tier, setTier] = useState<CpTier>("free")
  const [loading, setLoading] = useState(true)
  const supabase = createClient()
  const mod = getModuleById(params.moduleId as string)

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const { data: sub } = await (supabase as any).from("cas_pratique_subscriptions").select("tier").eq("user_id", data.user.id).maybeSingle()
      setTier(sub?.tier ?? "free")
      setLoading(false)
    })
  }, [])

  if (!mod) return <div className="flex items-center justify-center h-64"><p className="text-[var(--on-surface-muted)]">Module introuvable</p></div>
  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <Link href="/gpx/quiz" className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 transition-colors"><ArrowLeft size={15} />Retour aux quiz</Link>
      <div className="flex items-center gap-3 mb-6">
        <span className="text-3xl">{mod.icon}</span>
        <div><h1 className="text-xl font-bold text-[var(--on-surface)]">{mod.title}</h1><p className="text-sm text-[var(--on-surface-muted)]">Quiz GPX</p></div>
      </div>
      <QuizEngine track="gpx" moduleId={mod.id} userId={user.id} tier={tier} />
    </div>
  )
}
