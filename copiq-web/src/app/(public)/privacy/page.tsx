import type { Metadata } from "next";
import { EditorialDocument } from "@/components/information/editorial-document";
export const metadata: Metadata = {
  title: "Politique de confidentialité — COP'IQ",
};
const fallback = `## 1. Responsable du traitement
COP'IQ est responsable du traitement de vos données personnelles. Pour toute question : **contact@copiq.fr**.

## 2. Données collectées
Nous collectons les données nécessaires au compte, à la progression, aux résultats, au fonctionnement du service et à la facturation. Les paiements sont traités par Stripe : COP'IQ ne stocke pas le numéro complet de ta carte bancaire.

## 3. Finalités du traitement
- Gérer ton compte et synchroniser ta progression.
- Traiter ton abonnement et afficher son état.
- Assurer la sécurité et améliorer la qualité du service.
- Répondre à tes demandes de support.

## 4. Base légale
Les traitements reposent selon les cas sur l'exécution du contrat, ton consentement, nos obligations légales et notre intérêt légitime à sécuriser et améliorer COP'IQ.

## 5. Durée de conservation
Les données sont conservées pendant les durées nécessaires au service et aux obligations légales, notamment comptables.

## 6. Prestataires
COP'IQ utilise notamment Supabase pour l'infrastructure et Stripe pour la facturation. Aucune donnée personnelle n'est vendue à des tiers.

## 7. Tes droits
Tu disposes de droits d'accès, de rectification, d'effacement, de limitation, d'opposition et de portabilité. Tu peux exercer ces droits via **contact@copiq.fr**. Tu peux également saisir la CNIL.

## 8. Sécurité
Les échanges sont chiffrés et les accès aux données sont contrôlés. Aucun service en ligne ne pouvant garantir un risque nul, COP'IQ améliore continuellement ses protections.

## 9. Contact
Pour toute question relative à la confidentialité : **contact@copiq.fr**.`;
export default function PrivacyPage() {
  return (
    <EditorialDocument
      type="privacy"
      title="Politique de confidentialité"
      fallback={fallback}
      updatedAt="1er juin 2026"
    />
  );
}
