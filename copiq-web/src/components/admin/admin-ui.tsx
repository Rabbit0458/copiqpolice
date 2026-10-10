"use client";

/**
 * COP'IQ — Briques d'interface partagées du panel administrateur.
 * Design V5 (octobre 2026) : navigation bleu nuit avec le logo officiel,
 * barre supérieure légère, cartes et boutons alignés sur copiq.fr.
 * Navigation, permissions et logique de session inchangées.
 */

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useLayoutEffect, useRef, useState } from "react";
import {
  Activity,
  BadgeEuro,
  ChartNoAxesCombined,
  BookOpenText,
  ChevronLeft,
  ChevronRight,
  ClipboardCheck,
  Command,
  ExternalLink,
  FileClock,
  FilePenLine,
  Flag,
  GraduationCap,
  Gauge,
  HeartPulse,
  Inbox,
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
  TriangleAlert,
  Users,
  X,
  type LucideIcon,
} from "lucide-react";
import { useTheme } from "next-themes";
import { adminAuth, type AdminSession } from "@/lib/admin/api";
import { COPIQ_LOGO_PNG } from "@/components/home/brand";

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

const GROUPS = ["Pilotage", "Contenus", "Communauté", "Module actif", "Système"] as const;

/** Page courante : correspondance la plus longue dans la navigation. */
function currentItem(pathname: string) {
  const path = pathname.endsWith("/") ? pathname : `${pathname}/`;
  return [...NAV]
    .sort((a, b) => b.href.length - a.href.length)
    .find((n) => (n.href === "/admin/" ? path === "/admin/" : path.startsWith(n.href)));
}

function initials(email: string | undefined) {
  const name = (email ?? "").split("@")[0].replace(/[^a-zA-Z]/g, " ").trim();
  const parts = name.split(/\s+/).filter(Boolean);
  return ((parts[0]?.[0] ?? "A") + (parts[1]?.[0] ?? parts[0]?.[1] ?? "")).toUpperCase();
}

const ROLE_LABEL: Record<string, string> = {
  owner: "Propriétaire",
  admin: "Administrateur",
  editor: "Éditeur",
  moderator: "Modérateur",
};

export function AdminShell({
  session,
  children,
}: {
  session: AdminSession;
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const navRef = useRef<HTMLElement | null>(null);
  const indicatorRef = useRef<HTMLSpanElement | null>(null);
  const mainRef = useRef<HTMLElement | null>(null);
  const [open, setOpen] = useState(false);
  const [collapsed, setCollapsed] = useState(false);
  const [paletteOpen, setPaletteOpen] = useState(false);
  const [paletteQuery, setPaletteQuery] = useState("");
  const [paletteIndex, setPaletteIndex] = useState(0);
  const { resolvedTheme, setTheme } = useTheme();
  const perms = session.permissions ?? {};
  const isOwner = session.role === "owner";
  const visible = NAV.filter(
    (n) => (!n.ownerOnly || isOwner) && (!n.perm || isOwner || perms[n.perm]),
  );
  const q = paletteQuery.trim().toLocaleLowerCase("fr-FR");
  const paletteItems = visible.filter((item) =>
    `${item.label} ${item.group}`.toLocaleLowerCase("fr-FR").includes(q),
  );
  const current = currentItem(pathname);

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent) => {
      if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
        event.preventDefault();
        setPaletteQuery("");
        setPaletteIndex(0);
        setPaletteOpen(true);
      }
      if (event.key === "Escape") {
        setPaletteOpen(false);
        setOpen(false);
      }
    };
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  // Le menu mobile se referme à chaque changement de page.
  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setOpen(false);
  }, [pathname]);


  /* Pastille active qui glisse d'un lien à l'autre dans la navigation. */
  useLayoutEffect(() => {
    const nav = navRef.current;
    const pill = indicatorRef.current;
    if (!nav || !pill) return;
    const place = () => {
      const link = nav.querySelector<HTMLElement>('a[aria-current="page"]');
      if (!link) {
        pill.style.opacity = "0";
        return;
      }
      pill.style.transform = `translate3d(0, ${link.offsetTop}px, 0)`;
      pill.style.height = `${link.offsetHeight}px`;
      pill.style.opacity = "1";
    };
    place();
    window.addEventListener("resize", place);
    return () => window.removeEventListener("resize", place);
  }, [pathname, collapsed, visible.length]);

  /*
   * Mouvement du contenu :
   *  - chaque carte apparaît en douceur quand elle entre à l'écran, en
   *    cascade, y compris celles chargées plus tard (données asynchrones) ;
   *  - un halo de lumière suit le pointeur sur la carte survolée.
   * Rien de tout cela si l'utilisateur préfère réduire les animations.
   */
  useEffect(() => {
    const main = mainRef.current;
    if (!main) return;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    main.classList.add("admin-reveal-ready");
    const io = new IntersectionObserver(
      (entries) => {
        let rank = 0;
        for (const entry of entries) {
          if (!entry.isIntersecting) continue;
          const el = entry.target as HTMLElement;
          el.style.setProperty("--rd", `${Math.min(rank++, 10) * 55}ms`);
          el.classList.add("is-in");
          io.unobserve(el);
        }
      },
      { rootMargin: "0px 0px -4% 0px", threshold: 0.04 },
    );
    const watch = () => {
      main.querySelectorAll<HTMLElement>(".admin-card:not([data-reveal])").forEach((el) => {
        el.dataset.reveal = "";
        io.observe(el);
      });
    };
    watch();
    const mo = new MutationObserver(watch);
    mo.observe(main, { childList: true, subtree: true });

    let frame = 0;
    const onMove = (event: PointerEvent) => {
      if (event.pointerType !== "mouse" || frame) return;
      frame = requestAnimationFrame(() => {
        frame = 0;
        const card = (event.target as Element | null)?.closest<HTMLElement>(".admin-card");
        if (!card) return;
        const r = card.getBoundingClientRect();
        card.style.setProperty("--mx", `${event.clientX - r.left}px`);
        card.style.setProperty("--my", `${event.clientY - r.top}px`);
      });
    };
    main.addEventListener("pointermove", onMove, { passive: true });
    return () => {
      io.disconnect();
      mo.disconnect();
      main.removeEventListener("pointermove", onMove);
      cancelAnimationFrame(frame);
    };
  }, []);

  async function quit() {
    sessionStorage.removeItem("copiq_admin_code_ok");
    await adminAuth.signOut();
    location.href = "/admin/";
  }

  return (
    <div className="admin-shell min-h-screen">
      {/* ── Navigation latérale (bleu nuit, toujours) ─────────────────── */}
      {open && (
        <button
          type="button"
          aria-label="Fermer le menu"
          onClick={() => setOpen(false)}
          className="admin-scrim fixed inset-0 z-40 bg-[#00061F]/55 backdrop-blur-[2px] md:hidden"
        />
      )}
      <aside
        className={`admin-sidebar fixed inset-y-0 left-0 z-50 flex w-[284px] flex-col text-white transition-[transform,width,visibility] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] md:visible md:translate-x-0 ${
          open ? "visible translate-x-0" : "max-md:invisible -translate-x-full"
        } ${collapsed ? "md:w-[88px]" : "md:w-[272px]"}`}
        aria-label="Navigation d'administration"
      >
        <div className={`flex h-[72px] shrink-0 items-center ${collapsed ? "md:justify-center md:px-0" : ""} px-5`}>
          <Link href="/admin/" className="group flex min-w-0 items-center gap-3 rounded-xl" aria-label="COP'IQ Admin, vue d'ensemble">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src={COPIQ_LOGO_PNG} alt="" width={52} height={52} className="h-[52px] w-[52px] shrink-0 scale-[1.3] object-contain transition-transform duration-500 group-hover:scale-[1.38]" />
          </Link>
          <button
            type="button"
            onClick={() => setOpen(false)}
            className="ml-auto grid h-10 w-10 place-items-center rounded-xl text-white/60 transition hover:bg-white/10 hover:text-white md:hidden"
            aria-label="Fermer le menu"
          >
            <X size={19} />
          </button>
        </div>
        <span className="cq-tricolore mx-5 h-[2px] shrink-0 rounded-full opacity-80" aria-hidden="true" />

        <nav ref={navRef} className="admin-nav relative min-h-0 flex-1 overflow-y-auto px-3 py-5">
          <span ref={indicatorRef} className="admin-nav-indicator" aria-hidden="true" />
          {GROUPS.map((group) => {
            const items = visible.filter((item) => item.group === group);
            if (items.length === 0) return null;
            return (
              <div key={group} className="mb-5 last:mb-0">
                <p className={`mb-2 px-3 text-[10.5px] font-semibold uppercase tracking-[0.18em] text-white/35 ${collapsed ? "md:sr-only" : ""}`}>
                  {group}
                </p>
                <ul className="grid gap-0.5">
                  {items.map((n) => {
                    const active = current?.href === n.href;
                    const Icon = n.icon;
                    return (
                      <li key={n.href}>
                        <Link
                          href={n.href}
                          title={collapsed ? n.label : undefined}
                          aria-current={active ? "page" : undefined}
                          className={`admin-nav-link group relative z-[1] flex min-h-11 items-center gap-3 rounded-xl px-3 text-[14px] transition-colors duration-200 ${
                            collapsed ? "md:justify-center md:px-0" : ""
                          } ${active ? "admin-nav-active text-white" : "text-white/62 hover:bg-white/[0.05] hover:text-white"}`}
                        >
                          <Icon size={18} strokeWidth={active ? 2.2 : 1.8} aria-hidden="true" className="shrink-0" />
                          <span className={`truncate ${active ? "font-semibold" : "font-medium"} ${collapsed ? "md:sr-only" : ""}`}>{n.label}</span>
                        </Link>
                      </li>
                    );
                  })}
                </ul>
              </div>
            );
          })}
        </nav>

        {/* Compte connecté */}
        <div className="shrink-0 border-t border-white/[0.08] p-3">
          <div className={`flex items-center gap-3 rounded-2xl bg-white/[0.05] p-2.5 ${collapsed ? "md:justify-center md:bg-transparent md:p-0" : ""}`}>
            <span className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-[linear-gradient(135deg,#1147D9,#3D7BFF)] text-[12.5px] font-bold tracking-wide ring-2 ring-white/10" aria-hidden="true">
              {initials(session.email)}
            </span>
            <span className={`min-w-0 flex-1 ${collapsed ? "md:hidden" : ""}`}>
              <span className="block truncate text-[13px] font-semibold">{session.email}</span>
              <span className="mt-0.5 flex items-center gap-1.5 text-[11.5px] text-white/50">
                {ROLE_LABEL[session.role ?? ""] ?? session.role}
                {session.aal === "aal2" && (
                  <span className="inline-flex items-center gap-1 rounded-full bg-[#16A34A]/20 px-1.5 py-px text-[10.5px] font-semibold text-[#4ADE80]" title="Double authentification active">
                    <ShieldCheck size={11} aria-hidden="true" /> 2FA
                  </span>
                )}
              </span>
            </span>
            <button
              type="button"
              onClick={quit}
              className={`grid h-9 w-9 shrink-0 place-items-center rounded-xl text-white/55 transition hover:bg-[#E0162B]/15 hover:text-[#FF6B7A] ${collapsed ? "md:hidden" : ""}`}
              aria-label="Se déconnecter"
              title="Se déconnecter"
            >
              <LogOut size={17} />
            </button>
          </div>
          <button
            type="button"
            onClick={() => setCollapsed((value) => !value)}
            className="mt-2 hidden h-9 w-full items-center justify-center gap-2 rounded-xl text-[12.5px] font-medium text-white/45 transition hover:bg-white/[0.06] hover:text-white md:flex"
            aria-label={collapsed ? "Agrandir la navigation" : "Réduire la navigation"}
          >
            {collapsed ? <ChevronRight size={16} /> : <><ChevronLeft size={16} /> Réduire</>}
          </button>
        </div>
      </aside>

      {/* ── Zone de travail ───────────────────────────────────────────── */}
      <div className={`transition-[padding] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] ${collapsed ? "md:pl-[88px]" : "md:pl-[272px]"}`}>
        <header className="admin-topbar relative sticky top-0 z-30 flex h-[64px] items-center gap-3 px-4 md:px-8">
          <button
            type="button"
            onClick={() => setOpen(true)}
            className="grid h-10 w-10 place-items-center rounded-xl text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)] md:hidden"
            aria-label="Ouvrir le menu"
            aria-expanded={open}
          >
            <Menu size={20} />
          </button>
          <nav aria-label="Fil d'Ariane" className="flex min-w-0 items-center gap-2 text-[14px]">
            <span className="hidden text-[var(--on-surface-faint)] sm:inline">{current?.group ?? "Pilotage"}</span>
            <ChevronRight size={14} className="hidden shrink-0 text-[var(--on-surface-faint)] sm:block" aria-hidden="true" />
            <span className="truncate font-semibold text-[var(--on-surface)]">{current?.label ?? "Administration"}</span>
          </nav>

          <div className="ml-auto flex items-center gap-1.5 sm:gap-2">
            <button
              type="button"
              onClick={() => { setPaletteQuery(""); setPaletteIndex(0); setPaletteOpen(true); }}
              className="admin-search-btn hidden h-10 items-center gap-2.5 rounded-xl px-3 text-[13px] text-[var(--on-surface-muted)] transition hover:text-[var(--on-surface)] lg:inline-flex"
              aria-label="Rechercher une section"
            >
              <Search size={15} aria-hidden="true" />
              <span className="w-36 text-left">Rechercher…</span>
              <kbd className="rounded-md border border-[var(--outline)] bg-[var(--surface)] px-1.5 py-0.5 font-sans text-[10.5px] font-semibold">⌘K</kbd>
            </button>
            <button
              type="button"
              onClick={() => { setPaletteQuery(""); setPaletteIndex(0); setPaletteOpen(true); }}
              className="grid h-10 w-10 place-items-center rounded-xl text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)] lg:hidden"
              aria-label="Rechercher une section"
            >
              <Search size={18} />
            </button>
            <a
              href="/"
              target="_blank"
              rel="noreferrer"
              className="hidden h-10 items-center gap-2 rounded-xl px-3 text-[13px] font-medium text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)] sm:inline-flex"
            >
              <ExternalLink size={15} aria-hidden="true" /> Voir le site
            </a>
            <button
              type="button"
              onClick={() => setTheme(resolvedTheme === "dark" ? "light" : "dark")}
              className="grid h-10 w-10 place-items-center rounded-xl text-[var(--on-surface-muted)] transition hover:bg-[var(--surface-container-hi)] hover:text-[var(--on-surface)]"
              aria-label={resolvedTheme === "dark" ? "Activer le thème clair" : "Activer le thème sombre"}
            >
              {resolvedTheme === "dark" ? <Sun size={18} /> : <MoonStar size={18} />}
            </button>
          </div>
          {/* Liseré tricolore qui file à chaque changement de page */}
          <span key={pathname} className="admin-route-bar cq-tricolore pointer-events-none absolute inset-x-0 bottom-[-1px] h-[2px]" aria-hidden="true" />
        </header>

        <main ref={mainRef} className="admin-main min-w-0 px-4 pb-16 pt-6 md:px-8 md:pt-8 lg:px-10">
          <div key={pathname} className="admin-page-enter mx-auto w-full max-w-[1520px]">
            {children}
          </div>
        </main>
      </div>

      {/* ── Navigation rapide ⌘K ──────────────────────────────────────── */}
      {paletteOpen && (
        <div
          className="admin-palette-scrim fixed inset-0 z-[60] flex items-start justify-center bg-[#00061F]/50 px-4 pt-[12vh] backdrop-blur-[3px]"
          role="presentation"
          onMouseDown={(event) => { if (event.target === event.currentTarget) setPaletteOpen(false); }}
        >
          <div role="dialog" aria-modal="true" aria-labelledby="admin-palette-title" className="admin-palette w-full max-w-xl overflow-hidden rounded-[22px] border border-[var(--outline)] bg-[var(--surface)] shadow-[0_40px_120px_-30px_rgba(0,6,31,.6)]">
            <div className="flex items-center gap-3 border-b border-[var(--outline-variant)] px-5">
              <Search size={18} className="shrink-0 text-[var(--brand)]" aria-hidden="true" />
              <label htmlFor="admin-command-search" className="sr-only">Rechercher une page</label>
              <input
                id="admin-command-search"
                autoFocus
                value={paletteQuery}
                onChange={(event) => { setPaletteQuery(event.target.value); setPaletteIndex(0); }}
                onKeyDown={(event) => {
                  if (event.key === "ArrowDown") { event.preventDefault(); setPaletteIndex((i) => Math.min(i + 1, paletteItems.length - 1)); }
                  if (event.key === "ArrowUp") { event.preventDefault(); setPaletteIndex((i) => Math.max(i - 1, 0)); }
                  if (event.key === "Enter" && paletteItems[paletteIndex]) {
                    event.preventDefault();
                    setPaletteOpen(false);
                    location.assign(paletteItems[paletteIndex].href);
                  }
                }}
                placeholder="Aller vers une section…"
                className="admin-palette-input min-h-[60px] min-w-0 flex-1 bg-transparent text-[15px] outline-none placeholder:text-[var(--on-surface-faint)]"
              />
              <kbd className="rounded-md border border-[var(--outline)] px-1.5 py-0.5 font-sans text-[10.5px] font-semibold text-[var(--on-surface-faint)]">Échap</kbd>
            </div>
            <div className="max-h-[min(56vh,440px)] overflow-y-auto p-2">
              <p id="admin-palette-title" className="px-3 pb-1.5 pt-2 text-[10.5px] font-semibold uppercase tracking-[.16em] text-[var(--on-surface-faint)]">Navigation rapide</p>
              {paletteItems.length === 0 ? (
                <p className="px-3 py-10 text-center text-sm text-[var(--on-surface-muted)]">Aucune section trouvée.</p>
              ) : (
                paletteItems.map((item, i) => {
                  const Icon = item.icon;
                  const on = i === paletteIndex;
                  return (
                    <Link
                      key={item.href}
                      href={item.href}
                      onClick={() => setPaletteOpen(false)}
                      onMouseEnter={() => setPaletteIndex(i)}
                      style={{ "--i": i } as React.CSSProperties}
                      className={`admin-palette-item flex min-h-12 items-center gap-3 rounded-xl px-3 text-[14px] transition-colors ${on ? "bg-[var(--surface-container)] text-[var(--on-surface)]" : "text-[var(--on-surface-muted)]"}`}
                    >
                      <span className="grid h-8 w-8 place-items-center rounded-lg bg-[var(--brand)]/10 text-[var(--brand)]"><Icon size={16} /></span>
                      <span className="flex-1 truncate font-medium">{item.label}</span>
                      <span className="text-[11px] text-[var(--on-surface-faint)]">{item.group}</span>
                      <ChevronRight size={15} className={`text-[var(--on-surface-faint)] transition-transform ${on ? "translate-x-0.5" : ""}`} />
                    </Link>
                  );
                })
              )}
            </div>
            <div className="flex items-center justify-between border-t border-[var(--outline-variant)] px-5 py-2.5 text-[11px] text-[var(--on-surface-faint)]">
              <span>↑ ↓ pour choisir · Entrée pour ouvrir</span>
              <span>Selon les droits de ton compte</span>
            </div>
          </div>
        </div>
      )}
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
    <div className="admin-page-header mb-8 flex flex-wrap items-end justify-between gap-x-6 gap-y-4">
      <div className="min-w-0">
        <span className="cq-tricolore mb-4 block h-1 w-12 rounded-full" aria-hidden="true" />
        <h1 className="text-[clamp(1.6rem,2.4vw,2.15rem)] font-bold leading-[1.1] tracking-[-0.035em] text-[var(--on-surface)]">{title}</h1>
        {subtitle && (
          <p className="mt-2 max-w-3xl text-[15px] leading-relaxed text-[var(--on-surface-muted)]">
            {subtitle}
          </p>
        )}
      </div>
      {action && <div className="flex flex-wrap items-center gap-2">{action}</div>}
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
  return <div className={`admin-card rounded-[20px] border ${className}`}>{children}</div>;
}

/** Chiffre qui défile jusqu'à sa valeur (une fois visible, puis à chaque mise à jour). */
export function AnimatedNumber({
  value,
  format = (n: number) => Math.round(n).toLocaleString("fr-FR"),
  duration = 1100,
}: {
  value: number;
  format?: (n: number) => string;
  duration?: number;
}) {
  const ref = useRef<HTMLSpanElement | null>(null);
  const shown = useRef(0);
  const fmt = useRef(format);
  useEffect(() => {
    fmt.current = format;
  });

  useLayoutEffect(() => {
    const el = ref.current;
    if (!el) return;
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    if (reduce || !Number.isFinite(value)) {
      shown.current = value;
      el.textContent = fmt.current(value);
      return;
    }
    const from = shown.current;
    el.textContent = fmt.current(from);
    let raf = 0;
    let start = 0;
    const run = () => {
      const step = (t: number) => {
        if (!start) start = t;
        const p = Math.min(1, (t - start) / duration);
        const eased = 1 - Math.pow(2, -10 * p);
        const v = from + (value - from) * (p === 1 ? 1 : eased);
        shown.current = v;
        el.textContent = fmt.current(v);
        if (p < 1) raf = requestAnimationFrame(step);
      };
      raf = requestAnimationFrame(step);
    };
    const io = new IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) {
        io.disconnect();
        run();
      }
    });
    io.observe(el);
    return () => {
      io.disconnect();
      cancelAnimationFrame(raf);
    };
  }, [value, duration]);

  return (
    <span ref={ref} className="tabular-nums" aria-label={format(value)}>
      {format(value)}
    </span>
  );
}

/** Lit « 1 234 », « 87 % » ou « 12,5 » : renvoie la valeur et son suffixe. */
function parseFigure(value: React.ReactNode): { n: number; suffix: string; decimals: number } | null {
  if (typeof value === "number") return Number.isFinite(value) ? { n: value, suffix: "", decimals: Number.isInteger(value) ? 0 : 1 } : null;
  if (typeof value !== "string") return null;
  const m = value.trim().match(/^(-?[\d\s\u202f\u00a0]+(?:[,.]\d+)?)(\s?%|\s?€)?$/);
  if (!m) return null;
  const raw = m[1].replace(/[\s\u202f\u00a0]/g, "").replace(",", ".");
  const n = Number(raw);
  if (!Number.isFinite(n)) return null;
  const decimals = raw.includes(".") ? raw.split(".")[1].length : 0;
  return { n, suffix: m[2] ?? "", decimals };
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
  const dots = {
    neutral: "bg-[var(--brand)]",
    good: "bg-[var(--success)]",
    warn: "bg-[var(--warning)]",
    bad: "bg-[var(--danger)]",
  };
  return (
    <Card className="admin-stat relative overflow-hidden p-5">
      <div className="flex items-center gap-2 text-[12px] font-semibold uppercase tracking-[0.08em] text-[var(--on-surface-faint)]">
        <span className={`h-1.5 w-1.5 rounded-full ${dots[tone]}`} aria-hidden="true" />
        {label}
      </div>
      <div className={`mt-3 text-[2rem] font-bold leading-none tracking-[-0.04em] tabular-nums ${colors[tone]}`}>
        {(() => {
          const fig = parseFigure(value);
          if (!fig) return value;
          return (
            <AnimatedNumber
              value={fig.n}
              format={(n) => n.toLocaleString("fr-FR", { minimumFractionDigits: fig.decimals, maximumFractionDigits: fig.decimals }) + fig.suffix}
            />
          );
        })()}
      </div>
      {hint && <div className="mt-2 text-[13px] leading-snug text-[var(--on-surface-muted)]">{hint}</div>}
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
    warn: "bg-[var(--warning)]/14 text-[color-mix(in_srgb,var(--warning)_75%,var(--on-surface))]",
    bad: "bg-[var(--danger)]/12 text-[var(--danger)]",
    brand: "bg-[var(--brand)]/10 text-[var(--brand)]",
  };
  return (
    <span className={`inline-flex items-center gap-1.5 whitespace-nowrap rounded-full px-2.5 py-1 text-[11.5px] font-semibold leading-none ${map[tone]}`}>
      <span className="h-1.5 w-1.5 rounded-full bg-current opacity-80" aria-hidden="true" />
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
    primary: "admin-btn-primary text-white",
    ghost: "border border-[var(--outline)] bg-[var(--surface)] text-[var(--on-surface)] hover:border-[color-mix(in_srgb,var(--brand)_35%,var(--outline))] hover:bg-[var(--surface-container)]",
    danger: "bg-[var(--danger)] text-white shadow-[0_10px_24px_-12px_var(--danger)] hover:brightness-110",
  };
  return (
    <button
      {...rest}
      className={`inline-flex min-h-11 cursor-pointer items-center justify-center gap-2 rounded-xl px-4 py-2.5 text-[14px] font-semibold transition-[transform,background-color,border-color,box-shadow,filter] duration-300 ease-[cubic-bezier(0.22,1,0.36,1)] hover:-translate-y-0.5 active:translate-y-0 active:scale-[0.98] disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:translate-y-0 ${map[variant]} ${className}`}
    />
  );
}

export function Loading({ label = "Chargement…" }: { label?: string }) {
  return (
    <div className="p-6" role="status" aria-live="polite">
      <span className="sr-only">{label}</span>
      <div className="flex items-center gap-2.5 text-[13.5px] text-[var(--on-surface-muted)]" aria-hidden="true">
        <span className="h-4 w-4 animate-spin rounded-full border-2 border-[var(--brand)] border-t-transparent" />
        {label}
      </div>
      <div className="mt-5 grid gap-2.5" aria-hidden="true">
        {[92, 78, 85].map((w) => (
          <span key={w} className="admin-skeleton h-3.5 rounded-full" style={{ width: `${w}%` }} />
        ))}
      </div>
    </div>
  );
}

export function ErrorBox({ error }: { error: unknown }) {
  if (!error) return null;
  const msg = error instanceof Error ? error.message : String(error);
  return (
    <div role="alert" className="flex items-start gap-3 rounded-2xl border border-[var(--danger)]/25 bg-[var(--danger)]/[0.06] p-4">
      <span className="mt-0.5 grid h-7 w-7 shrink-0 place-items-center rounded-full bg-[var(--danger)]/15 text-[var(--danger)]" aria-hidden="true">
        <TriangleAlert size={15} />
      </span>
      <div className="min-w-0">
        <div className="text-[14px] font-semibold text-[var(--danger)]">Une erreur est survenue</div>
        <div className="mt-0.5 break-words text-[13.5px] text-[var(--on-surface-muted)]">{msg}</div>
      </div>
    </div>
  );
}

export function Empty({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex flex-col items-center gap-3 px-6 py-12 text-center text-[14px] text-[var(--on-surface-muted)]">
      <span className="grid h-11 w-11 place-items-center rounded-2xl bg-[var(--surface-container)] text-[var(--on-surface-faint)]" aria-hidden="true">
        <Inbox size={20} />
      </span>
      <div className="max-w-sm">{children}</div>
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
