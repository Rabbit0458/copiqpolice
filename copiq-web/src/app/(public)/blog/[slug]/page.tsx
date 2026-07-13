import type { Metadata } from "next"
import { BLOG_ARTICLES, getArticleBySlug } from "@/data/blog"
import { notFound } from "next/navigation"
import Link from "next/link"
import { ChevronRight, Clock, Tag, ArrowLeft } from "lucide-react"

export async function generateStaticParams() {
  return BLOG_ARTICLES.map(a => ({ slug: a.slug }))
}

export async function generateMetadata({ params }: { params: Promise<{ slug: string }> }): Promise<Metadata> {
  const { slug } = await params
  const article = getArticleBySlug(slug)
  if (!article) return {}
  return {
    title: `${article.title} | COP'IQ`,
    description: article.description,
    keywords: article.keywords,
    openGraph: { title: article.title, description: article.description, type: "article", publishedTime: article.date },
  }
}

function mdToHtml(md: string): string {
  return md
    .replace(/^### (.+)$/gm, '<h3 class="text-lg font-semibold text-[#000B36] dark:text-white mt-8 mb-3">$1</h3>')
    .replace(/^## (.+)$/gm, '<h2 class="text-xl font-bold text-[#000B36] dark:text-white mt-10 mb-4">$1</h2>')
    .replace(/\*\*(.+?)\*\*/g, '<strong class="font-semibold text-[#000B36] dark:text-white">$1</strong>')
    .replace(/\*(.+?)\*/g, '<em class="italic">$1</em>')
    .replace(/`(.+?)`/g, '<code class="px-1.5 py-0.5 rounded bg-gray-100 dark:bg-gray-800 text-[#1147D9] text-xs font-mono">$1</code>')
    .replace(/^> (.+)$/gm, '<blockquote class="border-l-4 border-[#1147D9] pl-4 py-2 bg-[#1147D9]/5 rounded-r-lg my-4 text-sm italic text-gray-600 dark:text-gray-400">$1</blockquote>')
    .replace(/^\| (.+) \|$/gm, (_, row) => {
      const cells = row.split(" | ").map((c: string) => `<td class="px-4 py-2 text-sm border border-gray-200 dark:border-gray-700">${c.trim()}</td>`).join("")
      return `<tr>${cells}</tr>`
    })
    .replace(/(<tr>[\s\S]*?<\/tr>)/gm, '<table class="w-full my-4 border-collapse rounded-xl overflow-hidden">$1</table>')
    .replace(/^- (.+)$/gm, '<li class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed ml-4 list-disc">$1</li>')
    .replace(/^(\d+)\. (.+)$/gm, '<li class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed ml-4 list-decimal">$2</li>')
    .replace(/\n\n/g, '</p><p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed my-3">')
}

export default async function BlogArticlePage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params
  const article = getArticleBySlug(slug)
  if (!article) notFound()
  const related = BLOG_ARTICLES.filter(a => a.slug !== slug && a.category === article.category).slice(0, 2)
  return (
    <div className="max-w-3xl mx-auto px-4 py-12">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-[var(--on-surface-muted)] mb-8">
        <Link href="/blog" className="hover:text-[var(--on-surface)] flex items-center gap-1"><ArrowLeft size={14} />Blog</Link>
        <ChevronRight size={14} />
        <span className="text-[var(--on-surface)] truncate">{article.title}</span>
      </div>
      {/* Header */}
      <header className="mb-8">
        <div className="flex items-center gap-2 mb-4">
          <span className="flex items-center gap-1 px-2.5 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9] text-xs font-medium"><Tag size={10} />{article.category}</span>
        </div>
        <h1 className="text-3xl font-bold text-[var(--on-surface)] leading-tight mb-4">{article.title}</h1>
        <p className="text-[var(--on-surface-muted)] text-base leading-relaxed mb-6">{article.description}</p>
        <div className="flex items-center gap-4 text-sm text-[var(--on-surface-faint)] pb-6 border-b border-[var(--outline)]">
          <span>{article.author}</span>
          <span>·</span>
          <span>{new Date(article.date).toLocaleDateString("fr-FR", { day: "numeric", month: "long", year: "numeric" })}</span>
          <span>·</span>
          <span className="flex items-center gap-1"><Clock size={13} />{article.readTime} min de lecture</span>
        </div>
      </header>
      {/* Content */}
      <article className="prose prose-sm max-w-none" dangerouslySetInnerHTML={{ __html: mdToHtml(article.content) }} />
      {/* CTA */}
      <div className="mt-12 rounded-2xl bg-gradient-to-br from-[#000B36] to-[#1147D9] p-8 text-white text-center">
        <h2 className="text-xl font-bold mb-2">Entraînez-vous sur COP&apos;IQ</h2>
        <p className="text-white/80 text-sm mb-5">Quiz, cas pratiques, cours protégés et psychotechniques — tout pour réussir votre concours.</p>
        <Link href="/signup" className="inline-block px-6 py-3 rounded-xl bg-white text-[#1147D9] font-bold text-sm hover:bg-gray-50 transition-all">
          Commencer gratuitement →
        </Link>
      </div>
      {/* Related */}
      {related.length > 0 && (
        <div className="mt-10">
          <h3 className="text-lg font-bold text-[var(--on-surface)] mb-4">Articles similaires</h3>
          <div className="grid gap-4 sm:grid-cols-2">
            {related.map(a => (
              <Link key={a.slug} href={`/blog/${a.slug}`} className="group rounded-xl border border-[var(--outline)] p-4 hover:border-[#1147D9]/40 transition-all">
                <h4 className="text-sm font-semibold text-[var(--on-surface)] group-hover:text-[#1147D9] transition-colors leading-tight">{a.title}</h4>
                <p className="text-xs text-[var(--on-surface-muted)] mt-1 line-clamp-2">{a.description}</p>
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
