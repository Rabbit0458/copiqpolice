export const dynamic = "force-static"
import { MetadataRoute } from "next"
const BASE = process.env.NEXT_PUBLIC_SITE_URL ?? "https://copiqpolice.app"
export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: ["/", "/blog/", "/tarifs", "/contact", "/beta", "/cgu", "/privacy"],
        disallow: ["/dashboard/", "/pa/", "/gpx/", "/forum/", "/concours-blanc/", "/psychotechniques/", "/culture-generale/", "/langues/", "/api/", "/abonnement/", "/profil/", "/parametres/", "/progression/", "/historique/", "/favoris/", "/notifications/"],
      },
    ],
    sitemap: `${BASE}/sitemap.xml`,
  }
}
