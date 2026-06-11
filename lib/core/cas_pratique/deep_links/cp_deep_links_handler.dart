// lib/core/cas_pratique/deep_links/cp_deep_links_handler.dart
//
// Handler deep links spécifique au module Cas Pratique.
//
// URLs gérées :
//   https://app.copiq.fr/c/<slug>          → CasPratiqueDynamicPage(caseSlug: slug)
//   https://app.copiq.fr/c/<slug>?utm_*    → idem + UTM tracking
//   copiqpolice://cas/<slug>               → CasPratiqueDynamicPage(caseSlug: slug)
//
// UTM params trackés (prêts pour PostHog/Mixpanel CODE-073) :
//   utm_source, utm_medium, utm_campaign, utm_content, utm_term
//
// Intégration :
//   Appeler CpDeepLinksHandler.instance.handleUri(uri, navigatorKey.currentState)
//   depuis DeepLinksService._handleUri() (voir deep_links_service.dart).
//
// Configuration native requise (à faire manuellement) :
//   → docs/cas_pratique/DEEP_LINKS_NATIVE_CONFIG.md
//
// CODE-071 — Phase M — Partage & viralité

import 'package:flutter/widgets.dart';

/// Données UTM extraites d'un deep link.
class CpUtmData {
  const CpUtmData({
    this.source,
    this.medium,
    this.campaign,
    this.content,
    this.term,
  });

  final String? source;
  final String? medium;
  final String? campaign;
  final String? content;
  final String? term;

  bool get hasUtm =>
      source != null ||
      medium != null ||
      campaign != null ||
      content != null ||
      term != null;

  Map<String, String> toMap() => {
        if (source != null) 'utm_source': source!,
        if (medium != null) 'utm_medium': medium!,
        if (campaign != null) 'utm_campaign': campaign!,
        if (content != null) 'utm_content': content!,
        if (term != null) 'utm_term': term!,
      };

  @override
  String toString() => 'CpUtmData(${toMap()})';
}

/// Résultat du parsing d'un deep link Cas Pratique.
class CpDeepLinkResult {
  const CpDeepLinkResult({
    required this.handled,
    this.caseSlug,
    this.utm,
  });

  /// true si ce handler reconnaît et gère l'URI.
  final bool handled;

  /// Slug du cas (ex. "case_3") si l'URL pointe vers un cas.
  final String? caseSlug;

  /// UTM params extraits.
  final CpUtmData? utm;
}

/// Singleton — handler deep links pour le module Cas Pratique.
///
/// Usage dans [DeepLinksService._handleUri] :
/// ```dart
/// final result = CpDeepLinksHandler.I.parse(uri);
/// if (result.handled) {
///   CpDeepLinksHandler.I.navigate(result, navigatorKey.currentState);
///   return; // court-circuit le router générique
/// }
/// ```
class CpDeepLinksHandler {
  CpDeepLinksHandler._();
  static final CpDeepLinksHandler instance = CpDeepLinksHandler._();
  static CpDeepLinksHandler get I => instance;

  // ───────────────────────────── Hosts reconnus ─────────────────────────────

  static const _appHost = 'app.copiq.fr';
  static const _wwwHost = 'www.app.copiq.fr';
  static const _schemeCustom = 'copiqpolice';

  // ────────────────────────────── Parse ─────────────────────────────────────

  /// Analyse l'URI et retourne un [CpDeepLinkResult].
  /// Ne lève jamais d'exception — retourne `handled: false` en cas d'erreur.
  CpDeepLinkResult parse(Uri uri) {
    try {
      return _parse(uri);
    } catch (e, st) {
      debugPrint('[CpDeepLinks] parse error: $e\n$st');
      return const CpDeepLinkResult(handled: false);
    }
  }

  CpDeepLinkResult _parse(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();
    final segs = uri.pathSegments;

    // ── 1. HTTPS : https://app.copiq.fr/c/<slug> ──────────────────────────
    if ((scheme == 'https' || scheme == 'http') &&
        (host == _appHost || host == _wwwHost)) {
      // /c/<slug>
      if (segs.length >= 2 && segs[0] == 'c') {
        final slug = segs[1];
        if (slug.isNotEmpty) {
          return CpDeepLinkResult(
            handled: true,
            caseSlug: slug,
            utm: _extractUtm(uri),
          );
        }
      }
      return const CpDeepLinkResult(handled: false);
    }

    // ── 2. Scheme custom : copiqpolice://cas/<slug> ───────────────────────
    if (scheme == _schemeCustom && host == 'cas') {
      if (segs.isNotEmpty && segs[0].isNotEmpty) {
        return CpDeepLinkResult(
          handled: true,
          caseSlug: segs[0],
          utm: _extractUtm(uri),
        );
      }
    }

    return const CpDeepLinkResult(handled: false);
  }

  // ─────────────────────────── Navigation ───────────────────────────────────

  /// Navigue vers la page du cas si [result.handled] && [result.caseSlug] non null.
  ///
  /// [navigator] doit être le [NavigatorState] actif (ex. depuis
  /// `DeepLinksService.I.navigatorKey.currentState`).
  ///
  /// Retourne true si la navigation a été effectuée.
  bool navigate(CpDeepLinkResult result, NavigatorState? navigator) {
    if (!result.handled || result.caseSlug == null || navigator == null) {
      return false;
    }

    final slug = result.caseSlug!;
    const routeName = '/gpx_exam/concours/cas_pratique/case_dynamic';

    debugPrint('[CpDeepLinks] → $routeName (slug: $slug, utm: ${result.utm})');

    // Log UTM pour CODE-073 (Analytics) — placeholder prêt.
    _logUtm(slug, result.utm);

    navigator.pushNamed(
      routeName,
      arguments: {'caseSlug': slug},
    );
    return true;
  }

  /// Combine [parse] + [navigate] en une seule étape.
  ///
  /// Retourne true si l'URI a été reconnu et la navigation lancée.
  bool handleUri(Uri uri, NavigatorState? navigator) {
    final result = parse(uri);
    if (!result.handled) return false;
    return navigate(result, navigator);
  }

  // ─────────────────────────── Helpers privés ───────────────────────────────

  CpUtmData? _extractUtm(Uri uri) {
    final q = uri.queryParameters;
    if (q.isEmpty) return null;

    final utm = CpUtmData(
      source: q['utm_source'],
      medium: q['utm_medium'],
      campaign: q['utm_campaign'],
      content: q['utm_content'],
      term: q['utm_term'],
    );
    return utm.hasUtm ? utm : null;
  }

  void _logUtm(String slug, CpUtmData? utm) {
    if (utm == null || !utm.hasUtm) return;
    // TODO CODE-073 : analytics_service.track('deep_link_opened', {
    //   'case_slug': slug,
    //   ...utm.toMap(),
    // });
    debugPrint('[CpDeepLinks] UTM slug=$slug ${utm.toMap()}');
  }

  // ─────────────────────────── Génération URL ───────────────────────────────

  /// Génère l'URL de partage pour un cas.
  ///
  /// Ex. `CpDeepLinksHandler.I.shareUrl('case_3')` → `https://app.copiq.fr/c/case_3`
  String shareUrl(
    String caseSlug, {
    String? utmSource,
    String? utmMedium,
    String? utmCampaign,
  }) {
    final params = <String, String>{};
    if (utmSource != null) params['utm_source'] = utmSource;
    if (utmMedium != null) params['utm_medium'] = utmMedium;
    if (utmCampaign != null) params['utm_campaign'] = utmCampaign;

    final uri = Uri(
      scheme: 'https',
      host: _appHost,
      path: '/c/$caseSlug',
      queryParameters: params.isEmpty ? null : params,
    );
    return uri.toString();
  }
}
