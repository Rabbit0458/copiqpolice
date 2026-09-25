"use client"

import { Activity, BarChart3, BookOpenCheck, Eye, ShieldCheck, Users } from "lucide-react"
import { Badge, Card, PageHeader } from "@/components/admin/admin-ui"

const activity = [118, 132, 126, 151, 163, 175, 191, 184, 207, 221, 239, 248, 261, 279]
const journeys = [
  { label: "Scolarité GPX", users: 486, accuracy: 74 },
  { label: "Scolarité PA", users: 312, accuracy: 71 },
  { label: "Concours GPX", users: 428, accuracy: 68 },
  { label: "Concours PA", users: 295, accuracy: 70 },
]

export default function DemoAdminPage() {
  const max = Math.max(...activity)
  return <div className="relative">
    <div className="pointer-events-none fixed inset-x-0 top-[76px] z-30 flex justify-center"><div className="rounded-b-2xl bg-[var(--warning)] px-5 py-2 text-xs font-bold uppercase tracking-[.14em] text-slate-950 shadow-lg">Mode démonstration · données fictives · aucune action de production</div></div>
    <PageHeader title="Démonstration sécurisée" subtitle="Présenter le pilotage COP’IQ sans charger de profil utilisateur réel et sans permettre aucune écriture." />
    <div className="mb-5 flex items-start gap-3 rounded-2xl border border-[var(--brand)]/30 bg-[var(--brand)]/8 p-4"><ShieldCheck className="mt-0.5 shrink-0 text-[var(--brand)]" /><div><div className="font-semibold">Environnement entièrement isolé</div><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Toutes les valeurs de cette page sont statiques et fictives. Aucun appel Supabase, aucune adresse e-mail et aucun identifiant utilisateur ne sont chargés.</p></div></div>
    <section className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4"><DemoKpi icon={Users} label="Utilisateurs actifs 30 j" value="1 842" change="+12,4 %" /><DemoKpi icon={Activity} label="Rétention J7" value="34,8 %" change="+3,1 pts" /><DemoKpi icon={BookOpenCheck} label="Réponses sauvegardées" value="48 921" change="+18,7 %" /><DemoKpi icon={BarChart3} label="Conversion Premium" value="7,6 %" change="+0,8 pt" /></section>
    <div className="mt-4 grid gap-4 xl:grid-cols-[1.2fr_.8fr]"><Card className="p-5"><div className="flex items-center justify-between"><div><h2 className="font-semibold">Activité quotidienne</h2><p className="mt-1 text-xs text-[var(--on-surface-muted)]">Exemple fictif sur 14 jours</p></div><Badge tone="good">Tendance positive</Badge></div><div className="mt-6 flex h-44 items-end gap-2" aria-hidden="true">{activity.map((value, index) => <div key={index} className="flex min-w-0 flex-1 items-end"><div className="w-full rounded-t-md bg-gradient-to-t from-blue-700 to-blue-400" style={{ height: `${value / max * 100}%` }} /></div>)}</div><table className="sr-only"><caption>Activité fictive quotidienne</caption><tbody>{activity.map((value, index) => <tr key={index}><th>Jour {index + 1}</th><td>{value}</td></tr>)}</tbody></table></Card><Card className="p-5"><h2 className="font-semibold">Parcours</h2><div className="mt-4 space-y-4">{journeys.map((journey) => <div key={journey.label}><div className="flex justify-between gap-3 text-sm"><span>{journey.label}</span><span className="font-semibold">{journey.accuracy} %</span></div><div className="mt-2 h-2 overflow-hidden rounded-full bg-[var(--surface-container-hi)]"><div className="h-full rounded-full bg-[var(--brand)]" style={{ width: `${journey.accuracy}%` }} /></div><div className="mt-1 text-[10px] text-[var(--on-surface-faint)]">{journey.users} apprenants fictifs</div></div>)}</div></Card></div>
    <Card className="mt-4 p-5"><div className="flex items-center gap-3"><Eye className="text-[var(--brand)]" /><div><h2 className="font-semibold">Ce mode sert aux démonstrations et aux tests visuels</h2><p className="mt-1 text-sm text-[var(--on-surface-muted)]">Il permet de vérifier les volumes, le responsive et la hiérarchie du dashboard sans exposer la production. Pour travailler sur les données réelles, utilise les autres rubriques owner.</p></div></div></Card>
  </div>
}

function DemoKpi({ icon: Icon, label, value, change }: { icon: typeof Users; label: string; value: string; change: string }) { return <Card className="p-5"><Icon size={20} className="text-[var(--brand)]" /><div className="mt-4 text-2xl font-semibold tabular-nums">{value}</div><div className="mt-1 text-xs text-[var(--on-surface-muted)]">{label}</div><div className="mt-3 text-xs font-semibold text-[var(--success)]">{change}</div></Card> }

