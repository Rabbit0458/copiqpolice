export const dynamic = "force-static"
import { MetadataRoute } from "next"
import { BLOG_ARTICLES } from "@/data/blog"
import { PA_COURSE_MODULES, GPX_COURSE_MODULES } from "@/data/modules"
const BASE = process.env.NEXT_PUBLIC_SITE_URL ?? "https://copiqpolice.app"
export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date()
  const static_pages = [
    { url: `${BASE}/`, lastModified: now, priority: 1.0 },
    { url: `${BASE}/tarifs`, lastModified: now, priority: 0.9 },
    { url: `${BASE}/blog`, lastModified: now, priority: 0.8 },
    { url: `${BASE}/contact`, lastModified: now, priority: 0.5 },
    { url: `${BASE}/beta`, lastModified: now, priority: 0.4 },
    { url: `${BASE}/cgu`, lastModified: now, priority: 0.3 },
    { url: `${BASE}/privacy`, lastModified: now, priority: 0.3 },
    { url: `${BASE}/login`, lastModified: now, priority: 0.6 },
    { url: `${BASE}/signup`, lastModified: now, priority: 0.7 },
  ]
  const blog_pages = BLOG_ARTICLES.map(a => ({
    url: `${BASE}/blog/${a.slug}`,
    lastModified: new Date(a.date),
    priority: 0.7,
  }))
  // Note: premium course pages are NOT indexed (noindex on dashboard routes)
  return [...static_pages, ...blog_pages]
}
