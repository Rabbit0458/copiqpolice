"use client";

/** COP'IQ — Briques d'interface partagées du panel administrateur. */

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import {
  Activity,
  BadgeEuro,
  ChartNoAxesCombined,
  BookOpenText,
  ChevronLeft,
  ChevronRight,
  ClipboardCheck,
  Command,
  FileClock,
  FilePenLine,
  Flag,
  GraduationCap,
  Gauge,
  HeartPulse,
  Info,
  LayoutDashboard,
  LibraryBig,
  LogOut,
  Mail,
  Menu,
  MessageSquareMore,
  MonitorPlay,
  MoonStar,
  BrainCircuit,
  Search,
  ShieldCheck,
  Smartphone,
  Sun,
  Users,
  X,
  type LucideIcon,
} from "lucide-react";
import { useTheme } from "next-themes";
import { adminAuth, type AdminSession } from "@/lib/admin/api";

/* ────────────────────────────────────────────────────────────────────────── */
/*  Navigation                                                                */
/* ────────────────────────────────────────────────────────────────────────── */

type NavItem = {
  href: string;
  label: string;
  icon: LucideIcon;
  group: "Pilotage" | "Contenus" | "Communauté" | "Module actif" | "Système";
  perm?: string;
  ownerOnly?: boolean;
};

const NAV: NavItem[] = [
  {
    href: "/admin/",
    label: "Vue d'ensemble",
    icon: LayoutDashboard,
    group: "Pilotage",
    perm: "dashboard",
  },
  {
    href: "/admin/statistiques/",
    label: "Statistiques de l’app",
    icon: ChartNoAxesCombined,
    group: "Pilotage",
    perm: "dashboard",
    ownerOnly: true,
  },
  {
    href: "/admin/exploitation/",
    label: "Centre d’exploitation",
    icon: Command,
    group: "Pilotage",
    perm: "admin_security",
    ownerOnly: true,
  },
  {
    href: "/admin/pilotage-avance/",
    label: "Pilotage premium",
    icon: Gauge,
    group: "Pilotage",
    perm: "admin_security",
    ownerOnly: true,
  },
  {
    href: "/admin/demo/",
    label: "Mode démonstration",
    icon: MonitorPlay,
    group: "Pilotage",
    perm: "admin_security",
    ownerOnly: true,
  },
  {
    href: "/admin/coach/",
    label: "Coach pédagogique",
    icon: BrainCircuit,
    group: "Pilotage",
    perm: "admin_security",
    ownerOnly: true,
  },
  {
    href: "/admin/signalements/",
    label: "Signalements",
    icon: Flag,
    group: "Pilotage",
    perm: "flags",
  },
  {
    href: "/admin/cas-pratiques/",
    label: "Cas pratiques",
    icon: ClipboardCheck,
    group: "Contenus",
    perm: "cas_pratiques",
  },
  {
    href: "/admin/appels/",
    label: "Appels élèves",
    icon: FileClock,
    group: "Contenus",
    perm: "cas_pratiques",
  },
  {
    href: "/admin/contenus/",
    label: "Pilotage pédagogique",
    icon: LibraryBig,
    group: "Contenus",
    perm: "quiz.write",
  },
  {
    href: "/admin/quiz/",
    label: "Quiz de scolarité",
    icon: GraduationCap,
    group: "Contenus",
    perm: "quiz.write",
  },
  {
    href: "/admin/cours/",
    label: "Fiches de cours",
    icon: BookOpenText,
    group: "Contenus",
    perm: "quiz.write",
  },
  {
    href: "/admin/informations/",
    label: "Centre d'information",
    icon: Info,
    group: "Contenus",
    perm: "dashboard",
  },
  {
    href: "/admin/sante/",
    label: "Santé du contenu",
    icon: HeartPulse,
    group: "Contenus",
    perm: "cas_pratiques",
  },
  {
    href: "/admin/forum/",
    label: "Modération forum",
    icon: MessageSquareMore,
    group: "Communauté",
    perm: "flags",
  },
  {
    href: "/admin/utilisateurs/",
    label: "Utilisateurs",
    icon: Users,
    group: "Communauté",
    perm: "users",
  },
  {
    href: "/admin/messages/",
    label: "Messages utilisateurs",
    icon: Mail,
    group: "Communauté",
    perm: "admin_security",
    ownerOnly: true,
  },
  {
    href: "/admin/abonnements/",
    label: "Abonnements",
    icon: BadgeEuro,
    group: "Communauté",
    perm: "subscriptions",
  },
  {
    href: "/admin/actif/",
    label: "Gestion du module actif",
    icon: ShieldCheck,
    group: "Module actif",
    perm: "admin_security",
    ownerOnly: true,
  },
  {
    href: "/admin/patch-notes/",
    label: "Notes de patch",
    icon: FilePenLine,
    group: "Système",
    perm: "dashboard",
  },
  {
    href: "/admin/versions/",
    label: "Versions mobiles",
    icon: Smartphone,
    group: "Système",
    perm: "admin_security",
    ownerOnly: true,
  },
  {
    href: "/admin/administrateurs/",
    label: "Administrateurs",
    icon: ShieldCheck,
    group: "Système",
    perm: "admin_security",
  },
  {
    href: "/admin/journal/",
    label: "Journal d'audit",
    icon: Activity,
    group: "Système",
    perm: "admin_security",
  },
];

export function AdminShell({
  session,
  children,
}: {
  session: AdminSession;
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const [open, setOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(false);
  const [paletteOpen, setPaletteOpen] = useState(false);
  const [paletteQuery, setPaletteQuery] = useState("");
  const { resolvedTheme, setTheme } = useTheme();
  const perms = session.permissions ?? {};
  const isOwner = session.role === "owner";
  const visible = NAV.filter(
    (n) => (!n.ownerOnly || isOwner) && (!n.perm || isOwner || perms[n.perm]),
  );
  const paletteItems = visible.filter((item) => item.label.toLocaleLowerCase("fr-FR").includes(paletteQuery.trim().toLocaleLowerCase("fr-FR")));

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent) => {
      if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
        event.preventDefault();
        setPaletteOpen(true);
      }
      if (event.key === "Escape") setPaletteOpen(false);
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  return (
    <div className="admin-shell min-h-screen bg-[var(--surface-container)] selection:bg-[var(--brand)]/20">
      {/* Barre supérieure */}
      <header className="admin-topbar sticky top-0 z-40 flex h-[76px] items-center justify-between border-b border-white/10 bg-[var(--surface)]/80 px-4 backdrop-blur-2xl md:px-6">
        <div className="flex items-center gap-3">
          <button
            onClick={() => setOpen((v) => !v)}
            className="rounded-xl p-2 transition hover:bg-[var(--surface-container)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] md:hidden"
            aria-label={open ? "Fermer le menu" : "Ouvrir le menu"}
            aria-expanded={open}
          >
            {open ? <X size={20} /> : <Menu size={20} />}
          </button>
          <Link href="/admin/" className="group flex items-center gap-3 rounded-2xl focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[var(--brand)]">
            <span className="admin-brand-logo relative grid h-12 w-12 shrink-0 place-items-center rounded-2xl p-[2px]">
              <span className="relative z-[1] grid h-full w-full place-items-center overflow-hidden rounded-[14px] bg-[#080d24]">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src="https://nuoonagnkhbeeymtvrcn.supabase.co/storage/v1/object/public/assets/logo_gris.png" alt="" className="h-10 w-10 object-contain transition duration-300 group-hover:scale-110" />
              </span>
            </span>
            <span className="leading-tight"><span className="block text-base font-semibold tracking-[-.02em]">COP&apos;IQ <span className="font-normal text-[var(--on-surface-faint)]">Admin</span></span><span className="mt-0.5 hidden text-[10px] font-medium uppercase tracking-[.18em] text-[var(--brand)] sm:block">Centre de pilotage</span></span>
          </Link>
        </div>
        <div className="flex items-center gap-3">
          <button
            type="button"
            onClick={() => { setPaletteQuery(""); setPaletteOpen(true); }}
            className="hidden min-h-10 items-center gap-2 rounded-xl border border-[var(--outline-variant)] bg-[var(--surface-container)] px-3 text-xs text-[var(--on-surface-muted)] transition hover:border-[var(--brand)]/40 hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] lg:inline-flex"
            aria-label="Rechercher dans le panel"
          >
            <Search size={15} aria-hidden="true" />
            <span>Rechercher</span>
            <kbd className="rounded-md border border-[var(--outline-variant)] px-1.5 py-0.5 text-[10px]">⌘K</kbd>
          </button>
          <span className="hidden max-w-48 truncate text-xs text-[var(--on-surface-muted)] lg:inline">
            {session.email}
          </span>
          <span className="rounded-full bg-[var(--brand)]/10 px-2.5 py-1 text-[11px] font-medium uppercase tracking-wide text-[var(--brand)]">
            {session.role}
          </span>
          {session.aal === "aal2" && (
            <span
              title="Double authentification active"
              className="rounded-full bg-[var(--success)]/10 px-2 py-1 text-[11px] text-[var(--success)]"
            >
              2FA
            </span>
          )}
          <button
            onClick={() =>
              setTheme(resolvedTheme === "dark" ? "light" : "dark")
            }
            className="rounded-xl p-2 text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
            aria-label={
              resolvedTheme === "dark"
                ? "Activer le thème clair"
                : "Activer le thème sombre"
            }
          >
            {resolvedTheme === "dark" ? (
              <Sun size={18} />
            ) : (
              <MoonStar size={18} />
            )}
          </button>
          <button
            onClick={async () => {
              sessionStorage.removeItem("copiq_admin_code_ok");
              await adminAuth.signOut();
              location.href = "/admin/";
            }}
            className="inline-flex items-center gap-2 rounded-xl px-2.5 py-2 text-xs text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--danger)]"
          >
            <LogOut size={16} />{" "}
            <span className="hidden sm:inline">Quitter</span>
          </button>
        </div>
      </header>

      {paletteOpen && (
        <div className="fixed inset-0 z-50 flex items-start justify-center bg-slate-950/55 px-4 pt-[12vh] backdrop-blur-sm" role="presentation" onMouseDown={(event) => { if (event.target === event.currentTarget) setPaletteOpen(false) }}>
          <div role="dialog" aria-modal="true" aria-labelledby="admin-palette-title" className="w-full max-w-xl overflow-hidden rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] shadow-[0_30px_100px_rgba(0,0,0,.35)] motion-safe:animate-[admin-page-enter_180ms_ease-out]">
            <div className="flex items-center gap-3 border-b border-[var(--outline-variant)] px-4">
              <Search size={18} className="shrink-0 text-[var(--brand)]" aria-hidden="true" />
              <label htmlFor="admin-command-search" className="sr-only">Rechercher une page</label>
              <input id="admin-command-search" autoFocus value={paletteQuery} onChange={(event) => setPaletteQuery(event.target.value)} placeholder="Aller vers une section…" className="min-h-14 min-w-0 flex-1 bg-transparent text-sm outline-none placeholder:text-[var(--on-surface-faint)]" />
              <button type="button" onClick={() => setPaletteOpen(false)} className="rounded-lg p-1.5 text-[var(--on-surface-faint)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]" aria-label="Fermer la recherche"><X size={17} /></button>
            </div>
            <div className="max-h-[min(55vh,420px)] overflow-y-auto p-2">
              <p id="admin-palette-title" className="px-3 py-2 text-[10px] font-semibold uppercase tracking-[.16em] text-[var(--on-surface-faint)]">Navigation rapide</p>
              {paletteItems.length === 0 ? <p className="px-3 py-8 text-center text-sm text-[var(--on-surface-muted)]">Aucune section trouvée.</p> : paletteItems.map((item) => { const Icon = item.icon; return <Link key={item.href} href={item.href} onClick={() => setPaletteOpen(false)} className="flex min-h-12 items-center gap-3 rounded-xl px-3 text-sm text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-[var(--brand)]"><span className="grid h-8 w-8 place-items-center rounded-lg bg-[var(--brand)]/10 text-[var(--brand)]"><Icon size={16} /></span><span className="flex-1 truncate">{item.label}</span><span className="text-[10px] text-[var(--on-surface-faint)]">{item.group}</span><ChevronRight size={15} className="text-[var(--on-surface-faint)]" /></Link> })}
            </div>
            <div className="flex items-center justify-between border-t border-[var(--outline-variant)] px-4 py-2 text-[10px] text-[var(--on-surface-faint)]"><span>Utilise les permissions de ton compte</span><span>Échap pour fermer</span></div>
          </div>
        </div>
      )}

      <div className="flex items-start">
        {/* Barre latérale */}
        <aside
          className={`${open ? "block" : "hidden"} admin-sidebar fixed inset-x-0 top-[76px] z-30 max-h-[calc(100vh-76px)] overflow-y-auto border-b border-[var(--outline-variant)] bg-[var(--surface)]/95 p-3 shadow-2xl backdrop-blur-2xl md:sticky md:top-[76px] md:block md:h-[calc(100vh-76px)] md:max-h-none md:shrink-0 md:border-b-0 md:border-r md:shadow-none ${collapsed ? "md:w-24" : "md:w-72"} transition-[width] duration-300`}
        >
          <nav aria-label="Navigation d'administration" className="space-y-5">
            {(["Pilotage", "Contenus", "Communauté", "Module actif", "Système"] as const).map(
              (group) => {
                const items = visible.filter((item) => item.group === group);
                if (items.length === 0) return null;
                return (
                  <div key={group}>
                    {!collapsed && (
                      <p className="mb-1.5 px-3 text-[10px] font-semibold uppercase tracking-[0.16em] text-[var(--on-surface-faint)]">
                        {group}
                      </p>
                    )}
                    <div className="space-y-1">
                      {items.map((n) => {
                        const active =
                          pathname === n.href ||
                          pathname === n.href.slice(0, -1);
                        const Icon = n.icon;
                        return (
                          <Link
                            key={n.href}
                            href={n.href}
                            onClick={() => setOpen(false)}
                            title={collapsed ? n.label : undefined}
                          className={`admin-nav-link group flex min-h-12 items-center rounded-2xl px-3.5 text-sm transition duration-200 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)] ${collapsed ? "justify-center" : "gap-3"} ${
                              active
                                ? "admin-nav-active font-semibold text-white"
                                : "text-[var(--on-surface-muted)] hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)]"
                            }`}
                          >
                            <Icon
                              size={18}
                              strokeWidth={active ? 2.3 : 1.8}
                              aria-hidden="true"
                            />
                            {!collapsed && (
                              <span className="truncate">{n.label}</span>
                            )}
                          </Link>
                        );
                      })}
                    </div>
                  </div>
                );
              },
            )}
          </nav>
          <button
            onClick={() => setCollapsed((value) => !value)}
            className="absolute bottom-4 right-3 hidden rounded-xl border border-[var(--outline-variant)] bg-[var(--surface)] p-2 text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container)] hover:text-[var(--on-surface)] md:block"
            aria-label={
              collapsed ? "Agrandir la navigation" : "Réduire la navigation"
            }
          >
            {collapsed ? <ChevronRight size={17} /> : <ChevronLeft size={17} />}
          </button>
        </aside>

        <main className="admin-main min-w-0 flex-1 p-4 md:p-7 lg:p-10">
          <div key={pathname} className="admin-page-enter mx-auto w-full max-w-[1600px]">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}

/* ────────────────────────────────────────────────────────────────────────── */
/*  Primitives                                                                */
/* ────────────────────────────────────────────────────────────────────────── */

export function PageHeader({
  title,
  subtitle,
  action,
}: {
  title: string;
  subtitle?: string;
  action?: React.ReactNode;
}) {
  return (
    <div className="admin-page-header mb-7 flex flex-wrap items-end justify-between gap-4">
      <div>
        <div className="mb-3 h-1 w-14 rounded-full bg-[linear-gradient(90deg,#1d4ed8_0_33%,#f8fafc_33%_66%,#ef4444_66%)] shadow-[0_0_18px_rgba(59,130,246,.3)]" />
        <h1 className="text-2xl font-semibold tracking-[-.025em] md:text-3xl">{title}</h1>
        {subtitle && (
          <p className="mt-0.5 text-sm text-[var(--on-surface-muted)]">
            {subtitle}
          </p>
        )}
      </div>
      {action}
    </div>
  );
}

export function Card({
  children,
  className = "",
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={`admin-card rounded-2xl border border-[var(--outline-variant)] bg-[var(--surface)] ${className}`}
    >
      {children}
    </div>
  );
}

export function Stat({
  label,
  value,
  hint,
  tone = "neutral",
}: {
  label: string;
  value: React.ReactNode;
  hint?: string;
  tone?: "neutral" | "good" | "warn" | "bad";
}) {
  const colors = {
    neutral: "text-[var(--on-surface)]",
    good: "text-[var(--success)]",
    warn: "text-[var(--warning)]",
    bad: "text-[var(--danger)]",
  };
  return (
    <Card className="admin-stat p-5">
      <div className="text-[11px] font-medium uppercase tracking-wide text-[var(--on-surface-faint)]">
        {label}
      </div>
      <div
        className={`mt-2 text-3xl font-semibold tracking-[-.03em] tabular-nums ${colors[tone]}`}
      >
        {value}
      </div>
      {hint && (
        <div className="mt-0.5 text-xs text-[var(--on-surface-muted)]">
          {hint}
        </div>
      )}
    </Card>
  );
}

export function Badge({
  children,
  tone = "neutral",
}: {
  children: React.ReactNode;
  tone?: "neutral" | "good" | "warn" | "bad" | "brand";
}) {
  const map = {
    neutral: "bg-[var(--surface-container-hi)] text-[var(--on-surface-muted)]",
    good: "bg-[var(--success)]/12 text-[var(--success)]",
    warn: "bg-[var(--warning)]/15 text-[var(--warning)]",
    bad: "bg-[var(--danger)]/12 text-[var(--danger)]",
    brand: "bg-[var(--brand)]/10 text-[var(--brand)]",
  };
  return (
    <span
      className={`inline-flex items-center rounded-full px-2 py-0.5 text-[11px] font-medium ${map[tone]}`}
    >
      {children}
    </span>
  );
}

export function Button({
  variant = "primary",
  className = "",
  ...rest
}: React.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: "primary" | "ghost" | "danger";
}) {
  const map = {
    primary: "bg-[var(--brand)] text-white hover:brightness-110",
    ghost:
      "border border-[var(--outline)] text-[var(--on-surface-muted)] hover:bg-[var(--surface-container)]",
    danger: "bg-[var(--danger)] text-white hover:brightness-110",
  };
  return (
    <button
      {...rest}
      className={`min-h-11 cursor-pointer rounded-xl px-4 py-2.5 text-sm font-semibold shadow-sm transition duration-200 hover:-translate-y-0.5 disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:translate-y-0 ${map[variant]} ${className}`}
    />
  );
}

export function Loading({ label = "Chargement…" }: { label?: string }) {
  return (
    <div className="flex items-center gap-2.5 p-8 text-sm text-[var(--on-surface-muted)]">
      <span className="h-4 w-4 animate-spin rounded-full border-2 border-[var(--brand)] border-t-transparent" />
      {label}
    </div>
  );
}

export function ErrorBox({ error }: { error: unknown }) {
  if (!error) return null;
  const msg = error instanceof Error ? error.message : String(error);
  return (
    <Card className="border-[var(--danger)]/30 bg-[var(--danger)]/5 p-4">
      <div className="text-sm font-medium text-[var(--danger)]">Erreur</div>
      <div className="mt-1 text-sm text-[var(--on-surface-muted)]">{msg}</div>
    </Card>
  );
}

export function Empty({ children }: { children: React.ReactNode }) {
  return (
    <div className="p-10 text-center text-sm text-[var(--on-surface-muted)]">
      {children}
    </div>
  );
}

/** Hook de chargement de données avec gestion d'erreur et rafraîchissement. */
export function useAsync<T>(
  fn: () => Promise<T>,
  deps: React.DependencyList = [],
) {
  const [data, setData] = useState<T | null>(null);
  const [error, setError] = useState<unknown>(null);
  const [loading, setLoading] = useState(true);
  const [tick, setTick] = useState(0);

  useEffect(() => {
    let alive = true;
    // L'état doit repasser en chargement dès qu'une dépendance ou un rechargement change.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setLoading(true);
    setError(null);
    fn()
      .then((d) => alive && setData(d))
      .catch((e) => alive && setError(e))
      .finally(() => alive && setLoading(false));
    return () => {
      alive = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [...deps, tick]);

  return { data, error, loading, reload: () => setTick((t) => t + 1) };
}
