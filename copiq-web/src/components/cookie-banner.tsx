"use client"

/**
 * COP'IQ — Bandeau de consentement aux cookies
 *
 * Conforme aux recommandations de la CNIL :
 *  • « Tout refuser » est aussi accessible et aussi visible que « Tout accepter » ;
 *  • aucun traceur non essentiel n'est déposé avant un choix explicite ;
 *  • le paramétrage fin est accessible en un clic ;
 *  • le choix est révocable depuis le pied de page (`<ConsentLink />`).
 */

import { useEffect, useState } from "react"
import Link from "next/link"
import {
  DEFAULT_CONSENT,
  getConsent,
  resetConsent,
  setConsent,
  type ConsentCategories,
} from "@/lib/consent"

type Choice = Omit<ConsentCategories, "necessary">

export function CookieBanner() {
  const [visible, setVisible] = useState(false)
  const [details, setDetails] = useState(false)
  const [choice, setChoice] = useState<Choice>({
    analytics: DEFAULT_CONSENT.analytics,
    marketing: DEFAULT_CONSENT.marketing,
  })

  useEffect(() => {
    // Le rendu est différé au montage : le composant est côté client, ce qui
    // évite toute divergence d'hydratation entre serveur et navigateur.
    if (getConsent() === null) setVisible(true)

    const reopen = () => {
      setDetails(false)
      setChoice({ analytics: false, marketing: false })
      setVisible(true)
    }
    window.addEventListener("copiq:consent-reset", reopen)
    return () => window.removeEventListener("copiq:consent-reset", reopen)
  }, [])

  if (!visible) return null

  function decide(next: Choice) {
    setConsent(next)
    setVisible(false)
  }

  return (
    <div
      role="dialog"
      aria-modal="false"
      aria-labelledby="cookie-title"
      aria-describedby="cookie-desc"
      className="fixed inset-x-0 bottom-0 z-[100] p-3 sm:p-4"
    >
      <div className="mx-auto max-w-3xl rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5 shadow-2xl">
        <h2 id="cookie-title" className="text-base font-semibold">
          Cookies et données
        </h2>

        <p
          id="cookie-desc"
          className="mt-2 text-sm leading-relaxed text-[var(--on-surface-muted)]"
        >
          Nous utilisons des cookies strictement nécessaires au fonctionnement du
          site (connexion, sécurité). Avec ton accord, nous pouvons aussi mesurer
          l&apos;audience pour améliorer la préparation au concours. Tu peux
          refuser sans conséquence sur ton utilisation du site.{" "}
          <Link
            href="/privacy"
            className="font-medium text-[var(--brand)] underline underline-offset-2"
          >
            Politique de confidentialité
          </Link>
        </p>

        {details && (
          <div className="mt-4 space-y-2.5 rounded-xl border border-[var(--outline-variant)] p-3.5">
            <Row
              title="Strictement nécessaires"
              desc="Session, authentification, sécurité. Indispensables au fonctionnement du site."
              checked
              disabled
            />
            <Row
              title="Mesure d'audience"
              desc="Pages consultées et parcours, de façon agrégée, pour améliorer le contenu."
              checked={choice.analytics}
              onChange={(v) => setChoice({ ...choice, analytics: v })}
            />
            <Row
              title="Publicité"
              desc="Personnalisation des annonces et mesure des campagnes."
              checked={choice.marketing}
              onChange={(v) => setChoice({ ...choice, marketing: v })}
            />
          </div>
        )}

        {/* Refuser et accepter ont volontairement le même poids visuel :
            c'est une exigence de la CNIL. */}
        <div className="mt-4 flex flex-col gap-2 sm:flex-row">
          <button
            onClick={() => decide({ analytics: false, marketing: false })}
            className="flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]"
          >
            Tout refuser
          </button>

          {details ? (
            <button
              onClick={() => decide(choice)}
              className="flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]"
            >
              Enregistrer mes choix
            </button>
          ) : (
            <button
              onClick={() => setDetails(true)}
              className="flex-1 rounded-xl border border-[var(--outline)] px-4 py-2.5 text-sm font-semibold transition hover:bg-[var(--surface-container)]"
            >
              Personnaliser
            </button>
          )}

          <button
            onClick={() => decide({ analytics: true, marketing: true })}
            className="flex-1 rounded-xl bg-[var(--brand)] px-4 py-2.5 text-sm font-semibold text-white transition hover:brightness-110"
          >
            Tout accepter
          </button>
        </div>
      </div>
    </div>
  )
}

function Row({
  title,
  desc,
  checked,
  disabled,
  onChange,
}: {
  title: string
  desc: string
  checked: boolean
  disabled?: boolean
  onChange?: (v: boolean) => void
}) {
  return (
    <label
      className={`flex items-start gap-3 ${disabled ? "opacity-60" : "cursor-pointer"}`}
    >
      <input
        type="checkbox"
        checked={checked}
        disabled={disabled}
        onChange={(e) => onChange?.(e.target.checked)}
        className="mt-0.5 h-4 w-4 shrink-0"
      />
      <span className="min-w-0">
        <span className="block text-sm font-medium">
          {title}
          {disabled && (
            <span className="ml-2 text-[11px] font-normal text-[var(--on-surface-faint)]">
              toujours actifs
            </span>
          )}
        </span>
        <span className="block text-xs text-[var(--on-surface-muted)]">
          {desc}
        </span>
      </span>
    </label>
  )
}

/**
 * Lien de révocation, à placer dans le pied de page.
 * Le RGPD impose que le consentement soit retirable aussi facilement
 * qu'il a été donné.
 */
export function ConsentLink({ className = "" }: { className?: string }) {
  return (
    <button
      onClick={resetConsent}
      className={`text-sm text-[var(--on-surface-muted)] underline-offset-2 hover:underline ${className}`}
    >
      Gérer mes cookies
    </button>
  )
}
