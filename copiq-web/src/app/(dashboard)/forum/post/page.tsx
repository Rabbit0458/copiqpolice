"use client"
import { useRouter, useSearchParams } from "next/navigation"
import { useState, useEffect, Suspense } from "react"
import { createClient } from "@/lib/supabase/client"
import Link from "next/link"
import { ArrowLeft, MessageCircle, Send, Pin, Eye, Calendar, CheckCircle2, ChevronDown, ChevronUp } from "lucide-react"

// ─── Types ────────────────────────────────────────────────────────────────────

interface MockReply {
  id: string
  author: string
  content: string
  date: string
}

interface MockPost {
  id: string
  title: string
  content: string
  author: string
  category: string
  categoryIcon: string
  views: number
  isPinned: boolean
  createdAt: string
  replies: MockReply[]
}

// ─── Mock data ────────────────────────────────────────────────────────────────

const MOCK_POSTS: Record<string, MockPost> = {
  "1": {
    id: "1",
    title: "Comment mémoriser la procédure de GAV ?",
    content: "Bonjour à tous, je galère à retenir toutes les étapes de la garde à vue (art. 63 CPP). Est-ce que vous avez des techniques mnémotechniques ? Je suis en prépa PA depuis 3 mois et ce point me pose vraiment problème. Merci d'avance pour vos conseils !",
    author: "Officier74",
    category: "Droit & Procédure",
    categoryIcon: "⚖️",
    views: 234,
    isPinned: true,
    createdAt: "2025-03-12T10:30:00Z",
    replies: [
      { id: "r1", author: "GPX_Reçu2025", content: "Pour la GAV, je me souviens avec l'acronyme DINA : Droits (notification), Identité (relevé), Notification (parquet), Avocat (demande). Ça m'a bien aidé lors du concours !", date: "2025-03-12T11:45:00Z" },
      { id: "r2", author: "Aspirant_Paris", content: "Je te conseille de faire des fiches avec les articles exacts : 63, 63-1, 63-2, 63-3, 63-4 CPP. Chaque article correspond à une obligation précise. C'est structuré et logique.", date: "2025-03-12T14:20:00Z" },
      { id: "r3", author: "LegalEagle77", content: "La durée : 24h renouvelable 1 fois par le procureur = 48h max en droit commun. Crime organisé/terrorisme = 96h/144h. Facile à retenir avec une petite frise chronologique.", date: "2025-03-13T09:15:00Z" },
    ]
  },
  "2": {
    id: "2",
    title: "Résultats concours PA Ile-de-France 2025 ?",
    content: "Bonjour, est-ce que quelqu'un a des infos sur la date de publication des résultats du concours PA pour la zone Ile-de-France session 2025 ? J'ai passé les écrits en janvier et je commence à stresser d'attendre. Les résultats sont normalement publiés quand ?",
    author: "Aspirant_Paris",
    category: "Concours (PA & GPX)",
    categoryIcon: "🎓",
    views: 892,
    isPinned: false,
    createdAt: "2025-03-20T08:15:00Z",
    replies: [
      { id: "r1", author: "Major_Bordeaux", content: "En général les résultats tombent 6 à 8 semaines après les écrits. Pour la session janvier 2025 IDF, je dirais mi-mars. Surveille le site de la DGPN.", date: "2025-03-20T09:30:00Z" },
      { id: "r2", author: "GPX_Reçu2025", content: "L'an dernier c'était le 15 mars pour la session de janvier en IDF. Patience ! Les résultats sont publiés sur Choisir le service public.", date: "2025-03-20T11:00:00Z" },
      { id: "r3", author: "Officier74", content: "N'attends pas les résultats pour continuer à réviser l'oral. Si tu es admissible, tu auras peu de temps pour préparer l'entretien de personnalité.", date: "2025-03-21T07:45:00Z" },
      { id: "r4", author: "CandidatPA22", content: "Même chose pour moi, je suis en attente. On peut se tenir informés mutuellement ? J'ai passé les écrits le 18 janvier à Créteil.", date: "2025-03-21T10:20:00Z" },
    ]
  },
  "3": {
    id: "3",
    title: "Le cas pratique GPX m'angoisse, des conseils ?",
    content: "Je passe le GPX dans 6 semaines et le cas pratique me fait vraiment peur. J'ai l'impression de ne jamais savoir par où commencer quand je lis le sujet. Comment vous avez appris à structurer votre réponse ? Est-ce qu'il y a une méthode universelle à suivre ?",
    author: "Gardien_Lyon",
    category: "Cas pratiques",
    categoryIcon: "📋",
    views: 156,
    isPinned: false,
    createdAt: "2025-03-18T15:45:00Z",
    replies: [
      { id: "r1", author: "Major_Bordeaux", content: "La méthode CROC : Contexte (faits), Risques (qualification pénale), Obligations (que doit faire la police ?), Conclusion (synthèse + suite). Ça marche à tous les coups.", date: "2025-03-18T16:30:00Z" },
      { id: "r2", author: "Adjudant_Marseille", content: "Entraîne-toi à lire vite et à souligner les mots-clés juridiques. Souvent le cas cache un crime/délit que tu dois qualifier. Repère ça en premier.", date: "2025-03-19T08:00:00Z" },
      { id: "r3", author: "JuristePolice", content: "Les annales sont tes meilleures amies. Fais au moins 10 cas pratiques avant l'examen. La structure devient automatique avec l'entraînement.", date: "2025-03-19T12:15:00Z" },
    ]
  },
  "4": {
    id: "4",
    title: "Quelle est la différence flagrant délit / enquête préliminaire ?",
    content: "Bonjour, j'ai du mal à distinguer les pouvoirs de la police selon qu'on est en flagrant délit ou en enquête préliminaire. Les conditions de perquisition, de garde à vue, tout ça me semble confus. Quelqu'un peut m'expliquer clairement ?",
    author: "CandidatPA22",
    category: "Droit & Procédure",
    categoryIcon: "⚖️",
    views: 187,
    isPinned: false,
    createdAt: "2025-03-10T09:00:00Z",
    replies: [
      { id: "r1", author: "JuristePolice", content: "En flagrant délit (art. 53 CPP) : crime/délit en cours ou venant d'être commis. Pouvoirs renforcés : perquisition sans autorisation du procureur, GAV de plein droit.", date: "2025-03-10T10:15:00Z" },
      { id: "r2", author: "LegalEagle77", content: "Enquête préliminaire : tout le reste (infractions passées). Perquisition possible UNIQUEMENT avec consentement écrit de l'occupant ou autorisation du JLD. Pouvoirs plus restreints.", date: "2025-03-10T13:45:00Z" },
      { id: "r3", author: "Aspirant_Paris", content: "Retiens : flagrant délit = pouvoirs étendus, urgence, infraction fraîche. Préliminaire = pouvoirs restreints, consentement ou autorisation judiciaire nécessaire. C'est la règle générale.", date: "2025-03-11T08:30:00Z" },
    ]
  },
  "5": {
    id: "5",
    title: "Planning de révision 3 mois avant le concours PA",
    content: "Bonjour à tous ! Je partage mon planning de révision que j'ai utilisé pour préparer le concours PA et qui m'a permis d'être admis. J'avais 3 mois devant moi, voici comment j'ai organisé mon temps. Mois 1 : culture générale et actualité (2h/jour). Mois 2 : droit pénal et procédure (2h/jour). Mois 3 : révisions croisées + cas pratiques (3h/jour). Qu'est-ce que vous en pensez ?",
    author: "Major_Bordeaux",
    category: "Concours (PA & GPX)",
    categoryIcon: "🎓",
    views: 541,
    isPinned: true,
    createdAt: "2025-02-28T10:00:00Z",
    replies: [
      { id: "r1", author: "Officier74", content: "Super planning ! Je rajouterais les psychotechniques dès le mois 1 car ça s'entraîne sur la durée. Le calcul mental surtout, ça s'améliore avec la répétition quotidienne.", date: "2025-02-28T11:30:00Z" },
      { id: "r2", author: "GPX_Reçu2025", content: "J'ai suivi quelque chose de similaire. Je te conseil d'intégrer 30min de lecture de presse chaque matin (Le Monde ou Le Figaro) tout au long des 3 mois pour la culture générale.", date: "2025-03-01T09:00:00Z" },
      { id: "r3", author: "Sergent_Nice", content: "Est-ce qu'on peut avoir accès à tes fiches de révision sur le droit pénal ? Je suis dans la même période de prépa, ça m'aiderait beaucoup.", date: "2025-03-02T14:00:00Z" },
      { id: "r4", author: "Major_Bordeaux", content: "@Sergent_Nice Je peux partager mes fiches CPP si tu me contactes en privé. Elles sont basées sur les cours de la SNPN.", date: "2025-03-02T16:45:00Z" },
    ]
  },
  "6": {
    id: "6",
    title: "Calcul mental : astuces pour aller plus vite",
    content: "Le test de calcul mental du concours de gardien de la paix me pose problème. J'arrive à faire les calculs mais pas assez vite. Est-ce que vous avez des techniques de calcul rapide ? Notamment pour les multiplications et les pourcentages.",
    author: "Aspirant_Nantes",
    category: "Psychotechniques",
    categoryIcon: "🧠",
    views: 112,
    isPinned: false,
    createdAt: "2025-03-15T13:00:00Z",
    replies: [
      { id: "r1", author: "CandidatPA22", content: "Pour les multiplications par 11 : tu additionnes les deux chiffres et tu le mets au milieu. Ex: 53 × 11 = 5(5+3)3 = 583. Ça marche si la somme < 10.", date: "2025-03-15T14:15:00Z" },
      { id: "r2", author: "Sergent_Nice", content: "Pour les pourcentages : 10% c'est ÷10, 5% c'est ÷20, 15% c'est 10%+5%. Une fois que tu maîtrises ces bases tu peux tout calculer très vite.", date: "2025-03-15T16:00:00Z" },
      { id: "r3", author: "Major_Bordeaux", content: "L'application Mathway permet de s'entraîner au chrono. 15 minutes par jour pendant 4 semaines et tu vois une vraie amélioration.", date: "2025-03-16T08:30:00Z" },
    ]
  },
  "7": {
    id: "7",
    title: "Culture générale : quels thèmes travailler en priorité ?",
    content: "Pour la culture générale du concours PA, il y a tellement de choses à potasser que je ne sais pas par où commencer. Institutions françaises, histoire, géographie, actualité... Est-ce qu'il y a des thèmes qui reviennent souvent dans les sujets ?",
    author: "Officier74",
    category: "Concours (PA & GPX)",
    categoryIcon: "🎓",
    views: 328,
    isPinned: false,
    createdAt: "2025-03-08T10:30:00Z",
    replies: [
      { id: "r1", author: "Adjudant_Marseille", content: "En ordre de priorité : 1) Institutions (constitution, gouvernement, justice), 2) Histoire récente (5e République), 3) Actualité des 12 derniers mois, 4) Police Nationale (missions, organisation).", date: "2025-03-08T11:45:00Z" },
      { id: "r2", author: "GPX_Reçu2025", content: "La Police Nationale elle-même est très souvent au programme : DGPN, DCSP, BRI, BAC... Connaître l'organisation interne est indispensable pour l'oral aussi.", date: "2025-03-09T09:00:00Z" },
      { id: "r3", author: "JuristePolice", content: "Je rajouterais le droit constitutionnel de base : droits fondamentaux, état de droit, libertés publiques. C'est transversal et ça revient souvent.", date: "2025-03-09T14:30:00Z" },
    ]
  },
  "8": {
    id: "8",
    title: "Témoignage : reçu GPX après 2 tentatives",
    content: "Bonjour à tous, je voulais partager mon expérience pour ceux qui traversent des moments de doute. J'ai échoué au GPX en 2023, recommencé en 2024, et j'ai été reçu ! Ce n'est pas facile de se relever après un échec mais c'est possible. La clé pour moi a été de vraiment comprendre pourquoi j'avais échoué la première fois : je ne connaissais pas assez la procédure pénale et mes cas pratiques manquaient de structure. N'abandonnez pas !",
    author: "GPX_Reçu2025",
    category: "Témoignages",
    categoryIcon: "💬",
    views: 1203,
    isPinned: false,
    createdAt: "2025-02-15T09:00:00Z",
    replies: [
      { id: "r1", author: "Gardien_Lyon", content: "Merci pour ce témoignage ! Moi aussi j'ai échoué une première fois. Ça me redonne de la motivation. Quelles ressources tu recommandes pour la procédure pénale ?", date: "2025-02-15T10:30:00Z" },
      { id: "r2", author: "Aspirant_Paris", content: "Super témoignage ! Combien de temps tu as travaillé pour la deuxième tentative ? Et tu avais des cours ou tu t'es préparé seul ?", date: "2025-02-15T13:15:00Z" },
      { id: "r3", author: "GPX_Reçu2025", content: "Pour la procédure pénale j'ai utilisé le Dalloz procédure pénale + les annales officielles. J'ai travaillé 4-5h/jour pendant 4 mois. Seul, sans prépa payante.", date: "2025-02-16T08:00:00Z" },
      { id: "r4", author: "CandidatPA22", content: "4-5h par jour pendant 4 mois c'est vraiment courageux. Respect ! Je viens de commencer ma prépa pour le PA, est-ce que tu penses que la même méthode s'applique ?", date: "2025-02-16T11:45:00Z" },
      { id: "r5", author: "Sergent_Nice", content: "Merci pour ce partage. On a besoin de ce genre de témoignages positifs sur ce forum. Bonne continuation dans ta carrière !", date: "2025-02-17T09:00:00Z" },
    ]
  },
  "9": {
    id: "9",
    title: "Art. 63 CPP : durée et prolongation de la GAV",
    content: "Bonjour, j'ai une question précise sur l'article 63 du CPP concernant la durée de la garde à vue. J'ai lu des choses contradictoires et je veux être sûr pour le concours. Quelle est la durée initiale ? Dans quels cas peut-on la prolonger et de combien ?",
    author: "JuristePolice",
    category: "Droit & Procédure",
    categoryIcon: "⚖️",
    views: 143,
    isPinned: false,
    createdAt: "2025-03-14T14:00:00Z",
    replies: [
      { id: "r1", author: "LegalEagle77", content: "Durée initiale : 24h (art. 63 CPP). Prolongation par le procureur : +24h = 48h max pour droit commun. Crime organisé : +48h = 96h. Terrorisme : +48h renouvelable = 144h (6 jours).", date: "2025-03-14T15:30:00Z" },
      { id: "r2", author: "Officier74", content: "N'oublie pas que le mineur de moins de 13 ans ne peut PAS être placé en GAV (art. 4 ord. 1945). Et pour 13-16 ans la durée est divisée par deux. Important pour les concours.", date: "2025-03-15T09:00:00Z" },
      { id: "r3", author: "JuristePolice", content: "Merci ! Et pour la prolongation, c'est le procureur qui décide ou faut-il l'autorisation d'un juge ?", date: "2025-03-15T10:15:00Z" },
      { id: "r4", author: "LegalEagle77", content: "Prolongation droit commun = procureur. Au-delà (96h+) = JLD (juge des libertés et de la détention). Le JLD intervient aussi pour les prolongations exceptionnelles en matière de crime organisé.", date: "2025-03-15T11:30:00Z" },
    ]
  },
  "10": {
    id: "10",
    title: "Erreurs à éviter lors de l'oral PA",
    content: "Bonsoir à tous. Je passe l'oral PA dans 3 semaines et je cherche des retours d'expérience. Quelles sont les erreurs classiques que font les candidats lors de l'entretien de personnalité ? Je suis surtout anxieux par rapport aux questions sur la motivation et les valeurs de la République.",
    author: "Adjudant_Marseille",
    category: "Concours (PA & GPX)",
    categoryIcon: "🎓",
    views: 467,
    isPinned: false,
    createdAt: "2025-03-05T19:00:00Z",
    replies: [
      { id: "r1", author: "Major_Bordeaux", content: "Erreur #1 : répondre de manière générique ('j'aime aider les gens'). Sois précis et personnel. Exemple concret de situation qui t'a motivé à rejoindre la police.", date: "2025-03-05T20:15:00Z" },
      { id: "r2", author: "GPX_Reçu2025", content: "Erreur #2 : ne pas connaître l'actualité policière. Le jury teste si tu t'intéresses vraiment à l'institution. Connaître 2-3 dossiers récents de la PN montre ton implication.", date: "2025-03-06T08:30:00Z" },
      { id: "r3", author: "Sergent_Nice", content: "Erreur #3 : minimiser les aspects difficiles du métier. Le jury veut voir que tu es lucide sur les contraintes (horaires décalés, violences, responsabilités). Ne survends pas le métier.", date: "2025-03-06T11:00:00Z" },
      { id: "r4", author: "Officier74", content: "Erreur #4 : négliger la forme. Tenue soignée, posture droite, voix assurée. Ils testent aussi ta présentation car tu représenteras l'État face au public.", date: "2025-03-07T09:15:00Z" },
    ]
  },
  "11": {
    id: "11",
    title: "Série logique : méthode pour les suites de chiffres",
    content: "Bonjour, j'ai du mal avec les séries logiques lors des tests psychotechniques, notamment les suites de chiffres. Parfois je trouve la règle rapidement, parfois je bloque complètement. Est-ce qu'il existe une méthode systématique pour analyser ces séries ?",
    author: "CandidatPA22",
    category: "Psychotechniques",
    categoryIcon: "🧠",
    views: 98,
    isPinned: false,
    createdAt: "2025-03-17T11:00:00Z",
    replies: [
      { id: "r1", author: "Aspirant_Nantes", content: "Méthode en 4 étapes : 1) Calcule les différences entre les termes. 2) Si ça ne marche pas, calcule les différences des différences. 3) Essaie ×2, ×3, ÷2... 4) Alternance (termes pairs/impairs séparément).", date: "2025-03-17T12:30:00Z" },
      { id: "r2", author: "Major_Bordeaux", content: "Les suites les plus fréquentes : arithmétiques (différence constante), géométriques (raison constante), Fibonacci (chaque terme = somme des deux précédents). Mémorise ces 3 types.", date: "2025-03-18T08:45:00Z" },
    ]
  },
  "12": {
    id: "12",
    title: "Comment gérer le stress le jour du concours ?",
    content: "Salut à tous. Mon concours PA est dans exactement 10 jours et je commence à paniquer. Je dors mal, j'ai du mal à me concentrer pour réviser et j'ai peur de tout oublier le jour J. Des conseils pour gérer le stress des derniers jours et le jour du concours lui-même ?",
    author: "Sergent_Nice",
    category: "Témoignages",
    categoryIcon: "💬",
    views: 612,
    isPinned: false,
    createdAt: "2025-02-10T22:00:00Z",
    replies: [
      { id: "r1", author: "GPX_Reçu2025", content: "Les 3 derniers jours avant l'examen : ne fais PLUS de nouvelles révisions. Révise juste tes fiches synthèse. Dors 8h. Mange bien. Le cerveau a besoin de récupérer.", date: "2025-02-11T08:00:00Z" },
      { id: "r2", author: "Officier74", content: "La veille : arrête complètement les révisions à 18h. Fais quelque chose que tu aimes (sport, série, ballade). Prépare tes affaires le soir pour ne pas stresser le matin.", date: "2025-02-11T10:30:00Z" },
      { id: "r3", author: "Major_Bordeaux", content: "Technique de respiration 4-7-8 : inspire 4s, bloque 7s, expire 8s. À faire avant d'entrer dans la salle. Ça régule immédiatement le système nerveux.", date: "2025-02-12T09:00:00Z" },
      { id: "r4", author: "Adjudant_Marseille", content: "N'essaie pas de tout réviser dans les derniers jours. Tu sais ce que tu sais. Concentre-toi sur ta méthode et la gestion du temps de l'épreuve, pas sur le fond.", date: "2025-02-12T14:15:00Z" },
      { id: "r5", author: "Sergent_Nice", content: "Merci à tous pour ces conseils. Je vais mettre en pratique la respiration et vraiment couper les révisions la veille. Je reviendrai vous donner des nouvelles après l'examen !", date: "2025-02-13T20:00:00Z" },
    ]
  },
  "13": {
    id: "13",
    title: "Différence entre OPJ et APJ ?",
    content: "Bonsoir, je confonds souvent OPJ (officier de police judiciaire) et APJ (agent de police judiciaire). Pouvez-vous m'expliquer clairement leurs différences de statut et de pouvoirs ? C'est un point qui revient souvent dans les concours.",
    author: "Gardien_Lyon",
    category: "Questions diverses",
    categoryIcon: "❓",
    views: 221,
    isPinned: false,
    createdAt: "2025-03-03T20:00:00Z",
    replies: [
      { id: "r1", author: "JuristePolice", content: "OPJ (art. 16 CPP) : officiers, gradés et gardiens ayant une habilitation spéciale. Peuvent placer en GAV, diriger des enquêtes, constater tous délits et crimes.", date: "2025-03-04T08:00:00Z" },
      { id: "r2", author: "LegalEagle77", content: "APJ (art. 20 CPP) : gardiens de la paix non habilités OPJ et agents ADS. Ils ASSISTENT les OPJ mais ne peuvent pas placer en GAV seuls ni diriger une enquête.", date: "2025-03-04T10:15:00Z" },
      { id: "r3", author: "Officier74", content: "En résumé : OPJ = autonome et responsable de l'enquête. APJ = sous l'autorité d'un OPJ. Le Gardien de la paix peut devenir OPJ après une formation et une habilitation du procureur.", date: "2025-03-04T14:30:00Z" },
      { id: "r4", author: "Gardien_Lyon", content: "Super clair ! Et les APJA (agents de police judiciaire adjoints, art. 21 CPP) c'est encore différent ? Il me semble que c'est pour les gardes champêtres et policiers municipaux ?", date: "2025-03-05T09:00:00Z" },
      { id: "r5", author: "JuristePolice", content: "Oui exactement ! APJA = policiers municipaux, gardes champêtres. Pouvoirs très limités (relevé d'identité, constat d'infractions mineures). La hiérarchie est : OPJ > APJ > APJA.", date: "2025-03-05T11:00:00Z" },
    ]
  },
  "14": {
    id: "14",
    title: "Cas pratique GPX 2024 : analyse de l'épreuve",
    content: "Bonjour à tous. J'ai passé le GPX en 2024 et je voulais faire un retour sur l'épreuve de cas pratique pour aider les futurs candidats. Le sujet portait sur une rixe dans un bar avec un suspect en fuite et un blessé grave. Je vais détailler ma démarche.",
    author: "Major_Bordeaux",
    category: "Cas pratiques",
    categoryIcon: "📋",
    views: 389,
    isPinned: false,
    createdAt: "2025-01-20T14:00:00Z",
    replies: [
      { id: "r1", author: "Adjudant_Marseille", content: "C'est exactement le type de sujet qui revient régulièrement : infraction flagrante, suspect identifié mais non interpellé. Quelles ont été les étapes de ta réponse ?", date: "2025-01-20T15:30:00Z" },
      { id: "r2", author: "Major_Bordeaux", content: "Étape 1 : qualification des faits (violences volontaires avec ITT > 8j = délit en flagrance). Étape 2 : sécuriser le blessé + SAMU. Étape 3 : rédiger PV de flagrance. Étape 4 : mesures de recherche du suspect.", date: "2025-01-21T09:00:00Z" },
      { id: "r3", author: "GPX_Reçu2025", content: "N'oublie pas le volet protection des témoins et sécurisation du périmètre. Les jurys apprécient quand tu montres que tu penses à la procédure ET à la situation terrain.", date: "2025-01-21T11:15:00Z" },
      { id: "r4", author: "Gardien_Lyon", content: "Merci pour ce retour ! Est-ce qu'il y avait des références aux articles du CPP à citer explicitement dans la réponse ?", date: "2025-01-22T08:30:00Z" },
      { id: "r5", author: "Major_Bordeaux", content: "Oui, citer les articles renforce la réponse mais ce n'est pas obligatoire si tu maîtrises les concepts. Art. 53 (flagrance), 63 (GAV) et 75 (enquête préliminaire) sont les incontournables.", date: "2025-01-22T10:00:00Z" },
    ]
  },
  "15": {
    id: "15",
    title: "La récidive en droit pénal : définition et conséquences",
    content: "Bonjour, pour le concours je dois connaître la notion de récidive en droit pénal. Mais je confonds récidive légale et réitération d'infraction. Est-ce que quelqu'un peut m'expliquer la différence et quelles sont les conséquences concrètes sur la peine ?",
    author: "JuristePolice",
    category: "Droit & Procédure",
    categoryIcon: "⚖️",
    views: 87,
    isPinned: false,
    createdAt: "2025-03-06T16:00:00Z",
    replies: [
      { id: "r1", author: "LegalEagle77", content: "Récidive légale (art. 132-8 CP) : conditions strictes - même infraction (ou infraction assimilée), dans un délai défini. Conséquence : doublement du maximum de la peine.", date: "2025-03-06T17:15:00Z" },
      { id: "r2", author: "Officier74", content: "Réitération : infraction commise après une condamnation définitive MAIS sans réunir les conditions de la récidive (délai expiré ou infractions non assimilées). Pas de doublement automatique.", date: "2025-03-07T08:00:00Z" },
      { id: "r3", author: "JuristePolice", content: "Donc en récidive légale le juge DOIT doubler la peine max alors qu'en réitération il peut seulement en tenir compte ? C'est bien ça ?", date: "2025-03-07T10:30:00Z" },
      { id: "r4", author: "LegalEagle77", content: "Pas tout à fait : la récidive légale PERMET le doublement mais le juge peut décider de ne pas l'appliquer (principe d'individualisation de la peine). Ce n'est pas automatique mais c'est la peine max doublée.", date: "2025-03-07T12:00:00Z" },
    ]
  },
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

function formatDate(iso: string) {
  return new Date(iso).toLocaleDateString("fr-FR", {
    day: "numeric", month: "long", year: "numeric",
  })
}

function formatDateTime(iso: string) {
  return new Date(iso).toLocaleDateString("fr-FR", {
    day: "numeric", month: "short", year: "numeric",
    hour: "2-digit", minute: "2-digit",
  })
}

function getInitials(name: string) {
  return name.slice(0, 2).toUpperCase()
}

const AVATAR_COLORS = [
  "#1147D9", "#8B5CF6", "#22C55E", "#F59E0B",
  "#EF4444", "#06B6D4", "#EC4899", "#6366F1",
]

function avatarColor(name: string) {
  let h = 0
  for (const c of name) h = c.charCodeAt(0) + h * 31
  return AVATAR_COLORS[Math.abs(h) % AVATAR_COLORS.length]
}

// ─── Toast ────────────────────────────────────────────────────────────────────

function Toast({ message, visible }: { message: string; visible: boolean }) {
  return (
    <div
      className={`fixed bottom-6 right-6 z-50 flex items-center gap-2 px-4 py-3 rounded-xl shadow-lg bg-[#1147D9] text-white text-sm font-medium transition-all duration-300 ${
        visible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-4 pointer-events-none"
      }`}
    >
      <CheckCircle2 size={16} />
      {message}
    </div>
  )
}

// ─── Main component ───────────────────────────────────────────────────────────

function ForumPostContent() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const postId = searchParams.get("id")

  const [post, setPost] = useState<MockPost | null>(null)
  const [replies, setReplies] = useState<MockReply[]>([])
  const [replyContent, setReplyContent] = useState("")
  const [loading, setLoading] = useState(true)
  const [notFound, setNotFound] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [toastVisible, setToastVisible] = useState(false)

  useEffect(() => {
    if (!postId) { router.replace("/forum"); return }

    // Check mock data first
    const mock = MOCK_POSTS[postId]
    if (mock) {
      setPost(mock)
      setReplies(mock.replies)
      setLoading(false)
      return
    }

    // Try Supabase for unknown IDs
    const supabase = createClient()
    supabase.auth.getUser().then(async ({ data }) => {
      if (!data.user) { router.replace("/login"); return }
      try {
        const [postRes, repliesRes] = await Promise.all([
          (supabase as any).from("forum_posts").select("*, profiles(full_name)").eq("id", postId).single(),
          (supabase as any).from("forum_replies").select("*, profiles(full_name)").eq("post_id", postId).order("created_at"),
        ])
        if (postRes.data) {
          const p = postRes.data
          setPost({
            id: p.id,
            title: p.title,
            content: p.content,
            author: p.profiles?.full_name ?? "Utilisateur",
            category: p.category ?? "Forum",
            categoryIcon: "💬",
            views: p.views ?? 0,
            isPinned: p.is_pinned ?? false,
            createdAt: p.created_at,
            replies: [],
          })
          setReplies((repliesRes.data ?? []).map((r: any) => ({
            id: r.id,
            author: r.profiles?.full_name ?? "Utilisateur",
            content: r.content,
            date: r.created_at,
          })))
        } else {
          setNotFound(true)
        }
      } catch {
        setNotFound(true)
      }
      setLoading(false)
    })
  }, [postId])

  const showToast = () => {
    setToastVisible(true)
    setTimeout(() => setToastVisible(false), 3000)
  }

  const handleReply = (e: React.FormEvent) => {
    e.preventDefault()
    if (!replyContent.trim()) return
    setSubmitting(true)
    const newReply: MockReply = {
      id: `local-${Date.now()}`,
      author: "Moi",
      content: replyContent.trim(),
      date: new Date().toISOString(),
    }
    setTimeout(() => {
      setReplies(r => [...r, newReply])
      setReplyContent("")
      setSubmitting(false)
      showToast()
    }, 500)
  }

  if (loading) return (
    <div className="flex items-center justify-center h-64">
      <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" />
    </div>
  )

  if (notFound || !post) return (
    <div className="max-w-3xl mx-auto px-4 py-12 text-center">
      <MessageCircle size={48} className="mx-auto mb-4 text-[var(--on-surface-muted)]" />
      <h2 className="text-lg font-bold text-[var(--on-surface)] mb-2">Sujet introuvable</h2>
      <p className="text-sm text-[var(--on-surface-muted)] mb-6">Ce sujet n'existe pas ou a été supprimé.</p>
      <Link
        href="/forum"
        className="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all"
      >
        <ArrowLeft size={14} />Retour au forum
      </Link>
    </div>
  )

  return (
    <div className="max-w-3xl mx-auto px-4 py-8">
      <Toast message="Réponse publiée !" visible={toastVisible} />

      {/* Back link */}
      <Link
        href="/forum"
        className="inline-flex items-center gap-2 text-sm text-[var(--on-surface-muted)] hover:text-[var(--on-surface)] mb-6 transition-colors"
      >
        <ArrowLeft size={15} />Retour au forum
      </Link>

      {/* Post header */}
      <div className="mb-4">
        <div className="flex items-center gap-2 mb-3 flex-wrap">
          <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-[#1147D9]/10 text-[#1147D9]">
            {post.categoryIcon} {post.category}
          </span>
          {post.isPinned && (
            <span className="flex items-center gap-1 text-xs font-semibold text-[#1147D9]">
              <Pin size={11} />Épinglé
            </span>
          )}
        </div>
        <h1 className="text-xl font-bold text-[var(--on-surface)] mb-4">{post.title}</h1>

        {/* Stats row */}
        <div className="flex items-center gap-4 text-xs text-[var(--on-surface-muted)]">
          <span className="flex items-center gap-1.5"><Eye size={13} />{post.views} vues</span>
          <span className="flex items-center gap-1.5"><MessageCircle size={13} />{replies.length} réponse{replies.length > 1 ? "s" : ""}</span>
          <span className="flex items-center gap-1.5"><Calendar size={13} />{formatDate(post.createdAt)}</span>
        </div>
      </div>

      {/* Main post card */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-6 mb-6">
        <div className="flex items-start gap-4">
          <div
            className="w-10 h-10 rounded-full flex items-center justify-center text-white text-sm font-bold shrink-0"
            style={{ backgroundColor: avatarColor(post.author) }}
          >
            {getInitials(post.author)}
          </div>
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 mb-3">
              <span className="text-sm font-semibold text-[var(--on-surface)]">{post.author}</span>
              <span className="text-xs text-[var(--on-surface-faint)]">·</span>
              <span className="text-xs text-[var(--on-surface-muted)]">{formatDate(post.createdAt)}</span>
            </div>
            <p className="text-sm text-[var(--on-surface)] leading-relaxed whitespace-pre-wrap">{post.content}</p>
          </div>
        </div>
      </div>

      {/* Replies section */}
      <div className="mb-6">
        <h2 className="text-sm font-bold text-[var(--on-surface)] mb-4 flex items-center gap-2">
          <MessageCircle size={15} className="text-[#1147D9]" />
          Réponses ({replies.length})
        </h2>

        {replies.length === 0 ? (
          <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-8 text-center">
            <p className="text-sm text-[var(--on-surface-muted)]">Aucune réponse pour l'instant. Soyez le premier à répondre !</p>
          </div>
        ) : (
          <div className="relative">
            {/* Timeline line */}
            <div className="absolute left-5 top-5 bottom-5 w-0.5 bg-[var(--outline)]" />
            <div className="space-y-4">
              {replies.map((reply) => (
                <div key={reply.id} className="flex items-start gap-4">
                  <div
                    className="w-10 h-10 rounded-full flex items-center justify-center text-white text-xs font-bold shrink-0 relative z-10"
                    style={{ backgroundColor: avatarColor(reply.author) }}
                  >
                    {getInitials(reply.author)}
                  </div>
                  <div className="flex-1 rounded-xl border border-[var(--outline)] bg-[var(--surface)] p-4">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="text-sm font-semibold text-[var(--on-surface)]">{reply.author}</span>
                      <span className="text-xs text-[var(--on-surface-faint)]">·</span>
                      <span className="text-xs text-[var(--on-surface-muted)]">{formatDateTime(reply.date)}</span>
                    </div>
                    <p className="text-sm text-[var(--on-surface)] leading-relaxed whitespace-pre-wrap">{reply.content}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Reply form */}
      <div className="rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-5">
        <h3 className="text-sm font-bold text-[var(--on-surface)] mb-4">Votre réponse</h3>
        <form onSubmit={handleReply}>
          <textarea
            value={replyContent}
            onChange={e => setReplyContent(e.target.value)}
            rows={4}
            placeholder="Partagez votre expérience, une ressource, un conseil..."
            required
            className="w-full bg-[var(--surface-dark)] rounded-xl px-4 py-3 text-sm text-[var(--on-surface)] placeholder:text-[var(--on-surface-faint)] focus:outline-none focus:ring-2 focus:ring-[#1147D9]/30 resize-none mb-3 border border-[var(--outline)]"
          />
          <div className="flex items-center justify-between">
            <p className="text-xs text-[var(--on-surface-faint)]">
              {replyContent.length} caractère{replyContent.length > 1 ? "s" : ""}
            </p>
            <button
              type="submit"
              disabled={submitting || replyContent.trim().length < 5}
              className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-[#1147D9] text-white text-sm font-semibold hover:bg-[#1A55E6] transition-all disabled:opacity-60"
            >
              {submitting
                ? <span className="animate-spin rounded-full h-3.5 w-3.5 border-b-2 border-white" />
                : <Send size={13} />
              }
              Publier ma réponse
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default function ForumPostPage() {
  return (
    <Suspense
      fallback={
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#1147D9]" />
        </div>
      }
    >
      <ForumPostContent />
    </Suspense>
  )
}
