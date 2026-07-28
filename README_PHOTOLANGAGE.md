# Épreuve de photolangage — Module PA (COP'IQ)

Module complet d'entraînement au commentaire de photographie pour la
sélection de Policier Adjoint : cas chronométrés chargés depuis la base,
moteur de correction hybride côté serveur, brouillons avec reprise exacte,
résultat annoté avec simulation de jury. Tous les scores sont des
indicateurs pédagogiques COP'IQ, jamais des notes officielles.

## Architecture

```
Flutter (lib/content/pa_exam/photolangage/)
  pa_photolangage_core.dart            modèles + repository + utilitaires texte
  pa_photolangage_hub_page.dart        accueil du module (3 sous-parties, reprise, stats)
  pa_photolangage_analyse_page.dart    « Analyse de l'épreuve » (+ mini quiz indicatif)
  pa_photolangage_etapes_page.dart     « Les étapes de la réussite » (7 étapes + checklist)
  pa_photolangage_training_pages.dart  liste des cas + intro + visionneuse d'image (zoom)
  pa_photolangage_editor_page.dart     éditeur chronométré (brouillons, seuils, expiration)
  pa_photolangage_result_page.dart     écran d'analyse + page de résultat
  pa_photolangage_history_page.dart    historique des copies

Supabase
  Tables    : photolangage_cases, photolangage_attempts, photolangage_drafts
  Edge Fn   : photolangage-correct (déployée, version 1)
  Migrations: photolangage_pa_schema, photolangage_pa_seed_cases_1_6, _7_11
```

## Routes

- `/pa_exam/concours/photolangage` → hub (ouverture directe depuis la home PA)
- `/pa_exam/concours/photolangage/analyse`
- `/pa_exam/concours/photolangage/etapes_reussite`
- `/pa_exam/concours/photolangage/entrainements`
- `/pa_exam/concours/photolangage/historique`

Le déroulé d'un cas (intro → image → rédaction → confirmation → analyse →
résultat) utilise des pushes internes `MaterialPageRoute`, conformément à la
navigation par map de routes du projet (pas de routes paramétrées).

## Les 11 cas

Seedés avec les images fournies (`assets/photolangage_pa/cas1..cas11` dans le
storage). **Chaque cas possède sa propre référence de correction** rédigée à
partir de l'analyse réelle de l'image : `sceneSummary`, `visibleElements`,
`spatialRelations`, `acceptedSynonyms`, `uncertainElements`,
`nonVisibleClaimsToReject`, `referenceDescription` (corrigé type),
`keyVocabulary`, plus conseils pédagogiques et exemples d'inférences
interdites. Difficultés : découverte (cas 2, 8, 9, 10), intermédiaire
(cas 1, 3, 4, 11), avancée (cas 5, 6, 7).

Pour ajouter un cas : insérer une ligne dans `photolangage_cases`
(id `case_12`…, `image_url`, `correction_reference` au même format). Aucun
changement de code nécessaire — la liste est chargée depuis la base.

## Timer 20 minutes (robuste)

La source de vérité est `deadline = startedAt + duration_seconds`, persistée
dans le brouillon (local + distant). L'UI se rafraîchit chaque seconde mais
recalcule toujours depuis l'horloge : pas de dérive en arrière-plan, reprise
exacte après fermeture ou crash. Le chronomètre démarre au clic sur
« Commencer la rédaction » ; revoir l'image ne le met jamais en pause.
Avertissements à 5 min et 1 min ; à 0 : verrouillage, sauvegarde, soumission
automatique si le double seuil (900 caractères ET 140 mots, configurables
par cas) est atteint, sinon tentative « temps écoulé — réponse incomplète »
avec analyse partielle proposée. Limite documentée : un changement d'heure
système côté client peut fausser l'affichage ; les horodatages de soumission
sont posés côté serveur.

## Seuils et anti-contournement

Bouton verrouillé sous `minimum_characters` + `minimum_words` (espaces
multiples et caractères invisibles non comptés). Détection non punitive au
moment de la validation : ratio de mots uniques trop bas, mot répété de
façon abusive, excès de caractères non linguistiques → message explicatif,
le candidat corrige son texte.

## Moteur de correction (Edge Function `photolangage-correct`)

1. **Auth & sécurité** : JWT vérifié, propriété de la tentative contrôlée,
   texte plafonné à 8 000 caractères, référence du cas lue côté serveur
   uniquement, texte candidat délimité dans le prompt (anti prompt-injection),
   idempotence par hash (`texte + version moteur`).
2. **Niveau déterministe** : comptages, phrases, diversité lexicale,
   vocabulaire spatial, « il y a », expressions d'incertitude, répétitions.
3. **LanguageTool** (api.languagetool.org, fr) : fautes localisées
   (offsets UTF-16), catégorisées, avec suggestions.
4. **Analyse sémantique IA** (Anthropic) : fidélité factuelle, couverture,
   interprétations non justifiées, organisation, jury simulé, version
   améliorée. **Nécessite le secret `ANTHROPIC_API_KEY`** :

   ```bash
   supabase secrets set ANTHROPIC_API_KEY=sk-ant-...   # ou via le dashboard
   # optionnel : supabase secrets set PHOTOLANGAGE_AI_MODEL=claude-sonnet-4-5
   ```

   Sans clé, la correction est rendue en mode `partial`
   (linguistique + structure), clairement signalé à l'utilisateur.
5. **Agrégation** : score /100 pondéré (langue 35 %, fidélité 20 %,
   structure 15 %, couverture 15 %, vocabulaire 10 %, lisibilité 5 %),
   niveaux « Bases à renforcer » → « Très bonne maîtrise », payload JSON
   versionné (`schemaVersion`, `engineVersion`) enregistré dans la tentative.

Aucun système ne détecte 100 % des fautes : le résultat affiche un niveau de
confiance et le mode de correction utilisé.

## Sécurité des données (RLS)

- `photolangage_cases` : lecture seule (cas publiés) pour les authentifiés.
- `photolangage_attempts` : select/insert limités à `auth.uid()` ;
  la correction est écrite par l'Edge Function (service role).
- `photolangage_drafts` : accès complet limité à `auth.uid()`.
- Index : `(user_id, created_at desc)`, `(user_id, case_id)`, `case_order`.
- Aucune clé secrète dans Flutter ; textes traités comme données
  personnelles (pas de log du texte intégral côté fonction).

## Fichiers globaux modifiés (3)

`lib/main.dart` (5 imports), `lib/routes/app_router.dart` (5 routes),
`lib/features/home/home_page_pa_exam.dart` (ouverture directe du hub).
**Fichiers GPX modifiés : 0.**

## Limites connues / reste à faire

- 11 cas seedés sur les 25 prévus par le cahier des charges : ajouter des
  images + références en base pour les suivants (aucun code à changer).
- `ANTHROPIC_API_KEY` à définir pour activer l'analyse sémantique complète.
- LanguageTool public : limité en débit ; prévoir une instance auto-hébergée
  si le volume augmente (changer l'URL dans l'Edge Function).
- Mode examen strict, bibliothèque personnelle des erreurs et profil lexical
  multi-copies : non inclus dans cette itération, le schéma de données le
  permet (payloads conservés par tentative).
- `flutter analyze` / `flutter test` à exécuter sur le poste de dev.
