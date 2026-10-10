import { LegacyRedirect } from "@/features/parcours/legacy-redirect"
import { GPX_COURSE_MODULES } from "@/data/modules"
export function generateStaticParams() {
  return GPX_COURSE_MODULES.map(m => ({ moduleId: m.id }))
}
export default function GPXQuizModulePage() { return <LegacyRedirect /> }
