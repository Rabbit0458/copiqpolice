"use client"

import Link from "next/link"
import { useEffect, useState } from "react"
import { cn } from "@/lib/utils"
import { BrandWordmark, Tricolore } from "@/components/home/brand"
import { ThemeToggle } from "@/components/ui/theme-toggle"
import { ConsentLink } from "@/components/cookie-banner"
import { INDEPENDENCE_NOTICE } from "@/data/marketing"

/**
 * En-tête et pied de page de la partie publique.
 *
 * Deux variantes d'en-tête :
 *  - `overlay` : transparent au-dessus du hero bleu nuit de l'accueil, puis
 *    opaque une fois le hero dépassé ;
 *  - `solid` : opaque dès le chargement, pour les pages intérieures.
 *
 * Version 5 (octobre 2026) : logo officiel en PNG transparent
 * (`BrandWordmark`), bouton d'inscription rouge COP'IQ, navigation recentrée
 * sur l'accueil. Les liens du pied de page sont inchangés.
 */

const NAV = [
  { label: "Parcours", href: "/#parcours" },
  { label: "Fonctionnalités", href: "/#fonctionnalites" },
  { label: "Tarifs", href: "/tarifs" },
  { label: "Ressources", href: "/ressources" },
] as const

export function SiteHeader({ variant = "solid" }: { variant?: "solid" | "overlay" }) {
  const [scrolled, setScrolled] = useState(variant === "solid")
  const [hidden, setHidden] = useState(false)
  const [menuOpen, setMenuOpen] = useState(false)

  useEffect(() => {
    let last = window.scrollY
    let frame = 0
    const update = () => {
      frame = 0
      const y = window.scrollY
      if (variant === "overlay") setScrolled(y > 48)
      // Se cache en descendant, revient dès qu'on remonte (seuil anti-tremblement).
      if (Math.abs(y - last) > 6) {
        setHidden(y > last && y > 160)
        last = y
      }
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
  }, [variant])

  /** L'en-tête est sur fond sombre quand il survole le hero. */
  const onDark = variant === "overlay" && !scrolled

  return (
    <>
      <header
        className={cn(
          "sticky top-0 z-50 transition-[transform,background-color,border-color] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] motion-reduce:transition-none",
          variant === "overlay" && "cq-enter-header",
          hidden && !menuOpen && "-translate-y-full",
          variant === "overlay"
            ? scrolled
              ? "border-b border-white/10 bg-[#00061F]/92 backdrop-blur-xl"
              : "border-b border-transparent"
            : "border-b border-[var(--outline)] bg-[var(--surface)]/92 backdrop-blur-xl",
        )}
      >
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between gap-4 px-4 sm:px-6 xl:px-8">
          {/* Lien classique (rechargement complet) : retour net à l'accueil. */}
          {/* eslint-disable-next-line @next/next/no-html-link-for-pages */}
          <a href="/" aria-label="COP'IQ, accueil" className="shrink-0">
            <BrandWordmark size={40} tone={variant === "overlay" ? "light" : "auto"} />
          </a>

          <nav
            aria-label="Navigation principale"
            className="hidden items-center gap-6 lg:flex"
          >
            {NAV.map((n) => (
              <Link
                key={n.href}
                href={n.href}
                className={cn(
                  "text-[14.5px] font-medium transition-colors duration-200",
                  variant === "overlay"
                    ? "text-white/70 hover:text-white"
                    : "text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]",
                )}
              >
                {n.label}
              </Link>
            ))}
          </nav>

          <div className="flex items-center gap-2 sm:gap-3">
            {variant === "solid" && <ThemeToggle />}
            <Link
              href="/login"
              className={cn(
                "cq-tap hidden items-center px-2 text-[14.5px] font-medium transition-colors duration-200 sm:inline-flex",
                variant === "overlay"
                  ? "text-white/70 hover:text-white"
                  : "text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]",
              )}
            >
              Se connecter
            </Link>
            <Link
              href="/signup"
              className="cq-tap cq-btn cq-btn-shine inline-flex items-center rounded-xl bg-[#E0162B] px-4 py-2.5 text-[14.5px] font-semibold text-white hover:bg-[#C8102A]"
            >
              Créer un compte
            </Link>
            <button
              type="button"
              aria-expanded={menuOpen}
              aria-controls="menu-mobile"
              aria-label={menuOpen ? "Fermer le menu" : "Ouvrir le menu"}
              onClick={() => setMenuOpen((v) => !v)}
              className={cn(
                "cq-tap grid place-items-center rounded-xl border px-2 lg:hidden",
                onDark
                  ? "border-white/18 text-white"
                  : variant === "overlay"
                    ? "border-white/18 text-white"
                    : "border-[var(--outline)] text-[var(--on-surface)]",
              )}
            >
              <svg viewBox="0 0 18 18" className="h-4 w-4" aria-hidden="true">
                {menuOpen ? (
                  <path
                    d="M4 4l10 10M14 4L4 14"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.8"
                    strokeLinecap="round"
                  />
                ) : (
                  <path
                    d="M2.5 5h13M2.5 9h13M2.5 13h13"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.8"
                    strokeLinecap="round"
                  />
                )}
              </svg>
            </button>
          </div>
        </div>

        {menuOpen && (
          <nav
            id="menu-mobile"
            aria-label="Navigation mobile"
            className={cn(
              "lg:hidden",
              variant === "overlay"
                ? "border-t border-white/10 bg-[#00061F]/97 backdrop-blur-xl"
                : "border-t border-[var(--outline)] bg-[var(--surface)]",
            )}
          >
            <ul className="mx-auto max-w-7xl px-4 py-3 sm:px-6">
              {NAV.map((n) => (
                <li key={n.href}>
                  <Link
                    href={n.href}
                    onClick={() => setMenuOpen(false)}
                    className={cn(
                      "cq-tap flex items-center py-2.5 text-[15px] font-medium",
                      variant === "overlay"
                        ? "text-white/80"
                        : "text-[var(--on-surface)]",
                    )}
                  >
                    {n.label}
                  </Link>
                </li>
              ))}
              <li>
                <Link
                  href="/login"
                  onClick={() => setMenuOpen(false)}
                  className={cn(
                    "cq-tap flex items-center py-2.5 text-[15px] font-medium",
                    variant === "overlay" ? "text-white/80" : "text-[var(--on-surface)]",
                  )}
                >
                  Se connecter
                </Link>
              </li>
            </ul>
          </nav>
        )}
      </header>
    </>
  )
}

/* ───────────────────────────────────────────────────────────────────────── */

const FOOTER_COLUMNS = [
  {
    title: "Préparation",
    links: [
      ["Gardien de la paix", "/preparation/gardien-de-la-paix"],
      ["Policier adjoint", "/preparation/policier-adjoint"],
      ["Tests psychotechniques", "/preparation/tests-psychotechniques"],
      ["Cas pratique", "/preparation/cas-pratique"],
      ["Culture générale", "/preparation/culture-generale"],
      ["Préparation à l’oral", "/preparation/oral"],
      ["Réserve de la Police nationale", "/preparation/reserve"],
    ],
  },
  {
    title: "Plateforme",
    links: [
      ["Fonctionnalités", "/#produit"],
      ["Tarifs", "/tarifs"],
      ["Ressources", "/ressources"],
      ["Blog", "/blog"],
      ["Notes de mise à jour", "/notes-de-mise-a-jour"],
    ],
  },
  {
    title: "Compte",
    links: [
      ["Créer un compte", "/signup"],
      ["Se connecter", "/login"],
      ["Mot de passe oublié", "/forgot-password"],
      ["Aide", "/informations"],
      ["Contact", "/contact"],
    ],
  },
  {
    title: "Légal",
    links: [
      ["Confidentialité", "/privacy"],
      ["Conditions d’utilisation", "/cgu"],
      ["Mentions légales", "/mentions-legales"],
      ["FAQ", "/faq"],
    ],
  },
] as const

export function SiteFooter() {
  return (
    <footer className="border-t border-white/10 bg-[#00061F] text-white">
      <div className="mx-auto max-w-7xl px-4 py-14 sm:px-6 xl:px-8">
        <div className="grid gap-10 lg:grid-cols-[minmax(0,1fr)_minmax(0,2.2fr)]">
          <div>
            <BrandWordmark size={44} tone="light" />
            <Tricolore className="mt-5 h-1 w-12" />
            <p className="mt-5 max-w-xs text-[14px] leading-relaxed text-white/60">
              Préparation aux concours, aux sélections et à la scolarité de la
              Police nationale. Mobile et web, un seul compte.
            </p>
          </div>

          <div className="grid grid-cols-2 gap-8 sm:grid-cols-4">
            {FOOTER_COLUMNS.map((col) => (
              <div key={col.title}>
                <h2 className="text-[14px] font-semibold text-white">{col.title}</h2>
                <ul className="mt-3.5 space-y-2.5">
                  {col.links.map(([label, href]) => (
                    <li key={label}>
                      <Link
                        href={href}
                        className="text-[14px] text-white/62 transition-colors duration-200 hover:text-white"
                      >
                        {label}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>

        {/* Mention d'indépendance institutionnelle — visible sur chaque page (§45) */}
        <p className="mt-12 border-t border-white/10 pt-7 text-[12px] leading-relaxed text-white/55">
          {INDEPENDENCE_NOTICE}
        </p>

        <div className="mt-5 flex flex-wrap items-center justify-between gap-x-6 gap-y-3">
          <span className="text-[12px] text-white/55">
            © {new Date().getFullYear()} COP’IQ. Tous droits réservés.
          </span>
          {/* Le RGPD impose que le consentement soit retirable aussi
              facilement qu'il a été donné : ce lien rouvre le bandeau. */}
          <ConsentLink className="!text-[12px] !text-white/55 hover:!text-white/75" />
        </div>
      </div>
    </footer>
  )
}
