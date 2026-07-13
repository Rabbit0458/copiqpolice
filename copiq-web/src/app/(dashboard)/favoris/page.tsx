"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { Heart, BookOpen } from "lucide-react"
import Link from "next/link"

export default function FavorisPage() {
  const router = useRouter()
  const [favorites, setFavorites] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      const { data: favs } = await (supabase as any).from("user_favorites").select("*").eq("user_id", data.user.id).order("created_at", { ascending: false })
      setFavorites(favs ?? [])
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6 flex items-center gap-2"><Heart size={24} />Mes Favoris</h1>
      {favorites.length === 0 ? (
        <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-12 text-center">
          <Heart size={40} className="text-[var(--on-surface-faint)] mx-auto mb-3" />
          <p className="text-[var(--on-surface-muted)]">Aucun favori enregistré</p>
          <p className="text-sm text-[var(--on-surface-faint)] mt-1">Marquez des cours et quiz comme favoris pour les retrouver ici</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {favorites.map((f) => (
            <Link key={f.id} href={f.url || "#"} className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 hover:border-[#1147D9]/40 transition-all group">
              <div className="flex items-center gap-3">
                <BookOpen size={18} className="text-[#1147D9]" />
                <p className="font-medium text-[var(--on-surface)] text-sm group-hover:text-[#1147D9] transition-colors">{f.title || f.resource_id}</p>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
