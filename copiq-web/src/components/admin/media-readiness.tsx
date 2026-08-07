"use client"

import { useEffect, useMemo, useState } from "react"
import { ImageIcon, LoaderCircle, ShieldCheck } from "lucide-react"
import {
  extractCourseMedia,
  validateCourseMedia,
  type EditorialIssue,
} from "@/lib/admin/content-validation"

type MediaReadinessProps = {
  markdown: string
  onChange: (state: { checking: boolean; issues: EditorialIssue[] }) => void
}

export function MediaReadiness({ markdown, onChange }: MediaReadinessProps) {
  const references = useMemo(() => extractCourseMedia(markdown), [markdown])
  const staticIssues = useMemo(() => validateCourseMedia(markdown), [markdown])
  const [checking, setChecking] = useState(false)
  const [networkIssues, setNetworkIssues] = useState<EditorialIssue[]>([])

  useEffect(() => {
    let cancelled = false
    const safeReferences = references
      .map((reference, index) => ({ reference, number: index + 1 }))
      .filter(({ number }) =>
        !staticIssues.some((issue) => issue.code.endsWith(`-${number}`)),
      )

    setNetworkIssues([])
    if (safeReferences.length === 0) {
      setChecking(false)
      onChange({ checking: false, issues: staticIssues })
      return () => { cancelled = true }
    }

    setChecking(true)
    onChange({ checking: true, issues: staticIssues })
    const timer = window.setTimeout(async () => {
      const results = await Promise.all(safeReferences.map(({ reference }) => probeImage(reference.source)))
      if (cancelled) return
      const broken = results.flatMap((ok, index) => ok ? [] : [{
        code: `course-media-unavailable-${safeReferences[index].number}`,
        label: `Média inaccessible — ${safeReferences[index].number}`,
        detail: `L’image « ${safeReferences[index].reference.alt || safeReferences[index].reference.source} » ne peut pas être chargée. Vérifie son adresse et ses droits d’accès.`,
        severity: "error" as const,
      }])
      setNetworkIssues(broken)
      setChecking(false)
      onChange({ checking: false, issues: [...staticIssues, ...broken] })
    }, 450)

    return () => {
      cancelled = true
      window.clearTimeout(timer)
    }
  }, [markdown, onChange, references, staticIssues])

  const issues = [...staticIssues, ...networkIssues]
  return (
    <section className="mt-3 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/45 p-3.5" aria-live="polite">
      <div className="flex items-start gap-3">
        <span className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]">
          {checking ? <LoaderCircle size={17} className="animate-spin motion-reduce:animate-none" /> : issues.length > 0 ? <ImageIcon size={17} /> : <ShieldCheck size={17} />}
        </span>
        <div className="min-w-0">
          <p className="text-xs font-semibold">
            {checking ? "Vérification des médias…" : references.length === 0 ? "Aucun média référencé" : issues.length === 0 ? `${references.length} média${references.length > 1 ? "s" : ""} vérifié${references.length > 1 ? "s" : ""}` : `${issues.length} anomalie${issues.length > 1 ? "s" : ""} média`}
          </p>
          <p className="mt-1 text-[11px] leading-relaxed text-[var(--on-surface-muted)]">
            Description, adresse sécurisée, format et chargement sont contrôlés automatiquement.
          </p>
        </div>
      </div>
    </section>
  )
}

function probeImage(source: string): Promise<boolean> {
  return new Promise((resolve) => {
    const image = new Image()
    const timeout = window.setTimeout(() => finish(false), 8000)
    let done = false
    function finish(ok: boolean) {
      if (done) return
      done = true
      window.clearTimeout(timeout)
      image.onload = null
      image.onerror = null
      resolve(ok && image.naturalWidth > 0 && image.naturalHeight > 0)
    }
    image.onload = () => finish(true)
    image.onerror = () => finish(false)
    image.src = source
  })
}
