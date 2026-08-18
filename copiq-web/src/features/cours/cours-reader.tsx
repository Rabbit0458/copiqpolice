"use client"
import { useEffect, useRef, useState } from "react"
import { CourseModule, CourseSection } from "@/data/modules"
import { Crown, ChevronDown, Check, ArrowLeft, ArrowRight, RotateCcw, BookOpen, Layers, Zap } from "lucide-react"
import type { LucideIcon } from "lucide-react"
import Link from "next/link"

// ─── Extended types (flashcards & keyPoints are optional additions) ────────────

interface Flashcard {
  question: string
  answer: string
}

interface RichSection {
  id: string
  title: string
  content: string
  flashcards?: Flashcard[]
  keyPoints?: string[]
}

type ViewMode = "cours" | "flashcards" | "keypoints"

interface Props {
  module: CourseModule
  tier: string
  userEmail?: string
}

// ─── Root Component ───────────────────────────────────────────────────────────

export default function CoursReader({ module, tier, userEmail }: Props) {
  const contentRef = useRef<HTMLDivElement>(null)
  const isPremiumUser = tier === "premium" || tier === "premium_trial"
  const isLocked = module.isPremium && !isPremiumUser

  const [viewMode, setViewMode] = useState<ViewMode>("cours")

  // Security: disable copy / right-click
  useEffect(() => {
    if (!contentRef.current || isLocked) return
    const el = contentRef.current
    const noCtx = (e: MouseEvent) => e.preventDefault()
    const noKeys = (e: KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && ["c", "a", "s", "p", "u"].includes(e.key.toLowerCase())) {
        e.preventDefault()
      }
    }
    el.addEventListener("contextmenu", noCtx)
    document.addEventListener("keydown", noKeys)
    return () => {
      el.removeEventListener("contextmenu", noCtx)
      document.removeEventListener("keydown", noKeys)
    }
  }, [isLocked])

  // ── Premium lock ──────────────────────────────────────────────────────────
  if (isLocked) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-center px-4">
        <div className="w-16 h-16 rounded-2xl bg-[#EAB308]/10 flex items-center justify-center mb-4">
          <Crown size={28} className="text-[#EAB308]" />
        </div>
        <h2 className="text-xl font-bold text-[var(--on-surface)] mb-2">Contenu Premium</h2>
        <p className="text-[var(--on-surface-muted)] mb-6 max-w-sm">
          Ce module est réservé aux membres Premium. Débloquez l&apos;accès à tous les cours et cas pratiques.
        </p>
        <Link
          href="/abonnement"
          className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-[#1147D9] text-white font-semibold hover:bg-[#1A55E6] transition-all"
        >
          <Crown size={16} /> Passer Premium
        </Link>
      </div>
    )
  }

  const richSections = module.sections as unknown as RichSection[]
  const allFlashcards: Flashcard[] = richSections.flatMap(s => s.flashcards ?? [])
  const allKeyPoints = richSections.flatMap(s =>
    (s.keyPoints ?? []).map(kp => ({ text: kp, sectionTitle: s.title, sectionId: s.id }))
  )

  const modes: { id: ViewMode; label: string; icon: LucideIcon }[] = [
    { id: "cours",      label: "Cours",      icon: BookOpen },
    { id: "flashcards", label: "Flashcards",  icon: Layers   },
    { id: "keypoints",  label: "Points clés", icon: Zap      },
  ]

  return (
    <div ref={contentRef} className="relative select-none">

      {/* ── Watermark overlay ── */}
      <WatermarkOverlay email={userEmail} />

      {/* ── Mode selector ── */}
      <div className="flex items-center gap-1 mb-5 p-1 rounded-xl bg-[var(--surface-dark)] border border-[var(--outline)]">
        {modes.map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            onClick={() => setViewMode(id)}
            className={`flex-1 flex items-center justify-center gap-2 py-2.5 px-2 rounded-lg text-sm font-medium transition-all ${
              viewMode === id
                ? "bg-[#1147D9] text-white shadow-sm"
                : "text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] hover:bg-[var(--surface)]"
            }`}
          >
            <Icon size={14} />
            <span className="hidden sm:inline">{label}</span>
            <span className="sm:hidden text-xs">{label.split(" ")[0]}</span>
          </button>
        ))}
      </div>

      {/* ── Content area ── */}
      <div className="relative rounded-xl border border-[var(--outline)] bg-[var(--surface)] overflow-hidden">
        {viewMode === "cours"      && <CoursMode sections={richSections} />}
        {viewMode === "flashcards" && <FlashcardsMode flashcards={allFlashcards} />}
        {viewMode === "keypoints"  && <KeyPointsMode keyPoints={allKeyPoints} />}
      </div>
    </div>
  )
}

// ─── Watermark overlay ────────────────────────────────────────────────────────

function WatermarkOverlay({ email }: { email?: string }) {
  const label = email ?? "COP'IQ POLICE"
  return (
    <div
      aria-hidden="true"
      className="pointer-events-none absolute inset-0 overflow-hidden z-10 select-none"
      style={{ opacity: 0.04 }}
    >
      {Array.from({ length: 40 }).map((_, i) => (
        <div
          key={i}
          className="absolute text-[11px] font-medium text-[var(--on-surface)] whitespace-nowrap"
          style={{
            top:       `${(i % 8) * 130}px`,
            left:      `${Math.floor(i / 8) * 240 - 40}px`,
            transform: "rotate(-28deg)",
          }}
        >
          {label}
        </div>
      ))}
    </div>
  )
}

// ─── MODE 1 — Cours (accordéons) ─────────────────────────────────────────────

function CoursMode({ sections }: { sections: RichSection[] }) {
  const [readSections, setReadSections] = useState<Set<string>>(new Set())
  const [expandedId, setExpandedId]     = useState<string>(sections[0]?.id ?? "")
  const [activeTab, setActiveTab]       = useState<string>(sections[0]?.id ?? "")

  const progressPct = sections.length > 0
    ? Math.round((readSections.size / sections.length) * 100)
    : 0

  const toggleRead = (id: string) =>
    setReadSections(prev => {
      const next = new Set(prev)
      next.has(id) ? next.delete(id) : next.add(id)
      return next
    })

  const goToSection = (id: string) => {
    setActiveTab(id)
    setExpandedId(id)
  }

  return (
    <div>
      {/* Progress bar */}
      <div className="px-4 pt-4 pb-3 border-b border-[var(--outline)]">
        <div className="flex items-center justify-between mb-1.5">
          <span className="text-xs font-medium text-[var(--on-surface-muted)]">Progression</span>
          <span className="text-xs font-semibold text-[#1147D9]">{progressPct}%</span>
        </div>
        <div className="h-1.5 rounded-full bg-[var(--outline)] overflow-hidden">
          <div
            className="h-full rounded-full bg-gradient-to-r from-[#1147D9] to-[#8B5CF6] transition-all duration-500"
            style={{ width: `${progressPct}%` }}
          />
        </div>
        <p className="text-xs text-[var(--on-surface-muted)] mt-1.5">
          {readSections.size}/{sections.length} section{sections.length > 1 ? "s" : ""} lue{readSections.size > 1 ? "s" : ""}
        </p>
      </div>

      {/* Tab pills (section nav) */}
      {sections.length > 1 && (
        <div className="px-4 py-3 overflow-x-auto border-b border-[var(--outline)]">
          <div className="flex gap-2 min-w-max">
            {sections.map(s => (
              <button
                key={s.id}
                onClick={() => goToSection(s.id)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-all border ${
                  activeTab === s.id
                    ? "bg-[#1147D9]/10 border-[#1147D9]/50 text-[#1147D9]"
                    : "bg-transparent border-[var(--outline)] text-[var(--on-surface-muted)] hover:border-[#1147D9]/30 hover:text-[var(--on-surface)]"
                }`}
              >
                {readSections.has(s.id) && (
                  <span className="w-3.5 h-3.5 rounded-full bg-green-500 flex items-center justify-center flex-shrink-0">
                    <Check size={8} className="text-white" />
                  </span>
                )}
                {s.title}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Accordions */}
      <div className="divide-y divide-[var(--outline)]">
        {sections.map(section => (
          <SectionAccordion
            key={section.id}
            section={section}
            isExpanded={expandedId === section.id}
            isRead={readSections.has(section.id)}
            onToggle={() => {
              setExpandedId(prev => prev === section.id ? "" : section.id)
              setActiveTab(section.id)
            }}
            onMarkRead={() => toggleRead(section.id)}
          />
        ))}
      </div>
    </div>
  )
}

function SectionAccordion({
  section, isExpanded, isRead, onToggle, onMarkRead,
}: {
  section: RichSection
  isExpanded: boolean
  isRead: boolean
  onToggle: () => void
  onMarkRead: () => void
}) {
  return (
    <div>
      {/* Header */}
      <button
        onClick={onToggle}
        className="w-full flex items-center justify-between px-4 py-3.5 text-left hover:bg-[var(--surface-dark)]/40 transition-colors group"
      >
        <div className="flex items-center gap-3">
          <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center flex-shrink-0 transition-all ${
            isRead
              ? "bg-green-500 border-green-500"
              : "border-[var(--outline)] group-hover:border-[#1147D9]/50"
          }`}>
            {isRead && <Check size={9} className="text-white" strokeWidth={3} />}
          </div>
          <span className="text-sm font-semibold text-[var(--on-surface)]">{section.title}</span>
        </div>
        <div className={`transition-transform duration-200 flex-shrink-0 ml-2 ${isExpanded ? "rotate-180" : ""}`}>
          <ChevronDown size={15} className="text-[var(--on-surface-muted)]" />
        </div>
      </button>

      {/* Content */}
      {isExpanded && (
        <div className="px-4 pb-5">
          <div
            dangerouslySetInnerHTML={{ __html: markdownToHtml(section.content) }}
          />
          <div className="mt-5 pt-4 border-t border-[var(--outline)] flex justify-end">
            <button
              onClick={onMarkRead}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-xs font-medium transition-all ${
                isRead
                  ? "bg-green-500/10 text-green-500 hover:bg-green-500/20 border border-green-500/30"
                  : "bg-[#1147D9]/10 text-[#1147D9] hover:bg-[#1147D9]/20 border border-[#1147D9]/30"
              }`}
            >
              <Check size={11} strokeWidth={2.5} />
              {isRead ? "Section lue ✓" : "Marquer comme lu"}
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

// ─── MODE 2 — Flashcards ─────────────────────────────────────────────────────

function FlashcardsMode({ flashcards }: { flashcards: Flashcard[] }) {
  const [currentIdx, setCurrentIdx] = useState(0)
  const [isFlipped,  setIsFlipped]  = useState(false)
  const [mastered,   setMastered]   = useState<Set<number>>(new Set())
  const [toReview,   setToReview]   = useState<Set<number>>(new Set())

  if (flashcards.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-16 px-4 text-center">
        <div className="w-14 h-14 rounded-2xl bg-[#8B5CF6]/10 flex items-center justify-center mb-4">
          <Layers size={24} className="text-[#8B5CF6]" />
        </div>
        <p className="font-semibold text-[var(--on-surface)] mb-1">Pas de flashcards disponibles</p>
        <p className="text-sm text-[var(--on-surface-muted)]">
          Les flashcards seront ajoutées prochainement pour ce module.
        </p>
      </div>
    )
  }

  const current = flashcards[currentIdx]

  const goTo = (idx: number) => {
    setIsFlipped(false)
    setTimeout(() => setCurrentIdx(idx), 50)
  }

  const handlePrev = () => goTo((currentIdx - 1 + flashcards.length) % flashcards.length)
  const handleNext = () => goTo((currentIdx + 1) % flashcards.length)

  const handleMastered = () => {
    setMastered(prev => new Set([...prev, currentIdx]))
    setToReview(prev => { const n = new Set(prev); n.delete(currentIdx); return n })
    handleNext()
  }

  const handleToReview = () => {
    setToReview(prev => new Set([...prev, currentIdx]))
    setMastered(prev => { const n = new Set(prev); n.delete(currentIdx); return n })
    handleNext()
  }

  const reset = () => {
    setCurrentIdx(0)
    setIsFlipped(false)
    setMastered(new Set())
    setToReview(new Set())
  }

  return (
    <div className="p-4 space-y-4">
      {/* Score row */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <span className="flex items-center gap-1.5 text-sm text-[var(--on-surface-muted)]">
            <span className="w-2 h-2 rounded-full bg-green-500 inline-block" />
            <span className="font-semibold text-green-500">{mastered.size}</span>/{flashcards.length} maîtrisées
          </span>
          {toReview.size > 0 && (
            <span className="flex items-center gap-1.5 text-sm text-[var(--on-surface-muted)]">
              <span className="w-2 h-2 rounded-full bg-orange-400 inline-block" />
              <span className="font-semibold text-orange-400">{toReview.size}</span> à revoir
            </span>
          )}
        </div>
        <button
          onClick={reset}
          className="flex items-center gap-1.5 text-xs text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] transition-colors"
        >
          <RotateCcw size={11} />
          Recommencer
        </button>
      </div>

      {/* Progress dots */}
      <div className="flex gap-1 flex-wrap">
        {flashcards.map((_, i) => (
          <button
            key={i}
            onClick={() => goTo(i)}
            className={`h-1.5 rounded-full transition-all ${
              i === currentIdx  ? "w-6 bg-[#1147D9]"   :
              mastered.has(i)   ? "w-1.5 bg-green-500"  :
              toReview.has(i)   ? "w-1.5 bg-orange-400" :
              "w-1.5 bg-[var(--outline)]"
            }`}
            aria-label={`Carte ${i + 1}`}
          />
        ))}
      </div>

      {/* Flip card */}
      <div
        className="relative cursor-pointer"
        style={{ perspective: "1200px", height: "220px" }}
        onClick={() => setIsFlipped(f => !f)}
      >
        <div
          style={{
            transformStyle: "preserve-3d",
            transform:      isFlipped ? "rotateY(180deg)" : "rotateY(0deg)",
            transition:     "transform 0.45s ease",
            position:       "relative",
            height:         "100%",
            width:          "100%",
          }}
        >
          {/* Front — question */}
          <div
            className="absolute inset-0 rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-5 flex flex-col items-center justify-center text-center"
            style={{
              backfaceVisibility:       "hidden",
              WebkitBackfaceVisibility: "hidden",
            } as React.CSSProperties}
          >
            <span className="text-xs font-semibold text-[#1147D9] uppercase tracking-widest mb-3">
              Question
            </span>
            <p className="text-[var(--on-surface)] font-semibold text-sm sm:text-base leading-relaxed">
              {current.question}
            </p>
            <span className="text-xs text-[var(--on-surface-muted)] mt-4">
              Cliquez pour voir la réponse →
            </span>
          </div>

          {/* Back — answer */}
          <div
            className="absolute inset-0 rounded-xl border border-[#8B5CF6]/40 bg-[#8B5CF6]/5 p-5 flex flex-col items-center justify-center text-center"
            style={{
              backfaceVisibility:       "hidden",
              WebkitBackfaceVisibility: "hidden",
              transform:                "rotateY(180deg)",
            } as React.CSSProperties}
          >
            <span className="text-xs font-semibold text-[#8B5CF6] uppercase tracking-widest mb-3">
              Réponse
            </span>
            <p className="text-[var(--on-surface)] text-sm leading-relaxed">
              {current.answer}
            </p>
          </div>
        </div>
      </div>

      {/* Prev / Next navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={handlePrev}
          className="w-10 h-10 rounded-xl border border-[var(--outline)] flex items-center justify-center text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] hover:border-[#1147D9]/40 transition-all"
          aria-label="Précédent"
        >
          <ArrowLeft size={15} />
        </button>
        <span className="text-sm font-medium text-[var(--on-surface-muted)]">
          {currentIdx + 1} / {flashcards.length}
        </span>
        <button
          onClick={handleNext}
          className="w-10 h-10 rounded-xl border border-[var(--outline)] flex items-center justify-center text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] hover:border-[#1147D9]/40 transition-all"
          aria-label="Suivant"
        >
          <ArrowRight size={15} />
        </button>
      </div>

      {/* Action buttons — visible only when card is flipped */}
      {isFlipped && (
        <div className="flex gap-3 pt-1">
          <button
            onClick={e => { e.stopPropagation(); handleToReview() }}
            className="flex-1 py-2.5 rounded-xl border border-orange-400/40 text-orange-500 text-sm font-medium hover:bg-orange-400/10 transition-all"
          >
            À revoir
          </button>
          <button
            onClick={e => { e.stopPropagation(); handleMastered() }}
            className="flex-1 py-2.5 rounded-xl bg-green-500/10 border border-green-500/40 text-green-600 text-sm font-medium hover:bg-green-500/20 transition-all"
          >
            Je savais ✓
          </button>
        </div>
      )}
    </div>
  )
}

// ─── MODE 3 — Points clés ────────────────────────────────────────────────────

interface KeyPoint {
  text: string
  sectionTitle: string
  sectionId: string
}

function KeyPointsMode({ keyPoints }: { keyPoints: KeyPoint[] }) {
  const [checked, setChecked] = useState<Set<number>>(new Set())

  const toggleItem = (i: number) =>
    setChecked(prev => {
      const n = new Set(prev)
      n.has(i) ? n.delete(i) : n.add(i)
      return n
    })

  const toggleAll = () =>
    setChecked(prev =>
      prev.size === keyPoints.length
        ? new Set()
        : new Set(keyPoints.map((_, i) => i))
    )

  if (keyPoints.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center py-16 px-4 text-center">
        <div className="w-14 h-14 rounded-2xl bg-[#EAB308]/10 flex items-center justify-center mb-4">
          <Zap size={24} className="text-[#EAB308]" />
        </div>
        <p className="font-semibold text-[var(--on-surface)] mb-1">Pas de points clés disponibles</p>
        <p className="text-sm text-[var(--on-surface-muted)]">
          Les points clés seront ajoutés prochainement pour ce module.
        </p>
      </div>
    )
  }

  const allChecked = checked.size === keyPoints.length

  return (
    <div className="p-4 space-y-3">
      {/* Header */}
      <div className="flex items-center justify-between">
        <span className="text-sm font-semibold text-[var(--on-surface)]">
          {keyPoints.length} point{keyPoints.length > 1 ? "s" : ""} clé{keyPoints.length > 1 ? "s" : ""}
        </span>
        <button
          onClick={toggleAll}
          className="text-xs font-medium text-[#1147D9] hover:underline underline-offset-2"
        >
          {allChecked ? "Tout décocher" : "Tout cocher"}
        </button>
      </div>

      {/* List */}
      <div className="space-y-2">
        {keyPoints.map((kp, i) => (
          <button
            key={i}
            onClick={() => toggleItem(i)}
            className={`w-full flex items-start gap-3 p-3 rounded-xl border text-left transition-all ${
              checked.has(i)
                ? "border-green-500/40 bg-green-500/5"
                : "border-[var(--outline)] bg-transparent hover:border-[#1147D9]/30 hover:bg-[var(--surface-dark)]/30"
            }`}
          >
            <div className={`mt-0.5 w-5 h-5 rounded-full border-2 flex-shrink-0 flex items-center justify-center transition-all ${
              checked.has(i) ? "bg-green-500 border-green-500" : "border-[var(--outline)]"
            }`}>
              {checked.has(i) && <Check size={9} className="text-white" strokeWidth={3} />}
            </div>
            <div className="flex-1 min-w-0">
              <p className={`text-sm leading-relaxed transition-colors ${
                checked.has(i)
                  ? "text-[var(--on-surface-muted)] line-through decoration-green-500/60"
                  : "text-[var(--on-surface)]"
              }`}>
                {kp.text}
              </p>
              <span className="inline-block mt-1.5 px-2 py-0.5 rounded-full text-xs font-medium bg-[#1147D9]/10 text-[#1147D9] border border-[#1147D9]/20">
                {kp.sectionTitle}
              </span>
            </div>
          </button>
        ))}
      </div>

      {/* Footer progress */}
      {checked.size > 0 && (
        <p className="text-center text-xs text-[var(--on-surface-muted)] pt-1">
          {checked.size}/{keyPoints.length} points maîtrisés 🎯
        </p>
      )}
    </div>
  )
}

// ─── Markdown renderer (no external deps) ────────────────────────────────────

function applyInline(text: string): string {
  return text
    .replace(/\*\*(.+?)\*\*/g, '<strong class="font-semibold text-[var(--on-surface)]">$1</strong>')
    .replace(/\*(.+?)\*/g,     '<em class="italic text-[var(--on-surface-muted)]">$1</em>')
    .replace(/`(.+?)`/g,       '<code class="px-1.5 py-0.5 rounded bg-[var(--surface-dark)] text-[#1147D9] text-[0.8em] font-mono">$1</code>')
}

function isSeparatorRow(line: string): boolean {
  return /^\|\s*([-:]+\s*\|)+\s*$/.test(line.trim())
}

function renderTable(lines: string[]): string {
  const dataLines = lines.filter(l => !isSeparatorRow(l))
  if (dataLines.length === 0) return ""

  const parseCells = (line: string) =>
    line.split("|").slice(1, -1).map(c => c.trim())

  const [headerLine, ...bodyLines] = dataLines

  let html = '<div class="overflow-x-auto my-4 rounded-xl border border-[var(--outline)]">'
  html +=    '<table class="w-full text-sm border-collapse">'
  html +=    '<thead><tr class="bg-[var(--surface-dark)] border-b border-[var(--outline)]">'
  parseCells(headerLine).forEach(h => {
    html += `<th class="px-3 py-2.5 text-left text-xs font-semibold text-[var(--on-surface)] uppercase tracking-wide">${applyInline(h)}</th>`
  })
  html += "</tr></thead><tbody>"

  bodyLines.forEach((line, idx) => {
    if (isSeparatorRow(line)) return
    html += `<tr class="border-b border-[var(--outline)] ${idx % 2 === 1 ? "bg-[var(--surface-dark)]/25" : ""}">`
    parseCells(line).forEach(cell => {
      html += `<td class="px-3 py-2 text-xs text-[var(--on-surface-muted)]">${applyInline(cell)}</td>`
    })
    html += "</tr>"
  })

  html += "</tbody></table></div>"
  return html
}

function markdownToHtml(md: string): string {
  const lines = md.split("\n")
  let html = ""
  let i = 0

  while (i < lines.length) {
    const line = lines[i]

    // Empty line → skip
    if (line.trim() === "") { i++; continue }

    // H4
    if (line.startsWith("#### ")) {
      html += `<h4 class="text-sm font-semibold text-[var(--on-surface)] mt-4 mb-1">${applyInline(line.slice(5))}</h4>`
      i++; continue
    }

    // H3
    if (line.startsWith("### ")) {
      html += `<h3 class="text-base font-bold text-[var(--on-surface)] mt-5 mb-2 pb-1 border-b border-[var(--outline)]">${applyInline(line.slice(4))}</h3>`
      i++; continue
    }

    // H2
    if (line.startsWith("## ")) {
      html += `<h2 class="text-lg font-bold text-[var(--on-surface)] mt-6 mb-3">${applyInline(line.slice(3))}</h2>`
      i++; continue
    }

    // H1
    if (line.startsWith("# ")) {
      html += `<h1 class="text-xl font-bold text-[var(--on-surface)] mb-4">${applyInline(line.slice(2))}</h1>`
      i++; continue
    }

    // Blockquote
    if (line.startsWith("> ")) {
      html += `<div class="border-l-4 border-[#1147D9] pl-4 py-2 bg-[#1147D9]/5 rounded-r-lg my-3"><p class="text-sm text-[var(--on-surface-muted)] italic leading-relaxed">${applyInline(line.slice(2))}</p></div>`
      i++; continue
    }

    // Table
    if (line.startsWith("|")) {
      const tableLines: string[] = []
      while (i < lines.length && lines[i].startsWith("|")) {
        tableLines.push(lines[i])
        i++
      }
      html += renderTable(tableLines)
      continue
    }

    // Unordered list — collect consecutive items
    if (line.startsWith("- ")) {
      const items: string[] = []
      while (i < lines.length && lines[i].startsWith("- ")) {
        items.push(lines[i].slice(2))
        i++
      }
      html += `<ul class="my-3 space-y-1.5">${items.map(item =>
        `<li class="flex items-start gap-2 text-sm text-[var(--on-surface-muted)] leading-relaxed">` +
        `<span class="mt-2 w-1.5 h-1.5 rounded-full bg-[#1147D9]/60 flex-shrink-0"></span>` +
        `<span>${applyInline(item)}</span></li>`
      ).join("")}</ul>`
      continue
    }

    // Paragraph
    html += `<p class="text-sm text-[var(--on-surface-muted)] leading-relaxed my-2">${applyInline(line)}</p>`
    i++
  }

  return html
}
