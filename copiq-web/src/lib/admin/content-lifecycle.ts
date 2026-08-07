export type PublicationStatus = "draft" | "scheduled" | "published" | "archived"
export type LifecycleAction = PublicationStatus | "restore"

export const lifecycleLabels: Record<PublicationStatus, string> = {
  draft: "Brouillon",
  scheduled: "Planifiée",
  published: "Publiée",
  archived: "Archivée",
}

export function publicationStatusOf(value: {
  publication_status?: string | null
  is_published?: boolean
  is_active?: boolean
}): PublicationStatus {
  const status = value.publication_status
  if (status === "draft" || status === "scheduled" || status === "published" || status === "archived") return status
  return value.is_published || value.is_active ? "published" : "draft"
}

export function toLocalDateTime(value?: string | null) {
  if (!value) return ""
  const date = new Date(value)
  const offset = date.getTimezoneOffset() * 60_000
  return new Date(date.getTime() - offset).toISOString().slice(0, 16)
}

export function toIsoDateTime(value: string) {
  return value ? new Date(value).toISOString() : null
}

export function lifecycleError(status: PublicationStatus, scheduledAt: string) {
  if (status !== "scheduled") return null
  if (!scheduledAt) return "Choisis une date et une heure de publication."
  if (new Date(scheduledAt).getTime() <= Date.now()) return "La publication doit être programmée dans le futur."
  return null
}
