"use client"

import { useRef, useState, type KeyboardEvent, type ReactNode } from "react"
import { Check, Clock3, Scale, ChevronLeft } from "lucide-react"
import { cn } from "@/lib/utils"
import { Appear, SplitText, useInView } from "@/components/home/motion"
import { useReducedMotion } from "@/hooks/use-reduced-motion"

/**
 * Fonctionnalités : une liste d'onglets à gauche, l'écran correspondant de
 * l'application à droite. Les écrans sont dessinés en HTML (pas de capture),
 * avec les jetons de l'app : encre #1C1C1C, rayons 16/20/24 px.
 * Le contenu affiché est un exemple d'interface, pas une statistique réelle.
 */

type Feature = {
  key: string
  title: string
  body: string
  screen: () => ReactNode
}

const INK = "#1C1C1C"

function ScreenTop({ title, right }: { title: string; right?: string }) {
  return (
    <div className="flex items-center justify-between px-4 pb-3 pt-2">
      <span className="flex items-center gap-1 text-[13px] font-semibold" style={{ color: INK }}>
        <ChevronLeft className="h-4 w-4 text-[#9E9E9E]" aria-hidden="true" />
        {title}
      </span>
      {right && <span className="text-[11.5px] font-medium text-[#9E9E9E]">{right}</span>}
    </div>
  )
}

function Bar({ w, className }: { w: string; className?: string }) {
  return <span className={cn("block h-2 rounded-full bg-[#E9ECF3]", className)} style={{ width: w }} />
}

const FEATURES: readonly Feature[] = [
  {
    key: "quiz",
    title: "Quiz et QCM",
    body: "Des séries par matière et par niveau. Chaque réponse est corrigée tout de suite, avec l’article de loi.",
    screen: () => (
      <>
        <ScreenTop title="Procédure pénale" right="7 / 20" />
        <div className="mx-4 h-1.5 rounded-full bg-[#E9ECF3]">
          <div className="h-full w-[35%] rounded-full bg-[#1147D9]" />
        </div>
        <p className="mx-4 mt-5 text-[14.5px] font-semibold leading-snug" style={{ color: INK }}>
          Qui peut procéder à une perquisition en enquête de flagrance ?
        </p>
        <div className="mx-4 mt-4 grid gap-2">
          {["L’officier de police judiciaire", "Le maire de la commune", "L’agent de police judiciaire"].map((o, i) => (
            <div
              key={o}
              className={cn(
                "flex items-center gap-2.5 rounded-2xl border px-3 py-2.5 text-[12.5px] font-medium",
                i === 0 ? "border-[#22C55E] bg-[#F0FDF4]" : "border-[#E0E0E0] bg-white",
              )}
              style={{ color: INK }}
            >
              <span
                className={cn(
                  "grid h-5 w-5 place-items-center rounded-full border",
                  i === 0 ? "border-[#22C55E] bg-[#22C55E] text-white" : "border-[#BDBDBD]",
                )}
              >
                {i === 0 && <Check className="h-3 w-3" strokeWidth={3} />}
              </span>
              {o}
            </div>
          ))}
        </div>
        <div className="mx-4 mt-4 rounded-2xl bg-[#EEF4FF] p-3">
          <p className="flex items-center gap-1.5 text-[11.5px] font-semibold text-[#1147D9]">
            <Scale className="h-3 w-3" aria-hidden="true" />
            Article 56 du Code de procédure pénale
          </p>
          <Bar w="92%" className="mt-2.5 h-1.5 bg-[#D6E3FF]" />
          <Bar w="70%" className="mt-1.5 h-1.5 bg-[#D6E3FF]" />
        </div>
      </>
    ),
  },
  {
    key: "cours",
    title: "Cours et fiches",
    body: "Le programme de l’école rédigé module par module, avec l’essentiel à retenir en fin de chapitre.",
    screen: () => (
      <>
        <ScreenTop title="Cadres juridiques" right="Chapitre 3 sur 8" />
        <div className="mx-4 h-28 rounded-[20px] bg-gradient-to-br from-[#0E2F9E] to-[#000B36] p-3.5">
          <p className="text-[11px] font-medium text-white/60">Chapitre 3</p>
          <p className="mt-1 text-[15px] font-semibold leading-snug text-white">L’enquête de flagrance</p>
        </div>
        <div className="mx-4 mt-4 space-y-2">
          <Bar w="96%" />
          <Bar w="88%" />
          <Bar w="93%" />
          <Bar w="60%" />
        </div>
        <div className="mx-4 mt-4 rounded-2xl border-l-4 border-[#E0162B] bg-[#FFF4F5] p-3">
          <p className="text-[12px] font-semibold" style={{ color: INK }}>À retenir</p>
          <p className="mt-1 text-[11.5px] leading-snug text-[#5B5B5B]">
            L’enquête de flagrance dure huit jours. Le procureur peut la prolonger de huit jours, sous conditions.
          </p>
          <p className="mt-2 text-[10.5px] font-medium text-[#9E9E9E]">Article 53 du Code de procédure pénale</p>
        </div>
        <div className="mx-4 mt-4 space-y-2">
          <Bar w="90%" />
          <Bar w="75%" />
        </div>
      </>
    ),
  },
  {
    key: "cas",
    title: "Cas pratiques corrigés",
    body: "Tu rédiges ta réponse comme le jour de l’épreuve. La correction détaille ce que tu as trouvé et ce qui manque.",
    screen: () => (
      <>
        <ScreenTop title="Cas pratique n° 12" right="Corrigé" />
        <div className="mx-4 rounded-[20px] bg-white p-3.5 shadow-[0_10px_16px_-12px_rgba(0,0,0,0.12)]">
          <p className="text-[11px] font-medium text-[#9E9E9E]">Qualification retenue</p>
          <p className="mt-1 text-[14px] font-semibold" style={{ color: INK }}>Vol aggravé, en réunion</p>
          <div className="mt-3 flex items-end justify-between">
            <p className="text-[26px] font-bold leading-none tracking-tight" style={{ color: INK }}>
              5<span className="text-[15px] text-[#BDBDBD]">/7</span>
            </p>
            <p className="text-[11px] font-medium text-[#22C55E]">éléments trouvés</p>
          </div>
          <div className="mt-2 flex gap-1">
            {Array.from({ length: 7 }).map((_, i) => (
              <span key={i} className={cn("h-1.5 flex-1 rounded-full", i < 5 ? "bg-[#22C55E]" : "bg-[#E9ECF3]")} />
            ))}
          </div>
        </div>
        <p className="mx-4 mt-4 text-[12px] font-semibold" style={{ color: INK }}>À ajouter</p>
        <div className="mx-4 mt-2 grid gap-2">
          {["Élément intentionnel", "Article 311-4 du Code pénal"].map((t) => (
            <div key={t} className="flex items-center gap-2 rounded-2xl border border-[#FDE2E4] bg-[#FFF7F8] px-3 py-2 text-[12px] font-medium" style={{ color: INK }}>
              <span className="h-1.5 w-1.5 rounded-full bg-[#E0162B]" />
              {t}
            </div>
          ))}
        </div>
      </>
    ),
  },
  {
    key: "psycho",
    title: "Psychotechniques",
    body: "Calcul, suites logiques et raisonnement, chronométrés comme en sélection.",
    screen: () => (
      <>
        <ScreenTop title="Suites logiques" right="4 / 15" />
        <div className="mx-4 flex items-center justify-center gap-1.5 rounded-full bg-[#FFF7E6] py-1.5 text-[12px] font-semibold text-[#B45309]">
          <Clock3 className="h-3.5 w-3.5" aria-hidden="true" />
          00:42
        </div>
        <div className="mx-4 mt-6 grid grid-cols-5 gap-1.5">
          {["3", "9", "27", "81", "?"].map((n, i) => (
            <div
              key={n}
              className={cn(
                "grid aspect-square place-items-center rounded-2xl text-[16px] font-bold",
                i === 4 ? "border-2 border-dashed border-[#1147D9] text-[#1147D9]" : "bg-white shadow-[0_6px_12px_-8px_rgba(0,0,0,0.18)]",
              )}
              style={i === 4 ? undefined : { color: INK }}
            >
              {n}
            </div>
          ))}
        </div>
        <div className="mx-4 mt-6 grid grid-cols-2 gap-2">
          {["162", "243", "324", "108"].map((n, i) => (
            <div
              key={n}
              className={cn(
                "rounded-2xl border py-3 text-center text-[14px] font-semibold",
                i === 1 ? "border-[#1147D9] bg-[#EEF4FF] text-[#1147D9]" : "border-[#E0E0E0] bg-white",
              )}
              style={i === 1 ? undefined : { color: INK }}
            >
              {n}
            </div>
          ))}
        </div>
      </>
    ),
  },
  {
    key: "blanc",
    title: "Concours blanc",
    body: "Une épreuve complète en conditions réelles, chronométrée et corrigée question par question.",
    screen: () => (
      <>
        <ScreenTop title="Concours blanc" right="Gardien de la paix" />
        <div className="mx-4 rounded-[24px] bg-[#000B36] p-4 text-white">
          <p className="text-[11px] font-medium text-white/60">Temps restant</p>
          <p className="mt-1 text-[28px] font-bold tabular-nums leading-none tracking-tight">1:24:10</p>
          <div className="mt-3 h-1.5 rounded-full bg-white/15">
            <div className="h-full w-[42%] rounded-full bg-white" />
          </div>
        </div>
        <div className="mx-4 mt-4 grid gap-2">
          {[
            ["Cas pratique", true],
            ["Culture générale", true],
            ["Psychotechniques", false],
            ["Langue étrangère", false],
          ].map(([t, ok]) => (
            <div key={String(t)} className="flex items-center justify-between rounded-2xl bg-white px-3 py-2.5 text-[12.5px] font-medium shadow-[0_6px_12px_-10px_rgba(0,0,0,0.2)]" style={{ color: INK }}>
              {t}
              <span className={cn("grid h-5 w-5 place-items-center rounded-full", ok ? "bg-[#22C55E] text-white" : "border border-[#BDBDBD]")}>
                {ok && <Check className="h-3 w-3" strokeWidth={3} />}
              </span>
            </div>
          ))}
        </div>
      </>
    ),
  },
  {
    key: "progression",
    title: "Progression",
    body: "Ton taux de réussite par matière, ton historique et tes favoris, identiques sur le web et sur mobile.",
    screen: () => (
      <>
        <ScreenTop title="Ma progression" />
        <div className="mx-4 flex items-center gap-4 rounded-[24px] bg-white p-4 shadow-[0_10px_16px_-12px_rgba(0,0,0,0.12)]">
          <svg viewBox="0 0 44 44" className="h-16 w-16 -rotate-90" aria-hidden="true">
            <circle cx="22" cy="22" r="18" fill="none" stroke="#E9ECF3" strokeWidth="5" />
            <circle cx="22" cy="22" r="18" fill="none" stroke="#1147D9" strokeWidth="5" strokeLinecap="round" strokeDasharray="113" strokeDashoffset="32" />
          </svg>
          <div>
            <p className="text-[24px] font-bold leading-none tracking-tight" style={{ color: INK }}>72 %</p>
            <p className="mt-1 text-[11.5px] text-[#9E9E9E]">de bonnes réponses</p>
          </div>
        </div>
        <div className="mx-4 mt-4 grid gap-3">
          {[
            ["Procédure pénale", 81],
            ["Droit pénal", 68],
            ["Culture générale", 74],
            ["Psychotechniques", 59],
          ].map(([t, v]) => (
            <div key={String(t)}>
              <div className="flex justify-between text-[12px] font-medium" style={{ color: INK }}>
                <span>{t}</span>
                <span className="text-[#9E9E9E]">{v} %</span>
              </div>
              <div className="mt-1.5 h-1.5 rounded-full bg-[#E9ECF3]">
                <div className="h-full rounded-full bg-[#1147D9]" style={{ width: `${v}%` }} />
              </div>
            </div>
          ))}
        </div>
      </>
    ),
  },
]

export function FeaturesShowcase() {
  const [active, setActive] = useState(0)
  /** Défilement automatique des onglets, coupé dès que le visiteur choisit. */
  const [auto, setAuto] = useState(true)
  const reduced = useReducedMotion()
  const [stageRef, inView] = useInView<HTMLDivElement>({ once: false, threshold: 0.35, rootMargin: "0px" })
  const tabs = useRef<(HTMLButtonElement | null)[]>([])

  function choose(i: number) {
    setAuto(false)
    setActive(i)
  }

  function onKey(e: KeyboardEvent<HTMLButtonElement>, i: number) {
    const keys: Record<string, number> = {
      ArrowDown: (i + 1) % FEATURES.length,
      ArrowRight: (i + 1) % FEATURES.length,
      ArrowUp: (i - 1 + FEATURES.length) % FEATURES.length,
      ArrowLeft: (i - 1 + FEATURES.length) % FEATURES.length,
      Home: 0,
      End: FEATURES.length - 1,
    }
    if (!(e.key in keys)) return
    e.preventDefault()
    const n = keys[e.key]
    choose(n)
    tabs.current[n]?.focus()
  }

  const feature = FEATURES[active]
  const cycling = auto && inView && !reduced

  return (
    <section id="fonctionnalites" className="scroll-mt-20 bg-[var(--surface-container)] py-[var(--section-y)]">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 xl:px-8">
        <SplitText
          as="h2"
          text="Tout ce que l’épreuve demande, au même endroit."
          className="block max-w-[44rem] text-[clamp(2rem,4.2vw,3.1rem)] font-bold leading-[1.04] tracking-[-0.035em] text-[var(--on-surface)] [text-wrap:balance]"
        />

        <div ref={stageRef} className="mt-12 grid gap-10 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-center lg:gap-20">
          <Appear delay={120} className="min-w-0">
            <div
              role="tablist"
              aria-label="Fonctionnalités"
              className="cq-tabs -mx-4 flex gap-2 overflow-x-auto px-4 pb-1 [scrollbar-width:none] sm:-mx-6 sm:px-6 lg:mx-0 lg:grid lg:gap-1.5 lg:overflow-visible lg:px-0 lg:pb-0"
            >
              {FEATURES.map((f, i) => {
                const selected = i === active
                return (
                  <button
                    key={f.key}
                    ref={(el) => {
                      tabs.current[i] = el
                    }}
                    role="tab"
                    id={`onglet-${f.key}`}
                    aria-selected={selected}
                    aria-controls="ecran-fonctionnalite"
                    tabIndex={selected ? 0 : -1}
                    onClick={() => choose(i)}
                    onKeyDown={(e) => onKey(e, i)}
                    className={cn(
                      "cq-tap relative shrink-0 overflow-hidden rounded-full border px-4 py-2 text-left transition-[background-color,border-color,box-shadow] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] lg:w-full lg:rounded-2xl lg:px-5 lg:py-4",
                      selected
                        ? "border-[var(--outline)] bg-[var(--surface)] shadow-[0_18px_40px_-28px_rgba(0,11,54,0.45)]"
                        : "border-[var(--outline)] lg:border-transparent lg:hover:bg-[var(--surface)]/60",
                    )}
                  >
                    <span
                      className={cn(
                        "flex items-center gap-3 whitespace-nowrap text-[15px] font-semibold tracking-[-0.015em] transition-colors duration-300 lg:text-[1.1rem]",
                        selected ? "text-[var(--on-surface)]" : "text-[var(--on-surface-muted)]",
                      )}
                    >
                      <span
                        aria-hidden="true"
                        className={cn(
                          "hidden h-5 w-1 rounded-full transition-colors duration-500 lg:block",
                          selected ? "bg-[#E0162B]" : "bg-[var(--outline)]",
                        )}
                      />
                      {f.title}
                    </span>
                    {/* Description : s'ouvre en douceur (grand écran) */}
                    <span
                      aria-hidden={!selected}
                      className={cn(
                        "hidden transition-[grid-template-rows,opacity] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] lg:grid",
                        selected ? "grid-rows-[1fr] opacity-100" : "grid-rows-[0fr] opacity-0",
                      )}
                    >
                      <span className="overflow-hidden">
                        <span className="block whitespace-normal pl-4 pt-2 text-[15px] leading-relaxed text-[var(--on-surface-muted)]">
                          {f.body}
                        </span>
                      </span>
                    </span>
                    {/* Progression du défilement automatique */}
                    {selected && cycling && (
                      <span
                        key={`p-${active}`}
                        aria-hidden="true"
                        className="cq-tab-progress absolute inset-x-4 bottom-0 h-[2px] rounded-full bg-[#E0162B] lg:inset-x-5"
                        style={{ animationDuration: "6s" }}
                        onAnimationEnd={() => setActive((a) => (a + 1) % FEATURES.length)}
                      />
                    )}
                  </button>
                )
              })}
            </div>
            {/* Sur mobile, la description de l'onglet actif passe sous la rangée */}
            <p key={`m-${active}`} className="cq-quiz-in mt-5 text-[15.5px] leading-relaxed text-[var(--on-surface)] lg:hidden">
              {feature.body}
            </p>
            <p className="mt-6 hidden max-w-[34rem] pl-5 text-[14.5px] leading-relaxed text-[var(--on-surface-muted)] lg:block">
              Et aussi : photolangage, langue étrangère, culture générale, mémos et notes
              personnelles, forum de ton parcours.
            </p>
          </Appear>

          {/* Écran du téléphone */}
          <Appear variant="scale" delay={220} className="mx-auto">
            <div className="relative h-[530px] w-[288px] rounded-[48px] bg-[#0B1020] p-[10px] shadow-[0_50px_100px_-40px_rgba(0,11,54,0.65)] ring-1 ring-black/5 dark:ring-white/12">
              <div
                id="ecran-fonctionnalite"
                role="tabpanel"
                aria-labelledby={`onglet-${feature.key}`}
                className="relative h-full overflow-hidden rounded-[38px] bg-[#F6F7FB]"
              >
                <div className="flex items-center justify-between px-6 pb-2 pt-3 text-[11px] font-semibold" style={{ color: INK }}>
                  <span>9:41</span>
                  <span className="h-[22px] w-[84px] rounded-full bg-[#0B1020]" aria-hidden="true" />
                  <span className="w-6" />
                </div>
                <div key={feature.key} className="cq-screen-in" aria-hidden="true">
                  {feature.screen()}
                </div>
                <span className="sr-only">{`Exemple d’écran : ${feature.title}`}</span>
              </div>
            </div>
            <p className="mt-8 max-w-[22rem] text-center text-[14.5px] leading-relaxed text-[var(--on-surface-muted)] lg:hidden">
              Et aussi : photolangage, langue étrangère, culture générale, mémos et notes
              personnelles, forum de ton parcours.
            </p>
          </Appear>
        </div>
      </div>
    </section>
  )
}
