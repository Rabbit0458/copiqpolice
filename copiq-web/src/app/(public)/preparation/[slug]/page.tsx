import type { Metadata } from "next"
import Link from "next/link"
import { notFound } from "next/navigation"
import { SEO_PAGES, getSeoPage } from "@/data/seo-pages"
import { PATHWAYS } from "@/config/pathways"
import { INDEPENDENCE_NOTICE } from "@/data/marketing"
import { Reveal } from "@/components/marketing/reveal"
import { FaqSection, faqJsonLd } from "@/components/marketing/faq-section"

/**
 * Pages d'acquisition « /preparation/<slug> ».
 *
 * Export statique : `generateStaticParams` liste les sept slugs, il n'y a
 * donc aucun rendu à la demande. Aucune URL existante n'est modifiée —
 * `/preparation/*` est un espace neuf, donc aucune redirection 301 n'est
 * nécessaire (§42).
 */

const SITE_URL = "https://copiq.fr"

export function generateStaticParams() {
  return SEO_PAGES.map((p) => ({ slug: p.slug }))
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>
}): Promise<Metadata> {
  const { slug } = await params
  const page = getSeoPage(slug)
  if (!page) return {}

  return {
    title: page.metaTitle,
    description: page.metaDescription,
    alternates: { canonical: `/preparation/${page.slug}` },
    openGraph: {
      title: page.metaTitle,
      description: page.metaDescription,
      url: `${SITE_URL}/preparation/${page.slug}`,
      type: "article",
    },
  }
}

export default async function PreparationPage({
  params,
}: {
  params: Promise<{ slug: string }>
}) {
  const { slug } = await params
  const page = getSeoPage(slug)
  if (!page) notFound()

  const pathway = PATHWAYS[page.pathway]
  const related = page.related
    .map((s) => getSeoPage(s))
    .filter((p): p is NonNullable<typeof p> => Boolean(p))

  const breadcrumb = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      { "@type": "ListItem", position: 1, name: "Accueil", item: SITE_URL },
      {
        "@type": "ListItem",
        position: 2,
        name: "Préparation",
        item: `${SITE_URL}/preparation/gardien-de-la-paix`,
      },
      {
        "@type": "ListItem",
        position: 3,
        name: page.h1,
        item: `${SITE_URL}/preparation/${page.slug}`,
      },
    ],
  }

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify([breadcrumb, faqJsonLd(page.faq)]),
        }}
      />

      {/* ── En-tête de page ─────────────────────────────────────────────── */}
      <section className="cq-night cq-synapse relative overflow-hidden">
        <span
          aria-hidden="true"
          className="cq-drift pointer-events-none absolute -left-20 top-[-30%] h-[22rem] w-[22rem] rounded-full bg-[rgb(17_71_217/0.28)] blur-[100px]"
        />
        <div className="relative mx-auto max-w-4xl px-4 pb-16 pt-12 sm:px-6 lg:pb-20 lg:pt-16">
          <nav aria-label="Fil d’Ariane" className="text-[12.5px] text-white/55">
            <ol className="flex flex-wrap items-center gap-1.5">
              <li>
                <Link href="/" className="hover:text-white/75">
                  Accueil
                </Link>
              </li>
              <li aria-hidden="true">/</li>
              <li className="text-white/70">Préparation</li>
            </ol>
          </nav>

          <p className="cq-eyebrow mt-6 text-[#7FB3FF]">{page.eyebrow}</p>
          <h1 className="cq-title mt-3 text-white">{page.h1}</h1>
          <p className="cq-lead mt-5 max-w-2xl text-white/70">{page.intro}</p>

          <div className="mt-8 flex flex-col gap-3 sm:flex-row">
            <Link
              href="/signup"
              className="cq-tap inline-flex items-center justify-center rounded-2xl bg-[#1147D9] px-6 py-3.5 text-[15px] font-semibold text-white shadow-[0_10px_40px_-8px_rgba(17,71,217,0.75)] transition-colors duration-200 hover:bg-[#1A55E6]"
            >
              {page.ctaLabel}
            </Link>
            <Link
              href="/tarifs"
              className="cq-tap inline-flex items-center justify-center rounded-2xl border border-white/18 bg-white/[0.04] px-6 py-3.5 text-[15px] font-semibold text-white/85 transition-colors duration-200 hover:bg-white/[0.08]"
            >
              Voir les tarifs
            </Link>
          </div>

          <p className="mt-5 text-[12.5px] text-white/55">
            Parcours COP’IQ concerné :{" "}
            <span className="text-white/70">{pathway.title}</span>
          </p>
        </div>
      </section>

      {/* ── Corps éditorial ────────────────────────────────────────────── */}
      <div className="mx-auto max-w-4xl px-4 py-16 sm:px-6 lg:py-20">
        {page.sections.map((s, i) => (
          <Reveal key={s.title} delay={i * 60}>
            <section className="mb-12 last:mb-0">
              <h2 className="text-[1.35rem] font-bold leading-snug tracking-[-0.025em] text-[var(--on-surface)]">
                {s.title}
              </h2>
              <p className="mt-3.5 text-[15px] leading-relaxed text-[var(--on-surface-muted)]">
                {s.body}
              </p>
              {s.bullets && (
                <ul className="mt-5 space-y-2.5 border-l-2 border-[#1147D9]/35 pl-5">
                  {s.bullets.map((b) => (
                    <li
                      key={b}
                      className="text-[14.5px] leading-snug text-[var(--on-surface)]"
                    >
                      {b}
                    </li>
                  ))}
                </ul>
              )}
            </section>
          </Reveal>
        ))}

        <Reveal>
          <aside className="mt-4 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)] p-5 text-[12.5px] leading-relaxed text-[var(--on-surface-muted)]">
            {INDEPENDENCE_NOTICE} Les modalités officielles des concours et
            sélections sont publiées par le ministère de l’Intérieur et la
            Police nationale : ce sont elles qui font foi.
          </aside>
        </Reveal>
      </div>

      <FaqSection
        items={page.faq}
        eyebrow="Questions fréquentes"
        title="Ce que l’on nous demande sur ce sujet."
      />

      {/* ── Pages liées ────────────────────────────────────────────────── */}
      {related.length > 0 && (
        <section
          className="border-t border-[var(--outline-variant)] bg-[var(--surface-container)]"
          style={{ paddingTop: "3.5rem", paddingBottom: "3.5rem" }}
        >
          <div className="mx-auto max-w-5xl px-4 sm:px-6">
            <h2 className="cq-eyebrow text-[var(--on-surface-muted)]">
              À lire aussi
            </h2>
            <ul className="mt-5 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
              {related.map((r) => (
                <li key={r.slug}>
                  <Link
                    href={`/preparation/${r.slug}`}
                    className="flex h-full flex-col rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-4 transition-[border-color,box-shadow] duration-200 hover:border-[#1147D9]/45 hover:shadow-card-hover"
                  >
                    <span className="cq-eyebrow text-[10px] text-[#1147D9] [.dark_&]:text-[#7FB3FF]">
                      {r.eyebrow}
                    </span>
                    <span className="mt-2 text-[14px] font-semibold leading-snug text-[var(--on-surface)]">
                      {r.h1}
                    </span>
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        </section>
      )}
    </>
  )
}
