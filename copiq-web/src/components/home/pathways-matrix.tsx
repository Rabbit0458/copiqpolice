import Link from "next/link"
import { PATHWAYS, type PathwayId } from "@/config/pathways"
import { PATHWAY_CARDS } from "@/data/marketing"
import { Appear, SplitText } from "@/components/home/motion"

/**
 * Les quatre parcours présentés comme ce qu'ils sont : un croisement entre
 * le grade visé (lignes) et l'étape (colonnes). Les libellés, couleurs et
 * modules viennent de `config/pathways.ts` et `data/marketing.ts`, qui sont
 * les mêmes sources que l'application.
 */

const ROWS = [
  { grade: "Policier adjoint", exam: "pa_exam", school: "pa_school" },
  { grade: "Gardien de la paix", exam: "gpx_exam", school: "gpx_school" },
] as const satisfies readonly { grade: string; exam: PathwayId; school: PathwayId }[]

const STAGES = {
  exam: { label: "Concours", hint: "Avant d’entrer dans la police" },
  school: { label: "École", hint: "Pendant la scolarité" },
} as const

function Cell({ id, grade, stage, delay }: { id: PathwayId; grade: string; stage: keyof typeof STAGES; delay: number }) {
  const card = PATHWAY_CARDS.find((c) => c.id === id)
  const pathway = PATHWAYS[id]
  if (!card) return null
  return (
    <Appear as="article" delay={delay} className="h-full">
    <div className="cq-card-lift flex h-full flex-col rounded-3xl border border-[var(--outline)] bg-[var(--surface)] p-6 sm:p-7">
      <p className="flex items-center gap-2 text-[13px] font-medium text-[var(--on-surface-muted)]">
        <span
          aria-hidden="true"
          className="h-2.5 w-2.5 rounded-full"
          style={{ background: pathway.color }}
        />
        {grade}, {STAGES[stage].label.toLowerCase()}
      </p>
      <h3 className="mt-3 text-[1.3rem] font-semibold leading-snug tracking-[-0.02em] text-[var(--on-surface)]">
        {pathway.title}
      </h3>
      <p className="mt-2 text-[15px] leading-relaxed text-[var(--on-surface-muted)]">
        {card.description}
      </p>
      <ul className="mt-5 flex flex-wrap gap-1.5" aria-label="Modules">
        {card.modules.map((m) => (
          <li
            key={m}
            className="rounded-full bg-[var(--surface-container)] px-2.5 py-1 text-[12.5px] font-medium text-[var(--on-surface-muted)]"
          >
            {m}
          </li>
        ))}
      </ul>
      <div className="mt-auto pt-6">
        <Link
          href={`/signup?parcours=${pathway.slug}`}
          className="cq-tap inline-flex items-center rounded-xl text-[15px] font-semibold text-[#1147D9] underline-offset-4 hover:underline dark:text-[#7FB3FF]"
        >
          Commencer ce parcours
        </Link>
      </div>
    </div>
    </Appear>
  )
}

export function PathwaysMatrix() {
  return (
    <section id="parcours" className="scroll-mt-20 bg-[var(--surface)] py-[var(--section-y)]">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 xl:px-8">
        <SplitText
          as="h2"
          text="Quatre parcours, du concours jusqu’à l’école."
          className="block max-w-[44rem] text-[clamp(2rem,4.2vw,3.1rem)] font-bold leading-[1.04] tracking-[-0.035em] text-[var(--on-surface)] [text-wrap:balance]"
        />
        <Appear delay={200}>
          <p className="mt-5 max-w-[40rem] text-[17px] leading-relaxed text-[var(--on-surface-muted)]">
            Choisis ton grade et ton étape. Les cours, les quiz et ta progression
            s’adaptent à ton parcours, et tu peux en changer à tout moment.
          </p>
        </Appear>

        <div>
          <div className="mt-14 grid gap-4 lg:grid-cols-[11rem_minmax(0,1fr)_minmax(0,1fr)] lg:gap-5">
            {/* En-têtes de colonnes (grand écran) */}
            <div className="hidden lg:block" />
            {(Object.keys(STAGES) as (keyof typeof STAGES)[]).map((s) => (
              <Appear key={s} variant="fade" delay={s === "exam" ? 100 : 180} className="hidden border-b border-[var(--outline)] pb-4 lg:block">
                <p className="text-[1.05rem] font-semibold text-[var(--on-surface)]">{STAGES[s].label}</p>
                <p className="text-[14px] text-[var(--on-surface-muted)]">{STAGES[s].hint}</p>
              </Appear>
            ))}

            {ROWS.map((row, r) => (
              <div key={row.grade} className="contents">
                <div className="hidden pt-7 lg:block">
                  <p className="text-[1.05rem] font-semibold leading-snug text-[var(--on-surface)]">
                    {row.grade}
                  </p>
                </div>
                <Cell id={row.exam} grade={row.grade} stage="exam" delay={r * 120} />
                <Cell id={row.school} grade={row.grade} stage="school" delay={r * 120 + 110} />
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}
