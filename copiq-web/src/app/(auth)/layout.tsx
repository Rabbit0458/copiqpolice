import Link from "next/link"
import { CopiqWordmark } from "@/components/brand/copiq-logo"
import { PRODUCT_FACTS, INDEPENDENCE_NOTICE_SHORT } from "@/data/marketing"

/**
 * Coque des pages d'authentification.
 *
 * Trois corrections de fond, la première étant sérieuse :
 *  1. « 95 % — Satisfaction » et « 200+ Cours » étaient affichés ici sans
 *     aucune source. C'est de la preuve sociale inventée, interdite (§53) :
 *     remplacé par les faits vérifiables de `PRODUCT_FACTS`, dont la méthode
 *     de comptage est documentée.
 *  2. Le logo était une approximation CSS (carré dégradé + lettre « C ») :
 *     remplacé par le fichier officiel (§61).
 *  3. L'emoji 🚔 en pleine page a été retiré (§8).
 *
 * La logique d'authentification n'est pas touchée : cette coque n'est que du
 * visuel autour de `children`.
 */
export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-screen">
      {/* ── Colonne de marque (desktop) ───────────────────────────────── */}
      <div className="cq-night cq-synapse relative hidden flex-col overflow-hidden lg:flex lg:w-[480px] xl:w-[560px]">
        <span
          aria-hidden="true"
          className="cq-drift pointer-events-none absolute left-1/2 top-1/3 h-96 w-96 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[rgb(17_71_217/0.30)] blur-[110px]"
        />
        <span
          aria-hidden="true"
          className="cq-drift pointer-events-none absolute bottom-[18%] left-[12%] h-56 w-56 rounded-full bg-[rgb(224_22_43/0.12)] blur-[100px]"
          style={{ animationDelay: "-6s" }}
        />

        <div className="relative z-10 p-8">
          <Link href="/" aria-label="COP'IQ — accueil">
            <CopiqWordmark size={40} tone="light" priority />
          </Link>
        </div>

        <div className="relative z-10 flex flex-1 flex-col justify-center px-10 xl:px-12">
          <h2 className="cq-title text-white">
            Votre préparation vous attend.
          </h2>
          <p className="mt-5 text-[15px] leading-relaxed text-white/65">
            Quiz, cours de scolarité, cas pratiques corrigés, psychotechniques
            et suivi de progression. Le même compte que sur l’application
            mobile, la même progression.
          </p>

          <dl className="mt-12 grid grid-cols-2 gap-x-6 gap-y-6 border-t border-white/10 pt-8">
            {PRODUCT_FACTS.map((f) => (
              // `flex-col-reverse` : le chiffre se lit d'abord à l'écran,
              // l'ordre du DOM reste dt puis dd.
              <div key={f.label} className="flex flex-col-reverse">
                <dt className="mt-1 text-[12px] leading-tight text-white/55">
                  {f.label}
                </dt>
                <dd className="text-[1.5rem] font-bold tracking-[-0.03em] text-white tabular-nums">
                  {f.value}
                </dd>
              </div>
            ))}
          </dl>
        </div>

        <div className="relative z-10 space-y-2 p-8 text-[12px] text-white/55">
          <p>{INDEPENDENCE_NOTICE_SHORT}</p>
          <p>© {new Date().getFullYear()} COP&apos;IQ — Tous droits réservés</p>
        </div>
      </div>

      {/* ── Colonne formulaire ────────────────────────────────────────── */}
      <div className="flex flex-1 flex-col items-center justify-center bg-[var(--surface)] p-6">
        <div className="mb-8 lg:hidden">
          <Link href="/" aria-label="COP'IQ — accueil">
            <CopiqWordmark size={40} tone="auto" priority />
          </Link>
        </div>

        <div className="w-full max-w-[420px]">{children}</div>

        <p className="mt-10 max-w-[420px] text-center text-[11.5px] leading-relaxed text-[var(--on-surface-faint)] lg:hidden">
          {INDEPENDENCE_NOTICE_SHORT}
        </p>
      </div>
    </div>
  )
}
