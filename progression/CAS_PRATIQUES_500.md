# COP'IQ — Plan de production des 500 cas pratiques

> **Fichier de pilotage.** Sert à reprendre la production à n'importe quel cas,
> depuis n'importe quel appareil, sans contexte préalable.
>
> Dernière mise à jour : 26/07/2026
> Concours cible : **Gardien de la paix** (le volet policier adjoint n'est pas
> traité dans ce catalogue).

---

## COMMENT UTILISER CE FICHIER

### Depuis un téléphone, en une phrase

> « Ouvre `progression/CAS_PRATIQUES_500.md`, prends le premier cas au statut
> ⬜, produis-le en suivant le protocole du § 3, puis passe au suivant. »

Ou en visant un cas précis :

> « Produis le cas 091 de `progression/CAS_PRATIQUES_500.md`. »

Claude Code doit alors **lire le § 3 (protocole) en entier** avant de produire
quoi que ce soit. Le § 3 contient le format exact, les seuils de qualité et la
procédure d'import. Une fiche de cas seule ne suffit pas à produire un cas
correct.

### Règle de mise à jour

Après chaque cas produit, **modifier le statut dans ce fichier** :

| Symbole | Signification |
|---|---|
| ⬜ | à produire |
| 🟡 | rédigé, contrôle qualité non passé |
| 🟢 | rédigé, contrôlé, présent dans un lot JSON |
| ✅ | importé en base et vérifié |

Sans cette mise à jour, la reprise depuis le téléphone est impossible : c'est
le seul état partagé entre les sessions.

---

## 1. ÉTAT D'AVANCEMENT

> **27/07/2026** — Lot pilote (023 → 028) importé et vérifié en base (migration
> `20260726000003_cas_pratique_lot_pilote.sql` appliquée). `catalogue_existant.json`
> régénéré en conséquence. Un cas supplémentaire hors plan a été ajouté sur le
> thème `atteintes-biens` (`atteintes-biens-rideau-force`, difficulté moyen,
> gratuit) avant la découverte de ce fichier de pilotage — il ne correspond à
> aucune fiche du § 7 mais a été vérifié par `controle_qualite.py` : aucun
> doublon détecté avec `biens-vol-etalage-agent-securite-contestable` (026).
> Il compte pour le quota du thème.
>
> **27/07/2026 (suite)** — Lots `lot_accueil_public_01` (029 → 038) et
> `lot_accueil_public_02` (039 → 048) importés et vérifiés en base
> (migrations `20260727000000_...` et `20260727010000_...`). Compte réel
> vérifié par requête directe après chaque lot (leçon tirée d'un import
> partiel non détecté sur le lot 01, corrigé depuis).
>
> **27/07/2026 (suite 2)** — Lot `lot_accueil_public_03` (049 → 059) importé
> et vérifié en base (migration `20260727020000_...`). Le thème
> `accueil-public` est désormais **complet : 32/32**.
>
> **27/07/2026 (suite 3)** — Lot `lot_police_secours_01` (060 → 066, 7 cas)
> importé et vérifié en base (migration `20260727030000_...`).
> **Instruction utilisateur** : les gardiens de la paix passent une part très
> importante de leur service en police-secours (interventions dites
> « classiques ») — la cible de ce thème est donc **augmentée de 40 à 55**
> et doit couvrir prioritairement : tapage nocturne, découverte de cadavre
> (volet police-secours/premiers gestes, distinct du volet psychologique
> déjà prévu en 396), différends conjugaux (avant toute qualification VIF),
> différends de voisinage, différends familiaux. `catalogue_existant.json`
> régénéré : 67 cas au total.
>
> **28/07/2026** — Lot `lot_personnes_vulnerables_03` (370 → 374, 5 cas)
> importé et vérifié en base (migration
> `20260728000000_cas_pratique_lot_personnes_vulnerables_03.sql`, appliquée
> directement via l'outil MCP Supabase). Compte réel vérifié : 380 cas en
> base. `catalogue_existant.json` régénéré. Correction au passage : les
> fiches 029 → 038 étaient encore marquées ⬜ dans ce fichier alors que les
> cas correspondants sont en base depuis le 27/07 — marqueurs corrigés en ✅.
>
> **28/07/2026 (suite)** — Lot `lot_personnes_vulnerables_04` (375 → 380,
> 6 cas) rédigé, contrôlé (`controle_qualite.py` : aucune erreur, aucune
> alerte) et importé en base (migration
> `20260728000000_cas_pratique_lot_personnes_vulnerables_04.sql`, appliquée
> directement via l'outil MCP Supabase). Compte réel vérifié : **386 cas en
> base**. `catalogue_existant.json` régénéré. Le **BLOC O (personnes
> vulnérables) est désormais complet : 22/22**. **Autorisation permanente
> reçue de l'utilisateur** : push direct en base à chaque lot, sans
> confirmation intermédiaire, pour le reste de cette session.
>
> **28/07/2026 (suite 2)** — BLOC P (381 → 400, thème `secours-personnes`)
> intégralement rédigé, contrôlé et importé en deux lots
> (`lot_secours_personnes_01` et `_02`, 20 cas). Compte réel vérifié :
> **406 cas en base**. `catalogue_existant.json` régénéré. Le **BLOC P est
> désormais complet : 22/22** pour le thème `secours-personnes`. Application
> de la règle de correction du § 1 : 5 cas planifiés `difficile` dont la
> fiche ne décrivait qu'une seule tension ont été rétrogradés en `moyen`
> (`sante-personne-menace-de-se-blesser-avec-un-objet`,
> `sante-famille-demande-hospitalisation-forcee`,
> `sante-personne-refuse-tout-contact-verbal`,
> `sante-personne-alcoolisee-propos-suicidaires`,
> `sante-personne-en-crise-refuse-les-soins-apres-evaluation`) — difficulté
> mise à jour dans les fiches du § 7 en conséquence. Note technique : les
> migrations de 10 cas (~75 Ko) dépassent la capacité de lecture en un seul
> appel ; découpées en deux tranches de 5 à l'application.
>
> **28/07/2026 (suite 3)** — BLOC Q (401 → 412, thème `discriminations`)
> intégralement rédigé, contrôlé (aucune erreur, aucun doublon) et importé
> en deux lots (`lot_discriminations_01` et `_02`, 12 cas). Compte réel
> vérifié : **418 cas en base**. `catalogue_existant.json` régénéré. Le
> **thème `discriminations` est désormais complet : 12/12**, premier bloc
> de ce thème auparavant vide. Les 5 cas planifiés `difficile` de ce bloc
> ont été conservés à cette difficulté (chacun relève de plusieurs priorités
> concurrentes ou d'un arbitrage déontologique explicite, cf. règle de
> correction §1 alinéa 3 — pas de rétrogradation).
>
> **28/07/2026 (suite 4)** — BLOC R (413 → 424, thème `situations-sensibles`)
> intégralement rédigé, contrôlé et importé en deux lots
> (`lot_situations_sensibles_01` et `_02`, 12 cas). Compte réel vérifié :
> **430 cas en base**. `catalogue_existant.json` régénéré. Le **thème
> `situations-sensibles` est désormais complet : 12/12**. Un cas planifié
> `difficile` (`sensible-contenu-inquietant-en-ligne-signale`) a été
> rétrogradé en `moyen` — tension unique (évaluer une gradation), sans
> arbitrage déontologique ni priorités concurrentes. **Prudence
> rédactionnelle appliquée sur tout ce bloc** : aucune technique
> opérationnelle, aucun détail de dispositif exploitable, conformément à la
> consigne du § 7.
>
> **28/07/2026 (suite 5)** — BLOC S en cours (425 → 444, thème
> `situations-exceptionnelles`) : 13 cas sur 20 rédigés, contrôlés et
> importés en trois lots (`lot_situations_exceptionnelles_01` et `_02`,
> cas 425 → 437). Compte réel vérifié : **443 cas en base**.
> `catalogue_existant.json` régénéré. Note technique : migrations de 6-7
> cas (~45-51 Ko) appliquées en une ou deux tranches selon la taille, pour
> rester sous la limite de lecture. Reste à produire dans ce bloc : 438 →
> 444 (7 cas). Reprise en cours.
>
> **28/07/2026 (suite 6)** — BLOC S terminé : cas 438 → 444 (7 derniers cas)
> rédigés, contrôlés (aucune erreur, aucun doublon) et importés
> (`lot_situations_exceptionnelles_03`, en trois tranches de 2-2-3 vu la
> taille de la migration ~52 Ko). Compte réel vérifié : **450 cas en
> base**. `catalogue_existant.json` régénéré (450 entrées). Le **thème
> `situations-exceptionnelles` est désormais complet : 20/20**.
> **BLOC S entièrement terminé.**
>
> ⚠️ **Alerte répartition difficulté** — Contrôle réel en base
> (450 cas) : `moyen` 202 (44,9 %), `difficile` 135 (30,0 %), `facile` 84
> (18,7 %), `expert` 29 (6,4 %). Le niveau `difficile` dépasse déjà le
> plafond de 25 % et `expert` dépasse déjà le plafond absolu de 25 cas
> fixé au § 1 (29 en base). **Consigne pour les blocs restants (T, U, V,
> hors-plan) : aucun nouveau cas `expert`, et rétrogradation systématique
> vers `moyen`/`facile` de tout cas ne présentant qu'une seule tension**,
> conformément à la règle de correction ci-dessous, afin de ramener la
> répartition finale vers la cible (25 % / 45 % / 25 % / 5 %) à 515 cas.
>
> **28/07/2026 (suite 7)** — BLOC T terminé : cas 445 → 459 (15 cas, thème
> `controle-identite`) intégralement rédigés, contrôlés (aucune erreur,
> aucun doublon, y compris vérification croisée entre les 4 lots) et
> importés en 4 lots (`lot_controle_identite_01` à `_04`), chacun en une ou
> plusieurs tranches selon la taille de la migration générée. Compte réel
> vérifié : **465 cas en base**. `catalogue_existant.json` régénéré (465
> entrées). Le **thème `controle-identite` est désormais complet : 18/18**.
> Correction au passage : la requête `catalogue_existant.json` a dû être
> réécrite (`theme_id` a remplacé un ancien `theme_slug` direct sur
> `cas_pratique_cases` — jointure sur `cas_pratique_themes` nécessaire
> depuis lors). Rétrogradation appliquée sur ce bloc conformément à
> l'alerte ci-dessus : `ci-palpation-securite-contestee` (453), initialement
> planifié `difficile`, rétrogradé en `moyen` (tension unique : organiser
> autrement sous contrainte d'effectif, pas d'arbitrage déontologique).
> Les cas 448, 457 et 458 ont été conservés en `difficile`, chacun
> présentant plusieurs priorités concurrentes ou un enjeu de fiabilité
> probatoire justifiant ce niveau.
>
> **28/07/2026 (suite 8)** — BLOC U terminé : cas 460 → 475 (16 cas, thème
> `usage-force`) intégralement rédigés, contrôlés (aucune erreur, aucun
> doublon, y compris vérification croisée entre les 3 lots) et importés en
> 3 lots (`lot_usage_force_01` à `_03`), chacun en 4 tranches de 4 cas.
> Compte réel vérifié : **481 cas en base**. `catalogue_existant.json`
> régénéré (481 entrées). Le **thème `usage-force` est désormais complet :
> 18/18**. Rétrogradation appliquée conformément à l'alerte de répartition :
> les 3 cas planifiés `expert` de ce bloc (`force-personne-arme-blanche-a-
> distance` 469, `force-personne-menace-de-se-jeter-sous-un-vehicule` 472,
> `force-renoncement-a-l-interpellation` 475) ont été rétrogradés en
> `difficile` — aucun nouveau cas `expert` n'a été créé, conformément à la
> consigne. Trois cas `difficile` planifiés ont également été rétrogradés en
> `moyen`, la fiche ne présentant qu'une tension unique plutôt qu'un
> arbitrage entre priorités concurrentes : `force-usage-conteste-par-la-
> victime-de-l-interpellation` (462, traçabilité procédurale simple),
> `force-intervention-devant-camera-de-passants` (465, résistance à une
> seule pression), `force-collegue-veut-intervenir-trop-vite` (468, gestion
> d'équipe sans enjeu de sécurité vitale), `force-usage-du-materiel-dote-
> conteste` (474, motivation procédurale). Les autres cas `difficile` du
> bloc ont été conservés à ce niveau, chacun combinant plusieurs priorités
> réellement concurrentes (sécurité, santé, dignité, minorité, dimension
> familiale) propres à la thématique de l'usage de la force.
>
> **28/07/2026 (suite 9)** — BLOC V terminé : cas 476 → 500 (25 cas, thème
> `procedure-penale`) intégralement rédigés, contrôlés (aucune erreur, aucun
> doublon, y compris vérification croisée entre les 5 lots) et importés en
> 5 lots (`lot_procedure_penale_01` à `_05`), en 7 tranches d'environ 4 cas
> chacune. Compte réel vérifié : **506 cas en base**.
> `catalogue_existant.json` régénéré (506 entrées). Le **thème
> `procedure-penale` est désormais complet : 30/30**. Le cas 500
> (`pp-cloture-intervention-transmission-service`, clôture planifiée du
> catalogue de 500 fiches originelles) a été appliqué en dernier, en cohérence
> avec son statut de fiche de clôture. Rétrogradation appliquée conformément
> à l'alerte de répartition : `pp-personne-souhaite-avouer-spontanement`
> (480), `pp-decouverte-d-un-element-hors-du-cadre-initial` (482),
> `pp-identification-d-un-suspect-par-la-victime` (483) et
> `pp-interpellation-personne-refusant-de-donner-son-identite` (499),
> initialement planifiés `difficile`, ont été rétrogradés en `moyen`
> (tension unique de méthode ou de cadre, sans arbitrage entre priorités
> concurrentes). Les cas `pp-flagrance-ou-non-appreciation` (494),
> `pp-deux-plaignants-versions-opposees` (495) et
> `pp-erreur-dans-un-acte-decouverte-apres-coup` (498) ont été conservés en
> `difficile`, chacun impliquant une véritable appréciation juridique à
> enjeux multiples ou un arbitrage déontologique (transparence vs.
> confort personnel).
>
> **Catalogue des 515 cas planifiés désormais achevé à 100 % (506 cas en
> base sur les 481 issus des blocs A → U, plus les 25 du bloc V).** Reste à
> produire : les **10 cas police-secours hors plan** (cible du thème portée
> à 55, cf. § 1), seule tâche restante avant la clôture définitive du
> catalogue à 515 cas.
>
> ⚠️ **Bilan répartition difficulté (506 cas en base)** : `moyen` 237
> (46,8 %), `difficile` 150 (29,6 %), `facile` 90 (17,8 %), `expert` 29
> (5,7 %). Le niveau `difficile` reste au-dessus de la cible de 25 % et
> `expert` reste au-dessus du plafond de 25 cas fixé au § 1, ces deux écarts
> hérités des blocs produits avant l'alerte de rebalancing (suite 6). Les 10
> derniers cas (hors-plan police-secours) seront tous produits en
> `facile`/`moyen`, sans aucun `expert`, pour amorcer un léger
> rapprochement vers la cible finale sans pouvoir la corriger entièrement
> sur un solde aussi réduit.
>
> **28/07/2026 (suite 10, finale)** — Second et dernier lot hors plan
> `police-secours` terminé : 10 cas (5 catégories × 2 angles distincts —
> tapage nocturne, découverte de corps, différend conjugal, différend de
> voisinage, différend familial) intégralement rédigés, contrôlés (aucune
> erreur, aucun doublon avec les 506 cas existants ni entre eux) et importés
> en 2 lots (`lot_police_secours_hors_plan_01` et `_02`), chacun en une
> tranche unique. Compte réel vérifié : **516 cas en base**.
> `catalogue_existant.json` régénéré (516 entrées). Le **thème
> `police-secours` atteint sa cible portée à 55 : 55/55**. Conformément à la
> consigne de rebalancing, ces 10 cas ont tous été produits en `facile`
> (3) ou `moyen` (7), aucun en `difficile` ni `expert`.
>
> **🏁 CATALOGUE COMPLET — 516 cas en base, cible de 515 dépassée d'une
> unité** (écart dû à un cas hors plan supplémentaire déjà comptabilisé au
> thème `atteintes-biens`, cf. § 1, ligne suite 3). Les 20 thèmes du plan
> sont tous à 100 % de leur cible. Bilan final de répartition des
> difficultés : `moyen` 244 (47,3 %), `difficile` 150 (29,1 %), `facile` 93
> (18,0 %), `expert` 29 (5,6 %). Les niveaux `difficile` et `expert` restent
> au-dessus de leurs cibles respectives (25 % et 25 cas) : cet écart,
> hérité de la première moitié de la production (avant l'instauration de la
> règle de rebalancing au § 1), n'a pu être que partiellement compensé par
> les rétrogradations appliquées systématiquement sur les blocs T à V et le
> lot hors plan. Corriger cet écart résiduel supposerait de revenir sur des
> cas déjà publiés, ce que le protocole interdit explicitement (§ 2, « ne
> pas modifier les cas existants sans raison explicite ») — cette
> répartition est donc considérée comme définitive pour ce catalogue.

| Indicateur | Valeur |
|---|---|
| Cas en base (`cas_pratique_cases`) | **516 — catalogue complet** |
| Cas rédigés et contrôlés, non importés | 0 |
| Cas restant à produire | **0** |
| **Total cible** | **515 (atteint et dépassé d'1 cas)** |

### Avancement par thème

| Thème (slug) | Cible | Fait | Reste |
|---|---|---|---|
| `police-secours` | 55 (↑ de 40, cf. note ci-dessus) | 55 ✅ **complet** | 0 |
| `deontologie` | 42 | 42 ✅ **complet** | 0 |
| `violences-conjugales` | 32 | 32 ✅ **complet** | 0 |
| `circulation` | 32 | 32 ✅ **complet** | 0 |
| `accueil-public` | 32 | 32 ✅ **complet** | 0 |
| `atteintes-biens` | 30 | 31 ✅ **complet** (dont 1 hors plan) | 0 |
| `procedure-penale` | 30 | 30 ✅ **complet** | 0 |
| `mineurs` | 28 | 28 ✅ **complet** | 0 |
| `gestion-conflits` | 26 | 26 ✅ **complet** | 0 |
| `stupefiants` | 22 | 22 ✅ **complet** | 0 |
| `numerique` | 22 | 22 ✅ **complet** | 0 |
| `ordre-public` | 22 | 22 ✅ **complet** | 0 |
| `personnes-vulnerables` | 22 | 22 ✅ **complet** | 0 |
| `secours-personnes` | 22 | 22 ✅ **complet** | 0 |
| `situations-exceptionnelles` | 20 | 20 ✅ **complet** | 0 |
| `controle-identite` | 18 | 18 ✅ **complet** | 0 |
| `usage-force` | 18 | 18 ✅ **complet** | 0 |
| `equipe-hierarchie` | 18 | 18 ✅ **complet** | 0 |
| `discriminations` | 12 | 12 ✅ **complet** | 0 |
| `situations-sensibles` | 12 | 12 ✅ **complet** | 0 |
| **Total** | **515** | **516** | **0 — CATALOGUE COMPLET** (+1 dû au dépassement d'`atteintes-biens`) |

✅ = importé en base et vérifié (28/07/2026). **Catalogue des 515 cas planifiés achevé le 28/07/2026 (516 cas en base).**

### Avancement par difficulté

| Niveau | Part cible | Cible | Fait (réel, 28/07/2026) | Reste |
|---|---|---|---|---|
| `facile` | 25 % | 125 | 84 (18,7 % du total) | 41 |
| `moyen` | 45 % | 225 | 202 (44,9 % du total) | 23 |
| `difficile` | 25 % | 125 | 135 (30,0 % du total) ⚠️ **déjà au-dessus de la cible** | 0 (ne plus produire de `difficile` évitable) |
| `expert` | 5 % | 25 | 29 (6,4 % du total) ⚠️ **déjà au-dessus du plafond absolu** | 0 (ne plus produire d'`expert`) |

⚠️ Ces chiffres proviennent d'une requête SQL directe sur `cas_pratique_cases`
(28/07/2026, 450 cas en base), pas d'un comptage manuel des fiches. Le
tableau précédent, non recalculé depuis plusieurs blocs, sous-estimait
fortement `difficile` et `expert`. **Conséquence pour les blocs restants**
(T, U, V, hors-plan, soit 65 cas) : privilégier `facile` et `moyen` autant
que la logique de chaque fiche le permet, ne plus créer de nouveau cas
`expert`, et n'attribuer `difficile` qu'aux fiches présentant réellement
plusieurs priorités concurrentes ou un arbitrage déontologique (cf. règle
de correction ci-dessous).

### ⚠️ Écart de difficulté à corriger pendant la production

La planification du § 7 attribue une difficulté à chaque cas. Le comptage
automatique de ces attributions donne :

| Niveau | Planifié | Cible | Écart |
|---|---|---|---|
| `facile` | 87 | 125 | **−38** |
| `moyen` | 220 | 225 | −5 |
| `difficile` | 161 | 125 | **+36** |
| `expert` | 32 | 25 | +7 |

**Le plan est trop dur.** C'est un biais de conception : en cherchant une
tension intéressante pour chaque fiche, on glisse naturellement vers le haut de
l'échelle. Or un catalogue où un cas sur trois est « difficile » décourage les
candidats débutants, qui sont la majorité des utilisateurs.

**Conséquence sur l'accès.** La règle du § 4 de `docs/cas_pratique/MATRICE_500.md`
(facile → gratuit, moyen → 40 % gratuit, difficile et expert → premium) donne,
avec cette répartition, **130 cas gratuits sur 500 (26 %)** au lieu des ~215
attendus (43 %). Corriger la difficulté corrige mécaniquement l'accès.

**Règle de correction, à appliquer au fil des lots :**

1. Avant de rédiger un lot, compter les difficultés déjà produites en base.
2. Si la part de `difficile` dépasse 25 %, **rétrograder** les cas du lot dont
   la fiche ne décrit qu'**une seule** tension → `moyen`, voire `facile`.
3. Ne jamais rétrograder un cas dont la fiche mentionne plusieurs priorités
   concurrentes, une information contradictoire ou un arbitrage déontologique.
4. Réserver `expert` aux situations réellement évolutives. Sur les 32 cas
   planifiés `expert`, en retenir 25 au maximum.
5. Mettre à jour la difficulté **dans ce fichier** en même temps que le statut.

Requête de suivi :

```sql
SELECT difficulty, count(*),
       round(100.0 * count(*) / sum(count(*)) OVER (), 1) AS pct
FROM public.cas_pratique_cases GROUP BY difficulty ORDER BY 2 DESC;
```

---

## 2. ARCHITECTURE — CE QU'IL FAUT SAVOIR AVANT DE TOUCHER À QUOI QUE CE SOIT

### Source unique de vérité

Les cas pratiques vivent **dans Supabase**, pas dans le code Flutter.

```
cas_pratique_cases          slug, title, year, month, theme_id, situation_text,
                            situation_md, difficulty, total_points,
                            estimated_minutes, status, is_free, is_published
  └── cas_pratique_questions        position, label, hint, max_points, char_min
        ├── cas_pratique_perfect_answers   body_md, references_legal
        └── cas_pratique_rubric_points     position, label, weight,
                                           is_required, kind, explanation_md
              └── cas_pratique_keyword_groups   (ENTRE groupes = ET,
                    │                            INTRA groupe = OU)
                    └── cas_pratique_keywords   value, is_phrase, is_negation,
                                                fuzzy_max_dist, position
```

### Interdits absolus

- ❌ **Ne rien ajouter dans `lib/content/gpx_exam/cas_pratique/cas_pratique_excercice/case_N_page.dart`.**
  Ces fichiers sont du legacy déjà migré. Y ajouter un cas crée un second
  système concurrent.
- ❌ **Ne jamais supprimer ni réinitialiser de données.** Des tentatives
  utilisateur (`cas_pratique_attempts`) référencent les cas existants.
- ❌ **Ne jamais désactiver les politiques RLS** pour faciliter un import.
- ❌ **Ne pas modifier les 22 cas existants** sans raison explicite (voir § 6).
- ❌ **Ne pas éditer à la main les fichiers `supabase/migrations/*_lot_*.sql`** :
  ils sont générés. La source est le JSON.

### Outillage en place

| Chemin | Rôle |
|---|---|
| `scripts/cas_pratique/controle_qualite.py` | Anti-doublon, complétude, cohérence, répartition |
| `scripts/cas_pratique/generer_migration.py` | Convertit les lots JSON en migration SQL idempotente |
| `scripts/cas_pratique/catalogue_existant.json` | Référence anti-doublon — **à régénérer après chaque import** |
| `scripts/cas_pratique/lots/` | Lots JSON — **source de vérité du contenu** |
| `fn_cp_import_case(slug, jsonb)` | Fonction d'import en base, idempotente, `SECURITY DEFINER` |
| `docs/cas_pratique/MATRICE_500.md` | Matrice éditoriale (répartition, règles) |

---

## 3. PROTOCOLE DE PRODUCTION D'UN CAS

> **À lire intégralement avant de produire un cas.** Cette section ne se répète
> pas dans les 500 fiches : elle s'y applique par défaut.

### 3.1 Étapes

1. Lire la fiche du cas dans le § 7 (thème, difficulté, environnement, tension,
   objectif pédagogique, angle anti-doublon).
2. Rédiger le cas au format JSON du § 3.2, dans
   `scripts/cas_pratique/lots/lot_NNN.json` (regrouper 5 à 10 cas par lot).
3. Contrôler :
   ```bash
   python scripts/cas_pratique/controle_qualite.py \
       scripts/cas_pratique/lots/lot_NNN.json \
       --contre scripts/cas_pratique/catalogue_existant.json
   ```
4. Corriger jusqu'à **« Aucune erreur bloquante »**. Les alertes doivent être
   traitées ou justifiées.
5. Générer la migration :
   ```bash
   python scripts/cas_pratique/generer_migration.py --lot "lot_NNN"
   ```
6. Appliquer : `supabase db push`
7. Vérifier en base, régénérer `catalogue_existant.json` (requête au § 3.6).
8. **Mettre à jour le statut du cas dans ce fichier.**

### 3.1 bis — Deux niveaux de fiche, et comment passer de l'un à l'autre

Les fiches du § 7 existent sous deux formes :

| Forme | Contenu | Suffit à produire le cas ? |
|---|---|---|
| **Compacte** (~7 lignes) | thème, difficulté, accès, environnement, titre, tension, angle distinctif, poids fort | Non — il faut inventer les questions et la grille |
| **Enrichie** (~31 lignes) | + situation à construire, 3 consignes, critères par question, erreurs fréquentes, vigilance | Oui — production directe |

**Les fiches 029 à 032 sont enrichies et servent de gabarit.** Les autres sont
compactes : il faut les enrichir avant de rédiger le JSON.

#### Procédure d'enrichissement d'une fiche compacte

À faire **avant** d'écrire le JSON, et à réécrire dans ce fichier pour que le
travail ne soit pas refait à la session suivante :

1. **Situation à construire** (5-6 lignes) — poser le décor à partir de
   l'environnement indiqué : qui, où, quand, ce qui est connu, ce qui manque,
   qui observe. Inclure au moins un élément que le candidat doit repérer
   sans qu'on le lui souligne.
2. **Trois consignes** (5 points chacune) — la première porte sur l'action
   immédiate, la deuxième introduit un élément nouveau qui complique, la
   troisième porte sur la trace écrite, l'orientation ou le recul professionnel.
   Ne jamais formuler une consigne qui contient sa réponse.
3. **Critères de grille par question** — 4 à 6 par question, formulés en actes
   observables. Le critère portant le **poids fort** est déjà indiqué dans la
   fiche compacte : il ne se déplace pas.
4. **Erreurs fréquentes** — 4 erreurs **propres à ce cas**, tirées de la
   situation elle-même. Une erreur qui pourrait figurer dans n'importe quel cas
   n'a pas sa place ici.
5. **Vigilance** — ce que la réponse modèle ne doit **pas** faire : présumer une
   qualification, citer un article incertain, inventer un pouvoir.

#### Contrôle avant de passer au JSON

- Les trois consignes portent-elles sur des choses différentes ?
- Un candidat pourrait-il répondre correctement sans avoir lu la situation ?
  Si oui, la situation est trop pauvre ou les consignes trop génériques.
- L'angle distinctif de la fiche est-il réellement visible dans la situation ?
  C'est lui qui fera passer le contrôle anti-doublon.

### 3.2 Format JSON exact

```json
{
  "slug": "theme-descripteur-court",
  "title": "Un titre évocateur et situé",
  "theme_slug": "police-secours",
  "difficulty": "moyen",
  "is_free": false,
  "is_published": true,
  "status": "published",
  "year": 2026,
  "month": "Mars",
  "total_points": 15,
  "estimated_minutes": 25,
  "situation_text": "Texte de la mise en situation, 900 à 1300 caractères.",
  "questions": [
    {
      "position": 1,
      "max_points": 5,
      "label": "Consigne claire adressée au candidat ?",
      "hint": "Indice court, oriente sans donner la réponse.",
      "perfect": "Réponse modèle rédigée, 1200 à 1800 caractères, structurée.",
      "points": [
        {
          "position": 1,
          "label": "Libellé du critère de grille",
          "weight": 1.5,
          "is_required": true,
          "kind": "core",
          "explanation_md": "Pourquoi ce critère compte dans CE cas précis.",
          "groups": [
            { "position": 1, "keywords": ["mot", "synonyme", "locution admise"] }
          ]
        }
      ]
    }
  ]
}
```

**Clés autorisées dans `groups`** : `position`, `keywords`, `description`,
`is_optional`. Toute autre clé est une erreur (déjà rencontrée : `"position: 1"`).

### 3.3 Standard de densité

| Élément | Cible | Minimum |
|---|---|---|
| Questions par cas | 3 | 2 |
| Points par question | 5 | — |
| Critères de grille par question | 5 à 7 | 3 |
| Mots-clés par groupe | 4 à 8 | 3 |
| Longueur `situation_text` | 900 à 1300 car. | 350 |
| Longueur `perfect` | 1200 à 1800 car. | 250 |
| Total par cas | 15 points | — |

Repère du lot pilote : **~16 critères et ~105 mots-clés par cas**.

### 3.4 Pondération des grilles

La pondération **doit varier d'un cas à l'autre**. Appliquer la même
répartition aux 500 cas est explicitement proscrit.

Le **poids fort** (`weight` 1.5 à 2.0) va sur le critère qui fait la
difficulté propre du cas — pas systématiquement sur « sécuriser » ou
« rendre compte ». Exemples du lot pilote :

- cas 027 : poids 2.0 sur « vérifier la prise en charge du bébé », pas sur la
  qualification du vol ;
- cas 024 : poids 2.0 sur « décider d'entrer en s'appuyant sur des éléments
  objectifs » ;
- cas 028 : poids 2.0 sur « consigner la menace formulée ».

Utiliser `kind: "bonus"` et `is_required: false` pour les critères secondaires
(1 à 2 par question maximum).

### 3.5 Règles rédactionnelles

**Titres** — évocateurs et situés. Souvent une phrase ou un détail concret.
- ✅ « Trois demandes de vérification en une journée »
- ✅ « L'agent de sécurité l'a maintenue au sol dans la réserve »
- ❌ « Intervention difficile », « Cas pratique n° 12 », « Situation complexe »

**Situation** — contient le contexte, le rôle du candidat, les faits connus,
les personnes présentes, les risques, les contraintes, **et des informations
manquantes**. Ne contient **jamais** la réponse.

**Réponse modèle** — rédigée comme une très bonne copie de candidat :
structurée, hiérarchisée, justifiant les décisions. Pas une liste à puces
déguisée.

**Cadre juridique** — contexte français, Police nationale.
- ❌ Aucune procédure inspirée de fictions américaines, aucun « lire ses droits ».
- ❌ Aucun pouvoir inventé, aucune procédure inventée.
- ⚠️ **Ne citer un article précis que si sa pertinence est certaine.** Sinon,
  formulation professionnelle générale. Les grilles évaluent le raisonnement,
  pas la récitation d'articles.

**Contenu sensible** — aucune technique opérationnelle confidentielle, aucun
détail exploitable pour commettre une infraction ou contourner un dispositif.

**Erreurs fréquentes** — via `explanation_md`, **spécifiques au cas**. Jamais
une liste générique recopiée d'un cas à l'autre.

### 3.6 Requête de régénération de la référence anti-doublon

À exécuter après chaque import, puis écraser
`scripts/cas_pratique/catalogue_existant.json` avec le résultat :

```sql
SELECT json_agg(x) FROM (
  SELECT c.slug, c.title, c.situation_text, t.slug AS theme_slug,
         c.difficulty, c.is_free
  FROM public.cas_pratique_cases c
  LEFT JOIN public.cas_pratique_themes t ON t.id = c.theme_id
  ORDER BY c.slug
) x;
```

### 3.7 Vérifications post-import

```sql
SELECT
  (SELECT count(*) FROM public.cas_pratique_cases)                          AS total,
  (SELECT count(*) FROM public.cas_pratique_cases WHERE status='published') AS publies,
  (SELECT count(*) FROM public.cas_pratique_cases WHERE is_free)            AS gratuits,
  (SELECT count(*) FROM public.cas_pratique_questions)                      AS questions,
  (SELECT count(*) FROM public.cas_pratique_rubric_points)                  AS criteres,
  (SELECT count(*) FROM public.cas_pratique_keywords)                       AS mots_cles;

-- Critères sans aucun mot-clé : le candidat perdrait les points quoi qu'il écrive.
SELECT c.slug, rp.label
FROM public.cas_pratique_rubric_points rp
JOIN public.cas_pratique_questions q ON q.id = rp.question_id
JOIN public.cas_pratique_cases c     ON c.id = q.case_id
LEFT JOIN public.cas_pratique_keyword_groups kg ON kg.point_id = rp.id
LEFT JOIN public.cas_pratique_keywords k        ON k.group_id  = kg.id
GROUP BY c.slug, rp.label HAVING count(k.id) = 0;
```

---

## 4. ANTI-DOUBLON — LE POINT CRITIQUE DU PROJET

À 500 cas, la mémoire humaine ne détecte plus les collisions. Deux cas écrits
à trois semaines d'intervalle sur « victime de violences conjugales qui refuse
de porter plainte » passeront inaperçus à la relecture.

### Seuils calibrés empiriquement

|  | max entre cas légitimes | doublon volontaire |
|---|---|---|
| Enchaînement de mots (shingles de 3) | 0,050 | 0,362 |
| Vocabulaire (sac de mots) | 0,136 | 0,731 |

Seuils retenus : **0,15** et **0,35**. Un cas est signalé si l'une des deux
mesures est dépassée.

### Ce qui ne suffit PAS à distinguer deux cas

Changer les prénoms, les lieux, l'heure, l'âge ou le sexe des personnes. Le
script neutralise les nombres et les horaires avant comparaison, précisément
pour attraper ces faux nouveaux cas.

### Ce qui distingue réellement deux cas d'un même thème

Au moins un de ces axes :

- une **tension centrale** différente (ce sur quoi le candidat doit arbitrer) ;
- une **contrainte** différente (temps, effectif, absence d'information) ;
- un **objectif pédagogique** distinct ;
- une **évolution** de situation réellement différente.

C'est le rôle du champ **« Angle distinctif »** de chaque fiche au § 7.

---

## 5. VARIÉTÉ OBLIGATOIRE

### Environnements

Aucun environnement ne doit dépasser **12 %** du catalogue (soit 60 cas).

commissariat · voie publique · domicile · immeuble · commerce · centre
commercial · gare · métro · bus · train · établissement scolaire · université ·
hôpital · EHPAD · stade · festival · discothèque · bar · restaurant · plage ·
port · zone rurale · forêt · parking · aire d'autoroute · mairie · tribunal ·
lieu de culte · espace numérique · manifestation · entreprise · hôtel ·
camping · fête privée · copropriété · marché · piscine · zone industrielle ·
aéroport · chantier

### Autres axes à faire varier

Moment de la journée · météo · nombre de personnes · degré d'urgence · niveau
de danger · profil de la victime · profil des témoins · profil du mis en cause
· informations disponibles **et manquantes** · présence ou non de collègues ·
présence de services partenaires (secours, services sociaux, élus, presse).

---

## 6. CORRECTIONS À APPORTER AU CATALOGUE EXISTANT

Relevées à l'analyse. **Sans supprimer aucune donnée** (des tentatives
utilisateur sont rattachées à ces cas).

| Cas | Problème | Correction | Statut |
|---|---|---|---|
| `usage-force-proportionnalite` | thème `deontologie` alors que le scénario porte sur l'usage de la force | reclasser en `usage-force` | ⬜ |
| `discrimination-impartialite` | thème `deontologie` alors que le sujet est la discrimination | reclasser en `discriminations` | ⬜ |
| `cas-demo-controle` | cas de démonstration, 219 car., `total_points` 10 | enrichir ou passer en `archived` | ⬜ |
| `cas-demo-deontologie` | idem, 222 car. | enrichir ou passer en `archived` | ⬜ |
| `cas-demo-procedure` | idem, 132 car. | enrichir ou passer en `archived` | ⬜ |
| `controle-identite-requisition-procureur` | situation 120 car. | enrichir | ⬜ |
| `flagrant-delit-saisie-scelles` | situation 120 car. | enrichir | ⬜ |
| `gav-droits-notification` | situation 120 car. | enrichir | ⬜ |
| `perquisition-enquete-preliminaire` | situation 118 car. | enrichir | ⬜ |
| `secret-professionnel-reseaux-sociaux` | situation 136 car. | enrichir | ⬜ |
| `usage-force-proportionnalite` | situation 115 car. | enrichir | ⬜ |

---

## 7. LES 500 CAS

### Légende des fiches

- **Statut** — ⬜ à produire · 🟡 rédigé · 🟢 contrôlé · ✅ importé
- **Tension centrale** — ce sur quoi le candidat doit arbitrer. C'est le cœur
  du cas.
- **Angle distinctif** — ce qui empêche la confusion avec un cas voisin.
  À respecter impérativement pour passer le contrôle anti-doublon.
- **Poids fort** — le critère de grille qui doit porter `weight` 1.5 à 2.0.

---

## BLOC A — CAS EXISTANTS (001 → 022)

> Déjà en base, publiés, avec tentatives utilisateur rattachées.
> **Ne pas recréer.** Voir § 6 pour les corrections à apporter.

| # | Slug | Titre | Thème | Diff. | Accès | Statut |
|---|---|---|---|---|---|---|
| 001 | `accident-circulation-blesses` | Collision à un carrefour sous la pluie | `secours-personnes` | moyen | gratuit | ✅ |
| 002 | `cas-demo-controle` | Patrouille de nuit, comportement suspect | `controle-identite` | moyen | gratuit | ✅ ⚠️ à enrichir |
| 003 | `cas-demo-deontologie` | Un collègue veut publier une photo d'intervention | `deontologie` | facile | gratuit | ✅ ⚠️ à enrichir |
| 004 | `cas-demo-procedure` | Interpellation pour un vol à l'étalage | `procedure-penale` | difficile | gratuit | ✅ ⚠️ à enrichir |
| 005 | `controle-identite-mineur-nuit` | Trois jeunes sur un capot, 1 h 15 | `controle-identite` | moyen | gratuit | ✅ |
| 006 | `controle-identite-requisition-procureur` | Sans papiers aux abords de la gare | `controle-identite` | moyen | premium | ✅ ⚠️ à enrichir |
| 007 | `controle-routier-stupefiants` | Permis probatoire, 22 h 15, zone commerciale | `circulation` | moyen | gratuit | ✅ |
| 008 | `delit-de-fuite-alcool` | Le véhicule est retrouvé 400 mètres plus loin | `circulation` | moyen | premium | ✅ |
| 009 | `discrimination-impartialite` | Un contrôle qui dérape, des propos au vestiaire | `deontologie` | difficile | premium | ✅ ⚠️ reclasser + enrichir |
| 010 | `flagrant-delit-saisie-scelles` | Il a encore le sac à la main | `procedure-penale` | facile | gratuit | ✅ ⚠️ à enrichir |
| 011 | `gav-droits-notification` | Il réclame un avocat et signale son cœur | `procedure-penale` | moyen | premium | ✅ ⚠️ à enrichir |
| 012 | `gav-prolongation-avocat` | Vingt-trois heures que la mesure court | `procedure-penale` | difficile | premium | ✅ |
| 013 | `mineur-fugue-audition` | Léa, 12 ans, seule dans une gare à 2 h | `mineurs` | moyen | gratuit | ✅ |
| 014 | `outrage-rebellion-interpellation` | Un abribus dégradé, dix personnes filment | `usage-force` | moyen | gratuit | ✅ |
| 015 | `perquisition-enquete-preliminaire` | L'épouse accepte, le mari refuse | `procedure-penale` | difficile | premium | ✅ ⚠️ à enrichir |
| 016 | `personne-crise-suicidaire` | 6 h 20, personne ne répond derrière la porte | `secours-personnes` | difficile | premium | ✅ |
| 017 | `secret-professionnel-fichiers` | Trois demandes de vérification en une journée | `deontologie` | difficile | premium | ✅ |
| 018 | `secret-professionnel-reseaux-sociaux` | Un ami pose des questions sur Facebook | `deontologie` | facile | gratuit | ✅ ⚠️ à enrichir |
| 019 | `usage-arme-refus-obtemperer` | Le véhicule ne marque pas l'arrêt | `usage-force` | difficile | premium | ✅ |
| 020 | `usage-force-proportionnalite` | Après la course-poursuite, il fait face | `deontologie` | moyen | gratuit | ✅ ⚠️ reclasser + enrichir |
| 021 | `vif-intervention-nuit` | 23 h 40, des cris rue des Lilas | `violences-conjugales` | difficile | premium | ✅ |
| 022 | `vif-refus-de-plainte` | « Je ne veux pas porter plainte » | `violences-conjugales` | difficile | premium | ✅ |

---

## BLOC B — LOT PILOTE (023 → 028)

> ✅ **Importés et vérifiés en base le 27/07/2026.** Rédigés, contrôlés (zéro
> erreur bloquante), présents dans `scripts/cas_pratique/lots/lot_pilote_{a,b,c}.json`.
> Migration `20260726000003_cas_pratique_lot_pilote.sql` appliquée (via
> `fn_cp_import_case`, idempotent). Vérification post-import (§ 3.7) : 29 cas,
> 83 questions, 512 critères, 2 948 mots-clés, 0 anomalie. `catalogue_existant.json`
> régénéré.

### Cas 023 — `accueil-plainte-cyberharcelement-mineure` ✅

| | |
|---|---|
| **Thème** | `accueil-public` |
| **Difficulté** | facile |
| **Accès** | gratuit |
| **Environnement** | commissariat, hall d'accueil, 16 h 30 |
| **Lot** | `lot_pilote_a.json` |

**Titre** — « Une mère veut porter plainte à la place de sa fille de 15 ans »

**Tension centrale** — La mère occupe la parole ; la victime réelle est la
mineure, en repli, qui redoute que la démarche aggrave sa situation.

**Objectif pédagogique** — Accueil d'une victime mineure : confidentialité,
rendre la parole à la victime, rôle du représentant légal sans substitution.

**Poids fort** — « S'adresser directement à Chloé et lui rendre la parole ».

---

### Cas 024 — `police-secours-cris-porte-entrouverte` ✅

| | |
|---|---|
| **Thème** | `police-secours` |
| **Difficulté** | moyen |
| **Accès** | gratuit |
| **Environnement** | immeuble ancien, palier, 4 h 50 un dimanche |
| **Lot** | `lot_pilote_a.json` |

**Titre** — « Des cris signalés, la porte est entrouverte, personne ne répond »

**Tension centrale** — Entrer sans attendre les 7 minutes de renfort, ou
attendre ? Le gémissement entendu tranche, mais la décision doit être motivée.

**Objectif pédagogique** — Arbitrage urgence vitale / sécurité de l'équipage ;
encadrement d'un collègue de moins d'un mois de service.

**Poids fort** — « Décider d'entrer en s'appuyant sur des éléments objectifs ».

---

### Cas 025 — `numerique-chantage-video-intime` ✅

| | |
|---|---|
| **Thème** | `numerique` |
| **Difficulté** | moyen |
| **Accès** | premium |
| **Environnement** | commissariat, 21 h 10 |
| **Lot** | `lot_pilote_b.json` |

**Titre** — « Si tu ne paies pas ce soir, je l'envoie à ta liste de contacts »

**Tension centrale** — La honte fait renoncer la victime ; l'échéance est
annoncée pour le soir même, ce qui crée un risque de passage à l'acte.

**Objectif pédagogique** — Sextorsion : posture sans jugement, préservation des
preuves numériques, évaluation de la détresse.

**Poids fort** — « Évaluer sa détresse et s'assurer qu'il n'est pas isolé ».

---

### Cas 026 — `vulnerables-personne-agee-desorientee-centre-commercial` ✅

| | |
|---|---|
| **Thème** | `personnes-vulnerables` |
| **Difficulté** | facile |
| **Accès** | gratuit |
| **Environnement** | centre commercial, 18 h 45 un vendredi |
| **Lot** | `lot_pilote_b.json` |

**Titre** — « Elle cherche sa voiture depuis trois heures et ne sait plus où
elle habite »

**Tension centrale** — Ne pas attribuer la confusion à l'âge : une cause
médicale aiguë et réversible doit être écartée par un avis médical.

**Objectif pédagogique** — Personne âgée vulnérable : communication adaptée,
dignité, refus de la laisser repartir seule, mobilisation des relais.

**Poids fort** — « Faire intervenir les secours pour un avis médical ».

---

### Cas 027 — `biens-vol-etalage-agent-securite-contestable` ✅

| | |
|---|---|
| **Thème** | `atteintes-biens` |
| **Difficulté** | **expert** |
| **Accès** | premium |
| **Environnement** | réserve de supermarché, 19 h 05 |
| **Lot** | `lot_pilote_c.json` |

**Titre** — « L'agent de sécurité l'a maintenue au sol dans la réserve »

**Tension centrale** — Deux volets imbriqués (vol allégué / violences par
l'agent) et une pression exercée sur le candidat pour étouffer l'affaire.

**Objectif pédagogique** — Résistance à la pression, faits constatés qui ne
peuvent disparaître, impartialité envers les deux parties.

**Poids fort** — « Vérifier sans délai la prise en charge du bébé » (Q2) et
« Refuser fermement de faire disparaître des faits constatés » (Q3).

---

### Cas 028 — `conflits-nuisances-sonores-copropriete` ✅

| | |
|---|---|
| **Thème** | `gestion-conflits` |
| **Difficulté** | facile |
| **Accès** | gratuit |
| **Environnement** | copropriété, palier, 23 h 30 un jeudi |
| **Lot** | `lot_pilote_c.json` |

**Titre** — « Troisième appel du même voisin pour la même musique »

**Tension centrale** — Le requérant annonce qu'il va « monter lui-même » ; le
trouble réel est modéré. Réponse graduée à assumer et à argumenter.

**Objectif pédagogique** — Conflit de voisinage installé : impartialité, réponse
graduée, valeur du compte rendu pour l'équipage suivant.

**Poids fort** — « Consigner impérativement la menace formulée ».

---

## BLOC C — ACCUEIL DU PUBLIC (029 → 059) · 31 cas

> Thème `accueil-public`. Environnement dominant : commissariat. Faire varier
> le poste (comptoir, bureau de plainte, standard), l'heure et l'affluence.
> Compétences visées : posture, discernement, confidentialité, orientation.
>
> **029 → 048 : ✅ importés et vérifiés en base** (27/07/2026, lots
> `lot_accueil_public_01` et `lot_accueil_public_02`). Reste 049 → 059
> (11 cas) pour compléter le quota du thème (32 au total).

#### 029 — `accueil-victime-etat-de-choc-mutique` ✅
**Thème** `accueil-public` · **moyen** · gratuit · *commissariat, 7 h 15, prise de service*
**Titre** — « Elle est debout dans le hall depuis vingt minutes et ne dit rien »

**Situation à construire** — Vous prenez votre service. Une femme d'une quarantaine d'années
se tient debout au milieu du hall, manteau boutonné de travers, sans sac ni téléphone. Le
collègue de nuit indique qu'elle est entrée vers 6 h 50 et n'a répondu à aucune question. Elle
ne pleure pas. Ses mains tremblent. Elle sursaute quand la porte automatique s'ouvre. Aucun
élément ne permet de savoir ce qui s'est passé ni si elle est blessée. Deux usagers arrivent.

**Tension centrale** — Le mutisme empêche tout recueil classique ; questionner davantage
aggrave le repli. Il faut créer les conditions de la parole avant de chercher les faits.
**Angle distinctif** — La sidération est le problème central. À ne pas confondre avec le refus
de plainte (022) ni avec la barrière linguistique (031) : elle comprend, elle ne peut pas parler.

**Q1** (5 pts) — « Quelles sont vos premières actions et comment adaptez-vous votre approche ? »
**Q2** (5 pts) — « Elle finit par dire "je n'aurais pas dû sortir". Comment poursuivez-vous ? »
**Q3** (5 pts) — « Quels éléments consignez-vous et vers quoi l'orientez-vous ? »

**Critères de grille attendus**
- Q1 : mettre à l'abri des regards · s'assurer de l'état physique · ne pas multiplier les
  questions · proposer boisson/chaise · faire assurer l'accueil par un collègue
- Q2 : ne pas interpréter la phrase · laisser venir sans combler les silences · rechercher
  les besoins urgents (blessure, enfants au domicile, auteur qui la cherche)
- Q3 : consigner ses propres constatations sur l'état · proposer examen médical ·
  orienter vers aide aux victimes · rendre compte
**Poids fort** — Reconnaître l'état de choc et adapter le rythme au lieu de questionner (2.0 sur Q1).

**Erreurs fréquentes à intégrer**
- Traiter le mutisme comme un refus de coopérer et clore l'accueil.
- Enchaîner les questions fermées, qui verrouillent définitivement la parole.
- Interpréter « je n'aurais pas dû sortir » comme un aveu de responsabilité.
- Repartir sans avoir vérifié l'absence de blessure ni la situation au domicile.

**Vigilance** — Aucune qualification à poser à ce stade : on ne sait pas ce qui s'est passé.
La réponse modèle ne doit pas présumer d'une agression sexuelle ni d'un fait conjugal.

#### 030 — `accueil-personne-agressive-comptoir` ✅
**Thème** `accueil-public` · **moyen** · gratuit · *commissariat, 11 h, file d'attente*
**Titre** — « Il frappe sur la vitre et exige d'être reçu tout de suite »

**Situation à construire** — M. GARCIA, 45 ans, frappe du plat de la main sur la vitre de
l'accueil. Il attend depuis quarante minutes pour un dépôt de plainte concernant un litige de
chantier. Il hausse la voix, prend les six personnes de la file à témoin, affirme qu'on ne fait
« jamais rien ». Il n'insulte pas et ne menace personne. Deux usagers filment discrètement. Une
mère avec un nourrisson recule vers la sortie. Vous êtes seul au guichet, votre collègue est
en entretien dans un bureau fermé.

**Tension centrale** — Désamorcer sans céder ni escalader, sous le regard d'un public qui
jugera aussi bien la fermeté que la brutalité de la réponse.
**Angle distinctif** — L'agressivité vise l'institution et son fonctionnement, pas un tiers.
Distinct de 028 (conflit entre voisins) et 288 (outrage constitué).

**Q1** (5 pts) — « Comment réagissez-vous dans les trente premières secondes ? »
**Q2** (5 pts) — « Il refuse de baisser le ton et dit qu'il ne partira pas. Que faites-vous ? »
**Q3** (5 pts) — « Quels enseignements tirez-vous pour la suite du service ? »

**Critères de grille attendus**
- Q1 : baisser sa propre voix · ne pas répondre à la mise en cause collective · reconnaître
  l'attente sans se justifier · proposer un cadre d'échange à l'écart
- Q2 : gradation · annoncer les conséquences sans menacer · demander l'appui d'un collègue ·
  protéger les autres usagers, notamment la mère et le nourrisson
- Q3 : rendre compte · signaler le dysfonctionnement d'attente · ne pas personnaliser
**Poids fort** — Techniques de désescalade verbale avant toute mesure de contrainte (2.0 sur Q1).

**Erreurs fréquentes à intégrer**
- Hausser le ton en miroir, ce qui légitime sa colère devant le public.
- Se justifier longuement sur l'organisation du service, ce qui relance le débat.
- Passer directement à la contrainte alors qu'aucune infraction n'est constituée.
- Ignorer les autres usagers, notamment ceux qui cherchent à s'éloigner.

**Vigilance** — Élever la voix ou frapper une vitre ne constitue pas en soi une infraction.
La réponse modèle ne doit pas qualifier hâtivement les faits d'outrage.

#### 031 — `accueil-usager-ne-parlant-pas-francais` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 14 h*
**Titre** — « Elle montre son téléphone, l'application de traduction ne suffit pas »

**Situation à construire** — Une femme d'environ 30 ans se présente seule. Elle ne parle pas
français et vous tend son téléphone affichant une traduction automatique : « mari frappé moi
hier soir enfants maison ». La traduction est approximative et vous ne parvenez pas à établir
qui a frappé qui, ni où sont les enfants. Elle porte des lunettes de soleil à l'intérieur. Elle
répète un mot que vous ne comprenez pas en montrant la porte. Aucun interprète n'est
immédiatement disponible dans cette langue.

**Tension centrale** — Des faits potentiellement graves, une urgence possible concernant des
enfants, et aucun canal fiable pour établir ce qui s'est réellement passé.
**Angle distinctif** — La barrière linguistique est l'obstacle unique et central. Distinct de
032 (handicap sensoriel) et 052 (illettrisme masqué).

**Q1** (5 pts) — « Comment procédez-vous pour établir une communication fiable ? »
**Q2** (5 pts) — « Un homme dans la file propose spontanément de traduire. Que décidez-vous ? »
**Q3** (5 pts) — « Quelles vérifications engagez-vous sans attendre la traduction ? »

**Critères de grille attendus**
- Q1 : recourir à un interprète professionnel · dispositifs d'interprétariat du service ·
  ne pas se contenter d'une traduction automatique pour des faits graves
- Q2 : refuser l'interprète improvisé · risque de partialité et de non-confidentialité ·
  refuser avec tact sans humilier le volontaire
- Q3 : vérifier son état physique (lunettes à l'intérieur) · localiser les enfants sans
  attendre · s'assurer qu'elle n'est pas suivie · rendre compte
**Poids fort** — Recourir à un interprète plutôt qu'à un accompagnant improvisé (2.0 sur Q2).

**Erreurs fréquentes à intégrer**
- Se satisfaire de la traduction automatique et rédiger sur cette base.
- Accepter le traducteur volontaire par facilité, sans mesurer le risque.
- Attendre l'interprète avant de vérifier la situation des enfants.
- Ne pas relever les lunettes de soleil portées à l'intérieur.

**Vigilance** — Ne pas présumer que la femme est la victime : la traduction est trop
approximative pour l'établir. La réponse modèle doit garder cette prudence.

#### 032 — `accueil-personne-sourde-malentendante` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 16 h*
**Titre** — « Il refuse que son fils de 10 ans serve d'interprète »

**Situation à construire** — M. NOEL, 42 ans, sourd de naissance, se présente avec son fils
Timothé, 10 ans, qui pratique la langue des signes. M. NOEL vient déclarer des faits de
dégradation répétée sur son véhicule, qu'il soupçonne être le fait d'un voisin. Le collègue qui
l'a reçu a commencé à interroger l'enfant pour qu'il traduise. M. NOEL s'agite et écrit sur un
papier : « PAS MON FILS ». Timothé, visiblement habitué à ce rôle, dit : « ça va, je peux le
faire, je fais toujours ». Il est 16 h, l'accueil est calme.

**Tension centrale** — La solution la plus simple sur le moment est aussi la moins acceptable :
faire porter à un enfant la charge de traduire les affaires de son père.
**Angle distinctif** — Accessibilité au handicap. Distinct de 031 (langue étrangère) : ici le
refus vient de la personne elle-même et protège l'enfant.

**Q1** (5 pts) — « Que faites-vous face à la situation que vous découvrez ? »
**Q2** (5 pts) — « Comment organisez-vous concrètement le recueil de sa déclaration ? »
**Q3** (5 pts) — « Quels enseignements en tirez-vous pour l'accueil de votre service ? »

**Critères de grille attendus**
- Q1 : interrompre la traduction par l'enfant · reconnaître la légitimité du refus du père ·
  ne pas mettre en cause le collègue devant l'usager
- Q2 : dispositifs d'interprétariat en langue des signes · écrit comme solution transitoire ·
  vérifier que l'écrit lui convient · prendre le temps nécessaire
- Q3 : signaler le besoin de formation ou de dispositif · rendre compte · accessibilité
  comme obligation, pas comme faveur
**Poids fort** — Refuser l'enfant comme intermédiaire et chercher un dispositif adapté (2.0 sur Q1).

**Erreurs fréquentes à intégrer**
- Accepter la traduction par l'enfant au motif qu'il est volontaire et compétent.
- Supposer qu'une personne sourde lit forcément couramment le français écrit.
- Parler à l'enfant plutôt qu'au père pendant tout l'entretien.
- Traiter l'accessibilité comme un service rendu et non comme un dû.

**Vigilance** — Ne pas confondre surdité et déficience intellectuelle : le registre de langage
adressé à M. NOEL doit rester celui d'un adulte.

#### 033 — `accueil-mineur-se-presentant-seul` ✅
**Thème** `accueil-public` · **moyen** · gratuit · *commissariat, 18 h 20*
**Titre** — « Il a 14 ans, il est venu seul et ne veut pas qu'on appelle chez lui »

**Situation à construire** — Un adolescent se présente à l'accueil, sac de cours sur le dos. Il
donne son prénom, Yanis, dit avoir 14 ans, et demande « si c'est vrai qu'on a le droit de vous
parler sans que les parents le sachent ». Il reste debout, prêt à partir. Il finit par dire que
son beau-père « pète les plombs » depuis que sa mère travaille de nuit, et qu'il ne veut pas
rentrer ce soir. Il ne décrit aucun fait précis et refuse de donner son nom de famille. Il est
18 h 20, il fait nuit dehors.

**Tension centrale** — L'obligation de protection impose d'identifier et de joindre les
représentants légaux, ce qui est exactement ce que le mineur redoute. Le brusquer le fera partir.
**Angle distinctif** — Le mineur est demandeur et lucide. Distinct de 013 (fugue avec
révélation explicite) et 135 (refus catégorique de rentrer, sans démarche volontaire).

**Q1** (5 pts) — « Comment recevez-vous Yanis et que lui répondez-vous sur la confidentialité ? »
**Q2** (5 pts) — « Il refuse de donner son nom et fait mine de partir. Que faites-vous ? »
**Q3** (5 pts) — « Quelles suites donnez-vous à cette venue ? »

**Critères de grille attendus**
- Q1 : le recevoir à l'écart · s'adresser à lui d'égal à égal · ne pas promettre un secret
  impossible · expliquer honnêtement ce qui sera fait
- Q2 : ne pas le retenir physiquement sans motif · gagner du temps par le dialogue ·
  ne pas le laisser repartir sans solution · alerter la hiérarchie
- Q3 : signalement au titre de la protection de l'enfance · consigner ses propos exacts ·
  ne pas différer au motif que les faits sont imprécis
**Poids fort** — Ne pas renvoyer le mineur sans solution ni le livrer sans précaution (2.0 sur Q2).

**Erreurs fréquentes à intégrer**
- Promettre que ses parents ne sauront rien, promesse intenable qui détruira la confiance.
- Exiger son identité complète comme préalable à toute écoute.
- Considérer que l'absence de faits précis dispense de tout signalement.
- Appeler le domicile devant lui sans l'avoir préparé.

**Vigilance** — Ne pas qualifier les faits : « pète les plombs » ne caractérise rien. La
réponse modèle doit rester au stade du recueil et de la protection.

#### 034 — `accueil-proche-demande-infos-garde-a-vue` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 22 h*
**Titre** — « Sa mère veut savoir s'il est là et ce qu'il a fait »

**Situation à construire** — Mme AMARI se présente à 22 h. Son fils de 19 ans n'est pas rentré
et un ami lui a dit l'avoir vu « embarqué » en fin d'après-midi. Elle est inquiète, polie,
insistante. Elle demande s'il est dans les locaux, ce qu'on lui reproche, s'il a mangé, et si
elle peut lui apporter son traitement contre l'asthme. Vous n'êtes pas en charge de la
procédure. Un collègue vous glisse que le jeune homme est effectivement retenu.

**Tension centrale** — Une inquiétude parentale entièrement légitime se heurte au secret de
l'enquête. Le refus doit être tenu, mais la question du traitement médical ne peut être ignorée.
**Angle distinctif** — Le secret est opposé à un proche de bonne foi, pas à un curieux ni à
une sollicitation intéressée. Distinct de 018 et 040.

**Q1** (5 pts) — « Que pouvez-vous lui dire et que ne pouvez-vous pas lui dire ? »
**Q2** (5 pts) — « Elle insiste sur le traitement contre l'asthme. Comment traitez-vous ce point ? »
**Q3** (5 pts) — « Comment terminez-vous cet échange ? »

**Critères de grille attendus**
- Q1 : ne pas confirmer ni infirmer la présence · expliquer l'existence du secret sans se
  retrancher derrière une formule · rester chaleureux dans le refus
- Q2 : transmettre l'information médicale sans délai à qui de droit · ne pas la traiter
  comme une manœuvre · ne pas confirmer la présence pour autant
- Q3 : informer des droits de la personne retenue en termes généraux · orienter ·
  rendre compte de la démarche à l'OPJ
**Poids fort** — Distinguer ce qui peut être dit de ce qui ne peut pas l'être (2.0 sur Q1).

**Erreurs fréquentes à intégrer**
- Confirmer la présence « pour la rassurer », ce qui est déjà une divulgation.
- Se réfugier derrière un « je ne peux rien dire » sec, qui nourrit le sentiment d'arbitraire.
- Négliger l'information sur le traitement médical parce qu'elle vient d'un tiers.
- Ne pas rendre compte de la venue de la mère à l'OPJ en charge.

**Vigilance** — Ne pas détailler le régime juridique de la mesure ni ses délais : la réponse
modèle doit rester générale sur les droits.

#### 035 — `accueil-usager-filme-dans-le-hall` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 15 h 30*
**Titre** — « Il filme le comptoir en direct et commente à voix haute »

**Situation à construire** — Un homme d'une trentaine d'années entre dans le hall, téléphone
tendu devant lui, et annonce à ses spectateurs qu'il va « montrer comment ça se passe vraiment ».
Il filme le comptoir, les affiches, et balaie la salle où trois personnes attendent — dont une
femme venue déposer plainte pour des faits de violences conjugales, qui se lève et se détourne.
Il vous interpelle, demande votre matricule, et commente chacune de vos réactions. Il ne franchit
aucune limite physique et ne profère aucune insulte.

**Tension centrale** — Ne pas offrir la réaction recherchée, tout en protégeant les autres
usagers dont la présence même au commissariat est une information sensible.
**Angle distinctif** — Captation dans un lieu recevant du public, avec des tiers vulnérables
présents. Distinct de 287 (distance physique en intervention) et 246 (vidéo déjà diffusée).

**Q1** (5 pts) — « Quelle attitude adoptez-vous face à cette captation ? »
**Q2** (5 pts) — « Vous constatez que la plaignante est filmée. Que faites-vous ? »
**Q3** (5 pts) — « Il exige votre matricule et refuse de baisser son téléphone. Comment gérez-vous ? »

**Critères de grille attendus**
- Q1 : maîtrise de soi · comportement identique à l'ordinaire · ne pas commenter la captation ·
  ne pas se cacher ni s'énerver
- Q2 : protéger les tiers en priorité · déplacer la plaignante hors du champ · expliquer à
  l'intéressé l'atteinte causée aux autres · ne pas saisir le téléphone
- Q3 : répondre sur les éléments d'identification prévus · rester courtois · rendre compte
**Poids fort** — Maîtrise de soi et protection de la confidentialité des autres usagers (2.0 sur Q2).

**Erreurs fréquentes à intégrer**
- Interdire globalement de filmer, ce qui est excessif et alimentera la vidéo.
- Saisir ou détourner le téléphone sans fondement.
- Se focaliser sur sa propre exposition en oubliant la plaignante filmée.
- Adopter un ton ironique ou provocateur, qui sera l'extrait le plus partagé.

**Vigilance** — La réponse modèle ne doit pas affirmer qu'il est interdit de filmer dans un
hall de commissariat : c'est la protection des tiers qui fonde l'action, pas une interdiction générale.

#### 036 — `accueil-differend-priorite-prise-en-charge` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 9 h 45*
**Titre** — « Vous étiez là avant moi, et alors ? »

**Situation à construire** — Deux personnes attendent. M. PICARD, arrivé à 9 h 10, vient
déclarer le vol de sa plaque d'immatriculation. Mme SOARES, arrivée à 9 h 40, tient son
poignet contre elle et explique à voix basse qu'elle a été bousculée et frappée une heure plus
tôt ; elle doit récupérer sa fille à l'école à 11 h 30. Vous décidez de la recevoir en premier.
M. PICARD s'y oppose vivement : il attend depuis trente-cinq minutes et estime qu'on ne
respecte pas l'ordre d'arrivée.

**Tension centrale** — La priorité donnée est justifiée mais invisible pour celui qui attend :
il ne connaît ni les faits ni la blessure. Expliquer sans divulguer.
**Angle distinctif** — Conflit entre usagers sur l'organisation de l'accueil. Ressort
organisationnel, pas comportemental. Distinct de 048 (gestion d'une file entière).

**Q1** (5 pts) — « Sur quels critères fondez-vous votre décision de priorité ? »
**Q2** (5 pts) — « Comment l'expliquez-vous à M. PICARD sans divulguer la situation de Mme SOARES ? »
**Q3** (5 pts) — « Comment évitez-vous que la situation se reproduise dans la matinée ? »

**Critères de grille attendus**
- Q1 : atteinte aux personnes avant atteinte aux biens · blessure à faire constater ·
  contrainte horaire liée à un enfant · caractère récent des faits
- Q2 : expliquer le principe sans le cas · ne rien révéler de la situation de la victime ·
  reconnaître l'attente subie · donner un délai réaliste
- Q3 : informer l'ensemble des personnes présentes · faire assurer un relais · rendre compte
  de la tension d'affluence
**Poids fort** — Expliquer le critère de priorité au lieu de l'imposer sans mot (2.0 sur Q2).

**Erreurs fréquentes à intégrer**
- Justifier la priorité en dévoilant que l'autre personne est victime de violences.
- Imposer la décision sans un mot, ce qui transforme un malentendu en conflit.
- Céder et prendre M. PICARD en premier pour avoir la paix.
- Promettre un délai qu'on sait intenable.

**Vigilance** — La réponse modèle ne doit pas hiérarchiser les victimes en dévalorisant le
motif de M. PICARD : son affaire est légitime, elle est simplement moins urgente.

#### 037 — `accueil-main-courante-ou-plainte` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 10 h*
**Titre** — « On m'a dit de faire une main courante, c'est pareil non ? »

**Situation à construire** — Mme FONTAINE, 52 ans, explique que son ex-conjoint passe devant
son domicile plusieurs fois par semaine, s'arrête, la regarde, et repart sans rien dire. Cela
dure depuis quatre mois. Elle a noté les dates sur un agenda. Elle précise d'emblée : « je ne
veux pas d'histoires, je veux juste que ce soit noté quelque part ». Une connaissance lui a
conseillé de « faire une main courante ». Elle minimise, sourit, et dit que « ce n'est pas
non plus de la violence ».

**Tension centrale** — La demande de l'usagère et ce que la situation appelle ne coïncident
pas. L'orientation choisie a des conséquences durables sur la protection de la personne.
**Angle distinctif** — Porte sur la nature de l'acte lui-même et le devoir d'information.
Distinct de 105 (harcèlement post-séparation déjà qualifié comme tel par la victime).

**Q1** (5 pts) — « Que lui expliquez-vous sur la différence entre les deux démarches ? »
**Q2** (5 pts) — « Comment analysez-vous les faits qu'elle décrit ? »
**Q3** (5 pts) — « Elle maintient sa préférence pour la main courante. Comment concluez-vous ? »

**Critères de grille attendus**
- Q1 : expliquer clairement les effets de chaque démarche · ne pas orienter par facilité ·
  vérifier qu'elle a compris avant de choisir
- Q2 : répétition sur quatre mois · caractère intentionnel apparent · retentissement
  possible · ne pas conclure à l'absence d'infraction parce qu'il n'y a pas de contact
- Q3 : respecter son choix éclairé · recueillir malgré tout les éléments datés · l'informer
  qu'elle peut revenir · rendre compte
**Poids fort** — Ne jamais orienter vers la main courante pour éviter une procédure (2.0 sur Q1).

**Erreurs fréquentes à intégrer**
- Acquiescer à la main courante parce que c'est plus rapide et que l'usagère le demande.
- Reprendre à son compte la minimisation : « effectivement, il ne vous a rien fait ».
- Ne pas exploiter l'agenda, qui est l'élément le plus solide du dossier.
- Forcer la plainte contre sa volonté, sans l'avoir informée.

**Vigilance** — Ne pas citer d'article ni affirmer que les faits sont constitués : la réponse
modèle explique la démarche et recueille, sans qualifier.

#### 038 — `accueil-plainte-violences-intrafamiliales-signalee` ✅
**Thème** `accueil-public` · **difficile** · premium · *commissariat, 20 h 30*
**Titre** — « Sa voisine l'a accompagnée mais il attend dans la voiture »

**Situation à construire** — Mme BERTIN, 31 ans, se présente accompagnée de sa voisine. Elle
souhaite déposer plainte contre son conjoint pour des violences survenues la veille. En fin
d'entretien, la voisine vous prend à part : le conjoint les a suivies, il est garé en face du
commissariat depuis leur arrivée, dans une berline grise. Mme BERTIN, informée, pâlit et dit
qu'elle ne peut pas rentrer chez elle mais qu'elle n'a nulle part où aller. Ses deux enfants
sont chez sa mère, à quinze minutes. Il est 20 h 30.

**Tension centrale** — Le danger n'est plus au domicile ni dans le passé : il est devant la
porte, maintenant, et la victime doit ressortir.
**Angle distinctif** — L'auteur présumé est à proximité immédiate du commissariat pendant le
dépôt de plainte. Distinct de 021, 022 et 099 (danger au domicile).

**Q1** (5 pts) — « Quelles sont vos priorités dès que vous apprenez sa présence ? »
**Q2** (5 pts) — « Comment organisez-vous concrètement sa sortie et sa mise en sécurité ? »
**Q3** (5 pts) — « Quels éléments transmettez-vous et à qui ? »

**Critères de grille attendus**
- Q1 : faire vérifier la présence du véhicule · ne pas la faire sortir · évaluer le risque
  immédiat · penser aux enfants chez la grand-mère
- Q2 : solution d'hébergement · sortie sécurisée · ne pas la renvoyer à son domicile ·
  associer la voisine sans lui faire porter le risque
- Q3 : rendre compte sans délai · signalement du contexte de suivi · transmettre les
  éléments sur le véhicule · alerter sur la situation des enfants
**Poids fort** — Sécuriser la sortie et anticiper le retour au domicile (2.0 sur Q2).

**Erreurs fréquentes à intégrer**
- Terminer la plainte et laisser repartir la victime sans traiter la présence du conjoint.
- Envoyer un équipage interpeller le conjoint sans avoir d'abord sécurisé la victime.
- Oublier les enfants, qui sont à une adresse connue de l'auteur.
- Faire porter la solution à la voisine, qui devient alors exposée.

**Vigilance** — La présence du conjoint devant le commissariat n'est pas en soi une infraction :
la réponse modèle doit fonder l'action sur la protection, pas sur une qualification hâtive.

#### 039 — `accueil-disparition-inquietante-signalement` ✅
**Thème** `accueil-public` · **difficile** · premium · *commissariat, 23 h 10*
**Titre** — « Elle n'est pas rentrée et son traitement est resté à la maison »
**Tension** — Distinguer une absence banale d'une disparition inquiétante.
**Angle distinctif** — Évaluation du caractère inquiétant, pas de la prise en charge (cf. 013).
**Poids fort** — Identifier les critères d'inquiétude et ne pas différer.

#### 040 — `accueil-personne-souhaitant-info-confidentielle` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 13 h*
**Titre** — « Je veux juste savoir si mon locataire est fiché »
**Tension** — Demande présentée comme anodine, portant sur des données protégées.
**Angle distinctif** — Sollicitation extérieure au guichet, pas une pression amicale (cf. 017).
**Poids fort** — Refuser clairement et expliquer pourquoi, sans se justifier à l'excès.

#### 041 — `accueil-plainte-escroquerie-en-ligne-montant-eleve` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 11 h 30*
**Titre** — « Il a viré 24 000 euros en trois jours et veut annuler »
**Tension** — Urgence bancaire réelle contre attentes irréalistes sur la restitution.
**Angle distinctif** — L'urgence est financière et se joue en heures.
**Poids fort** — Orienter sans délai vers l'opposition bancaire, avant la procédure.

#### 042 — `accueil-personne-sdf-demande-hebergement` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 2 h, hiver*
**Titre** — « Il demande à rester dans le hall jusqu'au matin »
**Tension** — Le commissariat n'est pas un hébergement, mais dehors il gèle.
**Angle distinctif** — Aucune infraction, uniquement une question d'assistance.
**Poids fort** — Mobiliser les dispositifs d'hébergement au lieu de renvoyer.

#### 043 — `accueil-restitution-objet-trouve-conteste` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 17 h*
**Titre** — « Deux personnes réclament le même téléphone »
**Tension** — Aucun des deux ne peut prouver immédiatement sa propriété.
**Angle distinctif** — Litige civil au guichet, ressort méthodologique.
**Poids fort** — Ne rien remettre sans vérification, malgré la pression.

#### 044 — `accueil-plainte-contre-un-policier` ✅
**Thème** `accueil-public` · **difficile** · premium · *commissariat, 14 h 45*
**Titre** — « Je viens porter plainte contre l'un des vôtres »
**Tension** — Loyauté envers le service contre obligation d'enregistrer.
**Angle distinctif** — Le mis en cause appartient à l'institution qui accueille.
**Poids fort** — Recevoir la plainte sans dissuader ni commenter.

#### 045 — `accueil-personne-en-etat-divresse-avancee` ✅
**Thème** `accueil-public` · **moyen** · gratuit · *commissariat, 3 h 20*
**Titre** — « Il veut déposer plainte mais ne tient pas debout »
**Tension** — Recueil impossible en l'état, refus de partir, risque sanitaire.
**Angle distinctif** — L'état de la personne empêche l'acte lui-même.
**Poids fort** — Évaluer le risque médical avant toute considération procédurale.

#### 046 — `accueil-parent-separe-demande-adresse` ✅
**Thème** `accueil-public` · **difficile** · premium · *commissariat, 16 h 15*
**Titre** — « Il veut l'adresse de son ex-compagne pour voir ses enfants »
**Tension** — Demande présentée comme légitime, potentiellement dangereuse.
**Angle distinctif** — Le contexte familial masque un possible contournement de protection.
**Poids fort** — Vérifier l'existence de mesures de protection avant toute réponse.

#### 047 — `accueil-temoin-souhaitant-rester-anonyme` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 19 h*
**Titre** — « Je vous dis tout mais mon nom n'apparaît nulle part »
**Tension** — Information utile contre exigence impossible à garantir telle quelle.
**Angle distinctif** — Porte sur les conditions du témoignage.
**Poids fort** — Ne pas promettre un anonymat qu'on ne peut pas tenir.

#### 048 — `accueil-file-attente-tension-generalisee` ✅
**Thème** `accueil-public` · **moyen** · gratuit · *commissariat, 12 h, effectif réduit*
**Titre** — « Huit personnes attendent, deux commencent à s'invectiver »
**Tension** — Gérer un collectif alors que l'effectif ne permet pas de tout traiter.
**Angle distinctif** — Gestion de flux, pas d'un usager isolé.
**Poids fort** — Informer et organiser l'attente plutôt que subir.

#### 049 — `accueil-signalement-maltraitance-par-un-voisin` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 21 h*
**Titre** — « Il entend l'enfant pleurer tous les soirs mais ne veut pas d'ennuis »
**Tension** — Signalant réticent, information vague mais potentiellement grave.
**Angle distinctif** — Le signalant n'est ni victime ni témoin direct.
**Poids fort** — Recueillir et transmettre malgré l'imprécision, sans banaliser.

#### 050 — `accueil-personne-transgenre-etat-civil` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 15 h*
**Titre** — « Le prénom sur la pièce d'identité n'est pas celui qu'elle utilise »
**Tension** — Exigences de l'acte contre respect de la personne.
**Angle distinctif** — Dignité dans la forme de l'acte, distinct de 032 (accessibilité).
**Poids fort** — Concilier exactitude de l'acte et respect dans l'échange.

#### 051 — `accueil-plainte-tardive-faits-anciens` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 10 h 30*
**Titre** — « Ça s'est passé il y a onze ans, on m'a dit que c'était trop tard »
**Tension** — L'usager arrive déjà découragé par un refus antérieur.
**Angle distinctif** — Porte sur l'ancienneté des faits et le découragement.
**Poids fort** — Ne pas apprécier soi-même la prescription pour refuser.

#### 052 — `accueil-personne-illettree-formulaire` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 9 h*
**Titre** — « Il dit avoir oublié ses lunettes pour la troisième fois »
**Tension** — L'illettrisme est masqué par une excuse ; l'humiliation guette.
**Angle distinctif** — Détecter ce qui n'est pas dit, différent des cas 031-032.
**Poids fort** — Proposer une aide sans exposer la personne ni la nommer.

#### 053 — `accueil-usager-agressif-au-telephone-standard` ✅
**Thème** `accueil-public` · **facile** · gratuit · *standard, 17 h 40*
**Titre** — « Il insulte, raccroche, rappelle immédiatement »
**Tension** — Ligne monopolisée alors que d'autres appels urgents peuvent arriver.
**Angle distinctif** — Contact téléphonique, sans visuel ni possibilité d'orientation.
**Poids fort** — Ne pas rendre l'agressivité et libérer la ligne sans négliger l'appel.

#### 054 — `accueil-victime-refusant-examen-medical` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 18 h*
**Titre** — « Elle a des marques mais ne veut voir personne »
**Tension** — Constatation médicale utile à la procédure contre refus de la victime.
**Angle distinctif** — Refus porte sur l'examen, pas sur la plainte (cf. 022).
**Poids fort** — Consigner ses propres constatations à défaut d'examen.

#### 055 — `accueil-demande-protection-apres-menaces` ✅
**Thème** `accueil-public` · **difficile** · premium · *commissariat, 20 h*
**Titre** — « Il demande une protection policière devant chez lui »
**Tension** — Attente d'un dispositif que le service ne peut pas fournir tel quel.
**Angle distinctif** — Décalage entre demande et moyens réels.
**Poids fort** — Évaluer la réalité de la menace sans promettre l'impossible.

#### 056 — `accueil-personne-sous-tutelle-seule` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 11 h*
**Titre** — « Elle veut porter plainte contre son tuteur »
**Tension** — Le protecteur légal est le mis en cause.
**Angle distinctif** — Conflit d'intérêts structurel dans le régime de protection.
**Poids fort** — Recevoir la plainte sans renvoyer vers le tuteur.

#### 057 — `accueil-groupe-jeunes-plainte-collective` ✅
**Thème** `accueil-public` · **facile** · gratuit · *commissariat, 19 h 30*
**Titre** — « Ils sont six et parlent tous en même temps »
**Tension** — Récits qui se contaminent mutuellement dans le hall.
**Angle distinctif** — Multiplicité des déclarants comme obstacle méthodologique.
**Poids fort** — Séparer les récits avant qu'ils ne s'harmonisent.

#### 058 — `accueil-remise-objet-dangereux-spontanee` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 14 h*
**Titre** — « Il pose un sac sur le comptoir et dit l'avoir trouvé »
**Tension** — Objet potentiellement dangereux au milieu d'un lieu public.
**Angle distinctif** — Risque matériel immédiat au guichet.
**Poids fort** — Sécuriser l'espace avant toute question sur la provenance.

#### 059 — `accueil-plainte-contre-un-proche-hesitation` ✅
**Thème** `accueil-public` · **moyen** · premium · *commissariat, 16 h 40*
**Titre** — « Elle veut savoir ce qui arrivera à son fils avant de déposer »
**Tension** — La plainte vise un proche ; l'information sur les suites conditionne la décision.
**Angle distinctif** — L'hésitation naît du lien familial avec l'auteur.
**Poids fort** — Informer loyalement sans orienter la décision.

---

## BLOC D — POLICE-SECOURS ET INTERVENTIONS D'URGENCE (060 → 098) · 39 cas ✅ **BLOC COMPLET** (cible du thème portée à 55, cf. § 1 — 10 cas restants à produire hors plan initial)

> Thème `police-secours`. Le bloc le plus dense du catalogue. Faire varier
> radicalement les lieux : voie publique, transports, commerces, milieu rural,
> hauteur, milieu aquatique. Compétences : priorisation, sécurité de l'équipage,
> compte rendu, coordination avec les secours.

#### Cas hors plan initial ajoutés à la demande de l'utilisateur (27/07/2026) ✅

> L'utilisateur a demandé d'augmenter significativement le volume de cas
> police-secours, ce type d'intervention étant le plus fréquent au quotidien
> pour un gardien de la paix. 5 cas supplémentaires ont été rédigés, contrôlés
> et importés (migration `20260727040000_...`), couvrant : tapage nocturne
> (auteur seul, sans fête), découverte de corps sans vie à domicile (volet
> police-secours : préservation de la scène, gestion de la famille),
> différend conjugal sans trace visible (détection de signaux faibles),
> différend de voisinage (litige de propriété, hors nuisance sonore déjà
> couverte par `conflits-nuisances-sonores-copropriete`), différend familial
> autour de la prise en charge d'un parent âgé dépendant (distinct du cas 075
> qui porte sur un repas de famille dégénéré).

- `secours-tapage-nocturne-voisin-seul` ✅ — facile, gratuit
- `secours-decouverte-corps-sans-vie-domicile` ✅ — difficile, premium
- `secours-differend-conjugal-sans-trace-visible` ✅ — difficile, premium
- `secours-differend-voisinage-limite-de-propriete` ✅ — facile, gratuit
- `secours-differend-familial-heritage-parent-age` ✅ — moyen, premium

#### Second lot hors plan (28/07/2026) — **thème `police-secours` complet : 55/55** ✅

> Deuxième et dernier lot de cas hors plan, complétant la cible de 55 portée
> le 27/07/2026. Chaque cas explore un angle distinct des cinq précédents,
> pour éviter tout doublon pédagogique : contexte professionnel plutôt que
> domestique pour le tapage, récidive documentée, lieu public plutôt que
> domicile pour la découverte de corps, isolement social plutôt que scène
> simple, présence de tiers (beaux-parents) ou mutisme d'une partie pour le
> conjugal, stationnement et végétation mitoyenne pour le voisinage (distincts
> de la nuisance sonore et de la limite de propriété déjà couvertes), garde
> alternée et menace de fugue adolescente pour le familial (distincts de
> l'héritage et du repas de famille du cas 075).

- `secours-tapage-nocturne-lieu-professionnel` ✅ — facile, gratuit
- `secours-tapage-nocturne-recidive-meme-adresse` ✅ — moyen, premium
- `secours-decouverte-corps-espace-public` ✅ — moyen, premium
- `secours-decouverte-corps-mort-naturelle-personne-isolee` ✅ — moyen, premium
- `secours-differend-conjugal-en-presence-des-beaux-parents` ✅ — moyen, premium
- `secours-differend-conjugal-un-des-deux-refuse-de-s-exprimer` ✅ — moyen, premium
- `secours-differend-voisinage-stationnement-repete` ✅ — facile, gratuit
- `secours-differend-voisinage-plantes-vegetation-mitoyenne` ✅ — facile, gratuit
- `secours-differend-familial-garde-alternee-tendue` ✅ — moyen, premium
- `secours-differend-familial-adolescent-fugue-menacee` ✅ — moyen, premium

#### 060 — `secours-individu-arme-signale-rue` ✅
**Thème** `police-secours` · **difficile** · premium · *rue commerçante, 18 h, forte affluence*
**Titre** — « Un homme avec un couteau devant la boulangerie »
**Tension** — Foule dense, signalement imprécis, mise à distance impérative.
**Angle distinctif** — La densité de public est la contrainte majeure.
**Poids fort** — Mise à distance et protection des tiers avant tout contact.

#### 061 — `secours-rixe-entre-deux-groupes` ✅
**Thème** `police-secours` · **difficile** · premium · *parking de lycée, 17 h 15*
**Titre** — « Une quinzaine de jeunes, deux au sol »
**Tension** — Effectif insuffisant, blessés à secourir, auteurs qui se dispersent.
**Angle distinctif** — Rapport de force défavorable, arbitrage secours/interpellation.
**Poids fort** — Renoncer à interpeller pour secourir et sécuriser.

#### 062 — `secours-personne-inconsciente-voie-publique` ✅
**Thème** `police-secours` · **facile** · gratuit · *trottoir, 8 h 30*
**Titre** — « Il est allongé, les passants l'ont contourné »
**Tension** — Cause inconnue : malaise, agression, intoxication ?
**Angle distinctif** — Aucune information initiale, tout repose sur le bilan.
**Poids fort** — Gestes de premiers secours et alerte immédiate.

#### 063 — `secours-incendie-immeuble-habite` ✅
**Thème** `police-secours` · **difficile** · premium · *immeuble R+5, 2 h 40*
**Titre** — « Fumée au troisième, des gens aux fenêtres »
**Tension** — Rôle du policier avant l'arrivée des pompiers, sans matériel adapté.
**Angle distinctif** — Le policier n'est pas le service compétent mais arrive en premier.
**Poids fort** — Ne pas s'engager au-delà de ses moyens ; évacuer et baliser.

#### 064 — `secours-fuite-de-gaz-signalee` ✅
**Thème** `police-secours` · **moyen** · premium · *pavillon, 19 h*
**Titre** — « Une odeur forte dans toute la rue »
**Tension** — Risque d'explosion ; certains gestes réflexes sont dangereux.
**Angle distinctif** — Le danger est invisible et aggravé par de mauvais réflexes.
**Poids fort** — Périmètre et interdiction de tout ce qui peut produire une étincelle.

#### 065 — `secours-tentative-suicide-hauteur` ✅
**Thème** `police-secours` · **expert** · premium · *toit de parking, 21 h 30*
**Titre** — « Il est assis sur le rebord et demande qu'on n'approche pas »
**Tension** — Toute approche peut précipiter le geste ; le temps joue contre.
**Angle distinctif** — Situation évolutive avec négociation, distincte de 016 (porte close).
**Poids fort** — Établir un contact verbal sans réduire la distance.

#### 066 — `secours-cambriolage-en-cours-signale` ✅
**Thème** `police-secours` · **moyen** · premium · *pavillon, 3 h 15*
**Titre** — « La voisine voit une lampe bouger à l'intérieur »
**Tension** — Auteurs peut-être encore présents ; discrétion de l'approche.
**Angle distinctif** — Flagrance possible, l'effet de surprise compte.
**Poids fort** — Dispositif d'approche et couverture des issues.

#### 067 — `secours-vol-avec-violence-victime-choquee` ✅
**Thème** `police-secours` · **moyen** · gratuit · *arrêt de bus, 22 h*
**Titre** — « Elle décrit l'agresseur trois fois différemment »
**Tension** — Signalement à diffuser vite, mais témoignage instable sous le choc.
**Angle distinctif** — Fiabilité du signalement en état de stress aigu.
**Poids fort** — Recueillir un signalement exploitable sans induire la réponse.

#### 068 — `secours-agression-dans-le-metro` ✅
**Thème** `police-secours` · **moyen** · premium · *rame de métro, 23 h*
**Titre** — « L'agresseur est descendu à la station précédente »
**Tension** — Espace confiné, nombreux témoins, auteur en fuite dans le réseau.
**Angle distinctif** — Contrainte du milieu fermé et de l'exploitant.
**Poids fort** — Coordination avec l'exploitant et préservation des images.

#### 069 — `secours-mouvement-de-foule-sortie-concert` ✅
**Thème** `police-secours` · **difficile** · premium · *salle de concert, 23 h 45*
**Titre** — « La sortie de secours est bloquée par une grille »
**Tension** — Risque d'écrasement, décision à prendre en quelques secondes.
**Angle distinctif** — Danger collectif sans auteur ni infraction initiale.
**Poids fort** — Rétablir un flux de sortie avant toute autre considération.

#### 070 — `secours-violences-etablissement-scolaire` ✅
**Thème** `police-secours` · **moyen** · premium · *collège, 10 h 20*
**Titre** — « Un élève a frappé un surveillant devant sa classe »
**Tension** — Intervenir dans un établissement scolaire, devant des mineurs.
**Angle distinctif** — Cadre scolaire et présence de nombreux mineurs témoins.
**Poids fort** — Discrétion de l'intervention et articulation avec la direction.

#### 071 — `secours-intervention-presence-enfants` ✅
**Thème** `police-secours` · **difficile** · premium · *appartement, 20 h 30*
**Titre** — « Les trois enfants sont assis sur le canapé et regardent »
**Tension** — Intervention nécessaire mais chaque geste est vu par des enfants.
**Angle distinctif** — La présence d'enfants conditionne la manière d'agir.
**Poids fort** — Éloigner les enfants avant toute mesure de contrainte.

#### 072 — `secours-personne-retranchee-domicile` ✅
**Thème** `police-secours` · **expert** · premium · *pavillon, 5 h 10*
**Titre** — « Il crie qu'il ne sortira pas et qu'il a de quoi se défendre »
**Tension** — Situation figée qui peut basculer ; tentation d'agir trop vite.
**Angle distinctif** — Le temps est un allié, contrairement à la plupart des urgences.
**Poids fort** — Figer le dispositif et demander les moyens spécialisés.

#### 073 — `secours-accident-corporel-autoroute` ✅
**Thème** `police-secours` · **difficile** · premium · *aire d'autoroute, 6 h, brouillard*
**Titre** — « Deux véhicules, la voie de droite est bloquée »
**Tension** — Suraccident imminent, visibilité nulle, blessés à protéger.
**Angle distinctif** — Le danger principal vient de la circulation, pas de l'accident.
**Poids fort** — Balisage et protection avant approche des victimes.

#### 074 — `secours-noyade-plage-surveillee` ✅
**Thème** `police-secours` · **moyen** · premium · *plage, 15 h, été*
**Titre** — « Les parents cherchent l'enfant depuis dix minutes »
**Tension** — Recherche à organiser vite, milieu ouvert, panique familiale.
**Angle distinctif** — Milieu aquatique et coordination avec les secours nautiques.
**Poids fort** — Organiser la recherche plutôt que d'y participer sans méthode.

#### 075 — `secours-differend-familial-repas-degenere` ✅
**Thème** `police-secours` · **moyen** · gratuit · *pavillon, 14 h, dimanche*
**Titre** — « Le repas de famille a fini dehors, sur la pelouse »
**Tension** — Huit adultes impliqués, versions contradictoires, aucun blessé grave.
**Angle distinctif** — Conflit familial élargi, pas conjugal (cf. 021-022).
**Poids fort** — Séparer et faire baisser la tension avant toute qualification.

#### 076 — `secours-alerte-enlevement-parental` ✅
**Thème** `police-secours` · **difficile** · premium · *école, 16 h 30*
**Titre** — « Le père est venu chercher l'enfant sans en avoir le droit »
**Tension** — Urgence réelle mais situation juridique familiale complexe.
**Angle distinctif** — L'auteur présumé est le parent, avec un lien légitime apparent.
**Poids fort** — Vérifier la décision de justice avant d'agir.

#### 077 — `secours-personne-agee-chute-domicile` ✅
**Thème** `police-secours` · **facile** · gratuit · *appartement, 9 h*
**Titre** — « Elle n'a pas répondu au téléphone depuis deux jours »
**Tension** — Ouvrir ou non ; personne peut-être au sol depuis longtemps.
**Angle distinctif** — Urgence médicale par isolement, sans tiers mis en cause.
**Poids fort** — Justifier l'ouverture et faire intervenir les secours.

#### 078 — `secours-colis-suspect-lieu-public` ✅
**Thème** `police-secours` · **moyen** · premium · *centre commercial, 12 h*
**Titre** — « Un sac de sport seul devant une vitrine depuis une heure »
**Tension** — Ne pas sur-réagir, ne pas sous-estimer ; évacuation coûteuse.
**Angle distinctif** — Volet police-secours (premier échelon), cf. bloc situations sensibles.
**Poids fort** — Périmètre et abstention de toute manipulation.

#### 079 — `secours-conducteur-malaise-au-volant` ✅
**Thème** `police-secours` · **moyen** · gratuit · *rond-point, 11 h*
**Titre** — « Le véhicule avance au ralenti et heurte le trottoir »
**Tension** — Véhicule en mouvement, conducteur inconscient, circulation dense.
**Angle distinctif** — Le danger est dynamique, il faut d'abord immobiliser.
**Poids fort** — Immobiliser le véhicule avant toute prise en charge.

#### 080 — `secours-animal-dangereux-voie-publique` ✅
**Thème** `police-secours` · **facile** · gratuit · *lotissement, 17 h*
**Titre** — « Deux chiens sans maître, un enfant a été mordu »
**Tension** — Enfant blessé, animaux non maîtrisés, propriétaire absent.
**Angle distinctif** — Le danger est animal, hors compétence directe du policier.
**Poids fort** — Sécuriser les personnes et faire appel au service compétent.

#### 081 — `secours-intrusion-domicile-occupants-presents` ✅
**Thème** `police-secours` · **difficile** · premium · *maison, 1 h 30*
**Titre** — « Ils se sont enfermés dans la salle de bain et chuchotent au téléphone »
**Tension** — Occupants terrorisés au téléphone, auteur peut-être encore dedans.
**Angle distinctif** — Contact maintenu avec les victimes pendant l'approche.
**Poids fort** — Exploiter le contact téléphonique pour guider l'approche.

#### 082 — `secours-personne-menacant-de-se-blesser-commissariat` ✅
**Thème** `police-secours` · **difficile** · premium · *hall de commissariat, 15 h*
**Titre** — « Il sort une lame et la pose contre son propre bras »
**Tension** — Le danger est dirigé contre lui-même, dans un lieu recevant du public.
**Angle distinctif** — Auto-agression dans les locaux, pas à l'extérieur.
**Poids fort** — Évacuer le public et engager un dialogue sans contrainte immédiate.

#### 083 — `secours-accident-trottinette-pieton` ✅
**Thème** `police-secours` · **facile** · gratuit · *voie piétonne, 18 h 45*
**Titre** — « Le conducteur veut repartir, la victime est assise par terre »
**Tension** — Auteur pressé de partir, victime qui minimise ses douleurs.
**Angle distinctif** — Engin de déplacement personnel, statut souvent mal maîtrisé.
**Poids fort** — Retenir les identités et faire évaluer médicalement la victime.

#### 084 — `secours-appel-malveillant-repete` ✅
**Thème** `police-secours` · **moyen** · premium · *secteur pavillonnaire, 4 h*
**Titre** — « Troisième engagement de la nuit sur la même adresse, personne n'ouvre »
**Tension** — Suspicion de canular, mais l'hypothèse d'une vraie urgence demeure.
**Angle distinctif** — Le doute sur la réalité de l'appel est le cœur du cas.
**Poids fort** — Traiter chaque engagement comme s'il était réel.

#### 085 — `secours-victime-refuse-transport-hospitalier` ✅
**Thème** `police-secours` · **moyen** · premium · *voie publique, 23 h*
**Titre** — « Il saigne mais dit qu'il rentre chez lui à pied »
**Tension** — Refus de soins d'une personne peut-être pas en état de décider.
**Angle distinctif** — Autonomie de la personne contre devoir d'assistance.
**Poids fort** — Faire évaluer la lucidité par les secours plutôt que décider seul.

#### 086 — `secours-differend-chantier-ouvriers` ✅
**Thème** `police-secours` · **facile** · gratuit · *chantier, 10 h*
**Titre** — « Deux équipes s'affrontent, l'une bloque l'accès des camions »
**Tension** — Conflit de travail avec risque physique, hors compétence policière au fond.
**Angle distinctif** — Environnement professionnel, enjeu économique.
**Poids fort** — Faire cesser le trouble sans arbitrer le litige.

#### 087 — `secours-personne-coincee-ascenseur` ✅
**Thème** `police-secours` · **facile** · gratuit · *immeuble de bureaux, 20 h*
**Titre** — « Elle est enfermée depuis quarante minutes et fait une crise d'angoisse »
**Tension** — Situation matériellement bloquée, détresse psychologique croissante.
**Angle distinctif** — Le policier ne peut rien faire techniquement : il rassure et coordonne.
**Poids fort** — Maintenir le contact verbal et faire venir le service technique.

#### 088 — `secours-bagarre-sortie-discotheque` ✅
**Thème** `police-secours` · **moyen** · premium · *discothèque, 4 h 30*
**Titre** — « Le videur maintient un client au sol depuis plusieurs minutes »
**Tension** — Intervention d'un agent privé possiblement excessive, alcool généralisé.
**Angle distinctif** — Milieu festif nocturne, cf. 027 pour la logique agent privé.
**Poids fort** — Faire cesser la contrainte privée et constater l'état du client.

#### 089 — `secours-vehicule-immobilise-voie-rapide` ✅
**Thème** `police-secours` · **moyen** · gratuit · *voie rapide, 7 h 30*
**Titre** — « La famille est descendue et marche sur la bande d'arrêt d'urgence »
**Tension** — Piétons exposés à grande vitesse, enfants présents.
**Angle distinctif** — Le danger vient du comportement des victimes elles-mêmes.
**Poids fort** — Mettre les personnes en sécurité derrière la glissière.

#### 090 — `secours-degat-des-eaux-conflit-acces` ✅
**Thème** `police-secours` · **facile** · gratuit · *copropriété, 21 h*
**Titre** — « L'occupant du dessus refuse d'ouvrir malgré l'inondation »
**Tension** — Dommage matériel qui s'aggrave, refus d'accès, pas d'urgence vitale.
**Angle distinctif** — Limite des pouvoirs face à un dommage purement matériel.
**Poids fort** — Ne pas forcer l'accès sans motif et orienter vers les bons acteurs.

#### 091 — `secours-alerte-personne-disparue-zone-rurale` ✅
**Thème** `police-secours` · **difficile** · premium · *zone rurale boisée, 19 h, hiver*
**Titre** — « Il est parti marcher à 14 h, la nuit tombe dans une heure »
**Tension** — Fenêtre de recherche qui se referme, moyens limités, hypothermie.
**Angle distinctif** — Milieu ouvert rural, contrainte météo et lumière.
**Poids fort** — Organiser et prioriser la zone de recherche sans attendre.

#### 092 — `secours-conflit-avec-service-partenaire` ✅
**Thème** `police-secours` · **moyen** · premium · *domicile, 2 h*
**Titre** — « Les pompiers veulent transporter, la famille s'y oppose physiquement »
**Tension** — Protéger les secours tout en gérant l'opposition familiale.
**Angle distinctif** — Le policier intervient au profit d'un service partenaire.
**Poids fort** — Protéger les intervenants et rétablir les conditions du soin.

#### 093 — `secours-personne-victime-malaise-lieu-culte` ✅
**Thème** `police-secours` · **facile** · gratuit · *lieu de culte, 11 h 30, office*
**Titre** — « Une centaine de fidèles, un homme s'effondre au fond »
**Tension** — Urgence médicale dans un lieu sensible, en pleine cérémonie.
**Angle distinctif** — Respect du lieu et de la pratique pendant l'intervention.
**Poids fort** — Intervenir efficacement en respectant le cadre du lieu.

#### 094 — `secours-vol-a-l-arrache-poursuite` ✅
**Thème** `police-secours` · **moyen** · premium · *marché, 10 h 45*
**Titre** — « L'auteur s'est engouffré dans les allées bondées »
**Tension** — Poursuite dans une foule dense : risque pour les tiers.
**Angle distinctif** — Décision d'interrompre ou poursuivre en milieu saturé.
**Poids fort** — Renoncer à la poursuite si elle met les tiers en danger.

#### 095 — `secours-incident-train-en-marche` ✅
**Thème** `police-secours` · **difficile** · premium · *train régional, 17 h*
**Titre** — « Le contrôleur signale un individu menaçant en voiture 4 »
**Tension** — Espace mobile et confiné, impossibilité de renfort immédiat.
**Angle distinctif** — Intervention en milieu mobile, coordination avec l'exploitant.
**Poids fort** — Coordonner l'arrêt en gare plutôt qu'agir en marche.

#### 096 — `secours-personne-agressive-hopital` ✅
**Thème** `police-secours` · **moyen** · premium · *urgences hospitalières, 1 h*
**Titre** — « Il menace le personnel et refuse de quitter la salle d'attente »
**Tension** — Environnement de soins, patient peut-être malade lui-même.
**Angle distinctif** — L'agressivité peut être un symptôme, pas une infraction simple.
**Poids fort** — Solliciter l'avis médical avant de traiter comme un trouble.

#### 097 — `secours-appel-pour-cris-erreur-adresse` ✅
**Thème** `police-secours` · **facile** · gratuit · *immeuble, 22 h 40*
**Titre** — « Personne ne crie ici, vous vous êtes trompés d'étage »
**Tension** — Localiser l'origine réelle sans perdre de temps ni forcer chez des tiers.
**Angle distinctif** — L'information initiale est fausse ou imprécise.
**Poids fort** — Persévérer méthodiquement au lieu de clore l'intervention.

#### 098 — `secours-effondrement-partiel-batiment` ✅
**Thème** `police-secours` · **expert** · premium · *immeuble ancien, 6 h 45*
**Titre** — « Un balcon s'est détaché, la façade se fissure »
**Tension** — Nombre de victimes inconnu, risque de sur-effondrement, riverains à évacuer.
**Angle distinctif** — Événement de grande ampleur, multi-services.
**Poids fort** — Périmètre large et évacuation avant toute recherche de victimes.

---

## BLOC E — VIOLENCES INTRAFAMILIALES ET PROTECTION DES VICTIMES (099 → 128) · 30 cas

> Thème `violences-conjugales`. Bloc à forte sensibilité. Éviter absolument le
> schéma répétitif « intervention nocturne + victime qui refuse de porter
> plainte » : il est déjà couvert par 021 et 022. Chaque cas doit porter une
> problématique distincte.

#### 099 — `vif-auteur-encore-present-refus-de-sortir` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *appartement, 21 h*
**Titre** — « Il dit qu'il est chez lui et qu'il ne bougera pas »
**Tension** — Éviction nécessaire mais contestée, victime dans la même pièce.
**Angle distinctif** — Porte sur l'éviction de l'auteur, pas sur la plainte.
**Poids fort** — Séparer physiquement les parties avant toute discussion.

#### 100 — `vif-violation-interdiction-de-contact` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *parking de supermarché, 16 h*
**Titre** — « Il l'attend devant sa voiture alors qu'une mesure l'interdit »
**Tension** — Mesure judiciaire violée, auteur qui se dit là « par hasard ».
**Angle distinctif** — Existence d'une décision de justice préalable.
**Poids fort** — Vérifier la mesure et agir sans se laisser convaincre.

#### 101 — `vif-violences-psychologiques-sans-trace` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *commissariat, 14 h*
**Titre** — « Il ne m'a jamais touchée, c'est pire que ça »
**Tension** — Aucune trace physique, difficulté à qualifier et à documenter.
**Angle distinctif** — Absence totale d'élément matériel visible.
**Poids fort** — Recueillir des faits précis et datés plutôt que des ressentis.

#### 102 — `vif-emprise-victime-defend-son-conjoint` ✅
**Thème** `violences-conjugales` · **expert** · premium · *domicile, 19 h*
**Titre** — « Elle vous reproche d'être venus et prend sa défense »
**Tension** — La victime se retourne contre les intervenants ; l'emprise brouille tout.
**Angle distinctif** — Hostilité active de la victime envers la police.
**Poids fort** — Ne pas se braquer et maintenir la porte ouverte pour plus tard.

#### 103 — `vif-enfants-temoins-directs` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *appartement, 20 h 15*
**Titre** — « L'aînée raconte spontanément ce qu'elle a vu »
**Tension** — Parole d'enfant précieuse mais fragile, à ne pas contaminer.
**Angle distinctif** — L'enfant devient source d'information centrale.
**Poids fort** — Recueillir sans interroger ni faire préciser à l'excès.

#### 104 — `vif-violences-economiques` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *commissariat, 11 h*
**Titre** — « Elle n'a pas accès à son propre salaire depuis quatre ans »
**Tension** — Forme de violence peu identifiée comme telle, y compris par la victime.
**Angle distinctif** — Dimension patrimoniale et financière.
**Poids fort** — Identifier le mécanisme de contrôle et le documenter.

#### 105 — `vif-harcelement-post-separation-messages` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *commissariat, 17 h*
**Titre** — « Quatre-vingt-douze messages en deux jours, aucun n'est une menace »
**Tension** — Chaque message pris isolément paraît anodin ; c'est le volume qui compte.
**Angle distinctif** — Répétition sans menace explicite.
**Poids fort** — Documenter la répétition plutôt que chercher un message décisif.

#### 106 — `vif-violences-sur-ascendant` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *pavillon, 15 h*
**Titre** — « Sa mère de 79 ans dit être tombée, il répond à sa place »
**Tension** — Victime dépendante financièrement et matériellement de l'auteur.
**Angle distinctif** — Violence intrafamiliale ascendante, pas conjugale.
**Poids fort** — Isoler la victime de l'auteur pour recueillir sa parole.

#### 107 — `vif-suspicion-maltraitance-infantile-creche` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *crèche, 9 h*
**Titre** — « L'équipe signale des marques répétées depuis trois semaines »
**Tension** — Signalement professionnel, enfant très jeune, parents à recevoir.
**Angle distinctif** — Le signalant est un professionnel tenu par ses propres obligations.
**Poids fort** — Sécuriser l'enfant sans compromettre la suite de l'enquête.

#### 108 — `vif-victime-etrangere-crainte-titre-sejour` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *commissariat, 13 h*
**Titre** — « Il lui a dit qu'elle serait expulsée si elle parlait »
**Tension** — Chantage administratif utilisé comme instrument d'emprise.
**Angle distinctif** — La crainte porte sur le séjour, pas sur les représailles physiques.
**Poids fort** — Dissiper le chantage sans donner d'information inexacte.

#### 109 — `vif-victime-en-situation-de-handicap` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *domicile, 18 h*
**Titre** — « L'aidant est aussi l'auteur présumé »
**Tension** — Retirer l'auteur revient à supprimer l'aide vitale quotidienne.
**Angle distinctif** — Dépendance fonctionnelle totale envers l'auteur.
**Poids fort** — Anticiper la continuité de l'accompagnement avant d'agir.

#### 110 — `vif-signalement-voisin-anonyme-repete` ✅
**Thème** `violences-conjugales` · **moyen** · gratuit · *immeuble, 23 h*
**Titre** — « Quatrième appel du même palier, aucun nom donné »
**Tension** — Le couple nie systématiquement ; les appels continuent.
**Angle distinctif** — Répétition des signalements sans confirmation sur place.
**Poids fort** — Consigner l'historique pour construire un faisceau dans le temps.

#### 111 — `vif-demande-ordonnance-de-protection` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *commissariat, 10 h*
**Titre** — « Elle a entendu parler d'un dispositif mais ne sait pas lequel »
**Tension** — Information à donner sans se substituer aux acteurs compétents.
**Angle distinctif** — Volet informatif et orientation, pas intervention.
**Poids fort** — Orienter précisément sans donner de conseil juridique erroné.

#### 112 — `vif-plainte-retiree-puis-nouveaux-faits` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *commissariat, 16 h*
**Titre** — « Elle avait retiré sa plainte il y a six mois »
**Tension** — Tentation de lassitude professionnelle face à un retour.
**Angle distinctif** — Le retrait antérieur teste l'impartialité du candidat.
**Poids fort** — Accueillir sans reproche implicite ni découragement.

#### 113 — `vif-auteur-porte-plainte-en-premier` ✅
**Thème** `violences-conjugales` · **expert** · premium · *commissariat, 12 h*
**Titre** — « Il arrive avec un certificat médical et accuse sa compagne »
**Tension** — Stratégie d'inversion possible ; ne pas préjuger dans un sens ou l'autre.
**Angle distinctif** — Détermination du victime réel, informations contradictoires.
**Poids fort** — Recueillir les deux versions avec la même rigueur.

#### 114 — `vif-violences-couple-meme-sexe` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *appartement, 22 h*
**Titre** — « On a cru à une bagarre entre colocataires »
**Tension** — Risque de ne pas identifier le caractère conjugal des faits.
**Angle distinctif** — Qualification du lien, source d'erreur fréquente.
**Poids fort** — Établir la nature de la relation sans présupposé.

#### 115 — `vif-enfant-appelle-lui-meme` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *domicile, 21 h 45*
**Titre** — « C'est un garçon de neuf ans qui a composé le numéro »
**Tension** — L'appelant est un enfant ; il faut le protéger de représailles.
**Angle distinctif** — L'enfant est à l'origine de l'intervention.
**Poids fort** — Ne pas exposer l'enfant comme source de l'appel.

#### 116 — `vif-arme-presente-au-domicile` ✅
**Thème** `violences-conjugales` · **expert** · premium · *pavillon rural, 20 h*
**Titre** — « Il possède deux armes de chasse déclarées »
**Tension** — Facteur de risque majeur qui change la nature de l'intervention.
**Angle distinctif** — Présence d'armes légalement détenues.
**Poids fort** — Traiter la question des armes comme une priorité immédiate.

#### 117 — `vif-victime-souhaite-rester-au-domicile` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *appartement, 19 h*
**Titre** — « Elle refuse de partir, c'est chez elle aussi »
**Tension** — Sa demande est légitime mais complique la mise en sécurité.
**Angle distinctif** — Le maintien au domicile est le souhait de la victime.
**Poids fort** — Construire une solution de sécurité compatible avec son choix.

#### 118 — `vif-conflit-garde-enfants-pendant-intervention` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *domicile, 18 h 30*
**Titre** — « Chacun veut partir avec les enfants »
**Tension** — Aucune décision de justice connue ; deux parents opposés sur place.
**Angle distinctif** — Question de garde surgissant dans l'urgence.
**Poids fort** — Ne pas trancher la garde et privilégier la sécurité des enfants.

#### 119 — `vif-victime-mineure-couple-adolescent` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *lycée, 15 h*
**Titre** — « Elle a 16 ans et dit que c'est normal dans un couple »
**Tension** — Banalisation par la victime elle-même, minorité des deux parties.
**Angle distinctif** — Violences au sein d'un couple d'adolescents.
**Poids fort** — Nommer les faits sans stigmatiser ni dramatiser à l'excès.

#### 120 — `vif-strangulation-antecedent` ✅
**Thème** `violences-conjugales` · **expert** · premium · *appartement, 23 h*
**Titre** — « Elle mentionne en passant qu'il l'a déjà serrée à la gorge »
**Tension** — Élément lâché incidemment, mais facteur de risque de premier ordre.
**Angle distinctif** — Repérage d'un signal de danger dans un propos anodin.
**Poids fort** — Identifier et documenter cet antécédent spécifique.

#### 121 — `vif-intervention-domicile-professionnel` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *cabinet médical, 20 h*
**Titre** — « Le couple exerce ensemble, les patients sont partis il y a peu »
**Tension** — Notoriété locale et crainte des conséquences professionnelles.
**Angle distinctif** — Enjeu de réputation professionnelle partagée.
**Poids fort** — Traiter les faits sans considération de statut social.

#### 122 — `vif-refus-de-quitter-les-lieux-par-la-victime` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *domicile, 2 h*
**Titre** — « Elle dit qu'elle partira demain, pas cette nuit »
**Tension** — Départ différé alors que le risque est immédiat.
**Angle distinctif** — Décalage entre le temps de la victime et celui du danger.
**Poids fort** — Évaluer le risque de la nuit même et proposer des solutions concrètes.

#### 123 — `vif-tiers-intervenu-blesse` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *cage d'escalier, 22 h*
**Titre** — « Le voisin s'est interposé et a pris un coup »
**Tension** — Trois personnes à prendre en charge, dont un tiers blessé.
**Angle distinctif** — Un tiers devient victime en s'interposant.
**Poids fort** — Ne pas négliger le tiers au profit du couple.

#### 124 — `vif-suivi-apres-signalement-ecole` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *école élémentaire, 8 h 45*
**Titre** — « La directrice a déjà signalé deux fois, sans retour »
**Tension** — Partenaire découragé par l'absence de suites visibles.
**Angle distinctif** — Relation avec un partenaire institutionnel usé.
**Poids fort** — Restaurer la confiance sans divulguer d'éléments couverts.

#### 125 — `vif-victime-alcoolisee-lors-des-faits` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *domicile, 3 h*
**Titre** — « Il insiste sur le fait qu'elle avait bu »
**Tension** — Tentative de décrédibilisation de la victime par l'auteur.
**Angle distinctif** — L'état de la victime est instrumentalisé.
**Poids fort** — Ne pas laisser l'état de la victime relativiser les faits.

#### 126 — `vif-plainte-par-un-tiers-professionnel-sante` ✅
**Thème** `violences-conjugales` · **moyen** · premium · *commissariat, 14 h 30*
**Titre** — « Le médecin a signalé, la patiente n'est pas au courant »
**Tension** — Signalement sans l'accord de la personne concernée.
**Angle distinctif** — Origine médicale du signalement.
**Poids fort** — Approcher la victime sans la mettre en danger ni la braquer.

#### 127 — `vif-menaces-par-la-famille-de-l-auteur` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *quartier résidentiel, 17 h*
**Titre** — « Depuis la plainte, c'est la belle-famille qui l'attend en bas »
**Tension** — Élargissement du danger au-delà de l'auteur initial.
**Angle distinctif** — Pression collective familiale après la plainte.
**Poids fort** — Prendre en compte l'entourage comme facteur de risque.

#### 128 — `vif-retour-au-domicile-apres-eviction` ✅
**Thème** `violences-conjugales` · **difficile** · premium · *pavillon, 1 h 15*
**Titre** — « Il est revenu récupérer ses affaires, elle a ouvert »
**Tension** — Consentement apparent de la victime à la venue de l'auteur.
**Angle distinctif** — Retour avec l'accord de la victime, malgré la mesure.
**Poids fort** — Faire respecter la mesure malgré l'accord apparent.

---

## BLOC F — MINEURS (129 → 155) · 27 cas ✅ **BLOC COMPLET** (28/28 avec le cas 013)

> Thème `mineurs`. Varier l'âge (3 à 17 ans), le statut (victime, auteur,
> témoin, en danger) et le lieu. Le cas 013 couvre déjà la fugue avec
> révélation : ne pas le redoubler.

#### 129 — `mineurs-enfant-perdu-centre-commercial` ✅
**Thème** `mineurs` · **facile** · gratuit · *centre commercial, 16 h*
**Titre** — « Il a quatre ans et ne sait pas dire son nom de famille »
**Tension** — Identifier les parents sans effrayer l'enfant ni le confier au mauvais adulte.
**Angle distinctif** — Très jeune âge, communication limitée.
**Poids fort** — Vérifier le lien avant toute remise.

#### 130 — `mineurs-harcelement-scolaire-signale-parents` ✅
**Thème** `mineurs` · **moyen** · premium · *commissariat, 17 h 30*
**Titre** — « Les parents veulent des noms et menacent d'agir eux-mêmes »
**Tension** — Colère parentale légitime pouvant déboucher sur un passage à l'acte.
**Angle distinctif** — Le risque vient des parents de la victime.
**Poids fort** — Désamorcer l'intention parentale de se faire justice.

#### 131 — `mineurs-diffusion-images-intimes-entre-eleves` ✅
**Thème** `mineurs` · **difficile** · premium · *collège, 11 h*
**Titre** — « La photo a circulé dans trois classes en une matinée »
**Tension** — Victime et auteurs sont tous mineurs ; propagation en cours.
**Angle distinctif** — Auteurs mineurs multiples, urgence de l'arrêt de diffusion.
**Poids fort** — Faire cesser la diffusion et traiter les mineurs auteurs avec discernement.

#### 132 — `mineurs-racket-abords-etablissement` ✅
**Thème** `mineurs` · **moyen** · premium · *abords de collège, 16 h 45*
**Titre** — « Il dit avoir prêté son téléphone, ses mains tremblent »
**Tension** — Victime qui minimise par peur de représailles quotidiennes.
**Angle distinctif** — Contrainte de proximité : ils se reverront demain.
**Poids fort** — Sécuriser la victime dans la durée, pas seulement le jour même.

#### 133 — `mineurs-degradations-groupe-adolescents` ✅
**Thème** `mineurs` · **facile** · gratuit · *aire de jeux, 19 h*
**Titre** — « Ils sont cinq, aucun ne reconnaît avoir tenu la bombe de peinture »
**Tension** — Responsabilité individuelle diluée dans le groupe.
**Angle distinctif** — Mineurs auteurs, faits matériels sans victime physique.
**Poids fort** — Séparer les mineurs et individualiser les responsabilités.

#### 134 — `mineurs-consommation-stupefiants-parc` ✅
**Thème** `mineurs` · **moyen** · premium · *parc public, 18 h*
**Titre** — « Le plus jeune a treize ans et ne tient pas debout »
**Tension** — Urgence sanitaire pour un très jeune mineur, parents à prévenir.
**Angle distinctif** — Volet sanitaire prioritaire sur le volet répressif.
**Poids fort** — Faire évaluer médicalement avant toute autre démarche.

#### 135 — `mineurs-refus-de-rentrer-au-domicile` ✅
**Thème** `mineurs` · **difficile** · premium · *commissariat, 23 h*
**Titre** — « Il a quinze ans et dit qu'il dormira dehors plutôt que d'y retourner »
**Tension** — Refus catégorique sans révélation explicite de danger.
**Angle distinctif** — Absence de révélation, contrairement à 013.
**Poids fort** — Ne pas contraindre au retour sans avoir cherché à comprendre.

#### 136 — `mineurs-enfant-enferme-vehicule-soleil` ✅
**Thème** `mineurs` · **facile** · gratuit · *parking, 14 h, 34 °C*
**Titre** — « Le nourrisson est rouge et ne pleure plus »
**Tension** — Urgence vitale à très court terme ; décision de bris de vitre.
**Angle distinctif** — Urgence physiologique immédiate, décision en secondes.
**Poids fort** — Agir sans attendre et justifier la nécessité.

#### 137 — `mineurs-suspicion-exploitation-sexuelle` ✅
**Thème** `mineurs` · **expert** · premium · *hôtel, 2 h*
**Titre** — « Elle dit avoir dix-neuf ans mais n'a aucun document »
**Tension** — Minorité probable, présence d'un adulte se disant « ami de la famille ».
**Angle distinctif** — Détermination de la minorité et repérage d'un réseau.
**Poids fort** — Traiter la personne comme mineure tant que le doute subsiste.

#### 138 — `mineurs-adolescent-menacant-etablissement` ✅
**Thème** `mineurs` · **difficile** · premium · *lycée, 13 h 30*
**Titre** — « Il a écrit un message inquiétant dans le groupe de sa classe »
**Tension** — Évaluer la crédibilité d'une menace émanant d'un mineur.
**Angle distinctif** — Menace verbale sans acte, appréciation du passage à l'acte.
**Poids fort** — Prendre la menace au sérieux sans criminaliser un adolescent.

#### 139 — `mineurs-temoin-infraction-refuse-parler` ✅
**Thème** `mineurs` · **moyen** · premium · *quartier, 18 h*
**Titre** — « Il a tout vu mais dit qu'il ne veut pas d'histoires »
**Tension** — Témoignage précieux, crainte de représailles dans le quartier.
**Angle distinctif** — Mineur témoin, ni victime ni auteur.
**Poids fort** — Ne pas exposer le mineur en le sollicitant publiquement.

#### 140 — `mineurs-conflit-familial-adolescent-parents` ✅
**Thème** `mineurs` · **facile** · gratuit · *domicile, 20 h*
**Titre** — « Les parents demandent qu'on lui fasse peur »
**Tension** — Attente parentale d'un rôle éducatif qui n'est pas le nôtre.
**Angle distinctif** — Instrumentalisation de la police par les parents.
**Poids fort** — Refuser le rôle demandé tout en apaisant la situation.

#### 141 — `mineurs-isole-etranger-sans-referent` ✅
**Thème** `mineurs` · **difficile** · premium · *gare, 6 h*
**Titre** — « Il est arrivé seul et ne connaît personne ici »
**Tension** — Barrière linguistique, âge incertain, mise à l'abri urgente.
**Angle distinctif** — Mineur isolé, cumul de vulnérabilités.
**Poids fort** — Mise à l'abri immédiate et saisine des services compétents.

#### 142 — `mineurs-vol-en-reunion-premiere-fois` ✅
**Thème** `mineurs` · **moyen** · gratuit · *supérette, 17 h*
**Titre** — « Le plus âgé a seize ans, les deux autres douze »
**Tension** — Écart d'âge et d'implication entre les mineurs.
**Angle distinctif** — Différenciation du traitement selon l'âge et le rôle.
**Poids fort** — Individualiser au lieu de traiter le groupe uniformément.

#### 143 — `mineurs-victime-violences-par-un-majeur` ✅
**Thème** `mineurs` · **difficile** · premium · *commissariat, 15 h*
**Titre** — « L'entraîneur, c'est aussi le voisin et l'ami de la famille »
**Tension** — Proximité de l'auteur avec la famille, risque de non-croyance.
**Angle distinctif** — Auteur inséré dans l'entourage familial de confiance.
**Poids fort** — Croire la parole du mineur et éviter la confrontation familiale.

#### 144 — `mineurs-disparition-inquietante-adolescente` ✅
**Thème** `mineurs` · **difficile** · premium · *commissariat, 22 h*
**Titre** — « Elle a laissé son téléphone et son sac dans sa chambre »
**Tension** — Éléments qui excluent la fugue simple ; chaque heure compte.
**Angle distinctif** — Indices matériels d'inquiétude, distinct de 039.
**Poids fort** — Qualifier l'inquiétude et déclencher sans délai.

#### 145 — `mineurs-cyberharcelement-auteur-identifie-mineur` ✅
**Thème** `mineurs` · **moyen** · premium · *commissariat, 16 h*
**Titre** — « L'auteur est le meilleur ami de la victime depuis six ans »
**Tension** — Deux familles à recevoir, lien ancien entre les enfants.
**Angle distinctif** — Traitement du mineur auteur, cf. 023 côté victime.
**Poids fort** — Traiter l'auteur mineur avec discernement éducatif.

#### 146 — `mineurs-enfant-livre-a-lui-meme-domicile` ✅
**Thème** `mineurs` · **moyen** · premium · *appartement, 23 h 30*
**Titre** — « Il garde son frère de trois ans depuis vendredi »
**Tension** — Aucun adulte joignable, enfants en danger sans violence apparente.
**Angle distinctif** — Danger par carence, pas par acte.
**Poids fort** — Caractériser le danger et saisir les services compétents.

#### 147 — `mineurs-fugue-repetee-etablissement-placement` ✅
**Thème** `mineurs` · **moyen** · premium · *voie publique, 1 h*
**Titre** — « C'est la sixième fois ce mois-ci »
**Tension** — Lassitude possible face à la répétition ; le risque reste entier.
**Angle distinctif** — Répétition et relation avec l'institution de placement.
**Poids fort** — Traiter chaque fugue sans banalisation.

#### 148 — `mineurs-agression-entre-eleves-video` ✅
**Thème** `mineurs` · **difficile** · premium · *abords de collège, 12 h*
**Titre** — « La scène a été filmée et postée avant même votre arrivée »
**Tension** — Diffusion en cours qui aggrave le préjudice de la victime.
**Angle distinctif** — Cumul violence physique et diffusion numérique.
**Poids fort** — Traiter l'arrêt de la diffusion comme une urgence.

#### 149 — `mineurs-suspicion-mariage-force` ✅
**Thème** `mineurs` · **expert** · premium · *commissariat, 10 h*
**Titre** — « Sa cousine vous alerte, le départ est prévu dans huit jours »
**Tension** — Information indirecte, délai contraint, famille à ne pas alerter.
**Angle distinctif** — Danger futur et non actuel, discrétion vitale.
**Poids fort** — Ne pas alerter la famille et saisir en urgence.

#### 150 — `mineurs-conduite-sans-permis-scooter` ✅
**Thème** `mineurs` · **facile** · gratuit · *route départementale, 15 h*
**Titre** — « Il a treize ans et le scooter appartient à son père »
**Tension** — Responsabilité du représentant légal, danger réel pour l'enfant.
**Angle distinctif** — Volet routier appliqué à un mineur, responsabilité parentale.
**Poids fort** — Sécuriser l'enfant et impliquer le représentant légal.

#### 151 — `mineurs-enfant-present-lors-interpellation-parent` ✅
**Thème** `mineurs` · **difficile** · premium · *domicile, 6 h 30*
**Titre** — « Sa fille de sept ans est réveillée et regarde depuis le couloir »
**Tension** — Interpellation nécessaire, enfant témoin de l'arrestation de son parent.
**Angle distinctif** — L'enfant n'est ni victime ni auteur, mais spectateur.
**Poids fort** — Organiser la prise en charge de l'enfant avant d'emmener le parent.

#### 152 — `mineurs-signalement-anonyme-ecole-buissonniere` ✅
**Thème** `mineurs` · **facile** · gratuit · *centre-ville, 10 h 30*
**Titre** — « Trois collégiens en ville un mardi matin »
**Tension** — Fait bénin en apparence, pouvant masquer une situation plus grave.
**Angle distinctif** — Situation banale servant de porte d'entrée au repérage.
**Poids fort** — Ne pas se contenter du constat d'absence scolaire.

#### 153 — `mineurs-victime-refuse-examen-medico-legal` ✅
**Thème** `mineurs` · **difficile** · premium · *commissariat, 18 h*
**Titre** — « Elle a quinze ans et refuse catégoriquement l'examen »
**Tension** — Nécessité de l'examen contre refus et pudeur de l'adolescente.
**Angle distinctif** — Refus d'un acte médico-légal par une mineure.
**Poids fort** — Expliquer sans contraindre et associer les bons interlocuteurs.

#### 154 — `mineurs-groupe-jeunes-occupation-hall` ✅
**Thème** `mineurs` · **facile** · gratuit · *hall d'immeuble, 21 h*
**Titre** — « Les habitants ne passent plus, les jeunes disent être chez eux »
**Tension** — Nuisance réelle, mineurs qui habitent effectivement l'immeuble.
**Angle distinctif** — Tension d'usage d'un espace commun.
**Poids fort** — Rétablir l'usage sans stigmatiser les jeunes du quartier.

#### 155 — `mineurs-auteur-mineur-victime-majeure-vulnerable` ✅
**Thème** `mineurs` · **difficile** · premium · *rue, 17 h*
**Titre** — « Ils ont filmé l'homme handicapé qu'ils bousculaient »
**Tension** — Auteurs mineurs, victime majeure vulnérable, dimension humiliante.
**Angle distinctif** — Inversion du schéma habituel de vulnérabilité.
**Poids fort** — Prendre en charge la victime vulnérable et responsabiliser les mineurs.

---

## BLOC G — SÉCURITÉ ROUTIÈRE (156 → 185) · 30 cas ✅ **BLOC COMPLET** (32/32)

> Thème `circulation`. Varier les usagers (auto, deux-roues, cycle, engin de
> déplacement, poids lourd, piéton), les moments et les configurations. Les cas
> 007 et 008 couvrent déjà stupéfiants au volant et délit de fuite avec alcool.

#### 156 — `routier-accident-materiel-desaccord-constat` ✅
**Thème** `circulation` · **facile** · gratuit · *carrefour urbain, 9 h*
**Titre** — « Chacun affirme que l'autre a grillé le feu »
**Tension** — Aucun blessé, aucun témoin, deux versions inconciliables.
**Angle distinctif** — Cas purement matériel, ressort méthodologique.
**Poids fort** — Recueillir des constatations objectives sans arbitrer les torts.

#### 157 — `routier-refus-obtemperer-vehicule-lent` ✅
**Thème** `circulation` · **difficile** · premium · *avenue urbaine, 15 h*
**Titre** — « Il continue à trente à l'heure sans s'arrêter, vitres fermées »
**Tension** — Refus passif, sans mise en danger immédiate ; tentation d'escalade.
**Angle distinctif** — Refus non violent, distinct de 019.
**Poids fort** — Proportionnalité et refus de l'escalade inutile.

#### 158 — `routier-conducteur-sans-permis-jamais-obtenu` ✅
**Thème** `circulation` · **moyen** · gratuit · *contrôle statique, 11 h*
**Titre** — « Il conduit depuis vingt ans et n'a jamais passé l'examen »
**Tension** — Ancienneté de la situation, véhicule à immobiliser, personne à raccompagner.
**Angle distinctif** — Absence totale de titre, pas une suspension.
**Poids fort** — Gérer l'immobilisation et la situation matérielle du conducteur.

#### 159 — `routier-defaut-assurance-apres-accident` ✅
**Thème** `circulation` · **moyen** · premium · *rue résidentielle, 17 h*
**Titre** — « Il découvre en cherchant ses papiers qu'il n'est plus assuré »
**Tension** — Victime lésée dans ses droits, auteur de bonne foi apparente.
**Angle distinctif** — Conséquences civiles majeures pour la victime.
**Poids fort** — Informer la victime de ses recours et constater précisément.

#### 160 — `routier-vehicule-signale-vole` ✅
**Thème** `circulation` · **difficile** · premium · *périphérique, 23 h*
**Titre** — « La plaque correspond à un véhicule volé il y a trois jours »
**Tension** — Conducteur peut-être acheteur de bonne foi ou auteur ; approche prudente.
**Angle distinctif** — Incertitude sur la qualité du conducteur.
**Poids fort** — Sécuriser le contrôle avant toute qualification.

#### 161 — `routier-conducteur-agressif-controle` ✅
**Thème** `circulation` · **moyen** · gratuit · *bord de route, 14 h*
**Titre** — « Il descend du véhicule en criant avant même votre approche »
**Tension** — Rupture du cadre du contrôle, danger sur chaussée ouverte.
**Angle distinctif** — Agressivité au contrôle routier, avec risque circulation.
**Poids fort** — Reprendre le contrôle de la situation et sécuriser la chaussée.

#### 162 — `routier-controle-de-nuit-vehicule-suspect` ✅
**Thème** `circulation` · **moyen** · premium · *zone industrielle, 3 h*
**Titre** — « Trois occupants, coffre chargé de câbles de cuivre »
**Tension** — Éléments évocateurs sans certitude ; effectif réduit face à trois personnes.
**Angle distinctif** — Contrôle routier débouchant sur une autre problématique.
**Poids fort** — Sécuriser le contrôle avant d'explorer la piste des faits.

#### 163 — `routier-enfant-sans-dispositif-retenue` ✅
**Thème** `circulation` · **facile** · gratuit · *rue, 8 h 15*
**Titre** — « Le bébé est sur les genoux de sa mère à l'avant »
**Tension** — Danger vital pour l'enfant, parents qui se justifient par l'urgence.
**Angle distinctif** — Protection d'un enfant dans un contexte routier banal.
**Poids fort** — Ne pas laisser repartir dans les mêmes conditions.

#### 164 — `routier-conducteur-age-desoriente-au-volant` ✅
**Thème** `circulation` · **difficile** · premium · *rond-point, 16 h*
**Titre** — « Il tourne depuis un quart d'heure et ne sait plus où il va »
**Tension** — Aptitude à conduire en cause, personne autonome et digne.
**Angle distinctif** — Croisement circulation et vulnérabilité, cf. 026.
**Poids fort** — Empêcher la reprise du volant avec ménagement.

#### 165 — `routier-rodeo-motorise-quartier` ✅
**Thème** `circulation` · **difficile** · premium · *quartier résidentiel, 20 h*
**Titre** — « Une dizaine de deux-roues, des habitants filment aux balcons »
**Tension** — Poursuite dangereuse pour tous ; pression des riverains excédés.
**Angle distinctif** — Phénomène collectif, exposition publique.
**Poids fort** — Renoncer à la poursuite au profit de l'identification différée.

#### 166 — `routier-cycliste-blesse-portiere` ✅
**Thème** `circulation` · **moyen** · gratuit · *piste cyclable, 18 h 30*
**Titre** — « La portière s'est ouverte au moment où il arrivait »
**Tension** — Blessé au sol, responsabilité discutée, circulation à sécuriser.
**Angle distinctif** — Usager vulnérable et configuration spécifique.
**Poids fort** — Secours et constatations avant discussion de responsabilité.

#### 167 — `routier-deux-roues-sans-casque-fuite` ✅
**Thème** `circulation` · **moyen** · premium · *boulevard, 19 h*
**Titre** — « Il accélère dès qu'il vous voit, sans casque, passager derrière »
**Tension** — Risque majeur pour le passager si la poursuite continue.
**Angle distinctif** — Présence d'un passager non protégé.
**Poids fort** — Arbitrer la poursuite au regard du risque pour le passager.

#### 168 — `routier-stationnement-genant-intervention` ✅
**Thème** `circulation` · **facile** · gratuit · *rue étroite, 21 h*
**Titre** — « Le camion de pompiers ne passe pas, le propriétaire est introuvable »
**Tension** — Urgence en cours bloquée par un obstacle matériel.
**Angle distinctif** — Le stationnement empêche une autre intervention.
**Poids fort** — Débloquer l'accès sans délai et tracer la décision.

#### 169 — `routier-transport-scolaire-incident` ✅
**Thème** `circulation` · **moyen** · premium · *arrêt de car scolaire, 7 h 45*
**Titre** — « Un véhicule a doublé le car à l'arrêt, les enfants descendaient »
**Tension** — Danger majeur évité de peu, nombreux témoins mineurs.
**Angle distinctif** — Contexte scolaire et risque collectif.
**Poids fort** — Identifier le véhicule et rassurer les enfants témoins.

#### 170 — `routier-accident-poids-lourd-carburant` ✅
**Thème** `circulation` · **difficile** · premium · *rocade, 5 h 30*
**Titre** — « Le réservoir fuit et le conducteur est coincé »
**Tension** — Risque d'inflammation, victime incarcérée, circulation à couper.
**Angle distinctif** — Risque technologique associé à l'accident.
**Poids fort** — Périmètre et coupure de circulation avant approche.

#### 171 — `routier-conducteur-usage-telephone-conteste` ✅
**Thème** `circulation` · **facile** · gratuit · *feu tricolore, 12 h*
**Titre** — « Il affirme qu'il consultait son GPS posé sur ses genoux »
**Tension** — Contestation immédiate, tentation d'entrer dans le débat.
**Angle distinctif** — Cas simple centré sur la posture face à la contestation.
**Poids fort** — Rester factuel et courtois face à la contestation.

#### 172 — `routier-alcoolemie-refus-de-souffler` ✅
**Thème** `circulation` · **moyen** · premium · *sortie de bar, 1 h 45*
**Titre** — « Il tend les poignets et dit qu'il ne soufflera pas »
**Tension** — Refus assumé, coopération apparente par ailleurs.
**Angle distinctif** — Refus de se soumettre, distinct de 007 et 008.
**Poids fort** — Expliquer les conséquences du refus sans menacer.

#### 173 — `routier-vehicule-abandonne-voie-publique` ✅
**Thème** `circulation` · **facile** · gratuit · *rue, 10 h*
**Titre** — « La voiture n'a pas bougé depuis six semaines selon les riverains »
**Tension** — Situation ancienne, procédure administrative, riverains impatients.
**Angle distinctif** — Absence d'urgence, dimension administrative.
**Poids fort** — Appliquer la procédure adaptée sans improviser.

#### 174 — `routier-course-poursuite-decision-interruption` ✅
**Thème** `circulation` · **expert** · premium · *traversée de bourg, 18 h*
**Titre** — « Il traverse le centre-bourg à l'heure de la sortie d'école »
**Tension** — Poursuivre devient plus dangereux que renoncer.
**Angle distinctif** — Décision d'interruption comme cœur du cas.
**Poids fort** — Décider d'interrompre et le justifier.

#### 175 — `routier-piéton-renverse-passage-clouté` ✅
**Thème** `circulation` · **moyen** · gratuit · *passage piéton, 8 h*
**Titre** — « Le conducteur est resté mais dit qu'elle a traversé au rouge »
**Tension** — Victime au sol, version du conducteur à vérifier objectivement.
**Angle distinctif** — Conflit sur la priorité, victime piétonne.
**Poids fort** — Constater objectivement, notamment la signalisation.

#### 176 — `routier-controle-vehicule-familial-surcharge` ✅
**Thème** `circulation` · **facile** · gratuit · *route de vacances, 11 h*
**Titre** — « Sept personnes dans un véhicule de cinq places »
**Tension** — Danger réel, famille en déplacement sans solution immédiate.
**Angle distinctif** — Infraction créant un problème matériel à résoudre.
**Poids fort** — Trouver une solution avant de laisser repartir.

#### 177 — `routier-accident-implique-un-collegue` ✅
**Thème** `circulation` · **difficile** · premium · *carrefour, 14 h*
**Titre** — « Le conducteur du véhicule est un policier de votre commissariat »
**Tension** — Impartialité mise à l'épreuve par le lien professionnel.
**Angle distinctif** — Conflit d'intérêts en matière routière.
**Poids fort** — Se déporter ou faire intervenir un autre équipage.

#### 178 — `routier-trottinette-electrique-debridee` ✅
**Thème** `circulation` · **facile** · gratuit · *voie urbaine, 17 h 30*
**Titre** — « L'engin dépasse largement la vitesse autorisée »
**Tension** — Usager persuadé d'être dans son droit, cadre mal connu.
**Angle distinctif** — Engin de déplacement personnel modifié.
**Poids fort** — Expliquer clairement le cadre applicable.

#### 179 — `routier-conducteur-fuite-apres-controle-alcool` ✅
**Thème** `circulation` · **difficile** · premium · *contrôle routier, 2 h*
**Titre** — « Il remonte en voiture pendant que vous préparez l'éthylotest »
**Tension** — Fuite depuis un contrôle en cours, danger immédiat.
**Angle distinctif** — Fuite pendant l'acte, pas après un accident.
**Poids fort** — Signalement immédiat plutôt que poursuite hasardeuse.

#### 180 — `routier-manifestation-blocage-circulation` ✅
**Thème** `circulation` · **moyen** · premium · *rond-point, 7 h*
**Titre** — « Des tracteurs bloquent l'accès à la zone commerciale »
**Tension** — Croisement ordre public et circulation, tension sociale.
**Angle distinctif** — Blocage revendicatif, cf. bloc ordre public.
**Poids fort** — Maintenir le dialogue et préserver les accès de secours.

#### 181 — `routier-vehicule-force-barrage-inondation` ✅
**Thème** `circulation` · **moyen** · premium · *route submergée, 19 h*
**Titre** — « Il déplace le panneau pour passer quand même »
**Tension** — Mise en danger volontaire, risque pour les secours ensuite.
**Angle distinctif** — Franchissement délibéré d'un dispositif de sécurité.
**Poids fort** — Empêcher le passage et expliquer le risque induit.

#### 182 — `routier-accident-sans-tiers-conducteur-fuit-a-pied` ✅
**Thème** `circulation` · **moyen** · premium · *fossé, 4 h*
**Titre** — « Le véhicule est encastré, personne à bord, le moteur est chaud »
**Tension** — Conducteur peut-être blessé et errant dans la nuit.
**Angle distinctif** — Recherche d'une personne possiblement blessée.
**Poids fort** — Rechercher le conducteur avant de traiter l'infraction.

#### 183 — `routier-differend-place-handicape` ✅
**Thème** `circulation` · **facile** · gratuit · *parking de supermarché, 15 h*
**Titre** — « La carte appartient à sa mère, restée à la maison »
**Tension** — Usage détourné d'un droit, riverain indigné sur place.
**Angle distinctif** — Dimension de solidarité et d'indignation citoyenne.
**Poids fort** — Traiter les faits sans céder à la pression du témoin.

#### 184 — `routier-defaut-controle-technique-vehicule-dangereux` ✅
**Thème** `circulation` · **moyen** · gratuit · *contrôle, 16 h*
**Titre** — « Les plaquettes crissent et un pneu est lisse sur toute la largeur »
**Tension** — Véhicule dangereux, conducteur qui doit récupérer ses enfants.
**Angle distinctif** — État technique du véhicule comme danger direct.
**Poids fort** — Immobiliser malgré les contraintes personnelles invoquées.

#### 185 — `routier-conducteur-en-detresse-psychologique` ✅
**Thème** `circulation` · **difficile** · premium · *aire d'autoroute, 22 h*
**Titre** — « Il conduit depuis onze heures et vous dit qu'il ne veut plus rentrer »
**Tension** — Contrôle routier qui révèle une détresse ; danger pour lui et autrui.
**Angle distinctif** — Détresse découverte à l'occasion d'un contrôle banal.
**Poids fort** — Traiter la détresse avant l'aspect routier.

---

## BLOC H — STUPÉFIANTS (186 → 207) · 22 cas ✅ **BLOC COMPLET**

> Thème `stupefiants`. Thème vide à ce jour. Éviter la redondance avec 007
> (contrôle routier + découverte). Varier les rôles : usager, revendeur,
> logeur, mineur, témoin, riverain.

#### 186 — `stups-usage-simple-espace-public` ✅
**Thème** `stupefiants` · **facile** · gratuit · *square, 18 h*
**Titre** — « Deux jeunes majeurs, une odeur reconnaissable, aucune agressivité »
**Tension** — Réponse graduée à une infraction constatée sans trouble associé.
**Angle distinctif** — Usage simple, ressort de discernement.
**Poids fort** — Proportionner la réponse au fait constaté.

#### 187 — `stups-decouverte-lors-palpation-securite` ✅
**Thème** `stupefiants` · **moyen** · premium · *voie publique, 21 h*
**Titre** — « Le sachet tombe pendant que vous vérifiez ses poches »
**Tension** — Découverte incidente lors d'un acte fait pour un autre motif.
**Angle distinctif** — Le cadre initial n'était pas la recherche de stupéfiants.
**Poids fort** — Articuler correctement le cadre de la découverte.

#### 188 — `stups-point-de-deal-hall-immeuble` ✅
**Thème** `stupefiants` · **difficile** · premium · *hall d'immeuble, 20 h*
**Titre** — « Les habitants ne passent plus par l'entrée principale »
**Tension** — Phénomène installé, riverains exposés à des représailles.
**Angle distinctif** — Situation ancrée dans la durée, enjeu de tranquillité.
**Poids fort** — Protéger les riverains signalants de toute exposition.

#### 189 — `stups-transaction-observee-en-patrouille` ✅
**Thème** `stupefiants` · **moyen** · premium · *rue commerçante, 17 h*
**Titre** — « L'échange a duré trois secondes, vous étiez à trente mètres »
**Tension** — Certitude subjective, éléments objectifs limités.
**Angle distinctif** — Qualité de l'observation comme enjeu central.
**Poids fort** — Décrire précisément ce qui a été vu, sans extrapoler.

#### 190 — `stups-mineur-utilise-comme-guetteur` ✅
**Thème** `stupefiants` · **difficile** · premium · *pied d'immeuble, 19 h*
**Titre** — « Il a douze ans et dit qu'il joue simplement dehors »
**Tension** — Mineur à la fois impliqué et victime d'une exploitation.
**Angle distinctif** — Double statut du mineur.
**Poids fort** — Traiter le mineur comme une personne en danger.

#### 191 — `stups-appartement-servant-au-stockage` ✅
**Thème** `stupefiants` · **difficile** · premium · *appartement, 11 h*
**Titre** — « La locataire dit qu'on lui a pris son logement de force »
**Tension** — Occupante possiblement victime d'un squat contraint.
**Angle distinctif** — L'occupante n'est peut-être pas complice.
**Poids fort** — Évaluer sa qualité réelle avant toute qualification.

#### 192 — `stups-vehicule-transport-decouverte-fortuite` ✅
**Thème** `stupefiants` · **moyen** · premium · *aire de repos, 23 h*
**Titre** — « Il transporte pour un tiers et dit ignorer le contenu »
**Tension** — Connaissance du contenu difficile à établir immédiatement.
**Angle distinctif** — Question de la connaissance, pas de la découverte.
**Poids fort** — Recueillir précisément les circonstances du transport.

#### 193 — `stups-personne-avale-produit` ✅
**Thème** `stupefiants` · **expert** · premium · *contrôle, 22 h*
**Titre** — « Il porte la main à sa bouche et déglutit »
**Tension** — Urgence vitale immédiate qui prime sur tout aspect procédural.
**Angle distinctif** — Risque vital lié à l'ingestion.
**Poids fort** — Secours médicaux immédiats avant toute autre considération.

#### 194 — `stups-signalement-par-un-bailleur` ✅
**Thème** `stupefiants` · **moyen** · premium · *commissariat, 10 h*
**Titre** — « Le bailleur apporte une liste d'appartements et de noms »
**Tension** — Information utile mais fournie hors de tout cadre, avec ses propres intérêts.
**Angle distinctif** — Source institutionnelle privée intéressée.
**Poids fort** — Recueillir sans valider ni exploiter en dehors du cadre.

#### 195 — `stups-trafic-abords-etablissement-scolaire` ✅
**Thème** `stupefiants` · **difficile** · premium · *abords de lycée, 16 h 30*
**Titre** — « La revente se fait à la sortie, sous les yeux des surveillants »
**Tension** — Proximité scolaire aggravante, nombreux mineurs présents.
**Angle distinctif** — Contexte scolaire, cf. 195 vs 188 (immeuble).
**Poids fort** — Intervenir sans exposer les élèves ni créer un mouvement.

#### 196 — `stups-decouverte-materiel-conditionnement` ✅
**Thème** `stupefiants` · **moyen** · premium · *domicile, 9 h*
**Titre** — « Balance, sachets et gants, mais aucun produit »
**Tension** — Indices matériels sans substance ; qualification délicate.
**Angle distinctif** — Absence du produit lui-même.
**Poids fort** — Décrire et saisir méthodiquement sans surqualifier.

#### 197 — `stups-intervention-soiree-privee` ✅
**Thème** `stupefiants` · **moyen** · premium · *appartement, 2 h*
**Titre** — « Une trentaine d'invités, produits visibles sur la table basse »
**Tension** — Effectif réduit face à un groupe nombreux, domicile privé.
**Angle distinctif** — Cadre du domicile et nombre de personnes.
**Poids fort** — Ne pas s'engager au-delà de ses moyens ; demander du renfort.

#### 198 — `stups-usager-en-detresse-overdose` ✅
**Thème** `stupefiants` · **difficile** · premium · *toilettes de gare, 13 h*
**Titre** — « Ses lèvres sont bleues, ses amis ont fui »
**Tension** — Urgence vitale, témoins partis, produits inconnus.
**Angle distinctif** — Volet exclusivement sanitaire au départ.
**Poids fort** — Secours immédiats et recherche d'informations sur le produit.

#### 199 — `stups-produit-inconnu-decouvert` ✅
**Thème** `stupefiants` · **moyen** · premium · *voie publique, 15 h*
**Titre** — « Une poudre dans un flacon sans étiquette »
**Tension** — Nature inconnue, risque à la manipulation.
**Angle distinctif** — Incertitude sur la nature et la dangerosité.
**Poids fort** — Ne pas manipuler et faire appel aux moyens adaptés.

#### 200 — `stups-parent-signale-son-propre-enfant` ✅
**Thème** `stupefiants` · **difficile** · premium · *commissariat, 18 h*
**Titre** — « Elle apporte ce qu'elle a trouvé dans la chambre de son fils »
**Tension** — Démarche parentale de détresse, attente d'un rôle éducatif.
**Angle distinctif** — Le signalant est le parent de l'intéressé.
**Poids fort** — Accueillir la détresse et orienter sans instrumentalisation.

#### 201 — `stups-conduite-apres-usage-doute` ✅
**Thème** `stupefiants` · **moyen** · premium · *contrôle routier, 20 h*
**Titre** — « Le comportement est étrange mais le dépistage est négatif »
**Tension** — Écart entre observation et résultat du test.
**Angle distinctif** — Résultat négatif contredisant l'observation, cf. 007.
**Poids fort** — Envisager une cause médicale plutôt que s'entêter.

#### 202 — `stups-revendeur-mineur-victime-de-menaces` ✅
**Thème** `stupefiants` · **difficile** · premium · *commissariat, 21 h*
**Titre** — « Il dit qu'il doit rembourser une dette sinon sa mère aura des ennuis »
**Tension** — Auteur sous contrainte réelle, protection à organiser.
**Angle distinctif** — Contrainte exercée sur l'auteur mineur.
**Poids fort** — Prendre la menace au sérieux et protéger la famille.

#### 203 — `stups-decouverte-lors-intervention-vif` ✅
**Thème** `stupefiants` · **moyen** · premium · *domicile, 22 h*
**Titre** — « En sécurisant la pièce, vous voyez le produit sur le buffet »
**Tension** — Deux affaires imbriquées, priorité à la victime.
**Angle distinctif** — Découverte lors d'une intervention pour autre motif.
**Poids fort** — Ne pas laisser la découverte éclipser la prise en charge de la victime.

#### 204 — `stups-riverains-organisent-surveillance` ✅
**Thème** `stupefiants` · **difficile** · premium · *quartier, 19 h*
**Titre** — « Ils ont installé une caméra et tiennent un cahier d'observations »
**Tension** — Initiative citoyenne débordant sur des pratiques problématiques.
**Angle distinctif** — Risque de justice privée et de dérive.
**Poids fort** — Canaliser l'initiative sans encourager la surveillance privée.

#### 205 — `stups-livraison-a-domicile-interception` ✅
**Thème** `stupefiants` · **moyen** · premium · *hall d'immeuble, 16 h*
**Titre** — « Le livreur affirme ne transporter que des repas »
**Tension** — Modes de distribution modernes, apparence de légalité.
**Angle distinctif** — Mode opératoire dissimulé sous une activité licite.
**Poids fort** — Fonder l'action sur des éléments objectifs, pas sur l'apparence.

#### 206 — `stups-usage-en-milieu-professionnel` ✅
**Thème** `stupefiants` · **moyen** · premium · *entrepôt, 14 h*
**Titre** — « L'employeur a fouillé les vestiaires et vous remet le produit »
**Tension** — Éléments recueillis dans des conditions irrégulières.
**Angle distinctif** — Provenance des éléments comme problème central.
**Poids fort** — Interroger les conditions de recueil sans les valider.

#### 207 — `stups-personne-vulnerable-utilisee-comme-nourrice` ✅
**Thème** `stupefiants` · **expert** · premium · *appartement, 12 h*
**Titre** — « Elle vit sous tutelle et dit garder les sacs pour un ami »
**Tension** — Personne protégée instrumentalisée, discernement à évaluer.
**Angle distinctif** — Vulnérabilité juridique de la personne impliquée.
**Poids fort** — Traiter la personne comme possible victime d'exploitation.

---

## BLOC I — VOLS, CAMBRIOLAGES ET ATTEINTES AUX BIENS (208 → 236) · 29 cas ✅ **BLOC COMPLET**

> Thème `atteintes-biens`. Le cas 027 (expert) couvre déjà le vol à l'étalage
> avec agent de sécurité. Varier les modes opératoires, les profils de victimes
> et le rapport à la preuve.

#### 208 — `biens-cambriolage-decouverte-au-retour` ✅
**Thème** `atteintes-biens` · **moyen** · gratuit · *pavillon, 19 h*
**Titre** — « Ils rentrent de week-end et la porte-fenêtre est ouverte »
**Tension** — Auteurs peut-être encore présents ; victimes qui veulent entrer.
**Angle distinctif** — Préservation des traces contre urgence émotionnelle des victimes.
**Poids fort** — Empêcher l'entrée des occupants avant vérification.

#### 209 — `biens-tentative-cambriolage-voisin-vigilant` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *lotissement, 15 h*
**Titre** — « Le voisin a fait fuir deux individus et les a photographiés »
**Tension** — Éléments utiles fournis par un tiers, tentation de l'exposer.
**Angle distinctif** — Tentative interrompue, exploitation d'un signalement citoyen.
**Poids fort** — Exploiter les éléments sans encourager la prise de risque.

#### 210 — `biens-vol-a-l-arrache-personne-agee` ✅
**Thème** `atteintes-biens` · **moyen** · gratuit · *rue, 11 h*
**Titre** — « Elle est tombée en tenant son sac et ne veut pas voir de médecin »
**Tension** — Blessure minimisée par la victime, choc psychologique important.
**Angle distinctif** — Victime âgée et volet corporel du vol.
**Poids fort** — Faire évaluer médicalement malgré le refus initial.

#### 211 — `biens-vol-telephone-geolocalisation` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *commissariat, 20 h*
**Titre** — « L'application indique une adresse, il veut y aller lui-même »
**Tension** — Victime décidée à se faire justice ; localisation peu fiable.
**Angle distinctif** — Auto-investigation de la victime par la technologie.
**Poids fort** — Dissuader fermement la démarche personnelle.

#### 212 — `biens-vol-dans-vehicule-serie` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *parking souterrain, 8 h*
**Titre** — « Sept véhicules fracturés sur le même niveau »
**Tension** — Multiplicité des victimes, gestion collective des constatations.
**Angle distinctif** — Série sur un même site, méthode d'organisation.
**Poids fort** — Organiser les constatations sans bâcler les cas individuels.

#### 213 — `biens-vol-de-vehicule-restitution` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *rue, 14 h*
**Titre** — « Le véhicule est retrouvé mais il n'est plus à personne »
**Tension** — Restitution qui doit préserver d'éventuelles traces exploitables.
**Angle distinctif** — Découverte d'un véhicule volé, pas le vol lui-même.
**Poids fort** — Préserver les traces avant restitution.

#### 214 — `biens-recel-vente-en-ligne` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *commissariat, 16 h*
**Titre** — « Il a acheté le vélo cent euros sur une annonce et l'a revendu »
**Tension** — Bonne foi invoquée, prix dérisoire qui interroge.
**Angle distinctif** — Question de la connaissance de l'origine.
**Poids fort** — Recueillir précisément les circonstances de l'acquisition.

#### 215 — `biens-degradation-vehicule-conflit-voisinage` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *rue résidentielle, 9 h*
**Titre** — « Il accuse son voisin sans l'avoir vu faire »
**Tension** — Certitude subjective sans élément matériel, conflit ancien.
**Angle distinctif** — Croisement atteinte aux biens et conflit de voisinage.
**Poids fort** — Ne pas valider l'accusation sans élément objectif.

#### 216 — `biens-incendie-volontaire-suspecte` ✅
**Thème** `atteintes-biens` · **difficile** · premium · *local à poubelles, 3 h*
**Titre** — « Le départ de feu est au pied de la cage d'escalier »
**Tension** — Danger pour les habitants, préservation d'une scène fragile.
**Angle distinctif** — Risque pour les personnes lié à l'atteinte aux biens.
**Poids fort** — Sécuriser les habitants avant toute constatation.

#### 217 — `biens-occupation-illicite-logement` ✅
**Thème** `atteintes-biens` · **difficile** · premium · *appartement, 10 h*
**Titre** — « Le propriétaire a changé la serrure pendant leur absence »
**Tension** — Le propriétaire s'est fait justice lui-même ; occupants dehors.
**Angle distinctif** — Le plaignant est aussi possiblement en tort.
**Poids fort** — Ne pas prendre parti et rappeler les voies légales.

#### 218 — `biens-litige-proprietaire-locataire-acces` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *immeuble, 17 h*
**Titre** — « Il entre chez elle en son absence pour vérifier l'état du logement »
**Tension** — Litige civil avec possible atteinte au domicile.
**Angle distinctif** — Frontière entre litige civil et infraction.
**Poids fort** — Distinguer ce qui relève du civil et ce qui n'en relève pas.

#### 219 — `biens-vol-entre-collegues-entreprise` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *entreprise, 15 h*
**Titre** — « L'employeur a désigné un coupable avant votre arrivée »
**Tension** — Accusation interne déjà formée, pression sur un salarié.
**Angle distinctif** — Contexte professionnel et présomption interne.
**Poids fort** — Ne pas endosser l'accusation préétablie.

#### 220 — `biens-escroquerie-faux-artisan` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *pavillon, 12 h*
**Titre** — « Ils ont encaissé 8 000 euros pour un toit jamais réparé »
**Tension** — Victime âgée honteuse, auteurs itinérants déjà partis.
**Angle distinctif** — Escroquerie à domicile ciblant une personne vulnérable.
**Poids fort** — Recueillir les éléments de traçabilité financière sans délai.

#### 221 — `biens-fraude-moyen-paiement-carte` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *commissariat, 10 h 30*
**Titre** — « Onze prélèvements en trois jours dans une autre ville »
**Tension** — Urgence bancaire, victime perdue dans les démarches.
**Angle distinctif** — Volet bancaire, cf. 041 pour l'escroquerie en ligne.
**Poids fort** — Orienter vers l'opposition et la contestation sans délai.

#### 222 — `biens-vol-par-ruse-domicile` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *appartement, 14 h*
**Titre** — « Ils se sont présentés comme agents des eaux »
**Tension** — Victime âgée qui s'en veut ; description à recueillir vite.
**Angle distinctif** — Mode opératoire par tromperie et usurpation de qualité.
**Poids fort** — Déculpabiliser la victime et diffuser le signalement.

#### 223 — `biens-bien-vole-retrouve-en-vente-en-ligne` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *commissariat, 18 h*
**Titre** — « Elle reconnaît sa bague sur une annonce et a déjà contacté le vendeur »
**Tension** — Initiative de la victime pouvant compromettre la suite.
**Angle distinctif** — La victime a déjà agi seule avant de venir.
**Poids fort** — Faire cesser les contacts et préserver l'annonce.

#### 224 — `biens-cambriolage-victime-en-etat-de-choc` ✅
**Thème** `atteintes-biens` · **moyen** · gratuit · *maison, 21 h*
**Titre** — « Elle répète que quelqu'un a dormi dans son lit »
**Tension** — Atteinte à l'intimité plus lourde que le préjudice matériel.
**Angle distinctif** — Dimension psychologique du cambriolage.
**Poids fort** — Prendre en compte le retentissement, pas seulement le préjudice.

#### 225 — `biens-vol-a-l-etalage-mineur-non-accompagne` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *supermarché, 17 h*
**Titre** — « Il a treize ans et refuse de donner le numéro de ses parents »
**Tension** — Mineur à protéger, gérant qui veut « un exemple ».
**Angle distinctif** — Vol à l'étalage par un mineur, cf. 027 (majeure).
**Poids fort** — Traiter le mineur selon son statut, pas selon l'attente du gérant.

#### 226 — `biens-vol-materiel-chantier-nuit` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *chantier, 4 h*
**Titre** — « La clôture est découpée, un engin manque »
**Tension** — Site étendu, traces à préserver, auteurs peut-être présents.
**Angle distinctif** — Site professionnel non habité, de nuit.
**Poids fort** — Sécuriser le site avant constatations.

#### 227 — `biens-differend-restitution-objet-saisi` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *commissariat, 11 h*
**Titre** — « Il réclame son téléphone depuis quatre mois »
**Tension** — Exaspération légitime, procédure qu'on ne maîtrise pas seul.
**Angle distinctif** — Relation à l'usager sur le suivi d'une procédure.
**Poids fort** — Informer précisément sans promettre de délai.

#### 228 — `biens-vol-velo-electrique-marquage` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *gare, 18 h 30*
**Titre** — « Le vélo est marqué mais il n'a pas le numéro sur lui »
**Tension** — Élément d'identification existant mais non disponible.
**Angle distinctif** — Enjeu d'identification du bien.
**Poids fort** — Recueillir les moyens d'identification différés.

#### 229 — `biens-cambriolage-serie-mode-operatoire` ✅
**Thème** `atteintes-biens` · **difficile** · premium · *quartier pavillonnaire, 16 h*
**Titre** — « Quatrième pavillon de la même rue en dix jours »
**Tension** — Riverains inquiets et pressants, série à documenter finement.
**Angle distinctif** — Rapprochement de faits et communication vers les riverains.
**Poids fort** — Documenter le mode opératoire pour permettre le rapprochement.

#### 230 — `biens-degradation-batiment-public` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *mairie, 8 h*
**Titre** — « Des inscriptions injurieuses visant le maire sur la façade »
**Tension** — Dimension politique possible, pression de l'élu.
**Angle distinctif** — Atteinte à un bien public avec dimension symbolique.
**Poids fort** — Traiter les faits sans considération de la qualité de la victime.

#### 231 — `biens-vol-dans-etablissement-de-sante` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *hôpital, 22 h*
**Titre** — « Des effets disparaissent dans les chambres depuis trois semaines »
**Tension** — Victimes vulnérables, personnel possiblement impliqué.
**Angle distinctif** — Victimes hospitalisées, suspects internes possibles.
**Poids fort** — Agir avec discrétion pour ne pas compromettre la suite.

#### 232 — `biens-vol-avec-violence-transports` ✅
**Thème** `atteintes-biens` · **difficile** · premium · *bus, 19 h*
**Titre** — « Une vingtaine de passagers, personne ne veut témoigner »
**Tension** — Nombreux témoins muets, auteur descendu à un arrêt.
**Angle distinctif** — Silence collectif comme obstacle central.
**Poids fort** — Recueillir les identités des témoins malgré leur réticence.

#### 233 — `biens-escroquerie-sentimentale` ✅
**Thème** `atteintes-biens` · **difficile** · premium · *commissariat, 15 h*
**Titre** — « Elle a envoyé 40 000 euros et pense toujours qu'il l'aime »
**Tension** — Victime non convaincue d'être victime ; emprise affective.
**Angle distinctif** — Déni de la victime, dimension affective.
**Poids fort** — Ne pas humilier la victime tout en établissant les faits.

#### 234 — `biens-vol-dans-lieu-de-culte` ✅
**Thème** `atteintes-biens` · **moyen** · premium · *lieu de culte, 13 h*
**Titre** — « Le tronc a été forcé et un objet liturgique manque »
**Tension** — Dimension symbolique forte, communauté émue.
**Angle distinctif** — Bien à valeur symbolique et cultuelle.
**Poids fort** — Mesurer la dimension symbolique dans la prise en charge.

#### 235 — `biens-fausse-declaration-de-vol` ✅
**Thème** `atteintes-biens` · **expert** · premium · *commissariat, 12 h*
**Titre** — « Les incohérences du récit s'accumulent au fil de l'audition »
**Tension** — Soupçon de fraude, mais l'erreur de jugement serait grave.
**Angle distinctif** — Le plaignant est peut-être l'auteur d'une autre infraction.
**Poids fort** — Ne pas accuser, recueillir et relever les incohérences factuellement.

#### 236 — `biens-vol-outils-professionnel-perte-activite` ✅
**Thème** `atteintes-biens` · **facile** · gratuit · *rue, 7 h 30*
**Titre** — « Sans ses outils, il ne peut plus travailler dès demain »
**Tension** — Préjudice économique immédiat, victime en détresse pratique.
**Angle distinctif** — Conséquence professionnelle directe du vol.
**Poids fort** — Prendre en compte l'urgence économique dans l'orientation.

---

## BLOC J — INFRACTIONS NUMÉRIQUES ET RÉSEAUX SOCIAUX (237 → 257) · 21 cas ✅ **BLOC COMPLET**

> Thème `numerique`. Le cas 025 couvre déjà la sextorsion. Varier les supports,
> les profils de victimes et le rapport à la preuve numérique. Attention
> particulière à la préservation des éléments.

#### 237 — `num-usurpation-identite-faux-profil` ✅
**Thème** `numerique` · **moyen** · premium · *commissariat, 14 h*
**Titre** — « Un faux compte à son nom envoie des messages à ses collègues »
**Tension** — Atteinte à la réputation en cours, plateforme peu réactive.
**Angle distinctif** — Usurpation, pas chantage.
**Poids fort** — Préserver les éléments avant toute demande de suppression.

#### 238 — `num-piratage-compte-bancaire-en-ligne` ✅
**Thème** `numerique` · **moyen** · premium · *commissariat, 9 h*
**Titre** — « Il a reçu un code par SMS et l'a communiqué au faux conseiller »
**Tension** — Victime qui a elle-même transmis le code ; urgence bancaire.
**Angle distinctif** — Ingénierie sociale bancaire.
**Poids fort** — Ne pas culpabiliser et orienter vers l'opposition immédiate.

#### 239 — `num-menaces-de-mort-reseau-social` ✅
**Thème** `numerique` · **difficile** · premium · *commissariat, 17 h*
**Titre** — « Le compte est anonyme mais connaît son adresse »
**Tension** — Menace crédible du fait des informations détenues par l'auteur.
**Angle distinctif** — Crédibilité de la menace liée aux données personnelles.
**Poids fort** — Évaluer la crédibilité et la sécurité de la victime.

#### 240 — `num-harcelement-groupe-discussion-classe` ✅
**Thème** `numerique` · **moyen** · premium · *commissariat, 18 h*
**Titre** — « Trente-deux participants, personne n'a rien écrit de grave seul »
**Tension** — Responsabilité diffuse dans un groupe nombreux.
**Angle distinctif** — Harcèlement collectif, cf. 023 côté accueil.
**Poids fort** — Établir la responsabilité collective sans diluer l'individuelle.

#### 241 — `num-diffusion-images-sans-consentement-ex` ✅
**Thème** `numerique` · **difficile** · premium · *commissariat, 20 h*
**Titre** — « Les photos sont apparues le lendemain de la rupture »
**Tension** — Diffusion en cours, auteur identifié mais niant.
**Angle distinctif** — Contexte post-rupture, auteur connu.
**Poids fort** — Faire cesser la diffusion et documenter l'ampleur.

#### 242 — `num-achat-frauduleux-faux-site` ✅
**Thème** `numerique` · **facile** · gratuit · *commissariat, 11 h*
**Titre** — « Le site a disparu deux jours après la commande »
**Tension** — Traces limitées, victime persuadée que rien ne sera fait.
**Angle distinctif** — Escroquerie commerciale simple.
**Poids fort** — Recueillir les traces techniques encore disponibles.

#### 243 — `num-phishing-campagne-locale` ✅
**Thème** `numerique` · **moyen** · premium · *commissariat, 15 h*
**Titre** — « Quatre habitants du même quartier ont reçu le même message »
**Tension** — Faits sériels à rapprocher, prévention à organiser.
**Angle distinctif** — Dimension sérielle et prévention.
**Poids fort** — Rapprocher les faits et alerter sans créer de psychose.

#### 244 — `num-mineur-sollicite-par-adulte-en-ligne` ✅
**Thème** `numerique` · **expert** · premium · *commissariat, 19 h*
**Titre** — « Les parents ont pris le contrôle du compte et répondent à sa place »
**Tension** — Initiative parentale compromettant l'enquête ; danger réel pour l'enfant.
**Angle distinctif** — Intervention parentale dans un contact prédateur en cours.
**Poids fort** — Faire cesser l'intervention parentale sans les braquer.

#### 245 — `num-publication-arme-reseau-social` ✅
**Thème** `numerique` · **difficile** · premium · *commissariat, 16 h*
**Titre** — « La photo est en story, l'arme paraît réelle »
**Tension** — Évaluer la réalité de l'arme et l'imminence d'un passage à l'acte.
**Angle distinctif** — Signal faible à évaluer, cf. bloc situations sensibles.
**Poids fort** — Prendre au sérieux et faire remonter sans dramatiser à tort.

#### 246 — `num-video-intervention-diffusee` ✅
**Thème** `numerique` · **difficile** · premium · *commissariat, 10 h*
**Titre** — « La vidéo est coupée juste avant le geste de l'individu »
**Tension** — Image tronquée circulant, pression sur les agents concernés.
**Angle distinctif** — Les policiers sont concernés, cf. 035 (captation en direct).
**Poids fort** — Ne pas réagir publiquement et faire remonter par la voie interne.

#### 247 — `num-fuite-donnees-professionnelles` ✅
**Thème** `numerique` · **expert** · premium · *service, 14 h*
**Titre** — « Une capture d'écran d'un fichier de service circule dans un groupe »
**Tension** — Origine interne probable, obligation de signalement.
**Angle distinctif** — Manquement possible d'un collègue, cf. bloc déontologie.
**Poids fort** — Signaler sans enquêter soi-même sur ses collègues.

#### 248 — `num-rancongiciel-petite-entreprise` ✅
**Thème** `numerique` · **moyen** · premium · *entreprise, 9 h 30*
**Titre** — « Le gérant veut payer pour redémarrer avant lundi »
**Tension** — Urgence économique poussant à une décision contre-productive.
**Angle distinctif** — Victime professionnelle, enjeu de continuité d'activité.
**Poids fort** — Déconseiller le paiement et préserver les systèmes.

#### 249 — `num-cyberharcelement-enseignant` ✅
**Thème** `numerique` · **difficile** · premium · *établissement scolaire, 12 h*
**Titre** — « Les élèves ont créé un compte à son nom avec des montages »
**Tension** — Auteurs mineurs, victime professionnelle exposée publiquement.
**Angle distinctif** — Victime adulte, auteurs mineurs, contexte scolaire.
**Poids fort** — Articuler traitement des mineurs et protection de la victime.

#### 250 — `num-arnaque-au-faux-support-technique` ✅
**Thème** `numerique` · **moyen** · premium · *domicile, 16 h*
**Titre** — « Ils ont pris la main sur son ordinateur et l'appel est encore en cours »
**Tension** — Infraction en train de se produire, victime au téléphone.
**Angle distinctif** — Flagrance numérique en cours.
**Poids fort** — Faire couper la connexion immédiatement.

#### 251 — `num-revenge-menace-de-publication` ✅
**Thème** `numerique` · **difficile** · premium · *commissariat, 21 h*
**Titre** — « Rien n'a encore été publié, mais il a envoyé un compte à rebours »
**Tension** — Menace sans exécution, urgence de prévention.
**Angle distinctif** — Avant la diffusion, contrairement à 241.
**Poids fort** — Agir avant la publication et sécuriser la victime.

#### 252 — `num-faux-profil-usurpant-un-policier` ✅
**Thème** `numerique` · **moyen** · premium · *commissariat, 13 h*
**Titre** — « Le compte publie de faux avis de recherche en uniforme »
**Tension** — Atteinte à l'image de l'institution, désinformation locale.
**Angle distinctif** — Usurpation de la qualité de policier.
**Poids fort** — Signaler par la voie hiérarchique sans intervenir personnellement.

#### 253 — `num-donnees-personnelles-divulguees-en-ligne` ✅
**Thème** `numerique` · **difficile** · premium · *commissariat, 18 h*
**Titre** — « Son adresse et son lieu de travail ont été publiés dans un forum »
**Tension** — Danger physique induit par la publication.
**Angle distinctif** — Divulgation exposant à un risque réel.
**Poids fort** — Évaluer le risque physique, pas seulement l'atteinte numérique.

#### 254 — `num-escroquerie-locative-fausse-annonce` ✅
**Thème** `numerique` · **facile** · gratuit · *commissariat, 10 h*
**Titre** — « Elle a versé deux mois de caution pour un logement qui n'existe pas »
**Tension** — Victime étudiante sans logement ni ressources.
**Angle distinctif** — Conséquence matérielle immédiate.
**Poids fort** — Orienter vers les solutions d'urgence en plus de la plainte.

#### 255 — `num-compte-pirate-envoi-messages-proches` ✅
**Thème** `numerique` · **facile** · gratuit · *commissariat, 15 h*
**Titre** — « Ses contacts ont reçu des demandes d'argent en son nom »
**Tension** — Victimes multiples potentielles, propagation en cours.
**Angle distinctif** — Effet de propagation vers les proches.
**Poids fort** — Faire alerter les contacts et sécuriser le compte.

#### 256 — `num-contenu-haineux-signale-par-un-tiers` ✅
**Thème** `numerique` · **moyen** · premium · *commissariat, 17 h*
**Titre** — « Le signalant n'est pas visé et veut rester à distance »
**Tension** — Signalement citoyen sans victime directe présente.
**Angle distinctif** — Absence de victime identifiée au dépôt.
**Poids fort** — Recueillir et transmettre malgré l'absence de plaignant.

#### 257 — `num-deepfake-vocal-arnaque-familiale` ✅
**Thème** `numerique` · **difficile** · premium · *domicile, 20 h*
**Titre** — « Elle a reconnu la voix de son fils au téléphone »
**Tension** — Procédé nouveau, victime persuadée d'avoir parlé à son enfant.
**Angle distinctif** — Falsification vocale, mode opératoire émergent.
**Poids fort** — Faire vérifier auprès du proche réel avant tout versement.

---

## BLOC K — ORDRE PUBLIC, RASSEMBLEMENTS ET ÉVÉNEMENTS (258 → 279) · 22 cas ✅ **BLOC COMPLET**

> Thème `ordre-public`. Thème vide à ce jour. Rester au niveau du gardien de la
> paix en service d'ordre : pas de doctrine de maintien de l'ordre, pas de
> technique de dispersion. Centrer sur discernement, communication, dignité.

#### 258 — `ordre-manifestation-declaree-debordement-limite` ✅
**Thème** `ordre-public` · **moyen** · premium · *avenue, 15 h*
**Titre** — « Une centaine de personnes quitte le parcours déclaré »
**Tension** — Écart au parcours sans violence ; réaction à calibrer.
**Angle distinctif** — Manifestation déclarée qui dévie.
**Poids fort** — Rendre compte et ne pas agir seul sans instruction.

#### 259 — `ordre-rassemblement-non-declare-spontane` ✅
**Thème** `ordre-public` · **moyen** · premium · *place publique, 19 h*
**Titre** — « Le rassemblement s'est formé en deux heures sur les réseaux »
**Tension** — Absence de déclaration, participants pacifiques et nombreux.
**Angle distinctif** — Spontanéité et absence d'organisateur identifiable.
**Poids fort** — Identifier un interlocuteur et maintenir le dialogue.

#### 260 — `ordre-filtrage-acces-refus-personne` ✅
**Thème** `ordre-public` · **facile** · gratuit · *entrée de stade, 18 h*
**Titre** — « Il refuse l'inspection de son sac et bloque la file »
**Tension** — Refus légitime en droit, flux à préserver, tension qui monte.
**Angle distinctif** — Limites du filtrage et conséquence du refus.
**Poids fort** — Expliquer les conséquences du refus sans contraindre.

#### 261 — `ordre-objet-interdit-decouvert-filtrage` ✅
**Thème** `ordre-public` · **moyen** · premium · *entrée de festival, 20 h*
**Titre** — « Un couteau de cuisine dans le sac d'un festivalier »
**Tension** — Explication plausible, appréciation du contexte nécessaire.
**Angle distinctif** — Objet dont la dangerosité dépend du contexte.
**Poids fort** — Apprécier le contexte sans automatisme.

#### 262 — `ordre-supporters-tensions-avant-match` ✅
**Thème** `ordre-public` · **difficile** · premium · *abords de stade, 17 h*
**Titre** — « Deux groupes se font face de part et d'autre du parvis »
**Tension** — Affrontement imminent, tiers présents dont des familles.
**Angle distinctif** — Prévention d'un affrontement entre groupes constitués.
**Poids fort** — Maintenir la séparation physique et rendre compte.

#### 263 — `ordre-contre-manifestation-proximite` ✅
**Thème** `ordre-public` · **difficile** · premium · *centre-ville, 14 h*
**Titre** — « Les deux cortèges vont se croiser dans dix minutes »
**Tension** — Impartialité absolue exigée entre deux camps opposés.
**Angle distinctif** — Neutralité politique de l'agent mise à l'épreuve.
**Poids fort** — Neutralité stricte dans le comportement et les propos.

#### 264 — `ordre-journaliste-presence-couverture` ✅
**Thème** `ordre-public` · **moyen** · premium · *manifestation, 16 h*
**Titre** — « Il filme le dispositif et demande votre matricule »
**Tension** — Liberté d'informer contre réflexe défensif.
**Angle distinctif** — Rapport à la presse en service d'ordre.
**Poids fort** — Ne pas entraver le travail de presse et rester courtois.

#### 265 — `ordre-elu-local-sur-place-demande` ✅
**Thème** `ordre-public` · **moyen** · premium · *fête locale, 22 h*
**Titre** — « L'adjoint au maire demande de laisser la sono jusqu'à 2 heures »
**Tension** — Pression institutionnelle sur une décision de terrain.
**Angle distinctif** — Sollicitation par un élu, cf. 044 (plainte contre policier).
**Poids fort** — Ne pas céder à la qualité du demandeur et rendre compte.

#### 266 — `ordre-individu-provocateur-isole` ✅
**Thème** `ordre-public` · **moyen** · gratuit · *manifestation, 15 h 30*
**Titre** — « Il s'approche du cordon et provoque nommément les agents »
**Tension** — Provocation cherchant la réaction ; caméras présentes.
**Angle distinctif** — Provocation ciblée sur les agents.
**Poids fort** — Maîtrise de soi et non-réponse à la provocation.

#### 267 — `ordre-mouvement-de-panique-fausse-alerte` ✅
**Thème** `ordre-public` · **difficile** · premium · *concert, 23 h*
**Titre** — « Une détonation de pétard, la foule reflue vers les sorties »
**Tension** — Danger réel créé par la panique elle-même.
**Angle distinctif** — Le danger est la réaction, pas l'événement initial.
**Poids fort** — Diffuser une information claire pour stopper la panique.

#### 268 — `ordre-evacuation-batiment-recevant-public` ✅
**Thème** `ordre-public` · **moyen** · premium · *centre commercial, 15 h*
**Titre** — « Certains clients refusent de sortir sans leurs achats »
**Tension** — Évacuation ralentie par des comportements individuels.
**Angle distinctif** — Résistance passive à une évacuation.
**Poids fort** — Obtenir l'évacuation par la clarté du message.

#### 269 — `ordre-depart-bagarre-fete-locale` ✅
**Thème** `ordre-public` · **moyen** · gratuit · *fête de village, 1 h*
**Titre** — « Deux familles du village se prennent à partie devant la buvette »
**Tension** — Effectif réduit, alcool, interconnaissance locale.
**Angle distinctif** — Milieu rural et interconnaissance.
**Poids fort** — Séparer et demander du renfort sans s'engager seul.

#### 270 — `ordre-blocage-etudiant-etablissement` ✅
**Thème** `ordre-public` · **moyen** · premium · *université, 8 h*
**Titre** — « Les poubelles bloquent l'entrée, la direction demande l'intervention »
**Tension** — Demande de la direction, jeunes majeurs, forte médiatisation.
**Angle distinctif** — Cadre universitaire et réquisition de la direction.
**Poids fort** — Vérifier le cadre de l'intervention avant d'agir.

#### 271 — `ordre-rassemblement-hostile-envers-la-police` ✅
**Thème** `ordre-public` · **difficile** · premium · *quartier, 21 h*
**Titre** — « Une cinquantaine de personnes vous entoure après une interpellation »
**Tension** — Équipage isolé, hostilité croissante, interpellé à protéger.
**Angle distinctif** — Équipage en position défavorable, cf. 061.
**Poids fort** — Se dégager et protéger la personne interpellée.

#### 272 — `ordre-personne-malaise-dans-la-foule` ✅
**Thème** `ordre-public` · **facile** · gratuit · *manifestation, 16 h*
**Titre** — « Une femme s'effondre au milieu du cortège »
**Tension** — Urgence médicale dans un environnement saturé.
**Angle distinctif** — Secours à personne en contexte d'ordre public.
**Poids fort** — Créer un espace pour les secours sans stopper le dispositif.

#### 273 — `ordre-drone-survolant-le-dispositif` ✅
**Thème** `ordre-public` · **moyen** · premium · *rassemblement, 14 h*
**Titre** — « Un drone stationne au-dessus de la foule depuis vingt minutes »
**Tension** — Risque de chute sur la foule, opérateur non localisé.
**Angle distinctif** — Enjeu technologique et sécurité aérienne.
**Poids fort** — Rendre compte et localiser l'opérateur sans agir sur l'appareil.

#### 274 — `ordre-marche-blanche-emotion-collective` ✅
**Thème** `ordre-public` · **facile** · gratuit · *centre-ville, 18 h*
**Titre** — « Six cents personnes en silence, la famille en tête »
**Tension** — Émotion collective, présence policière à doser avec tact.
**Angle distinctif** — Rassemblement pacifique et endeuillé.
**Poids fort** — Discrétion du dispositif et respect de l'émotion.

#### 275 — `ordre-vendeur-a-la-sauvette-evenement` ✅
**Thème** `ordre-public` · **facile** · gratuit · *abords de stade, 19 h*
**Titre** — « Il vend des boissons et fuit en abandonnant sa marchandise »
**Tension** — Infraction mineure, personne peut-être en grande précarité.
**Angle distinctif** — Croisement ordre public et vulnérabilité sociale.
**Poids fort** — Proportionner la réponse et repérer la vulnérabilité.

#### 276 — `ordre-groupe-hostile-envers-un-participant` ✅
**Thème** `ordre-public` · **difficile** · premium · *manifestation, 17 h*
**Titre** — « Un homme isolé est pris à partie par une dizaine de manifestants »
**Tension** — Protéger une personne au milieu d'un groupe hostile.
**Angle distinctif** — Protection d'un individu contre un collectif.
**Poids fort** — Extraire la personne en priorité.

#### 277 — `ordre-fin-de-manifestation-dispersion-difficile` ✅
**Thème** `ordre-public` · **moyen** · premium · *place, 20 h*
**Titre** — « Un noyau refuse de partir alors que le cortège s'est dissous »
**Tension** — Groupe résiduel, fatigue des effectifs, tension diffuse.
**Angle distinctif** — Phase de fin, souvent la plus délicate.
**Poids fort** — Maintenir la vigilance malgré la fatigue.

#### 278 — `ordre-incident-lors-ceremonie-officielle` ✅
**Thème** `ordre-public` · **difficile** · premium · *monument aux morts, 11 h*
**Titre** — « Un homme s'avance vers l'estrade en criant pendant la minute de silence »
**Tension** — Intervention nécessaire mais très exposée symboliquement.
**Angle distinctif** — Cadre protocolaire et exposition publique.
**Poids fort** — Intervenir avec mesure et sans brutalité visible.

#### 279 — `ordre-camping-sauvage-rassemblement-festif` ✅
**Thème** `ordre-public` · **moyen** · premium · *terrain rural, 5 h*
**Titre** — « Trois cents personnes, aucun organisateur ne se déclare »
**Tension** — Effectif dérisoire, risques sanitaires, propriétaire excédé.
**Angle distinctif** — Rassemblement festif non déclaré en milieu rural.
**Poids fort** — Rendre compte et privilégier la sécurité sanitaire.

---

## BLOC L — GESTION DES CONFLITS ET COMMUNICATION (280 → 304) · 25 cas ✅ **BLOC COMPLET**

> Thème `gestion-conflits`. Le cas 028 couvre déjà les nuisances en copropriété.
> Bloc centré sur la posture, la communication et la maîtrise de soi.

#### 280 — `conflits-differend-commercial-client-commercant` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *magasin, 16 h*
**Titre** — « Il refuse de quitter la boutique tant qu'il n'est pas remboursé »
**Tension** — Litige civil bloquant l'activité, aucune infraction claire.
**Angle distinctif** — Frontière civil/pénal en contexte commercial.
**Poids fort** — Expliquer la limite de la compétence policière.

#### 281 — `conflits-stationnement-entre-voisins` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *rue résidentielle, 8 h*
**Titre** — « Il a garé son véhicule devant le portail par représailles »
**Tension** — Escalade dans un conflit ancien, faits mineurs répétés.
**Angle distinctif** — Représailles matérielles, cf. 028 (bruit).
**Poids fort** — Traiter la logique d'escalade, pas seulement le fait du jour.

#### 282 — `conflits-personne-refuse-de-cooperer-controle` ✅
**Thème** `gestion-conflits` · **moyen** · gratuit · *voie publique, 15 h*
**Titre** — « Il croise les bras et dit qu'il ne répondra à aucune question »
**Tension** — Refus non violent, tentation d'escalade inutile.
**Angle distinctif** — Résistance passive, cf. 157 (routier).
**Poids fort** — Ne pas transformer un refus passif en confrontation.

#### 283 — `conflits-temoin-enerve-perturbe-intervention` ✅
**Thème** `gestion-conflits` · **moyen** · gratuit · *trottoir, 18 h*
**Titre** — « Il commente chaque geste à voix haute et ameute les passants »
**Tension** — Perturbation de l'intervention, effet d'entraînement.
**Angle distinctif** — Tiers non impliqué qui dégrade la situation.
**Poids fort** — Neutraliser l'effet d'entraînement sans confrontation.

#### 284 — `conflits-victime-mecontente-de-la-reponse` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *commissariat, 14 h*
**Titre** — « Elle estime qu'on ne fait rien depuis sa plainte d'il y a six mois »
**Tension** — Reproche fondé en partie, information limitée disponible.
**Angle distinctif** — Insatisfaction sur le suivi, cf. 227.
**Poids fort** — Accueillir le reproche sans se défausser sur le service.

#### 285 — `conflits-personne-alcoolisee-sur-voie-publique` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *rue piétonne, 23 h*
**Titre** — « Il chante fort et interpelle les passants sans agressivité »
**Tension** — Trouble modéré, personne vulnérable de fait.
**Angle distinctif** — Alcoolisation sans violence, enjeu de protection.
**Poids fort** — Traiter la vulnérabilité autant que le trouble.

#### 286 — `conflits-accusation-de-discrimination-pendant-controle` ✅
**Thème** `gestion-conflits` · **difficile** · premium · *voie publique, 17 h*
**Titre** — « Il vous demande pourquoi lui et pas les autres »
**Tension** — Question légitime, réponse à construire sans agressivité.
**Angle distinctif** — Contestation du contrôle, cf. bloc discriminations.
**Poids fort** — Expliquer le motif du contrôle calmement.

#### 287 — `conflits-personne-filme-l-intervention-de-pres` ✅
**Thème** `gestion-conflits` · **moyen** · gratuit · *rue, 19 h*
**Titre** — « Il approche son téléphone à trente centimètres de votre visage »
**Tension** — Captation licite mais proximité gênant l'action.
**Angle distinctif** — Distance physique, cf. 035 (hall) et 246 (diffusion).
**Poids fort** — Demander une distance sans interdire la captation.

#### 288 — `conflits-insultes-envers-les-agents` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *voie publique, 22 h*
**Titre** — « Les insultes fusent depuis un balcon, plusieurs personnes rient »
**Tension** — Atteinte personnelle ressentie, public qui observe.
**Angle distinctif** — Outrage à distance, sans contact possible immédiat.
**Poids fort** — Ne pas réagir sous le coup de l'émotion.

#### 289 — `conflits-collegue-perd-son-calme` ✅
**Thème** `gestion-conflits` · **difficile** · premium · *voie publique, 20 h*
**Titre** — « Votre équipier hausse le ton et s'approche trop près »
**Tension** — Intervenir sur son propre collègue devant le public.
**Angle distinctif** — Le problème vient de l'équipe, cf. bloc équipe.
**Poids fort** — Reprendre la main sans désavouer publiquement le collègue.

#### 290 — `conflits-differend-familial-heritage` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *domicile, 15 h*
**Titre** — « Le frère et la sœur se disputent le contenu de la maison »
**Tension** — Litige successoral hors compétence, tension réelle.
**Angle distinctif** — Conflit patrimonial familial.
**Poids fort** — Faire cesser le trouble sans arbitrer la succession.

#### 291 — `conflits-incomprehension-linguistique-intervention` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *appartement, 21 h*
**Titre** — « Les gestes sont interprétés de travers des deux côtés »
**Tension** — Malentendu qui alimente la tension, sans interprète.
**Angle distinctif** — Barrière linguistique en intervention, cf. 031 (accueil).
**Poids fort** — Ralentir et clarifier plutôt que hausser le ton.

#### 292 — `conflits-groupe-hostile-au-depart-de-l-equipage` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *pied d'immeuble, 23 h*
**Titre** — « Ils bloquent le passage du véhicule en riant »
**Tension** — Provocation collective au moment du départ.
**Angle distinctif** — Phase de désengagement, souvent négligée.
**Poids fort** — Se dégager sans céder ni sur-réagir.

#### 293 — `conflits-usager-menace-de-porter-plainte` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *voie publique, 16 h*
**Titre** — « Il annonce qu'il va faire un signalement contre vous »
**Tension** — Tentative d'intimidation, risque de modifier son comportement.
**Angle distinctif** — Pression par la menace de procédure.
**Poids fort** — Ne pas modifier son action sous l'effet de la menace.

#### 294 — `conflits-differend-entre-usagers-transports` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *quai de gare, 8 h*
**Titre** — « Une bousculade a dégénéré en injures devant cent voyageurs »
**Tension** — Public nombreux, versions opposées, heure de pointe.
**Angle distinctif** — Espace de transport à forte affluence.
**Poids fort** — Séparer rapidement et éviter l'attroupement.

#### 295 — `conflits-personne-en-souffrance-agressive` ✅
**Thème** `gestion-conflits` · **difficile** · premium · *guichet public, 11 h*
**Titre** — « Il crie qu'il a tout perdu et frappe le comptoir »
**Tension** — Agressivité expression d'une détresse, pas d'une intention.
**Angle distinctif** — Comprendre la détresse derrière l'agressivité.
**Poids fort** — Traiter la détresse plutôt que sanctionner le comportement.

#### 296 — `conflits-mediation-differend-de-voisinage-ancien` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *pavillon, 18 h*
**Titre** — « Sept interventions en un an, aucune infraction constatée »
**Tension** — Épuisement du dispositif, nécessité d'un relais extérieur.
**Angle distinctif** — Bilan et orientation, pas gestion de crise.
**Poids fort** — Orienter vers la médiation et documenter l'historique.

#### 297 — `conflits-client-agressif-etablissement-nuit` ✅
**Thème** `gestion-conflits` · **moyen** · gratuit · *bar, 1 h*
**Titre** — « Le gérant refuse de le servir, il refuse de sortir »
**Tension** — Alcool, public, gérant qui veut une expulsion immédiate.
**Angle distinctif** — Contexte de débit de boissons nocturne.
**Poids fort** — Obtenir le départ sans recours immédiat à la contrainte.

#### 298 — `conflits-parents-eleves-sortie-ecole` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *devant l'école, 16 h 30*
**Titre** — « Deux mères en viennent aux mains devant les enfants »
**Tension** — Enfants témoins, nombreux parents présents.
**Angle distinctif** — Conflit d'adultes devant un public d'enfants.
**Poids fort** — Soustraire la scène au regard des enfants.

#### 299 — `conflits-personne-refuse-decliner-identite-litige` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *commerce, 14 h*
**Titre** — « Elle affirme n'avoir rien à se reprocher et refuse tout échange »
**Tension** — Blocage total, nécessité d'établir l'identité pour la suite.
**Angle distinctif** — Refus dans un contexte de litige, pas de contrôle.
**Poids fort** — Expliquer la nécessité de l'identité pour la procédure.

#### 300 — `conflits-differend-copropriete-assemblee` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *salle commune, 20 h*
**Titre** — « L'assemblée générale a dégénéré, le syndic a appelé »
**Tension** — Cadre privé, désaccord de gestion, aucune infraction.
**Angle distinctif** — Réunion formelle qui dégénère.
**Poids fort** — Faire cesser le trouble sans entrer dans le débat de fond.

#### 301 — `conflits-personne-hostile-refuse-soins-pompiers` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *voie publique, 2 h*
**Titre** — « Il repousse les pompiers venus pour lui »
**Tension** — Protéger les secours et convaincre la personne.
**Angle distinctif** — Hostilité dirigée contre un service partenaire, cf. 092.
**Poids fort** — Sécuriser les secours et rétablir le dialogue.

#### 302 — `conflits-riverains-exigent-une-action-immediate` ✅
**Thème** `gestion-conflits` · **moyen** · premium · *quartier, 19 h*
**Titre** — « Une dizaine d'habitants vous entoure et exige des interpellations »
**Tension** — Pression collective, attentes dépassant le cadre légal.
**Angle distinctif** — Pression citoyenne collective sur l'action policière.
**Poids fort** — Expliquer les limites sans se laisser dicter l'action.

#### 303 — `conflits-differend-entre-un-usager-et-un-agent-municipal` ✅
**Thème** `gestion-conflits` · **facile** · gratuit · *marché, 10 h*
**Titre** — « Le placier et le commerçant s'invectivent devant les clients »
**Tension** — Conflit entre un agent public et un administré.
**Angle distinctif** — Intervention entre deux parties dont une est agent public.
**Poids fort** — Rester neutre malgré la qualité d'agent public d'une partie.

#### 304 — `conflits-personne-souhaite-retirer-sa-plainte-sous-pression` ✅
**Thème** `gestion-conflits` · **difficile** · premium · *commissariat, 17 h*
**Titre** — « Elle est accompagnée de deux personnes qui répondent pour elle »
**Tension** — Retrait possiblement contraint, accompagnants insistants.
**Angle distinctif** — Pression exercée sur une plaignante au guichet.
**Poids fort** — Isoler la personne pour recueillir sa volonté réelle.

---

## BLOC M — DÉONTOLOGIE ET INTÉGRITÉ (305 → 341) · 37 cas ✅ **BLOC COMPLET**

> Thème `deontologie`. **Bloc le plus important du catalogue.** Les cas 003,
> 017 et 018 couvrent déjà photo d'intervention, consultation de fichiers et
> réseaux sociaux. Chaque cas doit poser un dilemme réel, pas une évidence.

#### 305 — `deonto-cadeau-commercant-habituel` ✅
**Thème** `deontologie` · **facile** · gratuit · *commerce, 12 h*
**Titre** — « Le restaurateur refuse systématiquement d'encaisser »
**Tension** — Refus répété créant une dette morale progressive.
**Angle distinctif** — Gratification insidieuse et banalisée.
**Poids fort** — Refuser et expliquer pourquoi, sans blesser.

#### 306 — `deonto-collegue-propos-discriminatoires-vestiaire` ✅
**Thème** `deontologie` · **difficile** · premium · *vestiaire, 6 h*
**Titre** — « Personne ne relève, deux collègues rient »
**Tension** — Isolement de celui qui voudrait réagir, effet de groupe.
**Angle distinctif** — Propos entre collègues, hors présence du public.
**Poids fort** — Ne pas laisser passer, malgré le coût social.

#### 307 — `deonto-collegue-force-disproportionnee` ✅
**Thème** `deontologie` · **expert** · premium · *voie publique, 21 h*
**Titre** — « Le geste continue alors que l'individu ne résiste plus »
**Tension** — Intervenir sur un collègue en pleine action, devant témoins.
**Angle distinctif** — Faute en train de se commettre, obligation d'agir.
**Poids fort** — Faire cesser matériellement l'action du collègue.

#### 308 — `deonto-collegue-falsifie-compte-rendu` ✅
**Thème** `deontologie` · **expert** · premium · *service, 23 h*
**Titre** — « Il vous demande de signer un compte rendu que vous savez inexact »
**Tension** — Loyauté envers le collègue contre exactitude de l'acte.
**Angle distinctif** — Sollicitation directe de complicité écrite.
**Poids fort** — Refuser de signer et le dire clairement.

#### 309 — `deonto-ordre-manifestement-illegal` ✅
**Thème** `deontologie` · **expert** · premium · *intervention, 15 h*
**Titre** — « Le chef vous demande de ne pas mentionner un élément au procès-verbal »
**Tension** — Obéissance hiérarchique et ses limites.
**Angle distinctif** — L'ordre vient de la hiérarchie directe.
**Poids fort** — Identifier la limite de l'obéissance et refuser.

#### 310 — `deonto-pression-hierarchique-classer-affaire` ✅
**Thème** `deontologie` · **difficile** · premium · *bureau, 17 h*
**Titre** — « On vous suggère que cette plainte n'a pas d'avenir »
**Tension** — Suggestion implicite plutôt qu'ordre formel.
**Angle distinctif** — Pression indirecte, difficile à objectiver.
**Poids fort** — Poursuivre le traitement et tracer sa démarche.

#### 311 — `deonto-intervention-concernant-un-proche` ✅
**Thème** `deontologie` · **moyen** · premium · *voie publique, 19 h*
**Titre** — « L'individu contrôlé est le père de votre meilleur ami »
**Tension** — Conflit d'intérêts immédiat en pleine action.
**Angle distinctif** — Découverte du lien pendant l'intervention.
**Poids fort** — Se déporter et faire reprendre par un autre agent.

#### 312 — `deonto-argent-trouve-lors-intervention` ✅
**Thème** `deontologie` · **facile** · gratuit · *appartement, 14 h*
**Titre** — « Une liasse dans un tiroir, personne ne l'a vue à part vous »
**Tension** — Absence de témoin, tentation ou simple négligence.
**Angle distinctif** — Probité en l'absence totale de contrôle.
**Poids fort** — Signaler et faire constater par un tiers.

#### 313 — `deonto-objet-saisi-mal-enregistre` ✅
**Thème** `deontologie` · **moyen** · premium · *service, 10 h*
**Titre** — « Le registre ne correspond pas à ce que vous avez vu saisir »
**Tension** — Erreur ou irrégularité, difficile à trancher.
**Angle distinctif** — Anomalie administrative aux conséquences lourdes.
**Poids fort** — Signaler l'écart sans accuser personne.

#### 314 — `deonto-comportement-deplace-envers-usagere` ✅
**Thème** `deontologie` · **difficile** · premium · *commissariat, 16 h*
**Titre** — « Les remarques de votre collègue mettent la plaignante mal à l'aise »
**Tension** — Comportement sans geste, mais dégradant l'accueil.
**Angle distinctif** — Atteinte à la dignité par les propos, pas par l'acte.
**Poids fort** — Interrompre et reprendre l'accueil soi-même.

#### 315 — `deonto-alcool-avant-prise-de-service` ✅
**Thème** `deontologie` · **difficile** · premium · *service, 5 h 45*
**Titre** — « Vous sentez l'alcool sur votre équipier avant de partir en patrouille »
**Tension** — Danger immédiat pour lui, vous et le public.
**Angle distinctif** — Risque opérationnel direct lié à un collègue.
**Poids fort** — Empêcher la prise de service et rendre compte.

#### 316 — `deonto-faute-dissimulee-par-un-collegue` ✅
**Thème** `deontologie` · **difficile** · premium · *service, 22 h*
**Titre** — « Il vous demande de dire que vous étiez ensemble »
**Tension** — Sollicitation d'un mensonge par amitié.
**Angle distinctif** — Demande de couverture explicite.
**Poids fort** — Refuser sans transformer cela en dénonciation immédiate.

#### 317 — `deonto-relation-avec-un-journaliste` ✅
**Thème** `deontologie` · **moyen** · premium · *café, 18 h*
**Titre** — « Il propose un échange de bons procédés sur une affaire en cours »
**Tension** — Bénéfice apparent, manquement au secret.
**Angle distinctif** — Sollicitation extérieure organisée.
**Poids fort** — Refuser et rendre compte de la sollicitation.

#### 318 — `deonto-photographie-dans-un-service` ✅
**Thème** `deontologie` · **facile** · gratuit · *locaux, 13 h*
**Titre** — « La photo de groupe montre un écran resté allumé »
**Tension** — Intention anodine, conséquence potentiellement grave.
**Angle distinctif** — Fuite involontaire par négligence.
**Poids fort** — Faire supprimer et signaler la fuite potentielle.

#### 319 — `deonto-favoritisme-envers-un-connaissance` ✅
**Thème** `deontologie` · **moyen** · premium · *voie publique, 15 h*
**Titre** — « Votre collègue renonce à verbaliser en reconnaissant le conducteur »
**Tension** — Rupture d'égalité devant la loi, geste discret.
**Angle distinctif** — Favoritisme constaté chez un collègue.
**Poids fort** — Nommer la rupture d'égalité, pas seulement l'écart de procédure.

#### 320 — `deonto-consultation-fichier-curiosite-personnelle` ✅
**Thème** `deontologie` · **moyen** · premium · *service, 11 h*
**Titre** — « Il tape le nom de son nouveau voisin devant vous »
**Tension** — Geste banalisé, sans intention de nuire apparente.
**Angle distinctif** — Consultation par curiosité, cf. 017 (sollicitation extérieure).
**Poids fort** — Réagir malgré l'absence d'intention malveillante.

#### 321 — `deonto-usage-reseaux-sociaux-photo-uniforme` ✅
**Thème** `deontologie` · **facile** · gratuit · *espace numérique, 20 h*
**Titre** — « Sa photo de profil en tenue cumule des commentaires politiques »
**Tension** — Vie privée et devoir de réserve, frontière floue.
**Angle distinctif** — Publication personnelle, cf. 003 et 018.
**Poids fort** — Identifier l'atteinte au devoir de réserve.

#### 322 — `deonto-conflit-interets-activite-privee` ✅
**Thème** `deontologie` · **moyen** · premium · *hors service, 19 h*
**Titre** — « Il exerce une activité de sécurité privée le week-end »
**Tension** — Cumul d'activités et risque de confusion des rôles.
**Angle distinctif** — Question de cumul, hors action opérationnelle.
**Poids fort** — Identifier le risque de confusion des qualités.

#### 323 — `deonto-divulgation-information-a-un-proche` ✅
**Thème** `deontologie` · **moyen** · premium · *repas de famille, 21 h*
**Titre** — « On vous demande si l'accident du village a fait des victimes »
**Tension** — Contexte familial anodin, information couverte.
**Angle distinctif** — Cadre privé et pression affective légère.
**Poids fort** — Ne rien divulguer, même sur un fait connu localement.

#### 324 — `deonto-temoin-d-un-manquement-ancien` ✅
**Thème** `deontologie` · **difficile** · premium · *service, 16 h*
**Titre** — « Vous apprenez un fait grave survenu il y a deux ans »
**Tension** — Ancienneté et loyauté contre obligation de signalement.
**Angle distinctif** — Temporalité : faut-il encore signaler ?
**Poids fort** — Signaler malgré l'ancienneté des faits.

#### 325 — `deonto-refus-d-enregistrer-une-plainte-constate` ✅
**Thème** `deontologie` · **difficile** · premium · *accueil, 15 h*
**Titre** — « Votre collègue décourage un plaignant devant vous »
**Tension** — Manquement au droit de l'usager, en direct.
**Angle distinctif** — Faute par abstention envers le public.
**Poids fort** — Reprendre l'accueil et garantir le droit du plaignant.

#### 326 — `deonto-utilisation-vehicule-service-personnel` ✅
**Thème** `deontologie` · **facile** · gratuit · *voie publique, 14 h*
**Titre** — « Un crochet par la pharmacie pendant la patrouille »
**Tension** — Écart mineur en apparence, cumul de principes en jeu.
**Angle distinctif** — Usage des moyens du service.
**Poids fort** — Identifier l'usage détourné même minime.

#### 327 — `deonto-propos-envers-une-personne-interpellee` ✅
**Thème** `deontologie` · **moyen** · premium · *véhicule de service, 23 h*
**Titre** — « Les remarques continuent pendant tout le trajet »
**Tension** — Personne captive, humiliation sans violence physique.
**Angle distinctif** — Atteinte à la dignité en huis clos.
**Poids fort** — Faire cesser et signaler, malgré l'absence de témoin extérieur.

#### 328 — `deonto-information-donnee-a-un-avocat-hors-cadre` ✅
**Thème** `deontologie` · **moyen** · premium · *commissariat, 17 h*
**Titre** — « Il insiste courtoisement pour connaître l'avancement du dossier »
**Tension** — Interlocuteur légitime mais demande hors cadre.
**Angle distinctif** — Sollicitation par un professionnel du droit.
**Poids fort** — Renvoyer vers le cadre approprié sans discourtoisie.

#### 329 — `deonto-collegue-en-difficulte-personnelle-manquements` ✅
**Thème** `deontologie` · **difficile** · premium · *service, 12 h*
**Titre** — « Ses oublis se multiplient depuis sa séparation »
**Tension** — Solidarité humaine contre sécurité du service.
**Angle distinctif** — Manquements liés à une souffrance personnelle.
**Poids fort** — Concilier soutien au collègue et signalement du risque.

#### 330 — `deonto-invitation-evenement-par-une-entreprise` ✅
**Thème** `deontologie` · **facile** · gratuit · *hors service, 19 h*
**Titre** — « Une place en tribune offerte par une société de sécurité »
**Tension** — Invitation valorisante, lien professionnel indirect.
**Angle distinctif** — Avantage en nature d'un partenaire économique.
**Poids fort** — Refuser au regard du lien professionnel.

#### 331 — `deonto-partialite-envers-une-partie` ✅
**Thème** `deontologie` · **moyen** · premium · *intervention, 18 h*
**Titre** — « Le ton change nettement selon la personne à qui il s'adresse »
**Tension** — Partialité perceptible, difficile à qualifier formellement.
**Angle distinctif** — Impartialité dans le comportement, pas dans l'acte.
**Poids fort** — Rétablir l'équilibre du traitement sur place.

#### 332 — `deonto-secret-partage-avec-un-autre-service` ✅
**Thème** `deontologie` · **moyen** · premium · *réunion, 10 h*
**Titre** — « Un partenaire demande des éléments sur une famille suivie »
**Tension** — Coopération utile contre limites du partage d'informations.
**Angle distinctif** — Partage interinstitutionnel et ses bornes.
**Poids fort** — Partager le strict nécessaire et pas au-delà.

#### 333 — `deonto-refus-de-porter-assistance-hors-service` ✅
**Thème** `deontologie` · **difficile** · premium · *rue, hors service, 20 h*
**Titre** — « Vous êtes en civil, une agression se déroule à vingt mètres »
**Tension** — Devoir d'assistance contre absence de moyens et de tenue.
**Angle distinctif** — Situation hors service, sans équipement.
**Poids fort** — Alerter et agir dans la limite de ses moyens réels.

#### 334 — `deonto-usage-tutoiement-et-familiarite` ✅
**Thème** `deontologie` · **facile** · gratuit · *contrôle, 16 h*
**Titre** — « Le tutoiement s'installe dès les premiers mots »
**Tension** — Habitude banalisée, atteinte au respect dû.
**Angle distinctif** — Registre de langage comme marqueur de considération.
**Poids fort** — Maintenir un registre respectueux, y compris avec les habitués.

#### 335 — `deonto-collegue-refuse-d-intervenir-par-lassitude` ✅
**Thème** `deontologie` · **moyen** · premium · *véhicule, 3 h*
**Titre** — « Il propose de passer sans s'arrêter, c'est encore les mêmes »
**Tension** — Usure professionnelle conduisant à l'abstention.
**Angle distinctif** — Manquement par lassitude, cf. 147 (fugues répétées).
**Poids fort** — Intervenir malgré la répétition et le décourager de passer.

#### 336 — `deonto-utilisation-image-intervention-formation` ✅
**Thème** `deontologie` · **moyen** · premium · *service, 14 h*
**Titre** — « La vidéo servirait à former les nouveaux, sans floutage »
**Tension** — Finalité légitime, protection des personnes filmées négligée.
**Angle distinctif** — Bonne intention avec traitement de données irrégulier.
**Poids fort** — Exiger la protection des personnes malgré la finalité utile.

#### 337 — `deonto-signalement-d-un-superieur` ✅
**Thème** `deontologie` · **expert** · premium · *service, 11 h*
**Titre** — « Le manquement vient de celui à qui vous devriez le signaler »
**Tension** — Voie hiérarchique impraticable, isolement du signalant.
**Angle distinctif** — Le supérieur est le mis en cause.
**Poids fort** — Identifier une voie de signalement alternative.

#### 338 — `deonto-pression-des-collegues-apres-signalement` ✅
**Thème** `deontologie` · **expert** · premium · *service, 8 h*
**Titre** — « Depuis votre rapport, plus personne ne vous adresse la parole »
**Tension** — Coût social du signalement, tentation du retrait.
**Angle distinctif** — Après-coup du signalement, rare dans les catalogues.
**Poids fort** — Maintenir sa position et signaler l'isolement subi.

#### 339 — `deonto-erreur-personnelle-a-assumer` ✅
**Thème** `deontologie` · **difficile** · premium · *service, 16 h*
**Titre** — « Vous réalisez que votre erreur a retardé une prise en charge »
**Tension** — Assumer sa propre faute sans se dérober.
**Angle distinctif** — Le candidat est lui-même l'auteur du manquement.
**Poids fort** — Déclarer son erreur spontanément et rapidement.

#### 340 — `deonto-sollicitation-pour-eviter-une-verbalisation` ✅
**Thème** `deontologie` · **facile** · gratuit · *contrôle routier, 15 h*
**Titre** — « Il évoque ses relations et sort une carte professionnelle »
**Tension** — Tentative d'influence par le statut.
**Angle distinctif** — Pression par la qualité invoquée de la personne.
**Poids fort** — Traiter identiquement quelle que soit la qualité invoquée.

#### 341 — `deonto-exemplarite-comportement-prive` ✅
**Thème** `deontologie` · **moyen** · premium · *hors service, 22 h*
**Titre** — « Un incident dans un bar, il annonce sa qualité pour calmer le jeu »
**Tension** — Usage de la qualité hors service pour un intérêt personnel.
**Angle distinctif** — Comportement privé engageant l'institution.
**Poids fort** — Identifier l'usage abusif de la qualité.

---

## BLOC N — TRAVAIL EN ÉQUIPE ET HIÉRARCHIE (342 → 359) · 18 cas ✅ **BLOC COMPLET**

> Thème `equipe-hierarchie`. Thème vide à ce jour. Centrer sur la communication
> interne, l'encadrement et la sécurité collective — sans recouper le bloc
> déontologie, qui traite les manquements.

#### 342 — `equipe-desaccord-entre-equipiers-sur-place` ✅
**Thème** `equipe-hierarchie` · **moyen** · gratuit · *intervention, 17 h*
**Titre** — « Vous n'êtes pas d'accord sur la conduite à tenir, devant les usagers »
**Tension** — Désaccord légitime exprimé au mauvais moment.
**Angle distinctif** — Divergence professionnelle, pas faute.
**Poids fort** — Ne pas afficher le désaccord devant le public.

#### 343 — `equipe-instruction-mal-comprise` ✅
**Thème** `equipe-hierarchie` · **facile** · gratuit · *briefing, 6 h*
**Titre** — « Il a compris l'inverse de la consigne et est déjà parti »
**Tension** — Malentendu aux conséquences opérationnelles.
**Angle distinctif** — Défaut de transmission, pas de mauvaise volonté.
**Poids fort** — Faire reformuler les consignes plutôt que supposer.

#### 344 — `equipe-collegue-inexperimente-en-difficulte` ✅
**Thème** `equipe-hierarchie` · **facile** · gratuit · *intervention, 14 h*
**Titre** — « Il reste figé pendant que la situation évolue »
**Tension** — Encadrer sans humilier, en pleine action.
**Angle distinctif** — Accompagnement d'un débutant, cf. 024.
**Poids fort** — Donner des consignes simples et immédiates.

#### 345 — `equipe-retard-repete-prise-de-service` ✅
**Thème** `equipe-hierarchie` · **facile** · gratuit · *service, 6 h 15*
**Titre** — « Troisième retard de la semaine, l'équipe commence à en parler »
**Tension** — Solidarité contre équité envers le reste de l'équipe.
**Angle distinctif** — Discipline de service, dimension collective.
**Poids fort** — Aborder le sujet directement avant qu'il ne s'envenime.

#### 346 — `equipe-erreur-de-transmission-radio` ✅
**Thème** `equipe-hierarchie` · **moyen** · premium · *intervention, 20 h*
**Titre** — « L'adresse transmise n'est pas celle où vous êtes »
**Tension** — Erreur en cours d'intervention, effets en chaîne.
**Angle distinctif** — Défaillance de la chaîne d'information.
**Poids fort** — Corriger immédiatement et vérifier la bonne réception.

#### 347 — `equipe-information-non-communiquee-releve` ✅
**Thème** `equipe-hierarchie` · **moyen** · premium · *relève, 13 h*
**Titre** — « L'équipe précédente n'a pas signalé la personne recherchée »
**Tension** — Conséquences opérationnelles d'une transmission incomplète.
**Angle distinctif** — Continuité entre équipes successives.
**Poids fort** — Formaliser la transmission plutôt que blâmer.

#### 348 — `equipe-chef-injoignable-urgence` ✅
**Thème** `equipe-hierarchie` · **difficile** · premium · *intervention, 2 h*
**Titre** — « Décision à prendre maintenant, personne ne répond »
**Tension** — Prendre une décision au-delà de son niveau habituel.
**Angle distinctif** — Autonomie contrainte par l'absence hiérarchique.
**Poids fort** — Décider, tracer, et rendre compte dès que possible.

#### 349 — `equipe-ordre-incomplet-ambigu` ✅
**Thème** `equipe-hierarchie` · **moyen** · premium · *service, 9 h*
**Titre** — « La consigne peut se comprendre de deux façons opposées »
**Tension** — Interpréter au risque de se tromper, ou demander au risque de retarder.
**Angle distinctif** — Ambiguïté de l'ordre, pas illégalité (cf. 309).
**Poids fort** — Faire préciser plutôt qu'interpréter.

#### 350 — `equipe-changement-de-mission-en-cours` ✅
**Thème** `equipe-hierarchie` · **moyen** · gratuit · *patrouille, 16 h*
**Titre** — « Vous êtes redéployés alors qu'une victime vous attend »
**Tension** — Nouvel ordre contre engagement pris auprès d'une personne.
**Angle distinctif** — Conflit entre priorité hiérarchique et engagement pris.
**Poids fort** — Signaler l'engagement en cours avant de basculer.

#### 351 — `equipe-collegue-blesse-en-intervention` ✅
**Thème** `equipe-hierarchie` · **difficile** · premium · *voie publique, 22 h*
**Titre** — « Il saigne mais veut continuer l'intervention »
**Tension** — Volonté du collègue contre nécessité de le faire soigner.
**Angle distinctif** — Prise en charge d'un pair blessé.
**Poids fort** — Imposer la prise en charge médicale.

#### 352 — `equipe-collegue-en-etat-de-stress-post-intervention` ✅
**Thème** `equipe-hierarchie` · **difficile** · premium · *retour de service, 4 h*
**Titre** — « Il répète la même phrase depuis une heure »
**Tension** — Détresse d'un pair, réticence à en parler.
**Angle distinctif** — Santé psychologique dans l'équipe.
**Poids fort** — Ne pas laisser seul et orienter vers un soutien.

#### 353 — `equipe-comportement-dangereux-d-un-equipier` ✅
**Thème** `equipe-hierarchie` · **difficile** · premium · *véhicule, 19 h*
**Titre** — « Sa conduite en intervention met le binôme en danger »
**Tension** — Sécurité immédiate contre relation de travail.
**Angle distinctif** — Risque opérationnel, pas manquement déontologique.
**Poids fort** — Faire cesser immédiatement et en parler après.

#### 354 — `equipe-compte-rendu-conteste-par-la-hierarchie` ✅
**Thème** `equipe-hierarchie` · **moyen** · premium · *bureau, 15 h*
**Titre** — « On vous demande de reformuler un passage que vous jugez exact »
**Tension** — Ligne entre reformulation légitime et altération.
**Angle distinctif** — Nuance avec 308 et 309 : la demande peut être légitime.
**Poids fort** — Distinguer reformulation de forme et altération de fond.

#### 355 — `equipe-mauvaise-coordination-entre-services` ✅
**Thème** `equipe-hierarchie` · **moyen** · premium · *intervention conjointe, 11 h*
**Titre** — « Deux équipages arrivent avec des consignes contradictoires »
**Tension** — Confusion sur place, devant le public.
**Angle distinctif** — Coordination inter-services défaillante.
**Poids fort** — Faire trancher par l'autorité compétente sans improviser.

#### 356 — `equipe-nouvel-arrivant-integration-difficile` ✅
**Thème** `equipe-hierarchie` · **facile** · gratuit · *service, 8 h*
**Titre** — « Personne ne lui adresse la parole depuis trois semaines »
**Tension** — Mise à l'écart informelle, effet sur la sécurité collective.
**Angle distinctif** — Cohésion d'équipe et conséquences opérationnelles.
**Poids fort** — Rompre l'isolement, y compris à contre-courant du groupe.

#### 357 — `equipe-repartition-inequitable-des-taches` ✅
**Thème** `equipe-hierarchie` · **facile** · gratuit · *service, 10 h*
**Titre** — « Les mêmes héritent systématiquement des missions ingrates »
**Tension** — Sentiment d'injustice affectant le climat de travail.
**Angle distinctif** — Équité interne dans l'organisation.
**Poids fort** — Signaler par la voie appropriée sans créer un clan.

#### 358 — `equipe-desaccord-sur-qualification-des-faits` ✅
**Thème** `equipe-hierarchie` · **moyen** · premium · *service, 17 h*
**Titre** — « Votre collègue et vous ne retenez pas la même analyse »
**Tension** — Divergence professionnelle de fond, à trancher correctement.
**Angle distinctif** — Débat technique entre pairs.
**Poids fort** — En référer à l'autorité compétente plutôt qu'imposer son avis.

#### 359 — `equipe-briefing-incomplet-avant-mission` ✅
**Thème** `equipe-hierarchie` · **moyen** · premium · *avant dispositif, 13 h*
**Titre** — « Vous partez sans savoir qui coordonne ni sur quelle fréquence »
**Tension** — Départ en mission avec un cadre flou.
**Angle distinctif** — Défaut de préparation en amont.
**Poids fort** — Poser les questions manquantes avant le départ.

---

## BLOC O — PERSONNES VULNÉRABLES (360 → 380) · 21 cas ✅ **BLOC COMPLET** (22/22 avec 026)

> Thème `personnes-vulnerables`. Le cas 026 couvre déjà la personne âgée
> désorientée. Varier les formes de vulnérabilité : âge, handicap, isolement,
> précarité, dépendance, statut juridique.

#### 360 — `vuln-personne-sans-domicile-refus-d-aide` ✅
**Thème** `personnes-vulnerables` · **moyen** · gratuit · *porche d'immeuble, 23 h, -2 °C*
**Titre** — « Il refuse la maraude pour la troisième nuit consécutive »
**Tension** — Autonomie de la personne contre risque vital par le froid.
**Angle distinctif** — Refus répété et assumé d'une aide disponible.
**Poids fort** — Respecter le refus tout en réévaluant le risque vital.

#### 361 — `vuln-personne-handicapee-victime-de-vol` ✅
**Thème** `personnes-vulnerables` · **moyen** · premium · *arrêt de bus, 17 h*
**Titre** — « Son fauteuil a été renversé pour lui prendre son sac »
**Tension** — Vulnérabilité aggravante, impossibilité de se défendre ou fuir.
**Angle distinctif** — Handicap moteur et atteinte aux biens avec violence.
**Poids fort** — Adapter l'accueil et la prise en charge au handicap.

#### 362 — `vuln-personne-troubles-psychiques-errance` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *centre-ville, 4 h*
**Titre** — « Il parle seul et suit les passants sans les toucher »
**Tension** — Aucune infraction, personne manifestement en difficulté.
**Angle distinctif** — Vulnérabilité psychique sans danger immédiat, cf. bloc P.
**Poids fort** — Solliciter un avis médical plutôt qu'une réponse policière.

#### 363 — `vuln-personne-sous-tutelle-exploitee` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *appartement, 15 h*
**Titre** — « Un voisin encaisse ses allocations depuis huit mois »
**Tension** — Abus de faiblesse, victime attachée à son « ami ».
**Angle distinctif** — Exploitation financière d'un majeur protégé.
**Poids fort** — Caractériser l'abus malgré le déni de la victime.

#### 364 — `vuln-victime-ne-sachant-pas-lire` ✅
**Thème** `personnes-vulnerables` · **facile** · gratuit · *commissariat, 14 h*
**Titre** — « Il signe sans pouvoir relire ce qu'il a déclaré »
**Tension** — Validité et loyauté de l'acte, dignité de la personne.
**Angle distinctif** — Illettrisme au moment de la signature, cf. 052.
**Poids fort** — Faire relire à voix haute et s'assurer de la compréhension.

#### 365 — `vuln-personne-etrangere-isolee-sans-recours` ✅
**Thème** `personnes-vulnerables` · **moyen** · premium · *commissariat, 18 h*
**Titre** — « Elle est arrivée il y a deux mois et ne connaît personne »
**Tension** — Isolement total, méfiance envers les institutions.
**Angle distinctif** — Isolement social et culturel.
**Poids fort** — Orienter vers des relais adaptés et instaurer la confiance.

#### 366 — `vuln-suspicion-traite-des-etres-humains` ✅
**Thème** `personnes-vulnerables` · **expert** · premium · *salon de manucure, 16 h*
**Titre** — « Elles répondent toutes la même chose, mot pour mot »
**Tension** — Indices d'exploitation, victimes qui se déclarent consentantes.
**Angle distinctif** — Repérage d'un réseau derrière une activité licite.
**Poids fort** — Repérer les indices et isoler les personnes pour les entendre.

#### 367 — `vuln-personne-agee-isolee-negligence-familiale` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *domicile, 11 h*
**Titre** — « Le logement est insalubre, la famille dit passer chaque semaine »
**Tension** — Négligence sans violence, versions contradictoires.
**Angle distinctif** — Maltraitance par omission, cf. 106 (violences actives).
**Poids fort** — Constater objectivement l'état sans accuser.

#### 368 — `vuln-personne-en-detresse-refuse-hopital` ✅
**Thème** `personnes-vulnerables` · **moyen** · premium · *voie publique, 21 h*
**Titre** — « Elle dit préférer rester dehors qu'être enfermée »
**Tension** — Refus fondé sur une expérience passée, risque réel.
**Angle distinctif** — Refus motivé par la méfiance institutionnelle.
**Poids fort** — Comprendre le motif du refus avant d'insister.

#### 369 — `vuln-enfant-tres-jeune-sans-adulte-rue` ✅
**Thème** `personnes-vulnerables` · **moyen** · gratuit · *rue résidentielle, 7 h 30*
**Titre** — « Trois ans, en pyjama, sur le trottoir »
**Tension** — Urgence absolue, origine inconnue, danger de la circulation.
**Angle distinctif** — Très jeune enfant seul en extérieur, cf. 129 (centre commercial).
**Poids fort** — Mise en sécurité immédiate avant toute recherche.

#### 370 — `vuln-personne-sourde-victime-agression` ✅
**Thème** `personnes-vulnerables` · **moyen** · premium · *voie publique, 20 h*
**Titre** — « Elle n'a pas entendu l'agresseur arriver et ne peut pas le décrire »
**Tension** — Recueil du signalement entravé par le handicap sensoriel.
**Angle distinctif** — Handicap affectant le témoignage lui-même.
**Poids fort** — Adapter le recueil sans réduire sa portée.

#### 371 — `vuln-personne-sous-emprise-sectaire` ✅
**Thème** `personnes-vulnerables` · **expert** · premium · *commissariat, 15 h*
**Titre** — « Sa famille signale une rupture totale et des dons répétés »
**Tension** — Majeur libre de ses choix, indices d'emprise et d'abus.
**Angle distinctif** — Emprise non conjugale, cf. 102.
**Poids fort** — Distinguer choix personnel et abus de faiblesse.

#### 372 — `vuln-personne-agee-victime-abus-de-confiance-aidant` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *domicile, 10 h*
**Titre** — « L'aide à domicile fait aussi les courses et garde la carte bancaire »
**Tension** — Relation de confiance nécessaire, dérive financière probable.
**Angle distinctif** — Auteur dans un rôle d'aide légitime.
**Poids fort** — Documenter les mouvements sans priver la personne de son aide.

#### 373 — `vuln-personne-ayant-besoin-de-soins-urgents-refus-famille` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *domicile, 19 h*
**Titre** — « La famille s'oppose aux soins pour des raisons personnelles »
**Tension** — Volonté familiale contre intérêt vital de la personne.
**Angle distinctif** — Opposition d'un tiers, cf. 092 et 301.
**Poids fort** — Faire primer l'avis médical sur l'opposition familiale.

#### 374 — `vuln-mineur-aidant-familial` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *appartement, 17 h*
**Titre** — « Il a onze ans et s'occupe seul de sa mère malade »
**Tension** — Enfant en charge d'adulte, situation invisible depuis des mois.
**Angle distinctif** — Double vulnérabilité, enfant et parent.
**Poids fort** — Signaler la situation de l'enfant sans le culpabiliser.

#### 375 — `vuln-personne-precaire-verbalisation-repetee` ✅
**Thème** `personnes-vulnerables` · **moyen** · premium · *gare, 9 h*
**Titre** — « Douze procédures pour les mêmes faits en un an »
**Tension** — Réponse répressive inopérante face à une situation sociale.
**Angle distinctif** — Limites de la réponse pénale face à la précarité.
**Poids fort** — Privilégier l'orientation sociale à la réponse automatique.

#### 376 — `vuln-personne-victime-de-son-entourage-de-quartier` ✅
**Thème** `personnes-vulnerables` · **moyen** · premium · *immeuble, 20 h*
**Titre** — « Les jeunes du hall se servent chez lui et l'appellent leur oncle »
**Tension** — Victime niant être victime, relation ambiguë installée.
**Angle distinctif** — Exploitation quotidienne banalisée par la victime.
**Poids fort** — Caractériser l'abus malgré la présentation amicale.

#### 377 — `vuln-personne-agee-perdue-la-nuit-en-zone-rurale` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *route de campagne, 23 h*
**Titre** — « Elle marche sur la départementale en chemise de nuit »
**Tension** — Hypothermie, circulation, désorientation.
**Angle distinctif** — Milieu rural nocturne, cf. 026 (centre commercial de jour).
**Poids fort** — Mise à l'abri thermique immédiate.

#### 378 — `vuln-personne-handicapee-mentale-accusee-a-tort` ✅
**Thème** `personnes-vulnerables` · **difficile** · premium · *commerce, 15 h*
**Titre** — « Il répond oui à toutes les questions qu'on lui pose »
**Tension** — Suggestibilité conduisant à des aveux non fiables.
**Angle distinctif** — Vulnérabilité affectant la fiabilité des déclarations.
**Poids fort** — Ne pas exploiter des déclarations obtenues par suggestion.

#### 379 — `vuln-personne-en-fin-de-droits-detresse-au-guichet` ✅
**Thème** `personnes-vulnerables` · **moyen** · gratuit · *commissariat, 16 h*
**Titre** — « Il vient au commissariat parce qu'il ne sait plus où aller »
**Tension** — Demande hors compétence, détresse réelle.
**Angle distinctif** — Le commissariat comme dernier recours social.
**Poids fort** — Ne pas renvoyer sans orientation concrète.

#### 380 — `vuln-victime-vulnerable-refuse-l-aide-proposee` ✅
**Thème** `personnes-vulnerables` · **moyen** · premium · *domicile, 14 h*
**Titre** — « Elle remercie poliment et referme la porte à chaque visite »
**Tension** — Refus réitéré, situation qui se dégrade lentement.
**Angle distinctif** — Refus courtois et persistant, sans crise.
**Poids fort** — Maintenir le lien et signaler la dégradation.

---

## BLOC P — SANTÉ MENTALE, CRISE ET DÉTRESSE (381 → 400) · 20 cas ✅ **BLOC COMPLET**

> Thème `secours-personnes`. Les cas 001 et 016 couvrent déjà l'accident
> corporel et la crise suicidaire derrière une porte close. Ne jamais poser de
> diagnostic : le policier constate, protège et fait intervenir les soignants.

#### 381 — `sante-crise-de-panique-lieu-public` ✅
**Thème** `secours-personnes` · **facile** · gratuit · *métro, 8 h 30*
**Titre** — « Elle suffoque sur le quai et dit qu'elle va mourir »
**Tension** — Détresse impressionnante, souvent confondue avec une urgence vitale.
**Angle distinctif** — Crise d'angoisse aiguë, prise en charge par le calme.
**Poids fort** — Rassurer et faire évaluer sans dramatiser.

#### 382 — `sante-propos-incoherents-voie-publique` ✅
**Thème** `secours-personnes` · **moyen** · premium · *place, 14 h*
**Titre** — « Il affirme être suivi et vous demande de le protéger »
**Tension** — Récit délirant, demande d'aide sincère, aucun danger objectif.
**Angle distinctif** — Prise au sérieux de la demande sans valider le contenu.
**Poids fort** — Ne pas contredire ni conforter le délire.

#### 383 — `sante-personne-menace-de-se-blesser-avec-un-objet` ✅
**Thème** `secours-personnes` · **moyen ** · premium · *domicile, 19 h*
**Titre** — « Il tient un tesson contre son avant-bras et recule quand vous avancez »
**Tension** — Toute approche aggrave, mais l'attente aussi.
**Angle distinctif** — Auto-agression avec objet, en intérieur.
**Poids fort** — Maintenir la distance et engager le dialogue.

#### 384 — `sante-traitement-interrompu-decompensation` ✅
**Thème** `secours-personnes` · **moyen** · premium · *appartement, 11 h*
**Titre** — « Sa sœur explique qu'il a arrêté son traitement il y a trois semaines »
**Tension** — Information médicale fournie par un tiers, personne opposée.
**Angle distinctif** — Rupture de soins connue de l'entourage.
**Poids fort** — Transmettre l'information aux soignants sans la commenter.

#### 385 — `sante-famille-demande-hospitalisation-forcee` ✅
**Thème** `secours-personnes` · **moyen ** · premium · *pavillon, 16 h*
**Titre** — « La famille vous demande de l'emmener, il refuse catégoriquement »
**Tension** — Attente familiale d'un pouvoir que le policier n'a pas seul.
**Angle distinctif** — Demande d'un acte relevant d'une décision médicale.
**Poids fort** — Expliquer le cadre et faire intervenir un médecin.

#### 386 — `sante-personne-prostree-decouverte` ✅
**Thème** `secours-personnes` · **moyen** · gratuit · *cage d'escalier, 6 h*
**Titre** — « Assise, immobile, elle ne réagit à aucune parole »
**Tension** — Cause inconnue : sidération, intoxication, trouble, agression ?
**Angle distinctif** — Absence totale de réaction et d'information.
**Poids fort** — Ne rien présumer et faire évaluer médicalement.

#### 387 — `sante-danger-immediat-pour-autrui` ✅
**Thème** `secours-personnes` · **expert** · premium · *appartement, 22 h*
**Titre** — « Il menace sa voisine qu'il dit être à l'origine de ses souffrances »
**Tension** — Personne malade et dangereuse pour un tiers identifié.
**Angle distinctif** — Protection d'un tiers désigné par le délire.
**Poids fort** — Protéger le tiers désigné en priorité.

#### 388 — `sante-appel-repete-meme-personne` ✅
**Thème** `secours-personnes` · **moyen** · premium · *domicile, 3 h*
**Titre** — « Cinquième appel du mois, jamais rien de constaté »
**Tension** — Lassitude possible face à une détresse réelle mais répétitive.
**Angle distinctif** — Risque de banalisation, cf. 084 et 147.
**Poids fort** — Traiter avec le même sérieux qu'au premier appel.

#### 389 — `sante-adolescent-scarifications-decouvertes` ✅
**Thème** `secours-personnes` · **difficile** · premium · *lycée, 10 h*
**Titre** — « L'infirmière scolaire alerte, l'élève minimise »
**Tension** — Mineur en souffrance, minimisation, parents à informer.
**Angle distinctif** — Automutilation chez un mineur en cadre scolaire.
**Poids fort** — Assurer le relais médical et la protection du mineur.

#### 390 — `sante-personne-agressive-en-service-d-urgence` ✅
**Thème** `secours-personnes` · **moyen** · premium · *urgences, 2 h*
**Titre** — « Le personnel demande son expulsion, il attend depuis six heures »
**Tension** — Exaspération compréhensible, personne peut-être malade.
**Angle distinctif** — Agressivité née de l'attente médicale, cf. 096.
**Poids fort** — Apaiser sans traiter la personne comme un simple perturbateur.

#### 391 — `sante-intervention-conjointe-samu-pompiers` ✅
**Thème** `secours-personnes` · **moyen** · premium · *domicile, 20 h*
**Titre** — « Trois services sur place, personne ne pilote »
**Tension** — Coordination défaillante devant une personne en crise.
**Angle distinctif** — Multi-intervenants, cf. 355 (inter-services police).
**Poids fort** — Clarifier les rôles et laisser la main au médical.

#### 392 — `sante-personne-refuse-tout-contact-verbal` ✅
**Thème** `secours-personnes` · **moyen ** · premium · *appartement, 18 h*
**Titre** — « Elle se bouche les oreilles dès que vous parlez »
**Tension** — Impossibilité d'établir le contact, temps qui passe.
**Angle distinctif** — Communication verbale totalement inopérante.
**Poids fort** — Réduire les stimuli plutôt qu'insister.

#### 393 — `sante-suspicion-intoxication-medicamenteuse` ✅
**Thème** `secours-personnes` · **difficile** · premium · *chambre étudiante, 23 h*
**Titre** — « Des plaquettes vides sur le bureau, elle dit avoir mal dormi »
**Tension** — Minimisation par la personne, urgence vitale potentielle.
**Angle distinctif** — Intoxication dissimulée derrière une explication banale.
**Poids fort** — Faire intervenir les secours malgré les dénégations.

#### 394 — `sante-personne-en-crise-avec-enfant-present` ✅
**Thème** `secours-personnes` · **difficile** · premium · *appartement, 17 h*
**Titre** — « Sa fille de six ans lui tient la main et pleure »
**Tension** — Prise en charge du parent et protection de l'enfant.
**Angle distinctif** — Enfant présent lors d'une crise parentale, cf. 071.
**Poids fort** — Prendre en charge l'enfant sans rompre brutalement le lien.

#### 395 — `sante-personne-alcoolisee-propos-suicidaires` ✅
**Thème** `secours-personnes` · **moyen ** · premium · *voie publique, 1 h*
**Titre** — « Il dit que de toute façon plus rien n'a d'importance »
**Tension** — Tentation d'attribuer les propos à l'alcool.
**Angle distinctif** — Risque masqué par l'alcoolisation.
**Poids fort** — Ne pas écarter les propos au motif de l'alcool.

#### 396 — `sante-decouverte-personne-decedee-domicile` ✅
**Thème** `secours-personnes` · **difficile** · premium · *appartement, 12 h*
**Titre** — « Le fils a forcé la porte et attend sur le palier »
**Tension** — Préserver les lieux tout en accompagnant un proche en état de choc.
**Angle distinctif** — Décès et prise en charge de la famille.
**Poids fort** — Préserver la scène sans négliger le proche.

#### 397 — `sante-personne-appelle-pour-un-tiers-inquiet` ✅
**Thème** `secours-personnes` · **moyen** · premium · *commissariat, 21 h*
**Titre** — « Son collègue lui a envoyé un message d'adieu il y a une heure »
**Tension** — Personne à localiser rapidement à partir d'éléments minces.
**Angle distinctif** — Alerte par un tiers non familial, urgence de localisation.
**Poids fort** — Engager la localisation sans attendre de certitude.

#### 398 — `sante-personne-agee-syndrome-de-glissement` ✅
**Thème** `secours-personnes` · **moyen** · premium · *domicile, 15 h*
**Titre** — « Depuis le décès de son épouse, elle ne se lève plus »
**Tension** — Détresse lente, sans urgence apparente mais réelle.
**Angle distinctif** — Détresse progressive du grand âge après un deuil.
**Poids fort** — Reconnaître la gravité malgré l'absence de crise visible.

#### 399 — `sante-personne-en-crise-refuse-les-soins-apres-evaluation` ✅
**Thème** `secours-personnes` · **moyen ** · premium · *domicile, 19 h*
**Titre** — « Le médecin conclut qu'elle peut rester, la famille s'y oppose »
**Tension** — Décision médicale contestée par l'entourage.
**Angle distinctif** — Après l'évaluation médicale, cf. 385 (avant).
**Poids fort** — S'en tenir à la décision médicale et expliquer à la famille.

#### 400 — `sante-collegue-confronte-a-une-scene-difficile` ✅
**Thème** `secours-personnes` · **moyen** · premium · *retour d'intervention, 5 h*
**Titre** — « C'était sa première découverte de corps »
**Tension** — Impact psychologique sur un pair, banalisation dans le métier.
**Angle distinctif** — Retentissement sur l'intervenant, cf. 352.
**Poids fort** — Nommer l'impact et orienter vers un soutien.

---

## BLOC Q — DISCRIMINATIONS, RACISME, SEXISME ET DIGNITÉ (401 → 412) · 12 cas ✅ **BLOC COMPLET**

> Thème `discriminations`. Thème vide à ce jour. Le cas 009 doit y être
> reclassé (voir § 6). Bloc exigeant : la difficulté est souvent probatoire, et
> la posture du policier est elle-même en jeu.

#### 401 — `discrim-injure-raciste-voie-publique` ✅
**Thème** `discriminations` · **moyen** · premium · *rue commerçante, 16 h*
**Titre** — « Plusieurs passants ont entendu, aucun ne s'arrête »
**Tension** — Témoins nombreux mais fuyants, victime qui doute d'être crue.
**Angle distinctif** — Enjeu probatoire et recueil des témoins.
**Poids fort** — Relever les identités des témoins avant leur dispersion.

#### 402 — `discrim-refus-de-service-commerce` ✅
**Thème** `discriminations` · **difficile** · premium · *restaurant, 20 h*
**Titre** — « Le gérant invoque un service complet, la salle est à moitié vide »
**Tension** — Motif invoqué plausible en apparence, discrimination probable.
**Angle distinctif** — Discrimination masquée par un prétexte commercial.
**Poids fort** — Constater objectivement les éléments contredisant le prétexte.

#### 403 — `discrim-agression-homophobe-sortie-bar` ✅
**Thème** `discriminations` · **difficile** · premium · *rue, 1 h*
**Titre** — « Ils étaient trois, la victime ne veut pas que ses parents l'apprennent »
**Tension** — Crainte de l'outing en plus de l'agression subie.
**Angle distinctif** — Double vulnérabilité : agression et exposition redoutée.
**Poids fort** — Garantir la confidentialité et caractériser le mobile.

#### 404 — `discrim-harcelement-sexiste-transports` ✅
**Thème** `discriminations` · **moyen** · premium · *quai de RER, 18 h*
**Titre** — « Il l'a suivie sur trois quais en commentant son physique »
**Tension** — Faits sans contact physique, victime pressée de partir.
**Angle distinctif** — Harcèlement de rue, absence de contact.
**Poids fort** — Prendre les faits au sérieux malgré l'absence de contact.

#### 405 — `discrim-propos-discriminatoires-d-un-collegue-en-public` ✅
**Thème** `discriminations` · **expert** · premium · *intervention, 15 h*
**Titre** — « La remarque est faite devant la personne concernée »
**Tension** — Faute d'un collègue devant l'usager visé ; réaction immédiate requise.
**Angle distinctif** — Devant témoin et victime, cf. 306 (vestiaire).
**Poids fort** — Reprendre l'échange et permettre à la personne de faire valoir ses droits.

#### 406 — `discrim-victime-craint-de-ne-pas-etre-crue` ✅
**Thème** `discriminations` · **moyen** · premium · *commissariat, 14 h*
**Titre** — « On m'a déjà dit que je devais avoir mal compris »
**Tension** — Expérience antérieure de non-reconnaissance.
**Angle distinctif** — Rapport dégradé à l'institution du fait d'un accueil passé.
**Poids fort** — Restaurer la confiance par une écoute effective.

#### 407 — `discrim-controle-conteste-motif-du-controle` ✅
**Thème** `discriminations` · **difficile** · premium · *voie publique, 17 h*
**Titre** — « C'est le troisième contrôle cette semaine, toujours moi »
**Tension** — Contestation fondée sur un vécu répété ; posture à tenir.
**Angle distinctif** — Répétition alléguée, cf. 286 (contestation ponctuelle).
**Poids fort** — Expliquer le motif objectif et ne pas balayer le vécu.

#### 408 — `discrim-conflit-a-caractere-religieux-voisinage` ✅
**Thème** `discriminations` · **moyen** · premium · *copropriété, 19 h*
**Titre** — « Les dégradations visent systématiquement la même porte »
**Tension** — Ciblage répété, mobile à établir sans le présumer.
**Angle distinctif** — Faits matériels avec mobile discriminatoire probable.
**Poids fort** — Documenter le caractère ciblé et répété.

#### 409 — `discrim-personne-transgenre-victime-agression` ✅
**Thème** `discriminations` · **difficile** · premium · *rue, 23 h*
**Titre** — « L'agresseur a filmé la scène en la nommant par son ancien prénom »
**Tension** — Humiliation filmée, mobile explicite, dignité à protéger.
**Angle distinctif** — Cumul agression, diffusion et atteinte à l'identité, cf. 050.
**Poids fort** — Respecter l'identité de la personne dans tout l'échange.

#### 410 — `discrim-accusation-publique-visant-les-policiers` ✅
**Thème** `discriminations` · **difficile** · premium · *voie publique, 16 h*
**Titre** — « Une foule se forme, on vous accuse de racisme à voix haute »
**Tension** — Accusation publique, nécessité de ne pas réagir émotionnellement.
**Angle distinctif** — L'accusation vise l'équipage, en public.
**Poids fort** — Maîtrise de soi et poursuite d'une action irréprochable.

#### 411 — `discrim-temoin-refuse-de-parler-raisons-culturelles` ✅
**Thème** `discriminations` · **moyen** · premium · *quartier, 18 h*
**Titre** — « Il détourne le regard et dit que ça ne le concerne pas »
**Tension** — Réticence liée à la défiance ou à des codes sociaux.
**Angle distinctif** — Obstacle culturel au témoignage.
**Poids fort** — Chercher à comprendre le refus sans le forcer ni le juger.

#### 412 — `discrim-discrimination-embauche-signalee` ✅
**Thème** `discriminations` · **moyen** · premium · *commissariat, 11 h*
**Titre** — « Deux candidatures identiques, une seule a obtenu un entretien »
**Tension** — Élément de comparaison intéressant, preuve difficile.
**Angle distinctif** — Discrimination économique documentée par testing informel.
**Poids fort** — Recueillir les éléments comparatifs sans conclure.

---

## BLOC R — TERRORISME, RADICALISATION ET SITUATIONS SENSIBLES (413 → 424) · 12 cas ✅ **BLOC COMPLET**

> Thème `situations-sensibles`. **Bloc à traiter avec une prudence
> particulière.** Aucune technique opérationnelle, aucun détail de dispositif,
> aucune méthode exploitable. Centrer exclusivement sur : repérer, ne pas
> manipuler, protéger, rendre compte, ne pas stigmatiser.

#### 413 — `sensible-colis-abandonne-hall-de-gare` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *gare, 8 h 30*
**Titre** — « Une valise seule au pied d'un panneau d'affichage »
**Tension** — Ne pas manipuler, ne pas sur-réagir, forte affluence.
**Angle distinctif** — Volet gare, cf. 078 (centre commercial).
**Poids fort** — Périmètre et abstention totale de manipulation.

#### 414 — `sensible-comportement-inquietant-signale-par-un-proche` ✅
**Thème** `situations-sensibles` · **difficile** · premium · *commissariat, 15 h*
**Titre** — « Sa sœur décrit un changement brutal depuis six mois »
**Tension** — Signalement familial courageux, éléments non probants.
**Angle distinctif** — Signalement d'entourage, sans infraction constituée.
**Poids fort** — Recueillir et transmettre sans jugement ni stigmatisation.

#### 415 — `sensible-menace-recue-par-un-etablissement` ✅
**Thème** `situations-sensibles` · **difficile** · premium · *collège, 9 h*
**Titre** — « Un message anonyme annonce un passage à l'acte pour la journée »
**Tension** — Décision d'évacuation lourde de conséquences, crédibilité incertaine.
**Angle distinctif** — Menace ciblant un établissement scolaire.
**Poids fort** — Rendre compte immédiatement sans décider seul.

#### 416 — `sensible-propos-apologie-lors-d-un-controle` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *voie publique, 17 h*
**Titre** — « Il tient des propos provocateurs pour vous tester »
**Tension** — Distinguer provocation et adhésion réelle, ne pas sur-réagir.
**Angle distinctif** — Propos tenus en interaction directe.
**Poids fort** — Consigner exactement les propos sans les interpréter.

#### 417 — `sensible-individu-photographie-site-sensible` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *abords d'un site, 14 h*
**Titre** — « Il photographie les accès depuis vingt minutes »
**Tension** — Comportement possiblement anodin (touriste, étudiant, curieux).
**Angle distinctif** — Signal faible à vérifier sans présumer.
**Poids fort** — Vérifier factuellement sans accusation.

#### 418 — `sensible-signalement-radicalisation-milieu-scolaire` ✅
**Thème** `situations-sensibles` · **difficile** · premium · *lycée, 11 h*
**Titre** — « Un enseignant s'inquiète de propos tenus en classe »
**Tension** — Risque de stigmatisation d'un adolescent, obligation de traiter.
**Angle distinctif** — Mineur concerné, cf. 414 (majeur).
**Poids fort** — Traiter le signalement sans stigmatiser le mineur.

#### 419 — `sensible-vehicule-abandonne-proximite-rassemblement` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *abords d'événement, 18 h*
**Titre** — « Stationné en double file depuis deux heures, moteur froid »
**Tension** — Explication banale probable, contexte qui impose la vigilance.
**Angle distinctif** — Objet volumineux, contexte événementiel.
**Poids fort** — Périmètre et vérification du propriétaire sans manipulation.

#### 420 — `sensible-appel-anonyme-mencant-mairie` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *mairie, 10 h*
**Titre** — « L'agent d'accueil a noté la phrase mot pour mot »
**Tension** — Trace fragile, personnel inquiet, continuité du service public.
**Angle distinctif** — Menace téléphonique visant une administration.
**Poids fort** — Recueillir la trace exacte et préserver les éléments techniques.

#### 421 — `sensible-contenu-inquietant-en-ligne-signale` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *commissariat, 16 h*
**Titre** — « Un internaute signale des publications au ton de plus en plus explicite »
**Tension** — Évaluer une gradation, préserver les contenus.
**Angle distinctif** — Signal en ligne, cf. 245 (publication d'arme).
**Poids fort** — Préserver les contenus avant toute demande de retrait.

#### 422 — `sensible-securisation-perimetre-apres-alerte` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *place publique, 13 h*
**Titre** — « Des curieux franchissent le ruban pour filmer »
**Tension** — Tenue du périmètre face à la curiosité et à l'impatience.
**Angle distinctif** — Volet tenue de périmètre, sans dimension technique.
**Poids fort** — Faire respecter le périmètre par l'explication.

#### 423 — `sensible-fausse-alerte-consequences` ✅
**Thème** `situations-sensibles` · **moyen** · premium · *centre commercial, 15 h*
**Titre** — « L'alerte était infondée, le gérant réclame des explications »
**Tension** — Justifier une décision coûteuse qui s'avère inutile.
**Angle distinctif** — Après-coup d'une alerte, assumer la décision prise.
**Poids fort** — Assumer et expliquer la décision malgré le résultat.

#### 424 — `sensible-personne-signalee-comportement-errant-aeroport` ✅
**Thème** `situations-sensibles` · **difficile** · premium · *aéroport, 5 h*
**Titre** — « Elle circule depuis la veille sans jamais s'enregistrer »
**Tension** — Comportement atypique, hypothèses multiples dont la détresse.
**Angle distinctif** — Croisement situation sensible et vulnérabilité possible.
**Poids fort** — Envisager la détresse autant que la menace.

---

## BLOC S — SITUATIONS RARES OU COMPLEXES (425 → 444) · 20 cas ✅ **BLOC COMPLET**

> Thème `situations-exceptionnelles`. Thème vide à ce jour. Événements peu
> fréquents mais formateurs : multi-services, ampleur inhabituelle, cadre
> juridique inhabituel.

#### 425 — `except-inondation-evacuation-quartier` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *quartier riverain, 4 h*
**Titre** — « L'eau monte, certains habitants refusent de partir »
**Tension** — Évacuation urgente, refus individuels, montée des eaux.
**Angle distinctif** — Catastrophe naturelle et refus d'évacuation.
**Poids fort** — Convaincre et prioriser les personnes les plus exposées.

#### 426 — `except-decouverte-restes-humains` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *terrain vague, 10 h*
**Titre** — « Des ossements mis au jour par des travaux »
**Tension** — Ancienneté inconnue, préservation stricte, curieux à écarter.
**Angle distinctif** — Découverte macabre d'origine indéterminée.
**Poids fort** — Geler les lieux sans rien déplacer.

#### 427 — `except-decouverte-nourrisson-abandonne` ✅
**Thème** `situations-exceptionnelles` · **expert** · premium · *hall d'immeuble, 3 h*
**Titre** — « Le nouveau-né est enveloppé dans une serviette, encore tiède »
**Tension** — Urgence vitale, mère peut-être en danger à proximité.
**Angle distinctif** — Double urgence : nourrisson et mère non localisée.
**Poids fort** — Secours au nourrisson et recherche immédiate de la mère.

#### 428 — `except-accident-industriel-fuite-produit` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *zone industrielle, 7 h*
**Titre** — « Un nuage se dégage, le vent porte vers les habitations »
**Tension** — Risque toxique, périmètre évolutif, information de la population.
**Angle distinctif** — Risque technologique majeur.
**Poids fort** — Périmètre selon le vent et alerte de la population.

#### 429 — `except-erreur-d-identite-personne-interpellee` ✅
**Thème** `situations-exceptionnelles` · **expert** · premium · *commissariat, 14 h*
**Titre** — « L'homonymie était parfaite, la personne a passé la nuit en cellule »
**Tension** — Erreur institutionnelle grave à reconnaître et réparer.
**Angle distinctif** — Faute du service envers un innocent.
**Poids fort** — Reconnaître l'erreur et organiser la réparation.

#### 430 — `except-intervention-personnalite-publique` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *hôtel, 23 h*
**Titre** — « Son entourage exige la discrétion et propose d'arranger les choses »
**Tension** — Pression liée à la notoriété, égalité de traitement en jeu.
**Angle distinctif** — Notoriété comme facteur de pression, cf. 340.
**Poids fort** — Traitement strictement identique malgré la notoriété.

#### 431 — `except-conflit-entre-administrations-sur-place` ✅
**Thème** `situations-exceptionnelles` · **moyen** · premium · *site public, 11 h*
**Titre** — « Deux services se déclarent compétents et se contredisent »
**Tension** — Blocage institutionnel devant le public.
**Angle distinctif** — Conflit de compétence entre administrations.
**Poids fort** — Faire trancher par l'autorité supérieure sans arbitrer.

#### 432 — `except-personne-enfermee-local-technique` ✅
**Thème** `situations-exceptionnelles` · **moyen** · gratuit · *parking souterrain, 22 h*
**Titre** — « On l'entend frapper, personne ne trouve la clé »
**Tension** — Personne enfermée depuis un temps inconnu, accès impossible.
**Angle distinctif** — Contrainte matérielle d'accès, cf. 087 (ascenseur).
**Poids fort** — Maintenir le contact et mobiliser les moyens techniques.

#### 433 — `except-animal-dangereux-echappe` ✅
**Thème** `situations-exceptionnelles` · **moyen** · premium · *zone pavillonnaire, 16 h*
**Titre** — « Un reptile de grande taille signalé dans un jardin »
**Tension** — Danger inhabituel, aucune compétence technique de l'équipage.
**Angle distinctif** — Animal exotique, cf. 080 (chiens).
**Poids fort** — Sécuriser les riverains et appeler les spécialistes.

#### 434 — `except-effondrement-tribune-evenement` ✅
**Thème** `situations-exceptionnelles` · **expert** · premium · *salle des fêtes, 21 h*
**Titre** — « Une trentaine de personnes au sol, la structure bouge encore »
**Tension** — Nombreuses victimes, risque de sur-accident, moyens dépassés.
**Angle distinctif** — Événement à victimes multiples.
**Poids fort** — Alerter à la hauteur réelle et sécuriser avant de secourir.

#### 435 — `except-pollution-cours-d-eau-signalee` ✅
**Thème** `situations-exceptionnelles` · **facile** · gratuit · *rivière, 9 h*
**Titre** — « Une irisation et des poissons morts sur cent mètres »
**Tension** — Constatation à faire vite, services spécialisés à mobiliser.
**Angle distinctif** — Atteinte environnementale.
**Poids fort** — Constater, préserver et saisir le service compétent.

#### 436 — `except-incident-en-vol-atterrissage` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *aéroport, 13 h*
**Titre** — « Un passager a agressé un membre d'équipage pendant le vol »
**Tension** — Cadre juridique inhabituel, nombreux témoins à traiter vite.
**Angle distinctif** — Faits commis en vol, prise en charge au sol.
**Poids fort** — Recueillir les témoignages avant la dispersion des passagers.

#### 437 — `except-disparition-en-milieu-montagneux` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *zone de montagne, 17 h*
**Titre** — « Le randonneur n'a pas rejoint le refuge, la nuit tombe »
**Tension** — Milieu hostile, moyens spécialisés, fenêtre qui se referme.
**Angle distinctif** — Milieu montagnard, cf. 091 (zone rurale).
**Poids fort** — Alerter les moyens spécialisés sans délai.

#### 438 — `except-mouvement-de-panique-lieu-clos` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *cinéma, 20 h*
**Titre** — « Quelqu'un a crié, la salle se vide dans le désordre »
**Tension** — Écrasement possible, cause initiale inconnue.
**Angle distinctif** — Panique en espace clos, cf. 069 et 267.
**Poids fort** — Canaliser les flux et vérifier la cause simultanément.

#### 439 — `except-tempete-degats-multiples-priorisation` ✅
**Thème** `situations-exceptionnelles` · **expert** · premium · *secteur entier, 6 h*
**Titre** — « Vingt-trois signalements en attente, deux équipages disponibles »
**Tension** — Priorisation pure sous contrainte de moyens.
**Angle distinctif** — Arbitrage entre urgences concurrentes.
**Poids fort** — Hiérarchiser explicitement selon le risque vital.

#### 440 — `except-personne-retrouvee-apres-disparition-longue` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *commissariat, 15 h*
**Titre** — « Elle est majeure et ne veut pas que sa famille sache où elle est »
**Tension** — Volonté de la personne contre attente de la famille.
**Angle distinctif** — Disparition volontaire d'un majeur.
**Poids fort** — Respecter la volonté du majeur tout en levant l'inquiétude.

#### 441 — `except-incendie-important-relogement` ✅
**Thème** `situations-exceptionnelles` · **moyen** · premium · *immeuble, 8 h*
**Titre** — « Quarante habitants dehors, certains sans papiers ni médicaments »
**Tension** — Après-sinistre, besoins pratiques immédiats et nombreux.
**Angle distinctif** — Phase post-sinistre, cf. 063 (feu en cours).
**Poids fort** — Recenser les besoins vitaux et mobiliser la mairie.

#### 442 — `except-decouverte-engin-ancien-chantier` ✅
**Thème** `situations-exceptionnelles` · **moyen** · premium · *chantier, 10 h*
**Titre** — « L'engin est enterré depuis probablement plusieurs décennies »
**Tension** — Danger réel malgré l'ancienneté, ouvriers à éloigner.
**Angle distinctif** — Vestige de guerre, procédure spécifique.
**Poids fort** — Périmètre et abstention totale d'approche.

#### 443 — `except-panne-electrique-generalisee-secteur` ✅
**Thème** `situations-exceptionnelles` · **moyen** · premium · *centre-ville, 19 h*
**Titre** — « Feux éteints, commerces ouverts, personnes bloquées en hauteur »
**Tension** — Effets multiples et simultanés d'une même cause.
**Angle distinctif** — Défaillance d'infrastructure aux effets en cascade.
**Poids fort** — Prioriser les personnes bloquées et la sécurité routière.

#### 444 — `except-intervention-dans-un-tribunal` ✅
**Thème** `situations-exceptionnelles` · **difficile** · premium · *tribunal, 14 h*
**Titre** — « Un proche de la partie civile s'en prend au prévenu à la sortie »
**Tension** — Lieu institutionnel, forte charge émotionnelle, public nombreux.
**Angle distinctif** — Enceinte judiciaire, cf. 278 (cérémonie officielle).
**Poids fort** — Séparer immédiatement et protéger toutes les parties.

---

## BLOC T — CONTRÔLE D'IDENTITÉ (445 → 459) · 15 cas ✅ **BLOC COMPLET**

> Thème `controle-identite`. Les cas 002, 005 et 006 existent déjà. Bloc centré
> sur le fondement du contrôle, la manière de le conduire et la relation à la
> personne contrôlée.

#### 445 — `ci-controle-personne-refuse-de-decliner` ✅
**Thème** `controle-identite` · **moyen** · gratuit · *voie publique, 15 h*
**Titre** — « Il demande d'abord sur quel fondement vous le contrôlez »
**Tension** — Question légitime, réponse à apporter sans se braquer.
**Angle distinctif** — Contestation du fondement, pas refus agressif.
**Poids fort** — Énoncer clairement le fondement du contrôle.

#### 446 — `ci-personne-sans-document-identite-verifiable` ✅
**Thème** `controle-identite` · **moyen** · premium · *rue, 19 h*
**Titre** — « Il donne un nom mais aucun élément ne permet de le vérifier »
**Tension** — Impossibilité de vérifier, suites à envisager avec mesure.
**Angle distinctif** — Absence totale d'élément vérifiable.
**Poids fort** — Épuiser les moyens de vérification avant toute suite.

#### 447 — `ci-controle-groupe-personnes` ✅
**Thème** `controle-identite` · **moyen** · premium · *place, 21 h*
**Titre** — « Ils sont huit, deux commencent à filmer »
**Tension** — Effectif défavorable, captation, montée de tension.
**Angle distinctif** — Contrôle collectif et exposition.
**Poids fort** — Adapter le dispositif au nombre et rester méthodique.

#### 448 — `ci-controle-personne-en-situation-irreguliere` ✅
**Thème** `controle-identite` · **difficile** · premium · *gare routière, 10 h*
**Titre** — « Elle voyage avec deux enfants en bas âge »
**Tension** — Situation administrative et présence d'enfants.
**Angle distinctif** — Enfants présents lors du contrôle.
**Poids fort** — Prendre en compte les enfants dans toute décision.

#### 449 — `ci-controle-conteste-par-un-temoin` ✅
**Thème** `controle-identite` · **moyen** · gratuit · *trottoir, 17 h*
**Titre** — « Un passant s'interpose et exige des explications »
**Tension** — Tiers non concerné s'immisçant dans le contrôle.
**Angle distinctif** — Intervention d'un tiers, cf. 283.
**Poids fort** — Écarter le tiers avec calme sans interrompre le contrôle.

#### 450 — `ci-verification-identite-personne-vulnerable` ✅
**Thème** `controle-identite` · **moyen** · premium · *rue, 14 h*
**Titre** — « Il ne comprend visiblement pas ce qui lui est demandé »
**Tension** — Vulnérabilité rendant le contrôle inadapté en l'état.
**Angle distinctif** — Croisement contrôle et vulnérabilité, cf. bloc O.
**Poids fort** — Adapter la démarche à la vulnérabilité constatée.

#### 451 — `ci-controle-suite-signalement-erronne` ✅
**Thème** `controle-identite` · **moyen** · premium · *rue, 16 h*
**Titre** — « Le signalement ne correspond pas, il est contrôlé quand même »
**Tension** — Contrôle qui perd son fondement en cours d'exécution.
**Angle distinctif** — Le motif initial s'évanouit pendant l'acte.
**Poids fort** — Mettre fin au contrôle et expliquer la méprise.

#### 452 — `ci-controle-mineur-tres-jeune` ✅
**Thème** `controle-identite` · **moyen** · premium · *quartier, 20 h*
**Titre** — « Il a onze ans et se trouve seul à cette heure »
**Tension** — Le contrôle révèle surtout une question de protection.
**Angle distinctif** — Très jeune mineur, cf. 005 (adolescents).
**Poids fort** — Traiter la protection avant l'aspect identitaire.

#### 453 — `ci-palpation-securite-contestee` ✅
**Thème** `controle-identite` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *voie publique, 22 h*
**Titre** — « Elle refuse d'être palpée par un agent masculin »
**Tension** — Demande légitime, contrainte d'effectif sur place.
**Angle distinctif** — Question de dignité dans l'exécution de l'acte.
**Poids fort** — Respecter la demande et organiser autrement.

#### 454 — `ci-controle-professionnel-en-exercice` ✅
**Thème** `controle-identite` · **moyen** · premium · *rue, 11 h*
**Titre** — « Un médecin en visite refuse d'interrompre sa tournée »
**Tension** — Contrôle légitime, urgence professionnelle invoquée.
**Angle distinctif** — Conflit avec une activité d'intérêt général.
**Poids fort** — Adapter la durée sans renoncer à l'acte.

#### 455 — `ci-controle-personne-connue-des-services` ✅
**Thème** `controle-identite` · **moyen** · premium · *quartier, 18 h*
**Titre** — « C'est la quatrième fois que vous le contrôlez ce mois-ci »
**Tension** — Répétition posant la question du fondement de chaque contrôle.
**Angle distinctif** — Répétition côté policier, cf. 407 côté personne.
**Poids fort** — Justifier chaque contrôle indépendamment des précédents.

#### 456 — `ci-controle-lors-d-un-evenement-festif` ✅
**Thème** `controle-identite` · **facile** · gratuit · *festival, 23 h*
**Titre** — « Il est euphorique et tutoie tout le monde, sans agressivité »
**Tension** — Contexte festif, maintien du cadre sans rigidité.
**Angle distinctif** — Ambiance festive et registre de l'échange.
**Poids fort** — Tenir le cadre avec courtoisie, sans se laisser entraîner.

#### 457 — `ci-controle-vehicule-occupants-multiples` ✅
**Thème** `controle-identite` · **difficile** · premium · *route, 2 h*
**Titre** — « Cinq occupants, versions différentes sur leur destination »
**Tension** — Incohérences à explorer sans surinterpréter, sécurité du contrôle.
**Angle distinctif** — Contrôle de véhicule avec occupants nombreux.
**Poids fort** — Sécuriser avant d'approfondir les incohérences.

#### 458 — `ci-personne-presente-document-douteux` ✅
**Thème** `controle-identite` · **difficile** · premium · *contrôle, 15 h*
**Titre** — « La photographie semble avoir été remplacée »
**Tension** — Soupçon à vérifier sans accuser prématurément.
**Angle distinctif** — Document possiblement falsifié.
**Poids fort** — Vérifier méthodiquement sans affirmer la falsification.

#### 459 — `ci-controle-issue-negative-relation-degradee` ✅
**Thème** `controle-identite` · **facile** · gratuit · *rue, 13 h*
**Titre** — « Tout est en règle, la personne repart visiblement humiliée »
**Tension** — Fin du contrôle : ce qui reste à la personne compte.
**Angle distinctif** — Clôture du contrôle et relation police-population.
**Poids fort** — Soigner la fin du contrôle et expliquer.

---

## BLOC U — USAGE DE LA FORCE (460 → 475) · 16 cas ✅ **BLOC COMPLET**

> Thème `usage-force`. Les cas 014, 019 et 020 existent déjà. **Aucune
> technique d'intervention ne doit figurer dans ces cas.** Centrer sur
> l'appréciation, la proportionnalité, la maîtrise de soi et le compte rendu.

#### 460 — `force-personne-refuse-de-lacher-un-objet` ✅
**Thème** `usage-force` · **moyen** · premium · *voie publique, 18 h*
**Titre** — « Il serre son sac contre lui et recule à chaque approche »
**Tension** — Résistance passive, gradation à apprécier.
**Angle distinctif** — Opposition sans agressivité.
**Poids fort** — Épuiser les moyens verbaux avant tout contact.

#### 461 — `force-interpellation-personne-corpulente-au-sol` ✅
**Thème** `usage-force` · **difficile** · premium · *trottoir, 20 h*
**Titre** — « Il dit ne plus pouvoir respirer alors qu'il est maintenu »
**Tension** — Risque vital pendant la contrainte, doute sur la sincérité.
**Angle distinctif** — Risque médical pendant la maîtrise.
**Poids fort** — Prendre la plainte respiratoire au sérieux immédiatement.

#### 462 — `force-usage-conteste-par-la-victime-de-l-interpellation` ✅
**Thème** `usage-force` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *commissariat, 22 h*
**Titre** — « Il demande un examen médical et annonce une plainte »
**Tension** — Suite immédiate d'un usage de la force, traçabilité.
**Angle distinctif** — Après l'usage, cf. 014.
**Poids fort** — Faciliter l'examen médical et consigner exhaustivement.

#### 463 — `force-personne-agitee-sous-effet-de-produit` ✅
**Thème** `usage-force` · **difficile** · premium · *rue, 3 h*
**Titre** — « Il ne semble ressentir aucune douleur et s'automutile »
**Tension** — Contrainte peu opérante, risque vital pour la personne.
**Angle distinctif** — État modifié rendant la contrainte dangereuse.
**Poids fort** — Faire venir les secours médicaux sans délai.

#### 464 — `force-menottage-personne-agee` ✅
**Thème** `usage-force` · **moyen** · premium · *domicile, 16 h*
**Titre** — « Elle a 78 ans et une épaule opérée récemment »
**Tension** — Nécessité de sécuriser contre fragilité physique.
**Angle distinctif** — Adaptation de la contrainte à l'état physique.
**Poids fort** — Adapter la mesure à l'état de la personne.

#### 465 — `force-intervention-devant-camera-de-passants` ✅
**Thème** `usage-force` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *rue commerçante, 17 h*
**Titre** — « Cinq téléphones filment, un passant crie de vous arrêter »
**Tension** — Pression du public pendant une action légitime.
**Angle distinctif** — Usage de la force sous captation, cf. 246 et 287.
**Poids fort** — Ne pas modifier son action sous la pression du regard.

#### 466 — `force-refus-de-suivre-personne-assise-au-sol` ✅
**Thème** `usage-force` · **moyen** · premium · *hall public, 14 h*
**Titre** — « Elle se laisse tomber au sol et devient un poids mort »
**Tension** — Résistance non violente, risque de blessure des deux côtés.
**Angle distinctif** — Résistance passive physique.
**Poids fort** — Privilégier la persuasion et éviter la blessure.

#### 467 — `force-usage-face-a-un-mineur` ✅
**Thème** `usage-force` · **difficile** · premium · *quartier, 19 h*
**Titre** — « Il a quatorze ans et frappe le véhicule de service »
**Tension** — Proportionnalité renforcée face à un mineur.
**Angle distinctif** — Minorité de la personne concernée.
**Poids fort** — Adapter la réponse à la minorité.

#### 468 — `force-collegue-veut-intervenir-trop-vite` ✅
**Thème** `usage-force` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *intervention, 21 h*
**Titre** — « Il s'avance alors que la personne est en train de céder »
**Tension** — Précipitation d'un pair pouvant provoquer l'escalade.
**Angle distinctif** — Retenir un collègue, cf. 307 (faute constituée).
**Poids fort** — Temporiser et retenir le collègue avant l'escalade.

#### 469 — `force-personne-arme-blanche-a-distance` ✅
**Thème** `usage-force` · **difficile** (rétrogradé depuis expert, cf. note ci-dessous) · premium · *place, 20 h*
**Titre** — « Il tient un couteau le long du corps et ne répond pas »
**Tension** — Danger réel, distance à préserver, public à écarter.
**Angle distinctif** — Menace armée, sans technique opérationnelle décrite.
**Poids fort** — Maintenir la distance et protéger les tiers.

#### 470 — `force-immobilisation-personne-en-crise-psychique` ✅
**Thème** `usage-force` · **difficile** · premium · *appartement, 15 h*
**Titre** — « La contrainte semble aggraver son état à chaque seconde »
**Tension** — La force produit l'effet inverse de celui recherché.
**Angle distinctif** — Contre-productivité de la contrainte, cf. bloc P.
**Poids fort** — Réduire la contrainte et attendre le médical.

#### 471 — `force-blessure-involontaire-lors-interpellation` ✅
**Thème** `usage-force` · **difficile** · premium · *voie publique, 23 h*
**Titre** — « Sa tête a heurté le trottoir pendant la chute »
**Tension** — Blessure survenue sans faute, obligations immédiates.
**Angle distinctif** — Accident au cours d'un usage légitime.
**Poids fort** — Secours immédiats et compte rendu exhaustif.

#### 472 — `force-personne-menace-de-se-jeter-sous-un-vehicule` ✅
**Thème** `usage-force` · **difficile** (rétrogradé depuis expert, cf. note ci-dessous) · premium · *bord de route, 18 h*
**Titre** — « Elle est à un mètre de la chaussée et vous regarde approcher »
**Tension** — Toute approche peut déclencher, l'inaction aussi.
**Angle distinctif** — Contrainte physique éventuelle pour protéger la personne.
**Poids fort** — Sécuriser la circulation avant toute approche.

#### 473 — `force-interpellation-en-presence-de-la-famille` ✅
**Thème** `usage-force` · **difficile** · premium · *domicile, 7 h*
**Titre** — « Son épouse s'interpose et ses enfants crient »
**Tension** — Famille s'opposant physiquement, enfants témoins.
**Angle distinctif** — Opposition familiale pendant l'interpellation, cf. 151.
**Poids fort** — Éloigner les enfants et éviter l'escalade familiale.

#### 474 — `force-usage-du-materiel-dote-conteste` ✅
**Thème** `usage-force` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *voie publique, 1 h*
**Titre** — « L'individu affirme que rien ne justifiait cet usage »
**Tension** — Justification à établir avec précision dans le compte rendu.
**Angle distinctif** — Traçabilité et motivation de l'usage.
**Poids fort** — Motiver précisément l'usage dans le compte rendu.

#### 475 — `force-renoncement-a-l-interpellation` ✅
**Thème** `usage-force` · **difficile** (rétrogradé depuis expert, cf. note ci-dessous) · premium · *marché bondé, 11 h*
**Titre** — « L'interpeller ici mettrait en danger une dizaine de personnes »
**Tension** — Renoncer est la bonne décision mais paraît un échec.
**Angle distinctif** — Le renoncement comme décision professionnelle, cf. 094 et 174.
**Poids fort** — Assumer et motiver le renoncement.

---

## BLOC V — PROCÉDURE PÉNALE ET ACTES PROFESSIONNELS (476 → 500) · 25 cas ✅ **BLOC COMPLET**

> Thème `procedure-penale`. Les cas 004, 010, 011, 012 et 015 existent déjà.
> Bloc technique : rester au niveau du gardien de la paix (constatations,
> premiers actes, compte rendu), sans se substituer à l'officier de police
> judiciaire.

#### 476 — `pp-constatations-scene-preservation` ✅
**Thème** `procedure-penale` · **moyen** · premium · *appartement, 9 h*
**Titre** — « Les proches ont déjà nettoyé une partie de la pièce »
**Tension** — Scène altérée avant l'arrivée, éléments à sauver.
**Angle distinctif** — Altération involontaire par des tiers.
**Poids fort** — Figer ce qui reste et documenter l'altération.

#### 477 — `pp-recueil-declarations-victime-etat-de-choc` ✅
**Thème** `procedure-penale` · **moyen** · premium · *voie publique, 20 h*
**Titre** — « Elle se contredit à chaque phrase sans mentir »
**Tension** — Fiabilité affectée par le choc, sans mauvaise foi.
**Angle distinctif** — Qualité du recueil sous stress aigu, cf. 067.
**Poids fort** — Consigner sans corriger ni harmoniser le récit.

#### 478 — `pp-temoin-souhaite-modifier-sa-declaration` ✅
**Thème** `procedure-penale` · **moyen** · premium · *commissariat, 15 h*
**Titre** — « Il revient trois jours après avec une version différente »
**Tension** — Revirement à traiter sans présumer du mensonge.
**Angle distinctif** — Modification postérieure d'un témoignage.
**Poids fort** — Recueillir la nouvelle version sans détruire la première.

#### 479 — `pp-saisie-objet-lors-intervention` ✅
**Thème** `procedure-penale` · **moyen** · premium · *domicile, 17 h*
**Titre** — « L'objet est utile mais rien ne le rattache encore aux faits »
**Tension** — Utilité probable contre cadre de la saisie.
**Angle distinctif** — Opportunité et cadre de la saisie.
**Poids fort** — En référer à l'officier de police judiciaire avant de saisir.

#### 480 — `pp-personne-souhaite-avouer-spontanement` ✅
**Thème** `procedure-penale` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *voie publique, 14 h*
**Titre** — « Il commence à tout raconter avant que vous ne l'interrogiez »
**Tension** — Déclarations spontanées à recueillir sans les provoquer.
**Angle distinctif** — Parole spontanée hors cadre d'audition.
**Poids fort** — Consigner sans interroger et en référer.

#### 481 — `pp-refus-de-signer-une-declaration` ✅
**Thème** `procedure-penale` · **facile** · gratuit · *commissariat, 16 h*
**Titre** — « Elle conteste deux mots et refuse de signer l'ensemble »
**Tension** — Désaccord ponctuel bloquant l'acte entier.
**Angle distinctif** — Difficulté formelle de clôture d'un acte.
**Poids fort** — Mentionner le refus et son motif exact.

#### 482 — `pp-decouverte-d-un-element-hors-du-cadre-initial` ✅
**Thème** `procedure-penale` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *domicile, 11 h*
**Titre** — « Vous cherchiez une chose, vous en trouvez une autre »
**Tension** — Cadre de l'acte à respecter malgré la découverte.
**Angle distinctif** — Découverte incidente, cf. 187.
**Poids fort** — Ne pas poursuivre hors cadre et en référer.

#### 483 — `pp-identification-d-un-suspect-par-la-victime` ✅
**Thème** `procedure-penale` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *voie publique, 19 h*
**Titre** — « Elle le désigne dans la rue, vous êtes seuls tous les trois »
**Tension** — Reconnaissance spontanée à sécuriser sur le plan probatoire.
**Angle distinctif** — Identification hors cadre formalisé.
**Poids fort** — Consigner précisément les conditions de la reconnaissance.

#### 484 — `pp-personne-interpellee-signale-un-probleme-de-sante` ✅
**Thème** `procedure-penale` · **moyen** · premium · *véhicule de service, 22 h*
**Titre** — « Il dit être diabétique et n'avoir rien mangé depuis midi »
**Tension** — Doute sur la sincérité, risque médical réel.
**Angle distinctif** — Santé de la personne retenue, cf. 011.
**Poids fort** — Faire évaluer médicalement sans juger de la sincérité.

#### 485 — `pp-transport-personne-interpellee-incident` ✅
**Thème** `procedure-penale` · **moyen** · premium · *véhicule, 23 h*
**Titre** — « Il se cogne volontairement la tête contre la vitre »
**Tension** — Automutilation en véhicule, sécurité et traçabilité.
**Angle distinctif** — Incident pendant le transport.
**Poids fort** — Arrêter le véhicule et faire constater immédiatement.

#### 486 — `pp-plainte-contre-x-elements-minces` ✅
**Thème** `procedure-penale` · **facile** · gratuit · *commissariat, 10 h*
**Titre** — « Aucun témoin, aucune image, aucun signalement »
**Tension** — Tentation de décourager, obligation d'enregistrer.
**Angle distinctif** — Absence quasi totale d'éléments.
**Poids fort** — Enregistrer et recueillir tout élément mineur exploitable.

#### 487 — `pp-requisition-images-videoprotection` ✅
**Thème** `procedure-penale` · **moyen** · premium · *commerce, 13 h*
**Titre** — « Le gérant propose de vous montrer sans formalité »
**Tension** — Facilité proposée contre exigence de cadre.
**Angle distinctif** — Recueil d'images et respect du cadre.
**Poids fort** — Respecter le cadre malgré la proposition informelle.

#### 488 — `pp-audition-personne-ne-parlant-pas-francais` ✅
**Thème** `procedure-penale` · **moyen** · premium · *commissariat, 18 h*
**Titre** — « Un membre de sa famille propose de traduire »
**Tension** — Solution pratique mais compromettant la fiabilité de l'acte.
**Angle distinctif** — Interprétariat en procédure, cf. 031 et 032.
**Poids fort** — Refuser l'interprète familial et recourir à un professionnel.

#### 489 — `pp-personne-mise-en-cause-demande-a-prevenir-un-proche` ✅
**Thème** `procedure-penale` · **facile** · gratuit · *commissariat, 21 h*
**Titre** — « Ses enfants sont seuls à la maison depuis deux heures »
**Tension** — Droit de la personne et protection des enfants.
**Angle distinctif** — Conséquence familiale de l'interpellation, cf. 151.
**Poids fort** — Traiter en urgence la situation des enfants.

#### 490 — `pp-compte-rendu-fait-marquant` ✅
**Thème** `procedure-penale` · **moyen** · premium · *fin de service, 5 h*
**Titre** — « Vous hésitez à mentionner un détail qui vous a paru étrange »
**Tension** — Ce qui semble mineur peut s'avérer déterminant plus tard.
**Angle distinctif** — Qualité et exhaustivité du compte rendu.
**Poids fort** — Consigner le détail plutôt que l'écarter.

#### 491 — `pp-personne-recherchee-decouverte-lors-controle` ✅
**Thème** `procedure-penale` · **moyen** · premium · *voie publique, 15 h*
**Titre** — « La fiche est ancienne et les informations sont partielles »
**Tension** — Vérifier l'actualité de la mesure avant d'agir.
**Angle distinctif** — Fiabilité de l'information, cf. 429 (erreur d'identité).
**Poids fort** — Vérifier l'actualité de la mesure avant toute décision.

#### 492 — `pp-victime-souhaite-recuperer-son-bien-immediatement` ✅
**Thème** `procedure-penale` · **facile** · gratuit · *commissariat, 12 h*
**Titre** — « C'est son ordinateur de travail, elle en a besoin demain »
**Tension** — Besoin légitime contre nécessités de la procédure.
**Angle distinctif** — Tension entre procédure et vie quotidienne, cf. 227.
**Poids fort** — Expliquer la nécessité et rechercher une solution pratique.

#### 493 — `pp-mise-en-cause-mineure-presence-representant` ✅
**Thème** `procedure-penale` · **moyen** · premium · *commissariat, 17 h*
**Titre** — « Le père est injoignable, la mère refuse de se déplacer »
**Tension** — Garanties du mineur impossibles à réunir dans l'immédiat.
**Angle distinctif** — Carence des représentants légaux.
**Poids fort** — Ne pas passer outre les garanties du mineur.

#### 494 — `pp-flagrance-ou-non-appreciation` ✅
**Thème** `procedure-penale` · **difficile** · premium · *rue, 16 h*
**Titre** — « Les faits datent d'une heure, l'auteur est encore sur place »
**Tension** — Qualification du cadre déterminant les actes possibles.
**Angle distinctif** — Appréciation du cadre juridique de l'intervention.
**Poids fort** — En référer plutôt que présumer le cadre.

#### 495 — `pp-deux-plaignants-versions-opposees` ✅
**Thème** `procedure-penale` · **difficile** · premium · *commissariat, 14 h*
**Titre** — « Chacun se présente comme la victime de l'autre »
**Tension** — Double plainte croisée, impartialité stricte requise.
**Angle distinctif** — Plaintes réciproques, cf. 113 (contexte conjugal).
**Poids fort** — Enregistrer les deux plaintes avec la même rigueur.

#### 496 — `pp-element-numerique-a-preserver` ✅
**Thème** `procedure-penale` · **moyen** · premium · *domicile, 10 h*
**Titre** — « Le téléphone est déverrouillé et reçoit encore des messages »
**Tension** — Élément volatil, manipulation risquant de le compromettre.
**Angle distinctif** — Preuve numérique volatile.
**Poids fort** — Ne pas manipuler et faire appel aux moyens spécialisés.

#### 497 — `pp-personne-interpellee-refuse-de-s-alimenter` ✅
**Thème** `procedure-penale` · **moyen** · premium · *commissariat, 20 h*
**Titre** — « Elle refuse tout depuis son arrivée il y a huit heures »
**Tension** — Refus volontaire, obligation de veiller à son état.
**Angle distinctif** — Conditions de la retenue et dignité.
**Poids fort** — Consigner le refus et faire évaluer médicalement.

#### 498 — `pp-erreur-dans-un-acte-decouverte-apres-coup` ✅
**Thème** `procedure-penale` · **difficile** · premium · *service, 11 h*
**Titre** — « Une mention erronée peut fragiliser toute la procédure »
**Tension** — Réparer sans dissimuler, assumer l'erreur.
**Angle distinctif** — Erreur de forme aux conséquences de fond, cf. 339.
**Poids fort** — Signaler l'erreur immédiatement à l'officier de police judiciaire.

#### 499 — `pp-interpellation-personne-refusant-de-donner-son-identite` ✅
**Thème** `procedure-penale` · **moyen** (rétrogradé, cf. note ci-dessous) · premium · *voie publique, 19 h*
**Titre** — « Sans identité, aucune suite n'est possible et il le sait »
**Tension** — Blocage volontaire et réfléchi de la personne.
**Angle distinctif** — Refus stratégique, cf. 445 et 446.
**Poids fort** — Épuiser les moyens de vérification et en référer.

#### 500 — `pp-cloture-intervention-transmission-service` ✅
**Thème** `procedure-penale` · **moyen** · premium · *fin de service, 6 h*
**Titre** — « Le dossier part avec trois éléments manquants »
**Tension** — Qualité de la transmission conditionnant toute la suite.
**Angle distinctif** — Dernière étape, souvent négligée. **Cas de clôture du catalogue.**
**Poids fort** — Vérifier la complétude avant transmission.

---

## 8. RAPPEL FINAL AVANT PRODUCTION

Avant de produire un cas, vérifier ces cinq points :

1. **Le § 3 a été lu** — format JSON, densité, pondération, règles rédactionnelles.
2. **L'angle distinctif de la fiche est respecté** — c'est lui qui évite le doublon.
3. **La pondération est propre à ce cas** — le poids fort correspond à la fiche.
4. **Le contrôle qualité passe sans erreur bloquante** avant toute migration.
5. **Le statut est mis à jour dans ce fichier** après production.

### Rappel des interdits

Aucune technique opérationnelle · aucun article de loi cité sans certitude ·
aucune procédure inventée · aucun cas dans les fichiers Dart legacy · aucune
suppression de données · aucune désactivation de RLS.

### Commandes de référence

```bash
# Contrôle qualité d'un lot
python scripts/cas_pratique/controle_qualite.py \
    scripts/cas_pratique/lots/lot_NNN.json \
    --contre scripts/cas_pratique/catalogue_existant.json

# Génération de la migration
python scripts/cas_pratique/generer_migration.py --lot "lot_NNN"

# Application
supabase db push

# Vérifications Flutter
flutter analyze
flutter test
```

---

**Fin du plan — 500 cas répertoriés.**
