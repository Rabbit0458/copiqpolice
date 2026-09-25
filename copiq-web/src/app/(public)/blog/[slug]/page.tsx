import type { Metadata } from "next"
import { BLOG_ARTICLES, getArticleBySlug } from "@/data/blog"
import { notFound } from "next/navigation"
import Image from "next/image"
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
    title: article.title,
    description: article.description,
    keywords: article.keywords,
    alternates: { canonical: `/blog/${article.slug}` },
    openGraph: {
      title: article.title,
      description: article.description,
      type: "article",
      url: `/blog/${article.slug}`,
      publishedTime: article.date,
      authors: [article.author],
      images: [{ url: article.image, alt: article.imageAlt }],
    },
    twitter: {
      card: "summary_large_image",
      title: article.title,
      description: article.description,
      images: [article.image],
    },
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
        <div className="relative mb-6 aspect-[16/9] overflow-hidden rounded-3xl border border-[var(--outline)] bg-[#000B36] shadow-xl shadow-[#1147D9]/10">
          <Image
            src={article.image}
            alt={article.imageAlt}
            fill
            priority
            sizes="(min-width: 768px) 768px, 100vw"
            className="object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-[#000B36]/35 via-transparent to-transparent" />
        </div>
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
              <Link key={a.slug} href={`/blog/${a.slug}`} className="group overflow-hidden rounded-xl border border-[var(--outline)] transition-all hover:border-[#1147D9]/40">
                <div className="relative aspect-[16/8] overflow-hidden bg-[#000B36]">
                  <Image src={a.image} alt={a.imageAlt} fill sizes="(min-width: 640px) 50vw, 100vw" className="object-cover transition-transform duration-500 group-hover:scale-105" />
                </div>
                <div className="p-4">
                  <h4 className="text-sm font-semibold leading-tight text-[var(--on-surface)] transition-colors group-hover:text-[#1147D9]">{a.title}</h4>
                  <p className="mt-1 line-clamp-2 text-xs text-[var(--on-surface-muted)]">{a.description}</p>
                </div>
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}
