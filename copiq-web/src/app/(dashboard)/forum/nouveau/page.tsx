"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { ArrowLeft, Send } from "lucide-react"
import Link from "next/link"

export default function NouveauSujetPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [title, setTitle] = useState("")
  const [content, setContent] = useState("")
  const [category, setCategory] = useState("")
  const [categories, setCategories] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const { data: cats } = await (supabase as any).from("forum_categories").select("*").order("sort_order")
      setCategories(cats ?? [])
      setLoading(false)
    })
  }, [])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!title.trim() || !content.trim()) return
    setSubmitting(true)
    const { data: post, error } = await (supabase as any).from("forum_posts").insert({
      user_id: user.id, title: title.trim(), content: content.trim(),
      category_id: category || null,
    }).select().single()
    if (!error && post) router.push(`/forum/${post.id}`)
    else setSubmitting(false)
  }

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <Link href="/forum" className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 transition-colors">
        <ArrowLeft size={16} />Retour au forum
      </Link>
      <h1 className="text-2xl font-bold text-[var(--on-surface)] mb-6">Nouveau sujet</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Titre</label>
          <input value={title} onChange={e => setTitle(e.target.value)} placeholder="Titre de votre sujet..." required
            className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none focus:border-[#1147D9] transition-colors" />
        </div>
        {categories.length > 0 && (
          <div>
            <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Catégorie</label>
            <select value={category} onChange={e => setCategory(e.target.value)}
              className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none focus:border-[#1147D9] transition-colors">
              <option value="">Sélectionner une catégorie</option>
              {categories.map(cat => <option key={cat.id} value={cat.id}>{cat.icon} {cat.name}</option>)}
            </select>
          </div>
        )}
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Contenu</label>
          <textarea value={content} onChange={e => setContent(e.target.value)} rows={8} placeholder="Décrivez votre question ou sujet..." required
            className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none focus:border-[#1147D9] transition-colors resize-none" />
        </div>
        <button type="submit" disabled={submitting} className="w-full py-3 rounded-xl bg-[#1147D9] text-white font-bold text-sm hover:bg-[#1A55E6] transition-all disabled:opacity-60 flex items-center justify-center gap-2">
          {submitting ? <span className="animate-spin rounded-full h-4 w-4 border-b-2 border-white" /> : <Send size={15} />}
          {submitting ? "Publication..." : "Publier le sujet"}
        </button>
      </form>
    </div>
  )
}
