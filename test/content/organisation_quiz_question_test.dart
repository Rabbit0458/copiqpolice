import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:copiqpolice/content/gpx_scolarite/quiz_scolarite_gpx/gpx_quiz_dynamique_page.dart';

void main() {
  test('conserve l’identifiant stable, la révision et le visuel', () {
    final question = QuizScolariteQuestion.fromJson({
      'id': 42,
      'category': 'Grades PN',
      'difficulty': 'Moyenne',
      'question': 'Quel grade est représenté ?',
      'options': ['A', 'B', 'C', 'D'],
      'answer': 'B',
      'explanation': 'Une correction détaillée.',
      'legal_ref': 'Référentiel COP’IQ',
      'revision': 3,
      'metadata': {
        'stable_key': 'organisation-grade-001',
        'question_type': 'image_to_grade',
        'image_asset': 'assets/grades/grade_001_directeur_general.png',
      },
    });

    expect(question.options, hasLength(4));
    expect(question.stableKey, 'organisation-grade-001');
    expect(question.revision, 3);
    expect(question.questionType, 'image_to_grade');
    expect(question.toJson()['metadata']['image_asset'], question.imageAsset);
  });

  test('les 25 planches de grades déclarées existent', () {
    for (var index = 1; index <= 25; index++) {
      final prefix = index.toString().padLeft(3, '0');
      final matches = Directory('assets/grades')
          .listSync()
          .whereType<File>()
          .where(
            (file) => file.path.split('/').last.startsWith('grade_$prefix'),
          );
      expect(matches, hasLength(1), reason: 'Planche $prefix manquante');
    }
  });
}
