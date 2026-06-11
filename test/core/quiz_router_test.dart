// test/core/quiz_router_test.dart
//
// Tests unitaires du QuizRouter : la logique de réécriture des routes quiz
// selon le user_track.

import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/services/quiz_router.dart';
import 'package:copiqpolice/core/services/user_context_service.dart';

void main() {
  group('QuizRouter.isQuizRoute', () {
    test('détecte une route GPX', () {
      expect(
        QuizRouter.isQuizRoute('/gpx/generalites/quiz/tentative'),
        isTrue,
      );
    });
    test('détecte une route PA', () {
      expect(
        QuizRouter.isQuizRoute('/pa/generalites/quiz/tentative'),
        isTrue,
      );
    });
    test('détecte une route Reserve', () {
      expect(
        QuizRouter.isQuizRoute('/reserve/generalites/quiz/tentative'),
        isTrue,
      );
    });
    test('ignore une route hors quiz', () {
      expect(QuizRouter.isQuizRoute('/gpx/generalites/infraction'), isFalse);
      expect(QuizRouter.isQuizRoute('/home'), isFalse);
      expect(QuizRouter.isQuizRoute(null), isFalse);
      expect(QuizRouter.isQuizRoute(''), isFalse);
    });
  });

  group('QuizRouter.resolve', () {
    test('track=gpx => keep pour route /gpx/', () {
      final d = QuizRouter.resolve(
        '/gpx/generalites/quiz/tentative',
        trackOverride: UserTracks.gpx,
      );
      expect(d.resolution, QuizRouteResolution.keep);
    });

    test('track=gpx => rewrite si route /pa/', () {
      final d = QuizRouter.resolve(
        '/pa/generalites/quiz/tentative',
        trackOverride: UserTracks.gpx,
      );
      expect(d.resolution, QuizRouteResolution.rewrite);
      expect(d.rewrittenRoute, '/gpx/generalites/quiz/tentative');
    });

    test('track=pa => rewrite /gpx/ vers /pa/', () {
      final d = QuizRouter.resolve(
        '/gpx/generalites/quiz/tentative',
        trackOverride: UserTracks.pa,
      );
      expect(d.resolution, QuizRouteResolution.rewrite);
      expect(d.rewrittenRoute, '/pa/generalites/quiz/tentative');
    });

    test('track=pa => keep si déjà /pa/', () {
      final d = QuizRouter.resolve(
        '/pa/generalites/quiz/tentative',
        trackOverride: UserTracks.pa,
      );
      expect(d.resolution, QuizRouteResolution.keep);
    });

    test('track=reserve sur route /gpx/ => rewrite vers /pa/', () {
      final d = QuizRouter.resolve(
        '/gpx/generalites/quiz/tentative',
        trackOverride: UserTracks.reserve,
      );
      expect(d.resolution, QuizRouteResolution.rewrite);
      expect(d.rewrittenRoute, '/pa/generalites/quiz/tentative');
    });

    test('track=reserve sur route /pa/ => keep', () {
      final d = QuizRouter.resolve(
        '/pa/generalites/quiz/tentative',
        trackOverride: UserTracks.reserve,
      );
      expect(d.resolution, QuizRouteResolution.keep);
    });

    test('track=reserve sur route /reserve/ sans quiz codé => blocked', () {
      final d = QuizRouter.resolve(
        '/reserve/generalites/quiz/tentative',
        trackOverride: UserTracks.reserve,
      );
      expect(d.resolution, QuizRouteResolution.blocked);
    });

    test('route non quiz => keep peu importe le track', () {
      for (final t in [UserTracks.gpx, UserTracks.pa, UserTracks.reserve]) {
        final d = QuizRouter.resolve(
          '/gpx/generalites/infraction',
          trackOverride: t,
        );
        expect(d.resolution, QuizRouteResolution.keep);
      }
    });
  });

  group('UserTracks validation', () {
    test('isValid rejette null et inconnu', () {
      expect(UserTracks.isValid(null), isFalse);
      expect(UserTracks.isValid(''), isFalse);
      expect(UserTracks.isValid('pilot'), isFalse);
    });

    test('isValid accepte gpx/pa/reserve', () {
      expect(UserTracks.isValid('gpx'), isTrue);
      expect(UserTracks.isValid('pa'), isTrue);
      expect(UserTracks.isValid('reserve'), isTrue);
    });
  });

  group('UserModes validation', () {
    test('isValid accepte school/exam uniquement', () {
      expect(UserModes.isValid('school'), isTrue);
      expect(UserModes.isValid('exam'), isTrue);
      expect(UserModes.isValid('demo'), isFalse);
      expect(UserModes.isValid(null), isFalse);
    });
  });
}
