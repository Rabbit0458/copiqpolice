"use client";

import { useState } from "react";
import {
  AlignLeft,
  ArrowDown,
  ArrowRight,
  ArrowUp,
  BookOpen,
  Check,
  CheckCircle2,
  Circle,
  FileCheck2,
  FileText,
  FolderOpen,
  Folders,
  GripVertical,
  ImageIcon,
  LayoutTemplate,
  Link2,
  Minus,
  Scale,
  ScrollText,
  Sparkles,
  StickyNote,
  Trash2,
  Type,
  Workflow,
  XCircle,
  type LucideIcon,
} from "lucide-react";
import type {
  ActiveContentBlock,
  ActiveContentNode,
  ActiveNodeType,
} from "@/lib/admin/api";
import { Badge, Button } from "@/components/admin/admin-ui";
import {
  activeCourseTemplates,
  type ActiveCourseTemplateId,
} from "./active-content-templates";
import { PreviewImage } from "./active-content-preview";

export type ActiveDraft = Partial<ActiveContentNode> &
  Pick<ActiveContentNode, "node_type" | "title">;

export type StudioStep = "type" | "template" | "details" | "content" | "review";

export const studioSteps: {
  id: StudioStep;
  label: string;
  shortLabel: string;
  icon: LucideIcon;
}[] = [
  { id: "type", label: "Type de contenu", shortLabel: "Type", icon: Folders },
  {
    id: "template",
    label: "Modèle de départ",
    shortLabel: "Modèle",
    icon: LayoutTemplate,
  },
  {
    id: "details",
    label: "Informations",
    shortLabel: "Infos",
    icon: FileText,
  },
  {
    id: "content",
    label: "Composition",
    shortLabel: "Contenu",
    icon: Workflow,
  },
  {
    id: "review",
    label: "Vérification",
    shortLabel: "Vérifier",
    icon: FileCheck2,
  },
];

export function ActiveStudioStepper({
  current,
  nodeType,
  onChange,
}: {
  current: StudioStep;
  nodeType: ActiveNodeType;
  onChange: (step: StudioStep) => void;
}) {
  const visibleSteps =
    nodeType === "course"
      ? studioSteps
      : studioSteps.filter((step) => step.id !== "template");
  const currentIndex = visibleSteps.findIndex((step) => step.id === current);
  return (
    <nav aria-label="Étapes de création" className="px-3 py-4 md:px-5">
      <ol
        className={`grid gap-1.5 ${nodeType === "course" ? "grid-cols-5" : "grid-cols-4"}`}
      >
        {visibleSteps.map((step, index) => {
          const Icon = step.icon;
          const active = step.id === current;
          const complete = index < currentIndex;
          return (
            <li key={step.id}>
              <button
                type="button"
                onClick={() => onChange(step.id)}
                aria-current={active ? "step" : undefined}
                className={`group flex min-h-[66px] w-full cursor-pointer flex-col items-center justify-center gap-1 rounded-xl px-1.5 text-center transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${
                  active
                    ? "bg-[var(--brand)]/10 text-[var(--brand)]"
                    : "text-[var(--on-surface-faint)] hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)]"
                }`}
              >
                <span
                  className={`grid h-8 w-8 shrink-0 place-items-center rounded-lg border transition ${
                    active
                      ? "border-[var(--brand)] bg-[var(--brand)] text-white"
                      : complete
                        ? "border-[var(--success)]/30 bg-[var(--success)]/10 text-[var(--success)]"
                        : "border-[var(--outline)] bg-[var(--surface-container)]"
                  }`}
                >
                  {complete ? <Check size={15} /> : <Icon size={15} />}
                </span>
                <span className="min-w-0">
                  <span className="hidden text-[9px] font-semibold uppercase tracking-wide opacity-70 2xl:block">
                    Étape {index + 1}
                  </span>
                  <span className="block truncate text-[10px] font-semibold sm:text-xs">
                    {step.shortLabel}
                  </span>
                </span>
              </button>
            </li>
          );
        })}
      </ol>
    </nav>
  );
}

export function ContentTypeStep({
  value,
  onChoose,
}: {
  value: ActiveNodeType;
  onChoose: (type: ActiveNodeType) => void;
}) {
  const choices: {
    value: ActiveNodeType;
    title: string;
    description: string;
    icon: LucideIcon;
    number: string;
  }[] = [
    {
      value: "category",
      title: "Catégorie",
      description: "Le premier niveau visible sur l’accueil de l’espace actif.",
      icon: FolderOpen,
      number: "01",
    },
    {
      value: "subcategory",
      title: "Sous-catégorie",
      description:
        "Une rubrique rangée dans une catégorie pour organiser les cours.",
      icon: Folders,
      number: "02",
    },
    {
      value: "course",
      title: "Cours",
      description:
        "Un contenu pédagogique composé de blocs et publié dans l’application.",
      icon: BookOpen,
      number: "03",
    },
  ];

  return (
    <StepLayout
      eyebrow="Commençons simplement"
      title="Que veux-tu créer ?"
      description="Choisis un type de contenu. L’assistant adaptera automatiquement les étapes suivantes."
    >
      <div className="grid gap-4 lg:grid-cols-3">
        {choices.map((choice) => {
          const Icon = choice.icon;
          const selected = value === choice.value;
          return (
            <button
              key={choice.value}
              type="button"
              onClick={() => onChoose(choice.value)}
              aria-pressed={selected}
              className={`group relative min-h-[290px] cursor-pointer overflow-hidden rounded-[28px] border px-6 pb-16 pt-6 text-left transition duration-200 motion-reduce:transition-none motion-reduce:hover:translate-y-0 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${
                selected
                  ? "border-[var(--brand)] bg-[linear-gradient(145deg,rgba(17,71,217,.16),rgba(17,71,217,.035))] shadow-[0_22px_58px_rgba(17,71,217,.18)]"
                  : "border-[var(--outline-variant)] bg-[linear-gradient(145deg,var(--surface-container),var(--surface))] hover:-translate-y-1 hover:border-[var(--brand)]/40 hover:shadow-[0_20px_50px_rgba(15,23,42,.14)]"
              }`}
            >
              <span className="absolute -right-2 top-1 text-8xl font-bold tracking-[-.1em] text-[var(--on-surface)]/[.035]">
                {choice.number}
              </span>
              <span
                className={`grid h-16 w-16 place-items-center rounded-[20px] transition duration-200 ${
                  selected
                    ? "bg-[var(--brand)] text-white shadow-lg shadow-blue-950/25"
                    : "bg-[var(--surface)] text-[var(--brand)] shadow-sm group-hover:bg-[var(--brand)] group-hover:text-white"
                }`}
              >
                <Icon size={28} />
              </span>
              <h3 className="mt-9 text-xl font-semibold tracking-[-.025em]">
                {choice.title}
              </h3>
              <p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">
                {choice.description}
              </p>
              <span className="absolute bottom-6 left-6 inline-flex items-center gap-2 text-sm font-semibold text-[var(--brand)]">
                Choisir ce format <ArrowRight size={16} />
              </span>
            </button>
          );
        })}
      </div>
    </StepLayout>
  );
}

export function TemplateStep({
  nodeType,
  selected,
  onChoose,
  onSkip,
}: {
  nodeType: ActiveNodeType;
  selected: ActiveCourseTemplateId | null;
  onChoose: (id: ActiveCourseTemplateId) => void;
  onSkip: () => void;
}) {
  if (nodeType !== "course") {
    return (
      <StepLayout
        eyebrow="Aucun choix compliqué"
        title="Une structure déjà adaptée"
        description="Les modèles concernent uniquement les cours. Ta catégorie utilisera automatiquement la présentation COP’IQ."
      >
        <div className="rounded-3xl border border-[var(--brand)]/20 bg-[var(--brand)]/[.055] p-7 text-center">
          <span className="mx-auto grid h-16 w-16 place-items-center rounded-2xl bg-[var(--brand)] text-white shadow-xl shadow-blue-950/20">
            <CheckCircle2 size={28} />
          </span>
          <h3 className="mt-5 text-lg font-semibold">Tout est prêt</h3>
          <p className="mx-auto mt-2 max-w-md text-sm leading-6 text-[var(--on-surface-muted)]">
            Passe directement aux informations : titre, parent, icône et image.
          </p>
          <Button className="mt-5" onClick={onSkip}>
            Continuer <ArrowRight size={16} className="ml-2 inline" />
          </Button>
        </div>
      </StepLayout>
    );
  }

  return (
    <StepLayout
      eyebrow="Gagne du temps"
      title="Choisis un modèle de cours"
      description="Chaque modèle prépare des blocs modifiables. Rien n’est publié tant que tu ne le décides pas."
    >
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {activeCourseTemplates.map((template) => {
          const active = selected === template.id;
          return (
            <button
              key={template.id}
              type="button"
              onClick={() => onChoose(template.id)}
              aria-pressed={active}
              className={`group relative min-h-[250px] cursor-pointer overflow-hidden rounded-[26px] border px-6 pb-16 pt-6 text-left transition duration-200 motion-reduce:transition-none motion-reduce:hover:translate-y-0 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${
                active
                  ? "border-[var(--brand)] bg-[var(--brand)]/[.08] shadow-[0_20px_52px_rgba(17,71,217,.16)]"
                  : "border-[var(--outline-variant)] bg-[linear-gradient(145deg,var(--surface-container),var(--surface))] hover:-translate-y-1 hover:border-[var(--brand)]/35 hover:shadow-[0_18px_45px_rgba(15,23,42,.13)]"
              }`}
            >
              <span
                className="absolute inset-y-0 left-0 w-1"
                style={{ backgroundColor: template.accent }}
              />
              <div className="flex items-start justify-between gap-3">
                <span
                  className="grid h-14 w-14 shrink-0 place-items-center rounded-2xl"
                  style={{
                    backgroundColor: `${template.accent}18`,
                    color: template.accent,
                  }}
                >
                  <LayoutTemplate size={24} />
                </span>
                {active && (
                  <span className="grid h-7 w-7 place-items-center rounded-full bg-[var(--brand)] text-white">
                    <Check size={15} />
                  </span>
                )}
              </div>
              <h3 className="mt-6 text-lg font-semibold">{template.name}</h3>
              <p className="mt-1.5 text-sm leading-5 text-[var(--on-surface-muted)]">
                {template.description}
              </p>
              <p className="mt-4 text-[11px] font-medium uppercase tracking-wide text-[var(--on-surface-faint)]">
                {template.hint}
              </p>
              <span className="absolute bottom-5 left-6 inline-flex items-center gap-1.5 text-xs font-semibold text-[var(--brand)] opacity-80 transition group-hover:opacity-100">
                Utiliser ce modèle <ArrowRight size={14} />
              </span>
            </button>
          );
        })}
      </div>
      <button
        type="button"
        onClick={onSkip}
        className="mt-4 min-h-11 cursor-pointer rounded-xl px-3 text-sm font-semibold text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
      >
        Partir d’un cours vide
      </button>
    </StepLayout>
  );
}

export function DetailsStep({
  draft,
  parents,
  onChange,
}: {
  draft: ActiveDraft;
  parents: ActiveContentNode[];
  onChange: (patch: Partial<ActiveDraft>) => void;
}) {
  const image = inspectImageUrl(draft.image_url);

  return (
    <StepLayout
      eyebrow="Les informations essentielles"
      title="Présente ton contenu"
      description="Ces informations sont reprises en direct dans l’application. Tu peux les modifier avant publication."
    >
      <div className="grid gap-5 lg:grid-cols-2">
        <Field label="Type de contenu">
          <div className="flex min-h-12 items-center justify-between rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] px-3.5 text-sm font-semibold">
            <span>{typeLabel(draft.node_type)}</span>
            <Badge tone="brand">Défini à l’étape 1</Badge>
          </div>
        </Field>
        <Field
          label="Emplacement"
          hint={
            draft.node_type === "category"
              ? "Une catégorie peut rester à la racine."
              : "Choisis la rubrique qui contiendra ce contenu."
          }
        >
          <select
            value={draft.parent_id ?? ""}
            onChange={(event) =>
              onChange({ parent_id: event.target.value || null })
            }
            className={fieldClass}
          >
            <option value="">Racine du module</option>
            {parents.map((parent) => (
              <option key={parent.id} value={parent.id}>
                {parent.icon || "📚"} {parent.title}
              </option>
            ))}
          </select>
        </Field>
      </div>

      <div className="mt-5 grid gap-5 lg:grid-cols-[minmax(0,1fr)_150px]">
        <Field
          label="Titre"
          required
          hint="Court, précis et immédiatement compréhensible."
        >
          <input
            value={draft.title}
            onChange={(event) => onChange({ title: event.target.value })}
            placeholder="Ex. Contrôle d’identité"
            className={fieldClass}
          />
        </Field>
        <Field label="Ordre" hint="Position d’affichage.">
          <input
            type="number"
            value={draft.sort_order ?? 0}
            onChange={(event) =>
              onChange({ sort_order: Number(event.target.value) })
            }
            className={fieldClass}
          />
        </Field>
      </div>

      <div className="mt-5">
        <Field
          label="Sous-titre"
          hint="Une phrase qui explique ce que l’utilisateur va trouver."
        >
          <input
            value={draft.subtitle ?? ""}
            onChange={(event) => onChange({ subtitle: event.target.value })}
            placeholder="Ex. Les règles et réflexes à connaître sur le terrain"
            className={fieldClass}
          />
        </Field>
      </div>

      <div className="mt-6">
        <div className="mb-3 flex items-center justify-between gap-3">
          <div>
            <h3 className="text-sm font-semibold">Icône du contenu</h3>
            <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
              Elle sera affichée dans les cartes de l’application.
            </p>
          </div>
          <span className="grid h-11 w-11 place-items-center rounded-xl bg-[var(--brand)]/10 text-2xl">
            {draft.icon || "📚"}
          </span>
        </div>
        <div
          className="grid grid-cols-6 gap-2 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/55 p-3 sm:grid-cols-9"
          role="listbox"
          aria-label="Choisir une icône"
        >
          {iconChoices.map((choice) => (
            <button
              key={choice.value}
              type="button"
              role="option"
              aria-selected={draft.icon === choice.value}
              title={choice.label}
              onClick={() => onChange({ icon: choice.value })}
              className={`grid min-h-11 cursor-pointer place-items-center rounded-xl border text-xl transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${
                draft.icon === choice.value
                  ? "border-[var(--brand)] bg-[var(--brand)]/15 shadow-sm"
                  : "border-transparent bg-[var(--surface)] hover:border-[var(--outline)]"
              }`}
            >
              {choice.value}
              <span className="sr-only">{choice.label}</span>
            </button>
          ))}
        </div>
      </div>

      <div className="mt-6 rounded-3xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/35 p-4 md:p-5">
        <div className="flex items-start gap-3">
          <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]">
            <ImageIcon size={19} />
          </span>
          <div>
            <h3 className="text-sm font-semibold">
              Image depuis Supabase Storage
            </h3>
            <p className="mt-1 text-xs leading-5 text-[var(--on-surface-muted)]">
              Téléverse l’image dans ton dossier public <strong>assets</strong>,
              récupère son URL publique permanente puis colle-la ici.
            </p>
          </div>
        </div>
        <label className="relative mt-4 block">
          <span className="sr-only">URL publique de l’image</span>
          <Link2
            size={16}
            className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]"
          />
          <input
            type="url"
            inputMode="url"
            value={draft.image_url ?? ""}
            onChange={(event) => onChange({ image_url: event.target.value })}
            placeholder="https://…supabase.co/storage/v1/object/public/assets/…"
            className={`${fieldClass} pl-10`}
          />
        </label>
        <ImageUrlStatus state={image} />
        {image.kind === "valid" && draft.image_url && (
          <PreviewImage
            key={draft.image_url}
            src={draft.image_url}
            className="mt-4 h-44 w-full rounded-2xl object-cover"
          />
        )}
      </div>
    </StepLayout>
  );
}

export function BlocksEditor({
  blocks,
  onChange,
}: {
  blocks: ActiveContentBlock[];
  onChange: (blocks: ActiveContentBlock[]) => void;
}) {
  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);

  const update = (index: number, patch: Partial<ActiveContentBlock>) => {
    onChange(
      blocks.map((block, blockIndex) =>
        blockIndex === index ? { ...block, ...patch } : block,
      ),
    );
  };
  const add = (type: ActiveContentBlock["type"]) => {
    onChange([
      ...blocks,
      {
        type,
        text: "",
        ...(["card", "article", "circular"].includes(type)
          ? { color: defaultColor(type) }
          : {}),
      },
    ]);
  };
  const remove = (index: number) =>
    onChange(blocks.filter((_, blockIndex) => blockIndex !== index));
  const move = (from: number, to: number) => {
    if (to < 0 || to >= blocks.length || from === to) return;
    const next = [...blocks];
    const [item] = next.splice(from, 1);
    next.splice(to, 0, item);
    onChange(next);
  };

  return (
    <StepLayout
      eyebrow="Compose visuellement"
      title="Construis ton cours bloc par bloc"
      description="Ajoute, rédige et déplace les éléments. L’ordre affiché ici sera exactement celui du cours."
    >
      <div className="rounded-3xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/35 p-4">
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div>
            <h3 className="text-sm font-semibold">Ajouter un bloc</h3>
            <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
              {blocks.length} bloc{blocks.length > 1 ? "s" : ""} dans ce cours
            </p>
          </div>
          <Badge tone="brand">Glisser-déposer activé</Badge>
        </div>
        <div className="mt-4 grid grid-cols-2 gap-2 sm:grid-cols-3">
          {blockOptions.map((option) => {
            const Icon = option.icon;
            return (
              <button
                key={option.type}
                type="button"
                onClick={() => add(option.type)}
                className="group flex min-h-12 cursor-pointer items-center gap-2 rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-3 text-left text-xs font-semibold transition hover:border-[var(--brand)]/35 hover:bg-[var(--brand)]/[.045] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
              >
                <span className="grid h-8 w-8 shrink-0 place-items-center rounded-lg bg-[var(--brand)]/10 text-[var(--brand)] transition group-hover:bg-[var(--brand)] group-hover:text-white">
                  <Icon size={15} />
                </span>
                {option.label}
              </button>
            );
          })}
        </div>
      </div>

      <div className="mt-5 space-y-3">
        {blocks.map((block, index) => {
          const meta = blockMeta(block.type);
          const Icon = meta.icon;
          return (
            <article
              key={`${block.type}-${index}`}
              onDragOver={(event) => {
                if (draggedIndex == null) return;
                event.preventDefault();
              }}
              onDrop={(event) => {
                event.preventDefault();
                if (draggedIndex != null) move(draggedIndex, index);
                setDraggedIndex(null);
              }}
              className={`group overflow-hidden rounded-2xl border bg-[var(--surface)] transition duration-200 ${
                draggedIndex === index
                  ? "border-[var(--brand)] opacity-55"
                  : "border-[var(--outline-variant)] hover:border-[var(--brand)]/25"
              }`}
            >
              <div className="flex items-center gap-2 border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/45 px-3 py-2.5">
                <button
                  type="button"
                  draggable
                  onDragStart={(event) => {
                    setDraggedIndex(index);
                    event.dataTransfer.effectAllowed = "move";
                    event.dataTransfer.setData("text/plain", String(index));
                  }}
                  onDragEnd={() => setDraggedIndex(null)}
                  className="cursor-grab rounded-lg p-1.5 text-[var(--on-surface-faint)] hover:bg-[var(--surface-container-hi)] active:cursor-grabbing"
                  aria-label={`Déplacer le bloc ${index + 1}`}
                  title="Déplacer"
                >
                  <GripVertical size={16} />
                </button>
                <span className="grid h-8 w-8 place-items-center rounded-lg bg-[var(--brand)]/10 text-[var(--brand)]">
                  <Icon size={15} />
                </span>
                <div className="min-w-0 flex-1">
                  <div className="text-xs font-semibold">
                    {index + 1}. {meta.label}
                  </div>
                  <div className="truncate text-[10px] text-[var(--on-surface-faint)]">
                    {meta.hint}
                  </div>
                </div>
                {block.type !== "divider" && (
                  <label className="flex items-center gap-1.5 text-[10px] text-[var(--on-surface-faint)]">
                    <span className="sr-only">Couleur du bloc</span>
                    <input
                      type="color"
                      value={block.color || defaultColor(block.type)}
                      onChange={(event) =>
                        update(index, { color: event.target.value })
                      }
                      className="h-8 w-8 cursor-pointer rounded-lg border-0 bg-transparent p-0"
                      title="Couleur"
                    />
                  </label>
                )}
                <BlockAction
                  label="Monter"
                  icon={ArrowUp}
                  disabled={index === 0}
                  onClick={() => move(index, index - 1)}
                />
                <BlockAction
                  label="Descendre"
                  icon={ArrowDown}
                  disabled={index === blocks.length - 1}
                  onClick={() => move(index, index + 1)}
                />
                <BlockAction
                  label="Supprimer"
                  icon={Trash2}
                  danger
                  onClick={() => remove(index)}
                />
              </div>
              {block.type === "divider" ? (
                <div className="px-5 py-7">
                  <div className="h-px bg-[var(--outline)]" />
                </div>
              ) : (
                <div className="p-3">
                  <textarea
                    value={block.text}
                    onChange={(event) =>
                      update(index, { text: event.target.value })
                    }
                    rows={block.type === "paragraph" ? 6 : 4}
                    placeholder={meta.placeholder}
                    className="w-full resize-y rounded-xl border border-[var(--outline)] bg-[var(--surface-container)]/40 p-3 text-sm leading-6 outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"
                  />
                </div>
              )}
            </article>
          );
        })}
      </div>

      {blocks.length === 0 && (
        <div className="mt-5 rounded-3xl border border-dashed border-[var(--outline)] px-6 py-12 text-center">
          <Workflow size={30} className="mx-auto text-[var(--brand)]" />
          <h3 className="mt-4 font-semibold">Ton cours est encore vide</h3>
          <p className="mx-auto mt-1 max-w-sm text-sm leading-6 text-[var(--on-surface-muted)]">
            Ajoute un premier bloc ou retourne choisir un modèle prêt à remplir.
          </p>
        </div>
      )}
    </StepLayout>
  );
}

export function NonCourseContentStep({
  nodeType,
  onContinue,
}: {
  nodeType: ActiveNodeType;
  onContinue: () => void;
}) {
  return (
    <StepLayout
      eyebrow="Aucun éditeur nécessaire"
      title={`${typeLabel(nodeType)} prête à être vérifiée`}
      description="Les blocs pédagogiques sont réservés aux cours. Ta structure, son image et son icône suffisent pour cette étape."
    >
      <div className="rounded-3xl border border-[var(--success)]/20 bg-[var(--success)]/[.055] p-8 text-center">
        <CheckCircle2 size={34} className="mx-auto text-[var(--success)]" />
        <h3 className="mt-4 font-semibold">Composition automatique</h3>
        <p className="mx-auto mt-2 max-w-md text-sm leading-6 text-[var(--on-surface-muted)]">
          L’application utilisera sa carte habituelle et affichera les contenus
          enfants dans l’ordre choisi.
        </p>
        <Button className="mt-5" onClick={onContinue}>
          Vérifier le rendu <ArrowRight size={16} className="ml-2 inline" />
        </Button>
      </div>
    </StepLayout>
  );
}

export type ReadinessItem = {
  label: string;
  detail: string;
  ok: boolean;
  blocking?: boolean;
};

export function ReviewStep({
  draft,
  dirty,
  readiness,
}: {
  draft: ActiveDraft;
  dirty: boolean;
  readiness: ReadinessItem[];
}) {
  const readyCount = readiness.filter((item) => item.ok).length;
  return (
    <StepLayout
      eyebrow="Dernier contrôle"
      title="Vérifie avant de publier"
      description="La publication restera séparée de l’enregistrement du brouillon. Rien ne part dans l’application sans ton accord."
    >
      <div className="grid gap-4 lg:grid-cols-[1fr_230px]">
        <div className="space-y-2.5">
          {readiness.map((item) => (
            <div
              key={item.label}
              className={`flex items-start gap-3 rounded-2xl border p-4 ${
                item.ok
                  ? "border-[var(--success)]/20 bg-[var(--success)]/[.045]"
                  : item.blocking
                    ? "border-[var(--danger)]/20 bg-[var(--danger)]/[.045]"
                    : "border-[var(--warning)]/20 bg-[var(--warning)]/[.045]"
              }`}
            >
              {item.ok ? (
                <CheckCircle2
                  size={20}
                  className="mt-0.5 shrink-0 text-[var(--success)]"
                />
              ) : (
                <XCircle
                  size={20}
                  className={`mt-0.5 shrink-0 ${item.blocking ? "text-[var(--danger)]" : "text-[var(--warning)]"}`}
                />
              )}
              <div>
                <h3 className="text-sm font-semibold">{item.label}</h3>
                <p className="mt-0.5 text-xs leading-5 text-[var(--on-surface-muted)]">
                  {item.detail}
                </p>
              </div>
            </div>
          ))}
        </div>

        <div className="rounded-3xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/50 p-5">
          <div className="text-[11px] font-semibold uppercase tracking-[.14em] text-[var(--on-surface-faint)]">
            Préparation
          </div>
          <div className="mt-3 text-4xl font-bold tracking-[-.06em] tabular-nums">
            {readyCount}/{readiness.length}
          </div>
          <div className="mt-3 h-2 overflow-hidden rounded-full bg-[var(--surface-container-hi)]">
            <div
              className="h-full rounded-full bg-[var(--brand)] transition-[width] duration-300"
              style={{
                width: `${(readyCount / Math.max(readiness.length, 1)) * 100}%`,
              }}
            />
          </div>
          <div className="mt-5 space-y-2 text-xs text-[var(--on-surface-muted)]">
            <p>
              <strong className="text-[var(--on-surface)]">Type :</strong>{" "}
              {typeLabel(draft.node_type)}
            </p>
            <p>
              <strong className="text-[var(--on-surface)]">État :</strong>{" "}
              {draft.status === "published" ? "Publié" : "Brouillon"}
            </p>
            <p>
              <strong className="text-[var(--on-surface)]">Serveur :</strong>{" "}
              {dirty ? "Modifications à enregistrer" : "À jour"}
            </p>
          </div>
        </div>
      </div>
    </StepLayout>
  );
}

function StepLayout({
  eyebrow,
  title,
  description,
  children,
}: {
  eyebrow: string;
  title: string;
  description: string;
  children: React.ReactNode;
}) {
  return (
    <div className="p-5 md:p-7">
      <div className="mb-7 max-w-2xl">
        <div className="flex items-center gap-2 text-[11px] font-bold uppercase tracking-[.15em] text-[var(--brand)]">
          <Sparkles size={14} /> {eyebrow}
        </div>
        <h2 className="mt-2 text-2xl font-semibold tracking-[-.035em] md:text-[28px]">
          {title}
        </h2>
        <p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">
          {description}
        </p>
      </div>
      {children}
    </div>
  );
}

function Field({
  label,
  hint,
  required,
  children,
}: {
  label: string;
  hint?: string;
  required?: boolean;
  children: React.ReactNode;
}) {
  return (
    <label className="block">
      <span className="flex items-center gap-1.5 text-sm font-semibold">
        {label}
        {required && <span className="text-[var(--danger)]">*</span>}
      </span>
      {hint && (
        <span className="mt-0.5 block text-xs leading-5 text-[var(--on-surface-muted)]">
          {hint}
        </span>
      )}
      <span className="mt-2 block">{children}</span>
    </label>
  );
}

function ImageUrlStatus({ state }: { state: ImageInspection }) {
  if (state.kind === "empty") {
    return (
      <p className="mt-2 flex items-center gap-2 text-xs text-[var(--on-surface-faint)]">
        <Circle size={12} /> Aucune image renseignée pour le moment.
      </p>
    );
  }
  if (state.kind === "invalid") {
    return (
      <p className="mt-2 flex items-center gap-2 text-xs font-medium text-[var(--danger)]">
        <XCircle size={14} /> {state.message}
      </p>
    );
  }
  return (
    <p
      className={`mt-2 flex items-center gap-2 text-xs font-medium ${
        state.publicSupabase ? "text-[var(--success)]" : "text-[var(--warning)]"
      }`}
    >
      {state.publicSupabase ? <CheckCircle2 size={14} /> : <Link2 size={14} />}
      {state.publicSupabase
        ? "URL publique Supabase reconnue."
        : "URL valide, mais elle ne ressemble pas à une URL publique Supabase."}
    </p>
  );
}

function BlockAction({
  label,
  icon: Icon,
  onClick,
  disabled,
  danger,
}: {
  label: string;
  icon: LucideIcon;
  onClick: () => void;
  disabled?: boolean;
  danger?: boolean;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      aria-label={label}
      title={label}
      className={`grid h-8 w-8 shrink-0 cursor-pointer place-items-center rounded-lg transition focus-visible:outline-2 focus-visible:outline-[var(--brand)] disabled:cursor-not-allowed disabled:opacity-30 ${
        danger
          ? "text-[var(--on-surface-faint)] hover:bg-[var(--danger)]/10 hover:text-[var(--danger)]"
          : "text-[var(--on-surface-faint)] hover:bg-[var(--surface-container-hi)] hover:text-[var(--brand)]"
      }`}
    >
      <Icon size={15} />
    </button>
  );
}

type ImageInspection =
  | { kind: "empty" }
  | { kind: "invalid"; message: string }
  | { kind: "valid"; publicSupabase: boolean };

export function inspectImageUrl(value?: string | null): ImageInspection {
  const source = value?.trim();
  if (!source) return { kind: "empty" };
  try {
    const url = new URL(source);
    if (url.protocol !== "https:" && url.protocol !== "http:") {
      return { kind: "invalid", message: "L’URL doit commencer par https://" };
    }
    return {
      kind: "valid",
      publicSupabase:
        url.hostname.endsWith(".supabase.co") &&
        url.pathname.includes("/storage/v1/object/public/"),
    };
  } catch {
    return { kind: "invalid", message: "Cette URL n’est pas valide." };
  }
}

function typeLabel(type: ActiveNodeType) {
  if (type === "category") return "Catégorie";
  if (type === "subcategory") return "Sous-catégorie";
  return "Cours";
}

function defaultColor(type: ActiveContentBlock["type"]) {
  if (type === "article") return "#dc2626";
  if (type === "circular") return "#0891b2";
  if (type === "card") return "#2563eb";
  return "#202124";
}

function blockMeta(type: ActiveContentBlock["type"]) {
  return blockOptions.find((option) => option.type === type) ?? blockOptions[1];
}

const fieldClass =
  "min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] px-3.5 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10";

const iconChoices = [
  { value: "📚", label: "Cours" },
  { value: "👮", label: "Police" },
  { value: "🚔", label: "Intervention" },
  { value: "🛡️", label: "Protection" },
  { value: "⚖️", label: "Droit" },
  { value: "🏛️", label: "Institution" },
  { value: "📖", label: "Documentation" },
  { value: "📝", label: "Évaluation" },
  { value: "📋", label: "Procédure" },
  { value: "🔍", label: "Enquête" },
  { value: "🚨", label: "Urgence" },
  { value: "🚦", label: "Route" },
  { value: "🚗", label: "Véhicule" },
  { value: "📡", label: "Communication" },
  { value: "🤝", label: "Relations" },
  { value: "🧰", label: "Outils" },
  { value: "🏃", label: "Sport" },
  { value: "⭐", label: "Important" },
] as const;

const blockOptions: {
  type: ActiveContentBlock["type"];
  label: string;
  hint: string;
  placeholder: string;
  icon: LucideIcon;
}[] = [
  {
    type: "heading",
    label: "Titre",
    hint: "Organise une nouvelle partie",
    placeholder: "Titre de la section…",
    icon: Type,
  },
  {
    type: "paragraph",
    label: "Paragraphe",
    hint: "Explique avec un texte fluide",
    placeholder: "Rédige le contenu du paragraphe…",
    icon: AlignLeft,
  },
  {
    type: "card",
    label: "Encadré",
    hint: "Met en valeur une information",
    placeholder: "Information importante à retenir…",
    icon: StickyNote,
  },
  {
    type: "article",
    label: "Article",
    hint: "Présente une référence légale",
    placeholder: "Référence et contenu de l’article…",
    icon: Scale,
  },
  {
    type: "circular",
    label: "Circulaire",
    hint: "Affiche une directive officielle",
    placeholder: "Référence et directives de la circulaire…",
    icon: ScrollText,
  },
  {
    type: "divider",
    label: "Séparateur",
    hint: "Aère visuellement le cours",
    placeholder: "",
    icon: Minus,
  },
];
