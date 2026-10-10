"use client"

import { Suspense } from "react"
import { ModuleView } from "@/features/parcours/parcours-pages"

/** Module d'un parcours : cours, quiz ou contenu à venir. */
export default function ModulePage() {
  return (
    <Suspense fallback={<div className="cq-skel mx-auto h-64 max-w-6xl rounded-[28px]" />}>
      <ModuleView />
    </Suspense>
  )
}
