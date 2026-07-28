// COP'IQ — Épreuve de photolangage PA : modèles, repository, utilitaires.
// Les cas sont chargés depuis Supabase (photolangage_cases). Les brouillons
// sont sauvegardés localement (SharedPreferences) ET à distance
// (photolangage_drafts). La correction passe par l'Edge Function sécurisée
// `photolangage-correct` — aucune clé IA côté client.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ======================================================================
//                               ROUTES
// ======================================================================

class PaPhotolangageRoutes {
  static const home = '/pa_exam/concours/photolangage';
  static const analyse = '/pa_exam/concours/photolangage/analyse';
  static const etapes = '/pa_exam/concours/photolangage/etapes_reussite';
  static const entrainements = '/pa_exam/concours/photolangage/entrainements';
  static const historique = '/pa_exam/concours/photolangage/historique';
}

// ======================================================================
//                               MODÈLES
// ======================================================================

class PhotolangageCase {
  final String id;
  final int order;
  final String title;
  final String? shortDescription;
  final String imageUrl;
  final String imageAlt;
  final String difficulty; // decouverte | intermediaire | avancee
  final int durationSeconds;
  final int minimumCharacters;
  final int minimumWords;
  final int recommendedCharacters;
  final bool isPremium;
  final List<String> pedagogicalTips;
  final int version;

  const PhotolangageCase({
    required this.id,
    required this.order,
    required this.title,
    required this.shortDescription,
    required this.imageUrl,
    required this.imageAlt,
    required this.difficulty,
    required this.durationSeconds,
    required this.minimumCharacters,
    required this.minimumWords,
    required this.recommendedCharacters,
    required this.isPremium,
    required this.pedagogicalTips,
    required this.version,
  });

  String get difficultyLabel => switch (difficulty) {
    'intermediaire' => 'Intermédiaire',
    'avancee' => 'Avancée',
    _ => 'Découverte',
  };

  factory PhotolangageCase.fromMap(Map<String, dynamic> m) {
    List<String> strList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : const [];
    return PhotolangageCase(
      id: (m['id'] ?? '').toString(),
      order: (m['case_order'] as num?)?.toInt() ?? 0,
      title: (m['title'] ?? '').toString(),
      shortDescription: m['short_description']?.toString(),
      imageUrl: (m['image_url'] ?? '').toString(),
      imageAlt: (m['image_alt'] ?? '').toString(),
      difficulty: (m['difficulty'] ?? 'decouverte').toString(),
      durationSeconds: (m['duration_seconds'] as num?)?.toInt() ?? 1200,
      minimumCharacters: (m['minimum_characters'] as num?)?.toInt() ?? 900,
      minimumWords: (m['minimum_words'] as num?)?.toInt() ?? 140,
      recommendedCharacters:
          (m['recommended_characters'] as num?)?.toInt() ?? 1300,
      isPremium: m['is_premium'] == true,
      pedagogicalTips: strList(m['pedagogical_tips']),
      version: (m['version'] as num?)?.toInt() ?? 1,
    );
  }
}

class PhotolangageDraft {
  final String caseId;
  final String text;
  final DateTime? startedAt;
  final DateTime? deadline;
  final DateTime lastSavedAt;
  final int caseVersion;

  const PhotolangageDraft({
    required this.caseId,
    required this.text,
    required this.startedAt,
    required this.deadline,
    required this.lastSavedAt,
    required this.caseVersion,
  });

  bool get timerStarted => startedAt != null && deadline != null;

  Map<String, dynamic> toJson() => {
    'caseId': caseId,
    'text': text,
    'startedAt': startedAt?.toUtc().toIso8601String(),
    'deadline': deadline?.toUtc().toIso8601String(),
    'lastSavedAt': lastSavedAt.toUtc().toIso8601String(),
    'caseVersion': caseVersion,
  };

  factory PhotolangageDraft.fromJson(Map<String, dynamic> m) {
    DateTime? ts(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString())?.toUtc();
    return PhotolangageDraft(
      caseId: (m['caseId'] ?? m['case_id'] ?? '').toString(),
      text: (m['text'] ?? '').toString(),
      startedAt: ts(m['startedAt'] ?? m['started_at']),
      deadline: ts(m['deadline']),
      lastSavedAt:
          ts(m['lastSavedAt'] ?? m['last_saved_at']) ?? DateTime.now().toUtc(),
      caseVersion:
          (m['caseVersion'] as num?)?.toInt() ??
          (m['case_version'] as num?)?.toInt() ??
          1,
    );
  }
}

class PhotolangageAttempt {
  final String id;
  final String caseId;
  final String status;
  final String correctionStatus;
  final int? pedagogicalScore;
  final int wordCount;
  final int characterCount;
  final DateTime? submittedAt;
  final Map<String, dynamic>? correctionPayload;
  final String rawText;

  const PhotolangageAttempt({
    required this.id,
    required this.caseId,
    required this.status,
    required this.correctionStatus,
    required this.pedagogicalScore,
    required this.wordCount,
    required this.characterCount,
    required this.submittedAt,
    required this.correctionPayload,
    required this.rawText,
  });

  factory PhotolangageAttempt.fromMap(Map<String, dynamic> m) {
    return PhotolangageAttempt(
      id: (m['id'] ?? '').toString(),
      caseId: (m['case_id'] ?? '').toString(),
      status: (m['status'] ?? 'submitted').toString(),
      correctionStatus: (m['correction_status'] ?? 'pending').toString(),
      pedagogicalScore: (m['pedagogical_score'] as num?)?.toInt(),
      wordCount: (m['word_count'] as num?)?.toInt() ?? 0,
      characterCount: (m['character_count'] as num?)?.toInt() ?? 0,
      submittedAt: m['submitted_at'] == null
          ? null
          : DateTime.tryParse(m['submitted_at'].toString())?.toLocal(),
      correctionPayload: m['correction_payload'] is Map
          ? Map<String, dynamic>.from(m['correction_payload'] as Map)
          : null,
      rawText: (m['raw_text'] ?? '').toString(),
    );
  }
}

// ======================================================================
//                        UTILITAIRES TEXTE
// ======================================================================

class PaPhotolangageTextUtils {
  /// Longueur du texte nettoyé (espaces multiples réduits, invisibles retirés).
  static String cleaned(String raw) => raw
      .replaceAll(RegExp('[\\u200B-\\u200D\\uFEFF]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static int charCount(String raw) => cleaned(raw).length;

  static int wordCount(String raw) {
    final matches = RegExp(r"[A-Za-zÀ-ÖØ-öø-ÿœŒ'-]+").allMatches(cleaned(raw));
    return matches.length;
  }

  /// Détection anti-contournement non punitive.
  /// Retourne null si le texte est normal, sinon un message explicatif.
  static String? antiGamingIssue(String raw) {
    final text = cleaned(raw).toLowerCase();
    final words = RegExp(
      r"[a-zà-öø-ÿœ'-]+",
    ).allMatches(text).map((m) => m.group(0)!).toList();
    if (words.length < 60) return null;

    final unique = words.toSet();
    final uniqueRatio = unique.length / words.length;
    if (uniqueRatio < 0.28) {
      return 'Ton texte contient beaucoup de répétitions. Décris de '
          'nouveaux éléments de l’image plutôt que de répéter les mêmes mots.';
    }

    final freq = <String, int>{};
    for (final w in words) {
      if (w.length > 3) freq[w] = (freq[w] ?? 0) + 1;
    }
    for (final e in freq.entries) {
      if (e.value / words.length > 0.12) {
        return 'Le mot « ${e.key} » revient très souvent. Varie ton '
            'vocabulaire pour enrichir ta description.';
      }
    }

    final nonLinguistic = text.replaceAll(
      RegExp(r"[a-zà-öø-ÿœ0-9\s.,;:!?'’()\-]"),
      '',
    );
    if (nonLinguistic.length > text.length * 0.15) {
      return 'Ton texte contient de nombreux caractères non linguistiques. '
          'Rédige des phrases complètes en français.';
    }
    return null;
  }
}

// ======================================================================
//                            REPOSITORY
// ======================================================================

class PaPhotolangageRepository {
  PaPhotolangageRepository._();
  static final instance = PaPhotolangageRepository._();

  final SupabaseClient _sb = Supabase.instance.client;

  String? get userId => _sb.auth.currentUser?.id;

  String _localDraftKey(String caseId) => 'pa_photolangage_draft_$caseId';

  // ------------------------------ CAS ------------------------------

  List<PhotolangageCase>? _casesCache;

  Future<List<PhotolangageCase>> fetchCases({bool force = false}) async {
    if (!force && _casesCache != null) return _casesCache!;
    final rows = await _sb
        .from('photolangage_cases')
        .select()
        .eq('is_published', true)
        .order('case_order', ascending: true);
    _casesCache = List<Map<String, dynamic>>.from(
      rows as List,
    ).map(PhotolangageCase.fromMap).toList();
    return _casesCache!;
  }

  // --------------------------- BROUILLONS ---------------------------

  Future<PhotolangageDraft?> loadDraft(String caseId) async {
    // 1. Local d'abord (survit au hors-ligne).
    PhotolangageDraft? local;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_localDraftKey(caseId));
      if (raw != null) {
        local = PhotolangageDraft.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw) as Map),
        );
      }
    } catch (_) {}

    // 2. Distant ensuite ; on garde le plus récent.
    try {
      final uid = userId;
      if (uid != null) {
        final row = await _sb
            .from('photolangage_drafts')
            .select()
            .eq('user_id', uid)
            .eq('case_id', caseId)
            .maybeSingle();
        if (row != null) {
          final remote = PhotolangageDraft.fromJson(
            Map<String, dynamic>.from(row),
          );
          if (local == null || remote.lastSavedAt.isAfter(local.lastSavedAt)) {
            return remote;
          }
        }
      }
    } catch (_) {}
    return local;
  }

  Future<void> saveDraft(PhotolangageDraft draft, {bool remote = true}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _localDraftKey(draft.caseId),
        jsonEncode(draft.toJson()),
      );
    } catch (_) {}
    if (!remote) return;
    try {
      final uid = userId;
      if (uid == null) return;
      await _sb.from('photolangage_drafts').upsert({
        'user_id': uid,
        'case_id': draft.caseId,
        'text': draft.text,
        'started_at': draft.startedAt?.toIso8601String(),
        'deadline': draft.deadline?.toIso8601String(),
        'last_saved_at': draft.lastSavedAt.toIso8601String(),
        'case_version': draft.caseVersion,
      });
    } catch (e) {
      debugPrint('photolangage draft remote save failed: $e');
    }
  }

  Future<void> deleteDraft(String caseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localDraftKey(caseId));
    } catch (_) {}
    try {
      final uid = userId;
      if (uid == null) return;
      await _sb
          .from('photolangage_drafts')
          .delete()
          .eq('user_id', uid)
          .eq('case_id', caseId);
    } catch (_) {}
  }

  /// Brouillon actif le plus récent (pour « Reprendre mon exercice »).
  Future<PhotolangageDraft?> latestActiveDraft() async {
    try {
      final uid = userId;
      if (uid == null) return null;
      final rows = await _sb
          .from('photolangage_drafts')
          .select()
          .eq('user_id', uid)
          .order('last_saved_at', ascending: false)
          .limit(1);
      final list = List<Map<String, dynamic>>.from(rows as List);
      if (list.isEmpty) return null;
      return PhotolangageDraft.fromJson(list.first);
    } catch (_) {
      return null;
    }
  }

  // --------------------------- TENTATIVES ---------------------------

  Future<String> insertAttempt({
    required PhotolangageCase c,
    required String rawText,
    required DateTime startedAt,
    required int remainingSeconds,
    required bool expiredIncomplete,
  }) async {
    final row = await _sb
        .from('photolangage_attempts')
        .insert({
          'case_id': c.id,
          'case_version': c.version,
          'raw_text': rawText,
          'started_at': startedAt.toIso8601String(),
          'submitted_at': DateTime.now().toUtc().toIso8601String(),
          'elapsed_seconds': c.durationSeconds - remainingSeconds,
          'remaining_seconds_at_submit': remainingSeconds,
          'character_count': PaPhotolangageTextUtils.charCount(rawText),
          'word_count': PaPhotolangageTextUtils.wordCount(rawText),
          'status': expiredIncomplete ? 'expired_incomplete' : 'submitted',
        })
        .select('id')
        .single();
    return (row['id'] ?? '').toString();
  }

  /// Appelle l'Edge Function de correction. Lève une exception en cas
  /// d'échec réseau ; le résultat est aussi persisté côté serveur.
  Future<Map<String, dynamic>> correctAttempt(String attemptId) async {
    final res = await _sb.functions.invoke(
      'photolangage-correct',
      body: {'attemptId': attemptId, 'language': 'fr-FR'},
    );
    final data = res.data;
    if (data is Map && data['payload'] is Map) {
      return Map<String, dynamic>.from(data['payload'] as Map);
    }
    throw Exception('Réponse de correction invalide');
  }

  Future<List<PhotolangageAttempt>> fetchAttempts({int limit = 100}) async {
    final uid = userId;
    if (uid == null) return const [];
    final rows = await _sb
        .from('photolangage_attempts')
        .select(
          'id, case_id, status, correction_status, pedagogical_score, '
          'word_count, character_count, submitted_at, correction_payload, '
          'raw_text',
        )
        .eq('user_id', uid)
        .order('submitted_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(
      rows as List,
    ).map(PhotolangageAttempt.fromMap).toList();
  }
}
