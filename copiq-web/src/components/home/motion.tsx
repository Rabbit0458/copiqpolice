"use client"

import {
  Fragment,
  createElement,
  useEffect,
  useRef,
  useState,
  type CSSProperties,
  type ReactNode,
} from "react"
import Lenis from "lenis"
import { cn } from "@/lib/utils"

/**
 * Système d'animation de l'accueil COP'IQ.
 *
 * Règles qui rendent le tout fluide :
 *  - on n'anime que `transform`, `opacity` et (sur grand écran) `filter` :
 *    aucune propriété qui force le navigateur à recalculer la mise en page ;
 *  - une seule courbe pour tout le site (`--ease-premium`, une « expo out »
 *    douce) et des durées longues en sortie, courtes en entrée ;
 *  - chaque apparition ne se joue qu'une fois ;
 *  - `prefers-reduced-motion` coupe tout, en CSS (globals.css) et ici.
 *
 * Les courbes et keyframes vivent dans `globals.css`, bloc « COP'IQ WEB V5 ».
 */

/* ─────────────────────────────────────────────────────────────────────────────
   Visibilité à l'écran
   ───────────────────────────────────────────────────────────────────────── */

export function useInView<T extends Element>(options?: { threshold?: number; rootMargin?: string; once?: boolean }) {
  const ref = useRef<T | null>(null)
  const [inView, setInView] = useState(false)
  const { threshold = 0.15, rootMargin = "0px 0px -8% 0px", once = true } = options ?? {}

  useEffect(() => {
    const node = ref.current
    if (!node) return
    if (typeof IntersectionObserver === "undefined") {
      const f = requestAnimationFrame(() => setInView(true))
      return () => cancelAnimationFrame(f)
    }
    const io = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setInView(true)
          if (once) io.disconnect()
        } else if (!once) {
          setInView(false)
        }
      },
      { threshold, rootMargin },
    )
    io.observe(node)
    return () => io.disconnect()
  }, [threshold, rootMargin, once])

  return [ref, inView] as const
}

/* ─────────────────────────────────────────────────────────────────────────────
   Apparition d'un bloc au défilement
   ───────────────────────────────────────────────────────────────────────── */

export function Appear({
  children,
  delay = 0,
  variant = "up",
  className,
  as = "div",
}: {
  children: ReactNode
  /** Décalage en millisecondes, pour un escalier entre éléments frères. */
  delay?: number
  variant?: "up" | "scale" | "fade" | "right"
  className?: string
  as?: "div" | "li" | "article" | "section"
}) {
  const [ref, inView] = useInView<HTMLElement>()
  return createElement(
    as,
    {
      ref,
      className: cn("cq-appear", className),
      "data-variant": variant,
      "data-in": inView ? "true" : "false",
      style: { "--d": `${delay}ms` } as CSSProperties,
    },
    children,
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Texte qui monte mot par mot, derrière un masque
   ───────────────────────────────────────────────────────────────────────── */

/**
 * `mode="load"` : joué dès l'affichage (accroche). Pur CSS, donc il démarre
 * avant même que JavaScript soit chargé : aucun flash.
 * `mode="view"` : joué quand le texte entre à l'écran.
 *
 * Le texte reste un seul nœud lisible pour les lecteurs d'écran (`aria-label`
 * sur le conteneur, mots en `aria-hidden`).
 */
export function SplitText({
  text,
  mode = "view",
  delay = 0,
  stagger = 45,
  as = "span",
  className,
  id,
  before,
  after,
}: {
  text: string
  /** Contenu collé au premier mot (ex. guillemet ouvrant). */
  before?: ReactNode
  /** Contenu collé au dernier mot (ex. guillemet fermant). */
  after?: ReactNode
  mode?: "load" | "view"
  delay?: number
  stagger?: number
  as?: "span" | "h1" | "h2" | "h3" | "p" | "blockquote"
  className?: string
  id?: string
}) {
  const [ref, inView] = useInView<HTMLElement>({ threshold: 0.3 })
  const words = text.split(" ")
  // Titres et citations : un seul libellé lisible, mots masqués aux lecteurs
  // d'écran. Un simple <span> n'accepte pas aria-label de façon fiable.
  const labelled = as !== "span"
  return createElement(
    as,
    {
      ref: mode === "view" ? ref : undefined,
      id,
      className: cn("cq-split", className),
      "data-mode": mode,
      "data-in": mode === "view" && inView ? "true" : "false",
      "aria-label": labelled ? text : undefined,
      style: { "--d": `${delay}ms`, "--s": `${stagger}ms` } as CSSProperties,
    },
    // L'espace reste HORS du mot : à l'intérieur d'un inline-block, une espace
    // finale est supprimée et les mots se colleraient.
    words.map((w, i) => (
      <Fragment key={`${w}-${i}`}>
        <span className="cq-split-word" aria-hidden={labelled || undefined}>
          <span style={{ "--i": i } as CSSProperties}>
            {i === 0 ? before : null}
            {w}
            {i === words.length - 1 ? after : null}
          </span>
        </span>
        {i < words.length - 1 ? " " : null}
      </Fragment>
    )),
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Défilement fluide (Lenis) — accueil uniquement
   ───────────────────────────────────────────────────────────────────────── */

export function SmoothScroll() {
  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return
    // Sur écran tactile, le défilement natif est déjà fluide : on n'y touche pas.
    if (window.matchMedia("(pointer: coarse)").matches) return

    const lenis = new Lenis({
      duration: 1.15,
      easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
      smoothWheel: true,
      anchors: { offset: -72 },
      autoRaf: true,
    })
    return () => lenis.destroy()
  }, [])
  return null
}

/* ─────────────────────────────────────────────────────────────────────────────
   Progression de lecture : liseré tricolore en haut de l'écran
   ───────────────────────────────────────────────────────────────────────── */

export function ScrollProgress() {
  const bar = useRef<HTMLSpanElement | null>(null)
  useEffect(() => {
    let frame = 0
    const update = () => {
      frame = 0
      const max = document.documentElement.scrollHeight - window.innerHeight
      const p = max > 0 ? Math.min(1, Math.max(0, window.scrollY / max)) : 0
      if (bar.current) bar.current.style.transform = `scaleX(${p})`
    }
    const onScroll = () => {
      if (!frame) frame = requestAnimationFrame(update)
    }
    update()
    window.addEventListener("scroll", onScroll, { passive: true })
    window.addEventListener("resize", onScroll)
    return () => {
      window.removeEventListener("scroll", onScroll)
      window.removeEventListener("resize", onScroll)
      cancelAnimationFrame(frame)
    }
  }, [])
  return (
    <span aria-hidden="true" className="pointer-events-none fixed inset-x-0 top-0 z-[60] h-[3px]">
      <span ref={bar} className="cq-tricolore block h-full origin-left rounded-none" style={{ transform: "scaleX(0)" }} />
    </span>
  )
}

/* ─────────────────────────────────────────────────────────────────────────────
   Parallaxe de l'accroche : expose la progression (0 → 1) en variable CSS
   ───────────────────────────────────────────────────────────────────────── */

export function HeroScrollStage({ children, className }: { children: ReactNode; className?: string }) {
  const ref = useRef<HTMLDivElement | null>(null)
  useEffect(() => {
    const node = ref.current
    if (!node) return
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return
    let frame = 0
    const update = () => {
      frame = 0
      const h = node.offsetHeight || 1
      const p = Math.min(1, Math.max(0, window.scrollY / h))
      node.style.setProperty("--p", p.toFixed(4))
    }
    const onScroll = () => {
      if (!frame) frame = requestAnimationFrame(update)
    }
    update()
    window.addEventListener("scroll", onScroll, { passive: true })
    return () => {
      window.removeEventListener("scroll", onScroll)
      cancelAnimationFrame(frame)
    }
  }, [])
  return (
    <div ref={ref} className={className} style={{ "--p": 0 } as CSSProperties}>
      {children}
    </div>
  )
}
