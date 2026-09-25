/**
 * Pages d'acquisition « /preparation/<slug> ».
 *
 * Principe éditorial (§41) : peu de pages, chacune utile. Sept pages écrites,
 * pas des centaines générées. Chaque page décrit ce que COP'IQ apporte sur un
 * sujet précis et renvoie vers le parcours correspondant.
 *
 * Principe factuel (§53) : aucune modalité réglementaire chiffrée n'est
 * affirmée ici — conditions d'accès, coefficients, barèmes et calendriers
 * changent et ne sont pas vérifiables dans ce dépôt. Chaque page rappelle que
 * seules les publications officielles font foi. Ce qui est affirmé porte sur
 * le contenu de COP'IQ, lui, vérifiable dans `lib/content/`.
 */

import type { PathwayId } from "@/config/pathways"

export interface SeoSection {
  title: string
  body: string
  /** Liste optionnelle sous le paragraphe. */
  bullets?: readonly string[]
}

export interface SeoPage {
  slug: string
  /** <title> — unique. */
  metaTitle: string
  metaDescription: string
  /** H1 — unique, différent du <title>. */
  h1: string
  eyebrow: string
  intro: string
  sections: readonly SeoSection[]
  faq: readonly { q: string; a: string }[]
  /** Parcours COP'IQ vers lequel orienter. */
  pathway: PathwayId
  ctaLabel: string
  /** Pages sœurs à proposer en fin de page. */
  related: readonly string[]
}

const OFFICIAL_NOTICE_FAQ = {
  q: "Où trouver les modalités officielles ?",
  a: "Sur les publications du ministère de l’Intérieur et de la Police nationale. COP’IQ est une plateforme d’entraînement indépendante : elle prépare aux épreuves mais ne publie pas la réglementation, et seules les sources officielles font foi.",
}

export const SEO_PAGES: readonly SeoPage[] = [
  {
    slug: "gardien-de-la-paix",
    metaTitle: "Préparation au concours de Gardien de la paix",
    metaDescription:
      "Préparez le concours de Gardien de la paix : cas pratique, culture générale, psychotechniques, langue étrangère et concours blancs. Entraînement illimité sur mobile et web.",
    h1: "Préparer le concours de Gardien de la paix",
    eyebrow: "Concours GPX",
    intro:
      "Le concours de Gardien de la paix demande deux choses en même temps : des connaissances solides et une méthode qui tient sous la pression. COP’IQ travaille les deux, épreuve par épreuve, avec un suivi de progression qui montre où vous en êtes réellement.",
    sections: [
      {
        title: "Les modules d’entraînement GPX disponibles",
        body:
          "Le parcours GPX concours de COP’IQ est découpé selon les épreuves. Chaque module s’entraîne séparément, avec correction immédiate et reprise de l’historique de vos réponses.",
        bullets: [
          "Cas pratique — rédaction puis correction automatisée",
          "Culture générale — thèmes classés par difficulté",
          "Psychotechniques — calcul, suites logiques, raisonnement",
          "Langue étrangère",
          "Concours blanc — épreuve complète chronométrée",
        ],
      },
      {
        title: "Le cas pratique, l’épreuve qui départage",
        body:
          "C’est là que la méthode compte plus que la mémoire. Sur COP’IQ vous rédigez votre réponse, et le moteur de correction la compare aux éléments attendus : il vous rend la qualification retenue, le décompte des points acquis et la liste des oublis. Ce sont ces oublis répétés qui coûtent le plus de points, et c’est en les voyant qu’on les corrige.",
      },
      {
        title: "Après le concours : la scolarité",
        body:
          "Réussir le concours n’est pas la fin du parcours. COP’IQ couvre aussi la scolarité de Gardien de la paix — institutions et valeurs, DPS/DPG, policier en intervention (initial et avancé), mémento circulation, PV APJ 20 — soit la partie la plus volumineuse de la plateforme. Le même compte suit du concours à l’école.",
      },
      {
        title: "Mobile et web, une seule progression",
        body:
          "Une série de questions faite dans les transports apparaît dans votre historique web le soir. Un seul compte, une seule progression, un seul abonnement : c’est la même plateforme dans deux interfaces.",
      },
    ],
    faq: [
      {
        q: "COP’IQ couvre-t-il toutes les épreuves du concours GPX ?",
        a: "Le parcours GPX concours couvre le cas pratique, la culture générale, les psychotechniques, la langue étrangère et le concours blanc. La préparation à l’oral est travaillée à partir des mêmes contenus de culture générale et de connaissance de l’institution.",
      },
      {
        q: "Peut-on s’entraîner gratuitement ?",
        a: "Oui. Le compte gratuit donne accès aux quiz et QCM d’entraînement, à dix cas pratiques par semaine, au forum du parcours et au suivi de progression. Les cas pratiques illimités et les concours blancs complets relèvent de Premium.",
      },
      OFFICIAL_NOTICE_FAQ,
    ],
    pathway: "gpx_exam",
    ctaLabel: "Commencer la préparation GPX",
    related: ["cas-pratique", "tests-psychotechniques", "culture-generale", "oral"],
  },

  {
    slug: "policier-adjoint",
    metaTitle: "Préparation à la sélection de Policier adjoint",
    metaDescription:
      "Préparez la sélection de Policier adjoint : QCM, tests psychotechniques, photolangage et concours blancs. Entraînement suivi, sur mobile et sur le web.",
    h1: "Préparer la sélection de Policier adjoint",
    eyebrow: "Policier adjoint",
    intro:
      "Policier adjoint est souvent la première marche, et elle se joue autant sur la logique et l’expression que sur les connaissances. COP’IQ propose un parcours dédié, avec les familles d’épreuves réellement rencontrées — dont le photolangage, qui surprend ceux qui ne l’ont jamais travaillé.",
    sections: [
      {
        title: "Ce que contient le parcours Policier adjoint",
        body:
          "Le parcours concours PA de COP’IQ est organisé autour des épreuves de sélection.",
        bullets: [
          "QCM de connaissances, par thème",
          "Culture générale",
          "Psychotechniques — calcul, logique, concentration",
          "Photolangage — analyse d’image",
          "Concours blanc chronométré",
        ],
      },
      {
        title: "Le photolangage se travaille",
        body:
          "Décrire une image, en dégager l’essentiel, prendre position et argumenter : c’est un exercice qui s’apprend. COP’IQ s’entraîne sur des supports réels, avec une méthode de lecture en trois temps — ce que je vois, ce que j’en déduis, ce que j’en conclus.",
      },
      {
        title: "La formation en école",
        body:
          "COP’IQ couvre aussi toute la scolarité de Policier adjoint : procédure pénale, cadres juridiques, atteintes aux personnes et aux biens, armes et munitions, circulation, mineurs et famille, stupéfiants, libertés publiques, organisation judiciaire. C’est le deuxième volume de contenu de la plateforme.",
      },
    ],
    faq: [
      {
        q: "Le photolangage est-il inclus dans le compte gratuit ?",
        a: "Les exercices de photolangage font partie du parcours concours PA. Le compte gratuit permet de s’entraîner ; l’accès illimité aux corrections détaillées et aux concours blancs complets relève de Premium.",
      },
      {
        q: "Peut-on passer du parcours Policier adjoint au parcours Gardien de la paix ?",
        a: "Oui. Le parcours se change depuis vos paramètres, et votre historique est conservé. L’abonnement Premium couvre les quatre parcours, sans supplément.",
      },
      OFFICIAL_NOTICE_FAQ,
    ],
    pathway: "pa_exam",
    ctaLabel: "Commencer la préparation PA",
    related: ["tests-psychotechniques", "culture-generale", "gardien-de-la-paix"],
  },

  {
    slug: "tests-psychotechniques",
    metaTitle: "Tests psychotechniques Police : entraînement en ligne",
    metaDescription:
      "Entraînez-vous aux tests psychotechniques des concours de la Police nationale : calcul mental, suites logiques, raisonnement, concentration. Séries chronométrées et corrigées.",
    h1: "S’entraîner aux tests psychotechniques de la Police nationale",
    eyebrow: "Psychotechniques",
    intro:
      "Les tests psychotechniques ne récompensent pas la connaissance mais l’automatisme. Personne ne les réussit en réfléchissant longuement : on les réussit parce qu’on a déjà vu la forme de l’exercice. C’est exactement ce que fait l’entraînement répété.",
    sections: [
      {
        title: "Les familles travaillées",
        body:
          "COP’IQ propose des séries par famille d’exercice, chronométrées, avec correction immédiate.",
        bullets: [
          "Calcul mental et opérations rapides",
          "Suites logiques numériques et figuratives",
          "Raisonnement et syllogismes",
          "Attention et concentration",
        ],
      },
      {
        title: "Pourquoi le chronomètre change tout",
        body:
          "Un exercice psychotechnique réussi sans contrainte de temps n’apprend presque rien. Les séries de COP’IQ sont minutées, comme le jour de l’épreuve, et votre temps moyen par question fait partie des statistiques suivies.",
      },
      {
        title: "Mesurer le progrès, pas l’impression de progrès",
        body:
          "Le taux de réussite par famille d’exercice est suivi dans le temps. Vous voyez ce qui monte, et surtout ce qui stagne — l’information utile pour décider sur quoi passer la semaine suivante.",
      },
    ],
    faq: [
      {
        q: "Les tests psychotechniques sont-ils les mêmes pour GPX et Policier adjoint ?",
        a: "Les familles d’exercices se recoupent largement — calcul, logique, raisonnement, concentration — mais le format et le niveau diffèrent selon la sélection. COP’IQ propose les psychotechniques dans les deux parcours concours.",
      },
      {
        q: "Peut-on s’entraîner sans abonnement ?",
        a: "Oui, les séries d’entraînement sont accessibles au compte gratuit. Premium retire les limites et débloque les concours blancs complets.",
      },
      OFFICIAL_NOTICE_FAQ,
    ],
    pathway: "gpx_exam",
    ctaLabel: "M’entraîner aux psychotechniques",
    related: ["gardien-de-la-paix", "policier-adjoint", "cas-pratique"],
  },

  {
    slug: "cas-pratique",
    metaTitle: "Cas pratique Police : méthode et correction",
    metaDescription:
      "Travaillez le cas pratique du concours de Gardien de la paix : rédaction, qualification juridique, éléments attendus. Correction automatisée détaillée et export PDF.",
    h1: "Travailler le cas pratique avec une correction détaillée",
    eyebrow: "Cas pratique",
    intro:
      "Le cas pratique est l’épreuve où l’on perd des points sans savoir pourquoi. Vous rédigez, vous rendez, et l’écart entre ce que vous avez écrit et ce qui était attendu reste invisible. COP’IQ rend cet écart visible.",
    sections: [
      {
        title: "Comment fonctionne la correction",
        body:
          "Votre réponse rédigée est analysée côté serveur : le texte est normalisé, lemmatisé, puis comparé aux éléments attendus du corrigé. Vous recevez la qualification juridique retenue, le décompte des éléments acquis et, surtout, la liste de ceux qui manquent.",
        bullets: [
          "Qualification juridique vérifiée",
          "Éléments attendus comptés un par un",
          "Oublis listés explicitement",
          "Copie corrigée exportable en PDF",
        ],
      },
      {
        title: "La méthode avant la mémoire",
        body:
          "Un cas pratique se traite dans un ordre : les faits, la qualification, le cadre juridique applicable, les actes à accomplir, les diligences. C’est cet ordre qui fait gagner des points, et c’est en le répétant sur des cas variés qu’il devient réflexe.",
      },
      {
        title: "Contester une correction",
        body:
          "Une correction automatisée peut se tromper, notamment sur une formulation juste mais inhabituelle. COP’IQ prévoit une procédure de réclamation sur une copie corrigée : la demande est examinée et le barème peut être ajusté.",
      },
    ],
    faq: [
      {
        q: "Combien de cas pratiques sont accessibles gratuitement ?",
        a: "Dix par semaine avec le compte gratuit. Premium lève cette limite.",
      },
      {
        q: "La correction remplace-t-elle un correcteur humain ?",
        a: "Non. Elle sert à s’entraîner en volume et à repérer des oublis récurrents, ce qu’aucun correcteur ne peut faire à la demande plusieurs fois par jour. Le jugement d’un formateur reste plus fin sur la rédaction et l’argumentation.",
      },
      OFFICIAL_NOTICE_FAQ,
    ],
    pathway: "gpx_exam",
    ctaLabel: "Rédiger un premier cas pratique",
    related: ["gardien-de-la-paix", "oral", "tests-psychotechniques"],
  },

  {
    slug: "culture-generale",
    metaTitle: "Culture générale Police : quiz et révisions",
    metaDescription:
      "Révisez la culture générale des concours de la Police nationale : institutions, droit, actualité, histoire et géographie. Quiz par thème, correction immédiate, progression suivie.",
    h1: "Réviser la culture générale des concours de la Police nationale",
    eyebrow: "Culture générale",
    intro:
      "La culture générale se révise mal en lisant. Elle se révise en répondant, en se trompant, et en revoyant la même notion quelques jours plus tard. COP’IQ est construit pour cette répétition.",
    sections: [
      {
        title: "Réviser par thème, pas en vrac",
        body:
          "Les séries sont classées par thème et par niveau. Vous pouvez cibler ce qui manque plutôt que de repasser sur ce qui est déjà acquis, et retrouver votre historique de réponses sur chaque question.",
      },
      {
        title: "Les institutions et l’organisation de la Police nationale",
        body:
          "C’est la partie la plus rentable de la culture générale pour ces concours, parce qu’elle est stable et directement attendue. COP’IQ la traite comme un module de cours à part entière, avec ses propres quiz — dans le parcours concours comme dans la scolarité.",
      },
      {
        title: "Ce que la progression vous dit",
        body:
          "Taux de réussite par thème, historique complet, favoris pour marquer une notion à revoir. Les mêmes données sur mobile et sur le web.",
      },
    ],
    faq: [
      {
        q: "L’actualité est-elle mise à jour ?",
        a: "Les contenus pédagogiques de COP’IQ sont mis à jour par l’équipe éditoriale ; les notes de mise à jour de la plateforme sont publiées publiquement sur le site.",
      },
      {
        q: "La culture générale est-elle incluse dans les deux parcours concours ?",
        a: "Oui, en GPX concours comme en Policier adjoint concours.",
      },
      OFFICIAL_NOTICE_FAQ,
    ],
    pathway: "gpx_exam",
    ctaLabel: "Réviser la culture générale",
    related: ["gardien-de-la-paix", "policier-adjoint", "oral"],
  },

  {
    slug: "oral",
    metaTitle: "Préparation à l'oral des concours de la Police nationale",
    metaDescription:
      "Préparez l'entretien avec le jury : connaissance de l'institution, motivation, mise en situation, argumentation. Contenus et entraînements COP'IQ.",
    h1: "Préparer l’entretien avec le jury",
    eyebrow: "Oral",
    intro:
      "À l’oral, le jury n’évalue pas une quantité de connaissances : il évalue si vous savez ce dans quoi vous vous engagez, et si vous tenez une position sans la réciter. Cela se prépare, et pas la veille.",
    sections: [
      {
        title: "Connaître l’institution, vraiment",
        body:
          "Les questions sur l’organisation de la Police nationale, ses missions, ses valeurs et sa déontologie tombent presque toujours. Les modules « institutions et valeurs » de COP’IQ existent pour cela, et servent autant à l’écrit qu’à l’oral.",
      },
      {
        title: "Savoir se situer sur une situation concrète",
        body:
          "Les mises en situation de l’oral ressemblent beaucoup à un cas pratique raccourci : des faits, une qualification, une conduite à tenir. S’entraîner à l’écrit sur les cas pratiques fait progresser à l’oral, parce que c’est la même structure de raisonnement.",
      },
      {
        title: "La motivation ne s’improvise pas",
        body:
          "Une motivation crédible s’appuie sur des faits précis : ce que fait réellement le métier, ce que vous en savez, pourquoi cette voie plutôt qu’une autre. Le forum du parcours permet d’échanger avec des candidats et des élèves déjà passés par là.",
      },
    ],
    faq: [
      {
        q: "COP’IQ propose-t-il des oraux blancs avec un examinateur ?",
        a: "Non. COP’IQ prépare le fond de l’oral — connaissance de l’institution, méthode de mise en situation, argumentation — et pas la simulation d’entretien avec un jury humain.",
      },
      OFFICIAL_NOTICE_FAQ,
    ],
    pathway: "gpx_exam",
    ctaLabel: "Préparer mon oral",
    related: ["culture-generale", "cas-pratique", "gardien-de-la-paix"],
  },

  {
    slug: "reserve",
    metaTitle: "Réserve de la Police nationale : s'informer et se préparer",
    metaDescription:
      "Comprendre la réserve de la Police nationale et s'y préparer avec COP'IQ : bases institutionnelles, déontologie et entraînement aux connaissances attendues.",
    h1: "La réserve de la Police nationale",
    eyebrow: "Réserve",
    intro:
      "La réserve est une voie d’engagement à part entière, et une porte d’entrée vers l’institution pour beaucoup de candidats. COP’IQ commence à la couvrir : le module dédié est à ce jour en construction, et nous préférons le dire clairement plutôt que de le survendre.",
    sections: [
      {
        title: "Où en est COP’IQ sur la réserve",
        body:
          "Le module réserve existe dans l’application sous une forme d’introduction. Il n’a pas encore le volume des parcours concours et scolarité. En attendant, ce sont les contenus « institutions et valeurs » et « déontologie » qui sont les plus utiles pour se préparer, et ils sont complets.",
      },
      {
        title: "Ce qui est déjà exploitable aujourd’hui",
        body:
          "Les bases institutionnelles, l’organisation de la Police nationale, la déontologie et les cadres juridiques sont communs à tous les parcours COP’IQ. C’est le socle attendu, et il est disponible dès le compte gratuit.",
      },
    ],
    faq: [
      {
        q: "Un parcours réserve complet est-il prévu ?",
        a: "Le module existe et s’enrichit. Les évolutions de la plateforme sont publiées dans les notes de mise à jour du site ; nous n’annonçons pas de date que nous ne pouvons pas tenir.",
      },
      OFFICIAL_NOTICE_FAQ,
    ],
    pathway: "gpx_school",
    ctaLabel: "Découvrir les contenus disponibles",
    related: ["culture-generale", "gardien-de-la-paix", "policier-adjoint"],
  },
] as const

export function getSeoPage(slug: string): SeoPage | undefined {
  return SEO_PAGES.find((p) => p.slug === slug)
}
