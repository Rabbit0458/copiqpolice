"use client"

import Link from "next/link"
import type { LucideIcon } from "lucide-react"
import { ArrowLeft, ArrowRight, BookOpen, Crown, Layers, Smartphone, Zap } from "lucide-react"
import type { ReactNode } from "react"
import { cn } from "@/lib/utils"
import { imgUrl, type Leaf } from "@/features/parcours/tree"

/**
 * Briques visuelles partagées de l'espace connecté (v6).
 * Un seul en-tête image pour toutes les pages de contenu (catégorie, cours,
 * quiz), les mêmes cartes de module que l'app (_ModuleCard) et une liste
 * sommaire quand les modules n'ont pas d'image propre.
 */

export function PageHero({
  image,
  back,
  eyebrow,
  title,
  subtitle,
  chips = [],
  action,
}: {
  image: string | null | undefined
  back: { href: string; label: string }
  eyebrow?: string
  title: string
  subtitle?: string | null
  chips?: { icon: LucideIcon; label: string }[]
  action?: ReactNode
}) {
  const src = imgUrl(image)
  return (
    <section className="cq-page-hero relative isolate flex min-h-[236px] flex-col overflow-hidden rounded-[28px] bg-[#1A1C21] text-white sm:min-h-[264px]">
      {src && (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={src} alt="" className="cq-page-hero-img absolute inset-0 -z-10 h-full w-full object-cover" />
      )}
      <span
        className="absolute inset-0 -z-10 bg-[linear-gradient(90deg,rgba(12,13,16,.9)_0%,rgba(12,13,16,.72)_42%,rgba(12,13,16,.28)_100%)] sm:bg-[linear-gradient(90deg,rgba(12,13,16,.88)_0%,rgba(12,13,16,.6)_45%,rgba(12,13,16,.08)_100%)]"
        aria-hidden="true"
      />
      <span className="absolute inset-x-0 bottom-0 -z-10 h-2/3 bg-[linear-gradient(to_top,rgba(12,13,16,.55),transparent)]" aria-hidden="true" />

      <div className="flex flex-1 flex-col p-5 sm:p-8 lg:p-9">
        <Link href={back.href} className="cq-glass inline-flex h-9 w-fit max-w-full items-center gap-1.5 rounded-full pl-2.5 pr-3.5 text-[13px] font-semibold text-white transition hover:bg-white/25">
          <ArrowLeft className="h-4 w-4 shrink-0" aria-hidden="true" />
          <span className="truncate">{back.label}</span>
        </Link>
        <div className="mt-auto flex flex-col gap-5 pt-10 md:flex-row md:items-end md:justify-between">
          <div className="cq-page-hero-text min-w-0 max-w-[44rem]">
            {eyebrow && <p className="text-[13px] font-semibold tracking-[0.01em] text-white/75">{eyebrow}</p>}
            <h1 className="mt-1.5 text-[clamp(1.65rem,3.1vw,2.55rem)] font-extrabold leading-[1.05] tracking-[-0.03em] [text-wrap:balance]">{title}</h1>
            {subtitle && <p className="mt-2 max-w-[36rem] text-[15px] leading-snug text-white/80">{subtitle}</p>}
            {chips.length > 0 && (
              <div className="mt-4 flex flex-wrap gap-2">
                {chips.map(({ icon: Icon, label }) => (
                  <span key={label} className="cq-glass inline-flex h-8 items-center gap-1.5 rounded-full px-3 text-[12.5px] font-semibold text-white">
                    <Icon className="h-3.5 w-3.5" aria-hidden="true" /> {label}
                  </span>
                ))}
              </div>
            )}
          </div>
          {action && <div className="shrink-0">{action}</div>}
        </div>
      </div>
    </section>
  )
}

/** Bouton blanc posé sur un bandeau image (même langage que le CTA « Découvrir »). */
export function HeroAction({ href, children }: { href: string; children: ReactNode }) {
  return (
    <Link
      href={href}
      className="group inline-flex h-12 items-center gap-3 rounded-[18px] bg-white pl-5 pr-2 text-[14.5px] font-bold text-[#1C1C1C] shadow-[0_18px_40px_-20px_rgba(0,0,0,.8)] transition hover:-translate-y-0.5"
    >
      {children}
      <span className="grid h-8 w-8 place-items-center rounded-full bg-[#1C1C1C] text-white transition-transform duration-500 group-hover:translate-x-0.5">
        <ArrowRight className="h-4 w-4" aria-hidden="true" />
      </span>
    </Link>
  )
}

export function SectionTitle({ title, aside, className }: { title: string; aside?: ReactNode; className?: string }) {
  return (
    <div className={cn("flex items-end justify-between gap-3", className)}>
      <h2 className="text-[19px] font-extrabold tracking-[-0.015em] text-[var(--on-surface)]">{title}</h2>
      {aside && <div className="text-[13.5px] font-semibold text-[var(--on-surface-faint)]">{aside}</div>}
    </div>
  )
}

export function leafKind(leaf: Leaf): { icon: LucideIcon; label: string } {
  if (leaf.kind === "group") {
    const n = leaf.children.filter((c) => c.kind !== "quiz" && c.kind !== "cg").length
    const q = leaf.children.length - n
    return { icon: Layers, label: `${n} cours${q ? ` · ${q} quiz` : ""}` }
  }
  if (leaf.kind === "course") return { icon: BookOpen, label: "Cours" }
  if (leaf.kind === "app") return { icon: Smartphone, label: "Bientôt sur le site" }
  return { icon: Zap, label: "Quiz" }
}

/** Carte module de l'app (_ModuleCard) : image, voile, badge, titre, CTA rond. */
export function ModuleCard({ href, leaf, index, locked }: { href: string; leaf: Leaf; index: number; locked?: boolean }) {
  const src = imgUrl(leaf.image)
  const kind = leafKind(leaf)
  const soon = leaf.kind === "app"
  return (
    <Link href={href} className={cn("cq-module-card group relative flex h-[212px] flex-col overflow-hidden rounded-[22px] bg-[#1A1C21] p-4 text-white", soon && "is-soon")}>
      {src && (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={src} alt="" loading="lazy" className="cq-module-img absolute inset-0 -z-0 h-full w-full object-cover" />
      )}
      <span className="absolute inset-0 bg-[linear-gradient(to_bottom,rgba(0,0,0,.12),rgba(0,0,0,.5)_52%,rgba(0,0,0,.82))]" aria-hidden="true" />
      <span className="relative flex items-start justify-between gap-2">
        <span className="cq-glass inline-flex h-7 items-center rounded-full px-2.5 text-[12px] font-bold">Module {index}</span>
        {locked ? (
          <span className="inline-flex h-7 items-center gap-1 rounded-full bg-black/45 px-2.5 text-[12px] font-bold ring-1 ring-white/20">
            <Crown className="h-3.5 w-3.5 text-[#FBBF24]" aria-hidden="true" /> Premium
          </span>
        ) : (
          <span className="cq-glass inline-flex h-7 items-center gap-1.5 rounded-full px-2.5 text-[12px] font-semibold">
            <kind.icon className="h-3.5 w-3.5" aria-hidden="true" /> {kind.label}
          </span>
        )}
      </span>
      <span className="relative mt-auto flex items-end gap-3">
        <span className="min-w-0 flex-1">
          <span className="line-clamp-3 block text-[19px] font-extrabold leading-[1.1] tracking-[-0.01em]">{leaf.label}</span>
          {leaf.subtitle && <span className="mt-1.5 line-clamp-2 block text-[13px] font-medium leading-snug text-white/80">{leaf.subtitle}</span>}
        </span>
        <span className="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-white text-[#1C1C1C] transition-transform duration-500 group-hover:translate-x-0.5">
          <ArrowRight className="h-[18px] w-[18px]" aria-hidden="true" />
        </span>
      </span>
    </Link>
  )
}

/** Ligne de sommaire (modules sans image propre). */
export function TocRow({ href, leaf, index, compact }: { href: string; leaf: Leaf; index: number; compact?: boolean }) {
  const kind = leafKind(leaf)
  return (
    <Link href={href} className={cn("cq-toc-row group flex items-center gap-3.5 rounded-[16px]", compact ? "px-2.5 py-2" : "px-3.5 py-3")}>
      <span
        className={cn(
          "grid shrink-0 place-items-center rounded-full bg-[var(--surface-container-hi)] font-bold tabular-nums text-[var(--on-surface-muted)]",
          compact ? "h-8 w-8 text-[12px]" : "h-10 w-10 text-[13px]",
        )}
      >
        {String(index).padStart(2, "0")}
      </span>
      <span className="min-w-0 flex-1">
        <span className={cn("line-clamp-2 block font-semibold leading-snug text-[var(--on-surface)]", compact ? "text-[14px]" : "text-[15px]")}>{leaf.label}</span>
        {!compact && (
          <span className="mt-0.5 flex items-center gap-1.5 text-[12.5px] text-[var(--on-surface-muted)]">
            <kind.icon className="h-3.5 w-3.5 shrink-0" aria-hidden="true" /> <span className="line-clamp-1">{leaf.subtitle && leaf.kind !== "group" ? leaf.subtitle : kind.label}</span>
          </span>
        )}
      </span>
      {compact ? (
        <kind.icon className="h-4 w-4 shrink-0 text-[var(--on-surface-faint)]" aria-label={kind.label} />
      ) : (
        <span className="cq-toc-go grid h-9 w-9 shrink-0 place-items-center rounded-full bg-[var(--surface-container)] text-[var(--on-surface-muted)]">
          <ArrowRight className="h-4 w-4" aria-hidden="true" />
        </span>
      )}
    </Link>
  )
}

/** Vrai si la plupart des modules ont leur propre image (sinon : sommaire). */
export function hasRichImages(leaves: Leaf[]): boolean {
  if (leaves.length < 2) return false
  const distinct = new Set(leaves.map((l) => l.image).filter(Boolean)).size
  return distinct / leaves.length >= 0.7
}
