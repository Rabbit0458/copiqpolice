import type { Metadata } from "next"
import { BLOG_ARTICLES } from "@/data/blog"
import Link from "next/link"
import { Clock, Tag, ChevronRight } from "lucide-react"
export const metadata: Metadata = {
  title: "Blog — Préparer le concours de Police Nationale | COP'IQ",
  description: "Guides, méthodes et cours pour réussir les concours de Policier Adjoint (PA) et Gardien de la Paix (GPX) : droit pénal, procédure, psychotechniques.",
}
export default function BlogPage() {
  const categories = [...new Set(BLOG_ARTICLES.map(a => a.category))]
  return (
    <div className="max-w-4xl mx-auto px-4 py-16">
      <div className="mb-10">
        <h1 className="text-3xl font-bold text-[var(--on-surface)] mb-3">Blog COP&apos;IQ</h1>
        <p className="text-[var(--on-surface-muted)]">Guides et conseils pour réussir les concours de la Police Nationale.</p>
      </div>
      {/* Category tags */}
      <div className="flex gap-2 flex-wrap mb-8">
        {categories.map(cat => (
          <span key={cat} className="px-3 py-1 rounded-full border border-[var(--outline)] text-xs text-[var(--on-surface-muted)]">{cat}</span>
        ))}
      </div>
      {/* Articles */}
      <div className="grid gap-6 sm:grid-cols-2">
        {BLOG_ARTICLES.map(article => (
          <Link key={article.slug} href={`/blog/${article.slug}`} className="group rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 hover:border-[#1147D9]/40 hover:shadow-md transition-all">
            <div className="flex items-center gap-2 mb-3">
              <span className="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9] font-medium">
                <Tag size={10} />{article.category}
              </span>
            </div>
            <h2 className="text-base font-bold text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors leading-tight mb-2">{article.title}</h2>
            <p className="text-sm text-[var(--on-surface-muted)] leading-relaxed line-clamp-3 mb-4">{article.description}</p>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3 text-xs text-[var(--on-surface-faint)]">
                <span>{new Date(article.date).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })}</span>
                <span className="flex items-center gap-1"><Clock size={10} />{article.readTime} min</span>
              </div>
              <span className="flex items-center gap-1 text-xs text-[#1147D9] font-medium">Lire <ChevronRight size={12} /></span>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
}
