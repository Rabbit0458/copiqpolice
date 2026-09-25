import type { Metadata } from "next"
import { BLOG_ARTICLES } from "@/data/blog"
import Image from "next/image"
import Link from "next/link"
import { Clock, Tag, ChevronRight } from "lucide-react"
export const metadata: Metadata = {
  title: "Blog — préparer le concours de la Police nationale",
  description: "Guides, méthodes et cours pour réussir les concours de Policier Adjoint (PA) et Gardien de la Paix (GPX) : droit pénal, procédure, psychotechniques.",
  alternates: { canonical: "/blog" },
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
          <Link key={article.slug} href={`/blog/${article.slug}`} className="group overflow-hidden rounded-2xl border border-[var(--outline)] bg-[var(--surface)] transition-all duration-300 hover:-translate-y-1 hover:border-[#1147D9]/40 hover:shadow-xl hover:shadow-[#1147D9]/10">
            <div className="relative aspect-[16/9] overflow-hidden bg-[#000B36]">
              <Image
                src={article.image}
                alt={article.imageAlt}
                fill
                sizes="(min-width: 640px) 50vw, 100vw"
                className="object-cover transition-transform duration-500 group-hover:scale-105"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-[#000B36]/75 via-transparent to-transparent" />
              <span className="absolute bottom-4 left-4 flex items-center gap-1 rounded-full border border-white/20 bg-[#000B36]/70 px-3 py-1.5 text-xs font-semibold text-white backdrop-blur-md">
                <Tag size={11} />{article.category}
              </span>
            </div>
            <div className="p-6">
              <h2 className="mb-2 text-base font-bold leading-tight text-[var(--on-surface)] transition-colors group-hover:text-[#1147D9]">{article.title}</h2>
              <p className="mb-4 line-clamp-3 text-sm leading-relaxed text-[var(--on-surface-muted)]">{article.description}</p>
              <div className="flex items-center justify-between gap-3">
                <div className="flex items-center gap-3 text-xs text-[var(--on-surface-faint)]">
                  <span>{new Date(article.date).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })}</span>
                  <span className="flex items-center gap-1"><Clock size={10} />{article.readTime} min</span>
                </div>
                <span className="flex shrink-0 items-center gap-1 text-xs font-semibold text-[#1147D9]">Lire <ChevronRight size={12} /></span>
              </div>
            </div>
          </Link>
        ))}
      </div>
    </div>
  )
}
