"use client"
import { useState } from "react"
import { createBrowserClient } from "@/lib/supabase/client"
import { useRouter } from "next/navigation"
import { Send, Loader2 } from "lucide-react"
import toast from "react-hot-toast"
import Link from "next/link"
export default function NewPostForm({ categories, userId }: { categories: any[]; userId: string }) {
  const supabase = createBrowserClient()
  const router = useRouter()
  const [title, setTitle] = useState("")
  const [content, setContent] = useState("")
  const [categoryId, setCategoryId] = useState(categories[0]?.id ?? "")
  const [loading, setLoading] = useState(false)
  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!title.trim() || !content.trim()) return
    setLoading(true)
    const { data, error } = await (supabase as any).from("forum_posts").insert({ title: title.trim(), content: content.trim(), category_id: categoryId || null, user_id: userId }).select("id").single()
    setLoading(false)
    if (error) { toast.error("Erreur lors de la création du sujet"); return }
    toast.success("Sujet créé !")
    router.push(`/forum/${data.id}`)
  }
  return (
    <form onSubmit={handleSubmit} className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 space-y-4">
      {categories.length > 0 && (
        <div>
          <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Catégorie</label>
          <select value={categoryId} onChange={e => setCategoryId(e.target.value)} className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all">
            {categories.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
          </select>
        </div>
      )}
      <div>
        <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Titre du sujet</label>
        <input type="text" value={title} onChange={e => setTitle(e.target.value)} placeholder="Ex: Question sur l'article 122-5 CP..." required maxLength={200} className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all" />
        <p className="text-xs text-[var(--on-surface-faint)] mt-1 text-right">{title.length}/200</p>
      </div>
      <div>
        <label className="block text-sm font-medium text-[var(--on-surface)] mb-1.5">Contenu</label>
        <textarea value={content} onChange={e => setContent(e.target.value)} rows={8} placeholder="Détaillez votre question ou partagez vos informations..." required maxLength={5000} className="w-full px-4 py-3 rounded-xl border border-[var(--outline)] bg-[var(--surface-dark)] text-[var(--on-surface)] text-sm placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 focus:border-[#1147D9] transition-all resize-none" />
        <p className="text-xs text-[var(--on-surface-faint)] mt-1 text-right">{content.length}/5000</p>
      </div>
      <div className="flex items-center justify-between pt-2">
        <Link href="/forum" className="text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors">Annuler</Link>
        <button type="submit" disabled={loading || !title.trim() || !content.trim()} className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-[#1147D9] hover:bg-[#1A55E6] text-white text-sm font-semibold transition-all disabled:opacity-60">
          {loading ? <Loader2 size={14} className="animate-spin" /> : <Send size={14} />} Publier le sujet
        </button>
      </div>
    </form>
  )
}
