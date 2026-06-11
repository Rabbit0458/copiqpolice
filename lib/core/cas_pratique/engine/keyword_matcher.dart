// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Engine : Keyword Matcher                      ║
// ║  Référence : docs/cas_pratique/04_CORRECTION_ENGINE_SPEC.md (§ 2.5)     ║
// ║  Tâche      : CODE-025                                                  ║
// ║                                                                         ║
// ║  Le coeur du moteur : décide si un keyword est "présent" dans une      ║
// ║  réponse utilisateur, en combinant :                                    ║
// ║    1. Match exact (token ou phrase)                                     ║
// ║    2. Match n-gram (bigrams / trigrams)                                 ║
// ║    3. Fuzzy match (Levenshtein) si activé et token assez long           ║
// ║    4. Détection de négation (peut inverser le résultat)                 ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:copiqpolice/core/cas_pratique/engine/normalizer.dart';
import 'package:copiqpolice/core/cas_pratique/engine/tokenizer.dart';
import 'package:copiqpolice/core/cas_pratique/engine/levenshtein.dart';
import 'package:copiqpolice/core/cas_pratique/engine/negation_detector.dart';
import 'package:copiqpolice/core/cas_pratique/engine/synonym_resolver.dart';

/// Contexte de matching pré-calculé pour une réponse utilisateur donnée.
/// Évite de recalculer la normalisation / tokenisation pour chaque keyword.
class KeywordMatchContext {
  final String normalizedAnswer;
  final List<String> tokens;
  final Set<String> ngramSet;
  final Set<String> tokenSet; // accès O(1) aux tokens

  KeywordMatchContext._({
    required this.normalizedAnswer,
    required this.tokens,
    required this.ngramSet,
    required this.tokenSet,
  });

  /// Construit le contexte à partir d'une réponse brute.
  factory KeywordMatchContext.build(
    String rawAnswer, {
    Normalizer normalizer = const Normalizer(),
    Tokenizer tokenizer = const Tokenizer(),
  }) {
    final normalized = normalizer.normalize(rawAnswer);
    final tokens = tokenizer.tokenize(normalized);
    return KeywordMatchContext._(
      normalizedAnswer: normalized,
      tokens: tokens,
      ngramSet: tokenizer.ngramSet(tokens),
      tokenSet: tokens.toSet(),
    );
  }
}

/// Résultat détaillé d'un match (utile pour le debug / pédagogie).
class MatchInfo {
  final bool matched;
  final String? matchedAgainst; // candidat qui a matché
  final String? matchType;      // 'phrase' | 'exact' | 'ngram' | 'fuzzy' | 'negation_present'

  const MatchInfo({
    required this.matched,
    this.matchedAgainst,
    this.matchType,
  });

  static const MatchInfo none = MatchInfo(matched: false);
}

/// Matcher principal.
class KeywordMatcher {
  KeywordMatcher({
    Normalizer? normalizer,
    NegationDetector? negationDetector,
    SynonymResolver? synonymResolver,
  })  : _normalizer = normalizer ?? const Normalizer(),
        _negation = negationDetector ?? const NegationDetector(),
        _resolver = synonymResolver;

  final Normalizer _normalizer;
  final NegationDetector _negation;
  final SynonymResolver? _resolver;

  /// Renvoie `true` si le keyword est "présent" dans le contexte.
  /// Tient compte de la négation et de `is_negation` du keyword.
  bool matches(EngineKeyword kw, KeywordMatchContext ctx) {
    final info = matchInfo(kw, ctx);
    return info.matched;
  }

  /// Variante détaillée : renvoie l'info de match.
  MatchInfo matchInfo(EngineKeyword kw, KeywordMatchContext ctx) {
    final candidates = _resolveCandidates(kw);
    if (candidates.isEmpty) return MatchInfo.none;

    for (final candRaw in candidates) {
      // On normalise le candidat (au cas où il aurait des accents)
      final cand = _normalizer.normalize(candRaw);
      if (cand.isEmpty) continue;

      // ─── 1. Phrase (multi-mots ou is_phrase = true) ─────────────────────
      final isMultiWord = kw.isPhrase || cand.contains(' ');
      if (isMultiWord) {
        if (ctx.normalizedAnswer.contains(cand)) {
          final negated = _negation.isPhraseNegated(ctx.normalizedAnswer, cand);
          return _decide(kw, cand, 'phrase', negated);
        }
        // Pas trouvé en littéral : on n'essaie pas de fuzzy sur phrase
        continue;
      }

      // ─── 2. Match exact dans ngram set (uni + bi + tri) ─────────────────
      final candKey = cand.replaceAll(' ', '_');
      if (ctx.tokenSet.contains(cand)) {
        final pos = ctx.tokens.indexOf(cand);
        final negated = pos >= 0 && _negation.isNegated(ctx.tokens, pos);
        return _decide(kw, cand, 'exact', negated);
      }
      if (ctx.ngramSet.contains(candKey)) {
        return _decide(kw, cand, 'ngram', false);
      }

      // ─── 3. Fuzzy match si activé et candidat assez long ────────────────
      if (kw.fuzzyMaxDist > 0 && cand.length >= 6) {
        for (final t in ctx.tokens) {
          if ((t.length - cand.length).abs() > kw.fuzzyMaxDist) continue;
          if (Levenshtein.isWithin(t, cand, kw.fuzzyMaxDist)) {
            final pos = ctx.tokens.indexOf(t);
            final negated = pos >= 0 && _negation.isNegated(ctx.tokens, pos);
            return _decide(kw, cand, 'fuzzy', negated);
          }
        }
      }
    }

    // Aucun match :
    // - keyword normal "absence" → matched = false
    // - keyword `is_negation = true` "négation attendue" → si pas trouvé,
    //   c'est cohérent (la négation n'est pas dans le texte) donc matched = false aussi
    return MatchInfo.none;
  }

  /// Logique de décision tenant compte de `is_negation` et de la négation détectée.
  MatchInfo _decide(EngineKeyword kw, String matchedAgainst, String type, bool negatedInText) {
    if (kw.isNegation) {
      // Le keyword représente une "négation attendue".
      // Présent ET négué dans le texte → succès logique.
      if (negatedInText) {
        return MatchInfo(matched: true, matchedAgainst: matchedAgainst, matchType: 'negation_present');
      }
      // Présent SANS négation → contradicte la négation attendue → échec
      return MatchInfo.none;
    }
    // Keyword normal : présent ET non négué → succès.
    if (negatedInText) return MatchInfo.none;
    return MatchInfo(matched: true, matchedAgainst: matchedAgainst, matchType: type);
  }

  List<String> _resolveCandidates(EngineKeyword kw) {
    final r = _resolver;
    if (r != null) return r.resolve(kw);
    if (kw.value != null) return [kw.value!];
    return const [];
  }
}
