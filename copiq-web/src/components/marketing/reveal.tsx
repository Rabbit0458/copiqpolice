"use client"

import { useEffect, useRef, useState, type ReactNode } from "react"
import { cn } from "@/lib/utils"

/**
 * Un seul mécanisme de reveal pour toute la vitrine, réservé aux **blocs de
 * section** — pas à chaque paragraphe (§8, §13).
 *
 * Pourquoi un IntersectionObserver plutôt que framer-motion ici : ces sections
 * sont rendues au chargement de la page d'accueil, et l'observateur ne coûte
 * ni JS de bibliothèque ni re-render par frame. `prefers-reduced-motion` est
 * traité deux fois : en CSS (`globals.css`) et ici, pour ne même pas armer
 * l'observateur.
 *
 * Volontairement non polymorphe : un `<div>` neutre suffit et évite un type
 * générique coûteux. Si un jour une balise sémantique est nécessaire, elle est
 * placée *à l'intérieur* du Reveal.
 */
export function Reveal({
  children,
  delay = 0,
  className,
}: {
  children: ReactNode
  /** Décalage en ms, pour un escalier discret entre 2-3 éléments frères. */
  delay?: number
  className?: string
}) {
  const ref = useRef<HTMLDivElement | null>(null)
  const [shown, setShown] = useState(false)

  useEffect(() => {
    const node = ref.current
    if (!node) return

    // `prefers-reduced-motion` n'est pas traité ici : la feuille de style
    // force déjà `.cq-reveal` à `opacity: 1` en `!important` dans ce cas. Rien
    // à faire en JavaScript, et rien à mettre à jour synchroniquement dans cet
    // effet.
    if (typeof IntersectionObserver === "undefined") {
      // Navigateur sans IntersectionObserver : on révèle à la frame suivante
      // plutôt que pendant l'effet, pour ne pas déclencher un rendu en cascade.
      const frame = requestAnimationFrame(() => setShown(true))
      return () => cancelAnimationFrame(frame)
    }

    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            setShown(true)
            observer.disconnect()
          }
        }
      },
      { rootMargin: "0px 0px -12% 0px", threshold: 0.08 },
    )
    observer.observe(node)
    return () => observer.disconnect()
  }, [])

  return (
    <div
      ref={ref}
      className={cn("cq-reveal", className)}
      data-shown={shown ? "true" : "false"}
      style={delay ? { transitionDelay: `${delay}ms` } : undefined}
    >
      {children}
    </div>
  )
}
