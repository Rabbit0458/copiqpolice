"use client"
import { useParams, useRouter } from "next/navigation"
import { useState, useEffect } from "react"
import { createClient } from "@/lib/supabase/client"
import { getModuleById } from "@/data/modules"
import CoursReader from "@/features/cours/cours-reader"
import Link from "next/link"
import { ChevronRight, Clock, Star } from "lucide-react"

export default function GPXCoursClient() {
  const params = useParams()
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [tier, setTier] = useState("free")
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

  if (!mod || mod.category !== "gpx") return <div className="flex items-center justify-center h-64"><p className="text-[var(--on-surface-muted)]">Module introuvable</p></div>
  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] mb-6">
        <Link href="/dashboard" className="hover:text-[var(--on-surface)]">Accueil</Link>
        <ChevronRight size={14} />
        <Link href="/gpx/scolarite" className="hover:text-[var(--on-surface)]">GPX Scolarité</Link>
        <ChevronRight size={14} />
        <span className="text-[var(--on-surface)]">{mod.title}</span>
      </div>
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 mb-6">
        <div className="flex items-center gap-4">
          <span className="text-4xl">{mod.icon}</span>
          <div className="flex-1">
            <h1 className="text-2xl font-bold text-[var(--on-surface)]">{mod.title}</h1>
            <p className="text-[var(--on-surface-muted)] text-sm mt-1">{mod.description}</p>
            <div className="flex items-center gap-4 mt-3">
              <span className="flex items-center gap-1 text-xs text-[var(--on-surface-faint)]"><Clock size={12} />{mod.sections.length * 5} min</span>
              <span className="flex items-center gap-1 text-xs text-[#EAB308]"><Star size={12} />+{mod.xpReward} XP</span>
            </div>
          </div>
        </div>
        <div className="mt-4 pt-4 border-t border-[var(--outline)]">
          <div className="flex flex-wrap gap-2">
            {mod.sections.map((s, i) => (
              <a key={s.id} href={`#${s.id}`} className="text-xs px-2.5 py-1 rounded-full border border-[var(--outline)] text-[var(--on-surface-muted)] hover:border-[#1147D9]/40 hover:text-[#1147D9] transition-all">
                {i + 1}. {s.title}
              </a>
            ))}
          </div>
        </div>
      </div>
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-8">
        <CoursReader module={mod} tier={tier} userEmail={user?.email} />
      </div>
      <div className="mt-6 flex items-center justify-between">
        <Link href="/gpx/scolarite" className="px-4 py-2.5 rounded-xl border border-[var(--outline)] text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-all">← Retour</Link>
        <Link href="/gpx/quiz" className="px-4 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all">Quiz →</Link>
      </div>
    </div>
  )
}
