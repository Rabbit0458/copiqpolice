// lib/core/widgets/user_verification_badge.dart
//
// COP'IQ — Badge de vérification affiché à côté d'un nom/pseudonyme.
// Source de vérité unique de la logique et du dessin : un seul pictogramme
// (sceau à pointes + coche, dessiné en CustomPainter donc net à toute
// densité d'écran) recoloré selon le statut. Ne JAMAIS dupliquer cette
// logique de couleur/priorité ailleurs dans l'app — passer par
// [UserBadgeType.fromRoleAndQuizCount] ou [UserBadgeType.fromString].
//
// Priorité (un seul badge à la fois) : admin > modérateur > légende > actif > aucun.
import 'dart:math' as math;

import 'package:flutter/material.dart';

enum UserBadgeType {
  none,
  active, // bleu — >= 100 quiz lancés
  legend, // violet — >= 2000 quiz lancés
  moderator, // jaune/doré
  admin; // rouge — owner ou admin

  /// Construit le type de badge depuis la valeur `badge_type` renvoyée par
  /// les RPC Supabase (`get_my_entitlement`, `get_public_profile_badges`).
  /// Toute valeur inconnue ou nulle retombe sur [UserBadgeType.none] —
  /// jamais sur admin par défaut.
  static UserBadgeType fromString(String? value) {
    switch (value) {
      case 'admin':
        return UserBadgeType.admin;
      case 'moderator':
        return UserBadgeType.moderator;
      case 'legend':
        return UserBadgeType.legend;
      case 'active':
        return UserBadgeType.active;
      default:
        return UserBadgeType.none;
    }
  }

  /// Calcul local de secours (le calcul faisant foi reste côté serveur, via
  /// `compute_badge_type()` en base — cette fonction ne doit servir qu'à de
  /// l'affichage cohérent si jamais le champ `badge_type` n'est pas encore
  /// disponible dans une réponse, jamais à décider un droit).
  static UserBadgeType fromRoleAndQuizCount({
    required String? role,
    required int quizAttemptsCount,
  }) {
    if (role == 'owner' || role == 'admin') return UserBadgeType.admin;
    if (role == 'moderator') return UserBadgeType.moderator;
    if (quizAttemptsCount >= 2000) return UserBadgeType.legend;
    if (quizAttemptsCount >= 100) return UserBadgeType.active;
    return UserBadgeType.none;
  }

  Color get color => switch (this) {
    UserBadgeType.admin => const Color(0xFFE53935),
    UserBadgeType.moderator => const Color(0xFFFBC02D),
    UserBadgeType.legend => const Color(0xFF8B5CF6),
    UserBadgeType.active => const Color(0xFF42A5F5),
    UserBadgeType.none => Colors.transparent,
  };

  String get semanticLabel => switch (this) {
    UserBadgeType.admin => 'Compte administrateur vérifié',
    UserBadgeType.moderator => 'Compte modérateur vérifié',
    UserBadgeType.legend => 'Membre légende (2000+ quiz lancés)',
    UserBadgeType.active => 'Membre très actif (100+ quiz lancés)',
    UserBadgeType.none => '',
  };

  String get tooltip => switch (this) {
    UserBadgeType.admin => 'Administrateur COP\'IQ',
    UserBadgeType.moderator => 'Modérateur COP\'IQ',
    UserBadgeType.legend => 'Membre légende — 2000+ quiz lancés',
    UserBadgeType.active => 'Membre très actif — 100+ quiz lancés',
    UserBadgeType.none => '',
  };
}

/// Vignette de vérification à afficher à droite d'un nom ou pseudonyme.
/// Retourne [SizedBox.shrink] pour [UserBadgeType.none] — jamais d'espace
/// vide, de badge gris ni d'icône transparente.
class UserVerificationBadge extends StatelessWidget {
  const UserVerificationBadge({super.key, required this.type, this.size = 18});

  final UserBadgeType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (type == UserBadgeType.none) return const SizedBox.shrink();

    final badge = Semantics(
      label: type.semanticLabel,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _SealBadgePainter(color: type.color)),
      ),
    );

    return Tooltip(message: type.tooltip, child: badge);
  }
}

class _SealBadgePainter extends CustomPainter {
  const _SealBadgePainter({required this.color});

  final Color color;

  static const int _points = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.80;

    final sealPath = Path();
    for (int i = 0; i < _points * 2; i++) {
      final isOuter = i.isEven;
      final radius = isOuter ? outerRadius : innerRadius;
      final angle = (i * math.pi) / _points - math.pi / 2;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        sealPath.moveTo(point.dx, point.dy);
      } else {
        sealPath.lineTo(point.dx, point.dy);
      }
    }
    sealPath.close();

    canvas.drawPath(sealPath, Paint()..color = color..style = PaintingStyle.fill);

    // Coche : blanc légèrement bleuté pour rester lisible sur les 4 couleurs.
    final checkPaint = Paint()
      ..color = const Color(0xFFEAF3FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path()
      ..moveTo(size.width * 0.28, size.height * 0.52)
      ..lineTo(size.width * 0.44, size.height * 0.68)
      ..lineTo(size.width * 0.74, size.height * 0.34);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant _SealBadgePainter oldDelegate) =>
      oldDelegate.color != color;
}
