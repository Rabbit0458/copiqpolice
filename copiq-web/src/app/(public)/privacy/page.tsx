import type { Metadata } from "next"
export const metadata: Metadata = { title: "Politique de confidentialité — COP'IQ" }
export default function PrivacyPage() {
  return (
    <div className="max-w-3xl mx-auto px-4 py-16">
      <h1 className="text-3xl font-bold text-[var(--on-surface)] mb-2">Politique de confidentialité</h1>
      <p className="text-sm text-[var(--on-surface-muted)] mb-10">Dernière mise à jour : 1er juin 2026</p>
      <div className="prose prose-sm max-w-none text-[var(--on-surface-muted)] space-y-8">
        {[
          { title: "1. Responsable du traitement", content: "COP'IQ est responsable du traitement de vos données personnelles. Pour toute question : contact@copiqpolice.app" },
          { title: "2. Données collectées", content: "Nous collectons : adresse email (inscription), progression et résultats de quiz (synchronisation mobile/web), données de paiement Stripe (nous ne stockons pas les numéros de carte), adresse IP et données de navigation (analytics Firebase)." },
          { title: "3. Finalités du traitement", content: "Vos données sont utilisées pour : gérer votre compte et votre progression, traiter votre abonnement via Stripe, améliorer nos services grâce aux analytics, vous envoyer des notifications (si activées)." },
          { title: "4. Base légale", content: "Le traitement repose sur votre consentement (inscription), l'exécution du contrat d'abonnement, et nos intérêts légitimes (amélioration du service)." },
          { title: "5. Durée de conservation", content: "Vos données sont conservées pendant la durée de votre compte + 3 ans après fermeture, conformément aux obligations légales. Les données de paiement sont conservées 10 ans (obligation comptable)." },
          { title: "6. Partage des données", content: "Nous partageons vos données avec : Supabase (hébergement BDD, USA - standard contractuel), Stripe (paiement, USA - Privacy Shield), Firebase/Google (analytics, USA - standard contractuel). Aucune vente à des tiers." },
          { title: "7. Vos droits", content: "Vous disposez d'un droit d'accès, de rectification, d'effacement, de portabilité et d'opposition. Pour exercer vos droits : contact@copiqpolice.app. Vous pouvez également supprimer votre compte directement dans l'application (Paramètres → Supprimer mon compte)." },
          { title: "8. Cookies", content: "Nous utilisons des cookies essentiels (session, authentification) et des cookies d'analyse (Firebase Analytics). Vous pouvez refuser les cookies non essentiels dans les paramètres de votre navigateur." },
          { title: "9. Sécurité", content: "Vos données sont chiffrées en transit (HTTPS/TLS) et au repos. Supabase applique des politiques RLS (Row Level Security) garantissant que chaque utilisateur n'accède qu'à ses propres données." },
          { title: "10. Contact & réclamation", content: "DPO : contact@copiqpolice.app. En cas de désaccord non résolu, vous pouvez saisir la CNIL (www.cnil.fr)." },
        ].map(({ title, content }) => (
          <section key={title}>
            <h2 className="text-lg font-semibold text-[var(--on-surface)] mb-2">{title}</h2>
            <p className="leading-relaxed">{content}</p>
          </section>
        ))}
      </div>
    </div>
  )
}
