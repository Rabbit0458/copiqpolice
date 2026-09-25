import 'package:copiqpolice/features/onboarding/gpx_school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la sélection GPX reprend la hiérarchie premium de PA', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: GpxSchoolArt()));
    await tester.pumpAndSettle();

    expect(find.text('Recommandé aujourd’hui'), findsOneWidget);
    expect(find.text('Tous les programmes'), findsOneWidget);
    expect(find.text('6 disponibles'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);
    expect(find.text('Choisir'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('le tutoriel conserve APJ 20 comme programme accessible', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: GpxSchoolArt(lockToApj20Only: true)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Programme du tutoriel'), findsOneWidget);
    expect(find.text('Recueil de procès-verbaux (APJ 20)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('les deux socles d’intervention restent distinguables', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: GpxSchoolArt()));
    await tester.pumpAndSettle();

    for (final title in const [
      'Intervention — Socle initial',
      'Intervention — Socle avancé',
    ]) {
      await tester.scrollUntilVisible(
        find.text(title),
        160,
        scrollable: find.byType(Scrollable).first,
      );
      final text = tester.widget<Text>(find.text(title));
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.visible);
      expect(text.softWrap, isTrue);
    }

    expect(tester.takeException(), isNull);
  });
}
