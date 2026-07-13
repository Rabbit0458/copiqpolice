import { PA_COURSE_MODULES } from "@/data/modules"
import PAQuizClient from "./pa-quiz-client"
export function generateStaticParams() {
  return PA_COURSE_MODULES.map(m => ({ moduleId: m.id }))
}
export default function PAQuizModulePage() { return <PAQuizClient /> }
