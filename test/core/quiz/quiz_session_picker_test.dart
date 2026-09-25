import 'package:copiqpolice/core/quiz/quiz_session_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('affiche les durées disponibles après le niveau', (tester) async {
    SharedPreferences.setMockInitialValues({});
    QuizSessionChoice? choice;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () async {
                choice = await showQuizSessionPicker(
                  context,
                  availableQuestions: 42,
                );
              },
              child: const Text('Ouvrir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ouvrir'));
    await tester.pumpAndSettle();

    expect(find.text('Combien de questions ?'), findsOneWidget);
    expect(find.text('Session rapide'), findsOneWidget);
    expect(find.text('Session standard'), findsOneWidget);
    expect(find.text('Session intensive'), findsNothing);
    expect(find.text('Toutes les questions'), findsOneWidget);

    await tester.tap(find.text('Session standard'));
    await tester.pumpAndSettle();

    expect(choice?.questionCount, 20);
    expect(choice?.isFull, isFalse);
  });

  testWidgets('la session personnalisée refuse une valeur hors limites', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () =>
                  showQuizSessionPicker(context, availableQuestions: 30),
              child: const Text('Ouvrir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ouvrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personnalisée'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '2');
    await tester.tap(find.text('Continuer'));
    await tester.pump();

    expect(find.text('Choisis un nombre entre 5 et 30.'), findsOneWidget);
  });
}
