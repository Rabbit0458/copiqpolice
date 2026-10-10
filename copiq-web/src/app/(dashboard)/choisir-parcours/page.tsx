"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import Link from "next/link"
import { Check, Crown, GraduationCap, Lock, Shield, Sparkles } from "lucide-react"
import { useEntitlement } from "@/features/access/entitlement"
import { flatLeaves, imgUrl, programsFor } from "@/features/parcours/tree"
import toast from "react-hot-toast"
import { PATHWAY_LIST, isPathwayId, type PathwayDefinition, type PathwayId } from "@/config/pathways"
import { createClient } from "@/lib/supabase/client"
import { usePathway } from "@/features/pathway/pathway-provider"
import { cn } from "@/lib/utils"

export default function ChoosePathwayPage() {
  const router = useRouter()
  const { pathway, loading, error, refresh, changePathway } = usePathway()
  const ent = useEntitlement()
  // Comme l'app : la scolarité (PA / GPX) est réservée aux abonnés Premium.
  const isLocked = (item: PathwayDefinition) => item.mode === "school" && ent.loaded && !ent.premium
  const [selected, setSelected] = useState<PathwayId | null>(pathway?.id ?? null)
  const [saving, setSaving] = useState(false)

  // Parcours choisi à l'inscription web (/signup?parcours=…), mémorisé dans
  // les métadonnées du compte : on le présélectionne tant qu'aucun parcours
  // n'est enregistré. L'utilisateur confirme toujours lui-même.
  useEffect(() => {
    if (pathway || selected) return
    let cancelled = false
    void createClient().auth.getUser().then(({ data }) => {
      const wanted = data.user?.user_metadata?.parcours
      if (!cancelled && isPathwayId(wanted) && !wanted.endsWith("school")) setSelected(wanted)
    })
    return () => {
      cancelled = true
    }
  }, [pathway, selected])

  async function confirmChoice() {
    if (selected && isLocked(PATHWAY_LIST.find((p) => p.id === selected)!)) return
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
    <div className="mx-auto max-w-5xl pb-28 animate-fade-in">
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
            <PathwayCard key={item.id} pathway={item} locked={isLocked(item)} selected={selected === item.id} onSelect={() => !isLocked(item) && setSelected(item.id)} />
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

function PathwayCard({ pathway, selected, locked, onSelect }: { pathway: PathwayDefinition; selected: boolean; locked: boolean; onSelect: () => void }) {
  const Icon = pathway.mode === "school" ? GraduationCap : Shield
  const programs = programsFor(pathway.id)
  // Visuels distincts pour les 4 parcours (images de l'app).
  const image = imgUrl(
    pathway.id === "pa_exam"
      ? programs[0]?.cards[1]?.image
      : pathway.id === "gpx_exam"
        ? programs[0]?.cards[1]?.image
        : pathway.id === "gpx_school"
          ? (programs[3]?.image ?? programs[0]?.image)
          : programs[0]?.image,
  )
  const modules = programs.reduce((s, p) => s + p.cards.reduce((a, c) => a + flatLeaves(c.leaves).length, 0), 0)
  return (
    <label
      className={cn(
        "group relative block overflow-hidden rounded-3xl border bg-[var(--surface)] transition-all duration-300",
        locked ? "cursor-not-allowed border-[var(--outline)]" : "cursor-pointer hover:-translate-y-1 hover:shadow-card-hover",
        !locked && !selected && "border-[var(--outline)]",
      )}
      style={selected ? { borderColor: pathway.color, boxShadow: `0 18px 44px ${pathway.color}26` } : undefined}
    >
      <input type="radio" name="pathway" value={pathway.id} checked={selected} disabled={locked} onChange={onSelect} className="sr-only" />
      <span className="relative block h-36 overflow-hidden bg-[#0B1220]">
        {image && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={image} alt="" className={cn("absolute inset-0 h-full w-full object-cover transition-transform duration-700 group-hover:scale-105", locked && "grayscale-[.6] opacity-70")} />
        )}
        <span className="absolute inset-0 bg-[linear-gradient(180deg,rgba(0,0,0,.05),rgba(0,0,0,.6))]" aria-hidden="true" />
        <span className="absolute left-4 top-4 flex h-11 w-11 items-center justify-center rounded-2xl bg-white/95 shadow-lg" style={{ color: pathway.color }}>
          <Icon size={21} aria-hidden="true" />
        </span>
        {locked ? (
          <span className="absolute right-4 top-4 inline-flex items-center gap-1.5 rounded-full border border-white/25 bg-black/45 px-3 py-1 text-[12px] font-bold text-white backdrop-blur">
            <Lock size={13} aria-hidden="true" /> Premium
          </span>
        ) : (
          <span className={cn("absolute right-4 top-4 flex h-8 w-8 items-center justify-center rounded-full border-2 transition-colors", selected ? "text-white" : "border-white/70 text-transparent")} style={selected ? { borderColor: pathway.color, backgroundColor: pathway.color } : undefined}>
            <Check size={16} strokeWidth={3} aria-hidden="true" />
          </span>
        )}
        <span className="absolute bottom-3 left-4 text-[12px] font-bold uppercase tracking-[0.14em] text-white/85">{modules} modules</span>
      </span>
      <span className="block p-5">
        <span className="block text-xs font-semibold uppercase tracking-[0.14em]" style={{ color: pathway.color }}>{pathway.shortLabel}</span>
        <span className="mt-2 block text-xl font-bold tracking-tight text-[var(--on-surface)]">{pathway.title}</span>
        <span className="mt-2 block text-sm leading-relaxed text-[var(--on-surface-muted)]">{pathway.description}</span>
        {locked && (
          <Link href="/abonnement" className="mt-4 inline-flex items-center gap-1.5 text-[13.5px] font-extrabold text-[#B45309] hover:underline dark:text-[#FBBF24]">
            <Crown size={15} aria-hidden="true" /> Réservé aux abonnés Premium · voir les formules
          </Link>
        )}
      </span>
    </label>
  )
}
