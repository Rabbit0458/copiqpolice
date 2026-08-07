"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Check, GraduationCap, Shield, Sparkles } from "lucide-react"
import toast from "react-hot-toast"
import { PATHWAY_LIST, type PathwayDefinition, type PathwayId } from "@/config/pathways"
import { usePathway } from "@/features/pathway/pathway-provider"
import { cn } from "@/lib/utils"

export default function ChoosePathwayPage() {
  const router = useRouter()
  const { pathway, loading, error, refresh, changePathway } = usePathway()
  const [selected, setSelected] = useState<PathwayId | null>(pathway?.id ?? null)
  const [saving, setSaving] = useState(false)

  async function confirmChoice() {
    if (!selected || selected === pathway?.id) {
      if (pathway) router.replace(pathway.homeHref)
      return
    }

    setSaving(true)
    try {
      await changePathway(selected)
      toast.success("Votre parcours a bien été mis à jour.")
      router.replace("/dashboard")
    } catch {
      // Le provider conserve l'erreur et la sélection reste réessayable.
    } finally {
      setSaving(false)
    }
  }

  if (loading) {
    return (
      <div className="mx-auto max-w-5xl" aria-busy="true">
        <div className="mb-8 h-28 animate-pulse rounded-3xl bg-[var(--surface-container)]" />
        <div className="grid gap-4 md:grid-cols-2">
          {[0, 1, 2, 3].map((item) => <div key={item} className="h-56 animate-pulse rounded-3xl bg-[var(--surface-container)]" />)}
        </div>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-5xl pb-8 animate-fade-in">
      <header className="mb-8 max-w-2xl">
        <div className="mb-4 flex h-11 w-11 items-center justify-center rounded-2xl bg-brand/10 text-brand">
          <Sparkles size={20} aria-hidden="true" />
        </div>
        <p className="mb-2 text-xs font-semibold uppercase tracking-[0.16em] text-brand">Votre espace COP&apos;IQ</p>
        <h1 className="text-3xl font-bold tracking-tight text-[var(--on-surface)] sm:text-4xl">Quel objectif préparez-vous ?</h1>
        <p className="mt-3 text-base leading-relaxed text-[var(--on-surface-muted)]">Votre accueil, vos exercices et votre espace communautaire s’adapteront à ce choix. Vous pourrez le modifier plus tard sans perdre votre progression.</p>
      </header>

      {error && (
        <div role="alert" className="mb-5 flex flex-wrap items-center justify-between gap-3 rounded-2xl border border-danger/25 bg-danger/5 px-4 py-3 text-sm text-danger">
          <span>{error.message}</span>
          <button type="button" onClick={() => void refresh()} className="min-h-11 rounded-xl px-4 font-semibold transition-colors hover:bg-danger/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-danger">Réessayer</button>
        </div>
      )}

      <fieldset disabled={saving}>
        <legend className="sr-only">Choisissez un parcours</legend>
        <div className="grid gap-4 md:grid-cols-2">
          {PATHWAY_LIST.map((item) => (
            <PathwayCard key={item.id} pathway={item} selected={selected === item.id} onSelect={() => setSelected(item.id)} />
          ))}
        </div>
      </fieldset>

      <div className="sticky bottom-4 z-10 mt-7 flex flex-col-reverse gap-3 rounded-2xl border border-[var(--outline)] bg-[color:var(--surface)]/95 p-3 shadow-card-hover backdrop-blur sm:flex-row sm:items-center sm:justify-between">
        <p className="px-2 text-sm text-[var(--on-surface-muted)]">{selected ? PATHWAY_LIST.find((item) => item.id === selected)?.title : "Sélectionnez une carte pour continuer."}</p>
        <button type="button" onClick={() => void confirmChoice()} disabled={!selected || saving} className="inline-flex min-h-12 shrink-0 items-center justify-center gap-2 rounded-xl bg-[var(--on-surface)] px-5 text-sm font-semibold text-[var(--surface)] transition-all hover:-translate-y-0.5 disabled:cursor-not-allowed disabled:opacity-40 disabled:hover:translate-y-0 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-brand focus-visible:ring-offset-2">
          {saving ? <span className="h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent" aria-hidden="true" /> : <Check size={17} aria-hidden="true" />}
          {selected === pathway?.id ? "Conserver ce parcours" : "Confirmer mon parcours"}
        </button>
      </div>
    </div>
  )
}

function PathwayCard({ pathway, selected, onSelect }: { pathway: PathwayDefinition; selected: boolean; onSelect: () => void }) {
  const Icon = pathway.mode === "school" ? GraduationCap : Shield
  return (
    <label className={cn("group relative cursor-pointer overflow-hidden rounded-3xl border bg-[var(--surface)] p-5 transition-all duration-200 hover:-translate-y-1 hover:shadow-card-hover", selected ? "shadow-card-hover" : "border-[var(--outline)]")} style={selected ? { borderColor: pathway.color, boxShadow: `0 14px 40px ${pathway.color}18` } : undefined}>
      <input type="radio" name="pathway" value={pathway.id} checked={selected} onChange={onSelect} className="sr-only" />
      <span className="absolute inset-x-0 top-0 h-1" style={{ backgroundColor: pathway.color }} aria-hidden="true" />
      <span className="mb-8 flex items-start justify-between gap-4">
        <span className="flex h-12 w-12 items-center justify-center rounded-2xl" style={{ color: pathway.color, backgroundColor: pathway.softColor }}>
          <Icon size={22} aria-hidden="true" />
        </span>
        <span className={cn("flex h-7 w-7 items-center justify-center rounded-full border transition-colors", selected ? "text-white" : "border-[var(--outline)] text-transparent")} style={selected ? { borderColor: pathway.color, backgroundColor: pathway.color } : undefined}>
          <Check size={15} aria-hidden="true" />
        </span>
      </span>
      <span className="block text-xs font-semibold uppercase tracking-[0.14em]" style={{ color: pathway.color }}>{pathway.shortLabel}</span>
      <span className="mt-2 block text-xl font-bold tracking-tight text-[var(--on-surface)]">{pathway.title}</span>
      <span className="mt-2 block text-sm leading-relaxed text-[var(--on-surface-muted)]">{pathway.description}</span>
    </label>
  )
}
