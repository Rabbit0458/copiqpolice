export const dynamic = "force-static"
import { MetadataRoute } from "next"
import { BLOG_ARTICLES } from "@/data/blog"
import { SEO_PAGES } from "@/data/seo-pages"

/**
 * Sitemap.
 *
 * Les URLs portent un slash final : `next.config.ts` fixe
 * `trailingSlash: true`, donc les balises `<link rel="canonical">` générées
 * par Next en portent aussi. Sans cela, le sitemap et les canoniques
 * désigneraient deux formes différentes de la même page.
 *
 * Ajouts de la refonte : les sept guides `/preparation/*`, le hub
 * `/ressources`, et trois pages publiques qui existaient déjà mais n'étaient
 * pas déclarées (`/faq`, `/informations`, `/notes-de-mise-a-jour`).
 * Aucune URL n'a été retirée : les anciennes entrées sont toutes conservées.
 *
 * Les routes authentifiées (dashboard, parcours, forum, abonnement…) restent
 * hors du sitemap et interdites dans `robots.ts`.
 */

const BASE = "https://copiq.fr"

export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date()

  const staticPages: MetadataRoute.Sitemap = [
    { url: `${BASE}/`, lastModified: now, changeFrequency: "weekly", priority: 1.0 },
    { url: `${BASE}/tarifs/`, lastModified: now, changeFrequency: "monthly", priority: 0.9 },
    { url: `${BASE}/ressources/`, lastModified: now, changeFrequency: "weekly", priority: 0.8 },
    { url: `${BASE}/blog/`, lastModified: now, changeFrequency: "weekly", priority: 0.8 },
    { url: `${BASE}/signup/`, lastModified: now, changeFrequency: "yearly", priority: 0.7 },
    { url: `${BASE}/login/`, lastModified: now, changeFrequency: "yearly", priority: 0.6 },
    { url: `${BASE}/faq/`, lastModified: now, changeFrequency: "monthly", priority: 0.6 },
    { url: `${BASE}/informations/`, lastModified: now, changeFrequency: "monthly", priority: 0.5 },
    { url: `${BASE}/contact/`, lastModified: now, changeFrequency: "yearly", priority: 0.5 },
    { url: `${BASE}/notes-de-mise-a-jour/`, lastModified: now, changeFrequency: "weekly", priority: 0.4 },
    { url: `${BASE}/beta/`, lastModified: now, changeFrequency: "monthly", priority: 0.4 },
    { url: `${BASE}/cgu/`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
    { url: `${BASE}/privacy/`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
    { url: `${BASE}/mentions-legales/`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
  ]

  const preparationPages: MetadataRoute.Sitemap = SEO_PAGES.map((p) => ({
    url: `${BASE}/preparation/${p.slug}/`,
    lastModified: now,
    changeFrequency: "monthly",
    priority: 0.85,
  }))

  const blogPages: MetadataRoute.Sitemap = BLOG_ARTICLES.map((a) => ({
    url: `${BASE}/blog/${a.slug}/`,
    lastModified: new Date(a.date),
    changeFrequency: "yearly",
    priority: 0.7,
  }))

  return [...staticPages, ...preparationPages, ...blogPages]
}
