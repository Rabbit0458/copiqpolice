# COP'IQ — Matrice éditoriale du catalogue 500 cas pratiques

> Document de pilotage. Toute production de lot s'y réfère et le met à jour.
> Concours cible : **Gardien de la paix** (décision du 26/07/2026 — le volet
> policier adjoint n'est pas traité dans ce catalogue).

## 1. État de départ

| Indicateur | Valeur au 26/07/2026 |
|---|---|
| Cas en base | 22 (tous `published`) |
| Questions | 62 |
| Critères de grille | 405 |
| Mots-clés | 2 283 |
| Thèmes | 20 (9 d'origine + 11 ajoutés) |
| Tentatives utilisateur | 3 — **à préserver impérativement** |

Source unique de vérité : Supabase, table `cas_pratique_cases`.
Les fichiers `lib/content/.../case_N_page.dart` sont du legacy déjà migré :
**ne rien y ajouter**.

## 2. Répartition cible par thème

Total : **500**. La colonne « à produire » est le reste à écrire.

| # | Thème (slug) | Cible | Existants | À produire |
|---|---|---|---|---|
| 1 | `deontologie` | 42 | 5 | 37 |
| 2 | `police-secours` | 40 | 0 | 40 |
| 3 | `violences-conjugales` | 32 | 2 | 30 |
| 4 | `circulation` | 32 | 2 | 30 |
| 5 | `accueil-public` | 32 | 0 | 32 |
| 6 | `atteintes-biens` | 30 | 0 | 30 |
| 7 | `procedure-penale` | 30 | 5 | 25 |
| 8 | `mineurs` | 28 | 1 | 27 |
| 9 | `gestion-conflits` | 26 | 0 | 26 |
| 10 | `stupefiants` | 22 | 0 | 22 |
| 11 | `secours-personnes` | 22 | 2 | 20 |
| 12 | `numerique` | 22 | 0 | 22 |
| 13 | `ordre-public` | 22 | 0 | 22 |
| 14 | `personnes-vulnerables` | 22 | 0 | 22 |
| 15 | `situations-exceptionnelles` | 20 | 0 | 20 |
| 16 | `controle-identite` | 18 | 3 | 15 |
| 17 | `usage-force` | 18 | 2 | 16 |
| 18 | `equipe-hierarchie` | 18 | 0 | 18 |
| 19 | `discriminations` | 12 | 0 | 12 |
| 20 | `situations-sensibles` | 12 | 0 | 12 |
| | **Total** | **500** | **22** | **478** |

## 3. Répartition cible par difficulté

| Niveau | Part | Cible | Existants | À produire |
|---|---|---|---|---|
| `facile` | 25 % | 125 | 3 | 122 |
| `moyen` | 45 % | 225 | 10 | 215 |
| `difficile` | 25 % | 125 | 9 | 116 |
| `expert` | 5 % | 25 | 0 | 25 |

Définitions retenues :

- **facile** — une problématique principale, clairement identifiable.
- **moyen** — plusieurs éléments à hiérarchiser, sans ambiguïté juridique forte.
- **difficile** — risques, victimes ou priorités concurrents simultanés.
- **expert** — situation évolutive, informations contradictoires, arbitrage
  déontologique ou juridique lourd. La complexité vient **de la situation**,
  jamais d'une rédaction confuse.

## 4. Accès gratuit / premium

Le modèle actuel est respecté tel quel : colonne `is_free`, répartition
d'origine ≈ 50/50. Règle appliquée à la production :

- tout `facile` → `is_free = true` (vitrine, permet d'évaluer l'app) ;
- `moyen` → 40 % gratuit ;
- `difficile` et `expert` → `is_free = false`.

Cible ≈ 215 gratuits / 285 premium. **Aucune règle de verrouillage existante
n'est modifiée.**

## 5. Variété obligatoire des contextes

Aucun environnement ne doit dépasser **12 %** du catalogue. À suivre lot par lot :

commissariat · voie publique · domicile · immeuble · commerce · centre
commercial · gare · métro · bus · train · établissement scolaire · université ·
hôpital · EHPAD · stade · festival · discothèque · bar · restaurant · plage ·
port · zone rurale · forêt · parking · aire d'autoroute · mairie · tribunal ·
lieu de culte · espace numérique · manifestation · entreprise · hôtel ·
camping · fête privée · copropriété

Doivent également varier : moment de la journée, météo, nombre de personnes,
degré d'urgence, niveau de danger, profil de la victime, profil des témoins,
profil du mis en cause, informations disponibles **et manquantes**, présence
ou non de collègues et de services partenaires.

## 6. Structure d'un cas

Le schéma existant est conservé sans modification :

```
cas_pratique_cases          slug, title, year, month, theme_id, situation_text,
                            situation_md, difficulty, total_points,
                            estimated_minutes, status, is_free, is_published
  └── questions             position, label, hint, max_points, char_min
        ├── perfect_answers body_md, references_legal
        └── rubric_points   position, label, weight, is_required, kind,
                            explanation_md
              └── keyword_groups  (ENTRE groupes = ET, INTRA groupe = OU)
                    └── keywords  value, is_phrase, is_negation, fuzzy_max_dist
```

Standard de production : **3 questions × 5 points = 15 points**, 5 à 7 critères
de grille par question, 4 à 8 mots-clés par groupe.

La pondération de la grille **doit varier d'un cas à l'autre** : appliquer la
même répartition aux 500 cas est explicitement proscrit.

## 7. Règles rédactionnelles

À respecter sans exception :

- contexte français, Police nationale ; aucune procédure inspirée de fictions
  américaines, aucun « lire ses droits » non adapté au droit français ;
- ne citer un article précis que si sa pertinence est certaine ; sinon,
  formulation professionnelle générale ;
- aucun pouvoir inventé, aucune procédure inventée ;
- aucune technique opérationnelle sensible, aucun détail exploitable pour
  commettre une infraction ou contourner un dispositif ;
- titres évocateurs et situés, jamais « Cas pratique n° 12 » ni
  « Situation complexe » ;
- la situation ne contient jamais la réponse ;
- erreurs fréquentes **spécifiques au cas**, jamais une liste générique
  recopiée d'un cas à l'autre.

## 8. Procédure de production d'un lot

1. Choisir les thèmes et difficultés du lot selon les reliquats du § 2 et § 3.
2. Rédiger les cas au format JSON attendu par `fn_cp_seed_legacy_case`.
3. Contrôler :
   `python scripts/cas_pratique/controle_qualite.py lot_NN.json --contre catalogue_existant.json`
4. Corriger jusqu'à **zéro erreur bloquante**.
5. Importer (idempotent, `ON CONFLICT` sur `slug`).
6. Vérifier le total en base et regénérer `catalogue_existant.json`.
7. Mettre à jour la colonne « Existants » du § 2 et du § 3.

Le script refuse un lot qui introduirait un doublon. Seuils calibrés
empiriquement (cf. en-tête du script) : sur les 22 cas d'origine, le maximum de
similarité entre deux cas légitimes est de 0,05 (enchaînement de mots) et 0,136
(vocabulaire) ; un doublon volontaire atteint 0,36 et 0,73.

## 9. Corrections à apporter au catalogue existant

Relevées à l'analyse, à traiter avec les lots — **sans supprimer aucune donnée**
(3 tentatives utilisateur sont rattachées à ces cas) :

| Cas | Problème | Correction |
|---|---|---|
| `usage-force-proportionnalite` | thème `deontologie` alors que le scénario porte sur l'usage de la force | reclasser en `usage-force` |
| `discrimination-impartialite` | thème `deontologie` alors que le sujet est la discrimination | reclasser en `discriminations` |
| `cas-demo-controle`, `cas-demo-deontologie`, `cas-demo-procedure` | cas de démonstration, situation de 130 à 260 caractères, `total_points` à 10 | enrichir ou passer en `archived` |
| 7 autres cas | situation < 350 caractères (voir sortie du script) | enrichir la mise en situation |

## 10. Outillage en place

| Fichier | Rôle |
|---|---|
| `scripts/cas_pratique/controle_qualite.py` | Contrôle anti-doublon, complétude, cohérence, répartition |
| `scripts/cas_pratique/generer_migration.py` | Convertit les lots JSON en migration SQL idempotente |
| `scripts/cas_pratique/catalogue_existant.json` | Référence anti-doublon (à régénérer après chaque lot) |
| `scripts/cas_pratique/lots/` | Lots JSON source — **source de vérité du contenu** |
| `fn_cp_import_case(slug, jsonb)` | Fonction d'import en base, idempotente, `SECURITY DEFINER` |

Validations effectuées sur la base réelle :

- double import du même cas → 1 cas, 2 questions, 3 mots-clés (aucun doublon) ;
- `difficulty = 'expert'` accepté (aucune contrainte `CHECK` en base) ;
- `is_free` et `is_published` correctement positionnés ;
- détection automatique des locutions (`is_phrase`) sur les mots-clés
  composés de plusieurs mots ;
- fonction non exposée à `anon` / `authenticated` (`REVOKE`).

## 11. Suivi des lots

| Lot | Cas | Thèmes | Statut |
|---|---|---|---|
| Pilote A | 023-024 | `accueil-public`, `police-secours` | **rédigé, contrôlé** |
| Pilote B | 025-026 | `numerique`, `personnes-vulnerables` | **rédigé, contrôlé** |
| Pilote C | 027-028 | `atteintes-biens` (expert), `gestion-conflits` | **rédigé, contrôlé** |
| Pilote D | 029-047 | à répartir selon § 2 | à rédiger |
| 02 → 20 | 048-500 | selon reliquats § 2 et § 3 | à rédiger |

Lot pilote consolidé dans `20260726000003_cas_pratique_lot_pilote.sql`
(6 cas, 18 questions, 94 critères de grille, 629 mots-clés) — **reste à
appliquer** via `supabase db push`.

Densité obtenue, à tenir sur les lots suivants :

| Indicateur | Lot pilote | Catalogue d'origine |
|---|---|---|
| Critères par cas | 15,7 | 18,4 |
| Mots-clés par cas | 105 | 104 |
| Situation (caractères) | 1 076 | 447 |
| Réponse modèle (caractères) | 1 545 | — |

La situation moyenne est 2,4 fois plus longue que celle des cas d'origine :
c'est délibéré. Une mise en situation de 400 caractères ne contient pas assez
d'éléments pour que le candidat ait à hiérarchiser, ce qui est précisément
l'objet de l'épreuve.

### Prochaine action

```bash
supabase db push          # applique thèmes + fn_cp_import_case + lot pilote A
flutter analyze           # vérifie les 4 fichiers Dart modifiés
flutter test
```

Puis régénérer la référence anti-doublon avant le lot suivant :

```sql
SELECT json_agg(x) FROM (
  SELECT c.slug, c.title, c.situation_text, t.slug AS theme_slug,
         c.difficulty, c.is_free
  FROM public.cas_pratique_cases c
  LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
  ORDER BY c.slug
) x;
```
→ écraser `scripts/cas_pratique/catalogue_existant.json` avec le résultat.
