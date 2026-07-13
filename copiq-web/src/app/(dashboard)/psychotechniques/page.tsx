"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import Link from "next/link"
import { Brain, Calculator, Layers, Lightbulb, ChevronRight } from "lucide-react"

const TYPES = [
  { id: "calcul", label: "Calcul mental", icon: <Calculator size={22} className="text-[#1147D9]" />, description: "Additions, soustractions, multiplications rapides", color: "bg-blue-50 dark:bg-blue-950/20" },
  { id: "suites-logiques", label: "Suites logiques", icon: <Layers size={22} className="text-violet-500" />, description: "Séries numériques et alphabétiques", color: "bg-violet-50 dark:bg-violet-950/20" },
  { id: "raisonnement", label: "Raisonnement", icon: <Lightbulb size={22} className="text-amber-500" />, description: "Syllogismes et déductions logiques", color: "bg-amber-50 dark:bg-amber-950/20" },
]

export default function PsychotechniquesPage() {
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
        <h1 className="text-2xl font-bold text-[var(--on-surface)] flex items-center gap-2"><Brain size={24} />Psychotechniques</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mt-1">Exercices chronométrés pour développer votre rapidité</p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        {TYPES.map((t) => (
          <Link key={t.id} href={`/psychotechniques/${t.id}`} className={`rounded-2xl border border-[var(--outline)] p-6 hover:border-[#1147D9]/40 hover:shadow-md transition-all group ${t.color}`}>
            <div className="mb-3">{t.icon}</div>
            <p className="font-semibold text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors">{t.label}</p>
            <p className="text-xs text-[var(--on-surface-muted)] mt-1">{t.description}</p>
            <div className="flex items-center gap-1 text-xs text-[#1147D9] mt-4 font-medium">Commencer <ChevronRight size={12} /></div>
          </Link>
        ))}
      </div>
    </div>
  )
}
