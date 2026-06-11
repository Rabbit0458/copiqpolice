import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — SOURCES DES LIBERTÉS PUBLIQUES
///
///  Page d’étude complète inspirée du polycopié :
///
///   CHAPITRE 1 : ÉVOLUTION HISTORIQUE JUSQU’EN 1958
///     - Les apports antérieurs à 1789 (sources philosophiques & juridiques)
///     - La Déclaration des droits de l’Homme et du citoyen de 1789
///     - L’évolution postérieure (Révolutions, Empires, Républiques…)
///
///   CHAPITRE 2 : LES SOURCES ACTUELLES
///     - Préambule de la Constitution de 1958
///     - Textes internationaux (ONU, CEDH, droit international humanitaire)
///
///   CHAPITRE 3 : VALEUR JURIDIQUE DES SOURCES
///     - Hiérarchie des normes & place des libertés publiques
///
/// ===================================================================
class PaSourcesLibertesPubliquesPage extends StatelessWidget {
  const PaSourcesLibertesPubliquesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/introduction/sources';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF5E35B1)
        : const Color(0xFF512DA8);
    final Color referenceColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'Sources des libertés publiques',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            'Les sources des libertés publiques',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Les libertés dont nous bénéficions aujourd’hui en France sont le résultat '
                  'd’une construction historique longue. Textes philosophiques, déclarations '
                  'de droits, constitutions successives, conventions internationales : '
                  'chacun de ces éléments a contribué à forger le régime actuel des droits '
                  'et libertés publiques. ',
            ),
            TextSpan(
              text:
                  'Comprendre leurs sources permet au policier de situer juridiquement son action, '
                  'mais aussi de mesurer le poids symbolique de chaque atteinte à ces droits.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 18),

          // =====================================================
          // CHAPITRE 1 — ÉVOLUTION HISTORIQUE JUSQU’EN 1958
          // =====================================================
          const _NotaBox(
            title: 'Chapitre 1 — Évolution historique jusqu’en 1958',
            bodySpans: [
              TextSpan(
                text:
                    'Avant d’identifier les sources actuelles, il faut comprendre comment la '
                    'notion même de liberté publique s’est progressivement imposée : apports '
                    'philosophiques, révolutions politiques, textes de droits successifs…',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // -----------------------------------------------------
          // 1.1 — APPORTS ANTÉRIEURS À 1789 : SOURCES PHILOSOPHIQUES
          // -----------------------------------------------------
          _HypoCard(
            title:
                '1.1 — Les apports antérieurs à 1789\n1.1.1 — Les sources philosophiques',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Avant la Révolution française, plusieurs courants philosophiques ont '
                      'préparé le terrain à la reconnaissance des libertés publiques. Ils '
                      'constituent de véritables “sources intellectuelles” du droit des libertés.',
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'La pensée chrétienne : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'affirmation de l’égalité fondamentale de tous les hommes et valeur '
                      'de la personne humaine, qui doit être respectée en tant que créature '
                      'de Dieu. Cette idée sera reprise plus tard par le droit naturel.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'La théorie du droit naturel et du contrat social : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'développement, notamment chez Locke et Rousseau, de l’idée de droits '
                      'naturels, universels et inaliénables attachés à toute personne. '
                      'Le contrat social justifie la création de l’État, mais celui-ci ne peut '
                      'porter atteinte à ces droits que dans la mesure nécessaire au bien commun.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'La philosophie des Lumières (XVIIIᵉ siècle) : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'modélisation des systèmes politiques anglo-saxons, esprit de résistance '
                      'au pouvoir arbitraire, défense de la tolérance religieuse, de la '
                      'liberté d’expression et de la séparation des pouvoirs. Ces idées '
                      'circulent largement dans les Parlements et parmi les élites françaises.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // -----------------------------------------------------
          // 1.1.2 — SOURCES JURIDIQUES AVANT 1789
          // -----------------------------------------------------
          _HypoCard(
            title: '1.1.2 — Les sources juridiques avant 1789',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'À ces sources philosophiques s’ajoutent des textes juridiques étrangers qui '
                'proclament déjà des droits et organisent des garanties contre l’arbitraire.',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Les pactes anglais : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'de la Grande Charte de 1215 au Habeas Corpus (1679) puis au Bill of Rights (1689), '
                      'le roi s’engage progressivement à respecter certaines libertés '
                      '(sûreté, procès équitable, liberté politique) et à accepter le contrôle '
                      'du Parlement sur son pouvoir.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Les déclarations américaines : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'les colonies américaines, influencées par ces précédents anglais, '
                      'adoptent dès 1776 plusieurs déclarations de droits. On y retrouve '
                      'la notion d’égalité, l’affirmation de droits inaliénables (vie, liberté, '
                      'bonheur). Ces textes annoncent la Déclaration française de 1789.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // -----------------------------------------------------
          // 1.2 — DÉCLARATION DES DROITS DE L’HOMME ET DU CITOYEN
          // -----------------------------------------------------
          _HypoCard(
            title:
                '1.2 — La Déclaration des droits de l’Homme et du citoyen\n       du 26 août 1789',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Issue de l’Assemblée nationale constituante, la Déclaration de 1789 pose '
                      'les bases de la société nouvelle : souveraineté de la Nation, égalité, '
                      'droits naturels et séparation des pouvoirs. Elle devient la référence '
                      'majeure en matière de libertés publiques. ',
                ),
                TextSpan(
                  text:
                      'Ce texte a aujourd’hui valeur constitutionnelle en droit français.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Le polycopié met d’abord en avant les caractéristiques de la Déclaration, '
                'puis son contenu concret en matière de droits de l’Homme et du citoyen.',
              ),
              const SizedBox(height: 10),
              Text(
                '1.2.1 — Caractéristiques de la Déclaration de 1789',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'L’individualisme : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la Déclaration vise d’abord l’homme en tant qu’individu titulaire '
                      'de droits. Elle ne reconnaît pas de droits collectifs en tant que tels '
                      '(association, grève, syndicat…).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'L’aspect métaphysique : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'les droits proclamés sont présentés comme naturels, inaliénables et '
                      'sacrés, c’est-à-dire antérieurs et supérieurs au pouvoir politique.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'L’universalité : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'les droits énoncés valent pour “tous les hommes”, même si, en pratique, '
                      'ils ne s’appliquent alors qu’aux citoyens français.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Le caractère abstrait : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la Déclaration énonce de grands principes (liberté, égalité, sûreté, '
                      'propriété…) mais prévoit peu de mécanismes concrets de mise en œuvre.',
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                '1.2.2 — Contenu : droits de l’Homme et droits du citoyen',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Les droits de l’Homme : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'dignité, égalité (“les hommes naissent et demeurent libres et égaux en droits”), '
                      'liberté individuelle, liberté d’opinion et de religion, propriété, '
                      'résistance à l’oppression… Ces droits inspireront la plupart des libertés '
                      'publiques contemporaines.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Les droits du citoyen : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'droits politiques permettant la participation à la vie publique : '
                      'concours à la formation de la loi, consentement à l’impôt, accès aux '
                      'emplois publics, égalité devant les charges publiques, etc.',
                ),
              ]),
              const SizedBox(height: 6),
              const _ExempleBox(
                title: 'Idée-clé à retenir',
                bodySpans: [
                  TextSpan(
                    text:
                        'La Déclaration de 1789 ne se contente pas de “réciter” des valeurs. '
                        'Elle affirme que la finalité de toute institution politique est la '
                        'conservation de ces droits. Toute atteinte injustifiée aux libertés '
                        'publiques est donc, en principe, contraire à la vocation même de l’État.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // -----------------------------------------------------
          // 1.3 — ÉVOLUTION POSTÉRIEURE
          // -----------------------------------------------------
          _HypoCard(
            title: '1.3 — L’évolution postérieure (1789–1958)',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Après 1789, différents régimes se succèdent. Chacun réinterprète les droits '
                'et libertés proclamés, en les renforçant ou, au contraire, en les restreignant.',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: 'La Constituante (1789–1791) : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'mise en place d’un régime de monarchie constitutionnelle. Large liberté '
                      'de réunion et d’expression, développement de la presse et des clubs politiques.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Les projets de 1793 (Girondins, Montagnards) : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'nouvelles déclarations de droits plus sociales (droit au travail, à '
                      'l’instruction, aux secours publics…). Leur application reste toutefois '
                      'limitée par l’instabilité politique.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Directoire, Consulat et Empire (fin XVIIIᵉ – début XIXᵉ siècle) : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'périodes globalement défavorables aux libertés : censure de la presse, '
                      'contrôle des associations, commissions de sûreté, prisons d’État…',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Chartes de 1814 et 1830 : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'programme politique libéral, reconnaissance de certaines libertés '
                      'individuelles (culte, presse, égalité civile), mais suffrage censitaire '
                      'et maintien de fortes limitations.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Constitution de 1848 et IIᵉ République, Second Empire, IIIᵉ République, '
                      'préambule de 1946 : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'progressive affirmation des droits sociaux (travail, grève, protection '
                      'de la famille, instruction…) et élargissement du suffrage. La IIIᵉ '
                      'République consacre par diverses lois la liberté de réunion, de presse '
                      'et d’association. Le préambule de 1946 ajoute de nombreux droits '
                      'économiques et sociaux, toujours en vigueur aujourd’hui.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — SOURCES ACTUELLES
          // =====================================================
          const _NotaBox(
            title: 'Chapitre 2 — Les sources actuelles des libertés publiques',
            bodySpans: [
              TextSpan(
                text:
                    'Le régime contemporain des libertés publiques repose principalement '
                    'sur la Constitution de 1958 et sur des conventions internationales '
                    'ratifiées par la France, notamment celles relatives aux droits de l’Homme.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // -----------------------------------------------------
          // 2.1 — PRÉAMBULE DE 1958
          // -----------------------------------------------------
          _HypoCard(
            title:
                '2.1 — Le préambule de la Constitution du 4 octobre 1958\n       (5ᵉ République)',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le préambule de 1958 est la source interne principale des libertés '
                      'publiques en France. Il renvoie explicitement à : ',
                ),
                TextSpan(
                  text:
                      'la Déclaration de 1789, le préambule de 1946 et la Charte de '
                      'l’environnement de 2004',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Ces textes, reconnus comme ayant valeur constitutionnelle, forment '
                      'le “bloc de constitutionnalité”.',
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                'Ils ont été complétés par des lois importantes qui créent de nouveaux droits '
                'ou précisent la protection de libertés déjà existantes.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Droit au respect de la vie privée (loi du 17 juillet 1970) ; ',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Informatique et libertés (loi du 6 janvier 1978) ; ',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Droit d’accès aux documents administratifs (loi du 11 juillet 1979).',
                ),
              ]),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Conséquence pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Lorsqu’un policier applique une loi ou un règlement, il doit garder en tête '
                        'que ces textes doivent être compatibles avec le bloc de constitutionnalité. '
                        'En cas de doute sérieux, les justiciables peuvent saisir le Conseil '
                        'constitutionnel par la voie de la QPC.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // -----------------------------------------------------
          // 2.2 — TEXTES INTERNATIONAUX
          // -----------------------------------------------------
          _HypoCard(
            title: '2.2 — Les textes internationaux',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Les libertés publiques ne sont plus seulement protégées au niveau interne. '
                'Elles bénéficient aussi d’un ensemble de garanties internationales, '
                'issues principalement de l’Organisation des Nations Unies et du Conseil de l’Europe.',
              ),
              const SizedBox(height: 8),
              Text(
                '2.2.1 — Le droit des conflits armés / droit international humanitaire',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Convention de La Haye (1899–1907) : fixe des règles pour limiter les moyens '
                      'et méthodes de guerre, protéger les blessés et la population civile.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Conventions de Genève (12 août 1949) : protègent les prisonniers de guerre, '
                      'les blessés et les civils ; complétées par les protocoles additionnels de 1977 '
                      'qui prennent en compte les guerres de libération nationale, les conflits internes, etc.',
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                '2.2.2 — La Déclaration universelle des droits de l’Homme (ONU, 1948)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Adoptée par l’Assemblée générale des Nations Unies le 10 décembre 1948, '
                'la Déclaration universelle proclame un catalogue très large de droits '
                'civils, politiques, économiques, sociaux et culturels. Elle a une valeur '
                'essentiellement politique, mais a inspiré de nombreux traités contraignants.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Conventions sur le génocide (1948) et sur l’imprescriptibilité des crimes contre l’humanité (1968) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Conventions contre l’esclavage (1926) et la traite des personnes (1950) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Convention contre la torture et autres peines ou traitements cruels, inhumains ou dégradants (1984) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Convention de 1951 sur le statut des réfugiés, conventions relatives aux travailleurs migrants, '
                      'convention sur l’élimination de la discrimination raciale (1965)…',
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                '2.2.3 — La Convention européenne de sauvegarde des droits de l’Homme (CEDH, 1950)',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Signée en 1950 et ratifiée par la France en 1974, la CEDH reprend l’essentiel '
                      'des droits de 1948 et crée surtout un mécanisme de contrôle juridictionnel '
                      'devant la Cour européenne des droits de l’Homme. ',
                ),
                TextSpan(
                  text:
                      'Tout justiciable qui s’estime victime d’une violation de ses droits peut, '
                      'après épuisement des recours internes, saisir la Cour.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La France a été condamnée pour lenteur excessive de la justice, pour violations '
                      'du droit au respect de la vie privée (écoutes téléphoniques abusives), '
                      'pour traitements inhumains ou dégradants, etc.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les décisions de la Cour impliquent souvent des réformes législatives ou '
                      'administratives, ce qui montre l’impact concret de cette source sur le droit interne.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — VALEUR JURIDIQUE DES SOURCES
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 3 — Valeur juridique des sources des libertés publiques',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      'Toutes les sources des libertés publiques n’ont pas la même force juridique. '
                      'Plus un texte est élevé dans la hiérarchie des normes, plus la liberté qu’il '
                      'proclame est solidement protégée. En droit français, la hiérarchie se présente, '
                      'du niveau le plus fort au plus faible, de la manière suivante :\n\n',
                ),
                TextSpan(
                  text:
                      '• Constitution et textes à valeur constitutionnelle : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'Constitution de 1958, Déclaration de 1789, préambule de 1946, Charte de '
                      'l’environnement, principes fondamentaux reconnus par les lois de la République.\n',
                ),
                TextSpan(
                  text: '• Engagements internationaux : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'conventions de l’ONU, CEDH, traités relatifs aux droits de l’Homme…\n',
                ),
                TextSpan(
                  text: '• Lois et textes de valeur législative : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'codes et lois ordinaires qui organisent concrètement l’exercice des libertés.\n',
                ),
                TextSpan(
                  text: '• Principes généraux du droit : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'règles dégagées par la jurisprudence administrative (ex. respect des droits de la défense).\n',
                ),
                TextSpan(
                  text: '• Règlements : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'décrets, arrêtés, circulaires qui précisent les modalités pratiques '
                      'd’exercice ou de restriction des libertés publiques.',
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Réflexe opérationnel',
                bodySpans: [
                  TextSpan(
                    text:
                        'Lorsqu’une mesure de police administrative porte atteinte à une liberté '
                        'publique, elle doit toujours respecter cette hiérarchie : un règlement '
                        'ne peut contredire une loi, et une loi ne peut méconnaître un texte à '
                        'valeur constitutionnelle ou conventionnelle. C’est ce contrôle de '
                        'conformité qui garantit, en dernier ressort, la protection des citoyens.',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE DE CONTENU (bloc structuré)
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.fustat(
                fontWeight: FontWeight.w800,
                fontSize: 16.5,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES (texte simple ou riche)
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans);

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .95);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC EXEMPLE / ILLUSTRATION
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / MISE EN GARDE / FOCUS
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .75 : .96),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withValues(alpha: .95),
          ),
          children: [
            TextSpan(
              text: '$title : ',
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
