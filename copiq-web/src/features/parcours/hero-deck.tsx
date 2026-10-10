"use client"

import Link from "next/link"
import { useCallback, useEffect, useLayoutEffect, useRef, useState, type CSSProperties, type KeyboardEvent, type PointerEvent } from "react"
import { ArrowRight, ChevronLeft, ChevronRight, Crown, Heart, Layers } from "lucide-react"
import { cn } from "@/lib/utils"
import { imgUrl, type DeckCard } from "@/features/parcours/tree"

/**
 * Deck de cartes glissantes — portage web du `_HeroDeck` de l'application.
 *
 * Mêmes règles que Flutter (home_page_*.dart) : pile de cartes, carte active
 * à 78 % de la largeur, voisines réduites à 90 %, abaissées de 18 px, opacité
 * 75 %, glisser à la main puis ressort (raideur 420, amortissement 32,
 * masse 1). Adaptations ordinateur : flèches, clavier ← →, molette
 * horizontale, points de pagination, et voisines plus visibles sur grand écran.
 */

const SPRING = { stiffness: 420, damping: 32, mass: 1 }

export function HeroDeck({
  cards,
  initialIndex = 0,
  hrefFor,
  resumeId,
  locked,
  storageKey,
  onIndexChange,
}: {
  cards: DeckCard[]
  initialIndex?: number
  hrefFor: (card: DeckCard) => string
  resumeId?: string | null
  locked?: (card: DeckCard) => boolean
  storageKey: string
  onIndexChange?: (i: number) => void
}) {
  const wrapRef = useRef<HTMLDivElement | null>(null)
  const [width, setWidth] = useState(0)
  const [vh, setVh] = useState(800)
  const [page, setPage] = useState(() => {
    try {
      const saved = Number(window.sessionStorage.getItem(storageKey))
      if (Number.isFinite(saved) && saved >= 0 && saved < cards.length) return saved
    } catch {
      /* rien */
    }
    return Math.min(Math.max(0, initialIndex), Math.max(0, cards.length - 1))
  })
  const pageRef = useRef(page)
  const anim = useRef<number | null>(null)
  const drag = useRef<{ x: number; y: number; start: number; t: number; lastX: number; lastT: number; v: number; moved: boolean; axis: "x" | "y" | null } | null>(null)
  const reduce = useRef(false)

  useLayoutEffect(() => {
    const el = wrapRef.current
    if (!el) return
    const ro = new ResizeObserver(([e]) => setWidth(e.contentRect.width))
    ro.observe(el)
    setWidth(el.getBoundingClientRect().width)
    reduce.current = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    const onResize = () => setVh(window.innerHeight)
    onResize()
    window.addEventListener("resize", onResize)
    return () => {
      ro.disconnect()
      window.removeEventListener("resize", onResize)
    }
  }, [])

  const n = cards.length
  // Géométrie de l'app : carte active à 78 % (80 % sur ordinateur), voisines à
  // 90 % abaissées de 18 px qui dépassent juste derrière, une seule de chaque côté.
  const desktop = width >= 640
  const cardW = Math.round(width * (desktop ? 0.8 : 0.78))
  const height = desktop
    ? Math.round(Math.min(440, Math.max(330, Math.min(vh * 0.5, cardW * 0.82))))
    : Math.round(Math.min(400, Math.max(300, cardW * 1.12)))
  const step = desktop ? Math.max(40, (width - cardW) / 2 - 8 + cardW * 0.05) : 52
  const commit = useCallback(
    (p: number) => {
      pageRef.current = p
      setPage(p)
    },
    [],
  )

  const settle = useCallback(
    (target: number, velocity = 0) => {
      if (anim.current) cancelAnimationFrame(anim.current)
      const to = Math.min(Math.max(0, Math.round(target)), Math.max(0, n - 1))
      try {
        window.sessionStorage.setItem(storageKey, String(to))
      } catch {
        /* rien */
      }
      onIndexChange?.(to)
      if (reduce.current) {
        commit(to)
        return
      }
      let x = pageRef.current
      let v = velocity
      let last = performance.now()
      const tick = (now: number) => {
        const dt = Math.min(0.032, (now - last) / 1000)
        last = now
        const force = -SPRING.stiffness * (x - to) - SPRING.damping * v
        v += (force / SPRING.mass) * dt
        x += v * dt
        if (Math.abs(x - to) < 0.0005 && Math.abs(v) < 0.01) {
          commit(to)
          anim.current = null
          return
        }
        commit(x)
        anim.current = requestAnimationFrame(tick)
      }
      anim.current = requestAnimationFrame(tick)
    },
    [n, commit, storageKey, onIndexChange],
  )

  useEffect(() => () => {
    if (anim.current) cancelAnimationFrame(anim.current)
  }, [])

  const onPointerDown = (e: PointerEvent<HTMLDivElement>) => {
    if (e.button !== 0) return
    if (anim.current) cancelAnimationFrame(anim.current)
    drag.current = { x: e.clientX, y: e.clientY, start: pageRef.current, t: performance.now(), lastX: e.clientX, lastT: performance.now(), v: 0, moved: false, axis: null }
  }
  const onPointerMove = (e: PointerEvent<HTMLDivElement>) => {
    const d = drag.current
    if (!d) return
    const dx = e.clientX - d.x
    const dy = e.clientY - d.y
    if (!d.axis && Math.hypot(dx, dy) > 6) {
      d.axis = Math.abs(dx) > Math.abs(dy) ? "x" : "y"
      if (d.axis === "x") (e.currentTarget as HTMLDivElement).setPointerCapture(e.pointerId)
    }
    if (d.axis !== "x") return
    d.moved = true
    const now = performance.now()
    const dtt = Math.max(1, now - d.lastT)
    d.v = (-(e.clientX - d.lastX) / cardW) / (dtt / 1000)
    d.lastX = e.clientX
    d.lastT = now
    let p = d.start - dx / cardW
    if (p < 0) p = p * 0.35
    if (p > n - 1) p = n - 1 + (p - (n - 1)) * 0.35
    commit(p)
  }
  const onPointerUp = () => {
    const d = drag.current
    drag.current = null
    if (!d || d.axis !== "x") return
    settle(pageRef.current + d.v * 0.2, d.v)
  }

  const onKey = (e: KeyboardEvent<HTMLDivElement>) => {
    if (e.key === "ArrowRight") {
      e.preventDefault()
      settle(Math.round(pageRef.current) + 1)
    } else if (e.key === "ArrowLeft") {
      e.preventDefault()
      settle(Math.round(pageRef.current) - 1)
    }
  }

  // Molette / trackpad horizontal.
  const wheelAcc = useRef(0)
  const wheelTimer = useRef<number | null>(null)
  useEffect(() => {
    const el = wrapRef.current
    if (!el) return
    const onWheel = (e: WheelEvent) => {
      if (Math.abs(e.deltaX) <= Math.abs(e.deltaY)) return
      e.preventDefault()
      wheelAcc.current += e.deltaX
      if (wheelTimer.current) window.clearTimeout(wheelTimer.current)
      wheelTimer.current = window.setTimeout(() => {
        const dir = Math.sign(wheelAcc.current)
        wheelAcc.current = 0
        if (dir) settle(Math.round(pageRef.current) + dir)
      }, 60)
    }
    el.addEventListener("wheel", onWheel, { passive: false })
    return () => el.removeEventListener("wheel", onWheel)
  }, [settle])

  const active = Math.round(page)
  const order = cards
    .map((c, i) => ({ c, i }))
    .filter(({ i }) => Math.abs(i - page) <= 1.6)
    .sort((a, b) => Math.abs(b.i - page) - Math.abs(a.i - page))

  useEffect(() => {
    onIndexChange?.(Math.round(pageRef.current))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  return (
    <div className="relative select-none">
      <div
        ref={wrapRef}
        role="region"
        aria-roledescription="carrousel"
        aria-label="Sélection de contenu"
        tabIndex={0}
        onKeyDown={onKey}
        onPointerDown={onPointerDown}
        onPointerMove={onPointerMove}
        onPointerUp={onPointerUp}
        onPointerCancel={onPointerUp}
        className="cq-deck relative touch-pan-y rounded-[28px] outline-none focus-visible:ring-2 focus-visible:ring-[#4D82FF] focus-visible:ring-offset-4 focus-visible:ring-offset-[var(--surface-container)]"
        style={{ height: height + 20 }}
      >
        {width > 0 &&
          order.map(({ c, i }) => {
            const delta = i - page
            const a = Math.abs(delta)
            const t = 1 - Math.min(1, a)
            const scale = 0.9 + 0.1 * t
            const tx = delta * step
            const ty = (1 - t) * 18
            // Cartes opaques : la profondeur vient d'un voile, pas de la transparence.
            const opacity = Math.max(0, 1 - Math.max(0, a - 1.05) * 2.2)
            const shade = Math.min(0.42, a * 0.42)
            const isActive = i === active
            const style: CSSProperties = {
              width: cardW,
              height,
              left: (width - cardW) / 2,
              transform: `translate3d(${tx}px, ${ty}px, 0) scale(${scale})`,
              opacity,
              zIndex: 100 - Math.round(a * 10),
              "--shade": shade,
            } as CSSProperties
            return (
              <div key={c.id} className="absolute top-0" style={style} aria-hidden={!isActive}>
                <HeroCard
                  card={c}
                  href={hrefFor(c)}
                  active={isActive}
                  big={desktop}
                  resume={resumeId === c.id}
                  locked={locked?.(c) ?? false}
                  onPeek={() => settle(i)}
                  suppressClick={() => !!drag.current?.moved}
                />
              </div>
            )
          })}
      </div>

      {n > 1 && (
        <div className="mt-3 flex items-center justify-between gap-3 px-1">
          <p className="w-20 shrink-0 text-[13px] font-bold tabular-nums text-[var(--on-surface-faint)]" aria-live="polite">
            <span className="text-[var(--on-surface)]">{String(active + 1).padStart(2, "0")}</span> / {String(n).padStart(2, "0")}
          </p>
          <div className="flex min-w-0 items-center gap-1.5 overflow-hidden" role="tablist" aria-label="Cartes">
            {cards.map((c, i) => (
              <button
                key={c.id}
                type="button"
                role="tab"
                aria-selected={i === active}
                aria-label={c.label}
                onClick={() => settle(i)}
                className={cn("h-1.5 shrink-0 rounded-full transition-all duration-500 ease-[cubic-bezier(.22,1,.36,1)]", i === active ? "w-6 bg-[var(--on-surface)]" : "w-1.5 bg-[var(--outline)] hover:bg-[var(--on-surface-faint)]")}
              />
            ))}
          </div>
          <div className="flex w-20 shrink-0 justify-end gap-1.5">
          <button
            type="button"
            onClick={() => settle(active - 1)}
            disabled={active <= 0}
            aria-label="Carte précédente"
            className="grid h-9 w-9 place-items-center rounded-full bg-[var(--surface)] text-[var(--on-surface)] shadow-[var(--cq-shadow)] ring-1 ring-[var(--outline-variant)] transition hover:-translate-x-0.5 disabled:opacity-30"
          >
            <ChevronLeft className="h-5 w-5" aria-hidden="true" />
          </button>
          <button
            type="button"
            onClick={() => settle(active + 1)}
            disabled={active >= n - 1}
            aria-label="Carte suivante"
            className="grid h-9 w-9 place-items-center rounded-full bg-[var(--surface)] text-[var(--on-surface)] shadow-[var(--cq-shadow)] ring-1 ring-[var(--outline-variant)] transition hover:translate-x-0.5 disabled:opacity-30"
          >
            <ChevronRight className="h-5 w-5" aria-hidden="true" />
          </button>
          </div>
        </div>
      )}
    </div>
  )
}

/* ─── Carte du deck (HeroCard) ───────────────────────────────────────────── */

function HeroCard({
  card,
  href,
  active,
  big,
  resume,
  locked,
  onPeek,
  suppressClick,
}: {
  card: DeckCard
  href: string
  active: boolean
  big: boolean
  resume: boolean
  locked: boolean
  onPeek: () => void
  suppressClick: () => boolean
}) {
  const [fav, setFav] = useFavorite(card.route, card.label, card.image, card.badge)
  const modules = card.leaves.filter((l) => l.id !== card.id).length
  const src = imgUrl(card.image)

  return (
    <div className={cn("cq-hero-card group relative h-full w-full overflow-hidden rounded-[24px] bg-[#2A2D33] shadow-[0_26px_50px_-30px_rgba(0,0,0,.6)]", active && "is-active")}>
      {src && (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={src} alt="" draggable={false} className="cq-hero-img absolute inset-0 h-full w-full object-cover" loading={active ? "eager" : "lazy"} />
      )}
      <span className="absolute inset-0 bg-[linear-gradient(to_bottom,rgba(0,0,0,.18),transparent_50%)]" aria-hidden="true" />
      <span className="absolute inset-0 bg-[linear-gradient(to_top,rgba(0,0,0,.74)_0%,rgba(0,0,0,.3)_42%,transparent_85%)]" aria-hidden="true" />

      <Link
        href={href}
        tabIndex={active ? 0 : -1}
        draggable={false}
        onClick={(e) => {
          if (suppressClick()) {
            e.preventDefault()
            return
          }
          if (!active) {
            e.preventDefault()
            onPeek()
          }
        }}
        className="absolute inset-0 z-10 rounded-[24px] outline-none focus-visible:ring-4 focus-visible:ring-inset focus-visible:ring-white/70"
        aria-label={`${card.label} — ${resume ? "Reprendre" : "Découvrir"}`}
      />

      <button
        type="button"
        onClick={(e) => {
          e.stopPropagation()
          setFav(!fav)
        }}
        tabIndex={active ? 0 : -1}
        aria-pressed={fav}
        aria-label={fav ? "Retirer des favoris" : "Ajouter aux favoris"}
        className="absolute left-3 top-3 z-20 grid h-10 w-10 place-items-center rounded-full bg-black/30 text-white ring-1 ring-white/30 backdrop-blur-sm transition-transform hover:scale-105"
      >
        <Heart key={String(fav)} className={cn("h-[18px] w-[18px]", fav && "cq-fav-pop fill-[#FF5252] text-[#FF5252]")} aria-hidden="true" />
      </button>

      {locked && (
        <span className="absolute right-3 top-3 z-20 inline-flex items-center gap-1 rounded-full border border-white/25 bg-black/40 px-2.5 py-1 text-[12px] font-bold text-white backdrop-blur">
          <Crown className="h-3.5 w-3.5 text-[#FBBF24]" aria-hidden="true" /> Premium
        </span>
      )}

      <div className={cn("cq-hero-text pointer-events-none absolute z-0 text-white", big ? "inset-x-6 bottom-6" : "inset-x-4 bottom-4")}>
        <p className="truncate text-[12.5px] font-semibold tracking-[0.02em] text-white/85">{card.badge}</p>
        <h3 className={cn("mt-1 line-clamp-3 font-black leading-[1.06] tracking-[-0.02em]", big ? "max-w-[30rem] text-[clamp(1.45rem,2.3vw,1.9rem)]" : "text-[21px]")}>{card.label}</h3>
        {modules > 0 && (
          <p className="mt-2 inline-flex items-center gap-1.5 text-[12.5px] font-bold text-white/85">
            <Layers className="h-3.5 w-3.5" aria-hidden="true" />
            {modules} module{modules > 1 ? "s" : ""}
          </p>
        )}
        <span className="cq-hero-cta mt-3.5 flex h-[46px] w-fit items-center gap-2.5 rounded-[18px] border border-white/10 bg-[#2E3137]/95 pl-4 pr-2 text-[14.5px] font-extrabold">
          {resume ? "Reprendre" : "Découvrir"}
          <span className="grid h-7 w-7 place-items-center rounded-full bg-white text-black/85 transition-transform duration-500 ease-[cubic-bezier(.22,1,.36,1)] group-hover:translate-x-0.5">
            <ArrowRight className="h-[18px] w-[18px]" aria-hidden="true" />
          </span>
        </span>
      </div>
      <span className="cq-hero-shade pointer-events-none absolute inset-0 z-30 rounded-[24px] bg-[#0B0F18]" aria-hidden="true" />
    </div>
  )
}

/* ─── Favoris (mémorisés sur l'appareil, comme FavoritesStore dans l'app) ── */

type Fav = { route: string; title: string; image: string | null; subtitle: string }
const FAV_KEY = "cq-favoris-v1"

export function readFavorites(): Fav[] {
  try {
    return JSON.parse(window.localStorage.getItem(FAV_KEY) ?? "[]") as Fav[]
  } catch {
    return []
  }
}

function useFavorite(route: string, title: string, image: string | null, subtitle: string): [boolean, (v: boolean) => void] {
  const [on, setOn] = useState(false)
  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setOn(readFavorites().some((f) => f.route === route))
  }, [route])
  const set = (v: boolean) => {
    setOn(v)
    try {
      const list = readFavorites().filter((f) => f.route !== route)
      if (v) list.unshift({ route, title, image, subtitle })
      window.localStorage.setItem(FAV_KEY, JSON.stringify(list.slice(0, 100)))
    } catch {
      /* rien */
    }
  }
  return [on, set]
}
