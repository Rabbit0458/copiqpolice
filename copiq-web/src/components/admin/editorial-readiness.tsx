import { AlertTriangle, CheckCircle2, CircleAlert, ShieldCheck } from "lucide-react"
import type { EditorialIssue } from "@/lib/admin/content-validation"

export function EditorialReadiness({ issues, activeLabel = "publication" }: { issues: EditorialIssue[]; activeLabel?: string }) {
  const errors = issues.filter((issue) => issue.severity === "error")
  const warnings = issues.filter((issue) => issue.severity === "warning")
  const ready = errors.length === 0

  return (
    <section
      aria-live="polite"
      className={`rounded-2xl border p-4 ${ready ? "border-[var(--success)]/25 bg-[var(--success)]/[.06]" : "border-[var(--danger)]/25 bg-[var(--danger)]/[.055]"}`}
    >
      <div className="flex items-start gap-3">
        <span className={`grid h-9 w-9 shrink-0 place-items-center rounded-xl ${ready ? "bg-[var(--success)]/12 text-[var(--success)]" : "bg-[var(--danger)]/10 text-[var(--danger)]"}`}>
          {ready ? <ShieldCheck size={18} /> : <CircleAlert size={18} />}
        </span>
        <div className="min-w-0 flex-1">
          <h3 className="text-sm font-semibold">{ready ? `Prêt pour la ${activeLabel}` : `${errors.length} correction${errors.length > 1 ? "s" : ""} avant ${activeLabel}`}</h3>
          <p className="mt-0.5 text-xs leading-relaxed text-[var(--on-surface-muted)]">
            {ready ? "Aucune anomalie bloquante détectée. Les recommandations restent facultatives." : "Le brouillon peut être conservé, mais il ne peut pas devenir visible en l’état."}
          </p>
        </div>
      </div>

      {issues.length > 0 && (
        <ul className="mt-3 space-y-2 border-t border-current/10 pt-3">
          {[...errors, ...warnings].map((issue) => (
            <li key={issue.code} className="flex items-start gap-2.5 text-xs">
              {issue.severity === "error" ? <CircleAlert size={15} className="mt-0.5 shrink-0 text-[var(--danger)]" /> : <AlertTriangle size={15} className="mt-0.5 shrink-0 text-[var(--warning)]" />}
              <span className="min-w-0">
                <span className="font-semibold">{issue.label}</span>
                <span className="block pt-0.5 leading-relaxed text-[var(--on-surface-muted)]">{issue.detail}</span>
              </span>
            </li>
          ))}
        </ul>
      )}

      {issues.length === 0 && (
        <div className="mt-3 flex items-center gap-2 border-t border-current/10 pt-3 text-xs text-[var(--success)]">
          <CheckCircle2 size={15} /> Tous les contrôles éditoriaux sont validés.
        </div>
      )}
    </section>
  )
}
