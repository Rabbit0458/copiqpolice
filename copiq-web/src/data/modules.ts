export interface CourseModule {
  id: string
  title: string
  description: string
  sections: CourseSection[]
  isPremium: boolean
  category: "pa" | "gpx" | "common"
  icon: string
  color: string
  xpReward: number
}

export interface CourseSection {
  id: string
  title: string
  content: string
}

export const PA_COURSE_MODULES: CourseModule[] = [
  {
    id: "droit-penal-pa",
    title: "Droit Pénal",
    description: "Infractions, éléments constitutifs, classification des infractions, co-auteurs et complices.",
    isPremium: false,
    category: "pa",
    icon: "⚖️",
    color: "#1147D9",
    xpReward: 50,
    sections: [
      {
        id: "classification",
        title: "Classification des infractions",
        content: `## Classification des infractions

Les infractions pénales sont classées en trois catégories selon leur gravité :

### 1. Les crimes
Les crimes sont les infractions les plus graves. Ils sont jugés par la **Cour d'assises**. Les peines encourues sont la réclusion criminelle (peines d'emprisonnement allant de 15 ans à la perpétuité) ou la détention criminelle.

**Exemples** : meurtre, viol, actes de terrorisme, trafic de stupéfiants aggravé.

### 2. Les délits
Les délits sont des infractions de gravité intermédiaire. Ils sont jugés par le **Tribunal correctionnel**. Les peines peuvent aller jusqu'à 10 ans d'emprisonnement et/ou amende.

**Exemples** : vol simple, escroquerie, violences volontaires ayant entraîné une ITT > 8 jours, conduite en état d'ivresse.

### 3. Les contraventions
Les contraventions sont les infractions les moins graves. Elles sont jugées par le **Tribunal de police**. Elles sont divisées en 5 classes selon la gravité (amende de 38€ à 1 500€, voire 3 000€ en cas de récidive).

**Exemples** : stationnement interdit (C1), bruit nocturne (C3), excès de vitesse ≤ 20 km/h (C4), violences sans ITT (C5).

> ⚡ **Point clé** : La tentative n'est punissable que pour les crimes et les délits (art. 121-4 CP). La tentative de contravention n'est pas punissable.`
      },
      {
        id: "elements-constitutifs",
        title: "Éléments constitutifs de l'infraction",
        content: `## Éléments constitutifs de l'infraction

Pour qu'une infraction soit constituée, **trois éléments** doivent être réunis :

### 1. L'élément légal
L'infraction doit être prévue et punie par un texte de loi (**principe de légalité** : « Nul crime, nul délit sans loi »). Les crimes et délits sont prévus par la loi ; les contraventions par le règlement (décret).

### 2. L'élément matériel
L'infraction doit se manifester par un acte ou une omission :
- **Infraction de commission** : accomplissement d'un acte positif (ex. : vol)
- **Infraction d'omission** : abstention punissable (ex. : non-assistance à personne en danger)
- **Infraction de résultat** : l'infraction est consommée uniquement si le résultat dommageable se produit
- **Infraction formelle** : consommée par la seule réalisation des actes, peu importe le résultat (ex. : empoisonnement)

### 3. L'élément moral (intentionnel)
- **Infractions intentionnelles** (crimes et délits intentionnels) : nécessitent une **intention coupable** = dol général (conscience d'agir illicitement) + dol spécial (but poursuivi)
- **Infractions non intentionnelles** (délits de négligence) : faute d'imprudence, de négligence ou de manquement à une obligation de prudence
- **Contraventions** : pas besoin de démontrer l'intention (infraction dite matérielle)

> 🎯 **Astuce concours** : Retenez l'acronyme **ELM** : Élément Légal, Matériel, Moral.`
      },
      {
        id: "responsabilite-penale",
        title: "Responsabilité pénale",
        content: `## Responsabilité pénale

### Principe de personnalité des peines
Nul n'est responsable pénalement que de son propre fait (art. 121-1 CP).

### Causes d'irresponsabilité pénale
Les causes d'irresponsabilité **suppriment l'infraction** ou la culpabilité :

| Cause | Effet | Exemple |
|-------|-------|---------|
| Trouble mental (art. 122-1 al. 1) | Irresponsabilité totale | Schizophrène lors de l'acte |
| Contrainte (art. 122-2) | Irresponsabilité si contrainte irrésistible | Force majeure |
| Erreur de droit (art. 122-3) | Irresponsabilité si invincible | Décision erronée d'une autorité |
| Légitime défense (art. 122-5) | Fait justificatif | Agression actuelle et injustifiée |
| État de nécessité (art. 122-7) | Fait justificatif | Danger actuel pour soi ou autrui |
| Ordre de la loi (art. 122-4) | Fait justificatif | Actes autorisés par la loi |
| Minorité (< 13 ans) | Présomption d'irresponsabilité | Enfant < 13 ans |

### Participation à l'infraction
- **Auteur** (art. 121-4) : commet les faits ou tente de les commettre
- **Coauteur** : commet l'infraction avec d'autres personnes
- **Complice** (art. 121-7) : aide ou assiste, provoque ou donne des instructions
  - Le complice est puni **comme l'auteur**`
      }
    ]
  },
  {
    id: "procedure-penale-pa",
    title: "Procédure Pénale",
    description: "Enquête, garde à vue, perquisitions, saisies, phases de la procédure pénale.",
    isPremium: false,
    category: "pa",
    icon: "🔍",
    color: "#8B5CF6",
    xpReward: 50,
    sections: [
      {
        id: "enquete",
        title: "Les enquêtes de police",
        content: `## Les enquêtes de police

### 1. L'enquête de flagrance (art. 53 CPP)
La flagrance s'applique lorsqu'un crime ou délit est **en train de se commettre** ou **vient de se commettre**.

**Critères de la flagrance :**
- Crime ou délit flagrant
- En cours de commission ou commis depuis très peu de temps
- Poursuite immédiate par la victime, public ou policiers

**Durée :** 8 jours (prorogeable de 8 jours par le Procureur si enquête complexe).

**Pouvoirs élargis des OPJ :**
- Perquisitions sans accord du parquet
- Garde à vue (24h + 24h sur autorisation du procureur)
- Saisies sans accord préalable

### 2. L'enquête préliminaire (art. 75 CPP)
S'applique **hors flagrance**, sur initiative de l'OPJ ou sur instructions du Procureur de la République.

**Caractéristiques :**
- Pas de contrainte en principe
- Perquisitions nécessitent le consentement écrit de la personne
- Durée non limitée en principe (mais contrôle du parquet)

### 3. L'enquête sur commission rogatoire
Actes d'investigation délégués par le **juge d'instruction** à un OPJ.`
      },
      {
        id: "garde-a-vue",
        title: "La garde à vue",
        content: `## La garde à vue (art. 62-2 CPP)

### Définition
Mesure privative de liberté permettant de retenir une personne pour les nécessités de l'enquête.

### Conditions
La GAV ne peut être décidée que si :
1. La personne est **suspectée** d'avoir commis un crime ou délit
2. La GAV est l'**unique moyen** de parvenir aux objectifs listés (art. 62-2 CPP)
3. Le crime ou délit est puni d'**au moins 1 an d'emprisonnement**

### Durée
| Cas | Durée initiale | Prolongation |
|-----|---------------|--------------|
| Droit commun | 24h | + 24h (magistrat) = **48h max** |
| Criminalité organisée | 48h | + 24h + 24h (JLD) = **96h max** |
| Terrorisme | 96h | + 24h + 24h (JLD) = **144h max** |

### Droits du gardé à vue (art. 63-1 CPP)
- Être informé de la nature de l'infraction reprochée
- Prévenir un proche
- Être examiné par un médecin
- Être assisté d'un avocat dès le début
- Être informé de son droit au silence
- Bénéficier d'un interprète si nécessaire
- Consulter les PV et documents de la procédure (si assisté d'un avocat)

> ⚠️ **Point de vigilance** : Le mineur de moins de 16 ans doit être assisté d'un avocat dès le début de la GAV (obligation, pas seulement un droit).`
      }
    ]
  },
  {
    id: "droit-administratif-pa",
    title: "Droit Administratif",
    description: "Organisation administrative, actes administratifs, contentieux administratif.",
    isPremium: true,
    category: "pa",
    icon: "🏛️",
    color: "#22C55E",
    xpReward: 75,
    sections: [
      {
        id: "organisation",
        title: "Organisation administrative",
        content: `## Organisation administrative française

### Principe de séparation des pouvoirs
La France est organisée selon le principe de séparation des pouvoirs (législatif, exécutif, judiciaire) et selon le principe de décentralisation.

### L'État central
- **Président de la République** : chef de l'État
- **Premier ministre** : chef du Gouvernement
- **Ministres** : responsables de leur département ministériel
- **Préfets** : représentants de l'État dans les départements et régions

### Les collectivités territoriales (art. 72 Constitution)
- **Communes** : 34 935 communes, administrées par le Conseil municipal + Maire
- **Départements** : 101 départements, administrés par le Conseil départemental
- **Régions** : 18 régions (13 métropolitaines + 5 outre-mer), administrées par le Conseil régional

### Déconcentration vs Décentralisation
| | Déconcentration | Décentralisation |
|--|-----------------|------------------|
| Qui décide ? | État (via agents locaux) | Collectivités territoriales |
| Exemples | Préfet, DDPP | Communes, Régions |
| Contrôle | Hiérarchique | Contrôle de légalité`
      }
    ]
  },
  {
    id: "institutions-pa",
    title: "Institutions",
    description: "Institutions françaises et européennes, Cinquième République.",
    isPremium: true,
    category: "pa",
    icon: "🏢",
    color: "#F59E0B",
    xpReward: 75,
    sections: [
      {
        id: "veme-republique",
        title: "La Ve République",
        content: `## La Ve République

### Fondements
La Ve République est née de la **Constitution du 4 octobre 1958**, adoptée par référendum. Elle instaure un régime **semi-présidentiel** combinant les caractéristiques du régime présidentiel et parlementaire.

### Les institutions
**Le Président de la République**
- Élu au suffrage universel direct (depuis 1962) pour 5 ans (quinquennat depuis 2000)
- Garant de la Constitution, chef des armées
- Nomme le Premier ministre, peut dissoudre l'Assemblée nationale (art. 12)
- Dispose du droit de grâce, peut recourir au référendum (art. 11)

**Le Parlement**
- **Assemblée nationale** : 577 députés, élus pour 5 ans, peut renverser le gouvernement
- **Sénat** : 348 sénateurs, élus pour 6 ans par les grands électeurs

**Le Gouvernement**
- Dirigé par le Premier ministre, nommé par le Président
- Responsable devant l'Assemblée nationale
- Détermine et conduit la politique de la Nation (art. 20)

**Le Conseil Constitutionnel**
- 9 membres nommés pour 9 ans (non renouvelable)
- Vérifie la constitutionnalité des lois
- Veille à la régularité des élections`
      }
    ]
  },
  {
    id: "deontologie-pa",
    title: "Déontologie Police",
    description: "Code de déontologie, obligations du policier, discipline.",
    isPremium: false,
    category: "pa",
    icon: "🛡️",
    color: "#EF4444",
    xpReward: 50,
    sections: [
      {
        id: "principes",
        title: "Principes déontologiques",
        content: `## Principes déontologiques du policier

### Le Code de déontologie (Décret du 18 mars 1986 modifié)
Le policier est au service de la population. Il doit :
- **Légalité** : agir dans le strict respect des lois et règlements
- **Neutralité** : sans distinction de race, religion, opinion ou situation sociale
- **Discrétion** : ne pas révéler les informations confidentielles
- **Dignité** : traiter chaque personne avec respect
- **Intégrité** : refuser tout avantage indu

### L'usage de la force (art. L.435-1 CSI)
L'usage de la force est strictement encadré. Il doit être :
1. **Nécessaire** : aucune autre alternative
2. **Proportionné** : à la menace
3. **Légal** : fondé sur un texte

### Armes à feu (art. L.435-1 CSI)
Les policiers ne peuvent faire usage de leur arme à feu qu'en cas de **légitime défense** ou pour :
- Empêcher la fuite d'une personne qui vient de commettre un crime
- Stopper un véhicule dont le conducteur refuse d'obtempérer et met en danger autrui
- En cas de périple meurtrier

> 🚨 **Important** : Le tir de sommation (coup de feu en l'air) doit précéder l'usage de l'arme sauf impossibilité.`
      }
    ]
  },
]

export const GPX_COURSE_MODULES: CourseModule[] = [
  {
    id: "droit-penal-gpx",
    title: "Droit Pénal Approfondi",
    description: "Infractions complexes, concours d'infractions, circonstances aggravantes et atténuantes.",
    isPremium: false,
    category: "gpx",
    icon: "⚖️",
    color: "#1147D9",
    xpReward: 75,
    sections: [
      {
        id: "concours-infractions",
        title: "Concours d'infractions",
        content: `## Concours d'infractions

### Définition
Il y a concours d'infractions lorsqu'un auteur commet **plusieurs infractions** avant d'avoir été définitivement jugé pour l'une d'elles.

### Règle du non-cumul des peines (art. 132-3 CP)
En matière correctionnelle et contraventionnelle, lorsque plusieurs infractions sont commises en concours, **seule la peine la plus élevée peut être prononcée**.

### Exception : cumul possible
- En matière de **crimes**, les peines peuvent se cumuler
- Les peines d'amende se cumulent toujours
- Les peines complémentaires se cumulent

### Distinction avec la récidive
La récidive suppose une **condamnation définitive antérieure**. Le concours d'infractions suppose des infractions commises **sans condamnation définitive entre elles**.

| | Concours | Récidive |
|--|----------|---------|
| Condamnation antérieure ? | Non | Oui (définitive) |
| Effet sur la peine ? | Non-cumul | Doublement du max. |`
      }
    ]
  },
  {
    id: "procedure-penale-gpx",
    title: "Procédure Pénale Avancée",
    description: "Instruction, JLD, QPC, voies de recours, médiation pénale.",
    isPremium: true,
    category: "gpx",
    icon: "🔍",
    color: "#8B5CF6",
    xpReward: 100,
    sections: [
      {
        id: "instruction",
        title: "L'instruction préparatoire",
        content: `## L'instruction préparatoire

### Rôle du Juge d'instruction (JI)
Le JI est un magistrat indépendant chargé de **rechercher la vérité**. Il dispose de pouvoirs d'investigation importants :
- Délivrance de mandats (amener, comparaître, arrêt, dépôt)
- Délégation aux OPJ via **commissions rogatoires**
- Mise en examen des suspects
- Renvoi en jugement ou non-lieu

### Quand ouvrir une instruction ?
- **Obligatoire** pour les crimes
- **Facultative** pour les délits
- **Impossible** pour les contraventions

### Le Juge des Libertés et de la Détention (JLD)
Le JLD est seul compétent pour ordonner la **détention provisoire**. Le JI ne peut pas lui-même placer en détention.

**Détention provisoire :** privation de liberté avant jugement
- **Délits** : 4 mois renouvelables (6 mois si peine > 5 ans), max 2 ans
- **Crimes** : 1 an renouvelable, max 4 ans (voire + pour criminalité organisée)`
      }
    ]
  },
  {
    id: "securite-interieure-gpx",
    title: "Sécurité Intérieure",
    description: "Code de la sécurité intérieure, forces de sécurité, renseignement.",
    isPremium: true,
    category: "gpx",
    icon: "🔐",
    color: "#22C55E",
    xpReward: 100,
    sections: [
      {
        id: "forces-securite",
        title: "Les forces de sécurité intérieure",
        content: `## Les forces de sécurité intérieure

### Organisation duale
La France dispose de deux forces principales :

**La Police Nationale**
- Placée sous l'autorité du **Ministère de l'Intérieur**
- Compétente en **zone urbaine** (agglomérations > 20 000 hab.)
- Statut civil
- Directions principales : DGPN, DGSI, BRI, RAID, OCRTIS...

**La Gendarmerie Nationale**
- Placée sous l'autorité du **Ministère de l'Intérieur** (depuis 2009) mais maintien du statut militaire
- Compétente en **zone rurale et péri-urbaine**
- Statut militaire
- Unités d'élite : GIGN, PSIG-Sabre...

### La Direction Centrale de la Sécurité Publique (DCSP)
Chargée de la sécurité de proximité, comprend :
- Sûretés urbaines
- Corps d'intervention
- Unités territoriales de quartier (UTeQ)

### Coopération policière européenne
- **Europol** : agence de l'UE pour la coopération policière (La Haye)
- **Interpol** : organisation internationale (Lyon) - 195 pays membres
- **Schengen** : espace de libre circulation, coopération transfrontalière`
      }
    ]
  },
]

export function getAllModules() {
  return [...PA_COURSE_MODULES, ...GPX_COURSE_MODULES]
}

export function getModuleById(id: string) {
  return getAllModules().find(m => m.id === id)
}
