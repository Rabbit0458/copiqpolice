"use client"

import { useState } from "react"
import { staffApi, type AdminStaff } from "@/lib/admin/api"
import {
  Badge,
  Button,
  Card,
  Empty,
  ErrorBox,
  Loading,
  PageHeader,
  useAsync,
} from "@/components/admin/admin-ui"

/** Clés de permission utilisées par le panel. */
const PERMISSIONS: [string, string][] = [
  ["dashboard", "Vue d'ensemble"],
  ["cas_pratiques", "Cas pratiques"],
  ["quiz.write", "Quiz & fiches de cours"],
  ["flags", "Signalements"],
  ["forum", "Modération forum"],
  ["users", "Utilisateurs"],
  ["subscriptions", "Abonnements"],
  ["bugs", "Bugs & contacts"],
  ["results", "Résultats"],
  ["admin_security", "Journal d'audit"],
]

export default function AdministrateursPage() {
  const [search, setSearch] = useState("")
  const { data, error, loading, reload } = useAsync(
    () => staffApi.list(search),
    [search],
  )
  const [creating, setCreating] = useState(false)

  return (
    <>
      <PageHeader
        title="Comptes administrateurs"
        subtitle="Rôles, permissions et sécurité des accès au panel"
        action={<Button onClick={() => setCreating(true)}>+ Administrateur</Button>}
      />

      <Card className="mb-4 border-[var(--warning)]/40 bg-[var(--warning)]/5 p-4">
        <p className="text-sm text-[var(--on-surface-muted)]">
          <strong className="text-[var(--warning)]">Rappel de sécurité.</strong>{" "}
          Créer un compte ici ne suffit pas : la personne doit également disposer
          d&apos;un compte Supabase avec la <strong>même adresse e-mail</strong>,
          activer la double authentification, et recevoir son code staff. Toute
          action réalisée depuis ce panel est journalisée de façon immuable.
        </p>
      </Card>

      {creating && (
        <StaffForm
          onCancel={() => setCreating(false)}
          onSaved={() => {
            setCreating(false)
            reload()
          }}
        />
      )}

      <input
        placeholder="Rechercher un administrateur…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
        className="mb-4 w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"
      />

      {error && <ErrorBox error={error} />}
      {loading && <Loading />}
      {data && data.length === 0 && <Empty>Aucun administrateur.</Empty>}

      <div className="space-y-3">
        {(data ?? []).map((a) => (
          <StaffCard key={a.id} a={a} onChanged={reload} />
        ))}
      </div>
    </>
  )
}

function StaffCard({ a, onChanged }: { a: AdminStaff; onChanged: () => void }) {
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)
  const [open, setOpen] = useState(false)
  const [code, setCode] = useState("")

  const locked =
    a.locked_until != null && new Date(a.locked_until) > new Date()
  const expired =
    a.expires_at != null && new Date(a.expires_at) < new Date()

  async function run(fn: () => Promise<unknown>, confirmMsg?: string) {
    if (confirmMsg && !confirm(confirmMsg)) return
    setBusy(true)
    setErr(null)
    try {
      await fn()
      onChanged()
    } catch (e) {
      setErr(e)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="p-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="text-sm font-semibold">
            {[a.first_name, a.last_name].filter(Boolean).join(" ") ||
              a.username ||
              a.email}
          </div>
          <div className="text-xs text-[var(--on-surface-faint)]">{a.email}</div>
          <div className="mt-1 text-[11px] text-[var(--on-surface-muted)]">
            {a.last_admin_login_at
              ? `Dernière connexion : ${new Date(a.last_admin_login_at).toLocaleString("fr-FR")}`
              : "Jamais connecté"}
            {a.last_admin_login_ip ? ` · ${a.last_admin_login_ip}` : ""}
          </div>
        </div>
        <div className="flex shrink-0 flex-wrap items-center gap-1.5">
          <Badge tone={a.role === "owner" ? "brand" : "neutral"}>{a.role}</Badge>
          {a.disabled && <Badge tone="bad">désactivé</Badge>}
          {locked && <Badge tone="bad">verrouillé</Badge>}
          {expired && <Badge tone="warn">expiré</Badge>}
          {a.second_factor_enabled ? (
            <Badge tone="good">2FA</Badge>
          ) : (
            <Badge tone="warn">sans 2FA</Badge>
          )}
          {a.failed_admin_code_attempts > 0 && (
            <Badge tone="warn">{a.failed_admin_code_attempts} échecs</Badge>
          )}
        </div>
      </div>

      <div className="mt-2.5 flex flex-wrap gap-1">
        {PERMISSIONS.filter(([k]) => a.role === "owner" || a.permissions?.[k]).map(
          ([k, l]) => (
            <span
              key={k}
              className="rounded-full bg-[var(--surface-container-hi)] px-2 py-0.5 text-[11px] text-[var(--on-surface-muted)]"
            >
              {l}
            </span>
          ),
        )}
        {a.role === "owner" && (
          <span className="rounded-full bg-[var(--brand)]/10 px-2 py-0.5 text-[11px] font-medium text-[var(--brand)]">
            toutes permissions
          </span>
        )}
      </div>

      {a.notes && (
        <p className="mt-2 text-xs italic text-[var(--on-surface-muted)]">
          {a.notes}
        </p>
      )}

      <ErrorBox error={err} />

      <div className="mt-3 flex flex-wrap gap-2 border-t border-[var(--outline-variant)] pt-3">
        {a.disabled ? (
          <Button
            disabled={busy}
            onClick={() =>
              run(
                () => staffApi.reactivate(a.id, "Réactivation depuis le panel"),
                `Réactiver le compte de ${a.email} ?`,
              )
            }
            className="!py-1.5 !text-xs"
          >
            Réactiver
          </Button>
        ) : (
          <Button
            variant="danger"
            disabled={busy || a.role === "owner"}
            onClick={() =>
              run(
                () => staffApi.suspend(a.id, null, "Suspension depuis le panel"),
                `Suspendre le compte de ${a.email} ?`,
              )
            }
            className="!py-1.5 !text-xs"
          >
            Suspendre
          </Button>
        )}
        <Button
          variant="ghost"
          onClick={() => setOpen((v) => !v)}
          className="!py-1.5 !text-xs"
        >
          Réinitialiser le code staff
        </Button>
      </div>

      {open && (
        <div className="mt-2 flex flex-wrap items-center gap-2">
          <input
            type="password"
            value={code}
            onChange={(e) => setCode(e.target.value)}
            placeholder="Nouveau code staff"
            className="min-w-48 flex-1 rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-1.5 text-sm"
          />
          <Button
            disabled={busy || code.length < 4}
            onClick={() =>
              run(async () => {
                await staffApi.resetCode(a.id, code, "Réinitialisation panel")
                setCode("")
                setOpen(false)
              })
            }
            className="!py-1.5 !text-xs"
          >
            Enregistrer
          </Button>
        </div>
      )}
    </Card>
  )
}

function StaffForm({
  onCancel,
  onSaved,
}: {
  onCancel: () => void
  onSaved: () => void
}) {
  const [f, setF] = useState({
    email: "",
    role: "moderator",
    first_name: "",
    last_name: "",
    notes: "",
  })
  const [perms, setPerms] = useState<Record<string, boolean>>({
    dashboard: true,
  })
  const [busy, setBusy] = useState(false)
  const [err, setErr] = useState<unknown>(null)

  const ic =
    "w-full rounded-lg border border-[var(--outline)] bg-[var(--surface)] px-3 py-2 text-sm outline-none focus:border-[var(--brand)]"

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setBusy(true)
    setErr(null)
    try {
      await staffApi.create({
        email: f.email.trim().toLowerCase(),
        role: f.role,
        first_name: f.first_name || undefined,
        last_name: f.last_name || undefined,
        permissions: perms,
        notes: f.notes || undefined,
      })
      onSaved()
    } catch (e2) {
      setErr(e2)
    } finally {
      setBusy(false)
    }
  }

  return (
    <Card className="mb-4 p-5">
      <h2 className="mb-3 text-sm font-semibold">Nouvel administrateur</h2>
      <form onSubmit={submit} className="space-y-3">
        <div className="grid gap-3 sm:grid-cols-2">
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
              Adresse e-mail (identique au compte Supabase)
            </span>
            <input
              type="email"
              value={f.email}
              onChange={(e) => setF({ ...f, email: e.target.value })}
              required
              className={ic}
            />
          </label>
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
              Rôle
            </span>
            <select
              value={f.role}
              onChange={(e) => setF({ ...f, role: e.target.value })}
              className={ic}
            >
              <option value="moderator">moderator</option>
              <option value="admin">admin</option>
              <option value="superadmin">superadmin</option>
            </select>
          </label>
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
              Prénom
            </span>
            <input
              value={f.first_name}
              onChange={(e) => setF({ ...f, first_name: e.target.value })}
              className={ic}
            />
          </label>
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
              Nom
            </span>
            <input
              value={f.last_name}
              onChange={(e) => setF({ ...f, last_name: e.target.value })}
              className={ic}
            />
          </label>
        </div>

        <div>
          <span className="mb-1.5 block text-xs font-medium text-[var(--on-surface-muted)]">
            Permissions
          </span>
          <div className="grid gap-1.5 sm:grid-cols-2">
            {PERMISSIONS.map(([k, l]) => (
              <label key={k} className="flex items-center gap-2 text-sm">
                <input
                  type="checkbox"
                  checked={Boolean(perms[k])}
                  onChange={(e) => setPerms({ ...perms, [k]: e.target.checked })}
                  className="h-4 w-4"
                />
                {l}
              </label>
            ))}
          </div>
        </div>

        <label className="block">
          <span className="mb-1 block text-xs font-medium text-[var(--on-surface-muted)]">
            Notes internes
          </span>
          <input
            value={f.notes}
            onChange={(e) => setF({ ...f, notes: e.target.value })}
            className={ic}
          />
        </label>

        <ErrorBox error={err} />
        <div className="flex gap-2">
          <Button type="submit" disabled={busy}>
            {busy ? "Création…" : "Créer le compte"}
          </Button>
          <Button type="button" variant="ghost" onClick={onCancel}>
            Annuler
          </Button>
        </div>
      </form>
    </Card>
  )
}
