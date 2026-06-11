// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Badges service (gamification)                 ║
// ║  Tâche      : CODE-057                                                  ║
// ║                                                                         ║
// ║  Wrapper Dart sur les tables `cas_pratique_badges` (catalog) et        ║
// ║  `cas_pratique_user_badges` (unlocks) + la fonction                     ║
// ║  `fn_cp_check_and_unlock_badges(uuid)` créées par la migration         ║
// ║  20260518000004.                                                        ║
// ║                                                                         ║
// ║  - Modèle `Badge` (catalog entry).                                      ║
// ║  - Modèle `UnlockedBadge` = Badge + unlockedAt.                         ║
// ║  - Service singleton :                                                  ║
// ║     - listAll()              → catalog                                  ║
// ║     - listMyUnlocks()        → unlocks de l'user, joints au catalog    ║
// ║     - checkAndUnlock()       → appelle la fonction SQL, retourne les   ║
// ║                                badges débloqués dans les 5 sec.        ║
// ║     - Stream<List<Badge>> newUnlocks → émet après checkAndUnlock      ║
// ║       quand de nouveaux unlocks arrivent (pour toast premium UI).      ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Entrée du catalog.
class Badge {
  final String slug;
  final String label;
  final String description;
  final String icon;
  final String colorHex;
  final String kind;
  final int sortOrder;

  const Badge({
    required this.slug,
    required this.label,
    required this.description,
    required this.icon,
    required this.colorHex,
    required this.kind,
    required this.sortOrder,
  });

  factory Badge.fromJson(Map<String, dynamic> j) => Badge(
        slug: j['slug'] as String,
        label: j['label'] as String? ?? '',
        description: j['description'] as String? ?? '',
        icon: j['icon'] as String? ?? 'emoji_events_rounded',
        colorHex: j['color_hex'] as String? ?? '#1147D9',
        kind: j['kind'] as String? ?? 'progress',
        sortOrder: (j['sort_order'] is num)
            ? (j['sort_order'] as num).toInt()
            : 100,
      );
}

/// Une instance unlocked = catalog + date.
class UnlockedBadge {
  final Badge badge;
  final DateTime unlockedAt;
  final Map<String, dynamic> metadata;

  const UnlockedBadge({
    required this.badge,
    required this.unlockedAt,
    this.metadata = const {},
  });
}

/// Service singleton.
class BadgesService {
  BadgesService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final BadgesService instance = BadgesService._();

  final SupabaseClient _sb;
  final StreamController<List<Badge>> _newUnlocksCtrl =
      StreamController<List<Badge>>.broadcast();

  /// Stream des badges nouvellement débloqués (à brancher sur la UI pour toast).
  Stream<List<Badge>> get newUnlocks => _newUnlocksCtrl.stream;

  /// Cache local du catalog (chargé à la demande, TTL long).
  List<Badge>? _catalogCache;
  DateTime? _catalogCachedAt;
  static const Duration _kCatalogTtl = Duration(hours: 24);

  /// Charge le catalog (cache local 24h — catalog très statique).
  Future<List<Badge>> listAll({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _catalogCache != null &&
        _catalogCachedAt != null &&
        DateTime.now().difference(_catalogCachedAt!) < _kCatalogTtl) {
      return _catalogCache!;
    }
    try {
      final rows = await _sb
          .from('cas_pratique_badges')
          .select()
          .order('sort_order', ascending: true);
      final list = (rows as List)
          .whereType<Map<String, dynamic>>()
          .map(Badge.fromJson)
          .toList(growable: false);
      _catalogCache = list;
      _catalogCachedAt = DateTime.now();
      return list;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BadgesService] listAll failed: $e');
      }
      return _catalogCache ?? const [];
    }
  }

  /// Retourne les badges actuellement débloqués pour l'utilisateur courant.
  Future<List<UnlockedBadge>> listMyUnlocks() async {
    final userId = _sb.auth.currentUser?.id;
    if (userId == null) return const [];
    try {
      final rows = await _sb
          .from('cas_pratique_user_badges')
          .select('badge_slug, unlocked_at, metadata')
          .eq('user_id', userId)
          .order('unlocked_at', ascending: false);

      final catalog = await listAll();
      final bySlug = {for (final b in catalog) b.slug: b};

      final out = <UnlockedBadge>[];
      for (final r in (rows as List).whereType<Map<String, dynamic>>()) {
        final slug = r['badge_slug'] as String?;
        if (slug == null) continue;
        final b = bySlug[slug];
        if (b == null) continue;
        out.add(UnlockedBadge(
          badge: b,
          unlockedAt: DateTime.tryParse(
                  (r['unlocked_at'] ?? '').toString())?.toUtc() ??
              DateTime.now().toUtc(),
          metadata: r['metadata'] is Map<String, dynamic>
              ? r['metadata'] as Map<String, dynamic>
              : <String, dynamic>{},
        ));
      }
      return out;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BadgesService] listMyUnlocks failed: $e');
      }
      return const [];
    }
  }

  /// Déclenche la vérification + émet les nouveaux unlocks dans le stream.
  ///
  /// À appeler côté UI :
  ///   - après une correction validée (en plus du trigger SQL qui le fait déjà)
  ///   - manuellement depuis un écran de profil
  Future<List<Badge>> checkAndUnlock() async {
    final userId = _sb.auth.currentUser?.id;
    if (userId == null) return const [];
    try {
      final raw = await _sb.rpc(
        'fn_cp_check_and_unlock_badges',
        params: {'p_user_id': userId},
      );
      if (raw is! List) return const [];
      final slugs = raw.whereType<String>().toList(growable: false);
      if (slugs.isEmpty) return const [];

      final catalog = await listAll();
      final bySlug = {for (final b in catalog) b.slug: b};
      final newly = <Badge>[];
      for (final s in slugs) {
        final b = bySlug[s];
        if (b != null) newly.add(b);
      }
      if (newly.isNotEmpty) {
        _newUnlocksCtrl.add(newly);
      }
      return newly;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BadgesService] checkAndUnlock failed: $e');
      }
      return const [];
    }
  }

  Future<void> dispose() async {
    await _newUnlocksCtrl.close();
  }
}
