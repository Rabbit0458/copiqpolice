"use client";

import { useEffect, useMemo, useState } from "react";
import { AlertCircle, LoaderCircle } from "lucide-react";
import { listPublishedInformation } from "@/lib/information";
import type {
  InformationContent,
  InformationContentType,
} from "@/lib/admin/api";

export function usePublishedInformation(type: InformationContentType) {
  const [data, setData] = useState<InformationContent[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  useEffect(() => {
    let active = true;
    listPublishedInformation(type)
      .then((items) => active && setData(items))
      .catch(() => active && setError(true))
      .finally(() => active && setLoading(false));
    return () => {
      active = false;
    };
  }, [type]);
  return { data, loading, error };
}

export function EditorialLoading() {
  return (
    <div className="flex min-h-48 items-center justify-center text-[var(--on-surface-muted)]">
      <LoaderCircle className="mr-2 animate-spin" size={18} /> Chargement…
    </div>
  );
}

export function EditorialError() {
  return (
    <div className="flex items-center gap-2 rounded-2xl border border-red-200 bg-red-50 p-4 text-sm text-red-800 dark:border-red-900/50 dark:bg-red-950/30 dark:text-red-200">
      <AlertCircle size={18} /> Le contenu est momentanément indisponible.
    </div>
  );
}

export function RichText({ value }: { value: string }) {
  const blocks = useMemo(() => parseMarkdown(value), [value]);
  return (
    <div className="space-y-4 text-[15px] leading-7 text-[var(--on-surface-muted)]">
      {blocks.map((block, index) => {
        if (block.kind === "h2")
          return (
            <h2
              key={index}
              className="pt-3 text-xl font-bold tracking-tight text-[var(--on-surface)]"
            >
              {inline(block.text)}
            </h2>
          );
        if (block.kind === "h3")
          return (
            <h3
              key={index}
              className="pt-2 text-base font-bold text-[var(--on-surface)]"
            >
              {inline(block.text)}
            </h3>
          );
        if (block.kind === "list")
          return (
            <ul key={index} className="space-y-2 pl-5">
              {block.items.map((item, i) => (
                <li key={i} className="list-disc pl-1">
                  {inline(item)}
                </li>
              ))}
            </ul>
          );
        return <p key={index}>{inline(block.text)}</p>;
      })}
    </div>
  );
}

type Block =
  { kind: "h2" | "h3" | "p"; text: string } | { kind: "list"; items: string[] };
function parseMarkdown(value: string): Block[] {
  const result: Block[] = [];
  let paragraph: string[] = [];
  let list: string[] = [];
  const flush = () => {
    if (paragraph.length) result.push({ kind: "p", text: paragraph.join(" ") });
    if (list.length) result.push({ kind: "list", items: [...list] });
    paragraph = [];
    list = [];
  };
  for (const raw of value.split("\n")) {
    const line = raw.trim();
    if (!line) {
      flush();
      continue;
    }
    if (line.startsWith("## ")) {
      flush();
      result.push({ kind: "h2", text: line.slice(3) });
      continue;
    }
    if (line.startsWith("### ")) {
      flush();
      result.push({ kind: "h3", text: line.slice(4) });
      continue;
    }
    if (/^[-*] /.test(line)) {
      if (paragraph.length) flush();
      list.push(line.slice(2));
      continue;
    }
    if (list.length) flush();
    paragraph.push(line);
  }
  flush();
  return result;
}

function inline(value: string) {
  const parts = value.split(/(\*\*[^*]+\*\*)/g);
  return (
    <>
      {parts.map((part, index) =>
        part.startsWith("**") && part.endsWith("**") ? (
          <strong
            key={index}
            className="font-semibold text-[var(--on-surface)]"
          >
            {part.slice(2, -2)}
          </strong>
        ) : (
          <span key={index}>{part}</span>
        ),
      )}
    </>
  );
}
