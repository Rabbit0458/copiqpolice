# PROMPT AUTONOME — GÉNÉRATION 9M+ QUESTIONS CULTURE GÉNÉRALE
## Application CoPiQ Police Nationale

---

## CONTEXTE

Tu travailles sur l'application mobile Flutter **CoPiQ** (application de préparation au concours de la Police Nationale). Tu dois travailler **entièrement seul, sans intervention humaine**, toute la nuit. Ne demande jamais de confirmation, ne pose jamais de question. Prends toutes les décisions toi-même et continue jusqu'à la fin.

L'application récupère les questions depuis la table Supabase `quiz_questions`. Chaque module de culture générale filtre les questions par la colonne `category` avec une valeur exacte. Tu dois donc t'assurer que chaque question insérée porte la bonne valeur de `category`.

---

## STRUCTURE DE LA TABLE

```sql
CREATE TABLE public.quiz_questions (
  id          bigserial PRIMARY KEY,
  module      text NOT NULL,
  category    text NOT NULL,
  difficulty  text,
  question    text NOT NULL,
  options     jsonb NOT NULL DEFAULT '[]',
  answer      text NOT NULL,
  explanation text,
  sub         text,
  rand_key    double precision NOT NULL DEFAULT random()
);
```

### Colonnes importantes
- **module** : toujours `'Culture générale'` pour tout ce travail
- **category** : valeur EXACTE filtrée par l'app (voir mapping ci-dessous)
- **difficulty** : `'Facile'`, `'Moyen'`, ou `'Difficile'`
- **question** : texte de la question, unique, jamais un doublon
- **options** : JSON array de 4 strings, ex: `["Paris","Lyon","Marseille","Bordeaux"]`
- **answer** : une des 4 options, la bonne réponse
- **explanation** : explication détaillée (minimum 2 phrases, sourcée si possible)
- **sub** : sous-thème optionnel (ex: `'Coupe du Monde'`, `'Anatomie'`, `'Code de la route'`…)
- **rand_key** : NE PAS RENSEIGNER — valeur auto via `DEFAULT random()`

---

## MAPPING CATÉGORIES — VALEURS EXACTES EN BASE

| Fichier Dart | Valeur exacte `category` en DB |
|---|---|
| `quiz_culture_generale_sport.dart` | `Culture générale — Sport` |
| `quiz_culture_generale_musique.dart` | `Culture générale — Arts (Musique)` |
| `quiz_culture_generale_mythologie.dart` | `Culture générale — Mythologie` |
| `quiz_culture_generale_police.dart` | `Culture générale — Police (culture pro)` |
| `quiz_culture_generale_sante.dart` | `Culture générale — Santé (prévention)` |
| `quiz_culture_generale_sciences.dart` | `Culture générale — Sciences` |
| `quiz_culture_generale_securite_routiere.dart` | `Culture générale — Sécurité routière` |
| `quiz_culture_generale_actualite.dart` | `Actualité internationale — ONU` **ou** `Actualité internationale — UE` **ou** `Actualité internationale — Conflits` **ou** `Actualité internationale — Grandes puissances` **ou** `Société française — Laïcité` **ou** `Société française — Égalité` **ou** `Société française — Immigration` **ou** `Société française — Démographie` **ou** `Grands débats contemporains — Écologie` **ou** `Grands débats contemporains — Énergie` **ou** `Grands débats contemporains — Intelligence artificielle` |
| `quiz_culture_generale_institutions_europeens.dart` | `Institutions européennes — UE` **ou** `Institutions européennes — Construction européenne` **ou** `Fonction publique — France` |
| `quiz_culture_generale_droit.dart` | `Droit` |
| `quiz_culture_generale_france.dart` | `Humanites` |
| `quiz_culture_generale_geographie.dart` | `Geographie` |
| `quiz_culture_generale_cinema.dart` | `Cinéma` |
| `quiz_culture_generale_histoire_france.dart` | `Histoire` |

> ⚠️ **CRITIQUE** : Ces valeurs doivent être copiées EXACTEMENT (accents, tirets, espaces, majuscules). Une erreur de typo = questions invisibles dans l'app.

---

## ÉTAPE 1 — NETTOYAGE DES DOUBLONS

### Objectif
Supprimer les questions en double dans la table `quiz_questions`. Garder au maximum 5 questions très similaires sur un même sous-thème précis. Pour les questions quasi-identiques (reformulation mineure, même fond), ne garder qu'une seule.

### Méthode SQL recommandée

```sql
-- 1. Identifier les doublons exacts (même texte de question)
WITH duplicates AS (
  SELECT id,
         ROW_NUMBER() OVER (
           PARTITION BY LOWER(TRIM(question))
           ORDER BY id ASC
         ) AS rn
  FROM quiz_questions
)
DELETE FROM quiz_questions
WHERE id IN (SELECT id FROM duplicates WHERE rn > 1);

-- 2. Identifier les quasi-doublons (similarity > 0.85) si extension pg_trgm disponible
-- Activer d'abord l'extension si besoin :
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Supprimer les quasi-doublons par catégorie
WITH similar AS (
  SELECT a.id AS id_to_delete
  FROM quiz_questions a
  JOIN quiz_questions b ON a.category = b.category
                        AND a.id > b.id
                        AND similarity(a.question, b.question) > 0.82
)
DELETE FROM quiz_questions
WHERE id IN (SELECT id_to_delete FROM similar);

-- 3. Compter ce qui reste par catégorie
SELECT category, COUNT(*) as total
FROM quiz_questions
GROUP BY category
ORDER BY total DESC;
```

### Après nettoyage
- Logue le nombre de questions supprimées et le nombre restant par catégorie
- Continue vers l'Étape 2

---

## ÉTAPE 2 — GÉNÉRATION DES QUESTIONS

### Cibles par catégorie

| Catégorie DB | Volume cible | Thèmes à couvrir |
|---|---|---|
| `Culture générale — Sport` | **1 000 000** | Football (LFP, Champions League, Coupes du Monde), Rugby (Top 14, RWC), Basketball (NBA, Pro B), Tennis, Cyclisme, Athlétisme, JO, Natation, Boxe, Sports d'hiver, Formule 1, Handball, Volleyball, Sports français, Records mondiaux, Stades, Légendes du sport |
| `Culture générale — Arts (Musique)` | **1 000 000** | Musique classique, Jazz, Rock, Pop française, Pop mondiale, Rap français, Rap US, Électro, Variété française, Opéra, Instruments de musique, Artistes légendaires, Albums iconiques, Histoire de la musique, Prix musicaux, Fêtes de la musique |
| `Culture générale — Mythologie` | **1 000 000** | Mythologie grecque (dieux, héros, créatures), Mythologie romaine, Mythologie nordique, Mythologie égyptienne, Mythologie celtique, Mythologie japonaise, Légendes et épopées, Symbolisme mythologique, Personnages (Zeus, Athéna, Thor, Osiris, etc.) |
| `Culture générale — Police (culture pro)` | **2 000 000** | Histoire de la Police Nationale, Organisation de la PN (DGPN, DCPJ, DCSP, etc.), Grades et hiérarchie, Textes fondamentaux (code pénal, code de procédure pénale), Déontologie policière, Droits et devoirs du fonctionnaire, Missions de la PN, Police judiciaire vs administrative, RAID, BRI, BAC, BSPP, Interpol, Europol, Sécurité publique, Police de proximité, Garde à vue, Légale (IJ), Armement réglementaire, Procédures d'urgence (15-17-18-112), Code de déontologie, Loi du 24 juillet 2023, Réforme de la Police, Histoire des grands crimes résolus en France, Criminalité organisée, Cyberpolice |
| `Culture générale — Santé (prévention)` | **1 000 000** | Anatomie humaine, Biologie, Maladies courantes, Prévention santé, Nutrition, Hygiène, Premiers secours (PSC1, BLS), Médicaments et pharmacologie de base, Système de santé français (Sécurité sociale, hôpital), Santé mentale, Addictions, Maladies infectieuses, Vaccins, Cancer, Diabète, Maladies cardiovasculaires, OMS, Épidémies, Gestes qui sauvent |
| `Culture générale — Sciences` | **1 000 000** | Physique (lois fondamentales, relativité, quantique), Chimie (éléments, réactions, tableau périodique), Biologie (ADN, évolution, cellules), Mathématiques (concepts fondamentaux), Astronomie (planètes, étoiles, univers), Sciences de la Terre (géologie, climatologie), Informatique (algorithmes, Internet, IA), Inventions majeures, Scientifiques célèbres (Newton, Einstein, Curie, Darwin…), Prix Nobel, Technologies modernes, Énergies renouvelables |
| `Culture générale — Sécurité routière` | **500 000** | Code de la route (panneaux, priorités, limitations), Infractions et sanctions, Permis de conduire (catégories, points), Alcool et conduite, Stupéfiants et conduite, Statistiques accidentologie, Équipements de sécurité, Règles pour deux-roues, Véhicules d'urgence, Autoroutes et péages, Signalisation horizontale/verticale, Responsabilité civile, Assurance auto, Zones de danger, Règles piétons/cyclistes |
| `Actualité internationale — ONU` (+ autres sous-cat actualité) | **1 000 000 répartis** | ONU (résolutions, Conseil de sécurité, agences), UE (traités, Parlement, présidents), Conflits géopolitiques, Grandes puissances (USA, Chine, Russie, Inde), Laïcité française, Égalité hommes-femmes, Immigration et asile, Démographie mondiale, Écologie (COP, réchauffement, biodiversité), Énergie (nucléaire, renouvelables), Intelligence artificielle (éthique, réglementation, acteurs), Économie mondiale, OTAN, G7/G20 |
| `Institutions européennes — UE` (+ sous-cat institutions) | **1 000 000 répartis** | Institutions de l'UE (Parlement, Commission, Conseil, Cour de justice), Traités fondateurs (Rome, Maastricht, Lisbonne), Histoire de la construction européenne, Zone euro, Schengen, Droits fondamentaux, PESC, Fonctionnement de la fonction publique française, Droits de la fonction publique, Statut général des fonctionnaires |
| `Droit` | **1 000 000** | Droit constitutionnel (Ve République, Constitution de 1958, Préambule, DDHC), Droit pénal (infractions, peines, récidive, prescription), Procédure pénale (enquête, instruction, jugement), Droit civil (contrats, famille, successions, propriété), Droit administratif (actes, recours, juridictions), Droit du travail, Droit européen, Libertés fondamentales, Jurisprudence du Conseil Constitutionnel et de la CEDH, Notions clés (présomption d'innocence, non bis in idem, in dubio pro reo…) |
| `Humanites` | **1 000 000** | Géographie de la France (régions, départements, préfectures, superficies, reliefs, fleuves), Villes françaises (population, particularités), Économie française (PIB, secteurs, entreprises du CAC 40), Présidents de la République (depuis 1958), Gouvernements, Symboles républicains (drapeau, hymne, devise), Personnalités françaises célèbres (littérature, arts, sciences, politique), Gastronomie française, Culture et traditions, DOM-TOM, Langues régionales, Francophonie |
| `Geographie` | **1 000 000** | Capitales du monde, Pays et superficies, Populations mondiales, Océans et mers, Fleuves et montagnes, Déserts, Continents, Reliefs majeurs, Pays sans accès à la mer, Îles, Géographie physique mondiale, Fuseaux horaires, Pays membres ONU/UE/OTAN, Géographie économique (PIB, ressources naturelles), Catastrophes naturelles et zones sismiques |
| `Cinéma` | **1 000 000** | Films français et mondiaux (réalisateurs, acteurs, dates), Palmarès Oscars / César / Cannes / Golden Globes, Grands réalisateurs (Godard, Truffaut, Spielberg, Kubrick…), Franchises cinématographiques, Genres cinématographiques, Histoire du cinéma (cinéma muet, Hollywood classique), Effets spéciaux, Box-office mondial, Documentaires, Séries TV majeures, Acteurs légendaires (chaplin, Gabin, Deneuve, Depardieu, Belmondo) |
| `Histoire` | **1 000 000** | Préhistoire et Antiquité, Moyen Âge français (Capétiens, Guerre de Cent Ans, Jeanne d'Arc), Monarchie absolue (Richelieu, Louis XIV), Révolution française (1789-1799 : causes, personnages, événements clés), Napoléon et l'Empire, XIXe siècle (IIe République, Second Empire, Commune), Première Guerre mondiale (causes, batailles, armistice), Entre-deux-guerres, Seconde Guerre mondiale (occupation, résistance, libération, collaboration, Shoah), IVe République, Ve République, Décolonisation, Mai 68, Histoire de France récente |

---

## ÉTAPE 3 — RÈGLES QUALITÉ (OBLIGATOIRES)

### Format de chaque question
```json
{
  "module": "Culture générale",
  "category": "<valeur exacte du mapping>",
  "difficulty": "Facile" | "Moyen" | "Difficile",
  "question": "Texte de la question, clair, précis, sans ambiguïté ?",
  "options": ["Réponse A", "Réponse B", "Réponse C", "Réponse D"],
  "answer": "Réponse B",
  "explanation": "Explication détaillée de 2 à 5 phrases. Contexte, date, source si pertinent.",
  "sub": "Sous-thème optionnel"
}
```

### Règles strictes
1. **Unicité** : chaque question doit être unique. Jamais 2 questions avec le même sens, même reformulée.
2. **4 options toujours** : le champ `options` contient EXACTEMENT 4 éléments.
3. **Bonne réponse dans les options** : `answer` doit être identique à l'un des éléments de `options`.
4. **Explication réelle** : pas de "La réponse est X car X est correct." — toujours donner du contexte, une date, une source, un fait complémentaire.
5. **Distribution des niveaux** : 35% Facile, 40% Moyen, 25% Difficile.
6. **Pas de questions politiquement orientées** sur des personnalités vivantes.
7. **Catégorie stricte** : une question sur la biologie ne va PAS dans `Droit`. Une question sur Beethoven ne va PAS dans `Culture générale — Sport`.
8. **Langue française** : tout en français, orthographe correcte.
9. **Véracité** : toutes les réponses doivent être factuellement correctes. Ne pas inventer.
10. **Diversité** : dans 1 million de questions Sport, couvrir TOUS les sports, pas uniquement le football.

---

## ÉTAPE 4 — INSERTION EN BASE DE DONNÉES

### Méthode d'insertion (via Supabase MCP ou SQL)

Travailler **catégorie par catégorie**. Pour chaque catégorie :
1. Générer 50 000 questions en mémoire
2. Les insérer en batch SQL de 1 000 lignes à la fois
3. Vérifier le count après chaque batch
4. Logger les progrès : `[Sport] 50 000 / 1 000 000 insérées`
5. Répéter jusqu'à atteindre la cible

### Script d'insertion batch recommandé (Python)

```python
import json
import time
import random
from supabase import create_client

# Connexion Supabase (utiliser les variables d'environnement du projet)
# URL et clé disponibles via: supabase get_project_url et get_publishable_keys

BATCH_SIZE = 500  # nombre de questions par INSERT

def insert_batch(supabase, questions: list):
    """Insère un batch de questions dans quiz_questions."""
    data = []
    for q in questions:
        data.append({
            "module": q["module"],
            "category": q["category"],
            "difficulty": q["difficulty"],
            "question": q["question"],
            "options": q["options"],
            "answer": q["answer"],
            "explanation": q.get("explanation", ""),
            "sub": q.get("sub", None),
        })
    try:
        result = supabase.table("quiz_questions").insert(data).execute()
        return len(data)
    except Exception as e:
        print(f"Erreur batch: {e}")
        time.sleep(2)
        return 0

def get_current_count(supabase, category: str) -> int:
    """Retourne le nombre de questions existantes pour une catégorie."""
    result = supabase.table("quiz_questions") \
        .select("id", count="exact") \
        .eq("category", category) \
        .execute()
    return result.count or 0
```

### Vérification finale
Après toutes les insertions, exécuter :
```sql
SELECT 
  category,
  COUNT(*) as total,
  COUNT(CASE WHEN difficulty = 'Facile' THEN 1 END) as facile,
  COUNT(CASE WHEN difficulty = 'Moyen' THEN 1 END) as moyen,
  COUNT(CASE WHEN difficulty = 'Difficile' THEN 1 END) as difficile
FROM quiz_questions
WHERE module = 'Culture générale'
GROUP BY category
ORDER BY total DESC;
```

---

## ORDRE D'EXÉCUTION

Exécute dans cet ordre, sans t'arrêter :

1. **Nettoyage** → supprimer tous les doublons exacts et quasi-doublons (`similarity > 0.82`)
2. **Police** → 2 000 000 questions (priorité max, le plus de matière)
3. **Sport** → 1 000 000 questions
4. **Sciences** → 1 000 000 questions
5. **Droit** → 1 000 000 questions
6. **Géographie** → 1 000 000 questions (catégorie DB: `Geographie`)
7. **Histoire France** → 1 000 000 questions (catégorie DB: `Histoire`)
8. **Humanités/France** → 1 000 000 questions (catégorie DB: `Humanites`)
9. **Cinéma** → 1 000 000 questions (catégorie DB: `Cinéma`)
10. **Musique** → 1 000 000 questions
11. **Santé** → 1 000 000 questions
12. **Mythologie** → 1 000 000 questions
13. **Actualité** → 1 000 000 questions (répartir entre les sous-catégories)
14. **Institutions européennes** → 1 000 000 questions (répartir entre les sous-catégories)
15. **Sécurité routière** → 500 000 questions
16. **Vérification globale** → SQL de comptage final par catégorie
17. **Rapport final** → écrire un fichier `RAPPORT_GENERATION.md` avec les stats

---

## CONSIGNES GÉNÉRALES D'AUTONOMIE

- **Ne jamais attendre une validation humaine** — prends toutes les décisions seul.
- **En cas d'erreur SQL** → corriger et réessayer automatiquement jusqu'à 3 fois.
- **En cas de timeout Supabase** → attendre 5 secondes, réduire le batch à 200, réessayer.
- **En cas de question déjà existante** → utiliser `ON CONFLICT DO NOTHING` ou tester l'unicité avant insert.
- **Logger régulièrement** : afficher un log toutes les 10 000 questions insérées.
- **Priorité à la qualité** : mieux vaut 500 000 questions excellentes que 1 million de questions médiocres. Mais vise la cible quand même.
- **Variété** : dans chaque catégorie, couvrir TOUS les sous-thèmes listés ci-dessus, pas seulement les plus faciles.

---

## INFORMATIONS SUPABASE

Le projet Supabase est accessible via le MCP Supabase connecté dans cette session.
- Utilise `list_projects` pour obtenir l'ID du projet CoPiQ
- Utilise `execute_sql` pour les requêtes SQL directes
- Utilise `get_project_url` et `get_publishable_keys` pour la connexion client Python si nécessaire

---

## FICHIERS DE RÉFÉRENCE

Les fichiers Dart de l'application se trouvent dans :
```
C:\Users\kaiso\Desktop\copiqpolice\lib\content\gpx_exam\culture_generale\
```
Ces fichiers contiennent des exemples de questions déjà codées. Tu peux t'en inspirer pour comprendre le format et le niveau attendu, mais **ne pas les dupliquer**.

---

*Prompt généré automatiquement pour une exécution autonome overnight.*
*Toute modification manuelle doit respecter les valeurs exactes du mapping catégories.*
