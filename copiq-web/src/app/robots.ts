export const dynamic = "force-static"
import { MetadataRoute } from "next"

/**
 * robots.txt.
 *
 * Seuls des chemins publics ont été **ajoutés** à `allow` (`/preparation/`,
 * `/ressources`, `/faq`, `/informations`, `/notes-de-mise-a-jour`). La liste
 * `disallow` est reprise à l'identique : aucun espace authentifié n'est
 * ouverte à l'indexation, et `/admin/` reste interdit.
 */

const BASE = "https://copiq.fr"

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: "*",
        allow: [
          "/",
          "/preparation/",
          "/ressources",
          "/blog/",
          "/tarifs",
          "/faq",
          "/informations",
          "/notes-de-mise-a-jour",
          "/contact",
          "/beta",
          "/cgu",
          "/privacy",
          "/mentions-legales",
        ],
        disallow: [
          "/admin/",
          "/dashboard/",
          "/pa/",
          "/gpx/",
          "/forum/",
          "/concours-blanc/",
          "/psychotechniques/",
          "/culture-generale/",
          "/langues/",
          "/api/",
          "/abonnement/",
          "/profil/",
          "/parametres/",
          "/progression/",
          "/historique/",
          "/favoris/",
          "/notifications/",
          "/choisir-parcours/",
          "/memos/",
          "/notes/",
        ],
      },
    ],
    sitemap: `${BASE}/sitemap.xml`,
  }
}
