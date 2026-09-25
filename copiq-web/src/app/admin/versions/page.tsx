"use client"

import { useEffect, useMemo, useState } from "react"
import { AlertTriangle, CheckCircle2, ExternalLink, LockKeyhole, RotateCcw, ShieldCheck, Smartphone } from "lucide-react"
import toast from "react-hot-toast"
import { mobileReleaseApi, type MobileReleaseConfig } from "@/lib/admin/api"
import { Badge, Button, Card, ErrorBox, Loading, PageHeader, useAsync } from "@/components/admin/admin-ui"

const PLATFORM = {
  ios: { label: "iOS", store: "TestFlight / App Store" },
  android: { label: "Android", store: "Google Play" },
} as const

export default function MobileVersionsPage() {
  const query = useAsync(() => mobileReleaseApi.list(), [])
  const rows = query.data ?? []
  const ios = rows.find((row) => row.platform === "ios")
  const android = rows.find((row) => row.platform === "android")
  const [form, setForm] = useState({ build: 4, version: "1.0.0", message: "Une nouvelle version de COP'IQ est disponible. Mets à jour l'application pour continuer.", iosUrl: "", androidUrl: "" })
  const [busy, setBusy] = useState<string | null>(null)
  const [error, setError] = useState<unknown>(null)

  useEffect(() => {
    if (!ios || !android) return
    const latest = Math.max(ios.latest_build_number, android.latest_build_number)
    const minimum = Math.max(ios.min_build_number, android.min_build_number)
    setForm({
      build: latest <= minimum ? minimum + 1 : latest,
      version: ios.latest_version,
      message: ios.message,
      iosUrl: ios.store_url,
      androidUrl: android.store_url,
    })
  }, [ios, android])

  const targetBuild = Math.max(ios?.latest_build_number ?? 0, android?.latest_build_number ?? 0)
  const bothReady = useMemo(() => Boolean(
    ios && android && ios.release_available && android.release_available &&
    ios.available_build_number === targetBuild && android.available_build_number === targetBuild &&
    ios.latest_build_number === targetBuild && android.latest_build_number === targetBuild &&
    ios.store_url.trim() && android.store_url.trim()
  ), [ios, android, targetBuild])
  const isForced = Boolean(ios?.force_update && android?.force_update)

  async function run(key: string, action: () => Promise<unknown>, success: string) {
    setBusy(key); setError(null)
    try { await action(); toast.success(success); query.reload() }
    catch (reason) { setError(reason); toast.error(reason instanceof Error ? reason.message : "Action refusée par le serveur.") }
    finally { setBusy(null) }
  }

  async function prepare(event: React.FormEvent) {
    event.preventDefault()
    if (!window.confirm(`Préparer le build ${form.build} ? Les confirmations iOS et Android seront remises à zéro.`)) return
    await run("prepare", () => mobileReleaseApi.prepare(form), `Build ${form.build} préparé sans bloquer les utilisateurs.`)
  }

  async function markAvailable(platform: "ios" | "android") {
    if (!window.confirm(`Confirmer que le build ${targetBuild} est réellement téléchargeable sur ${PLATFORM[platform].store} ?`)) return
    await run(platform, () => mobileReleaseApi.markAvailable(platform, targetBuild), `${PLATFORM[platform].label} marqué disponible.`)
  }

  async function activate() {
    if (!bothReady) return
    if (!window.confirm(`Rendre le build ${targetBuild} obligatoire sur iOS ET Android ?\n\nLes anciens builds compatibles seront bloqués au prochain contrôle de version.`)) return
    await run("activate", () => mobileReleaseApi.activate(targetBuild), `Le build ${targetBuild} est maintenant obligatoire.`)
  }

  async function disableForce() {
    if (!window.confirm("Désactiver immédiatement le blocage obligatoire sur iOS et Android ?")) return
    await run("disable", () => mobileReleaseApi.disableForce(), "Blocage obligatoire désactivé.")
  }

  if (query.loading) return <Loading label="Chargement des versions mobiles…" />

  return <>
    <PageHeader title="Versions mobiles" subtitle="Préparer, valider puis imposer une mise à jour iOS et Android en toute sécurité" />
    {query.error && <ErrorBox error={query.error} />}
    {error && <ErrorBox error={error} />}

    <div className="mb-5 grid gap-4 lg:grid-cols-3">
      <StatusCard icon={Smartphone} label="Build préparé" value={targetBuild || "—"} hint={`Version ${ios?.latest_version ?? "—"}`} />
      <StatusCard icon={CheckCircle2} label="Disponibilité boutiques" value={`${Number(Boolean(ios?.release_available)) + Number(Boolean(android?.release_available))}/2`} hint={bothReady ? "Les deux plateformes sont prêtes" : "Confirmation des deux boutiques requise"} tone={bothReady ? "good" : "warn"} />
      <StatusCard icon={LockKeyhole} label="Mise à jour obligatoire" value={isForced ? `Build ${ios?.min_build_number}` : "Désactivée"} hint={isForced ? "Blocage actif sur les deux plateformes" : "Les utilisateurs peuvent continuer"} tone={isForced ? "bad" : "good"} />
    </div>

    <Card className="mb-5 overflow-hidden">
      <div className="border-b border-[var(--outline-variant)] p-5">
        <div className="flex items-start gap-3">
          <span className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-[var(--brand)]/10 text-[var(--brand)]"><ShieldCheck size={21} /></span>
          <div><h2 className="font-semibold">Parcours sécurisé</h2><p className="mt-1 max-w-3xl text-sm leading-6 text-[var(--on-surface-muted)]">La base refusera l’activation tant que le même build n’est pas confirmé disponible sur iOS et Android et que les deux liens ne sont pas valides. Seul le propriétaire connecté en double authentification peut effectuer ces actions.</p></div>
        </div>
      </div>
      <div className="grid gap-4 p-5 md:grid-cols-2">
        {[ios, android].filter(Boolean).map((row) => <PlatformCard key={row!.platform} row={row!} busy={busy} onConfirm={markAvailable} />)}
      </div>
    </Card>

    <Card className="mb-5 p-5">
      <div className="mb-5"><h2 className="font-semibold">Préparer la prochaine version</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Cette étape renseigne le build et les liens, sans modifier le build minimal exigé.</p></div>
      <form onSubmit={prepare} className="space-y-4">
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Numéro de build"><input type="number" min="1" required value={form.build} onChange={(e) => setForm({ ...form, build: Number(e.target.value) })} className={inputClass} /></Field>
          <Field label="Version publique"><input required value={form.version} onChange={(e) => setForm({ ...form, version: e.target.value })} placeholder="1.0.0" className={inputClass} /></Field>
          <Field label="Lien iOS"><input type="url" required value={form.iosUrl.startsWith("itms-beta://") ? "" : form.iosUrl} onChange={(e) => setForm({ ...form, iosUrl: e.target.value })} placeholder="https://testflight.apple.com/join/…" className={inputClass} /></Field>
          <Field label="Lien Android"><input type="url" required value={form.androidUrl} onChange={(e) => setForm({ ...form, androidUrl: e.target.value })} placeholder="https://play.google.com/store/apps/details?id=fr.copiq.app" className={inputClass} /></Field>
        </div>
        <Field label="Message affiché aux utilisateurs"><textarea required rows={3} value={form.message} onChange={(e) => setForm({ ...form, message: e.target.value })} className={inputClass} /></Field>
        <Button type="submit" disabled={busy !== null}>{busy === "prepare" ? "Préparation…" : "Préparer la version"}</Button>
      </form>
    </Card>

    <Card className={`p-5 ${bothReady ? "border-[var(--success)]/35" : "border-[var(--warning)]/35"}`}>
      <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div className="flex gap-3"><AlertTriangle className={bothReady ? "text-[var(--success)]" : "text-[var(--warning)]"} size={22} /><div><h2 className="font-semibold">Activation finale</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">{bothReady ? `Le build ${targetBuild} est confirmé sur les deux boutiques. L’activation est autorisée.` : "Le serveur maintient le bouton verrouillé jusqu’à la validation complète des deux plateformes."}</p></div></div>
        <div className="flex flex-wrap gap-2">
          {isForced && <Button type="button" variant="ghost" disabled={busy !== null} onClick={disableForce}><RotateCcw size={16} /> Désactiver le blocage</Button>}
          <Button type="button" disabled={!bothReady || busy !== null} onClick={activate}>{busy === "activate" ? "Activation…" : `Rendre le build ${targetBuild} obligatoire`}</Button>
        </div>
      </div>
    </Card>
  </>
}

const inputClass = "min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface-container)] px-3 py-2 text-sm outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"

function Field({ label, children }: { label: string; children: React.ReactNode }) { return <label className="block"><span className="mb-1.5 block text-xs font-semibold text-[var(--on-surface-muted)]">{label}</span>{children}</label> }

function StatusCard({ icon: Icon, label, value, hint, tone = "neutral" }: { icon: typeof Smartphone; label: string; value: React.ReactNode; hint: string; tone?: "neutral" | "good" | "warn" | "bad" }) {
  const colors = { neutral: "text-[var(--brand)]", good: "text-[var(--success)]", warn: "text-[var(--warning)]", bad: "text-[var(--danger)]" }
  return <Card className="p-5"><div className="flex items-start gap-3"><span className={`grid h-10 w-10 place-items-center rounded-xl bg-[var(--surface-container-hi)] ${colors[tone]}`}><Icon size={19} /></span><div><div className="text-xs text-[var(--on-surface-muted)]">{label}</div><div className="mt-1 text-2xl font-semibold tabular-nums">{value}</div><div className="mt-1 text-xs text-[var(--on-surface-faint)]">{hint}</div></div></div></Card>
}

function PlatformCard({ row, busy, onConfirm }: { row: MobileReleaseConfig; busy: string | null; onConfirm: (platform: "ios" | "android") => void }) {
  const meta = PLATFORM[row.platform]
  return <div className="rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface-container)]/45 p-4">
    <div className="flex items-start justify-between gap-3"><div><div className="font-semibold">{meta.label}</div><div className="mt-1 text-xs text-[var(--on-surface-muted)]">{meta.store}</div></div><Badge tone={row.release_available ? "good" : "warn"}>{row.release_available ? "Disponible" : "À confirmer"}</Badge></div>
    <dl className="mt-4 grid grid-cols-2 gap-3 text-xs"><div><dt className="text-[var(--on-surface-faint)]">Build préparé</dt><dd className="mt-1 font-semibold">{row.latest_build_number}</dd></div><div><dt className="text-[var(--on-surface-faint)]">Build minimal</dt><dd className="mt-1 font-semibold">{row.min_build_number}</dd></div></dl>
    <a href={row.store_url} target="_blank" rel="noreferrer" className="mt-4 flex min-h-11 items-center justify-between rounded-xl border border-[var(--outline)] px-3 text-xs text-[var(--brand)] transition hover:bg-[var(--brand)]/5 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"><span className="truncate">Ouvrir le lien de téléchargement</span><ExternalLink size={15} /></a>
    <Button type="button" variant="ghost" disabled={row.release_available || busy !== null} onClick={() => onConfirm(row.platform)} className="mt-3 w-full">{busy === row.platform ? "Confirmation…" : row.release_available ? "Disponibilité confirmée" : "Confirmer la disponibilité"}</Button>
    {row.availability_confirmed_at && <p className="mt-2 text-center text-[11px] text-[var(--on-surface-faint)]">Confirmé le {new Date(row.availability_confirmed_at).toLocaleString("fr-FR")}</p>}
  </div>
}
