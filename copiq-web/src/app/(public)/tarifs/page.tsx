import type { Metadata } from "next"
import Link from "next/link"
import { PricingSection } from "@/components/marketing/pricing-section"
import { FaqSection, faqJsonLd } from "@/components/marketing/faq-section"
import { Reveal } from "@/components/marketing/reveal"
import { INDEPENDENCE_NOTICE } from "@/data/marketing"

/**
 * Tarifs.
 *
 * Refonte UI/UX uniquement. Les montants ne sont pas décidés ici : ils
 * viennent de `src/data/marketing.ts`, qui reflète les prix Stripe déjà
 * facturés (`cas_pratique_create_checkout`) et les conditions publiées dans
 * `lib/legal/legal_content.dart`.
 *
 * Deux corrections de fond par rapport à la version précédente :
 *  1. le plan hebdomadaire (4,99 €), vendable et présent dans l'espace
 *     `/abonnement`, était absent de cette page ;
 *  2. le tableau comparatif annonçait des avantages propres à l'annuel
 *     (« support prioritaire », « accès anticipé aux nouveautés ») qui
 *     n'existent pas dans l'offre réelle : Premium est Premium, quelle que
 *     soit la périodicité. Ces lignes ont été retirées plutôt que
 *     « améliorées ».
 */

const SITE_URL = "https://copiq.fr"

export const metadata: Metadata = {
  title: "Tarifs et abonnement",
  description:
    "Compte gratuit, ou Premium à partir de 4,99 €. Les quatre parcours inclus, 7 jours d'essai sur le mensuel et l'annuel, résiliation à tout moment.",
  alternates: { canonical: "/tarifs" },
  openGraph: {
    title: "Tarifs COP'IQ",
    description:
      "Compte gratuit ou Premium à partir de 4,99 €. Les quatre parcours inclus.",
    url: `${SITE_URL}/tarifs`,
    type: "website",
  },
}

/** Comparaison Gratuit / Premium. Uniquement des différences réelles. */
const COMPARISON: readonly (readonly [string, string, string])[] = [
  ["Quiz et QCM par module", "Inclus", "Inclus"],
  ["Cours et fiches de scolarité", "Inclus", "Inclus"],
  ["Cas pratiques rédigés et corrigés", "10 par semaine", "Illimité"],
  ["Concours blanc complet", "—", "Inclus"],
  ["Psychotechniques", "Inclus", "Inclus"],
  ["Culture générale", "Inclus", "Inclus"],
  ["Langues (GPX)", "Inclus", "Inclus"],
  ["Photolangage (PA)", "Inclus", "Inclus"],
  ["Progression et historique", "Inclus", "Inclus"],
  ["Mémos et notes", "Inclus", "Inclus"],
  ["Forum du parcours", "Inclus", "Inclus"],
  ["Export PDF de la copie corrigée", "—", "Inclus"],
  ["Publicité dans l’application mobile", "Oui", "Aucune"],
  ["Compte synchronisé mobile et web", "Inclus", "Inclus"],
]

const TARIFS_FAQ = [
  {
    q: "Qu’est-ce qui change entre l’hebdomadaire, le mensuel et l’annuel ?",
    a: "Uniquement la durée et le prix. L’accès Premium est identique dans les trois cas : aucun module n’est réservé à une périodicité. L’essai de 7 jours s’applique au mensuel et à l’annuel.",
  },
  {
    q: "Si je m’abonne sur mobile, suis-je Premium sur le web ?",
    a: "Oui. L’abonnement est rattaché à votre compte COP’IQ, pas à l’appareil. Un abonnement souscrit sur l’App Store ou Google Play débloque aussi le web, et inversement.",
  },
  {
    q: "Comment suis-je facturé ?",
    a: "Sur le web, par carte bancaire via Stripe : la page de paiement est hébergée par Stripe, COP’IQ ne voit jamais votre numéro de carte. Dans l’application, la facturation passe par l’App Store ou Google Play.",
  },
  {
    q: "Où trouver mes factures ?",
    a: "Pour un abonnement web, dans le portail de facturation Stripe, accessible depuis la page Abonnement de votre espace. Pour un abonnement mobile, dans l’historique d’achats de votre compte App Store ou Google Play.",
  },
  {
    q: "Puis-je être facturé deux fois si je clique deux fois ?",
    a: "Non. Le bouton se verrouille pendant l’ouverture du paiement, et la session de paiement est créée côté serveur pour un client Stripe unique rattaché à votre compte.",
  },
  {
    q: "Puis-je annuler à tout moment ?",
    a: "Oui, sans frais et sans justification. L’accès reste actif jusqu’à la fin de la période déjà réglée.",
  },
] as const

export default function TarifsPage() {
  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(faqJsonLd(TARIFS_FAQ)),
        }}
      />

      <section className="cq-night cq-synapse relative overflow-hidden">
        <span
          aria-hidden="true"
          className="cq-drift pointer-events-none absolute left-1/2 top-[-40%] h-[24rem] w-[24rem] -translate-x-1/2 rounded-full bg-[rgb(17_71_217/0.26)] blur-[110px]"
        />
        <div className="relative mx-auto max-w-3xl px-4 pb-14 pt-12 text-center sm:px-6 lg:pb-16 lg:pt-16">
          <p className="cq-eyebrow text-[#7FB3FF]">Tarifs</p>
          <h1 className="cq-title mt-3 text-white">
            Un prix clair, quatre parcours inclus.
          </h1>
          <p className="cq-lead mx-auto mt-5 max-w-xl text-white/70">
            Commencez gratuitement. Passez Premium quand vous voulez lever les
            limites — et arrêtez quand votre concours est passé.
          </p>
        </div>
      </section>

      <PricingSection />

      {/* ── Comparaison ───────────────────────────────────────────────── */}
      <section className="border-t border-[var(--outline-variant)] bg-[var(--surface-container)]">
        <div className="mx-auto max-w-4xl px-4 py-16 sm:px-6 lg:py-20">
          <h2 className="cq-title text-[var(--on-surface)]">
            Gratuit ou Premium&nbsp;?
          </h2>
          <p className="mt-3 text-[14.5px] leading-relaxed text-[var(--on-surface-muted)]">
            La version gratuite n’est pas une démonstration bridée : la
            quasi-totalité des contenus est accessible. Premium lève les limites
            de volume et débloque les épreuves complètes.
          </p>

          {/* Desktop : tableau. Mobile : liste — pas un tableau compressé (§52). */}
          <div className="mt-8 hidden overflow-hidden rounded-2xl border border-[var(--outline)] bg-[var(--surface)] sm:block">
            <table className="w-full text-[13.5px]">
              <caption className="sr-only">
                Comparaison des offres gratuite et Premium
              </caption>
              <thead>
                <tr className="border-b border-[var(--outline)] bg-[var(--surface-container)]">
                  <th scope="col" className="px-5 py-3 text-left font-semibold text-[var(--on-surface-muted)]">
                    Fonctionnalité
                  </th>
                  <th scope="col" className="px-5 py-3 text-center font-semibold text-[var(--on-surface)]">
                    Gratuit
                  </th>
                  <th scope="col" className="px-5 py-3 text-center font-semibold text-[#1147D9] [.dark_&]:text-[#7FB3FF]">
                    Premium
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[var(--outline-variant)]">
                {COMPARISON.map(([feature, free, premium]) => (
                  <tr key={feature}>
                    <th scope="row" className="px-5 py-3 text-left font-normal text-[var(--on-surface)]">
                      {feature}
                    </th>
                    <td className="px-5 py-3 text-center text-[var(--on-surface-muted)]">
                      {free}
                    </td>
                    <td className="px-5 py-3 text-center font-medium text-[var(--on-surface)]">
                      {premium}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <ul className="mt-8 space-y-2.5 sm:hidden">
            {COMPARISON.map(([feature, free, premium]) => (
              <li
                key={feature}
                className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-4"
              >
                <p className="text-[14px] font-semibold text-[var(--on-surface)]">
                  {feature}
                </p>
                <dl className="mt-2.5 grid grid-cols-2 gap-3 text-[12.5px]">
                  <div>
                    <dt className="text-[var(--on-surface-muted)]">Gratuit</dt>
                    <dd className="mt-0.5 text-[var(--on-surface-muted)]">{free}</dd>
                  </div>
                  <div>
                    <dt className="text-[#1147D9] [.dark_&]:text-[#7FB3FF]">Premium</dt>
                    <dd className="mt-0.5 font-medium text-[var(--on-surface)]">
                      {premium}
                    </dd>
                  </div>
                </dl>
              </li>
            ))}
          </ul>

          <Reveal>
            <aside className="mt-8 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] p-5 text-[12.5px] leading-relaxed text-[var(--on-surface-muted)]">
              {INDEPENDENCE_NOTICE} Les conditions complètes figurent dans les{" "}
              <Link href="/cgu" className="underline underline-offset-2">
                conditions d’utilisation
              </Link>{" "}
              et la{" "}
              <Link href="/privacy" className="underline underline-offset-2">
                politique de confidentialité
              </Link>
              .
            </aside>
          </Reveal>
        </div>
      </section>

      <FaqSection
        items={TARIFS_FAQ}
        eyebrow="Facturation"
        title="Ce qu’il faut savoir sur l’abonnement."
      />
    </>
  )
}
