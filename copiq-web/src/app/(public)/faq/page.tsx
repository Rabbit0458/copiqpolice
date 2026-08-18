"use client";

import { useMemo, useState } from "react";
import { ChevronDown, HelpCircle, Search } from "lucide-react";
import {
  EditorialError,
  EditorialLoading,
  RichText,
  usePublishedInformation,
} from "@/components/information/editorial-content";

export default function FaqPage() {
  const { data, loading, error } = usePublishedInformation("faq");
  const [search, setSearch] = useState("");
  const [open, setOpen] = useState<string | null>(null);
  const filtered = useMemo(
    () =>
      data.filter((item) =>
        `${item.title} ${item.body_md} ${item.category}`
          .toLowerCase()
          .includes(search.toLowerCase()),
      ),
    [data, search],
  );
  const groups = useMemo(
    () =>
      Object.entries(
        filtered.reduce<Record<string, typeof filtered>>((acc, item) => {
          (acc[item.category] ??= []).push(item);
          return acc;
        }, {}),
      ),
    [filtered],
  );
  return (
    <main className="mx-auto max-w-4xl px-4 py-12 sm:py-16">
      <header className="text-center">
        <div className="mx-auto mb-4 grid h-14 w-14 place-items-center rounded-2xl bg-[var(--brand)]/10 text-[var(--brand)]">
          <HelpCircle size={26} />
        </div>
        <h1 className="text-3xl font-bold tracking-tight text-[var(--on-surface)] sm:text-4xl">
          Comment pouvons-nous t’aider ?
        </h1>
        <p className="mx-auto mt-3 max-w-2xl text-[var(--on-surface-muted)]">
          Retrouve rapidement les réponses sur l’abonnement, les cours, les quiz
          et ton compte.
        </p>
      </header>
      <label className="relative mx-auto mt-8 block max-w-2xl">
        <Search
          className="absolute left-4 top-4 text-[var(--on-surface-faint)]"
          size={20}
        />
        <span className="sr-only">Rechercher dans la FAQ</span>
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Rechercher une réponse…"
          className="min-h-14 w-full rounded-2xl border border-[var(--outline)] bg-[var(--surface)] pl-12 pr-4 text-base outline-none transition focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10"
        />
      </label>
      <div className="mt-10">
        {loading ? (
          <EditorialLoading />
        ) : error ? (
          <EditorialError />
        ) : groups.length === 0 ? (
          <p className="rounded-2xl border border-[var(--outline)] p-8 text-center text-[var(--on-surface-muted)]">
            Aucune réponse ne correspond à cette recherche.
          </p>
        ) : (
          <div className="space-y-9">
            {groups.map(([category, items]) => (
              <section key={category}>
                <h2 className="mb-3 text-sm font-bold uppercase tracking-[.12em] text-[var(--brand)]">
                  {category}
                </h2>
                <div className="space-y-3">
                  {items?.map((item) => {
                    const active = open === item.id;
                    return (
                      <article
                        key={item.id}
                        className="overflow-hidden rounded-2xl border border-[var(--outline)] bg-[var(--surface)]"
                      >
                        <button
                          onClick={() => setOpen(active ? null : item.id)}
                          aria-expanded={active}
                          className="flex min-h-14 w-full cursor-pointer items-center justify-between gap-4 p-4 text-left font-semibold text-[var(--on-surface)] transition hover:bg-[var(--surface-container)] focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-[var(--brand)]"
                        >
                          <span>{item.title}</span>
                          <ChevronDown
                            size={19}
                            className={`shrink-0 transition-transform duration-200 ${active ? "rotate-180 text-[var(--brand)]" : "text-[var(--on-surface-faint)]"}`}
                          />
                        </button>
                        {active && (
                          <div className="border-t border-[var(--outline)] px-4 py-5 sm:px-5">
                            <RichText value={item.body_md} />
                          </div>
                        )}
                      </article>
                    );
                  })}
                </div>
              </section>
            ))}
          </div>
        )}
      </div>
    </main>
  );
}
