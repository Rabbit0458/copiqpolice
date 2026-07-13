"use client"
import { useParams, useRouter } from "next/navigation"
import { useState, useEffect } from "react"
import { createClient } from "@/lib/supabase/client"
import PsychoExercice from "@/features/psychotechniques/psycho-exercice"
import Link from "next/link"
import { ArrowLeft } from "lucide-react"

const TYPES = ["calcul", "suites-logiques", "raisonnement"]
const LABELS: Record<string, string> = {
  "calcul": "Calcul mental",
  "suites-logiques": "Suites logiques",
  "raisonnement": "Raisonnement",
}

export default function PsychoClient() {
  const params = useParams()
  const router = useRouter()
  const [tier, setTier] = useState("free")
  const [loading, setLoading] = useState(true)
  const supabase = createClient()
  const type = params.type as string

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      const { data: sub } = await (supabase as any).from("cas_pratique_subscriptions").select("tier").eq("user_id", data.user.id).maybeSingle()
      setTier(sub?.tier ?? "free")
      setLoading(false)
    })
  }, [])

  if (!TYPES.includes(type)) return <div className="flex items-center justify-center h-64"><p className="text-[var(--on-surface-muted)]">Type introuvable</p></div>
  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <Link href="/psychotechniques" className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 transition-colors">
        <ArrowLeft size={15} />Retour
      </Link>
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6">{LABELS[type] ?? type}</h1>
      <PsychoExercice type={type} label={LABELS[type] ?? type} tier={tier} />
    </div>
  )
}
