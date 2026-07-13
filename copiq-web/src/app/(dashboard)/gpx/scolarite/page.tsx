"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { GPX_COURSE_MODULES } from "@/data/modules"
import Link from "next/link"
import { Clock, Star, ChevronRight } from "lucide-react"

export default function GPXScolaritePage() {
  const router = useRouter()
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-[var(--on-surface)]">GPX — Scolarité</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mt-1">Gardien de la Paix · Cours préparatoires</p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {GPX_COURSE_MODULES.map((mod) => (
          <Link key={mod.id} href={`/gpx/cours/${mod.id}`} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 hover:border-[#1147D9]/40 hover:shadow-md transition-all group">
            <div className="flex items-start gap-4">
              <span className="text-3xl">{mod.icon}</span>
              <div className="flex-1 min-w-0">
                <p className="font-semibold text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors">{mod.title}</p>
                <p className="text-xs text-[var(--on-surface-muted)] mt-1 line-clamp-2">{mod.description}</p>
                <div className="flex items-center gap-3 mt-3">
                  <span className="flex items-center gap-1 text-xs text-[var(--on-surface-faint)]"><Clock size={11} />{mod.sections.length * 5} min</span>
                  <span className="flex items-center gap-1 text-xs text-amber-500"><Star size={11} />+{mod.xpReward} XP</span>
                </div>
              </div>
              <ChevronRight size={16} className="text-[var(--on-surface-faint)] group-hover:text-[#1147D9] mt-1 shrink-0 transition-colors" />
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
}
