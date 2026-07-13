"use client"
import { useEffect, useRef } from "react"
import { CourseModule, CourseSection } from "@/data/modules"
import { Crown, Lock } from "lucide-react"
import Link from "next/link"

interface Props {
  module: CourseModule
  tier: string
  userEmail?: string
}

export default function CoursReader({ module, tier, userEmail }: Props) {
  const contentRef = useRef<HTMLDivElement>(null)
  const isPremium = tier === "premium" || tier === "premium_trial"
  const isLocked = module.isPremium && !isPremium

  useEffect(() => {
    if (!contentRef.current || isLocked) return
    const el = contentRef.current
    // Disable right-click
    const noCtx = (e: MouseEvent) => e.preventDefault()
    // Disable copy keyboard shortcuts
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

  if (isLocked) {
    return (
      <div className="flex flex-col items-center justify-center py-20 text-center px-4">
        <div className="w-16 h-16 rounded-2xl bg-[#EAB308]/10 flex items-center justify-center mb-4">
          <Crown size={28} className="text-[#EAB308]" />
        </div>
        <h2 className="text-xl font-bold text-[var(--on-surface)] mb-2">Contenu Premium</h2>
        <p className="text-[var(--on-surface-muted)] mb-6 max-w-sm">Ce module est réservé aux membres Premium. Débloquez l'accès à tous les cours et cas pratiques.</p>
        <Link href="/abonnement" className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-[#1147D9] text-white font-semibold hover:bg-[#1A55E6] transition-all">
          <Crown size={16} /> Passer Premium
        </Link>
      </div>
    )
  }

  return (
    <div
      ref={contentRef}
      className="course-content watermark-container"
      data-watermark={userEmail ?? "COP'IQ"}
    >
      {module.sections.map((section, idx) => (
        <CoursSection key={section.id} section={section} index={idx} isFirst={idx === 0} />
      ))}
    </div>
  )
}

function CoursSection({ section, index, isFirst }: { section: CourseSection; index: number; isFirst: boolean }) {
  return (
    <article className={`prose prose-sm max-w-none ${!isFirst ? "mt-10 pt-10 border-t border-[var(--outline)]" : ""}`}>
      <div dangerouslySetInnerHTML={{ __html: markdownToHtml(section.content) }} className="text-[var(--on-surface)]" />
    </article>
  )
}

// Simple markdown → HTML (for SSR-free rendering)
function markdownToHtml(md: string): string {
  return md
    .replace(/^### (.+)$/gm, '<h3 class="text-base font-semibold text-[var(--on-surface)] mt-6 mb-2">$1</h3>')
    .replace(/^## (.+)$/gm, '<h2 class="text-lg font-bold text-[var(--on-surface)] mt-8 mb-3">$1</h2>')
    .replace(/^# (.+)$/gm, '<h1 class="text-xl font-bold text-[var(--on-surface)] mb-4">$1</h1>')
    .replace(/\*\*(.+?)\*\*/g, '<strong class="text-[var(--on-surface)] font-semibold">$1</strong>')
    .replace(/\*(.+?)\*/g, '<em>$1</em>')
    .replace(/`(.+?)`/g, '<code class="px-1.5 py-0.5 rounded bg-[var(--surface-dark)] text-[#1147D9] text-xs font-mono">$1</code>')
    .replace(/^> (.+)$/gm, '<blockquote class="border-l-4 border-[#1147D9] pl-4 py-2 bg-[#1147D9]/5 rounded-r-lg my-4 text-sm italic">$1</blockquote>')
    .replace(/^\| (.+) \|$/gm, '<tr class="border-b border-[var(--outline)]"><td class="px-3 py-2 text-sm">$1</td></tr>')
    .replace(/^- (.+)$/gm, '<li class="text-sm text-[var(--on-surface-muted)] leading-relaxed">$1</li>')
    .replace(/\n\n/g, '</p><p class="text-sm text-[var(--on-surface-muted)] leading-relaxed my-3">')
    .replace(/^(?!<)(.+)$/gm, '<p class="text-sm text-[var(--on-surface-muted)] leading-relaxed my-3">$1</p>')
}
