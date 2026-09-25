"use client";

import { useMemo, useState } from "react";
import {
  ArrowDown,
  ArrowUp,
  Check,
  ChevronDown,
  ChevronRight,
  FolderInput,
  FolderTree,
  GripVertical,
  Plus,
  Save,
  Search,
} from "lucide-react";
import type { ActiveContentNode } from "@/lib/admin/api";
import { Badge, Button, Card } from "@/components/admin/admin-ui";

type TreeItem = ActiveContentNode & {
  parent_id: string | null;
  sort_order: number;
};

export function ActiveContentTree({
  nodes,
  selectedId,
  pendingCount,
  busy,
  onSelect,
  onNew,
  onMoveToParent,
  onMoveOrder,
  onSaveOrder,
}: {
  nodes: TreeItem[];
  selectedId?: string;
  pendingCount: number;
  busy: boolean;
  onSelect: (node: TreeItem) => void;
  onNew: () => void;
  onMoveToParent: (nodeId: string, parentId: string | null) => void;
  onMoveOrder: (nodeId: string, direction: -1 | 1) => void;
  onSaveOrder: () => void;
}) {
  const [search, setSearch] = useState("");
  const [collapsed, setCollapsed] = useState<Set<string>>(() => new Set());
  const [draggedId, setDraggedId] = useState<string | null>(null);

  const query = search.trim().toLocaleLowerCase("fr-FR");
  const childrenByParent = useMemo(() => {
    const map = new Map<string | null, TreeItem[]>();
    for (const node of nodes) {
      const current = map.get(node.parent_id) ?? [];
      current.push(node);
      map.set(node.parent_id, current);
    }
    for (const children of map.values()) {
      children.sort(
        (left, right) =>
          left.sort_order - right.sort_order ||
          left.title.localeCompare(right.title, "fr"),
      );
    }
    return map;
  }, [nodes]);

  const hasVisibleMatch = (
    node: TreeItem,
    visited = new Set<string>(),
  ): boolean => {
    if (!query) return true;
    if (visited.has(node.id)) return false;
    const nextVisited = new Set(visited).add(node.id);
    if (
      `${node.title} ${node.subtitle ?? ""} ${node.node_type}`
        .toLocaleLowerCase("fr-FR")
        .includes(query)
    ) {
      return true;
    }
    return (childrenByParent.get(node.id) ?? []).some((child) =>
      hasVisibleMatch(child, nextVisited),
    );
  };

  const toggle = (id: string) => {
    setCollapsed((current) => {
      const next = new Set(current);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const renderBranch = (
    parentId: string | null,
    depth = 0,
    visited = new Set<string>(),
  ): React.ReactNode[] => {
    return (childrenByParent.get(parentId) ?? []).flatMap((node) => {
      if (visited.has(node.id) || !hasVisibleMatch(node)) return [];
      const nextVisited = new Set(visited).add(node.id);
      const children = childrenByParent.get(node.id) ?? [];
      const isCollapsed = collapsed.has(node.id) && !query;
      const active = node.id === selectedId;
      const canReceiveChildren = node.node_type !== "course";

      return [
        <div key={node.id} className="group/tree relative">
          {depth > 0 && (
            <span
              className="pointer-events-none absolute bottom-0 top-0 w-px bg-[var(--outline-variant)]"
              style={{ left: depth * 18 - 7 }}
            />
          )}
          <div
            draggable
            onDragStart={(event) => {
              setDraggedId(node.id);
              event.dataTransfer.effectAllowed = "move";
              event.dataTransfer.setData("text/plain", node.id);
            }}
            onDragEnd={() => setDraggedId(null)}
            onDragOver={(event) => {
              if (!canReceiveChildren || draggedId === node.id) return;
              event.preventDefault();
              event.dataTransfer.dropEffect = "move";
            }}
            onDrop={(event) => {
              if (!canReceiveChildren) return;
              event.preventDefault();
              const source =
                draggedId || event.dataTransfer.getData("text/plain");
              if (source && source !== node.id) onMoveToParent(source, node.id);
              setDraggedId(null);
            }}
            className={`relative flex min-h-[66px] items-center gap-2 rounded-2xl border p-2.5 transition duration-200 ${
              active
                ? "border-[var(--brand)] bg-[var(--brand)]/[.09] shadow-[0_10px_28px_rgba(17,71,217,.12)]"
                : canReceiveChildren && draggedId && draggedId !== node.id
                  ? "border-dashed border-[var(--brand)]/35 bg-[var(--brand)]/[.03]"
                  : "border-[var(--outline-variant)] bg-[var(--surface)] hover:border-[var(--brand)]/25 hover:bg-[var(--surface-container)]/55"
            } ${draggedId === node.id ? "opacity-55" : ""}`}
            style={{ marginLeft: depth * 18 }}
          >
            <span
              className="cursor-grab text-[var(--on-surface-faint)] active:cursor-grabbing"
              title="Déplacer"
              aria-hidden="true"
            >
              <GripVertical size={15} />
            </span>

            {children.length > 0 ? (
              <button
                type="button"
                onClick={() => toggle(node.id)}
                className="grid h-8 w-8 shrink-0 cursor-pointer place-items-center rounded-lg text-[var(--on-surface-faint)] transition hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
                aria-label={isCollapsed ? "Déplier" : "Replier"}
                aria-expanded={!isCollapsed}
              >
                {isCollapsed ? (
                  <ChevronRight size={16} />
                ) : (
                  <ChevronDown size={16} />
                )}
              </button>
            ) : (
              <span className="w-8 shrink-0" />
            )}

            <button
              type="button"
              onClick={() => onSelect(node)}
              className="min-w-0 flex-1 cursor-pointer rounded-lg text-left focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
            >
              <div className="flex min-w-0 items-center gap-2">
                <span className="text-lg" aria-hidden="true">
                  {node.icon || "📚"}
                </span>
                <span className="min-w-0 flex-1 truncate text-sm font-semibold">
                  {node.title || "Sans titre"}
                </span>
              </div>
              <div className="mt-1 flex flex-wrap items-center gap-1.5">
                <span className="text-[10px] font-medium uppercase tracking-wide text-[var(--on-surface-faint)]">
                  {typeLabel(node.node_type)}
                </span>
                <Badge tone={node.status === "published" ? "good" : "warn"}>
                  {node.status === "published" ? "Publié" : "Brouillon"}
                </Badge>
              </div>
            </button>

            <div className="flex shrink-0 flex-col opacity-0 transition group-hover/tree:opacity-100 focus-within:opacity-100">
              <TreeMoveButton
                label="Monter"
                icon={ArrowUp}
                onClick={() => onMoveOrder(node.id, -1)}
              />
              <TreeMoveButton
                label="Descendre"
                icon={ArrowDown}
                onClick={() => onMoveOrder(node.id, 1)}
              />
            </div>
          </div>

          {!isCollapsed && renderBranch(node.id, depth + 1, nextVisited)}
        </div>,
      ];
    });
  };

  const roots = renderBranch(null);
  const orphanIds = new Set(
    nodes
      .filter(
        (node) =>
          node.parent_id &&
          !nodes.some((candidate) => candidate.id === node.parent_id),
      )
      .map((node) => node.id),
  );
  const orphanItems = nodes.filter((node) => orphanIds.has(node.id));

  return (
    <Card className="self-start overflow-hidden xl:sticky xl:top-24">
      <div className="border-b border-[var(--outline-variant)] p-4">
        <div className="flex items-start justify-between gap-3">
          <div className="flex items-center gap-3">
            <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]">
              <FolderTree size={19} />
            </span>
            <div>
              <h3 className="font-semibold">Bibliothèque</h3>
              <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
                {nodes.length} contenu{nodes.length > 1 ? "s" : ""}
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={onNew}
            className="grid h-11 w-11 shrink-0 cursor-pointer place-items-center rounded-xl bg-[var(--brand)] text-white shadow-lg shadow-blue-950/20 transition hover:brightness-110 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
            aria-label="Créer un nouveau contenu"
            title="Nouveau contenu"
          >
            <Plus size={19} />
          </button>
        </div>

        <label className="relative mt-4 block">
          <span className="sr-only">Rechercher dans l’arborescence</span>
          <Search
            size={16}
            className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-[var(--on-surface-faint)]"
          />
          <input
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Rechercher un contenu…"
            className="min-h-11 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] pl-9 pr-3 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"
          />
        </label>
      </div>

      <div className="max-h-[min(680px,calc(100vh-300px))] overflow-y-auto p-3">
        <div
          onDragOver={(event) => {
            if (!draggedId) return;
            event.preventDefault();
          }}
          onDrop={(event) => {
            event.preventDefault();
            const source =
              draggedId || event.dataTransfer.getData("text/plain");
            if (source) onMoveToParent(source, null);
            setDraggedId(null);
          }}
          className={`mb-3 flex min-h-12 items-center gap-2 rounded-xl border border-dashed px-3 text-xs font-semibold transition ${
            draggedId
              ? "border-[var(--brand)] bg-[var(--brand)]/[.06] text-[var(--brand)]"
              : "border-[var(--outline-variant)] text-[var(--on-surface-faint)]"
          }`}
        >
          <FolderInput size={16} /> Déposer ici pour placer à la racine
        </div>

        <div className="space-y-2">
          {roots}
          {orphanItems.map((node) => (
            <button
              key={node.id}
              type="button"
              onClick={() => onSelect(node)}
              className="w-full cursor-pointer rounded-xl border border-[var(--warning)]/30 bg-[var(--warning)]/5 p-3 text-left text-sm"
            >
              {node.icon || "📚"} {node.title} · parent introuvable
            </button>
          ))}
        </div>

        {nodes.length === 0 && (
          <div className="px-4 py-10 text-center">
            <FolderTree size={28} className="mx-auto text-[var(--brand)]" />
            <h4 className="mt-3 text-sm font-semibold">
              Ta bibliothèque est vide
            </h4>
            <p className="mt-1 text-xs leading-5 text-[var(--on-surface-muted)]">
              Commence par créer une catégorie racine.
            </p>
          </div>
        )}

        {nodes.length > 0 && roots.length === 0 && query && (
          <div className="px-4 py-10 text-center text-sm text-[var(--on-surface-muted)]">
            Aucun contenu ne correspond à « {search.trim()} ».
          </div>
        )}
      </div>

      {pendingCount > 0 && (
        <div className="border-t border-[var(--outline-variant)] bg-[var(--brand)]/[.045] p-3">
          <div className="mb-2 flex items-center gap-2 text-xs font-medium text-[var(--brand)]">
            <Check size={15} /> {pendingCount} modification
            {pendingCount > 1 ? "s" : ""} d’organisation prête
            {pendingCount > 1 ? "s" : ""}
          </div>
          <Button className="w-full" disabled={busy} onClick={onSaveOrder}>
            <Save size={16} className="mr-2 inline" /> Enregistrer
            l’organisation
          </Button>
        </div>
      )}
    </Card>
  );
}

function TreeMoveButton({
  label,
  icon: Icon,
  onClick,
}: {
  label: string;
  icon: typeof ArrowUp;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="grid h-7 w-7 cursor-pointer place-items-center rounded-md text-[var(--on-surface-faint)] transition hover:bg-[var(--surface-container-hi)] hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
      aria-label={label}
      title={label}
    >
      <Icon size={13} />
    </button>
  );
}

function typeLabel(type: ActiveContentNode["node_type"]) {
  if (type === "category") return "Catégorie";
  if (type === "subcategory") return "Sous-catégorie";
  return "Cours";
}
