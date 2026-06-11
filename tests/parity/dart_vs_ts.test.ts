// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Parity test : TS engine ↔ fixtures expected   ║
// ║  Tâche      : CODE-052                                                  ║
// ║                                                                         ║
// ║  Lance le moteur TS (port du moteur Dart) sur les fixtures partagées   ║
// ║  et vérifie que `total_score`, `total_max`, `percent` correspondent au ║
// ║  `expected` figé (à 0.01 près). Le pendant Dart                         ║
// ║  (`test/cas_pratique/parity_test.dart`) valide la même chose côté      ║
// ║  client : si les deux passent → parité Dart↔TS garantie.                ║
// ║                                                                         ║
// ║  Run :                                                                  ║
// ║    deno test --allow-read tests/parity/dart_vs_ts.test.ts               ║
// ╚════════════════════════════════════════════════════════════════════════╝

// @ts-ignore — Deno stdlib import
import { assertEquals } from "https://deno.land/std@0.208.0/assert/mod.ts";

import {
  scoreAttempt,
  type EngineKeyword,
  type EngineKeywordGroup,
  type EngineRubricPoint,
  type EngineSynDict,
  type QuestionSpec,
} from "../../supabase/functions/cas_pratique_correct_attempt/_engine.ts";

interface FixtureKeyword {
  value?: string | null;
  syn_dict_id?: string | null;
  is_phrase?: boolean;
  is_negation?: boolean;
  fuzzy_max_dist?: number;
}

interface FixtureGroup {
  id: string;
  position: number;
  is_optional: boolean;
  keywords: FixtureKeyword[];
}

interface FixturePoint {
  id: string;
  position: number;
  label: string;
  weight: number;
  is_required: boolean;
  kind: string;
  groups: FixtureGroup[];
}

interface FixtureQuestion {
  id: string;
  max_points: number;
  points: FixturePoint[];
}

interface FixtureDict {
  id: string;
  slug: string;
  terms: string[];
}

interface Fixture {
  dicts: FixtureDict[];
  questions: FixtureQuestion[];
  answers: Record<string, string>;
  expected: {
    total_score: number;
    total_max: number;
    percent: number;
  };
}

function buildSpecs(fixture: Fixture): {
  specs: QuestionSpec[];
  dictById: Map<string, EngineSynDict>;
} {
  const groupsByPoint = new Map<string, EngineKeywordGroup[]>();
  const specs: QuestionSpec[] = [];

  for (const q of fixture.questions) {
    const points: EngineRubricPoint[] = [];
    for (const p of q.points) {
      points.push({
        id: p.id,
        question_id: q.id,
        position: p.position,
        label: p.label,
        weight: p.weight,
        is_required: p.is_required,
        kind: p.kind,
        explanation_md: null,
      });
      const groups: EngineKeywordGroup[] = p.groups.map((g) => ({
        id: g.id,
        position: g.position,
        description: null,
        is_optional: g.is_optional,
        keywords: g.keywords.map((kw): EngineKeyword => ({
          value: kw.value ?? null,
          syn_dict_id: kw.syn_dict_id ?? null,
          is_phrase: kw.is_phrase ?? false,
          is_negation: kw.is_negation ?? false,
          fuzzy_max_dist: kw.fuzzy_max_dist ?? 1,
        })),
      }));
      groupsByPoint.set(p.id, groups);
    }
    specs.push({
      questionId: q.id,
      maxPoints: q.max_points,
      points,
      groupsByPoint, // partagé : seul l'accès par point_id compte
    });
  }

  const dictById = new Map<string, EngineSynDict>();
  for (const d of fixture.dicts) {
    dictById.set(d.id, { id: d.id, slug: d.slug, terms: d.terms });
  }
  return { specs, dictById };
}

const FIXTURE_NAMES = [
  "scenario_1_perfect",
  "scenario_2_partial",
  "scenario_3_missing",
  "scenario_4_fuzzy_phrase_multi",
];

function loadFixture(name: string): Fixture {
  // @ts-ignore — Deno global
  const url = new URL(`./fixtures/${name}.json`, import.meta.url);
  // @ts-ignore — Deno global
  const raw = Deno.readTextFileSync(url);
  return JSON.parse(raw) as Fixture;
}

function approxEq(a: number, b: number, eps = 0.01): boolean {
  return Math.abs(a - b) <= eps;
}

for (const name of FIXTURE_NAMES) {
  Deno.test(`parity TS — ${name}`, () => {
    const fix = loadFixture(name);
    const { specs, dictById } = buildSpecs(fix);
    const result = scoreAttempt(specs, fix.answers, dictById);

    if (!approxEq(result.totalScore, fix.expected.total_score)) {
      throw new Error(
        `total_score mismatch : TS=${result.totalScore} vs expected=${fix.expected.total_score}`,
      );
    }
    if (!approxEq(result.totalMax, fix.expected.total_max)) {
      throw new Error(
        `total_max mismatch : TS=${result.totalMax} vs expected=${fix.expected.total_max}`,
      );
    }
    if (!approxEq(result.percent, fix.expected.percent)) {
      throw new Error(
        `percent mismatch : TS=${result.percent} vs expected=${fix.expected.percent}`,
      );
    }
    assertEquals(true, true);
  });
}
