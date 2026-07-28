"use client"
import { useState, useEffect, useMemo } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { MessageCircle, Plus, Pin, Search, Eye, X, ChevronLeft, ChevronRight } from "lucide-react"

// ─── Mock data ────────────────────────────────────────────────────────────────

const MOCK_CATEGORIES = [
  { id: "concours", icon: "🎓", name: "Concours (PA & GPX)", post_count: 45 },
  { id: "droit", icon: "⚖️", name: "Droit & Procédure", post_count: 38 },
  { id: "cas", icon: "📋", name: "Cas pratiques", post_count: 22 },
  { id: "psycho", icon: "🧠", name: "Psychotechniques", post_count: 17 },
  { id: "temoignages", icon: "💬", name: "Témoignages", post_count: 31 },
  { id: "questions", icon: "❓", name: "Questions diverses", post_count: 28 },
]

const MOCK_POSTS = [
  {
    id: "1", title: "Comment mémoriser la procédure de GAV ?", category: "droit",
    author: "Officier74", reply_count: 12, views: 234, is_pinned: true,
    created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "2", title: "Résultats concours PA Ile-de-France 2025 ?", category: "concours",
    author: "Aspirant_Paris", reply_count: 34, views: 892, is_pinned: false,
    created_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "3", title: "Le cas pratique GPX m'angoisse, des conseils ?", category: "cas",
    author: "Gardien_Lyon", reply_count: 8, views: 156, is_pinned: false,
    created_at: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "4", title: "Quelle est la différence flagrant délit / enquête préliminaire ?", category: "droit",
    author: "CandidatPA22", reply_count: 9, views: 187, is_pinned: false,
    created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "5", title: "Planning de révision 3 mois avant le concours PA", category: "concours",
    author: "Major_Bordeaux", reply_count: 22, views: 541, is_pinned: true,
    created_at: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "6", title: "Calcul mental : astuces pour aller plus vite", category: "psycho",
    author: "Aspirant_Nantes", reply_count: 6, views: 112, is_pinned: false,
    created_at: new Date(Date.now() - 4 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "7", title: "Culture générale : quels thèmes travailler en priorité ?", category: "concours",
    author: "Officier74", reply_count: 15, views: 328, is_pinned: false,
    created_at: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "8", title: "Témoignage : reçu GPX après 2 tentatives", category: "temoignages",
    author: "GPX_Reçu2025", reply_count: 41, views: 1203, is_pinned: false,
    created_at: new Date(Date.now() - 15 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "9", title: "Art. 63 CPP : durée et prolongation de la GAV", category: "droit",
    author: "JuristePolice", reply_count: 7, views: 143, is_pinned: false,
    created_at: new Date(Date.now() - 6 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "10", title: "Erreurs à éviter lors de l'oral PA", category: "concours",
    author: "Adjudant_Marseille", reply_count: 19, views: 467, is_pinned: false,
    created_at: new Date(Date.now() - 8 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "11", title: "Série logique : méthode pour les suites de chiffres", category: "psycho",
    author: "CandidatPA22", reply_count: 5, views: 98, is_pinned: false,
    created_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "12", title: "Comment gérer le stress le jour du concours ?", category: "temoignages",
    author: "Sergent_Nice", reply_count: 28, views: 612, is_pinned: false,
    created_at: new Date(Date.now() - 20 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "13", title: "Différence entre OPJ et APJ ?", category: "questions",
    author: "Gardien_Lyon", reply_count: 11, views: 221, is_pinned: false,
    created_at: new Date(Date.now() - 12 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "14", title: "Cas pratique GPX 2024 : analyse de l'épreuve", category: "cas",
    author: "Major_Bordeaux", reply_count: 16, views: 389, is_pinned: false,
    created_at: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: "15", title: "La récidive en droit pénal : définition et conséquences", category: "droit",
    author: "JuristePolice", reply_count: 4, views: 87, is_pinned: false,
    created_at: new Date(Date.now() - 9 * 24 * 60 * 60 * 1000).toISOString(),
  },
]

function relativeDate(iso: string) {
  const diff = Date.now() - new Date(iso).getTime()
  const days = Math.floor(diff / (1000 * 60 * 60 * 24))
  if (days === 0) return "Aujourd'hui"
  if (days === 1) return "Hier"
  if (days < 30) return `Il y a ${days} jours`
  return `Il y a ${Math.floor(days / 30)} mois`
}

const POSTS_PER_PAGE = 8

export default function ForumPage() {
  const router = useRouter()
  const [posts, setPosts] = useState(MOCK_POSTS)
  const [categories] = useState(MOCK_CATEGORIES)
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState("")
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null)
  const [sort, setSort] = useState<"recent" | "discussed" | "pinned">("recent")
  const [page, setPage] = useState(1)
  const [showModal, setShowModal] = useState(false)
  const [newTitle, setNewTitle] = useState("")
  const [newCategory, setNewCategory] = useState("")
  const [newContent, setNewContent] = useState("")
  const [modalSuccess, setModalSuccess] = useState(false)

  useEffect(() => {
    const supabase = createClient()
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      try {
        const { data: pts } = await (supabase as any)
          .from("forum_posts")
          .select("*, profiles(full_name)")
          .order("is_pinned", { ascending: false })
          .order("created_at", { ascending: false })
          .limit(50)
        if (pts && pts.length > 0) setPosts(pts)
      } catch {}
      setLoading(false)
    })
  }, [])

  const filtered = useMemo(() => {
    let list = [...posts]
    if (search.trim()) list = list.filter(p => p.title.toLowerCase().includes(search.toLowerCase()))
    if (selectedCategory) list = list.filter(p => p.category === selectedCategory)
    if (sort === "recent") list.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
    if (sort === "discussed") list.sort((a, b) => b.reply_count - a.reply_count)
    if (sort === "pinned") list.sort((a, b) => (b.is_pinned ? 1 : 0) - (a.is_pinned ? 1 : 0))
    return list
  }, [posts, search, selectedCategory, sort])

  const totalPages = Math.ceil(filtered.length / POSTS_PER_PAGE)
  const paginated = filtered.slice((page - 1) * POSTS_PER_PAGE, page * POSTS_PER_PAGE)

  function handleCreateSubmit(e: React.FormEvent) {
    e.preventDefault()
    setModalSuccess(true)
    setTimeout(() => {
      setShowModal(false)
      setModalSuccess(false)
      setNewTitle("")
      setNewCategory("")
      setNewContent("")
    }, 2000)
  }

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" />
    </div>
  )

  const catLabel = categories.find(c => c.id === selectedCategory)

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-[var(--on-surface)]">Forum</h1>
          <p className="text-[var(--on-surface-muted)] text-sm mt-1">Entraidez-vous pour réussir vos concours</p>
        </div>
        <button
          onClick={() => setShowModal(true)}
          className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all"
        >
          <Plus size={16} />Nouveau sujet
        </button>
      </div>

      {/* Categories */}
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 mb-6">
        {categories.map((cat) => (
          <button
            key={cat.id}
            onClick={() => { setSelectedCategory(selectedCategory === cat.id ? null : cat.id); setPage(1) }}
            className={`rounded-xl border p-3 text-left transition-all ${
              selectedCategory === cat.id
                ? "border-[#1147D9] bg-[#1147D9]/10"
                : "border-[var(--outline)] bg-[var(--surface)] hover:border-[#1147D9]/40"
            }`}
          >
            <span className="text-xl">{cat.icon}</span>
            <p className="text-sm font-semibold text-[var(--on-surface)] mt-1">{cat.name}</p>
            <p className="text-xs text-[var(--on-surface-muted)]">{cat.post_count} sujets</p>
          </button>
        ))}
      </div>

      {/* Search + Sort */}
      <div className="flex gap-3 mb-4 flex-wrap">
        <div className="relative flex-1 min-w-[180px]">
          <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-muted)]" />
          <input
            value={search}
            onChange={e => { setSearch(e.target.value); setPage(1) }}
            placeholder="Rechercher un sujet..."
            className="w-full pl-8 pr-3 py-2 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-sm text-[var(--on-surface)] placeholder:text-[var(--on-surface-muted)] focus:outline-none focus:border-[#1147D9]/60"
          />
        </div>
        <select
          value={sort}
          onChange={e => { setSort(e.target.value as "recent" | "discussed" | "pinned"); setPage(1) }}
          className="px-3 py-2 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-sm text-[var(--on-surface)] focus:outline-none focus:border-[#1147D9]/60"
        >
          <option value="recent">Plus récent</option>
          <option value="discussed">Plus discuté</option>
          <option value="pinned">Épinglés</option>
        </select>
      </div>

      {/* Active filter badges */}
      {(selectedCategory || search) && (
        <div className="flex gap-2 mb-3 flex-wrap">
          {selectedCategory && (
            <span className="flex items-center gap-1 px-2.5 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-xs font-medium">
              {catLabel?.icon} {catLabel?.name}
              <button onClick={() => { setSelectedCategory(null); setPage(1) }}><X size={11} /></button>
            </span>
          )}
          {search && (
            <span className="flex items-center gap-1 px-2.5 py-1 rounded-full bg-[#8B5CF6]/10 text-[#8B5CF6] text-xs font-medium">
              &ldquo;{search}&rdquo;
              <button onClick={() => { setSearch(""); setPage(1) }}><X size={11} /></button>
            </span>
          )}
        </div>
      )}

      {/* Post list */}
      <div className="space-y-2">
        {paginated.map((post) => {
          const cat = categories.find(c => c.id === post.category)
          return (
            <div
              key={post.id}
              className="flex items-center gap-4 rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4 hover:border-[#1147D9]/40 transition-all group cursor-pointer"
            >
              {post.is_pinned && <Pin size={13} className="text-[#1147D9] shrink-0" />}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap mb-0.5">
                  <p className="font-medium text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors text-sm">
                    {post.title}
                  </p>
                  {cat && (
                    <span className="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-[#1147D9]/10 text-[#1147D9] shrink-0">
                      {cat.icon} {cat.name}
                    </span>
                  )}
                </div>
                <p className="text-xs text-[var(--on-surface-muted)]">
                  {post.author} · {relativeDate(post.created_at)}
                </p>
              </div>
              <div className="flex items-center gap-3 text-xs text-[var(--on-surface-muted)] shrink-0">
                <span className="flex items-center gap-1"><Eye size={12} />{post.views}</span>
                <span className="flex items-center gap-1"><MessageCircle size={12} />{post.reply_count}</span>
              </div>
            </div>
          )
        })}

        {paginated.length === 0 && (
          <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-12 text-center">
            <MessageCircle size={40} className="text-[var(--on-surface-muted)] mx-auto mb-3" />
            <p className="text-[var(--on-surface-muted)]">Aucun sujet ne correspond à votre recherche</p>
          </div>
        )}
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2 mt-6">
          <button
            onClick={() => setPage(p => Math.max(1, p - 1))}
            disabled={page === 1}
            className="p-1.5 rounded-lg border border-[var(--outline)] disabled:opacity-30 hover:border-[#1147D9]/40 transition-all"
          >
            <ChevronLeft size={16} className="text-[var(--on-surface)]" />
          </button>
          {Array.from({ length: totalPages }, (_, i) => i + 1).map(n => (
            <button
              key={n}
              onClick={() => setPage(n)}
              className={`w-8 h-8 rounded-lg text-sm font-medium transition-all ${
                n === page
                  ? "bg-[#1147D9] text-white"
                  : "border border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9]/40"
              }`}
            >
              {n}
            </button>
          ))}
          <button
            onClick={() => setPage(p => Math.min(totalPages, p + 1))}
            disabled={page === totalPages}
            className="p-1.5 rounded-lg border border-[var(--outline)] disabled:opacity-30 hover:border-[#1147D9]/40 transition-all"
          >
            <ChevronRight size={16} className="text-[var(--on-surface)]" />
          </button>
        </div>
      )}

      {/* Create topic modal */}
      {showModal && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 px-4"
          onClick={e => { if (e.target === e.currentTarget) setShowModal(false) }}
        >
          <div className="w-full max-w-lg rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 shadow-2xl">
            {modalSuccess ? (
              <div className="text-center py-6">
                <div className="text-4xl mb-3">✅</div>
                <p className="font-semibold text-[var(--on-surface)]">Sujet créé !</p>
                <p className="text-sm text-[var(--on-surface-muted)] mt-1">Il sera visible après modération.</p>
              </div>
            ) : (
              <>
                <div className="flex items-center justify-between mb-5">
                  <h2 className="text-lg font-bold text-[var(--on-surface)]">Nouveau sujet</h2>
                  <button
                    onClick={() => setShowModal(false)}
                    className="p-1 rounded-lg hover:bg-[var(--surface-dark)] text-[var(--on-surface-muted)]"
                  >
                    <X size={18} />
                  </button>
                </div>
                <form onSubmit={handleCreateSubmit} className="space-y-4">
                  <div>
                    <label className="block text-xs font-medium text-[var(--on-surface-muted)] mb-1">Titre</label>
                    <input
                      required
                      value={newTitle}
                      onChange={e => setNewTitle(e.target.value)}
                      placeholder="Ex: Comment mémoriser les articles du CPP ?"
                      className="w-full px-3 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-sm text-[var(--on-surface)] focus:outline-none focus:border-[#1147D9]/60"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-[var(--on-surface-muted)] mb-1">Catégorie</label>
                    <select
                      required
                      value={newCategory}
                      onChange={e => setNewCategory(e.target.value)}
                      className="w-full px-3 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-sm text-[var(--on-surface)] focus:outline-none focus:border-[#1147D9]/60"
                    >
                      <option value="">Choisir une catégorie...</option>
                      {categories.map(c => (
                        <option key={c.id} value={c.id}>{c.icon} {c.name}</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs font-medium text-[var(--on-surface-muted)] mb-1">Contenu</label>
                    <textarea
                      required
                      value={newContent}
                      onChange={e => setNewContent(e.target.value)}
                      rows={4}
                      placeholder="Décrivez votre question en détail..."
                      className="w-full px-3 py-2.5 rounded-xl border border-[var(--outline)] bg-[var(--surface)] text-sm text-[var(--on-surface)] focus:outline-none focus:border-[#1147D9]/60 resize-none"
                    />
                  </div>
                  <button
                    type="submit"
                    className="w-full py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all"
                  >
                    Publier le sujet
                  </button>
                </form>
              </>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
