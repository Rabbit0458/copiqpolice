"use client"

import Link from "next/link"
import { useEffect, useMemo, useState, type CSSProperties, type ReactNode } from "react"
import {
  ArrowRight,
  ArrowUpRight,
  BookOpen,
  Brain,
  CalendarClock,
  Check,
  ClipboardCheck,
  Crown,
  FileText,
  Flame,
  GraduationCap,
  Languages,
  NotebookPen,
  RefreshCw,
  Smartphone,
  Sparkles,
  StickyNote,
  Target,
  type LucideIcon,
} from "lucide-react"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { usePathway } from "@/features/pathway/pathway-provider"
import type { PathwayDefinition, PathwayFeature, PathwayIconKey } from "@/config/pathways"
import { Appear, SplitText, useInView } from "@/components/home/motion"
import { Counter } from "@/components/home/counter"
import { MOTIVATION_QUOTES } from "@/data/home"
import { avatarSrc } from "@/features/auth/profile-rules"
import { daysUntil, loadHomeSnapshot, type Activity, type HomeSnapshot, type Subject } from "@/features/home/progress"

/**
 * Progression de l'espace connecté — version 5 (octobre 2026).
 * (L'accueil, lui, est l'espace d'entraînement interactif : features/home/accueil-v5.tsx.)
 *
 * Mêmes chiffres que la home de l'application, calculés avec les mêmes règles
 * (features/home/progress.ts) : progression globale et par matière, série,
 * prochaine étape recommandée, échéance officielle du concours.
 * Uniquement des données réelles ; un nouveau compte voit un accueil guidé.
 *
 * Chorégraphie d'entrée (≈ 1,2 s) : bonjour mot par mot → anneau qui se
 * dessine jusqu'au score → barres qui se remplissent une à une → cartes en
 * cascade. Tout est immobile si l'utilisateur réduit les animations.
 */

const ICONS: Record<PathwayIconKey, LucideIcon> = {
  dashboard: Target,
  graduation: GraduationCap,
  quiz: Target,
  knowledge: BookOpen,
  brain: Brain,
  languages: Languages,
  caseStudies: FileText,
  mockExam: ClipboardCheck,
  memos: StickyNote,
  notes: NotebookPen,
}

/** Matière de progression ↔ entrée de navigation du parcours. */
const FEATURE_SUBJECT: Partial<Record<PathwayFeature, string>> = {
  generalKnowledge: "culture_generale",
  psychotechnics: "psychotechnique",
  languages: "langue_etrangere",
  caseStudies: "cas_pratique",
}

function subjectHref(pathway: PathwayDefinition, key: string) {
  const byFeature = (f: PathwayFeature) => pathway.navigation.find((n) => n.feature === f)?.href
  const quiz = byFeature("quiz") ?? "/dashboard"
  switch (key) {
    case "culture_generale":
      return byFeature("generalKnowledge") ?? quiz
    case "psychotechnique":
      return byFeature("psychotechnics") ?? quiz
    case "langue_etrangere":
      return byFeature("languages") ?? quiz
    case "cas_pratique":
      return byFeature("caseStudies") ?? quiz
    default:
      return quiz
  }
}

const relative = (d: Date) => {
  const diff = Math.round((new Date().setHours(0, 0, 0, 0) - new Date(d).setHours(0, 0, 0, 0)) / 86400000)
  if (diff <= 0) return `Aujourd’hui, ${d.toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" })}`
  if (diff === 1) return "Hier"
  if (diff < 7) return `Il y a ${diff} jours`
  return d.toLocaleDateString("fr-FR", { day: "numeric", month: "short" })
}

/* ─────────────────────────────────────────────────────────────────────────── */

export function ProgressionV5() {
  const supabase = useMemo(() => createClient(), [])
  const { pathway, profile } = usePathway()
  const [userId, setUserId] = useState<string | null>(null)
  const [extra, setExtra] = useState<{ avatar: number; tier: string } | null>(null)
  const [snap, setSnap] = useState<HomeSnapshot | null>(null)
  const [error, setError] = useState(false)
  const [tick, setTick] = useState(0)

  useEffect(() => {
    let alive = true
    supabase.auth.getUser().then(async ({ data }) => {
      if (!alive || !data.user) return
      setUserId(data.user.id)
      const [{ data: prof }, { data: sub }] = await Promise.all([
        supabase.from("user_profiles").select("avatar_index").eq("user_id", data.user.id).maybeSingle(),
        supabase.from("cas_pratique_subscriptions").select("tier, status").eq("user_id", data.user.id).maybeSingle(),
      ])
      if (!alive) return
      const avatar = Number((prof as { avatar_index?: number } | null)?.avatar_index) || 1
      setExtra({ avatar: Math.min(20, Math.max(1, avatar)), tier: String((sub as { tier?: string } | null)?.tier ?? "free") })
    })
    return () => {
      alive = false
    }
  }, [supabase])

  useEffect(() => {
    if (!userId || !pathway) return
    let alive = true
    loadHomeSnapshot(supabase, userId, pathway)
      .then((s) => {
        if (!alive) return
        setSnap(s)
        setError(false)
      })
      .catch(() => alive && setError(true))
    return () => {
      alive = false
    }
  }, [supabase, userId, pathway, tick])

  if (!pathway) return null
  const firstName = profile?.first_name?.trim() || profile?.username || ""
  const premium = extra?.tier === "premium" || extra?.tier === "premium_trial"

  return (
    <div className="cq-home-v5 pb-10">
      <Hero pathway={pathway} firstName={firstName} avatar={extra?.avatar ?? null} snap={snap} />

      {error && !snap ? (
        <div role="alert" className="mt-6 flex flex-wrap items-center justify-between gap-3 rounded-[22px] border border-[#DC2626]/25 bg-[#DC2626]/[0.06] p-5">
          <p className="text-[15px] text-[var(--on-surface)]">Impossible de charger ta progression pour le moment.</p>
          <button type="button" onClick={() => setTick((t) => t + 1)} className="cq-tap inline-flex items-center gap-2 rounded-xl bg-[var(--surface)] px-4 text-[14px] font-semibold ring-1 ring-[var(--outline)]">
            <RefreshCw className="h-4 w-4" aria-hidden="true" /> Réessayer
          </button>
        </div>
      ) : !snap ? (
        <HomeSkeleton />
      ) : (
        <div className="mt-6 grid gap-5 lg:grid-cols-12">
          <Appear className="lg:col-span-4" delay={80}>
            <GlobalRing snap={snap} pathway={pathway} />
          </Appear>
          <Appear className="lg:col-span-8" delay={160}>
            <Subjects pathway={pathway} snap={snap} />
          </Appear>

          <Appear className="lg:col-span-8" delay={120}>
            <NextStep pathway={pathway} snap={snap} />
          </Appear>
          <Appear className="lg:col-span-4" delay={200}>
            <Regularity snap={snap} />
          </Appear>

          <Appear className="lg:col-span-12" delay={80}>
            <Trainings pathway={pathway} snap={snap} premium={premium} />
          </Appear>

          <Appear className="lg:col-span-8" delay={80}>
            <Recent pathway={pathway} snap={snap} />
          </Appear>
          <Appear className="lg:col-span-4" delay={160}>
            {premium ? <AppCard /> : <PremiumCard />}
          </Appear>

          {snap.warnings.length > 0 && (
            <p className="text-[13px] text-[var(--on-surface-faint)] lg:col-span-12">
              Certaines données ({snap.warnings.join(", ")}) ne sont pas disponibles pour le moment.
            </p>
          )}
        </div>
      )}
    </div>
  )
}

/* ─── En-tête bleu nuit ───────────────────────────────────────────────────── */

function Hero({ pathway, firstName, avatar, snap }: { pathway: PathwayDefinition; firstName: string; avatar: number | null; snap: HomeSnapshot | null }) {
  const quote = useMemo(() => {
    const d = new Date()
    const n = d.getFullYear() * 400 + d.getMonth() * 31 + d.getDate()
    return MOTIVATION_QUOTES[n % MOTIVATION_QUOTES.length].replace(/^«\s*|\s*»$/g, "")
  }, [])
  const event = snap?.nextEvent ?? null
  const eventDate = event ? (event.type === "registration" ? event.endsOn : event.startsOn) : null
  const dLeft = eventDate ? daysUntil(eventDate) : null

  return (
    <section className="cq-home-hero cq-enter-panel relative isolate overflow-hidden rounded-[28px] px-6 py-7 text-white sm:px-9 sm:py-9" aria-labelledby="progression-titre">
      <span className="cq-hero-sheen pointer-events-none absolute inset-0" aria-hidden="true" />
      <div className="relative grid gap-8 lg:grid-cols-[1fr_auto] lg:items-end">
        <div className="min-w-0">
          <div className="flex items-center gap-4">
            {avatar ? (
              // eslint-disable-next-line @next/next/no-img-element
              <img src={avatarSrc(avatar)} alt="" width={64} height={64} className="cq-avatar-pop h-16 w-16 shrink-0 rounded-full ring-2 ring-white/20" />
            ) : (
              <span className="h-16 w-16 shrink-0 rounded-full bg-white/10" aria-hidden="true" />
            )}
            <div className="min-w-0">
              <p className="cq-enter text-[13px] font-semibold uppercase tracking-[0.16em] text-white/55" style={{ "--d": "120ms" } as CSSProperties}>
                {pathway.shortLabel}
              </p>
              <SplitText
                as="h1"
                id="progression-titre"
                mode="load"
                delay={180}
                text={firstName ? `Ta progression, ${firstName}.` : "Ta progression."}
                className="mt-1 block text-[clamp(1.9rem,3.6vw,2.9rem)] font-bold leading-[1.02] tracking-[-0.04em]"
              />
            </div>
          </div>
          <p className="cq-enter mt-5 max-w-xl text-[16px] leading-relaxed text-white/72" style={{ "--d": "420ms" } as CSSProperties}>
            {snap && snap.totalQuestions > 0
              ? `${snap.totalActivities} entraînement${snap.totalActivities > 1 ? "s" : ""} et ${snap.totalQuestions.toLocaleString("fr-FR")} réponse${snap.totalQuestions > 1 ? "s" : ""} au compteur, sur le site comme dans l’application.`
              : "Tes résultats s’afficheront ici dès ton premier entraînement, sur le site comme dans l’application."}
          </p>
          <div className="cq-enter mt-5 flex flex-wrap gap-2" style={{ "--d": "520ms" } as CSSProperties}>
            <span className="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1.5 text-[13px] font-medium ring-1 ring-white/10">
              <span className="h-2 w-2 rounded-full" style={{ background: pathway.color, boxShadow: `0 0 10px ${pathway.color}` }} aria-hidden="true" />
              {pathway.title}
            </span>
            {snap && snap.streakDays > 0 && (
              <span className="inline-flex items-center gap-1.5 rounded-full bg-[#F97316]/15 px-3 py-1.5 text-[13px] font-semibold text-[#FDBA74] ring-1 ring-[#F97316]/25">
                <Flame className="cq-flame h-3.5 w-3.5" aria-hidden="true" />
                {snap.streakDays} jour{snap.streakDays > 1 ? "s" : ""} d’affilée
              </span>
            )}
          </div>
        </div>

        {dLeft !== null && event && (
          <div className="cq-enter relative rounded-[22px] border border-white/12 bg-white/[0.07] p-5 backdrop-blur-md lg:w-[19rem]" style={{ "--d": "380ms" } as CSSProperties}>
            <p className="flex items-center gap-2 text-[12px] font-semibold uppercase tracking-[0.14em] text-white/55">
              <CalendarClock className="h-4 w-4" aria-hidden="true" />
              {event.type === "registration" ? "Fin des inscriptions" : event.typeLabel}
            </p>
            <p className="mt-3 flex items-baseline gap-2">
              <span className="text-[3.25rem] font-bold leading-none tracking-[-0.05em]">
                {dLeft === 0 ? "Aujourd’hui" : <>J‑<Counter value={dLeft} delay={500} /></>}
              </span>
            </p>
            <p className="mt-2 line-clamp-2 text-[13.5px] leading-snug text-white/65">{event.dateText}</p>
          </div>
        )}
      </div>

      <p className="cq-enter-fade relative mt-7 max-w-2xl border-t border-white/10 pt-5 text-[14.5px] italic leading-relaxed text-white/60" style={{ "--d": "700ms" } as CSSProperties}>
        « {quote} »
      </p>
    </section>
  )
}

/* ─── Prochaine étape ─────────────────────────────────────────────────────── */

function NextStep({ pathway, snap }: { pathway: PathwayDefinition; snap: HomeSnapshot }) {
  const rec = snap.recommendation
  const quizHref = "/dashboard"
  const href = rec ? subjectHref(pathway, rec.subject.key) : quizHref
  const eyebrow = rec ? "Ta prochaine étape" : "Pour bien démarrer"
  const title = rec ? `Renforce ${rec.subject.label.toLowerCase()}` : "Lance ta première session"
  const text = rec ? rec.reason : "En quelques minutes, tu sauras où tu en es. Tes résultats alimentent ensuite ta progression, ici et dans l’application."

  return (
    <Link href={href} className="cq-glow-ring cq-card-lift group relative block h-full overflow-hidden rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-7">
      <span className="pointer-events-none absolute -right-16 -top-16 h-56 w-56 rounded-full blur-3xl" style={{ background: `${rec?.subject.color ?? "#1147D9"}22` }} aria-hidden="true" />
      <p className="relative flex items-center gap-2 text-[12.5px] font-semibold uppercase tracking-[0.14em] text-[#1147D9] dark:text-[#7FB3FF]">
        <Sparkles className="h-4 w-4" aria-hidden="true" />
        {eyebrow}
      </p>
      <h2 className="relative mt-3 text-[clamp(1.5rem,2.4vw,2rem)] font-bold leading-[1.1] tracking-[-0.035em] text-[var(--on-surface)]">{title}</h2>
      <p className="relative mt-2.5 max-w-xl text-[15.5px] leading-relaxed text-[var(--on-surface-muted)]">{text}</p>
      <div className="relative mt-6 flex flex-wrap items-center gap-4">
        <span className="cq-btn cq-btn-shine inline-flex h-12 items-center gap-2 rounded-2xl bg-[#E0162B] px-5 text-[15px] font-semibold text-white shadow-[0_14px_36px_-16px_rgba(224,22,43,0.9)] transition-colors group-hover:bg-[#C8102A]">
          {rec ? "S’entraîner maintenant" : "Commencer"}
          <ArrowRight className="h-4 w-4 transition-transform duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] group-hover:translate-x-1" aria-hidden="true" />
        </span>
        {rec && (
          <span className="text-[14px] text-[var(--on-surface-muted)]">
            Moyenne actuelle : <strong className="font-semibold text-[var(--on-surface)]">{rec.subject.averagePercent} %</strong>
          </span>
        )}
      </div>
    </Link>
  )
}

/* ─── Anneau de progression globale ───────────────────────────────────────── */

function GlobalRing({ snap, pathway }: { snap: HomeSnapshot; pathway: PathwayDefinition }) {
  const [ref, inView] = useInView<HTMLDivElement>({ threshold: 0.35 })
  const R = 54
  const C = 2 * Math.PI * R
  const value = snap.globalPercent
  const has = snap.totalActivities > 0

  return (
    <div ref={ref} className="cq-card-lift flex h-full flex-col rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6">
      <h2 className="text-[15px] font-semibold text-[var(--on-surface)]">{pathway.mode === "exam" ? "Ta progression vers le concours" : "Ton niveau en scolarité"}</h2>
      <div className="mt-4 flex flex-1 items-center gap-5">
        <div className="relative h-[132px] w-[132px] shrink-0">
          <svg viewBox="0 0 132 132" className="h-full w-full -rotate-90" aria-hidden="true">
            <defs>
              <linearGradient id="cq-ring-grad" x1="0" y1="0" x2="1" y2="1">
                <stop offset="0%" stopColor="#3D7BFF" />
                <stop offset="55%" stopColor="#1147D9" />
                <stop offset="100%" stopColor="#E0162B" />
              </linearGradient>
            </defs>
            <circle cx="66" cy="66" r={R} fill="none" stroke="var(--outline)" strokeWidth="10" opacity="0.6" />
            <circle
              cx="66"
              cy="66"
              r={R}
              fill="none"
              stroke="url(#cq-ring-grad)"
              strokeWidth="10"
              strokeLinecap="round"
              strokeDasharray={C}
              strokeDashoffset={inView ? C * (1 - value / 100) : C}
              className="cq-ring-arc"
            />
          </svg>
          <div className="absolute inset-0 grid place-items-center text-center">
            <div>
              <p className="text-[2rem] font-bold leading-none tracking-[-0.04em] text-[var(--on-surface)]">
                {has ? <Counter value={value} suffix=" %" delay={150} /> : "—"}
              </p>
              <p className="mt-1 text-[11.5px] font-medium uppercase tracking-[0.1em] text-[var(--on-surface-faint)]">réussite</p>
            </div>
          </div>
        </div>
        <dl className="grid gap-3 text-[14px]">
          <div>
            <dt className="text-[var(--on-surface-faint)]">Entraînements</dt>
            <dd className="text-[18px] font-semibold text-[var(--on-surface)]"><Counter value={snap.totalActivities} /></dd>
          </div>
          <div>
            <dt className="text-[var(--on-surface-faint)]">Cette semaine</dt>
            <dd className="text-[18px] font-semibold text-[var(--on-surface)]"><Counter value={snap.doneThisWeek} /></dd>
          </div>
          {snap.placementPercent !== null && (
            <div>
              <dt className="text-[var(--on-surface-faint)]">Test de niveau</dt>
              <dd className="text-[18px] font-semibold text-[var(--on-surface)]">{snap.placementPercent} %</dd>
            </div>
          )}
        </dl>
      </div>
    </div>
  )
}

/* ─── Matières ────────────────────────────────────────────────────────────── */

function Subjects({ pathway, snap }: { pathway: PathwayDefinition; snap: HomeSnapshot }) {
  const [ref, inView] = useInView<HTMLDivElement>({ threshold: 0.2 })
  const list = [...snap.subjects].sort((a, b) => b.total - a.total)
  return (
    <div ref={ref} className="h-full rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6">
      <div className="flex items-center justify-between gap-3">
        <h2 className="text-[15px] font-semibold text-[var(--on-surface)]">Par matière</h2>
        <Link href="/historique" className="inline-flex items-center gap-1 rounded-lg text-[13.5px] font-semibold text-[#1147D9] hover:underline dark:text-[#7FB3FF]">
          Historique <ArrowUpRight className="h-3.5 w-3.5" aria-hidden="true" />
        </Link>
      </div>
      {list.length === 0 ? (
        <EmptyLine>Tes matières apparaîtront ici dès ton premier entraînement.</EmptyLine>
      ) : (
        <ul className="mt-5 grid gap-4">
          {list.slice(0, 6).map((s, i) => (
            <li key={s.key}>
              <Link href={subjectHref(pathway, s.key)} className="group block rounded-xl">
                <div className="flex items-baseline justify-between gap-3 text-[14.5px]">
                  <span className="flex min-w-0 items-center gap-2 font-medium text-[var(--on-surface)]">
                    <span className="h-2 w-2 shrink-0 rounded-full" style={{ background: s.color }} aria-hidden="true" />
                    <span className="truncate group-hover:underline">{s.label}</span>
                  </span>
                  <span className="shrink-0 tabular-nums text-[var(--on-surface-muted)]">
                    <strong className="font-semibold text-[var(--on-surface)]">{s.averagePercent} %</strong> · {s.activities} séance{s.activities > 1 ? "s" : ""}
                  </span>
                </div>
                <div className="mt-2 h-2 overflow-hidden rounded-full bg-[var(--surface-container-hi)]">
                  <div
                    className={cn("cq-bar h-full rounded-full", inView && "is-in")}
                    style={{ width: `${Math.max(3, s.averagePercent)}%`, background: `linear-gradient(90deg, ${s.color}cc, ${s.color})`, "--d": `${200 + i * 110}ms` } as CSSProperties}
                  />
                </div>
              </Link>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}

/* ─── Régularité ──────────────────────────────────────────────────────────── */

function Regularity({ snap }: { snap: HomeSnapshot }) {
  const days = ["L", "M", "M", "J", "V", "S", "D"]
  return (
    <div className="h-full rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6">
      <h2 className="text-[15px] font-semibold text-[var(--on-surface)]">Régularité</h2>
      <div className="mt-4 flex items-center gap-3">
        <span className={cn("grid h-12 w-12 place-items-center rounded-2xl", snap.streakDays > 0 ? "bg-[#F97316]/12 text-[#EA580C]" : "bg-[var(--surface-container)] text-[var(--on-surface-faint)]")}>
          <Flame className={cn("h-6 w-6", snap.streakDays > 0 && "cq-flame")} aria-hidden="true" />
        </span>
        <div>
          <p className="text-[1.75rem] font-bold leading-none tracking-[-0.03em] text-[var(--on-surface)]">
            <Counter value={snap.streakDays} /> <span className="text-[15px] font-semibold text-[var(--on-surface-muted)]">jour{snap.streakDays > 1 ? "s" : ""}</span>
          </p>
          <p className="mt-1 text-[13px] text-[var(--on-surface-muted)]">de série en cours</p>
        </div>
      </div>
      <ol className="mt-6 grid grid-cols-7 gap-1.5" aria-label="7 derniers jours">
        {snap.week.map((d, i) => {
          const today = i === snap.week.length - 1
          const on = d.count > 0
          return (
            <li key={d.day.toISOString()} className="flex flex-col items-center gap-1.5">
              <span
                className={cn(
                  "cq-day grid aspect-square w-full max-w-9 place-items-center rounded-xl text-[11px] font-semibold",
                  on ? "bg-[#1147D9] text-white shadow-[0_8px_18px_-10px_rgba(17,71,217,.9)]" : "bg-[var(--surface-container)] text-transparent",
                  today && !on && "ring-2 ring-dashed ring-[var(--outline)]",
                )}
                style={{ "--d": `${300 + i * 60}ms` } as CSSProperties}
                title={`${d.day.toLocaleDateString("fr-FR", { weekday: "long", day: "numeric", month: "long" })} : ${d.count} activité${d.count > 1 ? "s" : ""}`}
              >
                {on ? <Check className="h-3.5 w-3.5" strokeWidth={3} aria-hidden="true" /> : "·"}
              </span>
              <span className={cn("text-[11px] font-medium", today ? "text-[var(--on-surface)]" : "text-[var(--on-surface-faint)]")}>
                {days[(d.day.getDay() + 6) % 7]}
              </span>
            </li>
          )
        })}
      </ol>
      <p className="mt-4 text-[13.5px] text-[var(--on-surface-muted)]">
        {snap.doneThisWeek > 0 ? (
          <>
            <strong className="font-semibold text-[var(--on-surface)]">{snap.doneThisWeek}</strong> entraînement{snap.doneThisWeek > 1 ? "s" : ""} cette semaine.
          </>
        ) : (
          "Aucun entraînement cette semaine pour l’instant."
        )}
      </p>
    </div>
  )
}

/* ─── Tes entraînements (navigation du parcours) ──────────────────────────── */

function Trainings({ pathway, snap, premium }: { pathway: PathwayDefinition; snap: HomeSnapshot; premium: boolean }) {
  const items = pathway.navigation
  return (
    <section aria-labelledby="entrainements">
      <h2 id="entrainements" className="mb-3 px-1 text-[15px] font-semibold text-[var(--on-surface)]">
        {pathway.mode === "exam" ? "Tes épreuves" : "Ta scolarité"}
      </h2>
      <ul className="grid grid-cols-2 gap-3 md:grid-cols-3 xl:grid-cols-6">
        {items.map((n, i) => {
          const Icon = ICONS[n.iconKey]
          const subjectKey = FEATURE_SUBJECT[n.feature]
          const subject: Subject | undefined = subjectKey ? snap.subjects.find((s) => s.key === subjectKey) : undefined
          const locked = n.premium && !premium
          return (
            <li key={n.href + n.label} className="cq-stagger-item" style={{ "--i": i } as CSSProperties}>
              <Link href={n.href} className="cq-card-lift group relative flex h-full flex-col rounded-[20px] border border-[var(--outline)] bg-[var(--surface)] p-4">
                <span className="flex items-start justify-between">
                  <span className="grid h-10 w-10 place-items-center rounded-xl transition-transform duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] group-hover:scale-110" style={{ background: pathway.softColor, color: pathway.color }}>
                    <Icon className="h-5 w-5" aria-hidden="true" />
                  </span>
                  {locked && (
                    <span className="inline-flex items-center gap-1 rounded-full bg-[#F59E0B]/12 px-2 py-0.5 text-[11px] font-semibold text-[#B45309] dark:text-[#FBBF24]">
                      <Crown className="h-3 w-3" aria-hidden="true" /> Premium
                    </span>
                  )}
                </span>
                <span className="mt-4 text-[15px] font-semibold leading-snug text-[var(--on-surface)]">{n.label}</span>
                <span className="mt-1 text-[13px] leading-snug text-[var(--on-surface-muted)]">{n.description}</span>
                {subject && (
                  <span className="mt-3 text-[12.5px] font-semibold tabular-nums" style={{ color: subject.color }}>
                    {subject.averagePercent} % de réussite
                  </span>
                )}
              </Link>
            </li>
          )
        })}
      </ul>
    </section>
  )
}

/* ─── Activité récente ────────────────────────────────────────────────────── */

function Recent({ pathway, snap }: { pathway: PathwayDefinition; snap: HomeSnapshot }) {
  return (
    <div className="h-full rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6">
      <div className="flex items-center justify-between gap-3">
        <h2 className="text-[15px] font-semibold text-[var(--on-surface)]">Activité récente</h2>
        <Link href="/historique" className="inline-flex items-center gap-1 rounded-lg text-[13.5px] font-semibold text-[#1147D9] hover:underline dark:text-[#7FB3FF]">
          Historique <ArrowUpRight className="h-3.5 w-3.5" aria-hidden="true" />
        </Link>
      </div>
      {snap.recent.length === 0 ? (
        <EmptyLine>Ton historique s’affichera ici, sur le site comme dans l’application.</EmptyLine>
      ) : (
        <ul className="mt-3 divide-y divide-[var(--outline)]">
          {snap.recent.map((a: Activity) => {
            const p = a.total > 0 ? Math.round((Math.min(a.correct, a.total) / a.total) * 100) : null
            const subject = snap.subjects.find((s) => s.key === a.moduleKey)
            return (
              <li key={a.id}>
                <Link href={subjectHref(pathway, a.moduleKey)} className="group flex items-center gap-4 rounded-xl py-3.5">
                  <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl text-[13px] font-bold tabular-nums" style={{ background: `${subject?.color ?? "#64748B"}18`, color: subject?.color ?? "#64748B" }}>
                    {p === null ? "—" : `${p}`}
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className="block truncate text-[14.5px] font-medium text-[var(--on-surface)] group-hover:underline">{a.title}</span>
                    <span className="block truncate text-[13px] text-[var(--on-surface-muted)]">
                      {a.moduleLabel} · {relative(a.finishedAt)}
                    </span>
                  </span>
                  <span className="hidden shrink-0 items-center gap-1 text-[13px] font-semibold text-[#1147D9] opacity-0 transition-opacity group-hover:opacity-100 sm:inline-flex dark:text-[#7FB3FF]">
                    Reprendre <ArrowRight className="h-3.5 w-3.5" aria-hidden="true" />
                  </span>
                </Link>
              </li>
            )
          })}
        </ul>
      )}
    </div>
  )
}

/* ─── Premium / Application ───────────────────────────────────────────────── */

function PremiumCard() {
  return (
    <div className="cq-home-hero relative h-full overflow-hidden rounded-[24px] p-6 text-white">
      <span className="cq-hero-sheen pointer-events-none absolute inset-0" aria-hidden="true" />
      <p className="relative inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-[12px] font-semibold uppercase tracking-[0.12em] ring-1 ring-white/10">
        <Crown className="h-3.5 w-3.5 text-[#FBBF24]" aria-hidden="true" /> Premium
      </p>
      <h2 className="relative mt-4 text-[1.4rem] font-bold leading-tight tracking-[-0.03em]">Tout COP’IQ, sans limite.</h2>
      <ul className="relative mt-4 grid gap-2 text-[14px] text-white/75">
        {["Cas pratiques corrigés", "Concours blancs chronométrés", "Tous les quiz et psychotechniques"].map((t) => (
          <li key={t} className="flex items-center gap-2">
            <Check className="h-4 w-4 shrink-0 text-[#4ADE80]" strokeWidth={3} aria-hidden="true" /> {t}
          </li>
        ))}
      </ul>
      <Link href="/abonnement" className="cq-btn cq-btn-shine relative mt-6 inline-flex h-11 w-full items-center justify-center gap-2 rounded-xl bg-white px-4 text-[14.5px] font-semibold text-[#000B36] hover:bg-white/90">
        Voir les formules · dès 6,67 €/mois
      </Link>
    </div>
  )
}

function AppCard() {
  return (
    <div className="h-full rounded-[24px] border border-[var(--outline)] bg-[var(--surface)] p-6">
      <span className="grid h-11 w-11 place-items-center rounded-2xl bg-[#1147D9]/10 text-[#1147D9] dark:text-[#7FB3FF]">
        <Smartphone className="h-5 w-5" aria-hidden="true" />
      </span>
      <h2 className="mt-4 text-[16px] font-semibold text-[var(--on-surface)]">Révise aussi dans l’application</h2>
      <p className="mt-1.5 text-[14px] leading-relaxed text-[var(--on-surface-muted)]">
        Même compte, même progression. L’application COP’IQ arrive bientôt sur l’App Store et Google Play.
      </p>
    </div>
  )
}

/* ─── Divers ──────────────────────────────────────────────────────────────── */

function EmptyLine({ children }: { children: ReactNode }) {
  return <p className="mt-5 rounded-2xl bg-[var(--surface-container)] px-4 py-5 text-center text-[14px] text-[var(--on-surface-muted)]">{children}</p>
}

function HomeSkeleton() {
  const block = "cq-skel rounded-[24px]"
  return (
    <div className="mt-6 grid gap-5 lg:grid-cols-12" aria-busy="true" aria-label="Chargement de ta progression">
      <div className={cn(block, "h-56 lg:col-span-8")} />
      <div className={cn(block, "h-56 lg:col-span-4")} />
      <div className={cn(block, "h-64 lg:col-span-8")} />
      <div className={cn(block, "h-64 lg:col-span-4")} />
      <div className={cn(block, "h-40 lg:col-span-12")} />
    </div>
  )
}
