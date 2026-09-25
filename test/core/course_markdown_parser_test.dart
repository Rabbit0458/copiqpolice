import 'package:flutter_test/flutter_test.dart';

import 'package:copiqpolice/core/content/course_markdown_parser.dart';

void main() {
  group('parseCourseMarkdown', () {
    test('fusionne les retours à la ligne simples dans un même paragraphe', () {
      final blocks = parseCourseMarkdown(
        'Le policier adjoint est un agent\n'
        'contractuel recruté pour trois ans,\n'
        'renouvelable une fois.',
      );

      expect(blocks, hasLength(1));
      expect(blocks.single.type, CourseMarkdownBlockType.paragraph);
      expect(
        blocks.single.text,
        'Le policier adjoint est un agent contractuel recruté pour trois ans, '
        'renouvelable une fois.',
      );
    });

    test('répare aussi une emphase coupée par un retour éditorial', () {
      final blocks = parseCourseMarkdown(
        "La voie est ouverte : **aucun diplôme n'est\nexigé**.",
      );

      expect(
        blocks.single.text,
        "La voie est ouverte : **aucun diplôme n'est exigé**.",
      );
    });

    test('une ligne vide crée bien un nouveau paragraphe', () {
      final blocks = parseCourseMarkdown(
        'Premier paragraphe.\n\nSecond paragraphe.',
      );

      expect(blocks, hasLength(2));
      expect(blocks[0].text, 'Premier paragraphe.');
      expect(blocks[1].text, 'Second paragraphe.');
    });

    test('conserve la hiérarchie titres, listes et citations', () {
      final blocks = parseCourseMarkdown(
        '## À savoir\n'
        '- Première information qui\n'
        'continue sur une autre ligne\n'
        '- Deuxième information\n\n'
        '> Une citation\n'
        '> sur deux lignes',
      );

      expect(blocks, hasLength(3));
      expect(blocks[0].type, CourseMarkdownBlockType.heading);
      expect(blocks[0].headingLevel, 2);
      expect(blocks[1].type, CourseMarkdownBlockType.unorderedList);
      expect(blocks[1].items, [
        'Première information qui continue sur une autre ligne',
        'Deuxième information',
      ]);
      expect(blocks[2].type, CourseMarkdownBlockType.quote);
      expect(blocks[2].text, 'Une citation sur deux lignes');
    });

    test('retire la ligne de séparation des tableaux', () {
      final blocks = parseCourseMarkdown(
        '| Épreuve | Durée |\n'
        '|---|---|\n'
        '| QCM | 1 h |',
      );

      expect(blocks.single.type, CourseMarkdownBlockType.table);
      expect(blocks.single.rows, [
        ['Épreuve', 'Durée'],
        ['QCM', '1 h'],
      ]);
    });

    test(
      'conserve les vrais sauts forcés et accepte les fins de ligne CRLF',
      () {
        final blocks = parseCourseMarkdown('Ligne 1  \r\nLigne 2');

        expect(blocks.single.text, 'Ligne 1\nLigne 2');
      },
    );

    test('préserve le numéro de départ d’une liste ordonnée', () {
      final blocks = parseCourseMarkdown('3. Trois\n4. Quatre');

      expect(blocks.single.type, CourseMarkdownBlockType.orderedList);
      expect(blocks.single.listStart, 3);
      expect(blocks.single.items, ['Trois', 'Quatre']);
    });

    test('ne transforme pas une phrase avec pipe en tableau', () {
      final blocks = parseCourseMarkdown('| Ceci n’est pas un tableau');

      expect(blocks.single.type, CourseMarkdownBlockType.paragraph);
    });

    test(
      'accepte les tableaux sans pipes extérieurs et les pipes échappés',
      () {
        final blocks = parseCourseMarkdown(
          'Épreuve | Contenu\n'
          '--- | ---\n'
          r'QCM | Police \| justice',
        );

        expect(blocks.single.type, CourseMarkdownBlockType.table);
        expect(blocks.single.rows, [
          ['Épreuve', 'Contenu'],
          ['QCM', 'Police | justice'],
        ]);
      },
    );

    test('détecte un tableau même sans ligne vide avant son en-tête', () {
      final blocks = parseCourseMarkdown(
        'Introduction au tableau\n'
        'Épreuve | Durée\n'
        '--- | ---\n'
        'QCM | 1 h',
      );

      expect(blocks, hasLength(2));
      expect(blocks.first.type, CourseMarkdownBlockType.paragraph);
      expect(blocks.last.type, CourseMarkdownBlockType.table);
    });

    test('supporte les titres Markdown jusqu’au niveau six', () {
      final blocks = parseCourseMarkdown('###### Détail ######');

      expect(blocks.single.type, CourseMarkdownBlockType.heading);
      expect(blocks.single.headingLevel, 6);
      expect(blocks.single.text, 'Détail');
    });
  });
}
