"use client"

import Link from "next/link"
import { useRouter } from "next/navigation"
import { useEffect, useMemo, useRef, useState, type CSSProperties } from "react"
import { ArrowRight, Check, CornerDownLeft, Crown, Flame, GraduationCap, Lock, Play, Rocket, Search, Target, Trophy, X } from "lucide-react"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { usePathway } from "@/features/pathway/pathway-provider"
import { useEntitlement } from "@/features/access/entitlement"
import type { PathwayDefinition } from "@/config/pathways"
import { HeroDeck } from "@/features/parcours/hero-deck"
import {
  cardHref,
  countKinds,
  findProgram,
  flatLeaves,
  imgUrl,
  leafHref,
  programsFor,
  readLastOpened,
  readProgram,
  saveProgram,
  searchTree,
  type DeckCard,
  type Leaf,
  type Program,
} from "@/features/parcours/tree"
import { loadHomeSnapshot, type HomeSnapshot } from "@/features/home/progress"
import { Counter } from "@/components/home/counter"
import { SectionTitle, TocRow } from "@/features/parcours/ui"

/**
 * Accueil d'un parcours — portage web des 4 Home de l'application
 * (home_page_pa_exam / gpx_exam / pa_school / gpx_school).
 *
 * Même ordre que l'app : salutation, recherche, titre du parcours,
 * « Sélection de contenu » avec le deck de cartes glissantes, puis le bloc
 * propre à chaque parcours (Continue ta préparation / Ta prochaine étape).
 * Ajout ordinateur : toutes les catégories visibles d'un coup d'œil.
 */

const TITLES: Record<string, string> = {
  pa_exam: "Examen — Policier adjoint",
  gpx_exam: "Examen — Gardien de la paix",
  pa_school: "Scolarité — Policier adjoint",
  gpx_school: "Scolarité — Gardien de la paix",
}

const DAILY_GOAL = 3

export function PathwayHome() {
  const { pathway, profile } = usePathway()
  const ent = useEntitlement()
  if (!pathway) return null
  const firstName = profile?.first_name?.trim() || profile?.username || ""
  if (pathway.mode === "school" && ent.loaded && !ent.premium) return <SchoolLocked pathway={pathway} firstName={firstName} />
  return <HomeBody key={pathway.id} pathway={pathway} firstName={firstName} />
}

function HomeBody({ pathway, firstName }: { pathway: PathwayDefinition; firstName: string }) {
  const supabase = useMemo(() => createClient(), [])
  const programs = programsFor(pathway.id)
  const [programKey, setProgramKey] = useState<string>(programs[0]?.key ?? "concours")
  const [snap, setSnap] = useState<HomeSnapshot | null>(null)
  const [last, setLast] = useState<ReturnType<typeof readLastOpened>>(null)
  const [activeIndex, setActiveIndex] = useState(0)
  const program = findProgram(pathway.id, programKey) as Program

  useEffect(() => {
    // Programme et dernier module mémorisés sur l'appareil (comme l'app).
    const saved = readProgram(pathway.id)
    // eslint-disable-next-line react-hooks/set-state-in-effect
    if (saved && programs.some((p) => p.key === saved)) setProgramKey(saved)
    setLast(readLastOpened(pathway.id))
  }, [pathway.id, programs])

  useEffect(() => {
    let alive = true
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) return
      loadHomeSnapshot(supabase, data.user.id, pathway)
        .then((s) => alive && setSnap(s))
        .catch(() => undefined)
    })
    return () => {
      alive = false
    }
  }, [supabase, pathway])

  const initialIndex = Math.max(
    0,
    program.cards.findIndex((c) => (pathway.id === "gpx_exam" ? /structure/i.test(c.label) : /cadres juridiques/i.test(c.label))),
  )
  const activeCard = program.cards[Math.min(activeIndex, program.cards.length - 1)] ?? program.cards[0]

  return (
    <div className="cq-pathway-home pb-14">
      {/* Salutation + recherche (en-tête de l'app) */}
      <header className="cq-ph-in flex flex-col gap-4 md:flex-row md:items-center md:justify-between" style={{ "--d": "0ms" } as CSSProperties}>
        <div className="min-w-0">
          <h1 className="truncate text-[28px] font-black tracking-[-0.03em] text-[var(--on-surface)] sm:text-[30px]">
            Bonjour{firstName ? ` ${firstName}` : ""} <span className="cq-wave inline-block" aria-hidden="true">👋</span>
          </h1>
          <p className="mt-0.5 text-[14.5px] font-semibold text-[var(--on-surface-faint)]">Bienvenue sur COP’IQ</p>
        </div>
        <div className="flex w-full items-center gap-2.5 md:w-auto">
          <div className="min-w-0 flex-1 md:w-[22rem] md:flex-none">
            <TreeSearch pathway={pathway} />
          </div>
          <Link
            href="/choisir-parcours"
            aria-label="Changer de parcours"
            title="Changer de parcours"
            className="grid h-12 w-12 shrink-0 place-items-center rounded-full bg-[var(--surface)] text-[var(--on-surface)] shadow-[var(--cq-shadow)] ring-1 ring-[var(--outline-variant)] transition hover:-translate-y-0.5"
          >
            <GraduationCap className="h-5 w-5" aria-hidden="true" />
          </Link>
        </div>
      </header>

      <div className="cq-ph-in mt-9" style={{ "--d": "100ms" } as CSSProperties}>
        <h2 className="text-[22px] font-black tracking-[-0.02em] text-[var(--on-surface)]">{TITLES[pathway.id]}</h2>
        <p className="mt-0.5 text-[15px] font-bold text-[var(--on-surface-muted)]">Sélection de contenu</p>
        {programs.length > 1 && (
          <ProgramTabs
            programs={programs}
            value={program.key}
            onChange={(k) => {
              setProgramKey(k)
              setActiveIndex(0)
              saveProgram(pathway.id, k)
            }}
          />
        )}
      </div>

      <div className="cq-ph-in mt-5 grid gap-6 lg:grid-cols-[minmax(0,1fr)_330px] xl:grid-cols-[minmax(0,1fr)_360px]" style={{ "--d": "180ms" } as CSSProperties}>
        <div className="min-w-0">
          <HeroDeck
            key={program.key}
            cards={program.cards}
            initialIndex={initialIndex}
            storageKey={`cq-deck:${pathway.id}:${program.key}`}
            hrefFor={(c) => cardHref(program.key, c)}
            resumeId={last && last.programKey === program.key ? last.cardId : null}
            onIndexChange={setActiveIndex}
          />
        </div>
        {activeCard && <CardPanel key={`${program.key}:${activeCard.id}`} program={program} card={activeCard} />}
      </div>

      <div className="cq-ph-in mt-10 grid gap-5 lg:grid-cols-2" style={{ "--d": "260ms" } as CSSProperties}>
        <section>
          <SectionTitle title="Ta prochaine étape" aside={<Link href="/progression" className="hover:text-[var(--on-surface)]">Mon suivi</Link>} className="mb-3" />
          {pathway.mode === "exam" ? <ExamNext pathway={pathway} program={program} snap={snap} last={last} /> : <SchoolNext pathway={pathway} program={program} />}
        </section>
        <section>
          <SectionTitle title="Ma régularité" aside="Aujourd’hui" className="mb-3" />
          <Momentum snap={snap} />
        </section>
      </div>
    </div>
  )
}

/* ─── Panneau de la carte active (ordinateur) ─────────────────────────────── */

function CardPanel({ program, card }: { program: Program; card: DeckCard }) {
  const { courses, quizzes } = countKinds(card.leaves)
  const shown = card.leaves.slice(0, 5)
  const more = card.leaves.length - shown.length
  const meta = [
    `${card.leaves.length} module${card.leaves.length > 1 ? "s" : ""}`,
    courses ? `${courses} cours` : null,
    quizzes ? `${quizzes} quiz` : null,
  ].filter(Boolean)
  return (
    <aside className="cq-card cq-panel-in hidden min-h-0 flex-col p-5 lg:flex" aria-label={`Contenu : ${card.label}`}>
      <div>
        <p className="truncate text-[12.5px] font-bold uppercase tracking-[0.08em] text-[var(--on-surface-faint)]">{card.badge}</p>
        <h3 className="mt-1.5 line-clamp-2 text-[21px] font-black leading-[1.1] tracking-[-0.02em] text-[var(--on-surface)]">{card.label}</h3>
        <p className="mt-1.5 text-[13.5px] font-semibold text-[var(--on-surface-muted)]">{meta.join(" · ")}</p>
      </div>
      <div className="mt-4 border-t border-[var(--outline-variant)] pt-3">
        <p className="px-2.5 text-[12px] font-bold uppercase tracking-[0.08em] text-[var(--on-surface-faint)]">Au programme</p>
        <ul className="mt-1.5 grid gap-0.5">
          {shown.map((leaf, i) => (
            <li key={leaf.id}>
              <TocRow href={leafHref(program.key, card.id, leaf.id)} leaf={leaf} index={i + 1} compact={card.leaves.length > 3} />
            </li>
          ))}
        </ul>
        {more > 0 && <p className="mt-1 px-2.5 text-[13px] font-semibold text-[var(--on-surface-faint)]">+ {more} autre{more > 1 ? "s" : ""} module{more > 1 ? "s" : ""}</p>}
      </div>
      <Link href={cardHref(program.key, card)} className="cq-btn-ink group mt-auto inline-flex h-12 items-center justify-between rounded-[16px] pl-4 pr-2 text-[14.5px] font-bold">
        {card.leaves.length > 1 ? `Voir les ${card.leaves.length} modules` : "Ouvrir"}
        <span className="grid h-8 w-8 place-items-center rounded-full bg-[var(--cq-on-ink)] text-[var(--cq-ink)] transition-transform duration-500 group-hover:translate-x-0.5">
          <ArrowRight className="h-4 w-4" aria-hidden="true" />
        </span>
      </Link>
    </aside>
  )
}

/* ─── Recherche (comme l'app : sans accents, ouverture directe) ──────────── */

function TreeSearch({ pathway }: { pathway: PathwayDefinition }) {
  const router = useRouter()
  const [q, setQ] = useState("")
  const [focus, setFocus] = useState(false)
  const [sel, setSel] = useState(0)
  const results = useMemo(() => searchTree(pathway.id, q), [pathway.id, q])
  const boxRef = useRef<HTMLDivElement | null>(null)
  const go = (i: number) => {
    const r = results[i]
    if (!r) return
    router.push(r.leaf ? leafHref(r.program.key, r.card.id, r.leaf.id) : cardHref(r.program.key, r.card))
  }

  useEffect(() => {
    const onDoc = (e: MouseEvent) => boxRef.current && !boxRef.current.contains(e.target as Node) && setFocus(false)
    document.addEventListener("mousedown", onDoc)
    return () => document.removeEventListener("mousedown", onDoc)
  }, [])

  const open = focus && q.trim().length >= 2
  return (
    <div ref={boxRef} className="relative">
      <label className="flex h-12 items-center gap-2.5 rounded-[16px] bg-[var(--surface)] px-4 shadow-[var(--cq-shadow)] ring-1 ring-[var(--outline-variant)] transition focus-within:ring-2 focus-within:ring-[var(--cq-accent)]/40">
        <Search className="h-5 w-5 shrink-0 text-[var(--on-surface-faint)]" aria-hidden="true" />
        <input
          value={q}
          onChange={(e) => {
            setQ(e.target.value)
            setSel(0)
          }}
          onFocus={() => setFocus(true)}
          onKeyDown={(e) => {
            if (!open) return
            if (e.key === "ArrowDown") {
              e.preventDefault()
              setSel((s) => Math.min(results.length - 1, s + 1))
            } else if (e.key === "ArrowUp") {
              e.preventDefault()
              setSel((s) => Math.max(0, s - 1))
            } else if (e.key === "Enter") {
              e.preventDefault()
              go(sel)
            } else if (e.key === "Escape") setFocus(false)
          }}
          placeholder={pathway.mode === "exam" ? "Rechercher (ex : cas, psy, géographie…)" : "Rechercher (ex : san, nat, arm…)"}
          aria-label="Rechercher un cours, un quiz"
          role="combobox"
          aria-expanded={open}
          aria-autocomplete="list"
          aria-controls="cq-tree-search-list"
          className="cq-search-input h-full min-w-0 flex-1 border-0 bg-transparent text-[15px] font-medium text-[var(--on-surface)] shadow-none outline-none ring-0 placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-0 focus-visible:outline-none"
        />
        {q && (
          <button type="button" onClick={() => setQ("")} aria-label="Effacer" className="grid h-8 w-8 place-items-center rounded-full text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]">
            <X className="h-[18px] w-[18px]" aria-hidden="true" />
          </button>
        )}
      </label>
      {open && (
        <div id="cq-tree-search-list" role="listbox" className="cq-pop-in absolute inset-x-0 top-[calc(100%+8px)] z-40 overflow-hidden rounded-[18px] border border-[var(--outline)] bg-[var(--surface)] p-1.5 shadow-[0_30px_70px_-30px_rgba(0,11,54,.6)]">
          {results.length === 0 ? (
            <p className="px-3 py-6 text-center text-[14.5px] text-[var(--on-surface-muted)]">Aucun résultat pour « {q} ».</p>
          ) : (
            results.map((r, i) => (
              <button
                key={`${r.program.key}-${r.card.id}-${r.leaf?.id ?? ""}`}
                type="button"
                role="option"
                aria-selected={i === sel}
                onMouseEnter={() => setSel(i)}
                onClick={() => go(i)}
                className={cn("flex w-full items-center gap-3 rounded-xl px-2.5 py-2 text-left transition-colors", i === sel && "bg-[var(--surface-container)]")}
              >
                <Thumb image={r.leaf?.image ?? r.card.image} className="h-11 w-11 rounded-xl" />
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-[14.5px] font-bold text-[var(--on-surface)]">{r.leaf?.label ?? r.card.label}</span>
                  <span className="block truncate text-[12.5px] text-[var(--on-surface-muted)]">
                    {r.leaf ? `${r.card.label}` : `${r.card.leaves.length} modules`}
                    {r.program.key !== "concours" ? ` · ${r.program.label}` : ""}
                  </span>
                </span>
                {i === sel && <CornerDownLeft className="h-4 w-4 text-[var(--on-surface-faint)]" aria-hidden="true" />}
              </button>
            ))
          )}
        </div>
      )}
    </div>
  )
}

/* ─── Programmes de scolarité (une ligne, comme les onglets de l'app) ────── */

function ProgramTabs({ programs, value, onChange }: { programs: Program[]; value: string; onChange: (k: string) => void }) {
  return (
    <div className="cq-program-tabs cq-fade-x -mx-1 mt-4 flex gap-2 overflow-x-auto px-1 pb-1 pr-10" role="tablist" aria-label="Programme">
      {programs.map((p) => {
        const on = p.key === value
        return (
          <button
            key={p.key}
            type="button"
            role="tab"
            aria-selected={on}
            onClick={() => onChange(p.key)}
            className={cn(
              "h-10 shrink-0 rounded-full px-4 text-[13.5px] font-bold transition-[background-color,color,box-shadow] duration-300",
              on ? "bg-[var(--cq-ink)] text-[var(--cq-on-ink)] shadow-[0_10px_20px_-12px_rgba(0,0,0,.6)]" : "bg-[var(--surface)] text-[var(--on-surface-muted)] shadow-[var(--cq-shadow)] hover:text-[var(--on-surface)]",
            )}
          >
            {p.label.replace(/^Mémento • /, "").replace("Policier en intervention — ", "Intervention · ")}
          </button>
        )
      })}
    </div>
  )
}

/* ─── Ta prochaine étape ──────────────────────────────────────────────────── */

function cardForSubject(program: Program, key: string): DeckCard | undefined {
  const find = (re: RegExp) => program.cards.find((c) => re.test(c.label))
  switch (key) {
    case "psychotechnique":
      return find(/psycho/i)
    case "langue_etrangere":
      return find(/langue/i)
    case "cas_pratique":
      return find(/cas pratique/i)
    case "photolangage":
      return find(/photolangage/i)
    default:
      return find(/culture|connaissances/i)
  }
}

/** Carte « prochaine étape » commune aux 4 parcours. */
function NextCard({
  href,
  image,
  icon: Icon,
  eyebrow,
  title,
  text,
  action,
  progress,
}: {
  href: string
  image: string | null
  icon: typeof Play
  eyebrow: string
  title: string
  text: string
  action: string
  progress?: number
}) {
  const src = imgUrl(image)
  return (
    <Link href={href} className="cq-card group flex h-full min-h-[184px] gap-4 p-4 transition-transform duration-500 hover:-translate-y-0.5 sm:gap-5">
      <span className="relative hidden w-[120px] shrink-0 overflow-hidden rounded-[18px] bg-[#1A1C21] sm:block">
        {src && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={src} alt="" loading="lazy" className="absolute inset-0 h-full w-full object-cover transition-transform duration-700 group-hover:scale-105" />
        )}
        <span className="absolute left-2.5 top-2.5 grid h-9 w-9 place-items-center rounded-full bg-white text-[var(--cq-accent)] shadow-md">
          <Icon className="h-[18px] w-[18px]" aria-hidden="true" />
        </span>
      </span>
      <span className="flex min-w-0 flex-1 flex-col py-1">
        <span className="text-[12.5px] font-bold text-[var(--cq-accent)]">{eyebrow}</span>
        <span className="mt-1 line-clamp-2 text-[18.5px] font-black leading-[1.15] tracking-[-0.015em] text-[var(--on-surface)]">{title}</span>
        <span className="mt-1.5 line-clamp-2 text-[13.5px] font-medium leading-relaxed text-[var(--on-surface-muted)]">{text}</span>
        {typeof progress === "number" && (
          <span className="mt-3 block h-1.5 overflow-hidden rounded-full bg-[var(--surface-container-hi)]">
            <span className="cq-grow-bar block h-full rounded-full bg-[var(--cq-accent)]" style={{ width: `${Math.max(3, progress)}%` }} />
          </span>
        )}
        <span className="mt-auto inline-flex items-center gap-2 pt-3 text-[14px] font-bold text-[var(--on-surface)]">
          {action}
          <span className="grid h-7 w-7 place-items-center rounded-full bg-[var(--cq-ink)] text-[var(--cq-on-ink)] transition-transform duration-500 group-hover:translate-x-1">
            <ArrowRight className="h-3.5 w-3.5" aria-hidden="true" />
          </span>
        </span>
      </span>
    </Link>
  )
}

function ExamNext({ pathway, program, snap, last }: { pathway: PathwayDefinition; program: Program; snap: HomeSnapshot | null; last: ReturnType<typeof readLastOpened> }) {
  if (!snap) return <div className="cq-skel h-[184px] rounded-[24px]" />
  const rec = snap.recommendation
  const recent = snap.recent[0]
  const base = cardForSubject(program, "culture_generale") ?? program.cards[0]
  let card = base
  let eyebrow = "Bien démarrer"
  let title = "Découvre ton niveau"
  let text = "Un quiz court pour commencer : tes résultats personnalisent ensuite tes recommandations, ici et dans l’application."
  let action = "Commencer"
  let href = cardHref(program.key, base)
  let progress: number | undefined
  let icon = Rocket

  if (pathway.id === "gpx_exam" && rec) {
    card = cardForSubject(program, rec.subject.key) ?? base
    eyebrow = "Priorité personnalisée"
    title = `Renforce ${rec.subject.label.toLowerCase()}`
    text = `${rec.subject.averagePercent} % de moyenne sur ${rec.subject.activities} activité${rec.subject.activities > 1 ? "s" : ""}. Une session ciblée peut faire la différence.`
    action = "M’entraîner"
    href = cardHref(program.key, card)
    progress = rec.subject.averagePercent
    icon = Target
  } else if (recent) {
    card = cardForSubject(program, recent.moduleKey) ?? base
    const p = recent.total > 0 ? Math.round((Math.min(recent.correct, recent.total) / recent.total) * 100) : 0
    eyebrow = pathway.id === "pa_exam" ? "Continue ta préparation" : "Continuer sur ta lancée"
    title = recent.title
    text = `Dernier résultat : ${p} %. Garde le rythme, une session suffit pour progresser.`
    action = "Continuer"
    href = last ? leafHref(last.programKey, last.cardId, last.leafId) : cardHref(program.key, card)
    progress = p
    icon = Play
  }
  return <NextCard href={href} image={card?.image ?? null} icon={icon} eyebrow={eyebrow} title={title} text={text} action={action} progress={progress} />
}

function SchoolNext({ pathway, program }: { pathway: PathwayDefinition; program: Program }) {
  const [pick, setPick] = useState<{ card: DeckCard; leaf: Leaf } | null>(null)
  useEffect(() => {
    const all = program.cards.flatMap((card) => flatLeaves(card.leaves).filter((l) => l.kind !== "app").map((leaf) => ({ card, leaf })))
    const key = `cq-next:${pathway.id}:${program.key}`
    let i = -1
    try {
      i = Number(window.sessionStorage.getItem(key) ?? -1)
    } catch {
      /* rien */
    }
    if (!(i >= 0 && i < all.length)) {
      i = Math.floor(Math.random() * all.length)
      try {
        window.sessionStorage.setItem(key, String(i))
      } catch {
        /* rien */
      }
    }
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setPick(all[i] ?? null)
  }, [pathway.id, program])

  if (!pick) return <div className="cq-skel h-[184px] rounded-[24px]" />
  return (
    <NextCard
      href={leafHref(program.key, pick.card.id, pick.leaf.id)}
      image={pick.leaf.image ?? pick.card.image}
      icon={pick.leaf.kind === "course" ? Play : Target}
      eyebrow={pick.card.label}
      title={pick.leaf.label}
      text={pick.leaf.kind === "course" ? "Un cours de ton programme, à lire en quelques minutes." : "Un quiz corrigé pour vérifier tes connaissances."}
      action="Commencer"
    />
  )
}

/* ─── Régularité : série, objectif du jour, réussite ─────────────────────── */

function Momentum({ snap }: { snap: HomeSnapshot | null }) {
  const done = snap ? Math.min(snap.doneToday, DAILY_GOAL) : 0
  const reached = done >= DAILY_GOAL
  const stats = [
    {
      icon: Flame,
      tint: "#F08A24",
      value: snap ? <Counter value={snap.streakDays} /> : "–",
      label: snap && snap.streakDays > 1 ? "jours de suite" : "jour de suite",
    },
    {
      icon: reached ? Check : Target,
      tint: reached ? "#16A34A" : "#2563EB",
      value: `${done}/${DAILY_GOAL}`,
      label: "objectif du jour",
      bar: (done / DAILY_GOAL) * 100,
    },
    {
      icon: Trophy,
      tint: "#7C5CFC",
      value: snap && snap.totalActivities > 0 ? `${snap.globalPercent} %` : "–",
      label: "de réussite",
    },
  ]
  return (
    <div className="cq-card grid h-full min-h-[184px] grid-cols-3 divide-x divide-[var(--outline-variant)] p-2">
      {stats.map(({ icon: Icon, tint, value, label, bar }) => (
        <div key={label} className="flex flex-col p-3 sm:p-4">
          <span className="grid h-10 w-10 place-items-center rounded-[13px]" style={{ background: `${tint}1A`, color: tint }}>
            <Icon className={cn("h-5 w-5", Icon === Flame && snap && snap.streakDays > 0 && "cq-flame")} aria-hidden="true" />
          </span>
          <p className="mt-auto pt-4 text-[26px] font-black leading-none tracking-[-0.02em] text-[var(--on-surface)]">{value}</p>
          <p className="mt-1.5 text-[13px] font-semibold text-[var(--on-surface-muted)]">{label}</p>
          {typeof bar === "number" && (
            <span className="mt-2.5 block h-1.5 overflow-hidden rounded-full bg-[var(--surface-container-hi)]">
              <span className="block h-full rounded-full transition-[width] duration-700" style={{ width: `${Math.max(4, bar)}%`, background: tint }} />
            </span>
          )}
        </div>
      ))}
    </div>
  )
}

/* ─── Scolarité réservée aux abonnés ──────────────────────────────────────── */

function SchoolLocked({ pathway, firstName }: { pathway: PathwayDefinition; firstName: string }) {
  const programs = programsFor(pathway.id)
  const total = programs.reduce((s, p) => s + p.cards.reduce((a, c) => a + flatLeaves(c.leaves).length, 0), 0)
  return (
    <div className="pb-14">
      <section className="cq-page-hero relative isolate overflow-hidden rounded-[28px] bg-[#1A1C21] p-7 text-white sm:p-10">
        {imgUrl(programs[0]?.image) && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={imgUrl(programs[0]?.image)!} alt="" className="cq-page-hero-img absolute inset-0 -z-10 h-full w-full object-cover" />
        )}
        <span className="absolute inset-0 -z-10 bg-[linear-gradient(90deg,rgba(12,13,16,.94)_0%,rgba(12,13,16,.78)_50%,rgba(12,13,16,.35)_100%)]" aria-hidden="true" />
        <div className="cq-page-hero-text max-w-2xl">
          <span className="cq-glass inline-flex h-8 w-fit items-center gap-1.5 rounded-full px-3 text-[12.5px] font-bold">
            <Lock className="h-3.5 w-3.5" aria-hidden="true" /> {pathway.shortLabel}
          </span>
          <h1 className="mt-5 text-[clamp(1.7rem,3.2vw,2.5rem)] font-black leading-[1.05] tracking-[-0.03em] [text-wrap:balance]">
            {firstName ? `${firstName}, la` : "La"} scolarité est réservée aux abonnés Premium.
          </h1>
          <p className="mt-3 text-[16px] leading-relaxed text-white/80">
            {total} cours et quiz de l’école, les mêmes que dans l’application, organisés en {programs.length} programmes. Active Premium pour y accéder sur le site et sur ton téléphone.
          </p>
          <div className="mt-7 flex flex-wrap gap-3">
            <Link href="/abonnement" className="inline-flex h-12 items-center gap-2 rounded-[16px] bg-white px-5 text-[15px] font-bold text-[#1C1C1C] transition hover:-translate-y-0.5">
              <Crown className="h-4 w-4 text-[#F59E0B]" aria-hidden="true" /> Voir les formules
            </Link>
            <Link href="/choisir-parcours" className="cq-glass inline-flex h-12 items-center gap-2 rounded-[16px] px-5 text-[15px] font-bold text-white hover:bg-white/20">
              Préparer un concours <ArrowRight className="h-4 w-4" aria-hidden="true" />
            </Link>
          </div>
        </div>
      </section>
      <SectionTitle title="Au programme" aside={`${programs.length} programmes`} className="mb-4 mt-9" />
      <ul className="mt-6 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
        {programs.map((p, i) => (
          <li key={p.key} className="cq-stagger-item cq-card relative overflow-hidden rounded-[20px]" style={{ "--i": i } as CSSProperties}>
            <div className="flex items-center gap-3 p-3">
              <Thumb image={p.image} className="h-14 w-14 rounded-[14px]" />
              <div className="min-w-0">
                <p className="truncate text-[14.5px] font-semibold text-[var(--on-surface)]">{p.label}</p>
                <p className="text-[12.5px] text-[var(--on-surface-muted)]">{p.cards.length} domaines</p>
              </div>
              <Lock className="ml-auto h-4 w-4 shrink-0 text-[var(--on-surface-faint)]" aria-hidden="true" />
            </div>
          </li>
        ))}
      </ul>
    </div>
  )
}

export function Thumb({ image, className }: { image: string | null | undefined; className?: string }) {
  const src = imgUrl(image)
  return (
    <span className={cn("block shrink-0 overflow-hidden bg-[var(--surface-container-hi)]", className)}>
      {src && (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={src} alt="" loading="lazy" className="h-full w-full object-cover" />
      )}
    </span>
  )
}
