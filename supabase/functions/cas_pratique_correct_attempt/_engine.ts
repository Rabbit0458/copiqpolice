// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine TS (réutilisable)                      ║
// ║  Tâche      : CODE-051 (port) + CODE-052 (parité Dart↔TS)               ║
// ║                                                                         ║
// ║  Ce module est PUR : aucun import Deno ni Supabase. Il est consommé    ║
// ║  par :                                                                  ║
// ║    - `index.ts` (handler Deno de l'edge function)                       ║
// ║    - `tests/parity/dart_vs_ts.test.ts` (test de parité avec le moteur  ║
// ║      Dart de référence)                                                 ║
// ║                                                                         ║
// ║  Toute modification ici DOIT être répliquée à l'identique dans         ║
// ║  `lib/core/cas_pratique/engine/*.dart`. Un test de parité (CODE-052)   ║
// ║  garantit qu'un set de fixtures produit le même score à 0.01 près.    ║
// ╚════════════════════════════════════════════════════════════════════════╝

export const ENGINE_VERSION = "2.0.0";

// ─── Normalizer ─────────────────────────────────────────────────────────────

export interface NormalizerOptions {
  stripPunctuation: boolean;
  keepApostrophes: boolean;
  maxInputLength: number;
}

const NORMALIZER_DEFAULT: NormalizerOptions = {
  stripPunctuation: true,
  keepApostrophes: false,
  maxInputLength: 10000,
};

const DIACRITIC_MAP: Record<number, string> = {
  0x00e0: "a", 0x00e1: "a", 0x00e2: "a", 0x00e3: "a", 0x00e4: "a", 0x00e5: "a",
  0x00c0: "A", 0x00c1: "A", 0x00c2: "A", 0x00c3: "A", 0x00c4: "A", 0x00c5: "A",
  0x00e7: "c", 0x00c7: "C",
  0x00e8: "e", 0x00e9: "e", 0x00ea: "e", 0x00eb: "e",
  0x00c8: "E", 0x00c9: "E", 0x00ca: "E", 0x00cb: "E",
  0x00ec: "i", 0x00ed: "i", 0x00ee: "i", 0x00ef: "i",
  0x00cc: "I", 0x00cd: "I", 0x00ce: "I", 0x00cf: "I",
  0x00f1: "n", 0x00d1: "N",
  0x00f2: "o", 0x00f3: "o", 0x00f4: "o", 0x00f5: "o", 0x00f6: "o", 0x00f8: "o",
  0x00d2: "O", 0x00d3: "O", 0x00d4: "O", 0x00d5: "O", 0x00d6: "O", 0x00d8: "O",
  0x00f9: "u", 0x00fa: "u", 0x00fb: "u", 0x00fc: "u",
  0x00d9: "U", 0x00da: "U", 0x00db: "U", 0x00dc: "U",
  0x00fd: "y", 0x00ff: "y",
  0x00dd: "Y", 0x0178: "Y",
};

function stripDiacritics(s: string): string {
  let out = "";
  for (const ch of s) {
    const cp = ch.codePointAt(0)!;
    const mapped = DIACRITIC_MAP[cp];
    if (mapped !== undefined) {
      out += mapped;
    } else if (cp >= 0x0300 && cp <= 0x036f) {
      continue;
    } else {
      out += ch;
    }
  }
  return out;
}

function replaceLigatures(s: string): string {
  return s
    .replace(/œ/g, "oe").replace(/Œ/g, "OE")
    .replace(/æ/g, "ae").replace(/Æ/g, "AE")
    .replace(/ﬁ/g, "fi")
    .replace(/ﬂ/g, "fl");
}

function stripPunctuation(s: string, keepApostrophes: boolean): string {
  return keepApostrophes
    ? s.replace(/[^a-z0-9\s']/g, " ")
    : s.replace(/[^a-z0-9\s]/g, " ");
}

export function normalize(
  input: string,
  opts: Partial<NormalizerOptions> = {},
): string {
  if (!input) return "";
  const o = { ...NORMALIZER_DEFAULT, ...opts };
  let s = input;
  if (s.length > o.maxInputLength) s = s.substring(0, o.maxInputLength);
  s = stripDiacritics(s);
  s = replaceLigatures(s);
  s = s.replace(/ /g, " "); // NBSP
  s = s.toLowerCase();
  if (o.stripPunctuation) s = stripPunctuation(s, o.keepApostrophes);
  s = s.replace(/\s+/g, " ");
  return s.trim();
}

// ─── Tokenizer + n-grams ───────────────────────────────────────────────────

export function tokenize(normalized: string): string[] {
  if (!normalized) return [];
  return normalized.split(/\s+/).filter((t) => t.length > 0);
}

export function ngramSet(tokens: string[]): Set<string> {
  const out = new Set<string>(tokens);
  for (let i = 0; i + 1 < tokens.length; i++) {
    out.add(`${tokens[i]}_${tokens[i + 1]}`);
  }
  for (let i = 0; i + 2 < tokens.length; i++) {
    out.add(`${tokens[i]}_${tokens[i + 1]}_${tokens[i + 2]}`);
  }
  return out;
}

// ─── Levenshtein ───────────────────────────────────────────────────────────

export function levenshtein(a: string, b: string, maxDist?: number): number {
  if (a === b) return 0;
  if (!a.length) return b.length;
  if (!b.length) return a.length;
  if (maxDist !== undefined && Math.abs(a.length - b.length) > maxDist) {
    return maxDist + 1;
  }
  const m = a.length;
  const n = b.length;
  let prev = new Array<number>(n + 1);
  let curr = new Array<number>(n + 1).fill(0);
  for (let j = 0; j <= n; j++) prev[j] = j;
  for (let i = 1; i <= m; i++) {
    curr[0] = i;
    let rowMin = i;
    const ai = a.charCodeAt(i - 1);
    for (let j = 1; j <= n; j++) {
      const cost = ai === b.charCodeAt(j - 1) ? 0 : 1;
      const del = prev[j] + 1;
      const ins = curr[j - 1] + 1;
      const sub = prev[j - 1] + cost;
      let v = del;
      if (ins < v) v = ins;
      if (sub < v) v = sub;
      curr[j] = v;
      if (v < rowMin) rowMin = v;
    }
    if (maxDist !== undefined && rowMin > maxDist) return maxDist + 1;
    const tmp = prev;
    prev = curr;
    curr = tmp;
  }
  return prev[n];
}

export function isWithin(a: string, b: string, maxDist: number): boolean {
  return levenshtein(a, b, maxDist) <= maxDist;
}

// ─── Negation detector ─────────────────────────────────────────────────────

export const NEGATION_WORDS = new Set<string>([
  "ne", "n", "pas", "plus", "jamais",
  "aucun", "aucune", "aucuns", "aucunes",
  "rien", "sans", "non", "ni",
  "nul", "nulle", "nulles",
]);
export const NEG_WINDOW = 5;

export function isNegated(tokens: string[], keywordPos: number, window = NEG_WINDOW): boolean {
  if (keywordPos <= 0) return false;
  const start = Math.max(0, keywordPos - window);
  for (let i = start; i < keywordPos; i++) {
    if (NEGATION_WORDS.has(tokens[i])) return true;
  }
  return false;
}

export function isPhraseNegated(normalizedAnswer: string, phrase: string, window = NEG_WINDOW): boolean {
  const idx = normalizedAnswer.indexOf(phrase);
  if (idx < 0) return false;
  const before = normalizedAnswer.substring(0, idx).trim();
  if (!before) return false;
  const tokens = before.split(/\s+/);
  const start = Math.max(0, tokens.length - window);
  for (let i = start; i < tokens.length; i++) {
    if (NEGATION_WORDS.has(tokens[i])) return true;
  }
  return false;
}

// ─── Engine models ─────────────────────────────────────────────────────────

export interface EngineKeyword {
  value: string | null;
  syn_dict_id: string | null;
  is_phrase: boolean;
  is_negation: boolean;
  fuzzy_max_dist: number;
}

export interface EngineSynDict {
  id: string;
  slug: string;
  terms: string[];
}

export interface EngineKeywordGroup {
  id: string;
  position: number;
  description: string | null;
  is_optional: boolean;
  keywords: EngineKeyword[];
}

export interface EngineRubricPoint {
  id: string;
  question_id: string;
  position: number;
  label: string;
  weight: number;
  is_required: boolean;
  kind: string;
  explanation_md: string | null;
}

export interface MatchContext {
  normalizedAnswer: string;
  tokens: string[];
  ngrams: Set<string>;
  tokenSet: Set<string>;
}

export function buildContext(rawAnswer: string): MatchContext {
  const n = normalize(rawAnswer);
  const t = tokenize(n);
  return {
    normalizedAnswer: n,
    tokens: t,
    ngrams: ngramSet(t),
    tokenSet: new Set(t),
  };
}

// ─── Synonym resolver ──────────────────────────────────────────────────────

export function resolveCandidates(
  kw: EngineKeyword,
  dictById: Map<string, EngineSynDict>,
): string[] {
  if (kw.syn_dict_id && dictById.has(kw.syn_dict_id)) {
    return dictById.get(kw.syn_dict_id)!.terms;
  }
  if (kw.value && kw.value.length > 0) return [kw.value];
  return [];
}

// ─── Keyword matcher ───────────────────────────────────────────────────────

export type MatchType = "phrase" | "exact" | "ngram" | "fuzzy" | "negation_present";

export interface MatchInfo {
  matched: boolean;
  matchedAgainst?: string;
  matchType?: MatchType;
}

const NO_MATCH: MatchInfo = { matched: false };

function decide(kw: EngineKeyword, against: string, type: MatchType, negated: boolean): MatchInfo {
  if (kw.is_negation) {
    if (negated) {
      return { matched: true, matchedAgainst: against, matchType: "negation_present" };
    }
    return NO_MATCH;
  }
  if (negated) return NO_MATCH;
  return { matched: true, matchedAgainst: against, matchType: type };
}

export function matchKeyword(
  kw: EngineKeyword,
  ctx: MatchContext,
  dictById: Map<string, EngineSynDict>,
): MatchInfo {
  const candidates = resolveCandidates(kw, dictById);
  if (candidates.length === 0) return NO_MATCH;

  for (const candRaw of candidates) {
    const cand = normalize(candRaw);
    if (!cand) continue;

    const multiWord = kw.is_phrase || cand.includes(" ");
    if (multiWord) {
      if (ctx.normalizedAnswer.includes(cand)) {
        const negated = isPhraseNegated(ctx.normalizedAnswer, cand);
        return decide(kw, cand, "phrase", negated);
      }
      continue;
    }

    const candKey = cand.replace(/ /g, "_");
    if (ctx.tokenSet.has(cand)) {
      const pos = ctx.tokens.indexOf(cand);
      const negated = pos >= 0 && isNegated(ctx.tokens, pos);
      return decide(kw, cand, "exact", negated);
    }
    if (ctx.ngrams.has(candKey)) {
      return decide(kw, cand, "ngram", false);
    }

    if (kw.fuzzy_max_dist > 0 && cand.length >= 6) {
      for (const t of ctx.tokens) {
        if (Math.abs(t.length - cand.length) > kw.fuzzy_max_dist) continue;
        if (isWithin(t, cand, kw.fuzzy_max_dist)) {
          const pos = ctx.tokens.indexOf(t);
          const negated = pos >= 0 && isNegated(ctx.tokens, pos);
          return decide(kw, cand, "fuzzy", negated);
        }
      }
    }
  }
  return NO_MATCH;
}

// ─── Point evaluator ───────────────────────────────────────────────────────

export type PointStatus = "covered" | "partial" | "missing";

export interface GroupMatchResult {
  group_id: string;
  is_optional: boolean;
  matched: boolean;
  matched_keywords: string[];
}

export interface PointEvalResult {
  point_id: string;
  status: PointStatus;
  score: number;
  weight: number;
  group_matches: GroupMatchResult[];
}

export const PARTIAL_THRESHOLD = 0.5;

export function evaluatePoint(
  point: EngineRubricPoint,
  groups: EngineKeywordGroup[],
  ctx: MatchContext,
  dictById: Map<string, EngineSynDict>,
): PointEvalResult {
  if (groups.length === 0) {
    return {
      point_id: point.id,
      status: "missing",
      score: 0,
      weight: point.weight,
      group_matches: [],
    };
  }

  let requiredCount = 0;
  let requiredHits = 0;
  const groupResults: GroupMatchResult[] = [];

  for (const g of groups) {
    const matchedKw: string[] = [];
    let groupMatched = false;
    for (const kw of g.keywords) {
      const info = matchKeyword(kw, ctx, dictById);
      if (info.matched) {
        matchedKw.push(info.matchedAgainst ?? kw.value ?? "?");
        groupMatched = true;
        break;
      }
    }
    if (!g.is_optional) {
      requiredCount++;
      if (groupMatched) requiredHits++;
    }
    groupResults.push({
      group_id: g.id,
      is_optional: g.is_optional,
      matched: groupMatched,
      matched_keywords: matchedKw,
    });
  }

  const ratio = requiredCount === 0 ? 1.0 : requiredHits / requiredCount;
  let status: PointStatus;
  let factor: number;
  if (ratio >= 1.0) {
    status = "covered";
    factor = 1.0;
  } else if (ratio >= PARTIAL_THRESHOLD) {
    status = "partial";
    factor = 0.5;
  } else {
    status = "missing";
    factor = 0.0;
  }

  return {
    point_id: point.id,
    status,
    score: point.weight * factor,
    weight: point.weight,
    group_matches: groupResults,
  };
}

// ─── Question / Attempt scorer ─────────────────────────────────────────────

export interface QuestionSpec {
  questionId: string;
  maxPoints: number;
  points: EngineRubricPoint[];
  groupsByPoint: Map<string, EngineKeywordGroup[]>;
}

export interface QuestionScoreResult {
  questionId: string;
  score: number;
  maxPoints: number;
  percent: number;
  points: PointEvalResult[];
}

export function scoreQuestion(
  spec: QuestionSpec,
  userAnswer: string,
  dictById: Map<string, EngineSynDict>,
): QuestionScoreResult {
  const ctx = buildContext(userAnswer);
  let rawScore = 0;
  let maxPossible = 0;
  const points: PointEvalResult[] = [];
  for (const p of spec.points) {
    const groups = spec.groupsByPoint.get(p.id) ?? [];
    const r = evaluatePoint(p, groups, ctx, dictById);
    points.push(r);
    rawScore += r.score;
    maxPossible += r.weight;
  }
  const normalized = maxPossible === 0 ? 0 : (rawScore / maxPossible) * spec.maxPoints;
  const clamped = Math.max(0, Math.min(spec.maxPoints, normalized));
  const percent = spec.maxPoints === 0 ? 0 : (clamped / spec.maxPoints) * 100;
  return {
    questionId: spec.questionId,
    score: clamped,
    maxPoints: spec.maxPoints,
    percent,
    points,
  };
}

export interface AttemptScoreResult {
  totalScore: number;
  totalMax: number;
  percent: number;
  questionResults: QuestionScoreResult[];
}

export function scoreAttempt(
  specs: QuestionSpec[],
  answers: Record<string, string>,
  dictById: Map<string, EngineSynDict>,
): AttemptScoreResult {
  const results: QuestionScoreResult[] = [];
  let total = 0;
  let max = 0;
  for (const spec of specs) {
    const ans = answers[spec.questionId] ?? "";
    const r = scoreQuestion(spec, ans, dictById);
    results.push(r);
    total += r.score;
    max += r.maxPoints;
  }
  const percent = max === 0 ? 0 : (total / max) * 100;
  return { totalScore: total, totalMax: max, percent, questionResults: results };
}
