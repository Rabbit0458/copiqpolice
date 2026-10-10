"use client"

import Link from "next/link"
import { useSearchParams } from "next/navigation"
import { useEffect, useMemo, useState, type CSSProperties } from "react"
import { ArrowLeft, ArrowRight, BookOpen, Crown, Gauge, Layers, Lock, Play, Shuffle, Smartphone, X, Zap } from "lucide-react"
import type { SupabaseClient } from "@supabase/supabase-js"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { usePathway } from "@/features/pathway/pathway-provider"
import { useEntitlement } from "@/features/access/entitlement"
import type { PathwayDefinition } from "@/config/pathways"
import { CourseReader } from "@/features/parcours/course-reader"
import { HeroAction, ModuleCard, PageHero, SectionTitle, TocRow, hasRichImages } from "@/features/parcours/ui"
import { SessionPlayer } from "@/features/home/session-player"
import type { Difficulty, SessionPlan } from "@/features/home/session"
import {
  findCard,
  findLeaf,
  leafHref,
  saveLastOpened,
  countKinds,
  flatLeaves,
  type CgLeaf,
  type DeckCard,
  type GroupLeaf,
  type Leaf,
  type QuizLeaf,
} from "@/features/parcours/tree"

/* ─── Page catégorie (_CategoryDetailPage de l'app) ──────────────────────── */

export function CategoryView() {
  const params = useSearchParams()
  const { pathway } = usePathway()
  const ent = useEntitlement()
  if (!pathway) return null
  const { program, card } = findCard(pathway.id, params.get("p"), params.get("c"))
  if (!program || !card) return <NotFound />
  if (pathway.mode === "school" && ent.loaded && !ent.premium) return <PremiumWall pathway={pathway} />

  const { courses, quizzes } = countKinds(card.leaves)
  const rich = hasRichImages(card.leaves)
  const first = card.leaves.find((l) => l.kind !== "app") ?? card.leaves[0]
  const chips = [
    { icon: Layers, label: `${card.leaves.length} module${card.leaves.length > 1 ? "s" : ""}` },
    ...(courses ? [{ icon: BookOpen, label: `${courses} cours` }] : []),
    ...(quizzes ? [{ icon: Zap, label: `${quizzes} quiz` }] : []),
  ]

  return (
    <div className="pb-16">
      <PageHero
        image={card.image}
        back={{ href: "/dashboard", label: "Accueil" }}
        eyebrow={program.key === "concours" ? pathway.label : program.label}
        title={card.label}
        subtitle={card.badge}
        chips={chips}
        action={first ? <HeroAction href={leafHref(program.key, card.id, first.id)}>Commencer</HeroAction> : undefined}
      />
      {pathway.mode === "exam" && ent.loaded && !ent.premium && <QuotaBanner remaining={ent.freeRemaining} limit={ent.freeLimit} />}

      <SectionTitle title="Modules" aside={`${card.leaves.length} au total`} className="mb-4 mt-9" />
      {rich ? (
        <ol className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {card.leaves.map((leaf, i) => (
            <li key={leaf.id} className="cq-stagger-item" style={{ "--i": Math.min(i, 14) } as CSSProperties}>
              <ModuleCard href={leafHref(program.key, card.id, leaf.id)} leaf={leaf} index={i + 1} />
            </li>
          ))}
        </ol>
      ) : (
        <ol className="cq-card grid gap-1 p-2 md:grid-cols-2">
          {card.leaves.map((leaf, i) => (
            <li key={leaf.id} className="cq-stagger-item" style={{ "--i": Math.min(i, 14) } as CSSProperties}>
              <TocRow href={leafHref(program.key, card.id, leaf.id)} leaf={leaf} index={i + 1} />
            </li>
          ))}
        </ol>
      )}
    </div>
  )
}

function QuotaBanner({ remaining, limit }: { remaining: number; limit: number }) {
  return (
    <div className="cq-card mt-4 flex flex-wrap items-center justify-between gap-3 rounded-[18px] px-4 py-3">
      <p className="flex items-center gap-2 text-[14px] font-semibold text-[var(--on-surface)]">
        <Gauge className="h-4 w-4 text-[#3977F6]" aria-hidden="true" />
        <span>
          <strong>
            {remaining}/{limit}
          </strong>{" "}
          quiz gratuits restants cette semaine
        </span>
      </p>
      <Link href="/abonnement" className="inline-flex items-center gap-1.5 text-[13.5px] font-semibold text-[#B45309] hover:underline dark:text-[#FBBF24]">
        <Crown className="h-4 w-4" aria-hidden="true" /> Illimité avec Premium
      </Link>
    </div>
  )
}

/* ─── Page module (feuille) ───────────────────────────────────────────────── */

export function ModuleView() {
  const params = useSearchParams()
  const { pathway } = usePathway()
  const ent = useEntitlement()
  const p = params.get("p")
  const c = params.get("c")
  const l = params.get("l")
  const found = pathway ? findLeaf(pathway.id, p, c, l) : null

  useEffect(() => {
    if (pathway && found?.leaf && found.program && found.card) {
      saveLastOpened({ pathwayId: pathway.id, programKey: found.program.key, cardId: found.card.id, leafId: found.leaf.id, label: found.leaf.label, at: Date.now() })
    }
  }, [pathway, found?.leaf, found?.program, found?.card])

  if (!pathway || !found) return null
  const { program, card, leaf, parents } = found
  if (!program || !card || !leaf) return <NotFound />
  if (pathway.mode === "school" && ent.loaded && !ent.premium) return <PremiumWall pathway={pathway} />
  const parent = parents[parents.length - 1] ?? null
  const backHref = parent
    ? leafHref(program.key, card.id, parent.id)
    : card.leaves.length === 1
      ? "/dashboard"
      : `/parcours/categorie/?p=${encodeURIComponent(program.key)}&c=${encodeURIComponent(card.id)}`
  const backLabel = parent ? parent.label : card.leaves.length === 1 ? "Accueil" : card.label
  const siblings = parent ? parent.children : card.leaves

  if (leaf.kind === "group") return <GroupView key={leaf.id} pathway={pathway} program={program} card={card} leaf={leaf} backHref={backHref} backLabel={backLabel} />
  if (leaf.kind === "course") {
    const quiz = siblings.find((x) => x.kind === "quiz" || x.kind === "cg") ?? flatLeaves(card.leaves).find((x) => x.kind === "quiz" || x.kind === "cg")
    return <CourseReader key={leaf.id} leaf={leaf} cardLabel={backLabel} backHref={backHref} quizHref={quiz ? leafHref(program.key, card.id, quiz.id) : null} />
  }
  if (leaf.kind === "quiz" || leaf.kind === "cg") return <QuizIntro key={leaf.id} pathway={pathway} card={card} leaf={leaf} backHref={backHref} backLabel={backLabel} />
  return <AppOnly leaf={leaf} card={card} backHref={backHref} />
}

/* ─── Sommaire d'un cours (page « cartes » de l'app : sous-cours + quiz) ─── */

function GroupView({
  pathway,
  program,
  card,
  leaf,
  backHref,
  backLabel,
}: {
  pathway: PathwayDefinition
  program: { key: string; label: string }
  card: DeckCard
  leaf: GroupLeaf
  backHref: string
  backLabel: string
}) {
  const { courses, quizzes } = countKinds(leaf.children)
  const first = leaf.children.find((l) => l.kind !== "app") ?? leaf.children[0]
  const rich = hasRichImages(leaf.children)
  const chips = [
    ...(courses ? [{ icon: BookOpen, label: `${courses} cours` }] : []),
    ...(quizzes ? [{ icon: Zap, label: `${quizzes} quiz` }] : []),
  ]
  return (
    <div className="pb-16">
      <PageHero
        image={leaf.image ?? card.image}
        back={{ href: backHref, label: backLabel }}
        eyebrow={program.key === "concours" ? card.label : `${program.label} · ${card.label}`}
        title={leaf.label}
        subtitle={leaf.subtitle}
        chips={chips}
        action={first ? <HeroAction href={leafHref(program.key, card.id, first.id)}>Commencer</HeroAction> : undefined}
      />
      <SectionTitle title="Au sommaire" aside={`${leaf.children.length} élément${leaf.children.length > 1 ? "s" : ""}`} className="mb-4 mt-9" />
      {rich ? (
        <ol className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {leaf.children.map((child, i) => (
            <li key={child.id} className="cq-stagger-item" style={{ "--i": Math.min(i, 14) } as CSSProperties}>
              <ModuleCard href={leafHref(program.key, card.id, child.id)} leaf={child} index={i + 1} />
            </li>
          ))}
        </ol>
      ) : (
        <ol className="cq-card grid gap-1 p-2 md:grid-cols-2">
          {leaf.children.map((child, i) => (
            <li key={child.id} className="cq-stagger-item" style={{ "--i": Math.min(i, 14) } as CSSProperties}>
              <TocRow href={leafHref(program.key, card.id, child.id)} leaf={child} index={i + 1} />
            </li>
          ))}
        </ol>
      )}
      <p className="sr-only">{pathway.label}</p>
    </div>
  )
}

/* ─── Intro de quiz : niveau + nombre de questions (comme l'app) ──────────── */

const LEVELS: { value: Difficulty | null; label: string; hint: string; color: string }[] = [
  { value: "Facile", label: "Facile", hint: "Pour s’échauffer", color: "#16A34A" },
  { value: "Moyenne", label: "Moyen", hint: "Le niveau du concours", color: "#F59E0B" },
  { value: "Difficile", label: "Difficile", hint: "Pour viser haut", color: "#DC2626" },
  { value: null, label: "Mélanger", hint: "Les 3 niveaux", color: "#6C63FF" },
]
const SIZES = [
  { n: 10, label: "Session rapide", hint: "≈ 5 min" },
  { n: 20, label: "Session standard", hint: "≈ 10 min" },
  { n: 50, label: "Session intensive", hint: "≈ 25 min" },
]

function QuizIntro({ pathway, card, leaf, backHref, backLabel }: { pathway: PathwayDefinition; card: DeckCard; leaf: QuizLeaf | CgLeaf; backHref: string; backLabel: string }) {
  // Tables hors du typage généré : client non typé.
  const supabase = useMemo(() => createClient() as unknown as SupabaseClient, [])
  const ent = useEntitlement()
  const [level, setLevel] = useState<Difficulty | null>(null)
  const [size, setSize] = useState(() => {
    try {
      const v = Number(window.localStorage.getItem("cq-quiz-size"))
      return [10, 20, 50].includes(v) ? v : 20
    } catch {
      return 20
    }
  })
  const [counts, setCounts] = useState<Record<string, number> | null>(null)
  const [plan, setPlan] = useState<SessionPlan | null>(null)
  const [run, setRun] = useState(0)
  const [wall, setWall] = useState<{ resetsAt: string | null } | null>(null)
  const [starting, setStarting] = useState(false)

  useEffect(() => {
    let alive = true
    const count = async (d: Difficulty | null) => {
      let q =
        leaf.kind === "cg"
          ? supabase.from("quiz_questions").select("id", { count: "exact", head: true }).eq("category", leaf.category)
          : supabase.from("quiz_scolarite_questions").select("id", { count: "exact", head: true }).eq("module", leaf.module).eq("is_active", true).eq("publication_status", "published")
      if (d) q = q.eq("difficulty", d)
      const { count: c } = await q
      return c ?? 0
    }
    Promise.all([count(null), count("Facile"), count("Moyenne"), count("Difficile")])
      .then(([all, f, m, d]) => alive && setCounts({ all, Facile: f, Moyenne: m, Difficile: d }))
      .catch(() => alive && setCounts(null))
    return () => {
      alive = false
    }
  }, [supabase, leaf])

  const available = counts ? (level ? counts[level] : counts.all) : null

  const start = async () => {
    if (starting) return
    setStarting(true)
    try {
      // Concours : chaque lancement consomme un crédit gratuit (Premium : illimité).
      if (pathway.mode === "exam" && !ent.premium) {
        const r = await ent.consumeFreeRequest()
        if (!r.allowed) {
          setWall({ resetsAt: r.resetsAt })
          return
        }
      }
      try {
        window.localStorage.setItem("cq-quiz-size", String(size))
      } catch {
        /* rien */
      }
      const n = available ? Math.min(size, available) : size
      setPlan({
        kind: leaf.kind === "cg" ? "exam" : "school",
        count: Math.max(1, n),
        difficulty: level,
        theme: {
          key: leaf.kind === "cg" ? leaf.category : leaf.module,
          label: leaf.label,
          categories: leaf.kind === "cg" ? [leaf.category] : [],
          quizSuffix: leaf.label,
          hint: card.label,
          module: leaf.kind === "quiz" ? leaf.module : undefined,
          group: card.label,
          names:
            leaf.kind === "cg"
              ? { moduleName: leaf.moduleName, quizName: leaf.quizName, quizKey: leaf.quizKey }
              : { moduleName: leaf.moduleName, quizName: leaf.quizName, quizKey: leaf.module },
        },
      })
      setRun((r) => r + 1)
    } finally {
      setStarting(false)
    }
  }

  const chosen = LEVELS.find((x) => x.value === level) ?? LEVELS[3]
  const minutes = Math.max(2, Math.round((available ? Math.min(size, available) : size) * 0.5))
  return (
    <div className="pb-16">
      <PageHero
        image={leaf.image ?? card.image}
        back={{ href: backHref, label: backLabel }}
        eyebrow={`Quiz · ${pathway.shortLabel}`}
        title={leaf.label}
        subtitle={counts ? `${counts.all.toLocaleString("fr-FR")} questions, tirées au hasard à chaque partie.` : "Chargement des questions…"}
        chips={[{ icon: Zap, label: "Corrigé et expliqué" }, { icon: Layers, label: "3 niveaux" }]}
      />

      <div className="mt-6 grid items-start gap-5 lg:grid-cols-[minmax(0,1fr)_340px]">
        <div className="cq-card p-5 sm:p-7">
          <h2 className="text-[17px] font-black tracking-[-0.01em] text-[var(--on-surface)]">Niveau</h2>
          <p className="mt-0.5 text-[13.5px] text-[var(--on-surface-muted)]">Les mêmes niveaux que dans l’application.</p>
          <div className="mt-4 grid grid-cols-2 gap-2.5 sm:grid-cols-4" role="radiogroup" aria-label="Niveau">
            {LEVELS.map((lv) => {
              const on = level === lv.value
              const n = counts ? (lv.value ? counts[lv.value] : counts.all) : null
              return (
                <button
                  key={lv.label}
                  type="button"
                  role="radio"
                  aria-checked={on}
                  disabled={n === 0}
                  onClick={() => setLevel(lv.value)}
                  className={cn("cq-level relative overflow-hidden rounded-[16px] border-2 px-3.5 py-3 text-left transition-all duration-300 disabled:opacity-40", on ? "is-on" : "border-[var(--outline-variant)] bg-[var(--surface-container)] hover:border-[var(--outline)]")}
                  style={{ "--lv": lv.color, borderColor: on ? lv.color : undefined } as CSSProperties}
                >
                  <span className="flex items-center gap-2">
                    {lv.value ? <span className="h-2.5 w-2.5 rounded-full" style={{ background: lv.color }} /> : <Shuffle className="h-3.5 w-3.5" style={{ color: lv.color }} aria-hidden="true" />}
                    <span className="text-[15px] font-bold text-[var(--on-surface)]">{lv.label}</span>
                  </span>
                  <span className="mt-1 block text-[12.5px] tabular-nums text-[var(--on-surface-muted)]">{n !== null ? `${n.toLocaleString("fr-FR")} questions` : lv.hint}</span>
                </button>
              )
            })}
          </div>

          <h2 className="mt-8 text-[17px] font-black tracking-[-0.01em] text-[var(--on-surface)]">Nombre de questions</h2>
          <div className="mt-4 grid grid-cols-3 gap-2.5" role="radiogroup" aria-label="Nombre de questions">
            {SIZES.map((sz) => {
              const on = size === sz.n
              return (
                <button
                  key={sz.n}
                  type="button"
                  role="radio"
                  aria-checked={on}
                  onClick={() => setSize(sz.n)}
                  className={cn(
                    "rounded-[16px] border-2 px-3.5 py-3 text-left transition-all duration-300",
                    on ? "border-[var(--cq-ink)] bg-[var(--cq-ink)] text-[var(--cq-on-ink)] shadow-[0_14px_26px_-16px_rgba(0,0,0,.7)]" : "border-[var(--outline-variant)] bg-[var(--surface-container)] text-[var(--on-surface)] hover:border-[var(--outline)]",
                  )}
                >
                  <span className="block text-[22px] font-black leading-none">{sz.n}</span>
                  <span className={cn("mt-1.5 block text-[12.5px]", on ? "opacity-70" : "text-[var(--on-surface-muted)]")}>{sz.label}</span>
                </button>
              )
            })}
          </div>
        </div>

        <aside className="cq-card p-5 sm:p-6 lg:sticky lg:top-24">
          <p className="text-[12px] font-bold uppercase tracking-[0.08em] text-[var(--on-surface-faint)]">Ta session</p>
          <dl className="mt-3 grid gap-2.5 text-[14px]">
            <div className="flex items-center justify-between gap-3">
              <dt className="text-[var(--on-surface-muted)]">Niveau</dt>
              <dd className="inline-flex items-center gap-1.5 font-bold text-[var(--on-surface)]">
                <span className="h-2 w-2 rounded-full" style={{ background: chosen.color }} /> {chosen.label}
              </dd>
            </div>
            <div className="flex items-center justify-between gap-3">
              <dt className="text-[var(--on-surface-muted)]">Questions</dt>
              <dd className="font-bold tabular-nums text-[var(--on-surface)]">{available ? Math.min(size, available) : size}</dd>
            </div>
            <div className="flex items-center justify-between gap-3">
              <dt className="text-[var(--on-surface-muted)]">Durée estimée</dt>
              <dd className="font-bold tabular-nums text-[var(--on-surface)]">≈ {minutes} min</dd>
            </div>
          </dl>
          <button
            type="button"
            onClick={() => void start()}
            disabled={starting || available === 0}
            className="cq-btn-ink mt-5 inline-flex h-[52px] w-full items-center justify-center gap-2.5 rounded-[16px] text-[15.5px] font-bold disabled:opacity-50"
          >
            <Play className="h-[18px] w-[18px] fill-current" aria-hidden="true" /> Commencer
          </button>
          {pathway.mode === "exam" && ent.loaded && !ent.premium && (
            <p className="mt-3 flex items-center justify-center gap-1.5 text-center text-[12.5px] font-semibold text-[var(--on-surface-muted)]">
              <Gauge className="h-3.5 w-3.5" aria-hidden="true" /> {ent.freeRemaining}/{ent.freeLimit} quiz gratuits cette semaine
            </p>
          )}
          <p className="mt-3 border-t border-[var(--outline-variant)] pt-3 text-center text-[12.5px] leading-relaxed text-[var(--on-surface-faint)]">
            Tes réponses sont enregistrées sur ton compte et visibles dans l’application.
          </p>
        </aside>
      </div>

      {wall && <QuotaWall resetsAt={wall.resetsAt} onClose={() => setWall(null)} />}
      {plan && (
        <SessionPlayer
          key={run}
          plan={plan}
          pathway={pathway}
          onClose={() => setPlan(null)}
          onFinished={() => void ent.refresh()}
          onReplay={() => {
            setPlan(null)
            void start()
          }}
        />
      )}
    </div>
  )
}

function QuotaWall({ resetsAt, onClose }: { resetsAt: string | null; onClose: () => void }) {
  const when = resetsAt ? new Date(resetsAt).toLocaleDateString("fr-FR", { weekday: "long", day: "numeric", month: "long" }) : null
  return (
    <div className="fixed inset-0 z-[120] grid place-items-center bg-[#000B36]/50 p-4 backdrop-blur-sm" onClick={onClose}>
      <div role="alertdialog" aria-modal="true" aria-labelledby="quota-title" onClick={(e) => e.stopPropagation()} className="cq-pop-in w-full max-w-md rounded-[26px] border border-[var(--outline)] bg-[var(--surface)] p-7 shadow-[0_40px_100px_-40px_rgba(0,11,54,.8)]">
        <button type="button" onClick={onClose} aria-label="Fermer" className="float-right grid h-9 w-9 place-items-center rounded-full text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]">
          <X className="h-5 w-5" aria-hidden="true" />
        </button>
        <span className="grid h-12 w-12 place-items-center rounded-2xl bg-[#F59E0B]/15 text-[#D97706]">
          <Lock className="h-6 w-6" aria-hidden="true" />
        </span>
        <h2 id="quota-title" className="mt-4 text-[20px] font-bold text-[var(--on-surface)]">
          Limite atteinte
        </h2>
        <p className="mt-2 text-[15px] leading-relaxed text-[var(--on-surface-muted)]">
          Tu as utilisé tes 10 quiz gratuits de la semaine{when ? `. Ils reviennent ${when}` : ""}. Passe Premium pour t’entraîner sans limite, sur le site et dans l’application.
        </p>
        <div className="mt-6 grid gap-2 sm:grid-cols-2">
          <button type="button" onClick={onClose} className="h-12 rounded-2xl text-[14.5px] font-bold text-[var(--on-surface)] ring-1 ring-[var(--outline)]">
            Plus tard
          </button>
          <Link href="/abonnement" className="inline-flex h-12 items-center justify-center gap-2 rounded-2xl bg-[#1C1C1C] text-[14.5px] font-semibold text-white dark:bg-white dark:text-[#1C1C1C]">
            <Crown className="h-4 w-4 text-[#FBBF24]" aria-hidden="true" /> Voir Premium
          </Link>
        </div>
      </div>
    </div>
  )
}

/* ─── Contenu encore réservé à l'app ──────────────────────────────────────── */

function AppOnly({ leaf, card, backHref }: { leaf: Leaf & { kind: "app" }; card: DeckCard; backHref: string }) {
  return (
    <div className="pb-16">
      <PageHero
        image={leaf.image ?? card.image}
        back={{ href: backHref, label: backHref === "/dashboard" ? "Accueil" : card.label }}
        eyebrow={card.label}
        title={leaf.label}
        chips={[{ icon: Smartphone, label: "Disponible dans l’application" }]}
      />
      <div className="cq-card mt-6 flex flex-col gap-5 p-6 sm:flex-row sm:items-center sm:p-7">
        <span className="grid h-14 w-14 shrink-0 place-items-center rounded-[18px] bg-[var(--cq-accent)]/10 text-[var(--cq-accent)]">
          <Smartphone className="h-6 w-6" aria-hidden="true" />
        </span>
        <div className="min-w-0 flex-1">
          <p className="text-[16px] font-bold leading-snug text-[var(--on-surface)]">{leaf.reason}</p>
          <p className="mt-1 text-[14px] leading-relaxed text-[var(--on-surface-muted)]">Tes résultats dans l’application apparaissent déjà dans ta progression sur le site.</p>
        </div>
        <div className="flex shrink-0 flex-wrap gap-2.5">
          <Link href={backHref} className="cq-btn-ghost inline-flex h-11 items-center rounded-[14px] px-4 text-[14px] font-bold">
            Autres modules
          </Link>
          <Link href="/progression" className="cq-btn-ink inline-flex h-11 items-center gap-2 rounded-[14px] px-4 text-[14px] font-bold">
            Ma progression <ArrowRight className="h-4 w-4" aria-hidden="true" />
          </Link>
        </div>
      </div>
    </div>
  )
}

/* ─── Divers ──────────────────────────────────────────────────────────────── */

function PremiumWall({ pathway }: { pathway: PathwayDefinition }) {
  return (
    <div className="cq-card mx-auto mt-4 max-w-xl px-6 py-10 text-center sm:px-10">
      <span className="mx-auto grid h-14 w-14 place-items-center rounded-2xl bg-[#F59E0B]/15 text-[#D97706]">
        <Crown className="h-7 w-7" aria-hidden="true" />
      </span>
      <h1 className="mt-5 text-[26px] font-bold tracking-[-0.02em] text-[var(--on-surface)]">Contenu réservé aux abonnés Premium</h1>
      <p className="mt-2 text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]">La {pathway.label.toLowerCase()} est incluse dans Premium, sur le site comme dans l’application.</p>
      <div className="mt-7 flex flex-wrap justify-center gap-3">
        <Link href="/abonnement" className="inline-flex h-12 items-center gap-2 rounded-2xl cq-btn-ink px-5 text-[14.5px] font-bold">
          <Crown className="h-4 w-4 text-[#FBBF24]" aria-hidden="true" /> Voir les formules
        </Link>
        <Link href="/choisir-parcours" className="inline-flex h-12 items-center rounded-2xl px-5 text-[14.5px] font-bold text-[var(--on-surface)] ring-1 ring-[var(--outline)]">
          Changer de parcours
        </Link>
      </div>
    </div>
  )
}

function NotFound() {
  return (
    <div className="cq-card mx-auto mt-4 max-w-xl px-6 py-12 text-center">
      <h1 className="text-[24px] font-bold text-[var(--on-surface)]">Contenu introuvable</h1>
      <p className="mt-2 text-[15px] text-[var(--on-surface-muted)]">Ce contenu n’appartient pas à ton parcours actuel.</p>
      <Link href="/dashboard" className="mt-6 inline-flex h-12 items-center gap-2 rounded-2xl cq-btn-ink px-5 text-[14.5px] font-bold">
        <ArrowLeft className="h-4 w-4" aria-hidden="true" /> Retour à l’accueil
      </Link>
    </div>
  )
}
