"use client"

import { Fragment, useState, type ReactNode } from "react"
import {
  BookOpenText,
  CheckCircle2,
  Circle,
  Eye,
  FileQuestion,
  Monitor,
  Smartphone,
} from "lucide-react"
import { cn } from "@/lib/utils"

type PreviewViewport = "mobile" | "web"

type CoursePreviewProps = {
  title: string
  subtitle?: string
  code?: string
  body: string
  keyPoints: string[]
  legalRefs: string[]
  color: string
}

type QuizPreviewProps = {
  module: string
  question: string
  options: string[]
  answer: string
  category?: string
  difficulty: string
  explanation?: string
  legalRef?: string
}

export function CourseContentPreview(props: CoursePreviewProps) {
  return (
    <PreviewShell title="Aperçu de la fiche" description="Rendu indicatif avant publication">
      <article className="overflow-hidden rounded-[1.4rem] bg-white text-[#171717] shadow-sm ring-1 ring-black/5 dark:bg-[#15171b] dark:text-white">
        <div
          className="relative overflow-hidden px-5 pb-6 pt-8 text-white"
          style={{ background: `linear-gradient(135deg, ${safeColor(props.color)}, #101828)` }}
        >
          <div className="absolute -right-10 -top-14 h-36 w-36 rounded-full bg-white/10 blur-2xl" />
          <div className="relative">
            <div className="mb-5 flex items-center justify-between">
              <span className="inline-flex items-center gap-1.5 rounded-full bg-white/15 px-2.5 py-1 text-[10px] font-semibold ring-1 ring-white/20 backdrop-blur">
                <BookOpenText size={12} /> Fiche de cours
              </span>
              {props.code && <span className="text-[10px] font-semibold tracking-widest text-white/70">{props.code}</span>}
            </div>
            <h1 className="text-2xl font-bold leading-tight tracking-tight">{props.title || "Titre de la fiche"}</h1>
            {props.subtitle && <p className="mt-2 text-sm leading-relaxed text-white/75">{props.subtitle}</p>}
          </div>
        </div>

        <div className="space-y-6 px-5 py-6">
          {props.body.trim() ? (
            <MarkdownPreview markdown={props.body} accent={safeColor(props.color)} />
          ) : (
            <PreviewEmpty icon={<BookOpenText size={20} />} text="Le contenu du cours apparaîtra ici." />
          )}

          {props.keyPoints.length > 0 && (
            <section className="rounded-2xl bg-[#1147D9]/[.06] p-4 ring-1 ring-[#1147D9]/10 dark:bg-[#1147D9]/10">
              <h2 className="text-sm font-bold">À retenir</h2>
              <ul className="mt-3 space-y-2.5">
                {props.keyPoints.map((point, index) => (
                  <li key={`${point}-${index}`} className="flex gap-2.5 text-sm leading-relaxed text-black/65 dark:text-white/70">
                    <CheckCircle2 size={16} className="mt-0.5 shrink-0 text-[#1147D9]" />
                    <span>{point}</span>
                  </li>
                ))}
              </ul>
            </section>
          )}

          {props.legalRefs.length > 0 && (
            <section className="border-t border-black/10 pt-4 dark:border-white/10">
              <p className="text-[10px] font-bold uppercase tracking-[.14em] text-black/40 dark:text-white/40">Références</p>
              <p className="mt-2 text-xs leading-relaxed text-black/55 dark:text-white/55">{props.legalRefs.join(" · ")}</p>
            </section>
          )}
        </div>
      </article>
    </PreviewShell>
  )
}

export function QuizContentPreview(props: QuizPreviewProps) {
  const [selected, setSelected] = useState<string | null>(null)
  const corrected = selected !== null

  return (
    <PreviewShell title="Aperçu de la question" description="Teste le comportement sans enregistrer">
      <div className="rounded-[1.4rem] bg-white p-5 text-[#171717] shadow-sm ring-1 ring-black/5 dark:bg-[#15171b] dark:text-white">
        <div className="flex items-start justify-between gap-3">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-[#1147D9]/10 px-2.5 py-1 text-[10px] font-bold text-[#1147D9]">
            <FileQuestion size={12} /> {props.module || "Quiz"}
          </span>
          <span className="rounded-full bg-black/[.05] px-2.5 py-1 text-[10px] font-semibold text-black/55 dark:bg-white/10 dark:text-white/60">
            {props.difficulty}
          </span>
        </div>
        {props.category && <p className="mt-5 text-[10px] font-bold uppercase tracking-[.12em] text-black/40 dark:text-white/40">{props.category}</p>}
        <h2 className="mt-2 text-lg font-bold leading-snug">{props.question || "La question apparaîtra ici."}</h2>

        <div className="mt-5 space-y-2.5">
          {props.options.length > 0 ? props.options.map((option, index) => {
            const isSelected = selected === option
            const isAnswer = option === props.answer
            return (
              <button
                key={`${option}-${index}`}
                type="button"
                onClick={() => setSelected(option)}
                className={cn(
                  "flex min-h-12 w-full cursor-pointer items-center gap-3 rounded-xl border px-3.5 py-2.5 text-left text-sm transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#1147D9]",
                  !corrected && "border-black/10 hover:border-[#1147D9]/45 hover:bg-[#1147D9]/[.04] dark:border-white/10",
                  corrected && isAnswer && "border-emerald-500/45 bg-emerald-500/10 text-emerald-800 dark:text-emerald-300",
                  corrected && isSelected && !isAnswer && "border-red-500/40 bg-red-500/10 text-red-700 dark:text-red-300",
                  corrected && !isSelected && !isAnswer && "border-black/5 opacity-55 dark:border-white/5",
                )}
              >
                {corrected && isAnswer ? <CheckCircle2 size={18} className="shrink-0" /> : <Circle size={18} className="shrink-0" />}
                <span>{option}</span>
              </button>
            )
          }) : <PreviewEmpty icon={<FileQuestion size={20} />} text="Ajoute au moins deux propositions." />}
        </div>

        {corrected && (
          <div className="mt-5 rounded-2xl bg-black/[.035] p-4 dark:bg-white/[.06]">
            <p className="text-xs font-bold">{selected === props.answer ? "Bonne réponse" : "Correction"}</p>
            {props.explanation ? <p className="mt-1.5 text-xs leading-relaxed text-black/60 dark:text-white/65">{props.explanation}</p> : <p className="mt-1.5 text-xs text-black/45 dark:text-white/45">Aucune explication renseignée.</p>}
            {props.legalRef && <p className="mt-2 text-[10px] font-medium text-[#1147D9]">{props.legalRef}</p>}
          </div>
        )}
      </div>
    </PreviewShell>
  )
}

function PreviewShell({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  const [viewport, setViewport] = useState<PreviewViewport>("mobile")

  return (
    <section id="apercu" className="overflow-hidden rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] shadow-sm">
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-[var(--outline-variant)] px-4 py-3.5">
        <div className="flex min-w-0 items-center gap-3">
          <span className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><Eye size={18} /></span>
          <div className="min-w-0">
            <h3 className="truncate text-sm font-semibold">{title}</h3>
            <p className="truncate text-[11px] text-[var(--on-surface-faint)]">{description}</p>
          </div>
        </div>
        <div className="flex rounded-xl bg-[var(--surface-container)] p-1" aria-label="Format de prévisualisation">
          {([
            ["mobile", Smartphone, "Téléphone"],
            ["web", Monitor, "Web"],
          ] as const).map(([value, Icon, label]) => (
            <button
              key={value}
              type="button"
              onClick={() => setViewport(value)}
              aria-pressed={viewport === value}
              title={label}
              className={cn(
                "flex min-h-9 cursor-pointer items-center gap-1.5 rounded-lg px-2.5 text-xs font-medium transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]",
                viewport === value ? "bg-[var(--surface)] text-[var(--brand)] shadow-sm" : "text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]",
              )}
            >
              <Icon size={15} /> <span className="hidden sm:inline">{label}</span>
            </button>
          ))}
        </div>
      </div>

      <div className="bg-[var(--surface-container)]/70 p-3 sm:p-6">
        <div className={cn("mx-auto transition-[max-width] duration-300 motion-reduce:transition-none", viewport === "mobile" ? "max-w-[390px]" : "max-w-5xl")}>
          <div className={cn("overflow-y-auto bg-[#f4f6fa] dark:bg-[#0d0f12]", viewport === "mobile" ? "max-h-[680px] rounded-[2rem] border-[7px] border-[#202329] p-2 shadow-xl" : "max-h-[720px] rounded-2xl border border-[var(--outline-variant)] p-4 shadow-sm sm:p-7")}>
            {children}
          </div>
        </div>
        <p className="mt-3 text-center text-[10px] font-medium text-[var(--on-surface-faint)]">Aperçu uniquement · aucune donnée n’est publiée</p>
      </div>
    </section>
  )
}

function MarkdownPreview({ markdown, accent }: { markdown: string; accent: string }) {
  const blocks = parseMarkdown(markdown)
  return <div className="space-y-3">{blocks.map((block, index) => renderBlock(block, index, accent))}</div>
}

type MarkdownBlock =
  | { kind: "heading"; level: number; text: string }
  | { kind: "paragraph"; text: string }
  | { kind: "quote"; text: string }
  | { kind: "list"; ordered: boolean; items: string[] }
  | { kind: "table"; rows: string[][] }
  | { kind: "separator" }
  | { kind: "image"; alt: string; source: string }

function parseMarkdown(markdown: string): MarkdownBlock[] {
  const lines = markdown.split("\n")
  const blocks: MarkdownBlock[] = []
  let index = 0
  while (index < lines.length) {
    const line = lines[index].trim()
    if (!line) { index += 1; continue }
    if (/^-{3,}$/.test(line)) { blocks.push({ kind: "separator" }); index += 1; continue }
    const image = line.match(/^!\[([^\]]*)\]\(\s*([^\s)]+)(?:\s+["'][^"']*["'])?\s*\)$/)
    if (image) { blocks.push({ kind: "image", alt: image[1].trim(), source: image[2].trim() }); index += 1; continue }
    const heading = line.match(/^(#{1,4})\s+(.+)$/)
    if (heading) { blocks.push({ kind: "heading", level: heading[1].length, text: heading[2] }); index += 1; continue }
    if (line.startsWith("> ")) { blocks.push({ kind: "quote", text: line.slice(2) }); index += 1; continue }
    if (line.startsWith("|")) {
      const rows: string[][] = []
      while (index < lines.length && lines[index].trim().startsWith("|")) {
        const current = lines[index].trim()
        if (!/^\|\s*([-:]+\s*\|)+\s*$/.test(current)) rows.push(current.split("|").slice(1, -1).map((cell) => cell.trim()))
        index += 1
      }
      blocks.push({ kind: "table", rows }); continue
    }
    const unordered = /^[-*]\s+/.test(line)
    const ordered = /^\d+\.\s+/.test(line)
    if (unordered || ordered) {
      const items: string[] = []
      const pattern = ordered ? /^\d+\.\s+/ : /^[-*]\s+/
      while (index < lines.length && pattern.test(lines[index].trim())) {
        items.push(lines[index].trim().replace(pattern, "")); index += 1
      }
      blocks.push({ kind: "list", ordered, items }); continue
    }
    const paragraph = [line]
    index += 1
    while (index < lines.length && lines[index].trim() && !/^(#{1,4})\s+|^>\s+|^\||^[-*]\s+|^\d+\.\s+|^-{3,}$|^!\[[^\]]*\]\(/.test(lines[index].trim())) {
      paragraph.push(lines[index].trim()); index += 1
    }
    blocks.push({ kind: "paragraph", text: paragraph.join(" ") })
  }
  return blocks
}

function renderBlock(block: MarkdownBlock, key: number, accent: string): ReactNode {
  if (block.kind === "image") {
    return (
      <figure key={key} className="overflow-hidden rounded-2xl border border-black/10 bg-black/[.025] dark:border-white/10 dark:bg-white/[.04]">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img src={block.source} alt={block.alt} loading="lazy" decoding="async" className="max-h-[420px] w-full object-cover" />
        {block.alt && <figcaption className="px-3.5 py-2.5 text-xs leading-relaxed text-black/55 dark:text-white/60">{block.alt}</figcaption>}
      </figure>
    )
  }
  if (block.kind === "heading") {
    const sizes = ["", "text-xl", "text-lg", "text-base", "text-sm"]
    return <h2 key={key} className={cn("font-bold leading-tight", sizes[block.level], block.level <= 2 && "pt-2")}>{renderInline(block.text)}</h2>
  }
  if (block.kind === "paragraph") return <p key={key} className="text-sm leading-7 text-black/65 dark:text-white/70">{renderInline(block.text)}</p>
  if (block.kind === "quote") return <blockquote key={key} className="rounded-r-xl border-l-4 bg-black/[.025] px-4 py-3 text-sm italic leading-relaxed text-black/60 dark:bg-white/[.04] dark:text-white/65" style={{ borderColor: accent }}>{renderInline(block.text)}</blockquote>
  if (block.kind === "separator") return <hr key={key} className="border-black/10 dark:border-white/10" />
  if (block.kind === "list") {
    const List = block.ordered ? "ol" : "ul"
    return <List key={key} className={cn("space-y-2 pl-5 text-sm leading-relaxed text-black/65 dark:text-white/70", block.ordered ? "list-decimal" : "list-disc")}>{block.items.map((item, index) => <li key={`${item}-${index}`}>{renderInline(item)}</li>)}</List>
  }
  if (block.rows.length === 0) return null
  return (
    <div key={key} className="overflow-x-auto rounded-xl border border-black/10 dark:border-white/10">
      <table className="w-full min-w-[420px] border-collapse text-left text-xs">
        <thead className="bg-black/[.04] dark:bg-white/[.06]"><tr>{block.rows[0].map((cell, index) => <th key={`${cell}-${index}`} className="px-3 py-2.5 font-bold">{renderInline(cell)}</th>)}</tr></thead>
        <tbody>{block.rows.slice(1).map((row, rowIndex) => <tr key={rowIndex} className="border-t border-black/10 dark:border-white/10">{row.map((cell, cellIndex) => <td key={`${cell}-${cellIndex}`} className="px-3 py-2.5 text-black/60 dark:text-white/65">{renderInline(cell)}</td>)}</tr>)}</tbody>
      </table>
    </div>
  )
}

function renderInline(text: string): ReactNode[] {
  const parts = text.split(/(\*\*.+?\*\*|`.+?`|\*.+?\*)/g).filter(Boolean)
  return parts.map((part, index) => {
    if (part.startsWith("**") && part.endsWith("**")) return <strong key={index}>{part.slice(2, -2)}</strong>
    if (part.startsWith("`") && part.endsWith("`")) return <code key={index} className="rounded bg-black/[.06] px-1.5 py-0.5 text-[.85em] text-[#1147D9] dark:bg-white/10">{part.slice(1, -1)}</code>
    if (part.startsWith("*") && part.endsWith("*")) return <em key={index}>{part.slice(1, -1)}</em>
    return <Fragment key={index}>{part}</Fragment>
  })
}

function PreviewEmpty({ icon, text }: { icon: ReactNode; text: string }) {
  return <div className="grid min-h-32 place-items-center rounded-2xl border border-dashed border-black/15 p-5 text-center text-black/40 dark:border-white/15 dark:text-white/40"><div><span className="mx-auto mb-2 grid h-9 w-9 place-items-center rounded-full bg-black/[.04] dark:bg-white/[.06]">{icon}</span><p className="text-xs">{text}</p></div></div>
}

function safeColor(value: string): string {
  return /^#[0-9a-f]{6}$/i.test(value) ? value : "#1147D9"
}
