import Link from "next/link"
import { cn } from "@/lib/utils"
import { PRICING } from "@/data/marketing"
import { Reveal } from "@/components/marketing/reveal"
import { Section, SectionHead } from "@/components/marketing/sections"

/**
 * Tarifs.
 *
 * Les montants viennent de `src/data/marketing.ts`, qui reflète les prix
 * Stripe déjà en production. Ce composant ne décide d'aucun prix et n'envoie
 * aucun paiement : les CTA mènent à `/signup`, puis l'espace `/abonnement`
 * appelle l'Edge Function `cas_pratique_create_checkout`, seul chemin de
 * paiement valide (le Price ID est résolu et revérifié côté serveur, jamais
 * transmis par le navigateur).
 */
export function PricingSection({ compact = false }: { compact?: boolean }) {
  return (
    <Section id="tarifs">
      <SectionHead
        align="center"
        eyebrow="Tarifs"
        title="Un abonnement, les quatre parcours."
        lead="Aucun module n’est vendu séparément. Sept jours d’essai sur le mensuel et l’annuel, résiliation à tout moment."
      />

      <div
        className={cn(
          "mx-auto mt-12 grid max-w-6xl gap-4 sm:mt-14",
          "sm:grid-cols-2 lg:grid-cols-4",
        )}
      >
        {PRICING.map((plan, i) => (
          <Reveal key={plan.id} delay={i * 60} className="h-full">
            <article
              className={cn(
                "relative flex h-full flex-col rounded-3xl border p-6",
                plan.highlighted
                  ? "border-[#1147D9] bg-[var(--surface)] shadow-[0_18px_60px_-24px_rgba(17,71,217,0.55)]"
                  : "border-[var(--outline)] bg-[var(--surface)]",
              )}
            >
              {plan.highlighted && (
                <span className="absolute -top-3 left-6 rounded-full bg-[#1147D9] px-3 py-1 text-[10.5px] font-semibold uppercase tracking-wider text-white">
                  Le plus choisi
                </span>
              )}

              <h3 className="cq-eyebrow text-[var(--on-surface-muted)]">
                {plan.name}
              </h3>

              <p className="mt-3 flex items-baseline gap-1.5">
                <span className="text-[1.85rem] font-bold tracking-[-0.03em] text-[var(--on-surface)] tabular-nums">
                  {plan.price}
                </span>
                {plan.period && (
                  <span className="text-[13px] text-[var(--on-surface-muted)]">
                    {plan.period}
                  </span>
                )}
              </p>

              <p className="mt-2.5 text-[13px] leading-relaxed text-[var(--on-surface-muted)]">
                {plan.pitch}
              </p>

              <ul className="mt-5 flex-1 space-y-2.5">
                {plan.features.map((f) => (
                  <li
                    key={f}
                    className="flex items-start gap-2 text-[13px] leading-snug text-[var(--on-surface)]"
                  >
                    <svg
                      viewBox="0 0 14 14"
                      className="mt-[0.2rem] h-3.5 w-3.5 shrink-0 text-[#22C55E]"
                      aria-hidden="true"
                    >
                      <path
                        d="M2.5 7.4 5.4 10.2 11.5 3.8"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="1.9"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                      />
                    </svg>
                    {f}
                  </li>
                ))}
              </ul>

              <Link
                href="/signup"
                className={cn(
                  "cq-tap mt-6 inline-flex items-center justify-center rounded-2xl px-4 py-3 text-[14px] font-semibold transition-colors duration-200",
                  plan.highlighted
                    ? "bg-[#1147D9] text-white hover:bg-[#1A55E6]"
                    : "border border-[var(--outline)] text-[var(--on-surface)] hover:bg-[var(--surface-container)]",
                )}
              >
                {plan.cta}
              </Link>

              {plan.note && (
                <p className="mt-3 text-[11.5px] leading-snug text-[var(--on-surface-muted)]">
                  {plan.note}
                </p>
              )}
            </article>
          </Reveal>
        ))}
      </div>

      {!compact && (
        <Reveal delay={200}>
          <p className="mx-auto mt-10 max-w-2xl text-center text-[12.5px] leading-relaxed text-[var(--on-surface-muted)]">
            Abonnement souscrit sur le web : paiement par carte via Stripe,
            gestion et factures depuis votre espace. Abonnement souscrit dans
            l’application mobile : facturation et résiliation gérées par l’App
            Store ou Google Play. Dans les deux cas, l’accès Premium est le
            même sur tous vos appareils.
          </p>
        </Reveal>
      )}
    </Section>
  )
}
