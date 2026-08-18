"use client";

import Link from "next/link";
import {
  ArrowRight,
  BookOpenCheck,
  CircleCheck,
  FileText,
  Headphones,
  HelpCircle,
  History,
  ShieldCheck,
} from "lucide-react";
import {
  EditorialError,
  EditorialLoading,
  RichText,
  usePublishedInformation,
} from "./editorial-content";

export function InformationHub() {
  const info = usePublishedInformation("information");
  const status = usePublishedInformation("service_status");
  const current = status.data[0];
  const operational = current?.metadata?.state !== "incident";
  return (
    <main className="mx-auto max-w-6xl px-4 py-10 sm:py-16">
      <section className="relative overflow-hidden rounded-[32px] border border-[var(--outline)] bg-[var(--surface)] px-6 py-10 shadow-[0_20px_60px_rgba(15,23,42,.08)] sm:px-10 sm:py-14">
        <div className="absolute -right-24 -top-24 h-64 w-64 rounded-full bg-[var(--brand)]/10 blur-3xl" />
        <div className="relative max-w-3xl">
          <span className="mb-5 inline-flex items-center gap-2 rounded-full bg-[var(--brand)]/10 px-3 py-1.5 text-xs font-semibold text-[var(--brand)]">
            <BookOpenCheck size={14} /> Centre d&apos;information COP’IQ
          </span>
          <h1 className="text-3xl font-bold tracking-[-.04em] text-[var(--on-surface)] sm:text-5xl">
            Toutes les réponses, au même endroit.
          </h1>
          <p className="mt-4 max-w-2xl text-base leading-7 text-[var(--on-surface-muted)] sm:text-lg">
            Comprendre COP’IQ, obtenir de l’aide, consulter les informations
            légales et suivre les nouveautés de la plateforme.
          </p>
        </div>
      </section>
      <section className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <HubCard
          href="/faq/"
          icon={HelpCircle}
          title="Questions fréquentes"
          description="Abonnement, accès Premium, cours, quiz et utilisation."
        />
        <HubCard
          href="/contact/"
          icon={Headphones}
          title="Contacter le support"
          description="Transmets une demande et suis sa prise en charge."
        />
        <HubCard
          href="/notes-de-mise-a-jour/"
          icon={History}
          title="Notes de mise à jour"
          description="Découvre les dernières améliorations de COP’IQ."
        />
        <HubCard
          href="/mentions-legales/"
          icon={FileText}
          title="Mentions légales"
          description="Éditeur, hébergement et propriété intellectuelle."
        />
        <HubCard
          href="/privacy/"
          icon={ShieldCheck}
          title="Confidentialité"
          description="Comprends comment tes données sont protégées."
        />
        <div className="rounded-3xl border border-[var(--outline)] bg-[var(--surface)] p-6">
          <div
            className={`mb-4 grid h-11 w-11 place-items-center rounded-2xl ${operational ? "bg-emerald-500/10 text-emerald-600" : "bg-amber-500/10 text-amber-700"}`}
          >
            <CircleCheck size={21} />
          </div>
          <h2 className="font-semibold text-[var(--on-surface)]">
            État des services
          </h2>
          <p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">
            {(current?.metadata?.label as string) ||
              "Vérification de l’état des services…"}
          </p>
          <span
            className={`mt-4 inline-flex rounded-full px-2.5 py-1 text-xs font-semibold ${operational ? "bg-emerald-500/10 text-emerald-700 dark:text-emerald-300" : "bg-amber-500/10 text-amber-700 dark:text-amber-300"}`}
          >
            {operational ? "Opérationnel" : "Incident en cours"}
          </span>
        </div>
      </section>
      <section className="mt-10 rounded-3xl border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-8">
        <h2 className="mb-5 text-xl font-bold text-[var(--on-surface)]">
          À propos de COP’IQ
        </h2>
        {info.loading ? (
          <EditorialLoading />
        ) : info.error ? (
          <EditorialError />
        ) : (
          <div className="space-y-7">
            {info.data.map((item) => (
              <article key={item.id}>
                <h3 className="mb-2 text-lg font-semibold text-[var(--on-surface)]">
                  {item.title}
                </h3>
                {item.summary && (
                  <p className="mb-3 text-[var(--on-surface-muted)]">
                    {item.summary}
                  </p>
                )}
                <RichText value={item.body_md} />
              </article>
            ))}
          </div>
        )}
      </section>
    </main>
  );
}

function HubCard({
  href,
  icon: Icon,
  title,
  description,
}: {
  href: string;
  icon: typeof HelpCircle;
  title: string;
  description: string;
}) {
  return (
    <Link
      href={href}
      className="group cursor-pointer rounded-3xl border border-[var(--outline)] bg-[var(--surface)] p-6 transition-all duration-200 hover:-translate-y-0.5 hover:border-[var(--brand)]/35 hover:shadow-[0_14px_34px_rgba(15,23,42,.08)] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--brand)]"
    >
      <div className="mb-4 grid h-11 w-11 place-items-center rounded-2xl bg-[var(--brand)]/10 text-[var(--brand)]">
        <Icon size={21} />
      </div>
      <div className="flex items-center justify-between gap-3">
        <h2 className="font-semibold text-[var(--on-surface)]">{title}</h2>
        <ArrowRight
          className="text-[var(--on-surface-faint)] transition-transform group-hover:translate-x-1 group-hover:text-[var(--brand)]"
          size={18}
        />
      </div>
      <p className="mt-2 text-sm leading-6 text-[var(--on-surface-muted)]">
        {description}
      </p>
    </Link>
  );
}
