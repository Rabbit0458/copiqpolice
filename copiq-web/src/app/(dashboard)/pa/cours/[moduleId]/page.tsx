import { PA_COURSE_MODULES } from "@/data/modules"
import PACoursClient from "./pa-cours-client"

export function generateStaticParams() {
  return PA_COURSE_MODULES.map(m => ({ moduleId: m.id }))
}

export default function PACoursPage() {
  return <PACoursClient />
}
