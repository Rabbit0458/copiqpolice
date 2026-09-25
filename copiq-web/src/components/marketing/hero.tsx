import Link from "next/link"
import Image from "next/image"
import { ASSETS, PRODUCT_FACTS, INDEPENDENCE_NOTICE_SHORT, LAUNCH } from "@/data/marketing"
import {
  AppFrame,
  DashboardPanel,
  QuizPanel,
  PsychoPanel,
} from "@/components/marketing/product-composition"

/**
 * Hero de la vitrine.
 *
 * Composition, pas empilement : titre / paragraphe / bouton / photo à droite
 * est explicitement ce qu'il ne faut pas faire (§67). Ici, trois plans se
 * superposent à droite sur desktop — une fenêtre navigateur (tableau de bord),
 * une carte flottante sans cadre (quiz), un cadre mobile (psychotechniques) —
 * posés sur une photographie officielle très assombrie et masquée, plus deux
 * sources de lumière (bleu à gauche, rouge à droite) et un motif cérébral
 * discret.
 *
 * Mobile d'abord : sur petit écran la superposition est abandonnée au profit
 * d'un seul panneau, le titre reste lisible, les deux CTA restent au pouce.
 */
export function Hero() {
  return (
    <section className="cq-night cq-synapse relative overflow-hidden">
      {/* Photographie officielle en fond : contexte, jamais sujet (§68).
          Masquée et assombrie pour ne pas concurrencer l'interface. */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-y-0 right-0 hidden w-[62%] lg:block"
        style={{
          maskImage:
            "radial-gradient(75% 85% at 78% 45%, #000 0%, transparent 72%)",
          WebkitMaskImage:
            "radial-gradient(75% 85% at 78% 45%, #000 0%, transparent 72%)",
        }}
      >
        <Image
          src={ASSETS.terrain.src}
          alt=""
          width={ASSETS.terrain.width}
          height={ASSETS.terrain.height}
          priority
          unoptimized
          className="h-full w-full object-cover opacity-[0.17] saturate-[0.55]"
        />
      </div>

      {/* Deux halos qui dérivent très lentement. Un seul effet de lumière,
          pas de grain artificiel ni de traînée de curseur. */}
      <span
        aria-hidden="true"
        className="cq-drift pointer-events-none absolute -left-24 top-[-10%] h-[28rem] w-[28rem] rounded-full bg-[rgb(17_71_217/0.30)] blur-[110px]"
      />
      <span
        aria-hidden="true"
        className="cq-drift pointer-events-none absolute right-[8%] top-[42%] h-[20rem] w-[20rem] rounded-full bg-[rgb(224_22_43/0.16)] blur-[120px]"
        style={{ animationDelay: "-6s" }}
      />

      <div className="relative mx-auto grid max-w-7xl gap-14 px-4 pb-20 pt-[6.5rem] sm:px-6 lg:grid-cols-[minmax(0,1fr)_minmax(0,1.04fr)] lg:items-center lg:gap-10 lg:pb-32 lg:pt-[9.5rem] xl:px-8">
        {/* ── Colonne éditoriale ─────────────────────────────────────────── */}
        <div className="max-w-xl">
          <div className="flex flex-wrap items-center gap-2">
            {LAUNCH.status === "beta" && (
              <span className="inline-flex items-center gap-2 rounded-full border border-[#4D82FF]/35 bg-[#4D82FF]/10 px-3 py-1.5 text-[11.5px] font-semibold text-[#9CC0FF]">
                <span className="relative flex h-1.5 w-1.5">
                  <span className="h-1.5 w-1.5 rounded-full bg-[#4D82FF]" />
                </span>
                Sortie publique imminente
              </span>
            )}
            <span className="hidden items-center rounded-full border border-white/12 px-3 py-1.5 text-[11.5px] text-white/55 sm:inline-flex">
              {INDEPENDENCE_NOTICE_SHORT}
            </span>
          </div>

          <h1 className="cq-display mt-6 text-white">
            Votre préparation Police.
            <br />
            <span className="bg-gradient-to-r from-[#7FB3FF] via-white to-[#FF8A97] bg-clip-text text-transparent">
              Une longueur d’avance.
            </span>
          </h1>

          <p className="cq-lead mt-6 text-white/70">
            Préparez vos concours, entraînez-vous, révisez et mesurez votre
            progression sur une plateforme construite autour des épreuves et de
            la formation en école. Gardien de la paix et Policier adjoint,
            concours comme scolarité — un seul compte, sur mobile et sur le web.
          </p>

          <div className="mt-8 flex flex-col gap-3 sm:flex-row sm:items-center">
            <Link
              href="/signup"
              className="cq-tap inline-flex items-center justify-center gap-2 rounded-2xl bg-[#1147D9] px-6 py-3.5 text-[15px] font-semibold text-white shadow-[0_10px_40px_-8px_rgba(17,71,217,0.75)] transition-[transform,background-color] duration-200 hover:bg-[#1A55E6] active:translate-y-px"
            >
              Commencer ma préparation
              <svg viewBox="0 0 16 16" className="h-4 w-4" aria-hidden="true">
                <path
                  d="M3 8h9m0 0-3.4-3.4M12 8l-3.4 3.4"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="1.6"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </Link>
            <Link
              href="#produit"
              className="cq-tap inline-flex items-center justify-center rounded-2xl border border-white/18 bg-white/[0.04] px-6 py-3.5 text-[15px] font-semibold text-white/85 transition-colors duration-200 hover:border-white/30 hover:bg-white/[0.08]"
            >
              Découvrir COP’IQ
            </Link>
          </div>

          <p className="mt-4 text-[12.5px] text-white/55">
            Compte gratuit, sans carte bancaire. Premium à partir de 4,99 €.
          </p>

          {/* Faits vérifiables uniquement — aucun nombre d'utilisateurs,
              aucun taux de réussite (§53). */}
          <dl className="mt-10 grid grid-cols-2 gap-x-6 gap-y-5 border-t border-white/10 pt-7 sm:grid-cols-4">
            {PRODUCT_FACTS.map((f) => (
              // `flex-col-reverse` : le chiffre se lit d'abord à l'écran,
              // mais l'ordre du DOM reste dt puis dd.
              <div key={f.label} className="flex flex-col-reverse">
                <dt className="mt-0.5 text-[11.5px] leading-tight text-white/50">
                  {f.label}
                </dt>
                <dd className="text-[1.4rem] font-bold tracking-[-0.03em] text-white tabular-nums">
                  {f.value}
                </dd>
              </div>
            ))}
          </dl>
        </div>

        {/* ── Composition produit ────────────────────────────────────────── */}
        {/* Mobile : un seul panneau, dans un cadre mobile, sans superposition. */}
        <div className="lg:hidden">
          <div className="mx-auto max-w-[19rem] cq-halo">
            <AppFrame shell="phone" caption="Aperçu de l’interface — données d’exemple">
              <QuizPanel />
            </AppFrame>
          </div>
        </div>

        {/* Desktop : trois plans, profondeur, alternance des présentations (§69). */}
        <div className="relative hidden lg:block" aria-hidden="false">
          <div className="relative mx-auto h-[33rem] w-full max-w-[38rem]">
            <div className="cq-halo absolute left-0 top-2 w-[26.5rem]">
              <AppFrame shell="window" caption="Aperçu de l’interface — données d’exemple">
                <DashboardPanel />
              </AppFrame>
            </div>

            <div className="cq-float absolute right-0 top-[7.5rem] w-[20.5rem]">
              <AppFrame shell="bare">
                <QuizPanel />
              </AppFrame>
            </div>

            <div className="cq-float cq-float-delay absolute bottom-0 left-[6.5rem] w-[13.5rem]">
              <AppFrame shell="phone">
                <PsychoPanel />
              </AppFrame>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
