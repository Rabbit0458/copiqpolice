export type ActiveTemplateBlockType =
  "heading" | "paragraph" | "card" | "article" | "circular" | "divider";

export type ActiveTemplateBlock = {
  type: ActiveTemplateBlockType;
  text: string;
  color?: string;
};

export type ActiveCourseTemplateId =
  | "simple"
  | "legal_sheet"
  | "code_article"
  | "circular"
  | "procedure"
  | "complete";

export type ActiveCourseTemplate = {
  id: ActiveCourseTemplateId;
  name: string;
  description: string;
  hint: string;
  accent: string;
  blocks: ActiveTemplateBlock[];
};

export const activeCourseTemplates: ActiveCourseTemplate[] = [
  {
    id: "simple",
    name: "Cours simple",
    description:
      "Une structure courte pour transmettre l’essentiel rapidement.",
    hint: "Titre + introduction + contenu principal",
    accent: "#2563eb",
    blocks: [
      { type: "heading", text: "Titre de la leçon", color: "#2563eb" },
      {
        type: "paragraph",
        text: "Présente ici l’objectif du cours et ce que l’apprenant doit retenir.",
      },
      {
        type: "paragraph",
        text: "Développe ensuite le contenu avec des phrases courtes et concrètes.",
      },
    ],
  },
  {
    id: "legal_sheet",
    name: "Fiche juridique",
    description:
      "Une fiche lisible avec contexte, principe et points à retenir.",
    hint: "Contexte + règle + mémo opérationnel",
    accent: "#7c3aed",
    blocks: [
      { type: "heading", text: "Cadre juridique", color: "#7c3aed" },
      {
        type: "paragraph",
        text: "Explique le contexte juridique et le champ d’application de la règle.",
      },
      {
        type: "article",
        text: "Référence légale et formulation essentielle à connaître.",
        color: "#7c3aed",
      },
      {
        type: "card",
        text: "À retenir : résume ici les conséquences pratiques de la règle.",
        color: "#7c3aed",
      },
    ],
  },
  {
    id: "code_article",
    name: "Article de code",
    description:
      "Une lecture guidée d’un article avec explication et application.",
    hint: "Référence + texte + décryptage",
    accent: "#dc2626",
    blocks: [
      { type: "heading", text: "Article et référence", color: "#dc2626" },
      {
        type: "article",
        text: "Insère ici le texte ou l’extrait utile de l’article.",
        color: "#dc2626",
      },
      { type: "heading", text: "Comment le comprendre ?", color: "#dc2626" },
      {
        type: "paragraph",
        text: "Explique simplement les conditions, les effets et les limites de cet article.",
      },
      {
        type: "card",
        text: "Application terrain : ajoute un exemple concret et immédiatement compréhensible.",
        color: "#dc2626",
      },
    ],
  },
  {
    id: "circular",
    name: "Circulaire",
    description:
      "Une présentation structurée d’une circulaire et de ses directives.",
    hint: "Objet + directives + mise en œuvre",
    accent: "#0891b2",
    blocks: [
      { type: "heading", text: "Objet de la circulaire", color: "#0891b2" },
      {
        type: "circular",
        text: "Indique la référence, la date et les principales directives de la circulaire.",
        color: "#0891b2",
      },
      { type: "heading", text: "Mise en œuvre", color: "#0891b2" },
      {
        type: "paragraph",
        text: "Décris les personnes concernées, les étapes et les points de vigilance.",
      },
    ],
  },
  {
    id: "procedure",
    name: "Procédure opérationnelle",
    description:
      "Un déroulé actionnable pour guider une intervention étape par étape.",
    hint: "Objectif + étapes + vigilance",
    accent: "#ea580c",
    blocks: [
      { type: "heading", text: "Objectif de la procédure", color: "#ea580c" },
      {
        type: "paragraph",
        text: "Précise la situation de départ et le résultat attendu.",
      },
      { type: "heading", text: "1. Préparer", color: "#ea580c" },
      { type: "paragraph", text: "Décris les vérifications préalables." },
      { type: "heading", text: "2. Agir", color: "#ea580c" },
      {
        type: "paragraph",
        text: "Décris les actions dans leur ordre logique.",
      },
      {
        type: "card",
        text: "Point de vigilance : indique ici le risque principal à éviter.",
        color: "#ea580c",
      },
    ],
  },
  {
    id: "complete",
    name: "Cours complet",
    description:
      "Un parcours pédagogique complet avec chapitres et synthèse finale.",
    hint: "Introduction + chapitres + résumé",
    accent: "#16a34a",
    blocks: [
      { type: "heading", text: "Introduction", color: "#16a34a" },
      {
        type: "paragraph",
        text: "Présente les objectifs, le contexte et les connaissances attendues.",
      },
      { type: "divider", text: "" },
      { type: "heading", text: "Chapitre 1", color: "#16a34a" },
      { type: "paragraph", text: "Développe ici le premier chapitre." },
      {
        type: "card",
        text: "À retenir : ajoute le point essentiel du premier chapitre.",
        color: "#16a34a",
      },
      { type: "divider", text: "" },
      { type: "heading", text: "Chapitre 2", color: "#16a34a" },
      { type: "paragraph", text: "Développe ici le deuxième chapitre." },
      { type: "divider", text: "" },
      { type: "heading", text: "Résumé", color: "#16a34a" },
      {
        type: "card",
        text: "Synthèse : résume les éléments indispensables à mémoriser.",
        color: "#16a34a",
      },
    ],
  },
];

export function blocksFromTemplate(
  id: ActiveCourseTemplateId,
): ActiveTemplateBlock[] {
  const template = activeCourseTemplates.find((item) => item.id === id);
  if (!template) return [];
  return template.blocks.map((block) => ({ ...block }));
}

export function moveArrayItem<T>(
  items: readonly T[],
  from: number,
  to: number,
): T[] {
  if (
    from === to ||
    from < 0 ||
    to < 0 ||
    from >= items.length ||
    to >= items.length
  ) {
    return [...items];
  }
  const next = [...items];
  const [item] = next.splice(from, 1);
  next.splice(to, 0, item);
  return next;
}
