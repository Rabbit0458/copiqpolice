import type { Metadata } from "next"
import Link from "next/link"
import { CopiqLogo } from "@/components/brand/copiq-logo"
import { INDEPENDENCE_NOTICE_SHORT } from "@/data/marketing"

/**
 * 404.
 *
 * Rendue dans la coque racine uniquement (pas de `(public)/layout`), donc
 * autonome : elle embarque son propre retour de navigation.
 *
 * Ton : sobre. Pas de caricature policière, pas de gyrophare animé (§55).
 * En export statique, Next produit `404.html`, que `.htaccess` sert déjà en
 * dernier recours (`RewriteRule ^ /404.html [L]`).
 */

export const metadata: Metadata = {
  title: "Page introuvable",
  description: "Cette page n'existe pas ou a été déplacée.",
  robots: { index: false, follow: true },
}

const SHORTCUTS = [
  ["Accueil", "/"],
  ["Tarifs", "/tarifs"],
  ["Ressources", "/ressources"],
  ["Se connecter", "/login"],
  ["Aide", "/informations"],
  ["Contact", "/contact"],
] as const

export default function NotFound() {
  return (
    <main className="cq-night cq-synapse relative flex min-h-screen items-center overflow-hidden">
      <span
        aria-hidden="true"
        className="cq-drift pointer-events-none absolute left-[-12%] top-[-18%] h-[26rem] w-[26rem] rounded-full bg-[rgb(17_71_217/0.28)] blur-[110px]"
      />
      <span
        aria-hidden="true"
        className="cq-drift pointer-events-none absolute bottom-[-20%] right-[-8%] h-[20rem] w-[20rem] rounded-full bg-[rgb(224_22_43/0.14)] blur-[110px]"
        style={{ animationDelay: "-6s" }}
      />

      <div className="relative mx-auto w-full max-w-2xl px-4 py-20 sm:px-6">
        <Link href="/" aria-label="COP'IQ — accueil" className="inline-block">
          <CopiqLogo size={52} priority halo />
        </Link>

        <p className="cq-eyebrow mt-10 text-[#7FB3FF]">Erreur 404</p>
        <h1 className="cq-title mt-3 text-white">
          Vous avez quitté la zone de préparation.
        </h1>
        <p className="cq-lead mt-5 text-white/65">
          Cette page n’existe pas, ou elle a changé d’adresse. Rien n’est perdu :
          votre progression est enregistrée sur votre compte.
        </p>

        <div className="mt-9 flex flex-col gap-3 sm:flex-row">
          <Link
            href="/"
            className="cq-tap inline-flex items-center justify-center rounded-2xl bg-[#1147D9] px-6 py-3.5 text-[15px] font-semibold text-white shadow-[0_10px_40px_-8px_rgba(17,71,217,0.75)] transition-colors duration-200 hover:bg-[#1A55E6]"
          >
            Retour à COP’IQ
          </Link>
          <Link
            href="/dashboard"
            className="cq-tap inline-flex items-center justify-center rounded-2xl border border-white/18 bg-white/[0.04] px-6 py-3.5 text-[15px] font-semibold text-white/85 transition-colors duration-200 hover:bg-white/[0.08]"
          >
            Reprendre ma préparation
          </Link>
        </div>

        <nav aria-label="Raccourcis" className="mt-12 border-t border-white/10 pt-7">
          <h2 className="cq-eyebrow text-white/55">Aller directement à</h2>
          <ul className="mt-4 flex flex-wrap gap-2">
            {SHORTCUTS.map(([label, href]) => (
              <li key={href}>
                <Link
                  href={href}
                  className="cq-tap inline-flex items-center rounded-xl border border-white/12 bg-white/[0.03] px-4 py-2.5 text-[13.5px] text-white/75 transition-colors duration-200 hover:border-white/25 hover:text-white"
                >
                  {label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        <p className="mt-12 text-[12px] text-white/55">
          {INDEPENDENCE_NOTICE_SHORT}
        </p>
      </div>
    </main>
  )
}
