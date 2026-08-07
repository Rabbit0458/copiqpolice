import 'package:copiqpolice/features/onboarding/pa_school.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la sélection PA reste lisible sur un écran étroit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: PaSchoolArt()));
    await tester.pumpAndSettle();

    expect(find.text('Recommandé aujourd’hui'), findsOneWidget);
    expect(find.text('Tous les programmes'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
