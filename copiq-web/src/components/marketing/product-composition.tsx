import { cn } from "@/lib/utils"

/**
 * Compositions produit de la vitrine.
 *
 * Pourquoi ce fichier existe plutôt que des captures d'écran : le dépôt ne
 * contient AUCUNE capture de l'application (les 571 images d'`assets/` sont
 * des illustrations de contenu pédagogique). Fabriquer de faux écrans serait
 * une preuve inventée. Ces panneaux sont donc de l'interface COP'IQ réelle,
 * écrite en DOM avec les mêmes jetons de design que l'application web
 * (`--surface`, `--outline`, `--on-surface`, bleu `#1147D9`) et la
 * nomenclature réelle des modules relevée dans `lib/content/`.
 *
 * Les valeurs numériques affichées sont des exemples et sont annoncées comme
 * telles par la légende `caption` — jamais présentées comme des statistiques
 * de COP'IQ (§53).
 *
 * Présentations alternées (§69) : `bare` (carte flottante), `window` (fenêtre
 * navigateur), `phone` (cadre mobile). Aucun écran n'est systématiquement
 * enfermé dans un faux téléphone.
 */

type Shell = "bare" | "window" | "phone"

export function AppFrame({
  children,
  shell = "bare",
  caption,
  className,
}: {
  children: React.ReactNode
  shell?: Shell
  /** Légende visible. Sert à annoncer « données d'exemple ». */
  caption?: string
  className?: string
}) {
  const body = (
    <div className="bg-[#070C22] text-[#E8EDF9]">{children}</div>
  )

  return (
    <figure className={cn("m-0", className)}>
      {shell === "window" && (
        <div className="cq-edge-light overflow-hidden rounded-2xl border border-white/10 bg-[#0A1130] shadow-[0_28px_90px_-30px_rgba(2,6,24,0.9)]">
          <div className="flex items-center gap-2 border-b border-white/8 bg-[#0C133A] px-3.5 py-2.5">
            <span className="h-2.5 w-2.5 rounded-full bg-white/18" />
            <span className="h-2.5 w-2.5 rounded-full bg-white/12" />
            <span className="h-2.5 w-2.5 rounded-full bg-white/12" />
            <span className="ml-3 truncate rounded-md bg-black/30 px-2.5 py-1 text-[11px] text-white/55">
              copiq.fr
            </span>
          </div>
          {body}
        </div>
      )}

      {shell === "phone" && (
        <div className="rounded-[2.1rem] border border-white/12 bg-[#05091C] p-2 shadow-[0_28px_90px_-30px_rgba(2,6,24,0.95)]">
          <div className="overflow-hidden rounded-[1.65rem]">
            <div className="flex items-center justify-center bg-[#0A1130] py-2">
              <span className="h-1 w-14 rounded-full bg-white/20" />
            </div>
            {body}
          </div>
        </div>
      )}

      {shell === "bare" && (
        <div className="cq-edge-light overflow-hidden rounded-2xl border border-white/10 shadow-[0_24px_70px_-28px_rgba(2,6,24,0.9)]">
          {body}
        </div>
      )}

      {caption && (
        <figcaption className="mt-2.5 text-[11px] leading-snug text-white/55">
          {caption}
        </figcaption>
      )}
    </figure>
  )
}

/* ── Primitives internes ──────────────────────────────────────────────────── */

function PanelHead({ title, right }: { title: string; right?: string }) {
  return (
    <div className="flex items-baseline justify-between gap-3 border-b border-white/8 px-4 py-3">
      <span className="text-[13px] font-semibold tracking-[-0.01em]">{title}</span>
      {right && <span className="text-[11px] text-white/55">{right}</span>}
    </div>
  )
}

function Bar({
  label,
  value,
  color = "#4D82FF",
  delay = 0,
}: {
  label: string
  value: number
  color?: string
  delay?: number
}) {
  return (
    <div>
      <div className="mb-1.5 flex items-baseline justify-between gap-2">
        <span className="truncate text-[12px] text-white/75">{label}</span>
        <span className="text-[11px] font-semibold tabular-nums text-white/55">
          {value} %
        </span>
      </div>
      <div className="h-1.5 overflow-hidden rounded-full bg-white/8">
        <div
          className="cq-grow h-full rounded-full"
          style={{
            width: `${value}%`,
            background: color,
            animationDelay: `${delay}ms`,
          }}
        />
      </div>
    </div>
  )
}

/* ── Panneau : quiz en cours ──────────────────────────────────────────────── */

export function QuizPanel() {
  const options = [
    { label: "Le tribunal de police", state: "idle" as const },
    { label: "Le tribunal correctionnel", state: "correct" as const },
    { label: "La cour d’assises", state: "idle" as const },
    { label: "La cour d’appel", state: "idle" as const },
  ]

  return (
    <div>
      <PanelHead title="Procédure pénale" right="Question 7 / 20" />
      <div className="px-4 pt-3.5">
        <div className="h-1 overflow-hidden rounded-full bg-white/8">
          <div
            className="cq-grow h-full rounded-full bg-[#4D82FF]"
            style={{ width: "35%" }}
          />
        </div>
      </div>
      <div className="p-4">
        <p className="text-[13.5px] font-semibold leading-snug">
          Quelle juridiction est compétente pour juger un délit ?
        </p>
        <ul className="mt-3.5 space-y-2">
          {options.map((o) => (
            <li
              key={o.label}
              className={cn(
                "flex items-center gap-2.5 rounded-xl border px-3 py-2.5 text-[12.5px]",
                o.state === "correct"
                  ? "border-[#22C55E]/45 bg-[#22C55E]/10 text-[#BBF7D0]"
                  : "border-white/10 bg-white/[0.03] text-white/70",
              )}
            >
              <span
                className={cn(
                  "grid h-4 w-4 shrink-0 place-items-center rounded-full border",
                  o.state === "correct"
                    ? "border-[#22C55E] bg-[#22C55E]"
                    : "border-white/25",
                )}
              >
                {o.state === "correct" && (
                  <svg viewBox="0 0 12 12" className="h-2.5 w-2.5" aria-hidden="true">
                    <path
                      d="M2 6.3 4.6 9 10 3.2"
                      fill="none"
                      stroke="#04120A"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                )}
              </span>
              {o.label}
            </li>
          ))}
        </ul>
        <p className="mt-3 rounded-xl border border-white/10 bg-white/[0.03] px-3 py-2.5 text-[11.5px] leading-relaxed text-white/60">
          Les délits relèvent du tribunal correctionnel. Les crimes relèvent de
          la cour d’assises, les contraventions du tribunal de police.
        </p>
      </div>
    </div>
  )
}

/* ── Panneau : progression ────────────────────────────────────────────────── */

export function ProgressionPanel() {
  return (
    <div>
      <PanelHead title="Progression" right="GPX · École" />
      <div className="space-y-3.5 p-4">
        <Bar label="Institutions et valeurs" value={82} delay={0} />
        <Bar label="DPS / DPG" value={64} color="#7FB3FF" delay={90} />
        <Bar label="Policier en intervention" value={47} color="#F59E0B" delay={180} />
        <Bar label="Mémento circulation" value={31} color="#E0162B" delay={270} />
        <Bar label="PV APJ 20" value={18} color="#A855F7" delay={360} />
      </div>
    </div>
  )
}

/* ── Panneau : cas pratique corrigé ──────────────────────────────────────── */

export function CasPratiquePanel() {
  return (
    <div>
      <PanelHead title="Cas pratique — correction" right="Rédaction" />
      <div className="space-y-3 p-4">
        <div className="rounded-xl border border-white/10 bg-white/[0.03] p-3">
          <span className="cq-eyebrow text-[10px] text-white/55">Votre réponse</span>
          <p className="mt-1.5 text-[12px] leading-relaxed text-white/70">
            Je place l’individu en garde à vue et j’informe le procureur de la
            République dans les meilleurs délais…
          </p>
        </div>
        <div className="grid grid-cols-3 gap-2">
          {[
            { k: "Éléments attendus", v: "7 / 9", tone: "#7FB3FF" },
            { k: "Qualification", v: "Exacte", tone: "#22C55E" },
            { k: "Oublis", v: "2", tone: "#F59E0B" },
          ].map((c) => (
            <div
              key={c.k}
              className="rounded-xl border border-white/10 bg-white/[0.03] px-2.5 py-2"
            >
              <div className="text-[9.5px] leading-tight text-white/55">{c.k}</div>
              <div
                className="mt-1 text-[13px] font-bold tabular-nums"
                style={{ color: c.tone }}
              >
                {c.v}
              </div>
            </div>
          ))}
        </div>
        <ul className="space-y-1.5">
          {[
            "Mention de l’avis à famille manquante",
            "Délai de notification des droits non précisé",
          ].map((t) => (
            <li
              key={t}
              className="flex items-start gap-2 text-[11.5px] leading-snug text-white/60"
            >
              <span className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-[#F59E0B]" />
              {t}
            </li>
          ))}
        </ul>
      </div>
    </div>
  )
}

/* ── Panneau : psychotechniques chronométré ──────────────────────────────── */

export function PsychoPanel() {
  return (
    <div>
      <PanelHead title="Suites logiques" right="00:42" />
      <div className="p-4">
        <div className="flex items-center justify-center gap-2">
          {["4", "9", "16", "25", "?"].map((n, i) => (
            <span
              key={i}
              className={cn(
                "grid h-10 w-10 place-items-center rounded-xl border text-[14px] font-bold tabular-nums",
                n === "?"
                  ? "border-[#4D82FF]/60 bg-[#4D82FF]/12 text-[#9CC0FF]"
                  : "border-white/10 bg-white/[0.04] text-white/80",
              )}
            >
              {n}
            </span>
          ))}
        </div>
        <div className="mt-4 grid grid-cols-4 gap-2">
          {["30", "36", "49", "angle"].map((n) => (
            <span
              key={n}
              className="cq-tap grid place-items-center rounded-xl border border-white/10 bg-white/[0.03] text-[12.5px] text-white/70"
            >
              {n === "angle" ? "64" : n}
            </span>
          ))}
        </div>
      </div>
    </div>
  )
}

/* ── Panneau : tableau de bord condensé ──────────────────────────────────── */

export function DashboardPanel() {
  return (
    <div>
      <PanelHead title="Tableau de bord" right="Reprendre" />
      <div className="space-y-3 p-4">
        <div className="grid grid-cols-3 gap-2">
          {[
            { k: "Série", v: "6 j" },
            { k: "Questions", v: "1 248" },
            { k: "Réussite", v: "71 %" },
          ].map((c) => (
            <div
              key={c.k}
              className="rounded-xl border border-white/10 bg-white/[0.03] px-2.5 py-2.5"
            >
              <div className="text-[9.5px] text-white/55">{c.k}</div>
              <div className="mt-0.5 text-[15px] font-bold tabular-nums text-white/90">
                {c.v}
              </div>
            </div>
          ))}
        </div>
        <div className="rounded-xl border border-[#1147D9]/45 bg-[#1147D9]/12 p-3">
          <div className="text-[10px] text-[#9CC0FF]">À reprendre</div>
          <div className="mt-0.5 text-[13px] font-semibold text-white/90">
            Cadres juridiques — quiz 3
          </div>
          <div className="mt-2 h-1.5 overflow-hidden rounded-full bg-white/10">
            <div
              className="cq-grow h-full rounded-full bg-[#4D82FF]"
              style={{ width: "58%" }}
            />
          </div>
        </div>
        <div className="space-y-1.5">
          {["Culture générale — 20 questions", "Psychotechniques — calcul"].map((t) => (
            <div
              key={t}
              className="flex items-center justify-between rounded-xl border border-white/10 bg-white/[0.03] px-3 py-2.5 text-[12px] text-white/70"
            >
              {t}
              <span className="text-white/55">›</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
