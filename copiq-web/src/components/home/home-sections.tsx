import Link from "next/link"
import { Check, Monitor, Smartphone } from "lucide-react"
import { cn } from "@/lib/utils"
import { Appear, SplitText } from "@/components/home/motion"
import { HOME_FAQ } from "@/components/marketing/faq-section"
import { PRICING } from "@/data/marketing"
import { Tricolore } from "@/components/home/brand"
import { QuoteRotator } from "@/components/home/quote-rotator"

/* ─────────────────────────────────────────────────────────────────────────────
   Titre de section commun
   ───────────────────────────────────────────────────────────────────────── */

function SectionTitle({ children, lead }: { children: string; lead?: string }) {
  return (
    <>
      <SplitText
        as="h2"
        text={children}
        className="block max-w-[44rem] text-[clamp(2rem,4.2vw,3.1rem)] font-bold leading-[1.04] tracking-[-0.035em] text-[var(--on-surface)] [text-wrap:balance]"
      />
      {lead && (
        <Appear delay={200}>
          <p className="mt-5 max-w-[40rem] text-[17px] leading-relaxed text-[var(--on-surface-muted)]">
            {lead}
          </p>
        </Appear>
      )}
    </>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Un compte, deux écrans
   ───────────────────────────────────────────────────────────────────────── */

function DeviceCard({ compact = false }: { compact?: boolean }) {
  return (
    <div className={cn("rounded-2xl bg-white p-3.5 shadow-[0_10px_20px_-14px_rgba(0,0,0,0.25)]", compact && "p-3")}>
      <p className="text-[11px] font-medium text-[#9E9E9E]">Reprendre</p>
      <p className={cn("mt-0.5 font-semibold leading-snug text-[#1C1C1C]", compact ? "text-[12px]" : "text-[13px]")}>Procédure pénale, série 4</p>
      <div className="mt-2.5 h-1.5 rounded-full bg-[#E9ECF3]">
        <div className="h-full w-[64%] rounded-full bg-[#1147D9]" />
      </div>
      <p className="mt-1.5 text-[10.5px] font-medium text-[#9E9E9E]">13 sur 20</p>
    </div>
  )
}

export function SyncSection() {
  return (
    <section className="bg-[var(--surface)] py-[var(--section-y)]">
      <div className="mx-auto grid max-w-7xl items-center gap-14 px-4 sm:px-6 lg:grid-cols-2 lg:gap-20 xl:px-8">
        <div>
          <SectionTitle lead="Ta progression, tes favoris, tes notes et ton abonnement sont rattachés à ton compte, pas à ton appareil. Tu reprends exactement où tu t’es arrêté.">
            Commence dans le métro, termine sur ton ordinateur.
          </SectionTitle>
          <Appear delay={300}>
            <ul className="mt-8 grid gap-3 text-[15.5px] text-[var(--on-surface)]">
              <li className="flex items-center gap-3">
                <Monitor className="h-5 w-5 shrink-0 text-[#1147D9] dark:text-[#7FB3FF]" aria-hidden="true" />
                Sur copiq.fr, dès maintenant, depuis n’importe quel navigateur.
              </li>
              <li className="flex items-center gap-3">
                <Smartphone className="h-5 w-5 shrink-0 text-[#1147D9] dark:text-[#7FB3FF]" aria-hidden="true" />
                Sur iPhone et Android, très bientôt, avec le même compte.
              </li>
            </ul>
          </Appear>
        </div>

        {/* Illustration : le même point de reprise sur les deux écrans */}
        <div aria-hidden="true" className="relative mx-auto h-[340px] w-full max-w-[520px] sm:h-[380px]">
          <Appear variant="scale" delay={100} className="absolute left-0 top-0 w-[86%]">
            <div className="w-full rounded-[22px] bg-[#0B1020] p-2.5 dark:ring-1 dark:ring-white/12 shadow-[0_40px_80px_-40px_rgba(0,11,54,0.6)]">
              <div className="flex gap-1.5 px-2 pb-2.5 pt-1">
                <span className="h-2 w-2 rounded-full bg-white/20" />
                <span className="h-2 w-2 rounded-full bg-white/20" />
                <span className="h-2 w-2 rounded-full bg-white/20" />
              </div>
              <div className="grid h-[230px] gap-3 overflow-hidden rounded-[14px] bg-[#F6F7FB] p-3 sm:h-[260px] sm:grid-cols-[5.5rem_1fr]">
                <div className="hidden space-y-2 rounded-xl bg-white p-2.5 sm:block">
                  <span className="block h-2 w-10 rounded-full bg-[#1147D9]" />
                  <span className="block h-1.5 w-14 rounded-full bg-[#E9ECF3]" />
                  <span className="block h-1.5 w-12 rounded-full bg-[#E9ECF3]" />
                  <span className="block h-1.5 w-14 rounded-full bg-[#E9ECF3]" />
                </div>
                <div className="w-[62%] space-y-3 sm:w-auto">
                  <span className="block h-2.5 w-32 rounded-full bg-[#1C1C1C]/80" />
                  <DeviceCard />
                  <div className="grid grid-cols-2 gap-2">
                    <span className="block h-14 rounded-xl bg-white" />
                    <span className="block h-14 rounded-xl bg-white" />
                  </div>
                </div>
              </div>
            </div>
          </Appear>
          <Appear variant="right" delay={380} className="absolute bottom-0 right-0 w-[40%] max-w-[190px]">
            <div className="w-full rounded-[30px] bg-[#0B1020] p-2 dark:ring-1 dark:ring-white/12 shadow-[0_40px_80px_-30px_rgba(0,11,54,0.7)]">
              <div className="h-[250px] overflow-hidden rounded-[23px] bg-[#F6F7FB] p-2.5 pt-6 sm:h-[290px]">
                <span className="mx-auto mb-3 block h-2 w-14 rounded-full bg-[#1C1C1C]/80" />
                <DeviceCard compact />
                <span className="mt-2.5 block h-12 rounded-xl bg-white" />
                <span className="mt-2 block h-12 rounded-xl bg-white" />
              </div>
            </div>
          </Appear>
        </div>
      </div>
    </section>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Tarifs
   ───────────────────────────────────────────────────────────────────────── */

export function HomePricing() {
  return (
    <section id="tarifs" className="scroll-mt-20 bg-[var(--surface-container)] py-[var(--section-y)]">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 xl:px-8">
        <SectionTitle lead="Le compte gratuit n’a pas de date de fin. Premium débloque tout, au mois ou à l’année, sans engagement.">
          Commence gratuitement. Passe Premium quand tu veux.
        </SectionTitle>

        <div>
          <div className="mt-12 grid gap-4 lg:grid-cols-3">
            {PRICING.map((plan, i) => {
              const dark = plan.highlighted
              return (
                <Appear as="article" key={plan.id} delay={i * 110} variant="scale" className="h-full">
                <div
                  className={cn(
                    "cq-card-lift flex h-full flex-col rounded-3xl p-7",
                    dark
                      ? "cq-glow-ring bg-[#000B36] text-white shadow-[0_40px_80px_-40px_rgba(0,11,54,0.8)]"
                      : "border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)]",
                  )}
                >
                  <div className="flex items-center justify-between gap-3">
                    <h3 className="text-[1.15rem] font-semibold">{plan.name}</h3>
                    {dark && (
                      <span className="rounded-full bg-white/12 px-2.5 py-1 text-[12px] font-medium text-white/85">
                        Le plus choisi
                      </span>
                    )}
                  </div>
                  <p className="mt-5 flex items-baseline gap-1.5">
                    <span className="text-[2.6rem] font-bold leading-none tracking-[-0.04em]">{plan.price}</span>
                    {plan.period && (
                      <span className={cn("text-[15px]", dark ? "text-white/60" : "text-[var(--on-surface-muted)]")}>
                        {plan.period}
                      </span>
                    )}
                  </p>
                  <p className={cn("mt-3 text-[15px] leading-relaxed", dark ? "text-white/70" : "text-[var(--on-surface-muted)]")}>
                    {plan.pitch}
                  </p>
                  <ul className="mt-6 grid gap-2.5">
                    {plan.features.map((f) => (
                      <li key={f} className="flex items-start gap-2.5 text-[14.5px] leading-snug">
                        <Check
                          className={cn("mt-0.5 h-4 w-4 shrink-0", dark ? "text-[#7FB3FF]" : "text-[#1147D9] dark:text-[#7FB3FF]")}
                          strokeWidth={2.5}
                          aria-hidden="true"
                        />
                        {f}
                      </li>
                    ))}
                  </ul>
                  <div className="mt-auto pt-8">
                    <Link
                      href={plan.id === "free" ? "/signup" : `/signup?plan=${plan.id}`}
                      className={cn(
                        "cq-tap cq-btn inline-flex w-full items-center justify-center rounded-2xl px-5 py-3 text-[15px] font-semibold",
                        dark
                          ? "cq-btn-shine bg-[#E0162B] text-white hover:bg-[#C8102A]"
                          : "border border-[var(--outline)] text-[var(--on-surface)] hover:border-[var(--on-surface-faint)]",
                      )}
                    >
                      {plan.cta}
                    </Link>
                    {plan.note && (
                      <p className={cn("mt-3 text-center text-[12.5px]", dark ? "text-white/55" : "text-[var(--on-surface-faint)]")}>
                        {plan.note}
                      </p>
                    )}
                  </div>
                </div>
                </Appear>
              )
            })}
          </div>
          <p className="mt-6 text-[14.5px] text-[var(--on-surface-muted)]">
            Un abonnement pris sur le web fonctionne aussi dans l’application, et inversement.{" "}
            <Link href="/tarifs" className="font-semibold text-[#1147D9] underline-offset-4 hover:underline dark:text-[#7FB3FF]">
              Comparer les formules en détail
            </Link>
          </p>
        </div>
      </div>
    </section>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Questions fréquentes
   ───────────────────────────────────────────────────────────────────────── */

export function HomeFaq() {
  return (
    <section id="faq" className="scroll-mt-20 bg-[var(--surface)] py-[var(--section-y)]">
      <div className="mx-auto grid max-w-7xl gap-10 px-4 sm:px-6 lg:grid-cols-[minmax(0,0.8fr)_minmax(0,1.2fr)] lg:gap-20 xl:px-8">
        <div>
          <SectionTitle>Les questions qu’on nous pose le plus.</SectionTitle>
          <Appear delay={200}>
            <p className="mt-5 text-[15.5px] text-[var(--on-surface-muted)]">
              Une autre question ?{" "}
              <Link href="/contact" className="font-semibold text-[#1147D9] underline-offset-4 hover:underline dark:text-[#7FB3FF]">
                Écris-nous
              </Link>
            </p>
          </Appear>
        </div>
        <Appear delay={120}>
          <ul className="cq-faq border-t border-[var(--outline)]">
            {HOME_FAQ.map((item) => (
              <li key={item.q} className="border-b border-[var(--outline)]">
                <details className="group">
                  <summary className="cq-tap flex cursor-pointer list-none items-center justify-between gap-6 py-5 text-[16.5px] font-semibold leading-snug text-[var(--on-surface)] [&::-webkit-details-marker]:hidden">
                    {item.q}
                    <span
                      aria-hidden="true"
                      className="grid h-8 w-8 shrink-0 place-items-center rounded-full border border-[var(--outline)] text-[var(--on-surface-muted)] transition-transform duration-200 group-open:rotate-45"
                    >
                      <svg viewBox="0 0 14 14" className="h-3 w-3">
                        <path d="M7 1.6v10.8M1.6 7h10.8" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
                      </svg>
                    </span>
                  </summary>
                  <p className="max-w-[40rem] pb-6 pr-12 text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]">
                    {item.a}
                  </p>
                </details>
              </li>
            ))}
          </ul>
        </Appear>
      </div>
    </section>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Appel final : la phrase COP'IQ
   ───────────────────────────────────────────────────────────────────────── */

export function ClosingQuote() {
  return (
    <section aria-label="Commencer" className="cq-home-hero relative isolate overflow-hidden text-white">
      <div className="mx-auto max-w-7xl px-4 py-[var(--section-y)] sm:px-6 xl:px-8">
        <Tricolore className="mb-10 h-1 w-16" />
        <div className="max-w-[58rem]">
          <QuoteRotator />
        </div>
        <div className="mt-12 flex flex-col gap-3 sm:flex-row">
          <Link
            href="/signup"
            className="cq-tap cq-btn cq-btn-shine cq-btn-lift inline-flex items-center justify-center rounded-2xl bg-[#E0162B] px-6 py-3.5 text-[16px] font-semibold text-white shadow-[0_14px_40px_-14px_rgba(224,22,43,0.9)] hover:bg-[#C8102A]"
          >
            Créer mon compte gratuit
          </Link>
          <Link
            href="/login"
            className="cq-tap cq-btn cq-btn-lift inline-flex items-center justify-center rounded-2xl border border-white/20 px-6 py-3.5 text-[16px] font-medium text-white/90 hover:border-white/45 hover:text-white"
          >
            J’ai déjà un compte
          </Link>
        </div>
      </div>
    </section>
  )
}
