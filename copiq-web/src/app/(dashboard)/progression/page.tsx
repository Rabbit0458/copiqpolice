import { ProgressionV5 } from "@/features/home/progression-v5"

export const metadata = { title: "Ma progression · COP'IQ" }

/** Progression : mêmes chiffres que l'application (features/home/progress.ts). */
export default function ProgressionPage() {
  return <ProgressionV5 />
}
