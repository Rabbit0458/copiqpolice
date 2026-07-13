"use client"
import { useState } from "react"
import Link from "next/link"
import { Pin, MessageCircle, Clock, Tag, ChevronRight } from "lucide-react"

const CATEGORY_COLORS: Record<string, string> = {
  "general": "#1147D9",
  "droit-penal": "#8B5CF6",
  "procedure": "#22C55E",
  "psychotechniques": "#F59E0B",
  "annonces": "#EF4444",
  "cas-pratiques": "#06B6D4",
}

interface Props {
  posts: any[]
  categories: any[]
  currentUserId: string
}

export default function ForumList({ posts, categories, currentUserId }: Props) {
  const [selectedCat, setSelectedCat] = useState<string | null>(null)
  const filtered = selectedCat ? posts.filter(p => p.category_id === selectedCat) : posts
  return (
    <div className="space-y-4">
      {/* Category filters */}
      <div className="flex gap-2 flex-wrap">
        <button onClick={() => setSelectedCat(null)} className={`px-3 py-1.5 rounded-full text-xs font-medium transition-all border ${!selectedCat ? "bg-[#1147D9] text-white border-[#1147D9]" : "border-[var(--outline)] text-[var(--on-surface-muted)] hover:border-[#1147D9]/40"}`}>
          Tous
        </button>
        {categories.map(cat => (
          <button key={cat.id} onClick={() => setSelectedCat(cat.id)} className={`px-3 py-1.5 rounded-full text-xs font-medium transition-all border ${selectedCat === cat.id ? "bg-[#1147D9] text-white border-[#1147D9]" : "border-[var(--outline)] text-[var(--on-surface-muted)] hover:border-[#1147D9]/40"}`}>
            {cat.name}
          </button>
        ))}
      </div>
      {/* Posts */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] divide-y divide-[var(--outline)] overflow-hidden">
        {filtered.length === 0 ? (
          <div className="p-10 text-center">
            <MessageCircle size={32} className="text-[var(--on-surface-faint)] mx-auto mb-3" />
            <p className="text-sm text-[var(--on-surface-muted)]">Aucun sujet pour le moment. Soyez le premier à lancer une discussion !</p>
          </div>
        ) : filtered.map((post: any) => (
          <Link key={post.id} href={`/forum/${post.id}`} className="flex items-start gap-4 p-4 hover:bg-[var(--surface-dark)] transition-colors group">
            <div className={`w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 mt-0.5 ${post.pinned ? "bg-[#1147D9]/10" : "bg-[var(--surface-dark)]"}`}>
              {post.pinned ? <Pin size={15} className="text-[#1147D9]" /> : <MessageCircle size={15} className="text-[var(--on-surface-muted)]" />}
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-start gap-2 flex-wrap">
                <h3 className="text-sm font-semibold text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors truncate">{post.title}</h3>
                {post.pinned && <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-[10px] font-semibold flex-shrink-0">📌 Épinglé</span>}
              </div>
              <p className="text-xs text-[var(--on-surface-muted)] mt-0.5 line-clamp-1">{post.content}</p>
              <div className="flex items-center gap-3 mt-2">
                {post.category_slug && (
                  <span className="flex items-center gap-1 text-[10px] text-[var(--on-surface-faint)]">
                    <Tag size={10} />
                    <span>{post.category_slug}</span>
                  </span>
                )}
                <span className="flex items-center gap-1 text-[10px] text-[var(--on-surface-faint)]">
                  <MessageCircle size={10} />
                  <span>{post.reply_count ?? 0} réponses</span>
                </span>
                <span className="flex items-center gap-1 text-[10px] text-[var(--on-surface-faint)]">
                  <Clock size={10} />
                  <span>{new Date(post.created_at).toLocaleDateString("fr-FR", { day: "numeric", month: "short" })}</span>
                </span>
              </div>
            </div>
            <ChevronRight size={14} className="text-[var(--on-surface-faint)] flex-shrink-0 mt-2 group-hover:text-[#1147D9] transition-colors" />
          </Link>
        ))}
      </div>
    </div>
  )
}
