import type { Metadata } from "next"
import Link from "next/link"

export const metadata: Metadata = {
  title: "Mentions légales — COP'IQ",
  description:
    "Éditeur, hébergeur, propriété intellectuelle et contact — COP'IQ, préparation aux concours de la Police Nationale.",
}

/**
 * Mentions légales — obligation de l'article 6 III de la LCEN
 * (loi n° 2004-575 du 21 juin 2004 pour la confiance dans l'économie numérique).
 *
 * ⚠️ Les valeurs entre crochets doivent être complétées avant la mise en
 * production : la LCEN impose l'identité exacte de l'éditeur, et son absence
 * est passible d'un an d'emprisonnement et 75 000 € d'amende (art. 6 VI).
 */
export default function MentionsLegalesPage() {
  const sections: { title: string; body: React.ReactNode }[] = [
    {
      title: "1. Éditeur du site",
      body: (
        <>
          <p className="mb-2">
            Le site <strong>copiq.fr</strong> et l&apos;application mobile
            COP&apos;IQ sont édités par :
          </p>
          <ul className="ml-4 list-disc space-y-1">
            <li>
              <strong>Dénomination</strong> : [Raison sociale ou nom de
              l&apos;entrepreneur individuel]
            </li>
            <li>
              <strong>Forme juridique</strong> : [SAS / SASU / EI / micro-entreprise]
            </li>
            <li>
              <strong>Siège social</strong> : [Adresse complète]
            </li>
            <li>
              <strong>SIREN / SIRET</strong> : [Numéro]
            </li>
            <li>
              <strong>TVA intracommunautaire</strong> : [Numéro, le cas échéant]
            </li>
            <li>
              <strong>Directeur de la publication</strong> : Kaïs Ouartani
            </li>
            <li>
              <strong>Contact</strong> :{" "}
              <a
                href="mailto:contact@copiq.fr"
                className="text-[var(--brand)] underline underline-offset-2"
              >
                contact@copiq.fr
              </a>
            </li>
          </ul>
        </>
      ),
    },
    {
      title: "2. Hébergement",
      body: (
        <>
          <p className="mb-2">
            Les données et l&apos;infrastructure applicative sont hébergées par :
          </p>
          <ul className="ml-4 list-disc space-y-1">
            <li>
              <strong>Supabase, Inc.</strong> — 970 Toa Payoh North, Singapour.
              Les données de la base sont localisées dans la région{" "}
              <strong>eu-west-3 (Paris, France)</strong>.
            </li>
            <li>
              <strong>[Hébergeur du site web]</strong> — [Adresse et téléphone]
            </li>
          </ul>
        </>
      ),
    },
    {
      title: "3. Propriété intellectuelle",
      body: (
        <p>
          L&apos;ensemble des contenus présents sur COP&apos;IQ — fiches de
          cours, questions de quiz, cas pratiques, grilles de correction,
          réponses modèles, interface, charte graphique — est protégé par le
          droit de la propriété intellectuelle et demeure la propriété exclusive
          de l&apos;éditeur. Toute reproduction, représentation, adaptation ou
          extraction, totale ou partielle, sans autorisation écrite préalable,
          est interdite et constitue une contrefaçon sanctionnée par les
          articles L335-2 et suivants du Code de la propriété intellectuelle.
        </p>
      ),
    },
    {
      title: "4. Sources juridiques",
      body: (
        <p>
          Les contenus pédagogiques s&apos;appuient sur les textes officiels
          publiés sur Légifrance (Code pénal, Code de procédure pénale, Code de
          la sécurité intérieure, Code de la route, Code de la santé publique).
          Ces textes évoluant régulièrement, COP&apos;IQ ne garantit pas leur
          exhaustivité à un instant donné et ne saurait se substituer à une
          consultation des sources officielles.
        </p>
      ),
    },
    {
      title: "5. Données personnelles",
      body: (
        <p>
          Le traitement des données personnelles est décrit dans notre{" "}
          <Link
            href="/privacy"
            className="text-[var(--brand)] underline underline-offset-2"
          >
            politique de confidentialité
          </Link>
          . Conformément au RGPD et à la loi Informatique et Libertés, tu
          disposes d&apos;un droit d&apos;accès, de rectification,
          d&apos;effacement, de limitation, d&apos;opposition et de portabilité.
          Ces droits s&apos;exercent depuis l&apos;application (Paramètres →
          Mes données) ou par courriel à{" "}
          <a
            href="mailto:privacy@copiq.fr"
            className="text-[var(--brand)] underline underline-offset-2"
          >
            privacy@copiq.fr
          </a>
          . Tu peux également introduire une réclamation auprès de la CNIL
          (www.cnil.fr).
        </p>
      ),
    },
    {
      title: "6. Cookies",
      body: (
        <p>
          COP&apos;IQ dépose des cookies strictement nécessaires au
          fonctionnement du service. Les cookies de mesure d&apos;audience et de
          publicité ne sont déposés qu&apos;après consentement explicite. Ton
          choix est conservé 13 mois et reste modifiable à tout moment via le
          lien « Gérer mes cookies » en pied de page.
        </p>
      ),
    },
    {
      title: "7. Signalement d'une vulnérabilité",
      body: (
        <p>
          Si tu découvres une faille de sécurité, écris à{" "}
          <a
            href="mailto:security@copiq.fr"
            className="text-[var(--brand)] underline underline-offset-2"
          >
            security@copiq.fr
          </a>{" "}
          avant toute divulgation publique. Notre politique de divulgation est
          publiée au format RFC 9116 sur{" "}
          <a
            href="/.well-known/security.txt"
            className="text-[var(--brand)] underline underline-offset-2"
          >
            /.well-known/security.txt
          </a>
          .
        </p>
      ),
    },
    {
      title: "8. Médiation de la consommation",
      body: (
        <p>
          Conformément à l&apos;article L612-1 du Code de la consommation, tout
          consommateur peut recourir gratuitement à un médiateur de la
          consommation en vue de la résolution amiable d&apos;un litige.
          Médiateur désigné : <strong>[Nom et coordonnées du médiateur]</strong>.
          La plateforme européenne de règlement en ligne des litiges est
          accessible à l&apos;adresse{" "}
          <a
            href="https://ec.europa.eu/consumers/odr"
            rel="noopener noreferrer"
            target="_blank"
            className="text-[var(--brand)] underline underline-offset-2"
          >
            ec.europa.eu/consumers/odr
          </a>
          .
        </p>
      ),
    },
    {
      title: "9. Indépendance",
      body: (
        <p>
          COP&apos;IQ est un service de préparation privé, sans lien avec le
          ministère de l&apos;Intérieur, la Police nationale ou tout organisme
          officiel organisant les concours. Les marques et logos officiels
          demeurent la propriété de leurs titulaires respectifs.
        </p>
      ),
    },
  ]

  return (
    <div className="mx-auto max-w-3xl px-4 py-16">
      <h1 className="mb-2 text-3xl font-bold text-[var(--on-surface)]">
        Mentions légales
      </h1>
      <p className="mb-10 text-sm text-[var(--on-surface-muted)]">
        Dernière mise à jour : 26 juillet 2026
      </p>

      <div className="space-y-8 text-sm leading-relaxed text-[var(--on-surface-muted)]">
        {sections.map(({ title, body }) => (
          <section key={title}>
            <h2 className="mb-2 text-base font-semibold text-[var(--on-surface)]">
              {title}
            </h2>
            {body}
          </section>
        ))}
      </div>
    </div>
  )
}
