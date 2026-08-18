# Règle permanente — uniformisation COP'IQ

Date d'enregistrement : 17 août 2026

## Principe

Une correction demandée sur une page représentative doit être recherchée et vérifiée sur toutes les pages homologues de l'application. Si elles utilisent le même type d'écran, le même composant ou la même logique, elles doivent recevoir la même correction afin de préserver une expérience uniforme.

## Périmètre obligatoire

- Scolarité GPX
- Scolarité PA
- Exam GPX
- Exam PA
- Quiz associés
- Écrans de sélection du niveau
- Écrans de résultat et de fin de quiz
- Sous-pages et redirections concernées

## Méthode de validation

- Recenser les occurrences à partir de la cartographie et du code.
- Appliquer la correction au composant partagé lorsque cela est possible.
- Contrôler les implémentations particulières qui ne réutilisent pas ce composant.
- Tester les parcours et les redirections sur iOS et Android lorsque la modification touche l'interface.
- Indiquer le nombre de pages contrôlées, modifiées et laissées inchangées.

## Exemple fourni par le propriétaire

Une demande concernant une page de sélection du niveau avant un quiz implique la vérification de toutes les pages de sélection du niveau de GPX, PA, Exam GPX et Exam PA. Une couleur citée uniquement pour illustrer cette règle ne doit pas être modifiée sans demande réelle.

## Références

- `progression/CARTOGRAPHIE_COMPLETE_SCOLARITE_GPX_PA.md`
- `progression/CARTOGRAPHIE_PYRAMIDALE_SCOLARITE_GPX_PA.png`
- `progression/migration_data/sources.jsonl`
