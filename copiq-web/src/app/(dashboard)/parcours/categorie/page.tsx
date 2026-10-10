"use client"

import { Suspense } from "react"
import { CategoryView } from "@/features/parcours/parcours-pages"

/** Catégorie d'un parcours : la liste des modules, comme `_CategoryDetailPage` dans l'app. */
export default function CategoriePage() {
  return (
    <Suspense fallback={<div className="cq-skel mx-auto h-64 max-w-6xl rounded-[28px]" />}>
      <CategoryView />
    </Suspense>
  )
}
