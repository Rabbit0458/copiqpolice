import { LegacyRedirect } from "@/features/parcours/legacy-redirect"
import { PA_COURSE_MODULES } from "@/data/modules"

export function generateStaticParams() {
  return PA_COURSE_MODULES.map(m => ({ moduleId: m.id }))
}

export default function PACoursPage() {
  return <LegacyRedirect />
}
