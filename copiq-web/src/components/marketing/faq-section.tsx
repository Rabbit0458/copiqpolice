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
    q: "Mon compte du site et celui de l’application, c’est le même ?",
    a: "Oui. Le site et l’application utilisent le même compte : une seule connexion, une seule progression, un seul abonnement. Une question répondue sur ton téléphone apparaît dans ton historique sur le web.",
  },
  {
    q: "Je peux préparer le concours, puis l’école ?",
    a: "Oui. Il y a quatre parcours : Gardien de la paix concours, Gardien de la paix école, Policier adjoint concours, Policier adjoint école. Tu choisis ton parcours à l’inscription et tu peux en changer à tout moment dans tes paramètres.",
  },
  {
    q: "Qu’est-ce qui est gratuit ?",
    a: "Les quiz et QCM d’entraînement, dix cas pratiques par semaine, le forum de ton parcours, ta progression et ton historique. L’application mobile affiche de la publicité aux comptes gratuits ; Premium la supprime.",
  },
  {
    q: "Le compte gratuit est-il limité dans le temps ?",
    a: "Non. Le compte gratuit reste gratuit, sans date de fin. Premium se prend au mois (8,99 €) ou à l’année (79,99 €), sans engagement, quand tu en as besoin.",
  },
  {
    q: "Comment résilier mon abonnement ?",
    a: "Abonnement pris sur le web : depuis la page Abonnement de ton espace, en deux clics. Abonnement pris sur mobile : depuis les abonnements de ton compte App Store ou Google Play. Dans les deux cas, tu gardes l’accès jusqu’à la fin de la période déjà payée.",
  },
  {
    q: "Comment les cas pratiques sont-ils corrigés ?",
    a: "Ta réponse rédigée est comparée aux éléments attendus du corrigé. Tu reçois la qualification retenue, le nombre d’éléments trouvés et la liste de ce qui manque.",
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
