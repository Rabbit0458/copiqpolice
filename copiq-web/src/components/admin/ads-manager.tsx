"use client";

import { useState } from "react";
import { informationAdminApi } from "@/lib/admin/api";
import { Button, Card, ErrorBox, Loading, useAsync } from "./admin-ui";

function localDate(value: string | null) {
  if (!value) return "";
  const date = new Date(value);
  return new Date(date.getTime() - date.getTimezoneOffset() * 60000).toISOString().slice(0, 16);
}

export function AdsManager() {
  const config = useAsync(() => informationAdminApi.runtimeConfig(), []);
  const [draft, setDraft] = useState<null | { enabled: boolean; minutes: number; start: string; end: string }>(null);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");
  const current = draft ?? (config.data ? {
    enabled: config.data.ads_enabled,
    minutes: config.data.ads_interval_minutes,
    start: localDate(config.data.ads_starts_at), end: localDate(config.data.ads_ends_at),
  } : null);
  if (config.loading) return <Loading label="Chargement des publicités…" />;
  if (config.error) return <ErrorBox error={config.error} />;
  if (!current) return null;
  const save = async () => {
    if (saving) return;
    setMessage("");
    if (!Number.isInteger(current.minutes) || current.minutes < 5 || current.minutes > 1440) {
      setMessage("Choisissez un intervalle entier entre 5 et 1 440 minutes."); return;
    }
    if (current.start && current.end && new Date(current.end) <= new Date(current.start)) {
      setMessage("La fin doit être postérieure au début."); return;
    }
    setSaving(true);
    try {
      await informationAdminApi.updateAdsConfig({ enabled: current.enabled,
        intervalMinutes: current.minutes,
        startsAt: current.start ? new Date(current.start).toISOString() : null,
        endsAt: current.end ? new Date(current.end).toISOString() : null });
      setDraft(null); await config.reload();
      setMessage("Réglages enregistrés. Les applications compatibles les reliront avant la prochaine publicité.");
    } catch (error) { setMessage(error instanceof Error ? error.message : "Enregistrement impossible."); }
    finally { setSaving(false); }
  };
  const input = "mt-2 block w-full rounded-lg border border-[var(--outline-variant)] bg-[var(--surface)] p-3";
  return <Card className="max-w-3xl p-6">
    <h2 className="text-lg font-semibold">Publicités des comptes gratuits</h2>
    <p className="my-3 text-sm">Les abonnés Premium sont exclus. Modification réservée au propriétaire avec double authentification.</p>
    <fieldset disabled={saving} className="space-y-4">
      <label className="flex items-center gap-2"><input type="checkbox" checked={current.enabled}
        onChange={e => setDraft({ ...current, enabled: e.target.checked })} />Activer les publicités</label>
      <label className="block">Délai minimum entre deux publicités automatiques (minutes)
        <input className={input} type="number" min={5} max={1440} step={1} value={current.minutes}
          onChange={e => setDraft({ ...current, minutes: Number(e.target.value) })} /></label>
      <div className="flex gap-2">{[15, 20, 30].map(minutes => <Button key={minutes}
        onClick={() => setDraft({ ...current, minutes })}>{minutes} min</Button>)}</div>
      <label className="block">Début facultatif<input type="datetime-local" className={input} value={current.start}
        onChange={e => setDraft({ ...current, start: e.target.value })} /></label>
      <label className="block">Fin facultative<input type="datetime-local" className={input} value={current.end}
        onChange={e => setDraft({ ...current, end: e.target.value })} /></label>
      <p className="text-sm">Heures du navigateur ({Intl.DateTimeFormat().resolvedOptions().timeZone}). Une date vide ne fixe aucune limite. La fin est exclusive.</p>
      <p className="text-sm">L’intervalle est un minimum, pas une minuterie : affichage uniquement à une transition prévue, jamais au milieu d’un exercice. La durée de la vidéo dépend d’AdMob. Les annonces volontaires avec récompense ne suivent pas cet intervalle, mais respectent l’activation et les dates.</p>
      <Button onClick={save} disabled={saving}>{saving ? "Enregistrement…" : "Enregistrer les publicités"}</Button>
    </fieldset>
    {message && <p role="status" className="mt-4 text-sm">{message}</p>}
  </Card>;
}
