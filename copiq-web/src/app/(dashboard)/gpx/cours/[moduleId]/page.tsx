import { GPX_COURSE_MODULES } from "@/data/modules"
import GPXCoursClient from "./gpx-cours-client"
export function generateStaticParams() {
  return GPX_COURSE_MODULES.map(m => ({ moduleId: m.id }))
}
export default function GPXCoursPage() { return <GPXCoursClient /> }
