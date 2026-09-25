import 'package:copiqpolice/features/active/active_access_service.dart';
import 'package:copiqpolice/features/onboarding/mode_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ActiveModeConfig _config({required bool available, required int revision}) {
  return ActiveModeConfig(
    enabled: available,
    available: available,
    ownerPreviewActive: false,
    revision: revision,
    disableMessage: 'Maintenance',
    countdownSeconds: 30,
  );
}

void main() {
  testWidgets('le geste actualiser relit la visibilité du mode actif', (
    tester,
  ) async {
    var available = false;
    var revision = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: ModePickerScreen(
          activeModeRefreshInterval: Duration.zero,
          activeModeConfigLoader: () async =>
              _config(available: available, revision: revision),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Je suis actif'), findsNothing);

    available = true;
    revision = 2;
    final refresh = tester
        .state<RefreshIndicatorState>(find.byType(RefreshIndicator))
        .show();
    await tester.pumpAndSettle();
    await refresh;

    expect(find.text('Je suis actif'), findsOneWidget);
  });

  testWidgets('le sélecteur se synchronise automatiquement avec le panel', (
    tester,
  ) async {
    var available = false;
    var revision = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: ModePickerScreen(
          activeModeRefreshInterval: const Duration(seconds: 1),
          activeModeConfigLoader: () async =>
              _config(available: available, revision: revision),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Je suis actif'), findsNothing);

    available = true;
    revision = 2;
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Je suis actif'), findsOneWidget);

    available = false;
    revision = 3;
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Je suis actif'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
