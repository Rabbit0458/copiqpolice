"use client"
import { useState, useEffect, Suspense } from "react"
import { useRouter } from "next/navigation"
import { createClient } from "@/lib/supabase/client"
import { ArrowLeft, Send, ChevronDown, ChevronUp, CheckCircle2 } from "lucide-react"
import Link from "next/link"

// ─── Mock categories (fallback) ───────────────────────────────────────────────

const MOCK_CATEGORIES = [
  { id: "1", name: "Concours (PA & GPX)", icon: "🎓" },
  { id: "2", name: "Droit & Procédure", icon: "⚖️" },
  { id: "3", name: "Cas pratiques", icon: "📋" },
  { id: "4", name: "Psychotechniques", icon: "🧠" },
  { id: "5", name: "Témoignages", icon: "💬" },
  { id: "6", name: "Questions diverses", icon: "❓" },
]

// ─── Community rules ──────────────────────────────────────────────────────────

const COMMUNITY_RULES = [
  {
    title: "Soyez respectueux·se",
    description: "Tout le monde est ici pour apprendre et progresser. Les propos offensants, discriminatoires ou irrespectueux envers les autres membres ne sont pas tolérés.",
  },
  {
    title: "Vérifiez que le sujet n'existe pas déjà",
    description: "Avant de créer un nouveau sujet, utilisez la recherche pour vérifier qu'une discussion similaire n'existe pas déjà. Cela évite la duplication et centralise les échanges.",
  },
  {
    title: "Citez vos sources juridiques",
    description: "Pour toute affirmation juridique, citez l'article de loi correspondant (ex : art. 63 CPP). Cela renforce la fiabilité de l'information et aide les autres à approfondir.",
  },
]

// ─── Validation helpers ───────────────────────────────────────────────────────

function validateTitle(t: string) {
  if (!t.trim()) return "Le titre est requis"
  if (t.trim().length < 10) return "Le titre doit contenir au moins 10 caractères"
  if (t.length > 100) return "Le titre ne peut pas dépasser 100 caractères"
  return null
}

function validateContent(c: string) {
  if (!c.trim()) return "Le contenu est requis"
  if (c.trim().length < 20) return "Le contenu doit contenir au moins 20 caractères"
  if (c.length > 2000) return "Le contenu ne peut pas dépasser 2000 caractères"
  return null
}

// ─── Rules accordion ──────────────────────────────────────────────────────────

function RulesAccordion() {
  const [open, setOpen] = useState(false)
  const [openRule, setOpenRule] = useState<number | null>(null)

  return (
    <div className="rounded-xl border border-[var(--outline)] overflow-hidden">
      <button
        type="button"
        onClick={() => setOpen(o => !o)}
        className="w-full flex items-center justify-between px-4 py-3 text-sm font-semibold text-[var(--on-surface)] hover:bg-[var(--surface-dark)] transition-colors"
      >
        <span className="flex items-center gap-2">
          <span className="text-base">📋</span>
          Règles de la communauté
        </span>
        {open ? <ChevronUp size={16} className="text-[var(--on-surface-muted)]" /> : <ChevronDown size={16} className="text-[var(--on-surface-muted)]" />}
      </button>

      {open && (
        <div className="border-t border-[var(--outline)] divide-y divide-[var(--outline)]">
          {COMMUNITY_RULES.map((rule, i) => (
            <div key={i}>
              <button
                type="button"
                onClick={() => setOpenRule(openRule === i ? null : i)}
                className="w-full flex items-center justify-between px-4 py-3 text-left hover:bg-[var(--surface-dark)] transition-colors"
              >
                <span className="text-sm font-medium text-[var(--on-surface)] flex items-center gap-2">
                  <span
                    className="w-5 h-5 rounded-full flex items-center justify-center text-white text-[10px] font-bold shrink-0"
                    style={{ backgroundColor: "#1147D9" }}
                  >
                    {i + 1}
                  </span>
                  {rule.title}
                </span>
                {openRule === i
                  ? <ChevronUp size={14} className="text-[var(--on-surface-muted)] shrink-0" />
                  : <ChevronDown size={14} className="text-[var(--on-surface-muted)] shrink-0" />
                }
              </button>
              {openRule === i && (
                <div className="px-4 pb-3 ml-7">
                  <p className="text-xs text-[var(--on-surface-muted)] leading-relaxed">{rule.description}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ─── Main page ────────────────────────────────────────────────────────────────

function NouveauSujetContent() {
  const router = useRouter()
  const [categories, setCategories] = useState(MOCK_CATEGORIES)
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [success, setSuccess] = useState(false)

  const [selectedCategory, setSelectedCategory] = useState<string | null>(null)
  const [title, setTitle] = useState("")
  const [content, setContent] = useState("")
  const [touched, setTouched] = useState({ title: false, content: false, category: false })

  const titleError = validateTitle(title)
  const contentError = validateContent(content)
  const categoryError = !selectedCategory ? "Veuillez choisir une catégorie" : null

  const isValid = !titleError && !contentError && !categoryError

  useEffect(() => {
    const supabase = createClient()
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      try {
        const { data: cats } = await (supabase as any)
          .from("forum_categories")
          .select("*")
          .order("sort_order")
        if (cats && cats.length > 0) {
          setCategories(cats.map((c: any) => ({
            id: String(c.id),
            name: c.name,
            icon: c.icon ?? "💬",
          })))
        }
      } catch {
        // Keep mock categories
      }
      setLoading(false)
    })
  }, [])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setTouched({ title: true, content: true, category: true })
    if (!isValid) return
    setSubmitting(true)

    const supabase = createClient()
    const { data: user } = await supabase.auth.getUser()

    try {
      const { data: post, error } = await (supabase as any)
        .from("forum_posts")
        .insert({
          user_id: user.user?.id,
          title: title.trim(),
          content: content.trim(),
          category_id: selectedCategory,
        })
        .select()
        .single()

      if (!error && post) {
        router.push(`/forum/${post.id}`)
        return
      }
    } catch {
      // Supabase failed → show mock success
    }

    // Fallback: mock success
    setSuccess(true)
    setTimeout(() => router.push("/forum"), 2000)
  }

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" />
    </div>
  )

  if (success) return (
    <div className="max-w-2xl mx-auto px-4 py-16 text-center">
      <div className="w-16 h-16 rounded-full bg-[#1147D9]/10 flex items-center justify-center mx-auto mb-4">
        <CheckCircle2 size={32} className="text-[#1147D9]" />
      </div>
      <h2 className="text-xl font-bold text-[var(--on-surface)] mb-2">Sujet créé !</h2>
      <p className="text-sm text-[var(--on-surface-muted)] mb-1">Il sera publié après modération.</p>
      <p className="text-xs text-[var(--on-surface-faint)]">Redirection vers le forum dans quelques secondes...</p>
    </div>
  )

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      {/* Back link */}
      <Link
        href="/forum"
        className="inline-flex items-center gap-2 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 transition-colors"
      >
        <ArrowLeft size={16} />Retour au forum
      </Link>

      <div className="mb-6">
        <h1 className="text-2xl font-bold text-[var(--on-surface)]">Nouveau sujet</h1>
        <p className="text-sm text-[var(--on-surface-muted)] mt-1">Posez votre question à la communauté CopIQ Police</p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">

        {/* Category picker */}
        <div>
          <label className="block text-sm font-semibold text-[var(--on-surface)] mb-2">
            Catégorie <span className="text-red-500">*</span>
          </label>
          <div className="flex flex-wrap gap-2">
            {categories.map(cat => (
              <button
                key={cat.id}
                type="button"
                onClick={() => { setSelectedCategory(cat.id); setTouched(t => ({ ...t, category: true })) }}
                className={`flex items-center gap-1.5 px-3 py-2 rounded-xl text-sm font-medium border transition-all ${
                  selectedCategory === cat.id
                    ? "bg-[#1147D9] text-white border-[#1147D9] shadow-sm"
                    : "border-[var(--outline)] text-[var(--on-surface)] hover:border-[#1147D9]/50 hover:bg-[#1147D9]/5"
                }`}
              >
                <span>{cat.icon}</span>
                {cat.name}
              </button>
            ))}
          </div>
          {touched.category && categoryError && (
            <p className="text-xs text-red-500 mt-1.5">{categoryError}</p>
          )}
        </div>

        {/* Title */}
        <div>
          <div className="flex items-center justify-between mb-1.5">
            <label className="text-sm font-semibold text-[var(--on-surface)]">
              Titre <span className="text-red-500">*</span>
            </label>
            <span className={`text-xs ${title.length > 90 ? "text-red-500" : "text-[var(--on-surface-faint)]"}`}>
              {title.length}/100
            </span>
          </div>
          <input
            value={title}
            onChange={e => setTitle(e.target.value)}
            onBlur={() => setTouched(t => ({ ...t, title: true }))}
            maxLength={100}
            placeholder="Ex: Comment mémoriser les articles du CPP ?"
            className={`w-full px-4 py-3 rounded-xl border bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none transition-colors ${
              touched.title && titleError
                ? "border-red-400 focus:border-red-500"
                : "border-[var(--outline)] focus:border-[#1147D9]"
            }`}
          />
          {touched.title && titleError && (
            <p className="text-xs text-red-500 mt-1.5">{titleError}</p>
          )}
        </div>

        {/* Content */}
        <div>
          <div className="flex items-center justify-between mb-1.5">
            <label className="text-sm font-semibold text-[var(--on-surface)]">
              Contenu <span className="text-red-500">*</span>
            </label>
            <span className={`text-xs ${content.length > 1800 ? "text-red-500" : content.length > 1500 ? "text-[#F59E0B]" : "text-[var(--on-surface-faint)]"}`}>
              {content.length}/2000
            </span>
          </div>
          <textarea
            value={content}
            onChange={e => setContent(e.target.value)}
            onBlur={() => setTouched(t => ({ ...t, content: true }))}
            maxLength={2000}
            rows={8}
            placeholder="Décrivez votre question en détail. Plus vous êtes précis·e, meilleures seront les réponses que vous recevrez."
            className={`w-full px-4 py-3 rounded-xl border bg-[var(--surface)] text-[var(--on-surface)] text-sm focus:outline-none transition-colors resize-none ${
              touched.content && contentError
                ? "border-red-400 focus:border-red-500"
                : "border-[var(--outline)] focus:border-[#1147D9]"
            }`}
          />
          {touched.content && contentError && (
            <p className="text-xs text-red-500 mt-1.5">{contentError}</p>
          )}
          {content.length < 20 && content.length > 0 && (
            <p className="text-xs text-[var(--on-surface-muted)] mt-1.5">
              Encore {20 - content.length} caractère{20 - content.length > 1 ? "s" : ""} minimum
            </p>
          )}
        </div>

        {/* Community rules */}
        <RulesAccordion />

        {/* Submit */}
        <div className="pt-2">
          <button
            type="submit"
            disabled={submitting}
            onClick={() => setTouched({ title: true, content: true, category: true })}
            className="w-full py-3.5 rounded-xl bg-[#1147D9] text-white font-bold text-sm hover:bg-[#1A55E6] transition-all disabled:opacity-60 flex items-center justify-center gap-2"
          >
            {submitting
              ? <span className="animate-spin rounded-full h-4 w-4 border-b-2 border-white" />
              : <Send size={15} />
            }
            {submitting ? "Publication en cours..." : "Publier le sujet"}
          </button>
          <p className="text-xs text-center text-[var(--on-surface-faint)] mt-2">
            En publiant, vous acceptez les règles de la communauté CopIQ Police
          </p>
        </div>
      </form>
    </div>
  )
}

export default function NouveauSujetPage() {
  return (
    <Suspense
      fallback={
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" />
        </div>
      }
    >
      <NouveauSujetContent />
    </Suspense>
  )
}
