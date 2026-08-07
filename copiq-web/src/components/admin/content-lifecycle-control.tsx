"use client"

import { Archive, CalendarClock, FilePenLine, Globe2, RotateCcw } from "lucide-react"
import { lifecycleLabels, type PublicationStatus } from "@/lib/admin/content-lifecycle"

const choices = [
  { value: "draft", icon: FilePenLine, hint: "Invisible dans l’application" },
  { value: "scheduled", icon: CalendarClock, hint: "Publication automatique" },
  { value: "published", icon: Globe2, hint: "Visible immédiatement" },
  { value: "archived", icon: Archive, hint: "Conservée, mais masquée" },
] as const

export function ContentLifecycleControl({ status, scheduledAt, onStatusChange, onScheduledAtChange, onRestore }: {
  status: PublicationStatus
  scheduledAt: string
  onStatusChange: (status: PublicationStatus) => void
  onScheduledAtChange: (value: string) => void
  onRestore?: () => void
}) {
  return (
    <fieldset className="rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/45 p-3">
      <legend className="px-1 text-xs font-semibold text-[var(--on-surface-muted)]">Visibilité du contenu</legend>
      <div className="grid gap-2 sm:grid-cols-2">
        {choices.map(({ value, icon: Icon, hint }) => {
          const active = status === value
          return <button key={value} type="button" onClick={() => onStatusChange(value)} aria-pressed={active} className={`flex min-h-14 items-center gap-2.5 rounded-xl border px-3 text-left transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${active ? "border-[var(--brand)] bg-[var(--brand)]/[.08] text-[var(--brand)]" : "border-transparent bg-[var(--surface)] text-[var(--on-surface-muted)] hover:border-[var(--outline)]"}`}>
            <Icon size={18} aria-hidden="true" />
            <span><span className="block text-xs font-semibold">{lifecycleLabels[value]}</span><span className="block text-[10px] opacity-75">{hint}</span></span>
          </button>
        })}
      </div>
      {status === "scheduled" && <label className="mt-3 block"><span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">Date et heure de publication</span><input type="datetime-local" value={scheduledAt} onChange={(event) => onScheduledAtChange(event.target.value)} className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-sm outline-none focus:border-[var(--brand)]" /></label>}
      {status === "archived" && onRestore && <button type="button" onClick={onRestore} className="mt-3 inline-flex min-h-11 items-center gap-2 rounded-xl px-3 text-xs font-semibold text-[var(--brand)] hover:bg-[var(--brand)]/10"><RotateCcw size={16} /> Restaurer ce contenu</button>}
    </fieldset>
  )
}
