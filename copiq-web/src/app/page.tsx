import type { Metadata } from "next"
import { LandingV5 } from "@/features/landing/landing-v5"
import { HOME_FAQ, faqJsonLd } from "@/components/marketing/faq-section"
import { PRICING, INDEPENDENCE_NOTICE } from "@/data/marketing"

/**
 * Accueil.
 *
 * Retour arrière : remplacer `LandingV5` par
 * `import { LandingV4 } from "@/features/landing/landing-v4"`.
 * Les anciennes vitrines (V4 et landing-page) n'ont pas été supprimées.
 */

const SITE_URL = "https://copiq.fr"

export const metadata: Metadata = {
  title: "COP'IQ — Préparation aux concours de la Police nationale",
  description:
    "Prépare le concours de Gardien de la paix ou de Policier adjoint, puis l'école : quiz corrigés, cours, cas pratiques, psychotechniques et concours blancs. Un seul compte, sur le web et sur mobile.",
  alternates: { canonical: "/" },
  openGraph: {
    title: "COP'IQ — Préparation aux concours de la Police nationale",
    description:
      "Quiz, cours, cas pratiques corrigés et progression pour le concours de Gardien de la paix et de Policier adjoint.",
    url: SITE_URL,
    type: "website",
  },
}

/** Offres : montants réels, identiques à ceux facturés par Stripe. */
const organizationJsonLd = {
  "@context": "https://schema.org",
  "@type": "Organization",
  name: "COP'IQ",
  url: SITE_URL,
  description: INDEPENDENCE_NOTICE,
  logo:
    "https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo-png-copiq.png",
}

const serviceJsonLd = {
  "@context": "https://schema.org",
  "@type": "Service",
  name: "COP'IQ — préparation Police nationale",
  serviceType: "Préparation aux concours de la Police nationale",
  provider: { "@type": "Organization", name: "COP'IQ", url: SITE_URL },
  areaServed: { "@type": "Country", name: "France" },
  offers: PRICING.filter((p) => p.id !== "free").map((p) => ({
    "@type": "Offer",
    name: `COP'IQ Premium — ${p.name}`,
    price: p.price.replace(/[^\d,]/g, "").replace(",", "."),
    priceCurrency: "EUR",
    url: `${SITE_URL}/tarifs`,
  })),
}

export default function HomePage() {
  return (
    <>
      <script
        type="application/ld+json"
        // Contenu statique écrit dans ce fichier, aucune donnée utilisateur.
        dangerouslySetInnerHTML={{
          __html: JSON.stringify([
            organizationJsonLd,
            serviceJsonLd,
            faqJsonLd(HOME_FAQ),
          ]),
        }}
      />
      <LandingV5 />
    </>
  )
}
