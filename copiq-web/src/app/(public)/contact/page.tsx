"use client";

import { useState } from "react";
import {
  CheckCircle2,
  Clock3,
  Headphones,
  Send,
  ShieldCheck,
} from "lucide-react";
import { usePublishedInformation } from "@/components/information/editorial-content";
import { submitSupportRequest } from "@/lib/information";

export default function ContactPage() {
  const intro = usePublishedInformation("support").data[0];
  const [sent, setSent] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setLoading(true);
    setError("");
    const fd = new FormData(e.currentTarget);
    try {
      const id = await submitSupportRequest({
        name: String(fd.get("name")),
        email: String(fd.get("email")),
        category: String(fd.get("category")),
        subject: String(fd.get("subject")),
        message: String(fd.get("message")),
        website: String(fd.get("website") || ""),
      });
      setSent(id);
    } catch {
      setError(
        "Le message n’a pas pu être transmis. Vérifie les informations puis réessaie.",
      );
    } finally {
      setLoading(false);
    }
  }
  return (
    <main className="mx-auto max-w-6xl px-4 py-10 sm:py-16">
      <div className="grid gap-6 lg:grid-cols-[.8fr_1.2fr]">
        <section className="rounded-[30px] bg-[#0B1B45] p-7 text-white sm:p-9">
          <div className="grid h-12 w-12 place-items-center rounded-2xl bg-white/10">
            <Headphones size={23} />
          </div>
          <h1 className="mt-6 text-3xl font-bold tracking-tight">
            Parlons de ta demande.
          </h1>
          <p className="mt-4 leading-7 text-blue-100/80">
            {intro?.summary ||
              "Une question sur ton abonnement, un cours ou le fonctionnement de COP’IQ ? Notre équipe est là pour t’aider."}
          </p>
          <div className="mt-8 space-y-4">
            <SupportPoint
              icon={Clock3}
              title="Réponse suivie"
              text={String(
                intro?.metadata?.response_time ||
                  "Réponse habituelle sous 24 à 48 h ouvrées",
              )}
            />
            <SupportPoint
              icon={ShieldCheck}
              title="Informations protégées"
              text="Ta demande est transmise de manière sécurisée à l’équipe COP’IQ."
            />
          </div>
          <div className="mt-8 rounded-2xl border border-white/10 bg-white/5 p-4 text-sm text-blue-100/75">
            Ne communique jamais ton mot de passe ni les données complètes de ta
            carte bancaire.
          </div>
        </section>
        <section className="rounded-[30px] border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-8">
          {sent ? (
            <div className="flex min-h-[460px] flex-col items-center justify-center text-center">
              <div className="grid h-16 w-16 place-items-center rounded-full bg-emerald-500/10 text-emerald-600">
                <CheckCircle2 size={30} />
              </div>
              <h2 className="mt-5 text-2xl font-bold text-[var(--on-surface)]">
                Demande transmise
              </h2>
              <p className="mt-2 max-w-md text-[var(--on-surface-muted)]">
                Notre équipe a bien reçu ton message. Référence :{" "}
                <strong className="text-[var(--on-surface)]">
                  {sent.slice(0, 8).toUpperCase()}
                </strong>
              </p>
              <button
                onClick={() => setSent(null)}
                className="mt-6 min-h-11 cursor-pointer rounded-xl border border-[var(--outline)] px-5 text-sm font-semibold transition hover:bg-[var(--surface-container)]"
              >
                Envoyer une autre demande
              </button>
            </div>
          ) : (
            <>
              <h2 className="text-xl font-bold text-[var(--on-surface)]">
                Contacter le support
              </h2>
              <p className="mt-2 text-sm text-[var(--on-surface-muted)]">
                Plus ta description est précise, plus notre réponse sera rapide.
              </p>
              <form onSubmit={handleSubmit} className="mt-6 space-y-4">
                <div className="grid gap-4 sm:grid-cols-2">
                  <Field
                    name="name"
                    label="Nom complet"
                    placeholder="Ton nom"
                  />
                  <Field
                    name="email"
                    label="Adresse e-mail"
                    placeholder="toi@exemple.fr"
                    type="email"
                  />
                </div>
                <label className="block">
                  <span className={labelClass}>Catégorie</span>
                  <select name="category" className={inputClass}>
                    <option value="subscription">
                      Abonnement et facturation
                    </option>
                    <option value="technical">Problème technique</option>
                    <option value="content">Cours ou quiz</option>
                    <option value="account">Compte et connexion</option>
                    <option value="other">Autre demande</option>
                  </select>
                </label>
                <Field
                  name="subject"
                  label="Sujet"
                  placeholder="Résume ta demande"
                />
                <label className="block">
                  <span className={labelClass}>Message</span>
                  <textarea
                    name="message"
                    required
                    minLength={10}
                    maxLength={6000}
                    rows={7}
                    placeholder="Décris ce qui se passe, la page concernée et les étapes déjà essayées…"
                    className={`${inputClass} resize-y`}
                  />
                </label>
                <label className="absolute -left-[9999px]" aria-hidden="true">
                  Site web
                  <input name="website" tabIndex={-1} autoComplete="off" />
                </label>
                {error && (
                  <p
                    role="alert"
                    className="rounded-xl border border-red-200 bg-red-50 p-3 text-sm text-red-800 dark:border-red-900/50 dark:bg-red-950/30 dark:text-red-200"
                  >
                    {error}
                  </p>
                )}
                <button
                  type="submit"
                  disabled={loading}
                  className="flex min-h-12 w-full cursor-pointer items-center justify-center gap-2 rounded-xl bg-[var(--brand)] px-5 font-semibold text-white transition hover:brightness-110 disabled:cursor-wait disabled:opacity-60"
                >
                  <Send size={17} />
                  {loading ? "Transmission…" : "Envoyer au support"}
                </button>
              </form>
            </>
          )}
        </section>
      </div>
    </main>
  );
}

function SupportPoint({
  icon: Icon,
  title,
  text,
}: {
  icon: typeof Clock3;
  title: string;
  text: string;
}) {
  return (
    <div className="flex gap-3">
      <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-white/10">
        <Icon size={18} />
      </span>
      <div>
        <div className="font-semibold">{title}</div>
        <div className="mt-0.5 text-sm leading-5 text-blue-100/70">{text}</div>
      </div>
    </div>
  );
}
function Field({
  name,
  label,
  placeholder,
  type = "text",
}: {
  name: string;
  label: string;
  placeholder: string;
  type?: string;
}) {
  return (
    <label className="block">
      <span className={labelClass}>{label}</span>
      <input
        name={name}
        type={type}
        required
        minLength={2}
        placeholder={placeholder}
        className={inputClass}
      />
    </label>
  );
}
const labelClass = "mb-1.5 block text-sm font-medium text-[var(--on-surface)]";
const inputClass =
  "min-h-12 w-full rounded-xl border border-[var(--outline)] bg-[var(--surface)] px-4 py-3 text-sm text-[var(--on-surface)] outline-none transition placeholder:text-[var(--on-surface-faint)] focus:border-[var(--brand)] focus:ring-4 focus:ring-[var(--brand)]/10";
