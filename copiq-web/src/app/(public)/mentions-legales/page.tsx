import type { Metadata } from "next";
import { EditorialDocument } from "@/components/information/editorial-document";
export const metadata: Metadata = {
  title: "Mentions légales — COP'IQ",
  description: "Éditeur, hébergeur et informations légales COP'IQ.",
};
const fallback = `## 1. Éditeur du site
Le site **copiq.fr** et l'application mobile COP'IQ sont édités par :
- Dénomination : [à compléter avant mise en production]
- Forme juridique : [à compléter]
- Siège social : [à compléter]
- SIREN / SIRET : [à compléter]
- TVA intracommunautaire : [à compléter, le cas échéant]
- Directeur de la publication : **Kaïs Ouartani**
- Contact : **contact@copiq.fr**

## 2. Hébergement
Les données applicatives sont hébergées par **Supabase** dans la région configurée pour le projet. Les coordonnées définitives de l'hébergeur Web doivent être ajoutées avant la mise en production.

## 3. Propriété intellectuelle
Les fiches de cours, questions, cas pratiques, corrections, interfaces et éléments graphiques de COP'IQ sont protégés. Toute reproduction, adaptation ou extraction non autorisée est interdite.

## 4. Sources juridiques
Les contenus pédagogiques s'appuient notamment sur les textes officiels disponibles sur Légifrance. Ils ne remplacent pas la consultation des sources officielles à jour.

## 5. Données personnelles
Les traitements sont détaillés dans la politique de confidentialité. Pour exercer tes droits : **contact@copiq.fr**.

## 6. Médiation de la consommation
Les coordonnées du médiateur de la consommation doivent être complétées avant la commercialisation du service.

## 7. Indépendance
COP'IQ est un service privé de préparation, sans lien avec le ministère de l'Intérieur, la Police nationale ou un organisme officiel organisant les concours.`;
export default function MentionsPage() {
  return (
    <EditorialDocument
      type="legal_notice"
      title="Mentions légales"
      fallback={fallback}
      updatedAt="26 juillet 2026"
    />
  );
}
