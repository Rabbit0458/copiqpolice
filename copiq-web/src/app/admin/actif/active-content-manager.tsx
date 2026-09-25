"use client";

import { useEffect, useMemo, useState } from "react";
import {
  AlertTriangle,
  Archive,
  ArrowLeft,
  ArrowRight,
  CheckCircle2,
  CloudOff,
  Crown,
  Eye,
  EyeOff,
  FileCheck2,
  FolderTree,
  MonitorSmartphone,
  PanelRightClose,
  Save,
  Send,
  ShieldCheck,
  Sparkles,
  X,
} from "lucide-react";
import {
  activeContentAdminApi,
  type ActiveContentBlock,
  type ActiveContentNode,
  type ActiveNodeType,
} from "@/lib/admin/api";
import {
  Badge,
  Button,
  Card,
  ErrorBox,
  Loading,
  useAsync,
} from "@/components/admin/admin-ui";
import {
  ActiveStudioStepper,
  BlocksEditor,
  ContentTypeStep,
  DetailsStep,
  NonCourseContentStep,
  ReviewStep,
  TemplateStep,
  inspectImageUrl,
  studioSteps,
  type ActiveDraft,
  type ReadinessItem,
  type StudioStep,
} from "./active-content-editor";
import { ActivePhonePreview } from "./active-content-preview";
import {
  blocksFromTemplate,
  type ActiveCourseTemplateId,
} from "./active-content-templates";
import { ActiveContentTree } from "./active-content-tree";

type TreePatch = Pick<ActiveContentNode, "parent_id" | "sort_order">;

const emptyNode = (nodeType: ActiveNodeType = "category"): ActiveDraft => ({
  node_type: nodeType,
  title: "",
  parent_id: null,
  subtitle: "",
  image_url: "",
  icon: nodeType === "course" ? "📖" : "📚",
  sort_order: 0,
  draft_content: [],
  status: "draft",
});

const cloneNode = (node: ActiveDraft): ActiveDraft => ({
  ...node,
  draft_content: (node.draft_content ?? []).map((block) => ({ ...block })),
  published_content:
    node.published_content?.map((block) => ({ ...block })) ?? null,
});

const editableSignature = (node: ActiveDraft) =>
  JSON.stringify({
    parent_id: node.parent_id ?? null,
    node_type: node.node_type,
    title: node.title,
    subtitle: node.subtitle ?? null,
    image_url: node.image_url ?? null,
    icon: node.icon ?? null,
    sort_order: node.sort_order ?? 0,
    draft_content: node.draft_content ?? [],
  });

export function ActiveContentManager() {
  const state = useAsync(() => activeContentAdminApi.state(), []);
  const gradePicker = useAsync(
    () => activeContentAdminApi.gradePickerState(),
    [],
  );
  const initialDraft = useMemo(() => emptyNode(), []);
  const [draft, setDraft] = useState<ActiveDraft>(initialDraft);
  const [baseline, setBaseline] = useState<ActiveDraft>(initialDraft);
  const [step, setStep] = useState<StudioStep>("type");
  const [selectedTemplate, setSelectedTemplate] =
    useState<ActiveCourseTemplateId | null>(null);
  const [treePatches, setTreePatches] = useState<Record<string, TreePatch>>({});
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [publishOpen, setPublishOpen] = useState(false);
  const [archiveOpen, setArchiveOpen] = useState(false);
  const [libraryOpen, setLibraryOpen] = useState(false);
  const [previewOpen, setPreviewOpen] = useState(false);
  const [previewDocked, setPreviewDocked] = useState(true);

  const nodes = useMemo(() => state.data?.nodes ?? [], [state.data?.nodes]);
  const validTreePatches = useMemo(() => {
    const validIds = new Set(nodes.map((node) => node.id));
    return Object.fromEntries(
      Object.entries(treePatches).filter(([id]) => validIds.has(id)),
    );
  }, [nodes, treePatches]);
  const effectiveNodes = useMemo(
    () =>
      nodes.map((node) => ({
        ...node,
        ...(validTreePatches[node.id] ?? {}),
      })),
    [nodes, validTreePatches],
  );
  const dirty = editableSignature(draft) !== editableSignature(baseline);

  useEffect(() => {
    if (!dirty) return;
    const warn = (event: BeforeUnloadEvent) => event.preventDefault();
    window.addEventListener("beforeunload", warn);
    return () => window.removeEventListener("beforeunload", warn);
  }, [dirty]);

  const descendants = useMemo(() => {
    if (!draft.id) return new Set<string>();
    const found = new Set<string>();
    const visit = (parentId: string) => {
      effectiveNodes
        .filter((node) => node.parent_id === parentId && !found.has(node.id))
        .forEach((node) => {
          found.add(node.id);
          visit(node.id);
        });
    };
    visit(draft.id);
    return found;
  }, [draft.id, effectiveNodes]);

  const parents = useMemo(
    () =>
      effectiveNodes.filter(
        (node) =>
          node.node_type !== "course" &&
          node.id !== draft.id &&
          !descendants.has(node.id),
      ),
    [descendants, draft.id, effectiveNodes],
  );

  const readiness = useMemo<ReadinessItem[]>(() => {
    const image = inspectImageUrl(draft.image_url);
    const blocks = draft.draft_content ?? [];
    const requiresParent = draft.node_type !== "category";
    return [
      {
        label: "Titre renseigné",
        detail: draft.title.trim()
          ? "Le contenu possède un titre visible et compréhensible."
          : "Ajoute un titre avant de pouvoir publier.",
        ok: Boolean(draft.title.trim()),
        blocking: true,
      },
      {
        label: "Emplacement dans la bibliothèque",
        detail:
          !requiresParent || draft.parent_id
            ? "Le contenu est rangé dans l’arborescence."
            : "Ce contenu est à la racine. Tu peux lui choisir un parent pour une navigation plus claire.",
        ok: !requiresParent || Boolean(draft.parent_id),
      },
      {
        label: "Image publique et durable",
        detail:
          image.kind === "empty"
            ? "L’image est facultative, mais recommandée pour enrichir la carte."
            : image.kind === "invalid"
              ? image.message
              : image.publicSupabase
                ? "L’URL publique Supabase est reconnue."
                : "L’URL est valide, mais vérifie qu’elle restera disponible durablement.",
        ok: image.kind === "valid",
        blocking: image.kind === "invalid",
      },
      {
        label: "Composition du cours",
        detail:
          draft.node_type !== "course"
            ? "Aucun bloc pédagogique n’est nécessaire pour ce type de contenu."
            : blocks.length > 0
              ? `${blocks.length} bloc${blocks.length > 1 ? "s" : ""} prêt${blocks.length > 1 ? "s" : ""} à être affiché${blocks.length > 1 ? "s" : ""}.`
              : "Ajoute au moins un bloc de contenu au cours.",
        ok: draft.node_type !== "course" || blocks.length > 0,
        blocking: draft.node_type === "course",
      },
      {
        label: "Brouillon enregistré",
        detail:
          draft.id && !dirty
            ? "La version vérifiée correspond à celle enregistrée sur le serveur."
            : "Enregistre le brouillon avant de lancer la publication.",
        ok: Boolean(draft.id && !dirty),
        blocking: true,
      },
    ];
  }, [draft, dirty]);

  const canPublish = readiness.every((item) => !item.blocking || item.ok);
  const confirmDiscard = () =>
    !dirty ||
    window.confirm(
      "Des modifications ne sont pas enregistrées. Veux-tu vraiment les abandonner ?",
    );

  const selectNode = (node: ActiveContentNode) => {
    if (!confirmDiscard()) return false;
    const next = cloneNode(node);
    setDraft(next);
    setBaseline(cloneNode(next));
    setSelectedTemplate(null);
    setStep("details");
    setNotice(null);
    setError(null);
    return true;
  };

  const beginNew = () => {
    if (!confirmDiscard()) return false;
    const next = emptyNode();
    setDraft(next);
    setBaseline(cloneNode(next));
    setSelectedTemplate(null);
    setStep("type");
    setNotice(null);
    setError(null);
    return true;
  };

  const chooseType = (nodeType: ActiveNodeType) => {
    const next = emptyNode(nodeType);
    setDraft(next);
    setBaseline(emptyNode());
    setSelectedTemplate(null);
    setStep(nodeType === "course" ? "template" : "details");
  };

  const chooseTemplate = (template: ActiveCourseTemplateId) => {
    setSelectedTemplate(template);
    setDraft((current) => ({
      ...current,
      draft_content: blocksFromTemplate(template) as ActiveContentBlock[],
    }));
    setStep("details");
  };

  const skipTemplate = () => {
    setSelectedTemplate(null);
    setDraft((current) => ({
      ...current,
      draft_content:
        current.node_type === "course" ? [] : current.draft_content,
    }));
    setStep("details");
  };

  const saveDraft = async () => {
    if (!draft.title.trim()) {
      setError(
        new Error("Le titre est obligatoire pour enregistrer ce brouillon."),
      );
      setStep("details");
      return;
    }
    setBusy(true);
    setError(null);
    setNotice(null);
    try {
      const saved = await activeContentAdminApi.save({
        ...draft,
        title: draft.title.trim(),
        subtitle: draft.subtitle?.trim() || null,
        image_url: draft.image_url?.trim() || null,
      });
      const next = cloneNode(saved);
      setDraft(next);
      setBaseline(cloneNode(next));
      setNotice(
        "Brouillon enregistré. Rien n’a été publié dans l’application.",
      );
      await state.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(false);
    }
  };

  const publish = async () => {
    if (!draft.id || !canPublish) return;
    setBusy(true);
    setError(null);
    setNotice(null);
    try {
      const published = await activeContentAdminApi.publish(draft.id);
      const next = cloneNode(published);
      setDraft(next);
      setBaseline(cloneNode(next));
      setPublishOpen(false);
      setNotice(
        `« ${published.title} » est maintenant publié dans l’application.`,
      );
      await state.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(false);
    }
  };

  const archive = async () => {
    if (!draft.id) return;
    setBusy(true);
    setError(null);
    try {
      await activeContentAdminApi.archive(draft.id, draft.title);
      setArchiveOpen(false);
      const next = emptyNode();
      setDraft(next);
      setBaseline(cloneNode(next));
      setStep("type");
      setNotice(
        "Le contenu a été archivé et retiré de la bibliothèque active.",
      );
      await state.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(false);
    }
  };

  const toggleModule = async () => {
    const enabled = !state.data?.config.enabled;
    setBusy(true);
    setError(null);
    setNotice(null);
    try {
      await activeContentAdminApi.setEnabled(enabled);
      setNotice(
        enabled
          ? "Le module est maintenant visible dans l’application."
          : "Le module est masqué. Les sessions actives seront fermées selon le délai prévu.",
      );
      await state.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(false);
    }
  };

  const toggleOwnerPreview = async () => {
    const enabled = !state.data?.config.owner_preview_enabled;
    setBusy(true);
    setError(null);
    setNotice(null);
    try {
      await activeContentAdminApi.setOwnerPreview(enabled);
      setNotice(
        enabled
          ? "L’aperçu privé est actif. Le module est désormais visible uniquement sur ton compte owner tant que sa publication publique reste désactivée."
          : "L’aperçu privé est désactivé. Ton compte suit de nouveau exactement la visibilité publique.",
      );
      await state.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(false);
    }
  };

  const toggleReserveVisibility = async () => {
    const enabled = !gradePicker.data?.reserve_enabled;
    setBusy(true);
    setError(null);
    setNotice(null);
    try {
      await activeContentAdminApi.setReserveVisibility(enabled);
      setNotice(
        enabled
          ? "La carte Réserviste est maintenant visible dans le sélecteur de grade. Elle reste verrouillée tant que le parcours n’est pas prêt."
          : "La carte Réserviste est masquée dans tous les parcours de l’application.",
      );
      await gradePicker.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(false);
    }
  };

  const stageMoveToParent = (nodeId: string, parentId: string | null) => {
    const node = effectiveNodes.find((item) => item.id === nodeId);
    const parent = parentId
      ? effectiveNodes.find((item) => item.id === parentId)
      : null;
    if (!node || (parentId && (!parent || parent.node_type === "course")))
      return;
    if (parentId === nodeId || createsCycle(effectiveNodes, nodeId, parentId)) {
      setError(
        new Error("Ce déplacement créerait une boucle dans l’arborescence."),
      );
      return;
    }
    const siblings = effectiveNodes.filter(
      (item) => item.parent_id === parentId && item.id !== nodeId,
    );
    const sortOrder = siblings.length
      ? Math.max(...siblings.map((item) => item.sort_order)) + 1
      : 0;
    setTreePatches((current) => ({
      ...current,
      [nodeId]: { parent_id: parentId, sort_order: sortOrder },
    }));
    setError(null);
  };

  const stageMoveOrder = (nodeId: string, direction: -1 | 1) => {
    const node = effectiveNodes.find((item) => item.id === nodeId);
    if (!node) return;
    const siblings = effectiveNodes
      .filter((item) => item.parent_id === node.parent_id)
      .sort(
        (left, right) =>
          left.sort_order - right.sort_order ||
          left.title.localeCompare(right.title, "fr"),
      );
    const from = siblings.findIndex((item) => item.id === nodeId);
    const to = from + direction;
    if (from < 0 || to < 0 || to >= siblings.length) return;
    const reordered = [...siblings];
    const [moved] = reordered.splice(from, 1);
    reordered.splice(to, 0, moved);
    setTreePatches((current) => {
      const next = { ...current };
      reordered.forEach((item, index) => {
        next[item.id] = { parent_id: item.parent_id, sort_order: index };
      });
      return next;
    });
  };

  const saveTreeOrder = async () => {
    const entries = Object.entries(validTreePatches);
    if (!entries.length) return;
    setBusy(true);
    setError(null);
    setNotice(null);
    try {
      for (const [id, patch] of entries) {
        const original = nodes.find((node) => node.id === id);
        if (original)
          await activeContentAdminApi.save({ ...original, ...patch });
      }
      const selectedPatch = draft.id ? validTreePatches[draft.id] : undefined;
      if (selectedPatch) {
        setDraft((current) => ({ ...current, ...selectedPatch }));
        setBaseline((current) => ({ ...current, ...selectedPatch }));
      }
      setTreePatches({});
      setNotice("La nouvelle organisation de la bibliothèque est enregistrée.");
      await state.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(false);
    }
  };

  const visibleSteps =
    draft.node_type === "course"
      ? studioSteps
      : studioSteps.filter((item) => item.id !== "template");
  const currentIndex = visibleSteps.findIndex((item) => item.id === step);
  const goPrevious = () => {
    const previous = visibleSteps[currentIndex - 1];
    if (previous) setStep(previous.id);
  };
  const goNext = () => {
    if (step === "details" && !draft.title.trim()) {
      setError(new Error("Ajoute un titre pour continuer."));
      return;
    }
    const next = visibleSteps[currentIndex + 1];
    if (next) setStep(next.id);
    setError(null);
  };

  const immersiveStep = step === "type" || step === "template";
  const showDockedPreview = !immersiveStep && previewDocked;
  const treePanel = (
    <ActiveContentTree
      nodes={effectiveNodes}
      selectedId={draft.id}
      pendingCount={Object.keys(validTreePatches).length}
      busy={busy}
      onSelect={(node) => {
        if (selectNode(node)) setLibraryOpen(false);
      }}
      onNew={() => {
        if (beginNew()) setLibraryOpen(false);
      }}
      onMoveToParent={stageMoveToParent}
      onMoveOrder={stageMoveOrder}
      onSaveOrder={saveTreeOrder}
    />
  );

  if (state.loading) {
    return (
      <Card className="mb-8">
        <Loading label="Préparation du studio de contenus…" />
      </Card>
    );
  }

  return (
    <section className="mb-10 space-y-4" aria-label="Studio du module actif">
      <Card className="relative overflow-hidden p-5 md:p-6">
        <div className="pointer-events-none absolute -right-16 -top-24 h-64 w-64 rounded-full bg-[var(--brand)]/12 blur-3xl" />
        <div className="relative flex flex-wrap items-center justify-between gap-5">
          <div className="flex items-start gap-4">
            <span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-[var(--brand)]/10 text-[var(--brand)]">
              <ShieldCheck size={23} />
            </span>
            <div>
              <div className="flex flex-wrap items-center gap-2">
                <h2 className="text-lg font-semibold">Publication du module</h2>
                <Badge tone={state.data?.config.enabled ? "good" : "neutral"}>
                  {state.data?.config.enabled ? "Visible" : "Masqué"}
                </Badge>
              </div>
              <p className="mt-1 max-w-2xl text-sm leading-6 text-[var(--on-surface-muted)]">
                Le studio modifie uniquement les contenus du module actif. La
                synchronisation existante avec l’application reste inchangée.
              </p>
            </div>
          </div>
          <Button
            variant={state.data?.config.enabled ? "danger" : "primary"}
            disabled={busy}
            onClick={toggleModule}
          >
            {state.data?.config.enabled ? (
              <EyeOff size={16} className="mr-2 inline" />
            ) : (
              <Eye size={16} className="mr-2 inline" />
            )}
            {state.data?.config.enabled
              ? "Masquer le module"
              : "Rendre visible"}
          </Button>
        </div>
        <div className="relative mt-5 flex flex-wrap items-center justify-between gap-4 border-t border-[var(--outline-variant)] pt-5">
          <div className="flex min-w-0 items-start gap-3">
            <span className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-amber-400/10 text-amber-400">
              <Crown size={21} />
            </span>
            <div className="min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="text-sm font-semibold">
                  Aperçu privé propriétaire
                </h3>
                <Badge
                  tone={
                    state.data?.config.owner_preview_enabled
                      ? "warn"
                      : "neutral"
                  }
                >
                  {state.data?.config.owner_preview_enabled
                    ? "Actif pour Kaïs"
                    : "Désactivé"}
                </Badge>
              </div>
              <p className="mt-1 max-w-2xl text-xs leading-5 text-[var(--on-surface-muted)]">
                Permet à <strong>kaisouartani@gmail.com</strong> de tester le
                module sur son téléphone sans l’ouvrir aux autres utilisateurs.
                L’interrupteur public ci-dessus reste totalement indépendant.
              </p>
            </div>
          </div>
          <Button
            variant={
              state.data?.config.owner_preview_enabled ? "ghost" : "primary"
            }
            disabled={busy}
            onClick={toggleOwnerPreview}
          >
            <Crown size={16} className="mr-2 inline" />
            {state.data?.config.owner_preview_enabled
              ? "Désactiver mon aperçu"
              : "Afficher sur mon compte"}
          </Button>
        </div>
        <div className="relative mt-5 flex flex-wrap items-center justify-between gap-4 border-t border-[var(--outline-variant)] pt-5">
          <div className="flex min-w-0 items-start gap-3">
            <span className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-sky-400/10 text-sky-400">
              <MonitorSmartphone size={21} />
            </span>
            <div className="min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="text-sm font-semibold">Parcours Réserviste</h3>
                <Badge tone={gradePicker.data?.reserve_enabled ? "warn" : "neutral"}>
                  {gradePicker.data?.reserve_enabled ? "Carte visible" : "Carte masquée"}
                </Badge>
              </div>
              <p className="mt-1 max-w-2xl text-xs leading-5 text-[var(--on-surface-muted)]">
                Contrôle la présence de la carte dans le choix du grade, pour la scolarité comme pour la préparation aux concours. La carte est masquée par défaut et se rafraîchit automatiquement dans l’application.
              </p>
            </div>
          </div>
          <Button
            variant={gradePicker.data?.reserve_enabled ? "ghost" : "primary"}
            disabled={busy || gradePicker.loading}
            onClick={toggleReserveVisibility}
          >
            {gradePicker.data?.reserve_enabled ? (
              <EyeOff size={16} className="mr-2 inline" />
            ) : (
              <Eye size={16} className="mr-2 inline" />
            )}
            {gradePicker.data?.reserve_enabled ? "Masquer la carte" : "Afficher la carte"}
          </Button>
        </div>
      </Card>

      {state.error != null && <ErrorBox error={state.error} />}
      {error != null && <ErrorBox error={error} />}
      {notice && (
        <Card className="border-[var(--success)]/25 bg-[var(--success)]/[.055] p-4">
          <div className="flex items-start gap-3 text-sm text-[var(--success)]">
            <CheckCircle2 size={19} className="mt-0.5 shrink-0" />
            <p className="font-medium leading-6">{notice}</p>
          </div>
        </Card>
      )}
      {dirty && (
        <Card className="border-[var(--warning)]/25 bg-[var(--warning)]/[.055] p-4">
          <div className="flex flex-wrap items-center justify-between gap-3">
            <div className="flex items-start gap-3 text-sm">
              <CloudOff
                size={19}
                className="mt-0.5 shrink-0 text-[var(--warning)]"
              />
              <div>
                <p className="font-semibold">Modifications non enregistrées</p>
                <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
                  Elles restent dans ce navigateur et ne sont pas encore
                  envoyées au serveur.
                </p>
              </div>
            </div>
            <Button disabled={busy || !draft.title.trim()} onClick={saveDraft}>
              <Save size={16} className="mr-2 inline" /> Enregistrer le
              brouillon
            </Button>
          </div>
        </Card>
      )}

      <div
        className={`grid items-start gap-5 ${showDockedPreview ? "2xl:grid-cols-[minmax(0,1fr)_410px]" : ""}`}
      >
        <Card className="relative min-w-0 overflow-hidden shadow-[0_22px_70px_rgba(2,8,23,.08)]">
          {immersiveStep && (
            <div className="pointer-events-none absolute inset-x-0 top-0 h-56 bg-[radial-gradient(circle_at_50%_0%,rgba(17,71,217,.12),transparent_72%)]" />
          )}
          <div className="flex flex-wrap items-center justify-between gap-3 border-b border-[var(--outline-variant)] px-4 py-3.5 md:px-5">
            <div className="min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <span className="text-sm font-semibold">
                  {draft.id
                    ? draft.title || "Contenu sans titre"
                    : "Nouveau contenu"}
                </span>
                <Badge tone={draft.status === "published" ? "good" : "warn"}>
                  {draft.status === "published" ? "Publié" : "Brouillon"}
                </Badge>
                {dirty && <Badge tone="warn">Non enregistré</Badge>}
              </div>
              <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
                Assistant de création COP’IQ · sauvegarde et publication
                séparées
              </p>
            </div>
            <div className="relative flex flex-wrap items-center justify-end gap-2">
              <Button variant="ghost" onClick={() => setLibraryOpen(true)}>
                <FolderTree size={16} className="mr-2 inline" /> Bibliothèque
                <span className="ml-2 rounded-full bg-[var(--brand)]/10 px-1.5 py-0.5 text-[10px] text-[var(--brand)]">
                  {nodes.length}
                </span>
                {Object.keys(validTreePatches).length > 0 && (
                  <span className="ml-1 h-2 w-2 rounded-full bg-[var(--warning)]" />
                )}
              </Button>
              <Button
                variant="ghost"
                onClick={() => setPreviewOpen(true)}
                className={showDockedPreview ? "2xl:hidden" : ""}
              >
                <MonitorSmartphone size={16} className="mr-2 inline" /> Aperçu
              </Button>
              {!immersiveStep && (
                <Button
                  variant="ghost"
                  onClick={() => setPreviewDocked((current) => !current)}
                  className="hidden 2xl:inline-flex"
                >
                  {previewDocked ? (
                    <PanelRightClose size={16} className="mr-2" />
                  ) : (
                    <MonitorSmartphone size={16} className="mr-2" />
                  )}
                  {previewDocked ? "Masquer l’aperçu" : "Afficher l’aperçu"}
                </Button>
              )}
              <button
                type="button"
                onClick={beginNew}
                className="min-h-10 cursor-pointer rounded-xl px-3 text-xs font-semibold text-[var(--brand)] transition hover:bg-[var(--brand)]/10 focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
              >
                <Sparkles size={14} className="mr-1.5 inline" /> Recommencer
              </button>
            </div>
          </div>

          <div className="relative">
            <ActiveStudioStepper
              current={step}
              nodeType={draft.node_type}
              onChange={setStep}
            />
          </div>
          <div className="relative border-t border-[var(--outline-variant)]">
            {step === "type" && (
              <ContentTypeStep value={draft.node_type} onChoose={chooseType} />
            )}
            {step === "template" && (
              <TemplateStep
                nodeType={draft.node_type}
                selected={selectedTemplate}
                onChoose={chooseTemplate}
                onSkip={skipTemplate}
              />
            )}
            {step === "details" && (
              <DetailsStep
                draft={draft}
                parents={parents}
                onChange={(patch) =>
                  setDraft((current) => ({ ...current, ...patch }))
                }
              />
            )}
            {step === "content" &&
              (draft.node_type === "course" ? (
                <BlocksEditor
                  blocks={draft.draft_content ?? []}
                  onChange={(blocks) =>
                    setDraft((current) => ({
                      ...current,
                      draft_content: blocks,
                    }))
                  }
                />
              ) : (
                <NonCourseContentStep
                  nodeType={draft.node_type}
                  onContinue={() => setStep("review")}
                />
              ))}
            {step === "review" && (
              <ReviewStep draft={draft} dirty={dirty} readiness={readiness} />
            )}
          </div>

          <div className="sticky bottom-0 z-10 flex flex-wrap items-center justify-between gap-3 border-t border-[var(--outline-variant)] bg-[var(--surface)]/95 px-4 py-3.5 backdrop-blur-xl md:px-5">
            <div className="flex gap-2">
              <Button
                variant="ghost"
                disabled={currentIndex <= 0}
                onClick={goPrevious}
              >
                <ArrowLeft size={16} className="mr-2 inline" /> Précédent
              </Button>
              {draft.id && (
                <Button
                  variant="danger"
                  disabled={busy}
                  onClick={() => setArchiveOpen(true)}
                  aria-label="Archiver ce contenu"
                  title="Archiver ce contenu"
                  className="px-3"
                >
                  <Archive size={16} />
                </Button>
              )}
            </div>
            <div className="flex flex-wrap justify-end gap-2">
              <Button
                variant="ghost"
                disabled={busy || !draft.title.trim() || !dirty}
                onClick={saveDraft}
              >
                <Save size={16} className="mr-2 inline" /> Enregistrer
              </Button>
              {step !== "review" ? (
                <Button
                  disabled={step === "details" && !draft.title.trim()}
                  onClick={goNext}
                >
                  Continuer <ArrowRight size={16} className="ml-2 inline" />
                </Button>
              ) : (
                <Button
                  disabled={busy || !canPublish}
                  onClick={() => setPublishOpen(true)}
                >
                  <Send size={16} className="mr-2 inline" /> Vérifier et publier
                </Button>
              )}
            </div>
          </div>
        </Card>

        {showDockedPreview && (
          <div className="hidden 2xl:block">
            <ActivePhonePreview node={draft} />
          </div>
        )}
      </div>

      {libraryOpen && (
        <StudioDrawer
          side="left"
          label="Bibliothèque des contenus"
          onClose={() => setLibraryOpen(false)}
        >
          {treePanel}
        </StudioDrawer>
      )}
      {previewOpen && (
        <StudioDrawer
          side="right"
          label="Aperçu dans l’application"
          onClose={() => setPreviewOpen(false)}
          wide
        >
          <ActivePhonePreview node={draft} />
        </StudioDrawer>
      )}

      {publishOpen && (
        <PublishDialog
          title={draft.title}
          readiness={readiness}
          busy={busy}
          onClose={() => setPublishOpen(false)}
          onConfirm={publish}
        />
      )}
      {archiveOpen && (
        <ArchiveDialog
          title={draft.title}
          busy={busy}
          onClose={() => setArchiveOpen(false)}
          onConfirm={archive}
        />
      )}
    </section>
  );
}

function PublishDialog({
  title,
  readiness,
  busy,
  onClose,
  onConfirm,
}: {
  title: string;
  readiness: ReadinessItem[];
  busy: boolean;
  onClose: () => void;
  onConfirm: () => void;
}) {
  return (
    <DialogShell onClose={onClose} label="Vérification avant publication">
      <span className="grid h-13 w-13 place-items-center rounded-2xl bg-[var(--brand)]/10 text-[var(--brand)]">
        <FileCheck2 size={25} />
      </span>
      <h2 className="mt-5 text-2xl font-semibold tracking-[-.03em]">
        Publier « {title} » ?
      </h2>
      <p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">
        Cette action rendra la version enregistrée disponible dans l’application
        sans nécessiter son redémarrage.
      </p>
      <div className="mt-5 space-y-2">
        {readiness.map((item) => (
          <div
            key={item.label}
            className="flex items-center gap-2 rounded-xl bg-[var(--surface-container)] px-3 py-2.5 text-xs"
          >
            {item.ok ? (
              <CheckCircle2
                size={16}
                className="shrink-0 text-[var(--success)]"
              />
            ) : (
              <AlertTriangle
                size={16}
                className="shrink-0 text-[var(--warning)]"
              />
            )}
            <span className="font-medium">{item.label}</span>
          </div>
        ))}
      </div>
      <div className="mt-6 flex justify-end gap-2">
        <Button variant="ghost" disabled={busy} onClick={onClose}>
          Retour
        </Button>
        <Button disabled={busy} onClick={onConfirm}>
          <Send size={16} className="mr-2 inline" /> Publier maintenant
        </Button>
      </div>
    </DialogShell>
  );
}

function ArchiveDialog({
  title,
  busy,
  onClose,
  onConfirm,
}: {
  title: string;
  busy: boolean;
  onClose: () => void;
  onConfirm: () => void;
}) {
  const [confirmation, setConfirmation] = useState("");
  return (
    <DialogShell onClose={onClose} label="Archiver le contenu">
      <span className="grid h-13 w-13 place-items-center rounded-2xl bg-[var(--danger)]/10 text-[var(--danger)]">
        <Archive size={25} />
      </span>
      <h2 className="mt-5 text-2xl font-semibold tracking-[-.03em]">
        Archiver ce contenu ?
      </h2>
      <p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">
        Il sera retiré de la bibliothèque active. Saisis exactement son titre
        pour confirmer :{" "}
        <strong className="text-[var(--on-surface)]">{title}</strong>
      </p>
      <input
        value={confirmation}
        onChange={(event) => setConfirmation(event.target.value)}
        className="mt-5 min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] px-3.5 text-sm outline-none transition focus:border-[var(--danger)] focus:ring-4 focus:ring-[var(--danger)]/10"
        placeholder={title}
        autoFocus
      />
      <div className="mt-6 flex justify-end gap-2">
        <Button variant="ghost" disabled={busy} onClick={onClose}>
          Annuler
        </Button>
        <Button
          variant="danger"
          disabled={busy || confirmation !== title}
          onClick={onConfirm}
        >
          <Archive size={16} className="mr-2 inline" /> Archiver
        </Button>
      </div>
    </DialogShell>
  );
}

function DialogShell({
  children,
  onClose,
  label,
}: {
  children: React.ReactNode;
  onClose: () => void;
  label: string;
}) {
  return (
    <div
      className="fixed inset-0 z-[70] grid place-items-center bg-slate-950/70 p-4 backdrop-blur-sm"
      role="dialog"
      aria-modal="true"
      aria-label={label}
    >
      <button
        type="button"
        className="absolute inset-0 cursor-default"
        onClick={onClose}
        aria-label="Fermer"
      />
      <Card className="relative w-full max-w-lg p-6 shadow-2xl md:p-7">
        <button
          type="button"
          onClick={onClose}
          className="absolute right-4 top-4 grid h-10 w-10 cursor-pointer place-items-center rounded-xl text-[var(--on-surface-faint)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
          aria-label="Fermer"
        >
          <X size={18} />
        </button>
        {children}
      </Card>
    </div>
  );
}

function StudioDrawer({
  children,
  side,
  label,
  onClose,
  wide = false,
}: {
  children: React.ReactNode;
  side: "left" | "right";
  label: string;
  onClose: () => void;
  wide?: boolean;
}) {
  useEffect(() => {
    const previousOverflow = document.body.style.overflow;
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") onClose();
    };
    document.body.style.overflow = "hidden";
    window.addEventListener("keydown", closeOnEscape);
    return () => {
      document.body.style.overflow = previousOverflow;
      window.removeEventListener("keydown", closeOnEscape);
    };
  }, [onClose]);

  return (
    <div className="fixed inset-0 z-[65] flex bg-slate-950/65 backdrop-blur-sm">
      <button
        type="button"
        className="absolute inset-0 cursor-default"
        onClick={onClose}
        aria-label={`Fermer : ${label}`}
      />
      <aside
        role="dialog"
        aria-modal="true"
        aria-label={label}
        className={`relative h-full w-[calc(100%-1rem)] overflow-y-auto bg-[var(--surface)] p-4 shadow-2xl motion-safe:animate-in motion-safe:duration-200 sm:p-5 ${
          wide ? "max-w-[540px]" : "max-w-[440px]"
        } ${
          side === "left"
            ? "mr-auto motion-safe:slide-in-from-left"
            : "ml-auto motion-safe:slide-in-from-right"
        }`}
      >
        <div className="sticky top-0 z-20 mb-4 flex min-h-14 items-center justify-between gap-3 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)]/95 px-4 py-2.5 shadow-sm backdrop-blur-xl">
          <div className="min-w-0">
            <p className="text-[10px] font-semibold uppercase tracking-[.16em] text-[var(--brand)]">
              Outil du studio
            </p>
            <h2 className="truncate text-sm font-semibold">{label}</h2>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="grid h-10 w-10 shrink-0 cursor-pointer place-items-center rounded-xl bg-[var(--surface-container)] text-[var(--on-surface-muted)] transition hover:bg-[var(--brand)]/10 hover:text-[var(--brand)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
            aria-label="Fermer"
          >
            <X size={18} />
          </button>
        </div>
        {children}
      </aside>
    </div>
  );
}

function createsCycle(
  nodes: ActiveContentNode[],
  nodeId: string,
  parentId: string | null,
) {
  let current = parentId;
  const visited = new Set<string>();
  while (current) {
    if (current === nodeId || visited.has(current)) return true;
    visited.add(current);
    current = nodes.find((node) => node.id === current)?.parent_id ?? null;
  }
  return false;
}
