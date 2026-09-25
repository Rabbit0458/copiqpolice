"use client";

import { useState } from "react";
import { Check, MonitorSmartphone, Moon, Smartphone, Sun } from "lucide-react";
import type { ActiveContentBlock, ActiveContentNode } from "@/lib/admin/api";
import { Card } from "@/components/admin/admin-ui";

type PreviewTheme = "light" | "dark";
type PreviewSize = "compact" | "large";

export function ActivePhonePreview({
  node,
}: {
  node: Partial<ActiveContentNode>;
}) {
  const [theme, setTheme] = useState<PreviewTheme>("light");
  const [size, setSize] = useState<PreviewSize>("large");
  const isDark = theme === "dark";
  const phoneWidth = size === "large" ? 354 : 310;
  const phoneHeight = size === "large" ? 704 : 620;

  return (
    <Card className="self-start overflow-hidden xl:sticky xl:top-24">
      <div className="border-b border-[var(--outline-variant)] p-4">
        <div className="flex items-center gap-3">
          <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]">
            <MonitorSmartphone size={19} />
          </span>
          <div className="min-w-0">
            <h3 className="font-semibold">Aperçu dans l’application</h3>
            <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
              Vérifie le rendu avant de publier.
            </p>
          </div>
        </div>

        <div className="mt-4 grid grid-cols-2 gap-2">
          <SegmentedControl
            label="Thème"
            options={[
              { value: "light", label: "Clair", icon: Sun },
              { value: "dark", label: "Sombre", icon: Moon },
            ]}
            value={theme}
            onChange={(value) => setTheme(value as PreviewTheme)}
          />
          <SegmentedControl
            label="Format"
            options={[
              { value: "compact", label: "Petit", icon: Smartphone },
              { value: "large", label: "Grand", icon: MonitorSmartphone },
            ]}
            value={size}
            onChange={(value) => setSize(value as PreviewSize)}
          />
        </div>
      </div>

      <div className="overflow-x-auto bg-[var(--surface-container)]/45 px-3 py-5">
        <div
          className={`mx-auto overflow-hidden rounded-[42px] border-[7px] shadow-[0_28px_70px_rgba(2,6,23,.35)] transition-[width,height,background-color] duration-300 ${
            isDark
              ? "border-[#252930] bg-[#0f1114] text-[#f7f8fa]"
              : "border-[#171a20] bg-[#f5f6f8] text-[#17191d]"
          }`}
          style={{ width: phoneWidth, height: phoneHeight }}
        >
          <div className="relative h-full overflow-y-auto px-5 pb-8 pt-4">
            <div
              className={`sticky top-0 z-10 -mx-5 -mt-4 mb-5 flex h-14 items-center justify-center border-b px-5 backdrop-blur-xl ${
                isDark
                  ? "border-white/5 bg-[#0f1114]/90"
                  : "border-black/5 bg-[#f5f6f8]/90"
              }`}
            >
              <span
                className={`absolute left-5 text-lg ${isDark ? "text-white" : "text-[#17191d]"}`}
                aria-hidden="true"
              >
                ‹
              </span>
              <div className="text-center">
                <div className="text-[9px] font-extrabold uppercase tracking-[.16em] text-[#3977f6]">
                  Je suis actif
                </div>
                <div className="max-w-[230px] truncate text-[13px] font-bold">
                  {node.node_type === "course"
                    ? "Cours"
                    : "Mon espace professionnel"}
                </div>
              </div>
            </div>

            <div className="mb-5">
              <div className="text-[10px] font-extrabold uppercase tracking-[.13em] text-[#3977f6]">
                {node.node_type === "category"
                  ? "Catégorie"
                  : node.node_type === "subcategory"
                    ? "Sous-catégorie"
                    : "Formation professionnelle"}
              </div>
              <h2 className="mt-1 break-words text-[23px] font-extrabold leading-[1.05] tracking-[-.035em]">
                {node.title?.trim() || "Titre du contenu"}
              </h2>
              <p
                className={`mt-2 text-[13px] leading-5 ${isDark ? "text-[#aeb4bd]" : "text-[#657080]"}`}
              >
                {node.subtitle?.trim() ||
                  (node.node_type === "course"
                    ? "Le sous-titre apparaîtra ici."
                    : "Présente brièvement cette rubrique.")}
              </p>
            </div>

            {node.node_type === "course" ? (
              <CoursePreview
                blocks={node.draft_content ?? []}
                imageUrl={node.image_url}
                isDark={isDark}
              />
            ) : (
              <CategoryPreview node={node} isDark={isDark} />
            )}
          </div>
        </div>
      </div>
    </Card>
  );
}

function CategoryPreview({
  node,
  isDark,
}: {
  node: Partial<ActiveContentNode>;
  isDark: boolean;
}) {
  return (
    <div
      className={`overflow-hidden rounded-[26px] border shadow-[0_16px_38px_rgba(15,23,42,.14)] ${
        isDark ? "border-white/8 bg-[#171b20]" : "border-black/5 bg-white"
      }`}
    >
      <div
        className={`relative h-40 overflow-hidden ${isDark ? "bg-[#20252c]" : "bg-[#e8ecf2]"}`}
      >
        {node.image_url ? (
          <PreviewImage
            key={node.image_url}
            src={node.image_url}
            className="h-full w-full object-cover"
          />
        ) : (
          <div className="grid h-full place-items-center text-center">
            <div>
              <MonitorSmartphone size={26} className="mx-auto text-[#3977f6]" />
              <p
                className={`mt-2 text-xs ${isDark ? "text-[#aeb4bd]" : "text-[#657080]"}`}
              >
                Ajoute une URL publique Supabase
              </p>
            </div>
          </div>
        )}
        <div className="absolute inset-0 bg-gradient-to-t from-black/55 via-transparent to-transparent" />
      </div>
      <div className="flex min-h-28 items-center gap-4 p-4">
        <span
          className={`grid h-12 w-12 shrink-0 place-items-center rounded-2xl text-2xl ${
            isDark ? "bg-white/8" : "bg-[#f0f3f8]"
          }`}
        >
          {node.icon || "📚"}
        </span>
        <div className="min-w-0 flex-1">
          <strong className="block break-words text-[16px] leading-5">
            {node.title?.trim() || "Nouvelle catégorie"}
          </strong>
          <span
            className={`mt-1 block text-xs ${isDark ? "text-[#aeb4bd]" : "text-[#657080]"}`}
          >
            Appuyer pour découvrir
          </span>
        </div>
        <span
          className={`grid h-10 w-10 shrink-0 place-items-center rounded-full ${
            isDark ? "bg-white text-black" : "bg-[#17191d] text-white"
          }`}
        >
          →
        </span>
      </div>
    </div>
  );
}

function CoursePreview({
  blocks,
  imageUrl,
  isDark,
}: {
  blocks: ActiveContentBlock[];
  imageUrl?: string | null;
  isDark: boolean;
}) {
  return (
    <div className="space-y-4">
      {imageUrl && (
        <PreviewImage
          key={imageUrl}
          src={imageUrl}
          className="h-40 w-full rounded-[22px] object-cover"
        />
      )}

      {blocks.length === 0 && (
        <div
          className={`rounded-[22px] border border-dashed p-8 text-center text-xs leading-5 ${
            isDark
              ? "border-white/12 text-[#aeb4bd]"
              : "border-black/10 text-[#657080]"
          }`}
        >
          Les blocs du cours apparaîtront ici au fur et à mesure.
        </div>
      )}

      {blocks.map((block, index) => (
        <PreviewBlock
          key={`${block.type}-${index}`}
          block={block}
          isDark={isDark}
        />
      ))}
    </div>
  );
}

function PreviewBlock({
  block,
  isDark,
}: {
  block: ActiveContentBlock;
  isDark: boolean;
}) {
  if (block.type === "divider") {
    return <hr className={isDark ? "border-white/10" : "border-black/10"} />;
  }

  const text = block.text.trim() || "Contenu à compléter…";
  if (block.type === "heading") {
    return (
      <h3
        className="break-words text-[18px] font-extrabold leading-[1.16] tracking-[-.02em]"
        style={{ color: block.color || (isDark ? "#f7f8fa" : "#17191d") }}
      >
        {text}
      </h3>
    );
  }

  if (["card", "article", "circular"].includes(block.type)) {
    const label =
      block.type === "article"
        ? "ARTICLE"
        : block.type === "circular"
          ? "CIRCULAIRE"
          : "À RETENIR";
    const accent = block.color || "#3977f6";
    return (
      <div
        className={`rounded-[18px] border p-4 ${
          isDark ? "border-white/8 bg-[#171b20]" : "border-black/5 bg-white"
        }`}
        style={{ borderLeftColor: accent, borderLeftWidth: 4 }}
      >
        <div
          className="text-[9px] font-extrabold tracking-[.14em]"
          style={{ color: accent }}
        >
          {label}
        </div>
        <p
          className={`mt-2 whitespace-pre-wrap break-words text-[13px] leading-5 ${
            isDark ? "text-[#d9dde3]" : "text-[#343b45]"
          }`}
        >
          {text}
        </p>
      </div>
    );
  }

  return (
    <p
      className={`whitespace-pre-wrap break-words text-[13px] leading-[1.65] ${
        isDark ? "text-[#d9dde3]" : "text-[#343b45]"
      }`}
      style={{ color: block.color || undefined }}
    >
      {text}
    </p>
  );
}

function SegmentedControl({
  label,
  options,
  value,
  onChange,
}: {
  label: string;
  options: {
    value: string;
    label: string;
    icon: React.ComponentType<{ size?: number }>;
  }[];
  value: string;
  onChange: (value: string) => void;
}) {
  return (
    <fieldset>
      <legend className="sr-only">{label}</legend>
      <div className="grid grid-cols-2 rounded-xl bg-[var(--surface-container)] p-1">
        {options.map((option) => {
          const Icon = option.icon;
          const active = option.value === value;
          return (
            <button
              key={option.value}
              type="button"
              onClick={() => onChange(option.value)}
              aria-pressed={active}
              title={option.label}
              className={`flex min-h-9 cursor-pointer items-center justify-center gap-1 rounded-lg px-2 text-[11px] font-semibold transition focus-visible:outline-2 focus-visible:outline-[var(--brand)] ${
                active
                  ? "bg-[var(--surface)] text-[var(--brand)] shadow-sm"
                  : "text-[var(--on-surface-faint)] hover:text-[var(--on-surface)]"
              }`}
            >
              {active ? <Check size={13} /> : <Icon size={13} />}
              <span>{option.label}</span>
            </button>
          );
        })}
      </div>
    </fieldset>
  );
}

export function PreviewImage({
  src,
  className,
}: {
  src: string;
  className: string;
}) {
  const [failed, setFailed] = useState(false);
  if (failed) {
    return (
      <div
        className={`flex items-center justify-center bg-[var(--surface-container)] px-4 text-center text-xs leading-5 text-[var(--on-surface-muted)] ${className}`}
      >
        Image inaccessible. Vérifie que l’URL Supabase est publique et pointe
        directement vers une image.
      </div>
    );
  }
  return (
    // Les domaines sont saisis dynamiquement par l’administrateur.
    // eslint-disable-next-line @next/next/no-img-element
    <img
      src={src}
      alt="Aperçu du contenu"
      className={className}
      onError={() => setFailed(true)}
    />
  );
}
