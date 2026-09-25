import { Reveal } from "@/components/marketing/reveal"
import { Section, SectionHead } from "@/components/marketing/sections"

/**
 * FAQ de la vitrine.
 *
 * Chaque réponse est alignée sur le comportement réel du produit tel qu'il a
 * été vérifié dans le dépôt (Edge Functions Stripe, RevenueCat côté
 * boutiques, Supabase partagé mobile/web). Rien n'est promis qui n'existe pas.
 *
 * `<details>` natif : pas de JavaScript, accessible au clavier et aux
 * lecteurs d'écran par construction.
 */

export const HOME_FAQ = [
  {
    q: "COP’IQ est-il le site officiel de la Police nationale ?",
    a: "Non. COP’IQ est une plateforme de préparation indépendante. Elle n’est ni éditée, ni agréée, ni affiliée par la Police nationale ou le ministère de l’Intérieur. Les contenus sont pédagogiques et n’ont aucune valeur réglementaire.",
  },
  {
    q: "Le compte web et le compte mobile sont-ils le même compte ?",
    a: "Oui. Le site et l’application partagent le même projet Supabase : une seule identité, une seule progression, un seul abonnement. Une question répondue sur mobile apparaît dans l’historique web.",
  },
  {
    q: "Puis-je préparer le concours et la scolarité ?",
    a: "Oui. Quatre parcours existent : Gardien de la paix concours, Gardien de la paix école, Policier adjoint concours, Policier adjoint école. Vous choisissez votre parcours à l’inscription et vous pouvez en changer depuis vos paramètres.",
  },
  {
    q: "Que contient la version gratuite ?",
    a: "Les quiz et QCM d’entraînement, dix cas pratiques par semaine, le forum de votre parcours, la progression et l’historique. L’application mobile affiche de la publicité aux comptes gratuits ; Premium la supprime.",
  },
  {
    q: "Y a-t-il un essai gratuit ?",
    a: "Sept jours sur les formules mensuelle et annuelle. L’essai est géré par Stripe pour un abonnement souscrit sur le web, et par l’App Store ou Google Play pour un abonnement souscrit dans l’application.",
  },
  {
    q: "Comment résilier ?",
    a: "Abonnement souscrit sur le web : depuis la page Abonnement, le portail de facturation Stripe s’ouvre et la résiliation prend deux clics. Abonnement souscrit sur mobile : depuis les abonnements de votre compte App Store ou Google Play. Dans les deux cas, l’accès est conservé jusqu’à la fin de la période déjà payée.",
  },
  {
    q: "Comment les cas pratiques sont-ils corrigés ?",
    a: "La réponse rédigée est analysée côté serveur : normalisation du texte, lemmatisation, puis appariement avec les éléments attendus du corrigé. Vous recevez la qualification retenue, le décompte des éléments acquis et la liste des oublis.",
  },
  {
    q: "La version web remplace-t-elle l’application ?",
    a: "Non, elles se complètent. Le web donne plus de place aux cours, aux statistiques et à la rédaction des cas pratiques ; le mobile est plus pratique pour réviser par séries courtes. Les deux lisent les mêmes données.",
  },
] as const

export function FaqSection({
  items = HOME_FAQ,
  eyebrow = "Questions fréquentes",
  title = "Ce qu’il faut savoir avant de commencer.",
}: {
  items?: readonly { q: string; a: string }[]
  eyebrow?: string
  title?: string
}) {
  return (
    <Section id="faq">
      <div className="grid gap-10 lg:grid-cols-[22rem_minmax(0,1fr)] lg:gap-16">
        <SectionHead eyebrow={eyebrow} title={title} />

        <Reveal delay={80}>
          <ul className="divide-y divide-[var(--outline-variant)] border-y border-[var(--outline-variant)]">
            {items.map((item) => (
              <li key={item.q}>
                <details className="group">
                  <summary className="cq-tap flex cursor-pointer list-none items-start justify-between gap-4 py-4 text-[14.5px] font-semibold leading-snug text-[var(--on-surface)] [&::-webkit-details-marker]:hidden">
                    {item.q}
                    <span
                      aria-hidden="true"
                      className="mt-1 shrink-0 text-[var(--on-surface-faint)] transition-transform duration-200 group-open:rotate-45"
                    >
                      <svg viewBox="0 0 14 14" className="h-3.5 w-3.5">
                        <path
                          d="M7 1.6v10.8M1.6 7h10.8"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="1.7"
                          strokeLinecap="round"
                        />
                      </svg>
                    </span>
                  </summary>
                  <p className="pb-5 pr-8 text-[13.5px] leading-relaxed text-[var(--on-surface-muted)]">
                    {item.a}
                  </p>
                </details>
              </li>
            ))}
          </ul>
        </Reveal>
      </div>
    </Section>
  )
}

/** Données structurées FAQPage — à injecter dans la page, pas dans le composant. */
export function faqJsonLd(items: readonly { q: string; a: string }[]) {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: items.map((i) => ({
      "@type": "Question",
      name: i.q,
      acceptedAnswer: { "@type": "Answer", text: i.a },
    })),
  }
}
