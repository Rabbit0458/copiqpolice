"use client";

import { useEffect, useState } from "react";
import { CalendarDays, History, LoaderCircle, Sparkles } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { RichText } from "@/components/information/editorial-content";

type Note = {
  id: number;
  title: string;
  summary: string | null;
  body: string;
  published_at: string;
};
export default function UpdatesPage() {
  const [notes, setNotes] = useState<Note[]>([]),
    [loading, setLoading] = useState(true);
  useEffect(() => {
    let active = true;
    // La RPC vient d'une migration plus récente que le fichier de types généré.
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const sb = createClient() as any;
    sb.rpc("list_public_patch_notes", { p_limit: 100 })
      .then(({ data }: { data: Note[] | null }) => {
        if (active) setNotes(data ?? []);
      })
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, []);
  return (
    <main className="mx-auto max-w-4xl px-4 py-12 sm:py-16">
      <header className="text-center">
        <div className="mx-auto grid h-14 w-14 place-items-center rounded-2xl bg-[var(--brand)]/10 text-[var(--brand)]">
          <History size={26} />
        </div>
        <h1 className="mt-5 text-3xl font-bold tracking-tight text-[var(--on-surface)] sm:text-4xl">
          COP’IQ évolue avec toi.
        </h1>
        <p className="mx-auto mt-3 max-w-2xl text-[var(--on-surface-muted)]">
          Nouveaux contenus, améliorations et corrections : retrouve ici chaque
          évolution publiée.
        </p>
      </header>
      <div className="mt-10">
        {loading ? (
          <div className="flex justify-center py-16 text-[var(--on-surface-muted)]">
            <LoaderCircle className="mr-2 animate-spin" size={18} /> Chargement…
          </div>
        ) : notes.length === 0 ? (
          <div className="rounded-3xl border border-[var(--outline)] bg-[var(--surface)] p-10 text-center">
            <Sparkles className="mx-auto text-[var(--brand)]" />
            <h2 className="mt-4 font-semibold">
              Les prochaines nouveautés apparaîtront ici
            </h2>
            <p className="mt-2 text-sm text-[var(--on-surface-muted)]">
              Aucune note de mise à jour n’est publiée pour le moment.
            </p>
          </div>
        ) : (
          <div className="relative space-y-5 before:absolute before:bottom-8 before:left-5 before:top-8 before:w-px before:bg-[var(--outline)] sm:before:left-7">
            {notes.map((note, index) => (
              <article
                key={note.id}
                className="relative rounded-3xl border border-[var(--outline)] bg-[var(--surface)] p-6 pl-14 shadow-[0_12px_32px_rgba(15,23,42,.04)] sm:p-8 sm:pl-20"
              >
                <span className="absolute left-[11px] top-8 grid h-7 w-7 place-items-center rounded-full border-4 border-[var(--surface)] bg-[var(--brand)] text-white sm:left-[17px]">
                  <Sparkles size={11} />
                </span>
                {index === 0 && (
                  <span className="mb-3 inline-flex rounded-full bg-[var(--brand)]/10 px-2.5 py-1 text-xs font-semibold text-[var(--brand)]">
                    Dernière mise à jour
                  </span>
                )}
                <h2 className="text-xl font-bold text-[var(--on-surface)]">
                  {note.title}
                </h2>
                {note.summary && (
                  <p className="mt-2 text-sm text-[var(--on-surface-muted)]">
                    {note.summary}
                  </p>
                )}
                <div className="mb-5 mt-2 flex items-center gap-2 text-xs text-[var(--on-surface-faint)]">
                  <CalendarDays size={14} />
                  {new Date(note.published_at).toLocaleDateString("fr-FR", {
                    dateStyle: "long",
                  })}
                </div>
                <RichText value={note.body} />
              </article>
            ))}
          </div>
        )}
      </div>
    </main>
  );
}
