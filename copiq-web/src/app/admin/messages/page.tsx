"use client";

import { useEffect, useState } from "react";
import {
  ArrowRight,
  CheckCircle2,
  Clock3,
  Eye,
  Info,
  Mail,
  MailCheck,
  Megaphone,
  Search,
  Send,
  ShieldCheck,
  Sparkles,
  TriangleAlert,
  UserRound,
  UsersRound,
  X,
} from "lucide-react";
import toast from "react-hot-toast";
import {
  contactEmailAdminApi,
  type AdminEmailAudienceKind,
  type AdminEmailCampaign,
  type AdminEmailCampaignType,
  type AdminEmailUserResult,
} from "@/lib/admin/api";
import {
  Badge,
  Button,
  Card,
  ErrorBox,
  Loading,
  PageHeader,
  useAsync,
} from "@/components/admin/admin-ui";

type FormState = {
  campaign_type: AdminEmailCampaignType;
  audience_kind: AdminEmailAudienceKind;
  target_user_id: string | null;
  subject: string;
  headline: string;
  body_text: string;
  cta_label: string;
  cta_url: string;
};

const DEFAULT_FORM: FormState = {
  campaign_type: "product_update",
  audience_kind: "all",
  target_user_id: null,
  subject: "COP’IQ évolue : découvrez la nouvelle mise à jour",
  headline: "Une nouvelle version de COP’IQ est disponible",
  body_text:
    "Nous avons amélioré l’application pour rendre votre préparation plus fluide, plus claire et plus agréable.\n\nMettez COP’IQ à jour depuis votre boutique d’applications pour profiter de toutes les nouveautés.",
  cta_label: "Découvrir la mise à jour",
  cta_url: "https://copiq.fr",
};

const TYPE_OPTIONS: {
  value: AdminEmailCampaignType;
  title: string;
  description: string;
  icon: typeof Sparkles;
}[] = [
  {
    value: "product_update",
    title: "Mise à jour",
    description: "Informer d’une nouvelle version ou fonctionnalité.",
    icon: Sparkles,
  },
  {
    value: "service_information",
    title: "Information de service",
    description: "Maintenance, disponibilité ou information importante.",
    icon: Info,
  },
  {
    value: "individual_message",
    title: "Message individuel",
    description: "Contacter personnellement un seul utilisateur.",
    icon: UserRound,
  },
];

const inputClass =
  "min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] px-3.5 py-2.5 text-sm outline-none transition duration-200 placeholder:text-[var(--on-surface-faint)] focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10";

export default function MessagesAdminPage() {
  const overview = useAsync(() => contactEmailAdminApi.overview(), []);
  const [form, setForm] = useState<FormState>(DEFAULT_FORM);
  const [selectedUser, setSelectedUser] = useState<AdminEmailUserResult | null>(null);
  const [search, setSearch] = useState("");
  const [results, setResults] = useState<AdminEmailUserResult[]>([]);
  const [searching, setSearching] = useState(false);
  const [busy, setBusy] = useState<"draft" | "test" | "send" | "cancel" | null>(null);
  const [error, setError] = useState<unknown>(null);
  const [draft, setDraft] = useState<AdminEmailCampaign | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [confirmation, setConfirmation] = useState("");

  const audienceCount = form.audience_kind === "all"
    ? overview.data?.emailable_count ?? 0
    : selectedUser ? 1 : 0;
  const formReady = form.subject.trim().length >= 3 && form.headline.trim().length >= 3 &&
    form.body_text.trim().length >= 10 && audienceCount > 0 &&
    ((!form.cta_label && !form.cta_url) || (Boolean(form.cta_label) && /^https:\/\//i.test(form.cta_url)));

  useEffect(() => {
    if (form.audience_kind !== "individual" || search.trim().length < 2) {
      return;
    }
    const timer = window.setTimeout(async () => {
      setSearching(true);
      try {
        const response = await contactEmailAdminApi.searchUsers(search);
        setResults(response.users ?? []);
      } catch (caught) {
        setError(caught);
      } finally {
        setSearching(false);
      }
    }, 280);
    return () => window.clearTimeout(timer);
  }, [form.audience_kind, search]);

  function update<K extends keyof FormState>(key: K, value: FormState[K]) {
    setForm((current) => ({ ...current, [key]: value }));
    setError(null);
  }

  function chooseType(type: AdminEmailCampaignType) {
    const individual = type === "individual_message";
    setForm((current) => ({
      ...current,
      campaign_type: type,
      audience_kind: individual ? "individual" : current.audience_kind,
      target_user_id: individual ? current.target_user_id : current.target_user_id,
    }));
  }

  async function createDraft() {
    if (!formReady || busy) return;
    setBusy("draft");
    setError(null);
    try {
      const response = await contactEmailAdminApi.createDraft({
        ...form,
        target_user_id: selectedUser?.user_id ?? null,
        cta_label: form.cta_label.trim() || null,
        cta_url: form.cta_url.trim() || null,
      });
      if (!response.campaign) throw new Error("Le brouillon n’a pas pu être créé.");
      setDraft(response.campaign);
      toast.success("Brouillon sécurisé créé. Aucun e-mail n’a été envoyé.");
      await overview.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(null);
    }
  }

  async function sendTest() {
    if (!draft || busy) return;
    setBusy("test");
    setError(null);
    try {
      const response = await contactEmailAdminApi.sendTest(draft.id);
      toast.success(`E-mail test envoyé uniquement à ${response.sent_to}.`);
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(null);
    }
  }

  async function cancelDraft() {
    if (!draft || busy) return;
    setBusy("cancel");
    setError(null);
    try {
      await contactEmailAdminApi.cancel(draft.id);
      setDraft(null);
      setForm(DEFAULT_FORM);
      setSelectedUser(null);
      setSearch("");
      toast.success("Brouillon annulé.");
      await overview.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(null);
    }
  }

  async function launch() {
    if (!draft || busy) return;
    setBusy("send");
    setError(null);
    try {
      const response = await contactEmailAdminApi.launch(
        draft.id,
        draft.recipient_count,
        confirmation,
      );
      setConfirmOpen(false);
      setConfirmation("");
      toast.success(`${response.submitted_count ?? 0} e-mail(s) remis à Brevo.`);
      setDraft(null);
      setForm(DEFAULT_FORM);
      setSelectedUser(null);
      setSearch("");
      await overview.reload();
    } catch (caught) {
      setError(caught);
    } finally {
      setBusy(null);
    }
  }

  return (
    <>
      <PageHeader
        title="Messages utilisateurs"
        subtitle="Préparez, testez et envoyez les communications de service COP’IQ depuis un espace privé réservé au propriétaire."
        action={
          <div className="inline-flex items-center gap-2 rounded-full border border-[var(--outline-variant)] bg-[var(--surface)] px-3 py-2 text-xs text-[var(--on-surface-muted)]">
            <ShieldCheck size={15} className="text-[var(--success)]" />
            Owner · 2FA · no-reply@copiq.fr
          </div>
        }
      />

      <Card className="relative mb-5 overflow-hidden p-5 md:p-6">
        <div className="pointer-events-none absolute -right-10 -top-24 h-64 w-64 rounded-full bg-[var(--brand)]/15 blur-3xl" />
        <div className="relative flex flex-col justify-between gap-5 lg:flex-row lg:items-center">
          <div className="flex items-start gap-4">
            <span className="grid h-13 w-13 shrink-0 place-items-center rounded-2xl bg-[var(--brand)] text-white shadow-lg shadow-blue-600/20">
              <MailCheck size={23} />
            </span>
            <div>
              <p className="text-xs font-semibold uppercase tracking-[.14em] text-[var(--brand)]">Centre de communication</p>
              <h2 className="mt-1 text-xl font-semibold tracking-[-.025em]">Un envoi maîtrisé de la rédaction jusqu’au suivi</h2>
              <p className="mt-1 max-w-2xl text-sm leading-6 text-[var(--on-surface-muted)]">
                Les adresses ne quittent jamais le serveur. Chaque campagne est figée dans un brouillon, testable sur votre adresse, puis protégée par une confirmation finale.
              </p>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-2 sm:grid-cols-3">
            <Metric value={overview.data?.emailable_count ?? "—"} label="comptes joignables" />
            <Metric value={overview.data?.campaigns?.filter((item) => item.status === "sent").length ?? "—"} label="campagnes remises" />
            <Metric value="0" label="envoi automatique" className="col-span-2 sm:col-span-1" />
          </div>
        </div>
      </Card>

      {overview.loading && <Card><Loading label="Chargement du centre de contact…" /></Card>}
      <ErrorBox error={overview.error ?? error} />

      {!overview.loading && (
        <div className="mt-5 grid items-start gap-5 2xl:grid-cols-[minmax(0,1.08fr)_minmax(390px,.72fr)]">
          <section className="space-y-5">
            <Card className="overflow-hidden">
              <div className="flex items-center justify-between border-b border-[var(--outline-variant)] bg-[var(--surface-container)]/45 px-5 py-4">
                <div>
                  <h2 className="font-semibold">1. Composer le message</h2>
                  <p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Aucune action de cette zone ne déclenche directement un envoi.</p>
                </div>
                <Badge tone={draft ? "good" : "neutral"}>{draft ? "Brouillon figé" : "Non enregistré"}</Badge>
              </div>
              <fieldset disabled={Boolean(draft)} className="space-y-6 p-5 md:p-6 disabled:opacity-70">
                <div>
                  <Legend number="01" title="Choisir un modèle" />
                  <div className="grid gap-2 md:grid-cols-3">
                    {TYPE_OPTIONS.map((option) => {
                      const Icon = option.icon;
                      const active = form.campaign_type === option.value;
                      return (
                        <button
                          type="button"
                          key={option.value}
                          onClick={() => chooseType(option.value)}
                          className={`cursor-pointer rounded-2xl border p-4 text-left transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${active ? "border-[var(--brand)] bg-[var(--brand)]/8 shadow-md shadow-blue-950/10" : "border-[var(--outline-variant)] hover:-translate-y-0.5 hover:border-[var(--brand)]/30 hover:bg-[var(--surface-container)]"}`}
                        >
                          <span className={`grid h-10 w-10 place-items-center rounded-xl ${active ? "bg-[var(--brand)] text-white" : "bg-[var(--surface-container-hi)] text-[var(--on-surface-muted)]"}`}><Icon size={19} /></span>
                          <strong className="mt-3 block text-sm">{option.title}</strong>
                          <span className="mt-1 block text-xs leading-5 text-[var(--on-surface-muted)]">{option.description}</span>
                        </button>
                      );
                    })}
                  </div>
                </div>

                <div>
                  <Legend number="02" title="Définir les destinataires" />
                  <div className="grid gap-2 sm:grid-cols-2">
                    <AudienceCard
                      active={form.audience_kind === "all"}
                      icon={UsersRound}
                      title="Tous les utilisateurs"
                      description={`${overview.data?.emailable_count ?? 0} compte(s) avec une adresse valide`}
                      onClick={() => update("audience_kind", "all")}
                    />
                    <AudienceCard
                      active={form.audience_kind === "individual"}
                      icon={UserRound}
                      title="Un utilisateur"
                      description="Recherche nominative et envoi personnel"
                      onClick={() => update("audience_kind", "individual")}
                    />
                  </div>
                  {form.audience_kind === "individual" && (
                    <div className="relative mt-3">
                      <Search size={17} className="pointer-events-none absolute left-3.5 top-4 text-[var(--on-surface-faint)]" />
                      <input
                        className={`${inputClass} pl-10`}
                        value={selectedUser ? `${selectedUser.name} — ${selectedUser.email}` : search}
                        onChange={(event) => {
                          setSelectedUser(null);
                          setSearch(event.target.value);
                        }}
                        placeholder="Rechercher par nom, pseudo ou e-mail…"
                      />
                      {!selectedUser && (searching || results.length > 0) && (
                        <div className="absolute inset-x-0 top-[calc(100%+6px)] z-20 overflow-hidden rounded-2xl border border-[var(--outline)] bg-[var(--surface)] p-1.5 shadow-2xl">
                          {searching ? <div className="p-3 text-sm text-[var(--on-surface-muted)]">Recherche…</div> : results.map((user) => (
                            <button
                              key={user.user_id}
                              type="button"
                              onClick={() => {
                                setSelectedUser(user);
                                update("target_user_id", user.user_id);
                                setResults([]);
                              }}
                              className="flex w-full cursor-pointer items-center gap-3 rounded-xl px-3 py-2.5 text-left transition hover:bg-[var(--surface-container)] focus-visible:outline-2 focus-visible:outline-[var(--brand)]"
                            >
                              <span className="grid h-9 w-9 place-items-center rounded-xl bg-[var(--brand)]/10 text-[var(--brand)]"><UserRound size={17} /></span>
                              <span className="min-w-0"><strong className="block truncate text-sm">{user.name}</strong><span className="block truncate text-xs text-[var(--on-surface-muted)]">{user.email}</span></span>
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  )}
                </div>

                <div>
                  <Legend number="03" title="Rédiger le contenu" />
                  <div className="grid gap-4 md:grid-cols-2">
                    <Field label="Objet de l’e-mail" className="md:col-span-2">
                      <input className={inputClass} value={form.subject} maxLength={160} onChange={(e) => update("subject", e.target.value)} />
                    </Field>
                    <Field label="Titre principal" className="md:col-span-2">
                      <input className={inputClass} value={form.headline} maxLength={180} onChange={(e) => update("headline", e.target.value)} />
                    </Field>
                    <Field label="Message" hint={`${form.body_text.length}/8000 caractères`} className="md:col-span-2">
                      <textarea className={`${inputClass} min-h-48 resize-y leading-6`} value={form.body_text} maxLength={8000} onChange={(e) => update("body_text", e.target.value)} />
                    </Field>
                    <Field label="Texte du bouton (facultatif)">
                      <input className={inputClass} value={form.cta_label} maxLength={48} onChange={(e) => update("cta_label", e.target.value)} placeholder="Découvrir" />
                    </Field>
                    <Field label="Lien HTTPS du bouton">
                      <input className={inputClass} value={form.cta_url} onChange={(e) => update("cta_url", e.target.value)} placeholder="https://copiq.fr" inputMode="url" />
                    </Field>
                  </div>
                </div>
              </fieldset>
              <div className="flex flex-col gap-3 border-t border-[var(--outline-variant)] bg-[var(--surface-container)]/35 px-5 py-4 sm:flex-row sm:items-center sm:justify-between">
                <div className="flex items-center gap-2 text-xs text-[var(--on-surface-muted)]">
                  <ShieldCheck size={15} className="text-[var(--success)]" />
                  {draft ? `${draft.recipient_count} destinataire(s) figé(s) dans ce brouillon` : `${audienceCount} destinataire(s) seront figés lors de l’enregistrement`}
                </div>
                {!draft ? (
                  <Button disabled={!formReady || Boolean(busy)} onClick={() => void createDraft()}>
                    <Mail size={16} /> {busy === "draft" ? "Création…" : "Créer le brouillon sécurisé"}
                  </Button>
                ) : (
                  <div className="flex flex-wrap gap-2">
                    <Button variant="ghost" disabled={Boolean(busy)} onClick={() => void cancelDraft()}>{busy === "cancel" ? "Annulation…" : "Annuler"}</Button>
                    <Button variant="ghost" disabled={Boolean(busy)} onClick={() => void sendTest()}><Eye size={16} />{busy === "test" ? "Envoi du test…" : "M’envoyer un test"}</Button>
                    <Button disabled={Boolean(busy)} onClick={() => setConfirmOpen(true)}><Send size={16} />Préparer l’envoi</Button>
                  </div>
                )}
              </div>
            </Card>

            <CampaignHistory
              campaigns={overview.data?.campaigns ?? []}
              onResume={(campaign) => {
                setDraft(campaign);
                setForm({
                  campaign_type: campaign.campaign_type,
                  audience_kind: campaign.audience_kind,
                  target_user_id: campaign.target_user_id,
                  subject: campaign.subject,
                  headline: campaign.headline,
                  body_text: campaign.body_text,
                  cta_label: campaign.cta_label ?? "",
                  cta_url: campaign.cta_url ?? "",
                });
                window.scrollTo({ top: 0, behavior: "smooth" });
              }}
            />
          </section>

          <EmailPreview form={form} audienceCount={draft?.recipient_count ?? audienceCount} sender={overview.data?.sender ?? "no-reply@copiq.fr"} />
        </div>
      )}

      {confirmOpen && draft && (
        <ConfirmDialog
          campaign={draft}
          value={confirmation}
          busy={busy === "send"}
          onChange={setConfirmation}
          onClose={() => {
            if (!busy) {
              setConfirmOpen(false);
              setConfirmation("");
            }
          }}
          onConfirm={() => void launch()}
        />
      )}
    </>
  );
}

function Metric({ value, label, className = "" }: { value: string | number; label: string; className?: string }) {
  return <div className={`min-w-28 rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/70 px-4 py-3 ${className}`}><strong className="block text-xl tabular-nums">{value}</strong><span className="text-[11px] text-[var(--on-surface-muted)]">{label}</span></div>;
}

function Legend({ number, title }: { number: string; title: string }) {
  return <div className="mb-3 flex items-center gap-2"><span className="grid h-6 min-w-6 place-items-center rounded-lg bg-[var(--brand)]/10 px-1.5 text-[10px] font-bold text-[var(--brand)]">{number}</span><h3 className="text-sm font-semibold">{title}</h3></div>;
}

function AudienceCard({ active, icon: Icon, title, description, onClick }: { active: boolean; icon: typeof UsersRound; title: string; description: string; onClick: () => void }) {
  return <button type="button" onClick={onClick} className={`flex min-h-20 cursor-pointer items-center gap-3 rounded-2xl border p-3.5 text-left transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${active ? "border-[var(--brand)] bg-[var(--brand)]/8" : "border-[var(--outline-variant)] hover:border-[var(--brand)]/30 hover:bg-[var(--surface-container)]"}`}><span className={`grid h-10 w-10 shrink-0 place-items-center rounded-xl ${active ? "bg-[var(--brand)] text-white" : "bg-[var(--surface-container-hi)] text-[var(--on-surface-muted)]"}`}><Icon size={18} /></span><span><strong className="block text-sm">{title}</strong><span className="mt-0.5 block text-xs text-[var(--on-surface-muted)]">{description}</span></span></button>;
}

function Field({ label, hint, className = "", children }: { label: string; hint?: string; className?: string; children: React.ReactNode }) {
  return <label className={`block ${className}`}><span className="mb-1.5 flex items-center justify-between gap-3 text-xs font-semibold"><span>{label}</span>{hint && <span className="font-normal text-[var(--on-surface-faint)]">{hint}</span>}</span>{children}</label>;
}

function EmailPreview({ form, audienceCount, sender }: { form: FormState; audienceCount: number; sender: string }) {
  return (
    <aside className="2xl:sticky 2xl:top-28">
      <Card className="overflow-hidden">
        <div className="flex items-center justify-between border-b border-[var(--outline-variant)] px-5 py-4"><div><h2 className="font-semibold">Aperçu en direct</h2><p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Rendu indicatif ordinateur et mobile</p></div><Eye size={19} className="text-[var(--brand)]" /></div>
        <div className="bg-[var(--surface-container)] p-3 sm:p-5">
          <div className="mb-3 rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] px-3 py-2.5 text-xs"><div className="flex gap-2"><span className="w-10 shrink-0 text-[var(--on-surface-faint)]">De</span><span className="truncate">COP’IQ &lt;{sender}&gt;</span></div><div className="mt-1 flex gap-2"><span className="w-10 shrink-0 text-[var(--on-surface-faint)]">Objet</span><strong className="min-w-0 truncate">{form.subject || "Objet du message"}</strong></div></div>
          <div className="mx-auto max-w-[640px] overflow-hidden rounded-[24px] border border-slate-200 bg-white text-slate-900 shadow-xl shadow-slate-950/10">
            <div className="h-1 bg-[linear-gradient(90deg,#155eef_0_33%,#f8fafc_33%_66%,#ef4444_66%)]" />
            <div className="px-6 py-7 sm:px-8">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src="https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png" alt="COP’IQ" className="mx-auto mb-7 h-12 w-auto object-contain" />
              <p className="mb-2 text-[10px] font-extrabold uppercase tracking-[.14em] text-blue-600">Information COP’IQ</p>
              <h3 className="text-2xl font-bold leading-tight tracking-[-.03em]">{form.headline || "Titre du message"}</h3>
              <p className="mt-5 text-sm leading-6">Bonjour Kaïs,</p>
              <div className="mt-3 whitespace-pre-wrap text-sm leading-6 text-slate-600">{form.body_text || "Votre message apparaîtra ici."}</div>
              {form.cta_label && form.cta_url && <div className="mt-7 text-center"><span className="inline-flex min-h-12 items-center gap-2 rounded-xl bg-blue-600 px-5 py-3 text-sm font-bold text-white">{form.cta_label}<ArrowRight size={16} /></span></div>}
              <p className="mt-7 text-sm">L’équipe COP’IQ</p>
            </div>
            <div className="border-t border-slate-200 bg-slate-50 px-6 py-4 text-center text-[10px] leading-4 text-slate-500">Message de service envoyé depuis COP’IQ · Merci de ne pas répondre à cet e-mail.</div>
          </div>
        </div>
        <div className="flex items-center justify-between gap-3 border-t border-[var(--outline-variant)] px-5 py-4 text-xs"><span className="inline-flex items-center gap-2 text-[var(--on-surface-muted)]"><UsersRound size={15} />Audience préparée</span><Badge tone={audienceCount ? "brand" : "warn"}>{audienceCount} destinataire{audienceCount > 1 ? "s" : ""}</Badge></div>
      </Card>
      <div className="mt-3 flex gap-3 rounded-2xl border border-[var(--warning)]/25 bg-[var(--warning)]/8 p-4 text-xs leading-5 text-[var(--on-surface-muted)]"><TriangleAlert size={18} className="mt-0.5 shrink-0 text-[var(--warning)]" /><p>Ce centre est réservé aux informations liées au service COP’IQ. Il ne doit pas être utilisé pour des campagnes publicitaires non sollicitées.</p></div>
    </aside>
  );
}

function CampaignHistory({ campaigns, onResume }: { campaigns: AdminEmailCampaign[]; onResume: (campaign: AdminEmailCampaign) => void }) {
  const labels: Record<AdminEmailCampaign["status"], string> = { draft: "Brouillon", sending: "En cours", sent: "Remise à Brevo", partial: "Partiel", failed: "Échec", cancelled: "Annulée" };
  const tones: Record<AdminEmailCampaign["status"], "neutral" | "good" | "warn" | "bad"> = { draft: "neutral", sending: "warn", sent: "good", partial: "warn", failed: "bad", cancelled: "neutral" };
  return <Card className="overflow-hidden"><div className="border-b border-[var(--outline-variant)] px-5 py-4"><h2 className="font-semibold">Historique récent</h2><p className="mt-0.5 text-xs text-[var(--on-surface-muted)]">Le statut « remise » confirme l’acceptation par Brevo, pas l’ouverture par le destinataire.</p></div>{campaigns.length === 0 ? <div className="p-10 text-center text-sm text-[var(--on-surface-muted)]"><Clock3 className="mx-auto mb-3 text-[var(--brand)]" />Aucune campagne pour le moment.</div> : <div className="divide-y divide-[var(--outline-variant)]">{campaigns.map((campaign) => <div key={campaign.id} className="flex flex-col gap-3 px-5 py-4 sm:flex-row sm:items-center sm:justify-between"><div className="min-w-0"><div className="flex items-center gap-2"><Megaphone size={15} className="shrink-0 text-[var(--brand)]" /><strong className="truncate text-sm">{campaign.subject}</strong></div><p className="mt-1 text-xs text-[var(--on-surface-muted)]">{new Date(campaign.created_at).toLocaleString("fr-FR")} · {campaign.recipient_count} destinataire{campaign.recipient_count > 1 ? "s" : ""}</p></div><div className="flex items-center gap-2">{campaign.status === "draft" && <button type="button" onClick={() => onResume(campaign)} className="cursor-pointer rounded-lg px-2.5 py-1.5 text-xs font-semibold text-[var(--brand)] transition hover:bg-[var(--brand)]/10">Reprendre</button>}<Badge tone={tones[campaign.status]}>{labels[campaign.status]}</Badge>{campaign.status === "sent" && <span className="text-xs tabular-nums text-[var(--success)]">{campaign.submitted_count}/{campaign.recipient_count}</span>}</div></div>)}</div>}</Card>;
}

function ConfirmDialog({ campaign, value, busy, onChange, onClose, onConfirm }: { campaign: AdminEmailCampaign; value: string; busy: boolean; onChange: (value: string) => void; onClose: () => void; onConfirm: () => void }) {
  const phrase = `ENVOYER ${campaign.recipient_count}`;
  const valid = value.trim().toUpperCase() === phrase;
  return <div className="fixed inset-0 z-[100] grid place-items-center bg-slate-950/70 p-4 backdrop-blur-md" role="dialog" aria-modal="true" aria-labelledby="confirm-title" onMouseDown={(event) => { if (event.target === event.currentTarget) onClose(); }}><Card className="w-full max-w-lg overflow-hidden shadow-2xl"><div className="flex items-start justify-between gap-4 border-b border-[var(--outline-variant)] px-5 py-4"><div className="flex gap-3"><span className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-[var(--danger)]/10 text-[var(--danger)]"><Send size={19} /></span><div><h2 id="confirm-title" className="font-semibold">Confirmer l’envoi définitif</h2><p className="mt-1 text-xs text-[var(--on-surface-muted)]">Cette action contactera immédiatement l’audience figée.</p></div></div><button type="button" onClick={onClose} disabled={busy} className="cursor-pointer rounded-xl p-2 text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)]" aria-label="Fermer"><X size={18} /></button></div><div className="space-y-4 p-5"><div className="rounded-2xl border border-[var(--danger)]/25 bg-[var(--danger)]/7 p-4"><div className="flex items-center gap-2 text-sm font-semibold text-[var(--danger)]"><TriangleAlert size={17} />{campaign.recipient_count} destinataire{campaign.recipient_count > 1 ? "s" : ""}</div><p className="mt-2 text-xs leading-5 text-[var(--on-surface-muted)]">Objet : {campaign.subject}</p></div><label className="block"><span className="mb-2 block text-xs font-semibold">Pour confirmer, saisissez <strong className="text-[var(--on-surface)]">{phrase}</strong></span><input autoFocus className={inputClass} value={value} onChange={(event) => onChange(event.target.value)} autoComplete="off" /></label><div className="flex gap-2 rounded-xl bg-[var(--surface-container)] p-3 text-xs leading-5 text-[var(--on-surface-muted)]"><CheckCircle2 size={16} className="mt-0.5 shrink-0 text-[var(--success)]" />La protection anti-doublon reste active si la connexion est interrompue.</div></div><div className="flex justify-end gap-2 border-t border-[var(--outline-variant)] px-5 py-4"><Button variant="ghost" disabled={busy} onClick={onClose}>Retour</Button><Button variant="danger" disabled={!valid || busy} onClick={onConfirm}>{busy ? "Envoi sécurisé…" : `Envoyer à ${campaign.recipient_count}`}</Button></div></Card></div>;
}
