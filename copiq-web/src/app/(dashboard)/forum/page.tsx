"use client"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import Link from "next/link"
import { MessageCircle, Users, Plus, ChevronRight, Pin } from "lucide-react"

export default function ForumPage() {
  const router = useRouter()
  const [user, setUser] = useState<any>(null)
  const [categories, setCategories] = useState<any[]>([])
  const [posts, setPosts] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      setUser(data.user)
      const [cats, pts] = await Promise.all([
        (supabase as any).from("forum_categories").select("*").order("sort_order"),
        (supabase as any).from("forum_posts").select("*, profiles(full_name)").order("is_pinned", { ascending: false }).order("created_at", { ascending: false }).limit(20),
      ])
      setCategories(cats.data ?? [])
      setPosts(pts.data ?? [])
      setLoading(false)
    })
  }, [])

  if (loading) return <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" /></div>

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-6">
        <div><h1 className="text-2xl font-bold text-[var(--on-surface)]">Forum</h1><p className="text-[var(--on-surface-muted)] text-sm mt-1">Entraidez-vous pour réussir vos concours</p></div>
        <Link href="/forum/nouveau" className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all">
          <Plus size={16} />Nouveau sujet
        </Link>
      </div>
      {categories.length > 0 && (
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 mb-6">
          {categories.map((cat) => (
            <div key={cat.id} className="rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-3 cursor-pointer hover:border-[#1147D9]/40 transition-all">
              <span className="text-xl">{cat.icon}</span>
              <p className="text-sm font-semibold text-[var(--on-surface)] mt-1">{cat.name}</p>
              <p className="text-xs text-[var(--on-surface-muted)]">{cat.post_count ?? 0} sujets</p>
            </div>
          ))}
        </div>
      )}
      <div className="space-y-2">
        {posts.map((post) => (
          <Link key={post.id} href={`/forum/post?id=${post.id}`} className="flex items-center gap-4 rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 hover:border-[#1147D9]/40 transition-all group">
            {post.is_pinned && <Pin size={14} className="text-[#1147D9] shrink-0" />}
            <div className="flex-1 min-w-0">
              <p className="font-medium text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors text-sm truncate">{post.title}</p>
              <p className="text-xs text-[var(--on-surface-muted)] mt-0.5">{post.profiles?.full_name ?? "Utilisateur"} · {new Date(post.created_at).toLocaleDateString("fr-FR")}</p>
            </div>
            <div className="flex items-center gap-1 text-xs text-[var(--on-surface-faint)] shrink-0"><MessageCircle size={13} />{post.reply_count ?? 0}</div>
            <ChevronRight size={14} className="text-[var(--on-surface-faint)] group-hover:text-[#1147D9] transition-colors shrink-0" />
          </Link>
        ))}
        {posts.length === 0 && (
          <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-12 text-center">
            <MessageCircle size={40} className="text-[var(--on-surface-faint)] mx-auto mb-3" />
            <p className="text-[var(--on-surface-muted)]">Aucun sujet pour l'instant</p>
          </div>
        )}
      </div>
    </div>
  )
}
