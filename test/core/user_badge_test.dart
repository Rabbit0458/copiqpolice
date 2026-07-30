// test/core/user_badge_test.dart
//
// Tests unitaires de la logique de priorité des badges (UserBadgeType).
// La source de vérité réelle est la fonction SQL compute_badge_type() ;
// ce test couvre le calcul de secours côté client
// (UserBadgeType.fromRoleAndQuizCount), qui doit rester rigoureusement
// identique en priorité et en seuils.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/widgets/user_verification_badge.dart';

void main() {
  group('UserBadgeType.fromRoleAndQuizCount — priorité et seuils', () {
    test('admin + 0 quiz = badge admin', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(role: 'admin', quizAttemptsCount: 0),
        UserBadgeType.admin,
      );
    });

    test('admin + 500 quiz = badge admin (aucun quota pour admin)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'admin',
          quizAttemptsCount: 500,
        ),
        UserBadgeType.admin,
      );
    });

    test('owner = badge admin (owner est admin-équivalent)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(role: 'owner', quizAttemptsCount: 0),
        UserBadgeType.admin,
      );
    });

    test('moderator + 0 quiz = badge modérateur', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'moderator',
          quizAttemptsCount: 0,
        ),
        UserBadgeType.moderator,
      );
    });

    test('moderator + 500 quiz = badge modérateur (aucun quota)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'moderator',
          quizAttemptsCount: 500,
        ),
        UserBadgeType.moderator,
      );
    });

    test('user + 0 quiz = aucun badge', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(role: 'user', quizAttemptsCount: 0),
        UserBadgeType.none,
      );
    });

    test('user + 99 quiz = aucun badge (juste sous le seuil)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'user',
          quizAttemptsCount: 99,
        ),
        UserBadgeType.none,
      );
    });

    test('user + 100 quiz = badge actif (bleu)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'user',
          quizAttemptsCount: 100,
        ),
        UserBadgeType.active,
      );
    });

    test('user + 101 quiz = badge actif (bleu)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'user',
          quizAttemptsCount: 101,
        ),
        UserBadgeType.active,
      );
    });

    test('user + 1999 quiz = badge actif (juste sous le seuil légende)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'user',
          quizAttemptsCount: 1999,
        ),
        UserBadgeType.active,
      );
    });

    test('user + 2000 quiz = badge légende (violet)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'user',
          quizAttemptsCount: 2000,
        ),
        UserBadgeType.legend,
      );
    });

    test("rôle 'active' (compte standard actif, pas le badge bleu) + 0 quiz = aucun badge", () {
      // 'active' est la valeur PAR DÉFAUT de l'enum user_role en base
      // (compte activé, rien à voir avec le badge "très actif"). Ne doit
      // jamais déclencher le badge bleu à lui seul.
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'active',
          quizAttemptsCount: 0,
        ),
        UserBadgeType.none,
      );
    });

    test('rôle inconnu + 0 quiz = aucun badge (jamais admin par défaut)', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(
          role: 'guest_super_admin',
          quizAttemptsCount: 0,
        ),
        UserBadgeType.none,
      );
    });

    test('rôle inconnu ne donne jamais admin/modérateur, même avec beaucoup de quiz', () {
      // Un rôle non reconnu ne doit jamais déclencher admin/modérateur —
      // seule l'activité réelle (quiz) peut encore donner actif/légende.
      final result = UserBadgeType.fromRoleAndQuizCount(
        role: 'guest_super_admin',
        quizAttemptsCount: 99999,
      );
      expect(result, isNot(UserBadgeType.admin));
      expect(result, isNot(UserBadgeType.moderator));
    });

    test('rôle null = aucun badge', () {
      expect(
        UserBadgeType.fromRoleAndQuizCount(role: null, quizAttemptsCount: 0),
        UserBadgeType.none,
      );
    });
  });

  group('UserBadgeType.fromString — parsing des réponses RPC', () {
    test('parse chaque valeur connue', () {
      expect(UserBadgeType.fromString('admin'), UserBadgeType.admin);
      expect(UserBadgeType.fromString('moderator'), UserBadgeType.moderator);
      expect(UserBadgeType.fromString('legend'), UserBadgeType.legend);
      expect(UserBadgeType.fromString('active'), UserBadgeType.active);
      expect(UserBadgeType.fromString('none'), UserBadgeType.none);
    });

    test('valeur inconnue ou nulle retombe sur none, jamais sur admin', () {
      expect(UserBadgeType.fromString(null), UserBadgeType.none);
      expect(UserBadgeType.fromString(''), UserBadgeType.none);
      expect(UserBadgeType.fromString('superadmin'), UserBadgeType.none);
    });
  });

  group('UserVerificationBadge widget', () {
    testWidgets('badge none rend un SizedBox.shrink, aucun CustomPaint', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: UserVerificationBadge(type: UserBadgeType.none),
        ),
      );
      final badgeFinder = find.byType(UserVerificationBadge);
      expect(badgeFinder, findsOneWidget);
      expect(
        find.descendant(of: badgeFinder, matching: find.byType(SizedBox)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: badgeFinder, matching: find.byType(CustomPaint)),
        findsNothing,
      );
    });

    testWidgets('badge admin rend un CustomPaint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: UserVerificationBadge(type: UserBadgeType.admin),
        ),
      );
      final badgeFinder = find.byType(UserVerificationBadge);
      expect(
        find.descendant(of: badgeFinder, matching: find.byType(CustomPaint)),
        findsOneWidget,
      );
    });
  });
}
