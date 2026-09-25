import type { Metadata } from "next"
import Link from "next/link"
import Image from "next/image"
import { BLOG_ARTICLES } from "@/data/blog"
import { SEO_PAGES } from "@/data/seo-pages"
import { Reveal } from "@/components/marketing/reveal"

/**
 * Hub Ressources.
 *
 * Agrège ce qui existe déjà — les guides de préparation (`/preparation/*`) et
 * les articles du blog (`/blog/*`) — plutôt que de dupliquer du contenu. Les
 * URLs de blog existantes sont **conservées** : aucune redirection, aucune
 * chaîne de 301 (§42).
 *
 * Volume volontairement faible (§41) : sept guides et les articles réellement
 * rédigés. Pas de génération automatique de contenu pour occuper Google.
 */

const SITE_URL = "https://copiq.fr"

export const metadata: Metadata = {
  title: "Ressources — guides et articles de préparation Police",
  description:
    "Guides de préparation aux concours de la Police nationale et articles COP'IQ : Gardien de la paix, Policier adjoint, psychotechniques, cas pratique, culture générale, oral.",
  alternates: { canonical: "/ressources" },
  openGraph: {
    title: "Ressources COP'IQ — préparation Police nationale",
    description:
      "Guides de préparation et articles pour les concours de la Police nationale.",
    url: `${SITE_URL}/ressources`,
    type: "website",
  },
}

export default function RessourcesPage() {
  const articles = [...BLOG_ARTICLES].sort((a, b) =>
    b.date.localeCompare(a.date),
  )

  return (
    <>
      <section className="cq-night cq-synapse relative overflow-hidden">
        <span
          aria-hidden="true"
          className="cq-drift pointer-events-none absolute -left-16 top-[-35%] h-[20rem] w-[20rem] rounded-full bg-[rgb(17_71_217/0.26)] blur-[100px]"
        />
        <div className="relative mx-auto max-w-4xl px-4 pb-14 pt-12 sm:px-6 lg:pb-18 lg:pt-16">
          <p className="cq-eyebrow text-[#7FB3FF]">Ressources</p>
          <h1 className="cq-title mt-3 text-white">
            Comprendre les épreuves avant de les passer.
          </h1>
          <p className="cq-lead mt-5 max-w-2xl text-white/70">
            Des guides par épreuve et des articles de fond, écrits pour être
            utiles une fois. Rien de généré en série pour remplir une page.
          </p>
        </div>
      </section>

      {/* ── Guides par épreuve ─────────────────────────────────────────── */}
      <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6 lg:py-20">
        <h2 className="cq-eyebrow text-[var(--on-surface-muted)]">
          Guides de préparation
        </h2>
        <ul className="mt-6 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
          {SEO_PAGES.map((p, i) => (
            <li key={p.slug}>
              <Reveal delay={i * 45}>
                <Link
                  href={`/preparation/${p.slug}`}
                  className="flex h-full flex-col rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 transition-[border-color,box-shadow] duration-200 hover:border-[#1147D9]/45 hover:shadow-card-hover"
                >
                  <span className="cq-eyebrow text-[10px] text-[#1147D9] [.dark_&]:text-[#7FB3FF]">
                    {p.eyebrow}
                  </span>
                  <h3 className="mt-2 text-[15.5px] font-semibold leading-snug tracking-[-0.015em] text-[var(--on-surface)]">
                    {p.h1}
                  </h3>
                  <p className="mt-2 line-clamp-3 text-[13px] leading-relaxed text-[var(--on-surface-muted)]">
                    {p.metaDescription}
                  </p>
                </Link>
              </Reveal>
            </li>
          ))}
        </ul>
      </section>

      {/* ── Articles ───────────────────────────────────────────────────── */}
      <section className="border-t border-[var(--outline-variant)] bg-[var(--surface-container)]">
        <div className="mx-auto max-w-6xl px-4 py-16 sm:px-6 lg:py-20">
          <div className="flex flex-wrap items-baseline justify-between gap-3">
            <h2 className="cq-eyebrow text-[var(--on-surface-muted)]">
              Articles
            </h2>
            <Link
              href="/blog"
              className="text-[13px] font-semibold text-[#1147D9] hover:underline [.dark_&]:text-[#7FB3FF]"
            >
              Voir tout le blog
            </Link>
          </div>

          <ul className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {articles.map((a, i) => (
              <li key={a.slug}>
                <Reveal delay={i * 45}>
                  <Link
                    href={`/blog/${a.slug}`}
                    className="group flex h-full flex-col overflow-hidden rounded-2xl border border-[var(--outline)] bg-[var(--surface)] transition-[border-color,box-shadow] duration-200 hover:border-[#1147D9]/45 hover:shadow-card-hover"
                  >
                    <div className="cq-photo cq-photo-grade aspect-[16/9]">
                      <Image
                        src={a.image}
                        alt={a.imageAlt}
                        width={800}
                        height={450}
                        loading="lazy"
                        unoptimized
                        sizes="(max-width: 640px) 100vw, (max-width: 1024px) 46vw, 30vw"
                      />
                    </div>
                    <div className="flex flex-1 flex-col p-5">
                      <span className="cq-eyebrow text-[10px] text-[#1147D9] [.dark_&]:text-[#7FB3FF]">
                        {a.category}
                      </span>
                      <h3 className="mt-2 text-[15.5px] font-semibold leading-snug tracking-[-0.015em] text-[var(--on-surface)]">
                        {a.title}
                      </h3>
                      <p className="mt-2 line-clamp-3 flex-1 text-[13px] leading-relaxed text-[var(--on-surface-muted)]">
                        {a.description}
                      </p>
                      <span className="mt-4 text-[11.5px] text-[var(--on-surface-muted)]">
                        <time dateTime={a.date}>
                          {new Date(a.date).toLocaleDateString("fr-FR", {
                            day: "numeric",
                            month: "long",
                            year: "numeric",
                          })}
                        </time>
                        {" · "}
                        {a.readTime} min de lecture
                      </span>
                    </div>
                  </Link>
                </Reveal>
              </li>
            ))}
          </ul>
        </div>
      </section>
    </>
  )
}
