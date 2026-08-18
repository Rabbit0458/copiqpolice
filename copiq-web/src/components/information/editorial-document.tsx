"use client";

import { FileCheck2, ShieldCheck } from "lucide-react";
import type { InformationContentType } from "@/lib/admin/api";
import {
  EditorialError,
  EditorialLoading,
  RichText,
  usePublishedInformation,
} from "./editorial-content";

export function EditorialDocument({
  type,
  title,
  fallback,
  updatedAt,
}: {
  type: Extract<InformationContentType, "legal_notice" | "privacy">;
  title: string;
  fallback: string;
  updatedAt: string;
}) {
  const { data, loading, error } = usePublishedInformation(type);
  const item = data[0];
  const Icon = type === "privacy" ? ShieldCheck : FileCheck2;
  return (
    <main className="mx-auto max-w-4xl px-4 py-10 sm:py-16">
      <header className="rounded-[30px] border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-9">
        <div className="grid h-12 w-12 place-items-center rounded-2xl bg-[var(--brand)]/10 text-[var(--brand)]">
          <Icon size={23} />
        </div>
        <h1 className="mt-5 text-3xl font-bold tracking-tight text-[var(--on-surface)] sm:text-4xl">
          {item?.title || title}
        </h1>
        {item?.summary && (
          <p className="mt-3 max-w-2xl text-[var(--on-surface-muted)]">
            {item.summary}
          </p>
        )}
        <p className="mt-5 text-xs font-medium uppercase tracking-[.1em] text-[var(--on-surface-faint)]">
          Dernière mise à jour :{" "}
          {item?.updated_at
            ? new Date(item.updated_at).toLocaleDateString("fr-FR", {
                dateStyle: "long",
              })
            : updatedAt}
        </p>
      </header>
      <article className="mt-5 rounded-[30px] border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-9">
        {loading ? (
          <EditorialLoading />
        ) : error ? (
          <>
            <EditorialError />
            <div className="mt-6">
              <RichText value={fallback} />
            </div>
          </>
        ) : (
          <RichText value={item?.body_md || fallback} />
        )}
      </article>
    </main>
  );
}
