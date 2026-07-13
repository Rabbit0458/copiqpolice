"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { QuizEngine } from "@/features/quiz/quiz-engine"
import { Globe, BookOpen } from "lucide-react"

const CULTURE_TOPICS = [
  { id: "institutions", label: "Institutions françaises", icon: "🏛️", description: "République, Constitution, pouvoirs publics" },
  { id: "histoire", label: "Histoire de France", icon: "📜", description: "Dates clés, événements majeurs" },
  { id: "geographie", label: "Géographie", icon: "🗺️", description: "Régions, capitales, géographie physique" },
  { id: "actualite", label: "Actualité", icon: "📰", description: "Faits d'actualité récents" },
  { id: "droit", label: "Droit fondamental", icon: "⚖️", description: "Droits et libertés fondamentaux" },
]

export default function CultureGeneralePage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [selectedTopic, setSelectedTopic] = useState<string | null>(null)
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

  if (selectedTopic) return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <button onClick={() => setSelectedTopic(null)} className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 flex items-center gap-1 transition-colors">
        ← Retour aux thèmes
      </button>
      <QuizEngine track="pa" moduleId={selectedTopic} userId={user.id} tier="free" />
    </div>
  )

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-[var(--on-surface)] flex items-center gap-2"><Globe size={24} />Culture Générale</h1>
        <p className="text-[var(--on-surface-muted)] text-sm mt-1">Choisissez un thème pour vous entraîner</p>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {CULTURE_TOPICS.map((topic) => (
          <button key={topic.id} onClick={() => setSelectedTopic(topic.id)} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 text-left hover:border-[#1147D9]/40 hover:shadow-md transition-all group">
            <span className="text-3xl mb-3 block">{topic.icon}</span>
            <p className="font-semibold text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors">{topic.label}</p>
            <p className="text-xs text-[var(--on-surface-muted)] mt-1">{topic.description}</p>
          </button>
        ))}
      </div>
    </div>
  )
}
