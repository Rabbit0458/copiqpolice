import Link from "next/link"
import Image from "next/image"
import { cn } from "@/lib/utils"
import { Reveal } from "@/components/marketing/reveal"
import {
  ASSETS,
  CAPABILITIES,
  PATHWAY_CARDS,
  PHOTOLANGAGE,
  TESTIMONIALS,
  INDEPENDENCE_NOTICE,
  LAUNCH,
} from "@/data/marketing"
import {
  AppFrame,
  CasPratiquePanel,
  ProgressionPanel,
} from "@/components/marketing/product-composition"

/* ═══════════════════════════════════════════════════════════════════════════
   Coque de section — rythme vertical et gouttière uniformes
   ═══════════════════════════════════════════════════════════════════════ */

export function Section({
  id,
  tone = "light",
  children,
  className,
}: {
  id?: string
  tone?: "light" | "night"
  children: React.ReactNode
  className?: string
}) {
  return (
    <section
      id={id}
      className={cn(
        "relative",
        tone === "night" ? "cq-night" : "bg-[var(--surface)] text-[var(--on-surface)]",
        className,
      )}
      style={{ paddingTop: "var(--section-y)", paddingBottom: "var(--section-y)" }}
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 xl:px-8">{children}</div>
    </section>
  )
}

export function SectionHead({
  eyebrow,
  title,
  lead,
  tone = "light",
  align = "start",
}: {
  eyebrow?: string
  title: string
  lead?: string
  tone?: "light" | "night"
  align?: "start" | "center"
}) {
  const night = tone === "night"
  return (
    <Reveal
      className={cn(
        "max-w-2xl",
        align === "center" && "mx-auto text-center",
      )}
    >
      {eyebrow && (
        <p className={cn("cq-eyebrow", night ? "text-[#7FB3FF]" : "text-[#1147D9] [.dark_&]:text-[#7FB3FF]")}>
          {eyebrow}
        </p>
      )}
      <h2
        className={cn(
          "cq-title mt-3",
          night ? "text-white" : "text-[var(--on-surface)]",
        )}
      >
        {title}
      </h2>
      {lead && (
        <p
          className={cn(
            "cq-lead mt-4",
            night ? "text-white/65" : "text-[var(--on-surface-muted)]",
          )}
        >
          {lead}
        </p>
      )}
    </Reveal>
  )
}

/* ═══════════════════════════════════════════════════════════════════════════
   Parcours — nomenclature reprise telle quelle de l'application (§38)
   ═══════════════════════════════════════════════════════════════════════ */

export function PathwaysSection() {
  return (
    <Section id="parcours">
      <SectionHead
        eyebrow="Quatre parcours"
        title="Le concours, puis l’école. Les deux sont couverts."
        lead="COP’IQ ne s’arrête pas au jour de l’épreuve. Gardien de la paix et Policier adjoint disposent chacun d’un parcours concours et d’un parcours scolarité, avec leurs propres modules."
      />

      <div className="mt-12 grid gap-4 sm:mt-14 sm:grid-cols-2">
        {PATHWAY_CARDS.map((p, i) => (
          <Reveal key={p.id} delay={i * 70} className="h-full">
            <article className="group relative flex h-full flex-col overflow-hidden rounded-3xl border border-[var(--outline)] bg-[var(--surface)] transition-[border-color,box-shadow] duration-300 hover:border-transparent hover:shadow-card-hover">
              <span
                aria-hidden="true"
                className="absolute inset-x-0 top-0 h-[3px]"
                style={{ background: p.color }}
              />

              {p.image && (
                <div className="cq-photo cq-photo-grade aspect-[16/7] w-full">
                  <Image
                    src={ASSETS[p.image].src}
                    alt={ASSETS[p.image].alt}
                    width={ASSETS[p.image].width}
                    height={ASSETS[p.image].height}
                    loading="lazy"
                    unoptimized
                    sizes="(max-width: 640px) 100vw, 46vw"
                  />
                </div>
              )}

              <div className="flex flex-1 flex-col p-6 sm:p-7">
                {/* La couleur du parcours (reprise de `pathways.ts`) sert de
                    repère, pas de couleur de texte : plusieurs de ces teintes
                    tombent sous 4,5:1 en thème sombre. Le libellé reste en
                    couleur de texte standard, la couleur passe dans la pastille
                    et dans le filet supérieur de la carte. */}
                <span className="cq-eyebrow inline-flex items-center gap-2 text-[var(--on-surface-muted)]">
                  <span
                    aria-hidden="true"
                    className="h-2 w-2 rounded-full"
                    style={{ background: p.color }}
                  />
                  {p.shortLabel}
                </span>
                <h3 className="mt-2.5 text-[1.2rem] font-bold leading-snug tracking-[-0.02em] text-[var(--on-surface)]">
                  {p.title}
                </h3>
                <p className="mt-2.5 text-[14px] leading-relaxed text-[var(--on-surface-muted)]">
                  {p.description}
                </p>

                <ul className="mt-5 flex flex-wrap gap-1.5">
                  {p.modules.map((m) => (
                    <li
                      key={m}
                      className="rounded-lg border border-[var(--outline-variant)] bg-[var(--surface-container)] px-2.5 py-1 text-[11.5px] text-[var(--on-surface-muted)]"
                    >
                      {m}
                    </li>
                  ))}
                </ul>

                <Link
                  href="/signup"
                  className="cq-tap mt-6 inline-flex items-center gap-1.5 self-start text-[13.5px] font-semibold text-[#1147D9] transition-transform duration-200 group-hover:translate-x-0.5 [.dark_&]:text-[#7FB3FF]"
                >
                  Préparer ce parcours
                  <svg viewBox="0 0 16 16" className="h-3.5 w-3.5" aria-hidden="true">
                    <path
                      d="M3 8h9m0 0-3.4-3.4M12 8l-3.4 3.4"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.7"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                </Link>
              </div>
            </article>
          </Reveal>
        ))}
      </div>
    </Section>
  )
}

/* ═══════════════════════════════════════════════════════════════════════════
   Bande éditoriale immersive — cas pratiques
   ═══════════════════════════════════════════════════════════════════════ */

export function CasPratiqueBand() {
  return (
    <section id="cas-pratiques" className="relative overflow-hidden bg-[#00061F]">
      <div className="cq-photo cq-photo-grade cq-photo-scrim cq-photo-vignette absolute inset-0">
        <Image
          src={ASSETS.intervention.src}
          alt={ASSETS.intervention.alt}
          width={ASSETS.intervention.width}
          height={ASSETS.intervention.height}
          loading="lazy"
          unoptimized
          sizes="100vw"
          /* La source porte des bandes grises à droite et en bas :
             on recadre par object-position plutôt que de retoucher le fichier. */
          className="!object-[42%_34%] scale-[1.06]"
        />
      </div>

      <div
        className="relative mx-auto grid max-w-7xl gap-12 px-4 sm:px-6 lg:grid-cols-[minmax(0,1fr)_26rem] lg:items-center xl:px-8"
        style={{ paddingTop: "var(--section-y)", paddingBottom: "var(--section-y)" }}
      >
        <Reveal className="max-w-xl">
          <p className="cq-eyebrow text-[#FF8A97]">Cas pratiques</p>
          <h2 className="cq-title mt-3 text-white">
            Vous rédigez. La correction vous dit ce qui manque.
          </h2>
          <p className="cq-lead mt-4 text-white/70">
            Le moteur de correction de COP’IQ lit votre réponse, la normalise,
            la lemmatise et la compare aux éléments attendus. Vous obtenez la
            qualification retenue, les points acquis et surtout les oublis —
            ceux qui coûtent des points le jour de l’épreuve.
          </p>
          <ul className="mt-7 space-y-3">
            {[
              "Qualification juridique vérifiée",
              "Éléments attendus comptés un par un",
              "Copie corrigée exportable en PDF",
            ].map((t) => (
              <li key={t} className="flex items-start gap-3 text-[14px] text-white/75">
                <span
                  aria-hidden="true"
                  className="mt-[0.4rem] h-1.5 w-1.5 shrink-0 rounded-full bg-[#E0162B]"
                />
                {t}
              </li>
            ))}
          </ul>
        </Reveal>

        <Reveal delay={120} className="cq-halo cq-halo-red">
          <AppFrame shell="bare" caption="Aperçu de l’interface — données d’exemple">
            <CasPratiquePanel />
          </AppFrame>
        </Reveal>
      </div>
    </section>
  )
}

/* ═══════════════════════════════════════════════════════════════════════════
   Fonctionnalités — liste dense, pas neuf icon-boxes identiques (§8)
   ═══════════════════════════════════════════════════════════════════════ */

export function CapabilitiesSection() {
  return (
    <Section id="produit">
      <div className="grid gap-14 lg:grid-cols-[minmax(0,1fr)_minmax(0,1fr)] lg:gap-16">
        <div>
          <SectionHead
            eyebrow="La plateforme"
            title="Tout ce que vous utilisez sur mobile, dans le navigateur."
            lead="Le web n’est pas une brochure qui accompagne l’application : c’est la même plateforme, sur le même compte, avec les mêmes données."
          />

          <Reveal delay={90}>
            <ul className="mt-10 divide-y divide-[var(--outline-variant)] border-y border-[var(--outline-variant)]">
              {CAPABILITIES.map((c) => (
                <li key={c.key} className="py-4">
                  <div className="flex items-baseline gap-2.5">
                    <h3 className="text-[15px] font-semibold tracking-[-0.01em] text-[var(--on-surface)]">
                      {c.title}
                    </h3>
                    {c.premium && (
                      <span className="rounded-md bg-[#1147D9]/12 px-1.5 py-0.5 text-[10px] font-semibold uppercase tracking-wider text-[#1147D9] [.dark_&]:bg-[#4D82FF]/15 [.dark_&]:text-[#9CC0FF]">
                        Premium
                      </span>
                    )}
                  </div>
                  <p className="mt-1 text-[13.5px] leading-relaxed text-[var(--on-surface-muted)]">
                    {c.body}
                  </p>
                </li>
              ))}
            </ul>
          </Reveal>
        </div>

        <Reveal delay={140} className="lg:sticky lg:top-24 lg:self-start">
          <div className="cq-night cq-synapse overflow-hidden rounded-3xl p-5 sm:p-7">
            <AppFrame shell="bare" caption="Aperçu de l’interface — données d’exemple">
              <ProgressionPanel />
            </AppFrame>
            <p className="mt-6 text-[13.5px] leading-relaxed text-white/60">
              Une question répondue sur mobile dans le métro apparaît dans votre
              historique web. Un même identifiant Supabase, une même
              progression, un même abonnement.
            </p>
          </div>
        </Reveal>
      </div>
    </Section>
  )
}

/* ═══════════════════════════════════════════════════════════════════════════
   Photolangage — contenu pédagogique, présenté comme tel (§72)
   ═══════════════════════════════════════════════════════════════════════ */

export function PhotolangageSection() {
  return (
    <Section tone="night" id="photolangage">
      <SectionHead
        tone="night"
        eyebrow="Policier adjoint"
        title="Photolangage : décrire, analyser, prendre position."
        lead="L’épreuve d’analyse d’image du concours de Policier adjoint s’entraîne sur des supports réels. Voici des exemples de ceux utilisés dans COP’IQ."
      />

      <Reveal delay={90} className="mt-12">
        <ul className="grid grid-cols-2 gap-3 lg:grid-cols-4">
          {PHOTOLANGAGE.map((p, i) => (
            <li key={p.src}>
              <figure className="m-0">
                <div className="cq-photo cq-photo-grade aspect-[4/3] rounded-2xl border border-white/10">
                  <Image
                    src={p.src}
                    alt={p.alt}
                    width={p.width}
                    height={p.height}
                    loading="lazy"
                    unoptimized
                    sizes="(max-width: 1024px) 46vw, 23vw"
                  />
                </div>
                <figcaption className="mt-2 text-[11px] leading-snug text-white/55">
                  Support d’exercice {i + 1} — photolangage PA
                </figcaption>
              </figure>
            </li>
          ))}
        </ul>
      </Reveal>

      <Reveal delay={150}>
        <p className="mt-8 max-w-2xl text-[13px] leading-relaxed text-white/55">
          Ces images sont des supports pédagogiques de l’exercice de
          photolangage. Elles ne constituent pas une communication
          institutionnelle.
        </p>
      </Reveal>
    </Section>
  )
}

/* ═══════════════════════════════════════════════════════════════════════════
   Témoignages — n'apparaît que si de vrais retours sont fournis (§44)
   ═══════════════════════════════════════════════════════════════════════ */

export function TestimonialsSection() {
  if (TESTIMONIALS.length === 0) return null

  return (
    <Section id="temoignages">
      <SectionHead
        align="center"
        eyebrow="Retours d’utilisateurs"
        title="Ce qu’en disent les candidats."
      />
      <div className="mx-auto mt-12 grid max-w-5xl gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {TESTIMONIALS.map((t, i) => (
          <Reveal key={t.author + i} delay={i * 70}>
            <blockquote className="flex h-full flex-col rounded-3xl border border-[var(--outline)] bg-[var(--surface-container)] p-6">
              <p className="flex-1 text-[14.5px] leading-relaxed text-[var(--on-surface)]">
                « {t.quote} »
              </p>
              <footer className="mt-5 text-[12.5px] text-[var(--on-surface-muted)]">
                <span className="font-semibold text-[var(--on-surface)]">{t.author}</span>
                {" — "}
                {t.context}
              </footer>
            </blockquote>
          </Reveal>
        ))}
      </div>
    </Section>
  )
}

/* ═══════════════════════════════════════════════════════════════════════════
   Appel final + boutiques (§43)
   ═══════════════════════════════════════════════════════════════════════ */

export function ClosingSection() {
  const live = LAUNCH.status === "live"

  return (
    <Section tone="night" id="commencer" className="cq-synapse">
      <div className="mx-auto max-w-3xl text-center">
        <Reveal>
          <h2 className="cq-title text-white">
            Créez votre compte, reprenez là où vous vous êtes arrêté.
          </h2>
          <p className="cq-lead mx-auto mt-5 max-w-xl text-white/65">
            Compte gratuit, sans carte bancaire. Vos réponses, votre
            progression et votre abonnement suivent d’un appareil à l’autre.
          </p>
        </Reveal>

        <Reveal delay={90}>
          <div className="mt-9 flex flex-col items-center justify-center gap-3 sm:flex-row">
            <Link
              href="/signup"
              className="cq-tap inline-flex w-full items-center justify-center rounded-2xl bg-[#1147D9] px-7 py-3.5 text-[15px] font-semibold text-white shadow-[0_10px_40px_-8px_rgba(17,71,217,0.75)] transition-colors duration-200 hover:bg-[#1A55E6] sm:w-auto"
            >
              Commencer ma préparation
            </Link>
            <Link
              href="/tarifs"
              className="cq-tap inline-flex w-full items-center justify-center rounded-2xl border border-white/18 bg-white/[0.04] px-7 py-3.5 text-[15px] font-semibold text-white/85 transition-colors duration-200 hover:border-white/30 hover:bg-white/[0.08] sm:w-auto"
            >
              Voir les tarifs
            </Link>
          </div>
        </Reveal>

        {/* Les badges de boutiques n'apparaissent que lorsque les liens
            existent réellement. Aucun lien mort, aucune promesse anticipée. */}
        {live && (LAUNCH.appStore || LAUNCH.googlePlay) ? (
          <Reveal delay={140}>
            <div className="mt-10 flex flex-wrap items-center justify-center gap-3">
              {LAUNCH.appStore && (
                <a
                  href={LAUNCH.appStore}
                  className="cq-tap inline-flex items-center rounded-xl border border-white/15 bg-white/[0.04] px-5 py-3 text-[13.5px] font-semibold text-white/85 hover:bg-white/[0.08]"
                >
                  Télécharger sur l’App Store
                </a>
              )}
              {LAUNCH.googlePlay && (
                <a
                  href={LAUNCH.googlePlay}
                  className="cq-tap inline-flex items-center rounded-xl border border-white/15 bg-white/[0.04] px-5 py-3 text-[13.5px] font-semibold text-white/85 hover:bg-white/[0.08]"
                >
                  Télécharger sur Google Play
                </a>
              )}
            </div>
          </Reveal>
        ) : (
          <Reveal delay={140}>
            <p className="mt-9 text-[13px] text-white/55">
              Les applications iOS et Android sont en phase de sortie publique.
              La version web est utilisable dès maintenant.
            </p>
          </Reveal>
        )}
      </div>
    </Section>
  )
}

/* ═══════════════════════════════════════════════════════════════════════════
   Mention d'indépendance institutionnelle (§45)
   ═══════════════════════════════════════════════════════════════════════ */

export function IndependenceNotice({ tone = "light" }: { tone?: "light" | "night" }) {
  const night = tone === "night"
  return (
    <aside
      className={cn(
        "border-y",
        night
          ? "border-white/10 bg-[#01040F]"
          : "border-[var(--outline-variant)] bg-[var(--surface-container)]",
      )}
    >
      <p
        className={cn(
          "mx-auto max-w-4xl px-4 py-5 text-center text-[12.5px] leading-relaxed sm:px-6",
          night ? "text-white/55" : "text-[var(--on-surface-muted)]",
        )}
      >
        {INDEPENDENCE_NOTICE}
      </p>
    </aside>
  )
}
