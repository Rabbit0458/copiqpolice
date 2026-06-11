// ╔════════════════════════════════════════════════════════════════════════╗
// ║  COP'IQ — Cas Pratique — Referral service (parrainage)                 ║
// ║  Tâche      : CODE-060                                                  ║
// ║                                                                         ║
// ║  Consomme :                                                              ║
// ║   - fn_cp_get_or_create_my_referral_code() → code + stats               ║
// ║   - fn_cp_redeem_referral_code(p_code) → applique le code               ║
// ║                                                                         ║
// ║  Modèle immutable `ReferralCodeStatus` :                                ║
// ║   - code                                                                 ║
// ║   - createdAt                                                            ║
// ║   - referralsCount  (nb filleuls convertis)                             ║
// ║   - xpEarnedFromReferrals                                                ║
// ║   - xpPerReferral                                                        ║
// ║                                                                         ║
// ║  Helper `shareLink(baseUrl)` qui retourne l'URL deeplink à partager.   ║
// ╚════════════════════════════════════════════════════════════════════════╝

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReferralCodeStatus {
  final String code;
  final DateTime? createdAt;
  final int referralsCount;
  final int xpEarnedFromReferrals;
  final int xpPerReferral;

  const ReferralCodeStatus({
    required this.code,
    required this.createdAt,
    required this.referralsCount,
    required this.xpEarnedFromReferrals,
    required this.xpPerReferral,
  });

  static const ReferralCodeStatus empty = ReferralCodeStatus(
    code: '',
    createdAt: null,
    referralsCount: 0,
    xpEarnedFromReferrals: 0,
    xpPerReferral: 500,
  );

  bool get isValid => code.isNotEmpty;

  factory ReferralCodeStatus.fromJson(Map<String, dynamic> j) =>
      ReferralCodeStatus(
        code: (j['code'] ?? '').toString(),
        createdAt: j['created_at'] == null
            ? null
            : DateTime.tryParse(j['created_at'].toString())?.toUtc(),
        referralsCount: (j['referrals_count'] is num)
            ? (j['referrals_count'] as num).toInt()
            : 0,
        xpEarnedFromReferrals: (j['xp_earned_from_referrals'] is num)
            ? (j['xp_earned_from_referrals'] as num).toInt()
            : 0,
        xpPerReferral: (j['xp_per_referral'] is num)
            ? (j['xp_per_referral'] as num).toInt()
            : 500,
      );
}

enum RedeemError {
  notAuthenticated,
  invalidCode,
  codeNotFound,
  selfReferral,
  alreadyReferred,
  unknown,
}

class RedeemResult {
  final bool ok;
  final int xpAwarded;
  final RedeemError? error;

  const RedeemResult({required this.ok, required this.xpAwarded, this.error});

  factory RedeemResult.ok(int xp) =>
      RedeemResult(ok: true, xpAwarded: xp);

  factory RedeemResult.fail(RedeemError e) =>
      RedeemResult(ok: false, xpAwarded: 0, error: e);
}

class ReferralService {
  ReferralService._({SupabaseClient? client})
      : _sb = client ?? Supabase.instance.client;

  static final ReferralService instance = ReferralService._();

  final SupabaseClient _sb;

  ReferralCodeStatus? _cached;
  DateTime? _cachedAt;
  static const Duration _kCacheTtl = Duration(minutes: 5);

  /// Domaine de deeplink (à pointer vers le bon environnement).
  static const String _kBaseShareUrl =
      'https://copiqpolice.fr/r/'; // ex : https://copiqpolice.fr/r/AB3C2D

  Future<ReferralCodeStatus> getMyCode({bool forceRefresh = false}) async {
    if (!forceRefresh && _cached != null && _cachedAt != null) {
      if (DateTime.now().difference(_cachedAt!) < _kCacheTtl) {
        return _cached!;
      }
    }
    try {
      final raw = await _sb.rpc('fn_cp_get_or_create_my_referral_code');
      Map<String, dynamic> data;
      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is Map) {
        data = Map<String, dynamic>.from(raw);
      } else {
        data = const {};
      }
      if (data['error'] != null) return ReferralCodeStatus.empty;
      final status = ReferralCodeStatus.fromJson(data);
      _cached = status;
      _cachedAt = DateTime.now();
      return status;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ReferralService] getMyCode failed: $e');
      }
      return _cached ?? ReferralCodeStatus.empty;
    }
  }

  Future<RedeemResult> redeem(String code) async {
    final c = code.trim();
    if (c.isEmpty) return RedeemResult.fail(RedeemError.invalidCode);
    try {
      final raw = await _sb.rpc(
        'fn_cp_redeem_referral_code',
        params: {'p_code': c},
      );
      Map<String, dynamic> data;
      if (raw is Map<String, dynamic>) {
        data = raw;
      } else if (raw is Map) {
        data = Map<String, dynamic>.from(raw);
      } else {
        return RedeemResult.fail(RedeemError.unknown);
      }
      if (data['ok'] == true) {
        invalidate();
        return RedeemResult.ok(
          (data['xp_awarded'] is num) ? (data['xp_awarded'] as num).toInt() : 0,
        );
      }
      final err = (data['error'] ?? '').toString();
      switch (err) {
        case 'not_authenticated': return RedeemResult.fail(RedeemError.notAuthenticated);
        case 'invalid_code':      return RedeemResult.fail(RedeemError.invalidCode);
        case 'code_not_found':    return RedeemResult.fail(RedeemError.codeNotFound);
        case 'self_referral':     return RedeemResult.fail(RedeemError.selfReferral);
        case 'already_referred':  return RedeemResult.fail(RedeemError.alreadyReferred);
        default:                  return RedeemResult.fail(RedeemError.unknown);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ReferralService] redeem failed: $e');
      }
      return RedeemResult.fail(RedeemError.unknown);
    }
  }

  /// Construit le deeplink à partager. Ex: `https://copiqpolice.fr/r/AB3C2D`.
  String shareLink(String code) {
    if (code.isEmpty) return _kBaseShareUrl;
    return '$_kBaseShareUrl$code';
  }

  /// Construit un message prêt à partager (FR friendly).
  String shareMessage(String code) {
    final link = shareLink(code);
    return 'Rejoins-moi sur COP\'IQ pour réviser le concours de gardien de la paix : '
        'utilise mon code "$code" et on gagne chacun +500 XP.\n$link';
  }

  void invalidate() {
    _cachedAt = null;
  }
}
