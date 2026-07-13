import type { Metadata } from "next"
export const metadata: Metadata = { title: "Conditions Générales d'Utilisation — COP'IQ" }
export default function CguPage() {
  return (
    <div className="max-w-3xl mx-auto px-4 py-16">
      <h1 className="text-3xl font-bold text-[var(--on-surface)] mb-2">Conditions Générales d&apos;Utilisation</h1>
      <p className="text-sm text-[var(--on-surface-muted)] mb-10">Dernière mise à jour : 1er juin 2026</p>
      <div className="space-y-8 text-sm text-[var(--on-surface-muted)] leading-relaxed">
        {[
          { title: "1. Objet", content: "Les présentes CGU régissent l'utilisation de la plateforme COP'IQ (site web et application mobile) permettant la préparation aux concours de la Police Nationale française." },
          { title: "2. Inscription et compte", content: "L'inscription est ouverte à toute personne majeure. Vous êtes responsable de la confidentialité de vos identifiants. Tout usage frauduleux doit être signalé immédiatement à contact@copiqpolice.app." },
          { title: "3. Offre gratuite", content: "L'offre gratuite donne accès à un sous-ensemble de quiz et à 10 requêtes de cas pratiques par semaine glissante. Elle inclut des publicités Google Ads." },
          { title: "4. Abonnement Premium", content: "L'abonnement Premium est proposé en formules hebdomadaire (4,99€), mensuelle (8,99€) et annuelle (86,99€). Il donne accès à l'intégralité des contenus sans publicité. L'abonnement se renouvelle automatiquement jusqu'à annulation. Vous disposez d'un droit de rétractation de 14 jours sauf utilisation du service." },
          { title: "5. Propriété intellectuelle", content: "Tous les contenus (cours, questions, corrections) sont la propriété exclusive de COP'IQ. Toute reproduction, redistribution ou revente, même partielle, est strictement interdite. Les cours premium sont protégés par watermark et mesures anti-copie." },
          { title: "6. Contenu du forum", content: "Les utilisateurs sont responsables de leurs publications sur le forum. COP'IQ se réserve le droit de supprimer tout contenu illicite, offensant ou contraire aux règles de la communauté. Les contrevenants peuvent être bannis sans préavis." },
          { title: "7. Exactitude des contenus", content: "COP'IQ s'efforce de maintenir des contenus juridiques à jour. Cependant, les textes législatifs évoluant, COP'IQ ne garantit pas l'exactitude absolue des informations et ne saurait être tenu responsable d'un échec au concours." },
          { title: "8. Limitation de responsabilité", content: "COP'IQ ne peut être tenu responsable des dommages indirects liés à l'utilisation du service, aux interruptions techniques ou à l'inexactitude de contenus pédagogiques." },
          { title: "9. Résiliation", content: "Vous pouvez fermer votre compte à tout moment depuis Paramètres → Supprimer mon compte. COP'IQ peut suspendre un compte en cas de violation des CGU." },
          { title: "10. Droit applicable", content: "Les présentes CGU sont soumises au droit français. Tout litige sera porté devant les tribunaux compétents de Paris." },
        ].map(({ title, content }) => (
          <section key={title}>
            <h2 className="text-base font-semibold text-[var(--on-surface)] mb-2">{title}</h2>
            <p>{content}</p>
          </section>
        ))}
      </div>
    </div>
  )
}
