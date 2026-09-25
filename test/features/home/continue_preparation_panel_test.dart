import 'package:copiqpolice/features/home/widgets/continue_preparation_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpPanel(
    WidgetTester tester, {
    required Size size,
    required Brightness brightness,
    TextScaler textScaler = TextScaler.noScaling,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSeeAll,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          brightness: brightness,
          scaffoldBackgroundColor: brightness == Brightness.dark
              ? const Color(0xFF0F1114)
              : const Color(0xFFF5F6F8),
          cardColor: brightness == Brightness.dark
              ? const Color(0xFF161A1E)
              : Colors.white,
        ),
        home: MediaQuery(
          data: MediaQueryData(size: size, textScaler: textScaler),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ContinuePreparationPanel(
                loading: false,
                hasActivity: true,
                activityTitle:
                    'PA – Quiz tests psychotechniques concentration',
                activitySubtitle:
                    'PA – Tests psychotechniques – Concentration',
                scorePercent: 72,
                streakDays: 4,
                doneToday: 1,
                dailyGoal: 3,
                onPrimaryTap: onPrimaryTap ?? () {},
                onSeeAll: onSeeAll ?? () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('reste lisible et interactif en thème sombre', (tester) async {
    var continued = false;
    var openedPath = false;

    await pumpPanel(
      tester,
      size: const Size(390, 844),
      brightness: Brightness.dark,
      onPrimaryTap: () => continued = true,
      onSeeAll: () => openedPath = true,
    );

    expect(find.text('Continue ta préparation'), findsOneWidget);
    expect(find.text('Mon parcours'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continuer'));
    await tester.pump();
    expect(continued, isTrue);

    await tester.tap(find.text('Mon parcours'));
    await tester.pump();
    expect(openedPath, isTrue);
  });

  testWidgets('ne déborde pas à 320 px avec texte agrandi', (tester) async {
    await pumpPanel(
      tester,
      size: const Size(320, 780),
      brightness: Brightness.light,
      textScaler: const TextScaler.linear(2),
    );

    expect(find.text('Continue ta préparation'), findsOneWidget);
    expect(find.text('Dernier score'), findsOneWidget);
    expect(find.text('jours de suite'), findsOneWidget);
    expect(find.text('objectif du jour'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('présente un départ clair sans historique', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContinuePreparationPanel(
            loading: false,
            hasActivity: false,
            activityTitle: null,
            activitySubtitle: null,
            scorePercent: null,
            streakDays: 0,
            doneToday: 0,
            dailyGoal: 3,
            onPrimaryTap: () {},
            onSeeAll: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Commence ta préparation'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
