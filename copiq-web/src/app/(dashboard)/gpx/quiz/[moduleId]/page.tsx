import { GPX_COURSE_MODULES } from "@/data/modules"
import GPXQuizClient from "./gpx-quiz-client"
export function generateStaticParams() {
  return GPX_COURSE_MODULES.map(m => ({ moduleId: m.id }))
}
export default function GPXQuizModulePage() { return <GPXQuizClient /> }
