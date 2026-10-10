"use client"

import Link from "next/link"
import { Fragment, useEffect, useMemo, useRef, useState, type CSSProperties, type ReactNode } from "react"
import { ArrowRight, ArrowUp, BookOpen, Check, Clock3, Gavel, Lightbulb, ListChecks, RefreshCw } from "lucide-react"
import type { SupabaseClient } from "@supabase/supabase-js"
import { createClient } from "@/lib/supabase/client"
import { cn } from "@/lib/utils"
import { PageHero } from "@/features/parcours/ui"
import type { CourseLeaf } from "@/features/parcours/tree"
import { LAW_RE, fragmentsToSections, slugify, type Block, type Fragment as Frag, type Inline, type Section } from "@/features/parcours/course-parse"

/**
 * Lecteur de cours — même contenu et même présentation que l'application :
 * une page qui défile, faite de cartes colorées (une par titre de la page
 * Flutter), sous-titres numérotés, listes cochées, encadrés « Exemple » et
 * références légales en rouge.
 *
 * Source 1 : `scolarite_content_fragments` (texte des pages Dart, y compris les
 * pages enchaînées listées dans `srcs`). Source 2 (fiches dynamiques) :
 * `cours_scolarite.body_md` + points clés + références, comme `CoursScolaritePage`.
 *
 * Ordinateur : sommaire fixe à gauche qui suit la lecture, barre de progression.
 */

type CourseMeta = { title: string | null; subtitle: string | null; key_points: string[] | null; legal_refs: string[] | null; quiz_module: string | null }

const PALETTE = [
  { accent: "#1565C0", bg: "#E3F2FD" },
  { accent: "#00897B", bg: "#E0F2F1" },
  { accent: "#7B1FA2", bg: "#F3E5F5" },
  { accent: "#EF6C00", bg: "#FFF3E0" },
]

/** Fiches markdown (cours_scolarite) → mêmes sections que les pages Flutter. */
function markdownToSections(md: string, title: string): Section[] {
  const lines = md.replace(/\r/g, "").split("\n")
  const sections: Section[] = []
  const tint = () => PALETTE[sections.length % PALETTE.length]
  let cur: Section = { id: "s-0", title, level: 1, tint: tint(), blocks: [] }
  const inline = (s: string): Inline[] =>
    s
      .split(/(\*\*[^*]+\*\*)/g)
      .filter(Boolean)
      .map((seg) => {
        const m = seg.match(/^\*\*(.+)\*\*$/)
        return { text: m ? m[1] : seg, strong: !!m }
      })
  let i = 0
  while (i < lines.length) {
    const line = lines[i].trim()
    if (!line) {
      i++
      continue
    }
    if (/^##\s/.test(line)) {
      if (cur.blocks.length) sections.push(cur)
      const t = line.replace(/^##\s+/, "")
      cur = { id: `s-${sections.length + 1}-${slugify(t)}`, title: t, level: 1, tint: tint(), blocks: [] }
    } else if (/^#{1,3}\s/.test(line)) cur.blocks.push({ t: "sub", text: line.replace(/^#{1,3}\s+/, "") })
    else if (/^-{3,}$/.test(line)) cur.blocks.push({ t: "hr" })
    else if (/^\|/.test(line)) {
      const rows: string[][] = []
      while (i < lines.length && /^\|/.test(lines[i].trim())) {
        const r = lines[i].trim().replace(/^\||\|$/g, "").split("|").map((c) => c.trim().replace(/\*\*/g, ""))
        if (!r.every((c) => /^:?-{2,}:?$/.test(c) || c === "")) rows.push(r)
        i++
      }
      cur.blocks.push({ t: "table", rows })
      continue
    } else if (/^[-*]\s/.test(line)) {
      const items: Inline[][] = []
      while (i < lines.length && /^[-*]\s/.test(lines[i].trim())) {
        items.push(inline(lines[i].trim().replace(/^[-*]\s+/, "")))
        i++
      }
      cur.blocks.push({ t: "list", items })
      continue
    } else if (/^>\s?/.test(line)) cur.blocks.push({ t: "nota", parts: inline(line.replace(/^>\s?/, "")) })
    else {
      let text = line
      while (i + 1 < lines.length && lines[i + 1].trim() && !/^(#|\||[-*]\s|>|-{3,})/.test(lines[i + 1].trim())) {
        text += " " + lines[i + 1].trim()
        i++
      }
      cur.blocks.push({ t: "p", parts: inline(text) })
    }
    i++
  }
  if (cur.blocks.length) sections.push(cur)
  return sections
}

export function CourseReader({ leaf, cardLabel, backHref, quizHref }: { leaf: CourseLeaf; cardLabel: string; backHref: string; quizHref: string | null }) {
  // Tables hors du typage généré : client non typé.
  const supabase = useMemo(() => createClient() as unknown as SupabaseClient, [])
  const [state, setState] = useState<"loading" | "ready" | "error">("loading")
  const [sections, setSections] = useState<Section[]>([])
  const [meta, setMeta] = useState<CourseMeta | null>(null)
  const [headSubtitle, setHeadSubtitle] = useState<string | null>(null)
  const [tick, setTick] = useState(0)
  const [active, setActive] = useState(0)
  const [progress, setProgress] = useState(0)
  const bodyRef = useRef<HTMLDivElement | null>(null)

  useEffect(() => {
    let alive = true
    ;(async () => {
      try {
        // Pages Flutter enchaînées (intro → contenu → suite) : lues dans l'ordre de l'app.
        const sources = leaf.srcs?.length ? leaf.srcs : leaf.src ? [leaf.src] : []
        const [course, rawFrags] = await Promise.all([
          leaf.db
            ? supabase.from("cours_scolarite").select("title, subtitle, body_md, key_points, legal_refs, quiz_module").eq("route", leaf.db).limit(1).maybeSingle()
            : Promise.resolve({ data: null, error: null }),
          sources.length
            ? supabase.from("scolarite_content_fragments").select("source_path, panel, position, component, text_value, style_payload").in("source_path", sources).order("position", { ascending: true }).limit(4000)
            : Promise.resolve({ data: [], error: null }),
        ])
        if (!alive) return
        if (course.error) throw course.error
        const row = course.data as (CourseMeta & { body_md: string | null }) | null
        const title = row?.title?.trim() || leaf.label
        const frags = ((rawFrags.error ? [] : rawFrags.data ?? []) as (Frag & { source_path?: string })[]).map((f) => ({
          ...f,
          position: Math.max(0, sources.indexOf(f.source_path ?? sources[0])) * 1_000_000 + f.position,
        }))
        const parsed = fragmentsToSections(frags, title)
        let list = parsed.sections
        if (list.length === 0 && row?.body_md) list = markdownToSections(row.body_md, title)
        setMeta(row)
        setHeadSubtitle(parsed.subtitle)
        setSections(list)
        setState(list.length ? "ready" : "error")
      } catch {
        if (alive) setState("error")
      }
    })()
    return () => {
      alive = false
    }
  }, [supabase, leaf, tick])

  // Progression et sommaire actif : la page défile dans <main>.
  useEffect(() => {
    if (state !== "ready") return
    const scroller = document.querySelector("main")
    if (!scroller) return
    const onScroll = () => {
      const body = bodyRef.current
      if (!body) return
      const rect = body.getBoundingClientRect()
      const view = scroller.clientHeight
      const done = Math.min(1, Math.max(0, (view * 0.35 - rect.top) / Math.max(1, rect.height - view * 0.5)))
      setProgress(done)
      const cards = Array.from(body.querySelectorAll<HTMLElement>("[data-section]"))
      let idx = 0
      cards.forEach((c, i) => {
        if (c.getBoundingClientRect().top < view * 0.32) idx = i
      })
      setActive(idx)
    }
    onScroll()
    scroller.addEventListener("scroll", onScroll, { passive: true })
    return () => scroller.removeEventListener("scroll", onScroll)
  }, [state, sections])

  const goTo = (i: number) => {
    const el = bodyRef.current?.querySelectorAll<HTMLElement>("[data-section]")[i]
    el?.scrollIntoView({ behavior: "smooth", block: "start" })
  }

  const words = sections.reduce((s, c) => s + c.blocks.reduce((a, b) => a + JSON.stringify(b).split(/\s+/).length, 0), 0)
  const minutes = Math.max(2, Math.round(words / 200))
  const title = meta?.title?.trim() || leaf.label
  const subtitle = meta?.subtitle || leaf.subtitle || headSubtitle
  const toc = sections.map((s, i) => ({ ...s, i })).filter((s) => s.title !== title || s.i > 0)

  return (
    <article className="pb-16">
      <PageHero
        image={leaf.image}
        back={{ href: backHref, label: cardLabel }}
        eyebrow={`Cours · ${cardLabel}`}
        title={title}
        subtitle={subtitle}
        chips={
          state === "ready"
            ? [
                { icon: BookOpen, label: `${sections.length} partie${sections.length > 1 ? "s" : ""}` },
                { icon: Clock3, label: `≈ ${minutes} min de lecture` },
              ]
            : []
        }
      />

      {state === "loading" && (
        <div className="mt-6 grid gap-6 lg:grid-cols-[16.5rem_minmax(0,1fr)]" aria-busy="true">
          <div className="cq-skel hidden h-80 rounded-[24px] lg:block" />
          <div className="grid gap-4">
            {[0, 1, 2].map((i) => (
              <div key={i} className="cq-skel h-48 rounded-[24px]" />
            ))}
          </div>
        </div>
      )}

      {state === "error" && (
        <div className="cq-card mt-6 p-8 text-center">
          <p className="text-[16px] font-semibold text-[var(--on-surface)]">Ce cours n’a pas pu être chargé.</p>
          <p className="mt-1 text-[14.5px] text-[var(--on-surface-muted)]">Vérifie ta connexion puis réessaie.</p>
          <button
            type="button"
            onClick={() => {
              setState("loading")
              setTick((t) => t + 1)
            }}
            className="cq-btn-ink mt-5 inline-flex h-11 items-center gap-2 rounded-xl px-4 text-[14px] font-bold"
          >
            <RefreshCw className="h-4 w-4" aria-hidden="true" /> Réessayer
          </button>
        </div>
      )}

      {state === "ready" && (
        <div className="mt-6 grid gap-6 lg:grid-cols-[16.5rem_minmax(0,1fr)]">
          {/* Sommaire (suit la lecture) */}
          <nav aria-label="Sommaire du cours" className="hidden lg:sticky lg:top-24 lg:block lg:self-start">
            <div className="rounded-[24px] border border-[var(--outline-variant)] bg-[var(--surface)] p-2 shadow-[var(--cq-shadow)]">
              <div className="flex items-center justify-between px-3 pb-2 pt-2">
                <p className="text-[12px] font-bold uppercase tracking-[0.08em] text-[var(--on-surface-faint)]">Sommaire</p>
                <p className="text-[12px] font-bold tabular-nums text-[var(--on-surface-faint)]">{Math.round(progress * 100)} %</p>
              </div>
              <div className="mx-3 mb-2 h-1 overflow-hidden rounded-full bg-[var(--outline-variant)]">
                <div className="h-full rounded-full bg-[var(--cq-accent)] transition-[width] duration-300" style={{ width: `${Math.max(2, progress * 100)}%` }} />
              </div>
              <ol className="max-h-[calc(100dvh-14rem)] overflow-y-auto pr-1 [scrollbar-width:thin]">
                {toc.map((s) => (
                  <li key={s.id}>
                    <button
                      type="button"
                      onClick={() => goTo(s.i)}
                      aria-current={s.i === active ? "location" : undefined}
                      className={cn(
                        "flex w-full items-start gap-2.5 rounded-[12px] py-2 pr-2 text-left text-[13px] leading-snug transition-colors",
                        s.level === 2 ? "pl-7" : "pl-3",
                        s.i === active ? "bg-[var(--surface-container)] font-bold text-[var(--on-surface)]" : "font-semibold text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]",
                      )}
                    >
                      <span className="mt-[5px] h-2 w-2 shrink-0 rounded-full" style={{ background: s.i <= active ? s.tint.accent : "var(--outline)" }} aria-hidden="true" />
                      <span className="line-clamp-2">{s.title}</span>
                    </button>
                  </li>
                ))}
              </ol>
            </div>
          </nav>

          {/* Contenu : cartes colorées de l'app */}
          <div ref={bodyRef} className="min-w-0">
            <div className="grid gap-4">
              {sections.map((s, i) => (
                <SectionCard key={s.id} s={s} i={i} hideTitle={i === 0 && s.title === title} />
              ))}
            </div>

            {!!(meta?.key_points?.length || meta?.legal_refs?.length) && (
              <div className="mt-4 grid gap-4 sm:grid-cols-2">
                {!!meta?.key_points?.length && (
                  <div className="cq-card p-6">
                    <p className="flex items-center gap-2 text-[14px] font-bold text-[var(--cq-accent)]">
                      <ListChecks className="h-4 w-4" aria-hidden="true" /> Points clés
                    </p>
                    <ul className="mt-3 grid gap-2 text-[15px] text-[var(--on-surface)]">
                      {meta.key_points.map((k, j) => (
                        <li key={j} className="flex gap-2">
                          <Check className="mt-1 h-4 w-4 shrink-0 text-[#16A34A]" strokeWidth={3} aria-hidden="true" />
                          {k}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
                {!!meta?.legal_refs?.length && (
                  <div className="cq-card p-6">
                    <p className="flex items-center gap-2 text-[14px] font-bold text-[var(--on-surface)]">
                      <Gavel className="h-4 w-4" aria-hidden="true" /> Références
                    </p>
                    <ul className="mt-3 grid gap-1.5 text-[14px] text-[var(--on-surface-muted)]">
                      {meta.legal_refs.map((k, j) => (
                        <li key={j}>{k}</li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )}

            <div className="cq-card mt-6 flex flex-col items-start justify-between gap-4 p-5 sm:flex-row sm:items-center sm:p-6">
              <div>
                <p className="text-[16px] font-black text-[var(--on-surface)]">{quizHref ? "Prêt à vérifier tes connaissances ?" : "Cours terminé"}</p>
                <p className="mt-0.5 text-[14px] text-[var(--on-surface-muted)]">{quizHref ? "Le quiz du chapitre, corrigé et expliqué, comme dans l’application." : "Retrouve les autres cours de ce chapitre."}</p>
              </div>
              <div className="flex shrink-0 gap-2.5">
                <button
                  type="button"
                  onClick={() => document.querySelector("main")?.scrollTo({ top: 0, behavior: "smooth" })}
                  className="cq-btn-ghost inline-flex h-12 items-center gap-2 rounded-2xl px-4 text-[14.5px] font-bold"
                  aria-label="Revenir en haut"
                >
                  <ArrowUp className="h-4 w-4" aria-hidden="true" />
                </button>
                {quizHref ? (
                  <Link href={quizHref} className="cq-btn-ink inline-flex h-12 items-center gap-2 rounded-2xl px-5 text-[14.5px] font-bold">
                    Faire le quiz <ArrowRight className="h-4 w-4" aria-hidden="true" />
                  </Link>
                ) : (
                  <Link href={backHref} className="cq-btn-ink inline-flex h-12 items-center gap-2 rounded-2xl px-5 text-[14.5px] font-bold">
                    <Check className="h-4 w-4" strokeWidth={3} aria-hidden="true" /> Terminer
                  </Link>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </article>
  )
}

function SectionCard({ s, i, hideTitle }: { s: Section; i: number; hideTitle: boolean }) {
  const style = { "--tint": s.tint.accent, "--tint-bg": s.tint.bg, "--i": Math.min(i, 8) } as CSSProperties
  return (
    <section data-section id={s.id} style={style} className={cn("cq-sec scroll-mt-24 rounded-[24px] border p-5 sm:p-8", s.level === 2 && "sm:ml-6")}>
      {!hideTitle && (
        <h2 className={cn("cq-sec-title font-black leading-[1.18] tracking-[-0.015em]", s.level === 1 ? "text-[clamp(1.2rem,1.9vw,1.45rem)]" : "text-[clamp(1.08rem,1.6vw,1.22rem)]")}>{s.title}</h2>
      )}
      <div className={cn("cq-prose", !hideTitle && "mt-4")}>
        {s.blocks.map((b, j) => (
          <BlockView key={j} b={b} />
        ))}
      </div>
    </section>
  )
}

/** Texte avec références légales en rouge (comme `_lawRed` dans l'app). */
function Rich({ parts }: { parts: Inline[] }) {
  return (
    <>
      {parts.map((p, k) => {
        const chunks = p.text.split(LAW_RE)
        const content = chunks.map((c, j) =>
          j % 2 === 1 ? (
            <span key={j} className="cq-law">
              {c}
            </span>
          ) : (
            <Fragment key={j}>{c}</Fragment>
          ),
        )
        return p.strong ? <strong key={k}>{content}</strong> : <Fragment key={k}>{content}</Fragment>
      })}
    </>
  )
}

function BlockView({ b }: { b: Block }): ReactNode {
  switch (b.t) {
    case "sub":
      return <h3>{b.text}</h3>
    case "nota":
      return (
        <aside className="cq-nota">
          <Lightbulb className="h-4 w-4 shrink-0" aria-hidden="true" />
          <span>
            {b.label && <strong>{b.label} : </strong>}
            <Rich parts={b.parts} />
          </span>
        </aside>
      )
    case "list":
      return (
        <ul className="cq-checks">
          {b.items.map((it, k) => (
            <li key={k}>
              <Check className="cq-check" strokeWidth={2.6} aria-hidden="true" />
              <span>
                <Rich parts={it} />
              </span>
            </li>
          ))}
        </ul>
      )
    case "table":
      return (
        <div className="cq-table-wrap">
          <table>
            <tbody>
              {b.rows.map((r, k) => (
                <tr key={k}>{r.map((c, j) => (k === 0 ? <th key={j}>{c}</th> : <td key={j}>{c}</td>))}</tr>
              ))}
            </tbody>
          </table>
        </div>
      )
    case "hr":
      return <hr />
    default:
      return (
        <p>
          <Rich parts={b.parts} />
        </p>
      )
  }
}
