export interface BlogArticle {
  slug: string
  title: string
  description: string
  author: string
  date: string
  category: string
  readTime: number
  content: string
  keywords: string[]
}

export const BLOG_ARTICLES: BlogArticle[] = [
  {
    slug: "comment-reussir-concours-policier-adjoint",
    title: "Comment réussir le concours de Policier Adjoint en 2025 ?",
    description: "Guide complet pour préparer et réussir le concours PA : épreuves, programme, méthodes de révision et conseils pratiques.",
    author: "Équipe COP'IQ",
    date: "2025-04-15",
    category: "Préparation concours",
    readTime: 8,
    keywords: ["concours policier adjoint", "PA police nationale", "concours PA 2025", "préparer concours police"],
    content: `## Le concours de Policier Adjoint

Le concours de **Policier Adjoint (PA)** est l'un des concours de la Police Nationale les plus accessibles. Il permet d'intégrer la Police Nationale en tant qu'agent contractuel de catégorie C.

### Les conditions d'accès

Pour passer le concours PA, vous devez :
- Avoir la **nationalité française**
- Être âgé de **17 ans minimum** (et moins de 30 ans pour certains postes)
- Jouir de vos **droits civiques**
- Avoir accompli votre **Journée de Défense et Citoyenneté (JDC)**
- Posséder le **permis B** (obligatoire)
- Satisfaire aux conditions d'aptitude **physique et médicale**

### Les épreuves du concours PA

**1. Les épreuves écrites**
- **QCM de culture générale** (30 minutes) : connaissances générales, actualités, droit
- **Exercice de raisonnement logique** : suites logiques, matrices, analogies

**2. Les épreuves physiques**
- Test d'endurance aérobie (navette)
- Abdominaux
- Course de vitesse

**3. L'entretien de personnalité**
Face à un jury, vous présenterez votre projet professionnel et vos motivations.

### Méthode de révision efficace

**Planning de révision sur 3 mois :**

*Mois 1 — Les bases*
- Droit pénal : classification des infractions, éléments constitutifs
- Institutions françaises : Ve République, collectivités
- Psychotechniques : 30 min/jour (séries logiques, calcul mental)

*Mois 2 — Approfondissement*
- Procédure pénale : garde à vue, perquisitions
- Culture générale : histoire, géographie
- Entraînement aux QCM

*Mois 3 — Entraînement intensif*
- Concours blancs complets
- Correction détaillée de chaque erreur
- Préparation à l'entretien oral

### Les erreurs à éviter

- **Négliger les psychotechniques** : souvent sous-estimées, elles font la différence
- **Bachoter sans comprendre** : le jury teste la logique, pas la mémoire
- **Ne pas s'entraîner aux conditions réelles** : chronométrez vos essais
- **Oublier la préparation physique** : les épreuves physiques sont éliminatoires

### Utiliser COP'IQ pour se préparer

COP'IQ rassemble tout ce dont vous avez besoin : cours structurés, QCM par thème, psychotechniques interactifs et statistiques de progression. En mode gratuit, vous accédez à 10 exercices par semaine — en mode Premium, accès illimité à tout le contenu.`
  },
  {
    slug: "droit-penal-police-nationale-essentiel",
    title: "Droit pénal pour le concours de police : l'essentiel à savoir",
    description: "Maîtrisez les notions clés du droit pénal pour le concours PA et GPX : classification des infractions, responsabilité pénale, circonstances aggravantes.",
    author: "Équipe COP'IQ",
    date: "2025-05-02",
    category: "Cours",
    readTime: 10,
    keywords: ["droit pénal police nationale", "classification infractions concours", "cours droit pénal PA GPX"],
    content: `## Droit pénal : ce qu'il faut savoir pour le concours

Le droit pénal est l'une des matières centrales des concours de la Police Nationale, aussi bien pour le concours **PA** que pour le concours **GPX**. Voici les notions fondamentales à maîtriser.

### La classification tripartite des infractions

Le Code pénal classe les infractions en trois catégories (art. 111-1 CP) :

| Catégorie | Juridiction | Peine max |
|-----------|-------------|-----------|
| Crime | Cour d'assises | Réclusion criminelle à perpétuité |
| Délit | Tribunal correctionnel | 10 ans + amende |
| Contravention | Tribunal de police | Amende (5 classes) |

**Astuce mnémotechnique** : "CDC" — Crime = Cour d'assises, Délit = Correctionnel, Contravention = C'est le tribunal de police.

### Les éléments constitutifs

Toute infraction suppose la réunion de **3 éléments** :

**1. Élément légal** : nul crime sans loi (**nullum crimen sine lege**). L'infraction doit être prévue par un texte.

**2. Élément matériel** : l'acte ou l'omission doit être concrètement réalisé.
- Infraction de commission : acte positif
- Infraction d'omission : abstention (non-assistance à personne en danger)
- Infraction formelle : consommée par les actes seuls
- Infraction de résultat : nécessite le résultat dommageable

**3. Élément moral** (intentionnel) :
- Intentionnel : dol général + dol spécial
- Non intentionnel : négligence, imprudence
- Contraventionnel : élément moral non requis

### La tentative

La tentative n'est punissable que pour les **crimes** et les **délits** (art. 121-4 CP). Deux conditions :
1. Un **commencement d'exécution** (acte immédiatement tendant à la commission)
2. L'**absence de désistement volontaire**

### La récidive

La récidive entraîne un **doublement du maximum de la peine** (art. 132-8 à 132-15 CP). Conditions :
- **Récidive légale générale** (crimes → crimes) : condamnation définitive antérieure
- **Récidive légale spéciale** : même infraction ou infractions similaires

### Les causes d'irresponsabilité

Les causes d'irresponsabilité **objectives** (faits justificatifs) :
- Ordre de la loi (art. 122-4)
- Légitime défense (art. 122-5) — réponse proportionnée à une attaque injuste actuelle
- État de nécessité (art. 122-7)

Les causes **subjectives** (troubles de la volonté) :
- Trouble mental (art. 122-1) — irresponsabilité si abolition du discernement
- Contrainte (art. 122-2) — irrésistible et imprévisible
- Erreur de droit (art. 122-3) — invincible`
  },
  {
    slug: "cas-pratiques-gpx-methode-reussir",
    title: "Les cas pratiques GPX : méthode et conseils pour les réussir",
    description: "Comment structurer et rédiger un cas pratique pour le concours de Gardien de la Paix ? Méthode complète avec exemples.",
    author: "Équipe COP'IQ",
    date: "2025-05-20",
    category: "Méthode",
    readTime: 12,
    keywords: ["cas pratique GPX méthode", "rédaction cas pratique police", "concours Gardien de la Paix", "exercice GPX"],
    content: `## Les cas pratiques GPX : méthode complète

L'épreuve de **cas pratique** est au cœur du concours de **Gardien de la Paix (GPX)**. Elle évalue votre capacité à analyser une situation juridique réelle et à rédiger une réponse structurée et argumentée.

### Structure d'un cas pratique réussi

**1. La qualification juridique des faits**
Commencez toujours par identifier les infractions potentielles :
- Quelle(s) infraction(s) les faits pourraient-ils constituer ?
- Quels sont les éléments constitutifs présents ou manquants ?
- Quelle est la qualification exacte (crime, délit, contravention) ?

**2. L'analyse des circonstances**
Vérifiez :
- Y a-t-il des **circonstances aggravantes** ? (nuit, en réunion, sur mineur, avec arme...)
- Des **causes d'irresponsabilité** sont-elles invocables ?
- Quelle est la **qualité des protagonistes** ? (majeur/mineur, récidiviste, auteur/complice)

**3. La procédure applicable**
- Quel type d'enquête ? (flagrance, préliminaire, sur commission rogatoire)
- Quelles mesures de contrainte sont possibles ? (GAV, perquisition, saisie...)
- Quelle est la juridiction compétente ?

**4. La rédaction**
Votre réponse doit être :
- **Structurée** : introduction, développement, conclusion
- **Argumentée** : citez les articles de loi pertinents
- **Précise** : qualifications exactes, durées exactes
- **Neutre** : pas de jugement moral, analyse juridique uniquement

### Exemple de cas pratique

**Situation** : "Le 15 novembre 2024 à 23h30, M. X, 35 ans, déjà condamné pour vol en 2022, pénètre par effraction dans la bijouterie Dupont et dérobe des montres pour une valeur de 50 000€."

**Analyse :**

*Qualification juridique*
- **Vol** (art. 311-1 CP) : soustraction frauduleuse de la chose d'autrui
- Circonstances aggravantes :
  - Effraction (art. 311-4) → peine portée à 5 ans
  - Nuit → circonstance aggravante supplémentaire
  - **Récidive** : condamnation antérieure pour vol → doublement possible

*Procédure*
- **Flagrance** si découverte récente
- **GAV** possible : délit, peine > 1 an
- Durée initiale : 24h + 24h = **48h max** (droit commun)

### Les erreurs classiques à éviter

1. **Oublier la récidive** → peine doublée, mentionnez-la systématiquement
2. **Confondre auteur et complice** → conséquences procédurales différentes
3. **Négliger les circonstances aggravantes** → changement de qualification
4. **Citer la loi de mémoire inexacte** → préférez "les dispositions du Code pénal" si incertain
5. **Réponse trop courte** → développez chaque point

### S'entraîner avec COP'IQ

Sur COP'IQ, l'IA corrige vos cas pratiques en temps réel : détection des qualifications manquées, des circonstances oubliées, feedback personnalisé sur votre style rédactionnel. Disponible en mode Premium avec accès illimité.`
  },
  {
    slug: "psychotechniques-police-nationale-conseils",
    title: "Psychotechniques Police Nationale : entraînement et méthodes",
    description: "Tout sur les épreuves psychotechniques des concours de police : types d'exercices, méthodes de résolution et entraînement efficace.",
    author: "Équipe COP'IQ",
    date: "2025-06-01",
    category: "Psychotechniques",
    readTime: 7,
    keywords: ["psychotechniques police nationale", "exercices psychotechniques concours police", "suites logiques", "calcul mental concours"],
    content: `## Les épreuves psychotechniques aux concours de police

Les **épreuves psychotechniques** sont présentes dans quasiment tous les concours de la Police Nationale. Elles évaluent des aptitudes cognitives fondamentales : raisonnement logique, calcul, concentration, mémoire.

### Les types d'épreuves

**1. Suites logiques (numériques et figurales)**
On vous présente une suite de chiffres ou de figures, et il faut trouver le terme suivant.

*Méthode* :
- Calculez les différences entre termes successifs
- Cherchez un rapport (×2, ×3, ÷2...)
- Cherchez une alternance de deux suites imbriquées
- Regardez si les figures tournent, s'agrandissent, s'inversent...

**2. Calcul mental**
Opérations arithmétiques à effectuer rapidement : additions, soustractions, multiplications, divisions, pourcentages.

*Méthode* :
- Tables de multiplication jusqu'à 20 × 20 à connaître par cœur
- Technique des calculs par approximation puis correction
- 30 minutes de calcul mental/jour pendant 2 mois

**3. Raisonnement logique (syllogismes)**
Propositions → conclusion. "Tous les A sont des B. X est un A. Donc..."

*Méthode* :
- Dessinez des diagrammes de Venn
- Ne jamais supposer plus que ce qui est dit
- Répondre "indéterminé" si la conclusion ne découle pas nécessairement

**4. Concentration (tableaux, repérage)**
Repérer des éléments dans une grille, compter des figures identiques, associer symboles et lettres.

*Méthode* :
- Balayage systématique ligne par ligne
- Marquez mentalement les éléments trouvés
- Vitesse + rigueur = s'entraîner sous minuterie

**5. Spatial (rotation, pliage)**
Visualiser des formes en 3D, identifier des figures identiques par rotation, déplier des boîtes.

*Méthode* :
- Manipulez des objets physiques pour développer la vision spatiale
- Exercez-vous sur des cubes et des développements de solides

### Planning d'entraînement

**30 min/jour** suffisent si vous êtes régulier :
- Lundi : suites logiques (15 min) + syllogismes (15 min)
- Mardi : calcul mental (20 min) + spatial (10 min)
- Mercredi : concentration (30 min)
- Jeudi : suites figurales (15 min) + calcul (15 min)
- Vendredi : concours blanc psychotechniques complet
- Week-end : correction et révision des erreurs

### Sur COP'IQ

La section Psychotechniques de COP'IQ propose des exercices interactifs dans chaque catégorie, avec timer et score. Entraînez-vous en conditions réelles pour maximiser vos chances.`
  },
]

export function getArticleBySlug(slug: string) {
  return BLOG_ARTICLES.find(a => a.slug === slug)
}
