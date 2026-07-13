"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Languages, BookOpen, Volume2 } from "lucide-react"
import { QuizEngine } from "@/features/quiz/quiz-engine"

const LANGUAGES = [
  { id: "anglais-vocabulaire", label: "Anglais — Vocabulaire", icon: "🇬🇧", description: "Vocabulaire courant et professionnel" },
  { id: "anglais-comprehension", label: "Anglais — Compréhension", icon: "🇺🇸", description: "Textes à analyser et comprendre" },
  { id: "espagnol-vocabulaire", label: "Espagnol — Vocabulaire", icon: "🇪🇸", description: "Vocabulaire essentiel" },
]

export default function LanguesPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [selected, setSelected] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  if (selected) return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <button onClick={() => setSelected(null)} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 flex items-center gap-1 transition-colors">← Retour</button>
      <QuizEngine track="pa" moduleId={selected} userId={user!.id} tier="free" />
    </div>
  )

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-[var(--on-surface)] flex items-center gap-2"><Languages size={24} />Langues</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mt-1">Entraînez-vous en anglais et espagnol</p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {LANGUAGES.map((lang) => (
          <button key={lang.id} onClick={() => setSelected(lang.id)} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 text-left hover:border-[#1147D9]/40 hover:shadow-md transition-all group">
            <span className="text-3xl mb-3 block">{lang.icon}</span>
            <p className="font-semibold text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors">{lang.label}</p>
            <p className="text-xs text-[var(--on-surface-muted)] mt-1">{lang.description}</p>
          </button>
        ))}
      </div>
    </div>
  )
}
