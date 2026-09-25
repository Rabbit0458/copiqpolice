"use client"

import Link from "next/link"
import { useEffect, useState } from "react"
import { cn } from "@/lib/utils"
import { CopiqWordmark } from "@/components/brand/copiq-logo"
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
 * Le logo passe par `CopiqWordmark`, jamais par une approximation CSS.
 */

const NAV = [
  { label: "La plateforme", href: "/#produit" },
  { label: "Parcours", href: "/#parcours" },
  { label: "Préparation", href: "/preparation/gardien-de-la-paix" },
  { label: "Ressources", href: "/ressources" },
  { label: "Tarifs", href: "/tarifs" },
] as const

export function SiteHeader({ variant = "solid" }: { variant?: "solid" | "overlay" }) {
  const [scrolled, setScrolled] = useState(variant === "solid")
  const [menuOpen, setMenuOpen] = useState(false)

  useEffect(() => {
    if (variant === "solid") return
    const onScroll = () => setScrolled(window.scrollY > 48)
    onScroll()
    window.addEventListener("scroll", onScroll, { passive: true })
    return () => window.removeEventListener("scroll", onScroll)
  }, [variant])

  /** L'en-tête est sur fond sombre quand il survole le hero. */
  const onDark = variant === "overlay" && !scrolled

  return (
    <>
      <a href="#contenu" className="cq-skip">
        Aller au contenu principal
      </a>

      <header
        className={cn(
          "sticky top-0 z-50 transition-colors duration-300",
          variant === "overlay"
            ? scrolled
              ? "border-b border-white/10 bg-[#00061F]/92 backdrop-blur-xl"
              : "border-b border-transparent"
            : "border-b border-[var(--outline)] bg-[var(--surface)]/92 backdrop-blur-xl",
        )}
      >
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between gap-4 px-4 sm:px-6 xl:px-8">
          <Link href="/" aria-label="COP'IQ — accueil" className="shrink-0">
            <CopiqWordmark
              size={36}
              priority
              tone={variant === "overlay" ? "light" : "auto"}
            />
          </Link>

          <nav
            aria-label="Navigation principale"
            className="hidden items-center gap-6 lg:flex"
          >
            {NAV.map((n) => (
              <Link
                key={n.href}
                href={n.href}
                className={cn(
                  "text-[13.5px] font-medium transition-colors duration-200",
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
                "cq-tap hidden items-center px-2 text-[13.5px] font-medium transition-colors duration-200 sm:inline-flex",
                variant === "overlay"
                  ? "text-white/70 hover:text-white"
                  : "text-[var(--on-surface-muted)] hover:text-[var(--on-surface)]",
              )}
            >
              Connexion
            </Link>
            <Link
              href="/signup"
              className="cq-tap inline-flex items-center rounded-xl bg-[#1147D9] px-4 py-2.5 text-[13.5px] font-semibold text-white shadow-[0_6px_24px_-6px_rgba(17,71,217,0.7)] transition-colors duration-200 hover:bg-[#1A55E6]"
            >
              Commencer
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
                  Connexion
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
    <footer className="cq-night border-t border-white/10">
      <div className="mx-auto max-w-7xl px-4 py-14 sm:px-6 xl:px-8">
        <div className="grid gap-10 lg:grid-cols-[minmax(0,1fr)_minmax(0,2.2fr)]">
          <div>
            <CopiqWordmark size={40} tone="light" />
            <p className="mt-4 max-w-xs text-[13px] leading-relaxed text-white/55">
              Préparation aux concours, aux sélections et à la scolarité de la
              Police nationale. Mobile et web, un seul compte.
            </p>
          </div>

          <div className="grid grid-cols-2 gap-8 sm:grid-cols-4">
            {FOOTER_COLUMNS.map((col) => (
              <div key={col.title}>
                <h2 className="cq-eyebrow text-white/55">{col.title}</h2>
                <ul className="mt-3.5 space-y-2.5">
                  {col.links.map(([label, href]) => (
                    <li key={label}>
                      <Link
                        href={href}
                        className="text-[13px] text-white/65 transition-colors duration-200 hover:text-white"
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
            © {new Date().getFullYear()} COP’IQ — Tous droits réservés
          </span>
          {/* Le RGPD impose que le consentement soit retirable aussi
              facilement qu'il a été donné : ce lien rouvre le bandeau. */}
          <ConsentLink className="!text-[12px] !text-white/55 hover:!text-white/75" />
        </div>
      </div>
    </footer>
  )
}
