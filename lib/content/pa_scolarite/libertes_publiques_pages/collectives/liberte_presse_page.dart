import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — LA LIBERTÉ DE LA PRESSE
///
///  D’après le polycopié « Liberté de la presse »
///
///  CHAPITRE 1 : Étapes fondamentales de la liberté de la presse
///    - Avant la loi du 29 juillet 1881
///    - Après la loi du 29 juillet 1881
///
///  CHAPITRE 2 : Le contenu de la liberté de la presse
///    - L’entreprise de presse (création, fonctionnement, transparence,
///      pluralisme, aides publiques)
///    - Les journalistes (statut, carte de presse, clause de conscience,
///      liberté et limites, protection des sources)
///
///  CHAPITRE 3 : Les limites à la liberté de la presse
///    - Infractions commises par voie de presse
///    - Personnes responsables / prescription
///    - Contrôles et saisies en matière de presse
/// ===================================================================
class PaLibertePressePage extends StatelessWidget {
  const PaLibertePressePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/collectives/liberte_presse';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF1976D2)
        : const Color(0xFF1565C0);
    final Color referenceColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF0D47A1);
    const dangerColor = Color(0xFFFF3B30);

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
          'La liberté de la presse',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            'La liberté de la presse',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'La liberté de la presse est une liberté fondamentale. Elle est le corollaire '
                  'de la liberté d’opinion et, plus largement, un pilier de la démocratie. ',
            ),
            TextSpan(
              text:
                  'La presse est parfois qualifiée de « 4ème pouvoir » : elle peut influencer durablement '
                  'l’opinion publique, dénoncer les dérives du pouvoir, mais aussi fragiliser les '
                  'institutions lorsqu’elle s’éloigne de ses responsabilités.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          const _NotaBox(
            title: 'Repères doctrinaux',
            bodySpans: [
              TextSpan(
                text:
                    'Alexis de Tocqueville souligne que la souveraineté du peuple et la liberté de la presse '
                    'sont deux réalités inséparables : sans l’une, l’autre ne peut se maintenir. '
                    'Philippe Burdeau rappelle toutefois que cette liberté rend parfois difficile '
                    'la tâche de gouverner, car elle se heurte aux nécessités de l’ordre public. ',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — ÉTAPES FONDAMENTALES
          // =====================================================
          const _NotaBox(
            title:
                'Chapitre 1 — Les étapes fondamentales de la liberté de la presse',
            bodySpans: [
              TextSpan(
                text:
                    'Le régime de la presse a connu de très fortes variations : périodes libérales, '
                    'puis phases de contrôle strict voire de censure. La grande rupture reste la loi '
                    'du 29 juillet 1881, véritable charte de la liberté de la presse en France.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 1.1 AVANT 1881
          _HypoCard(
            title:
                '1.1 — La liberté de la presse avant la loi du 29 juillet 1881',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Avant 1881, la presse reste largement soumise au contrôle du pouvoir. '
                      'La liberté proclamée à la Révolution est vite encadrée par un régime '
                      'd’autorisation préalable et de censure. ',
                ),
                TextSpan(
                  text:
                      'L’article 11 de la Déclaration des droits de l’Homme et du citoyen de 1789',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' proclame pourtant « la libre communication des pensées et des opinions ». '
                      'En pratique, les régimes successifs oscillent entre ouverture et répression.',
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Période révolutionnaire : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'affirmation de la liberté d’expression, multiplication des journaux, mais '
                      'déjà mise en place de mécanismes de contrôle lorsque la situation politique '
                      'se tend (excès de certains écrits, troubles à l’ordre public).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Directoire, Consulat, Empire : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'régimes rigoureux, censure efficace. Le pouvoir freine la liberté de la presse '
                      'par autorisations, saisies, poursuites. Sous l’Empire, la presse devient un '
                      'instrument de propagande étroitement surveillé.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Restauration et monarchie de Juillet : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'le régime oscille entre liberté et « liberté surveillée ». Les périodes de crise '
                      'conduisent à des lois répressives, à des poursuites facilitée contre les journaux. '
                      'Les mécanismes d’autorisation préalable et de censure demeurent fréquents.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Second Empire : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'jusqu’aux années 1860, la presse est strictement encadrée : avertissements, '
                      'suspensions, cautionnements élevés. Le régime se libéralise légèrement en fin '
                      'de période, mais sans véritable statut protecteur.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Au total, avant 1881, le régime est marqué par un contrôle très fort de la presse : '
                'autorisations préalables, censure, cautionnement financier, saisies administratives. '
                'La nécessité d’une loi libérale, garantissant à la fois la liberté et la responsabilité, '
                'devient évidente.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 1.2 APRES 1881
          _HypoCard(
            title:
                '1.2 — La liberté de la presse après la loi du 29 juillet 1881',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La loi du 29 juillet 1881 marque la grande rupture. Elle met fin à l’arbitraire '
                'gouvernemental et organise un régime libéral : la liberté est le principe, la répression '
                'n’intervient qu’a posteriori, en cas d’abus.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'La loi ne s’intéresse qu’à la liberté d’opinion et d’expression : l’aspect matériel '
                      'de la presse (organisation industrielle, concentration, transparence des entreprises) '
                      'reste d’abord en retrait.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Après la Seconde Guerre mondiale, l’ordonnance du 26 août 1944 cherche à éviter '
                      'les concentrations excessives et à encadrer la transparence des organes de presse. '
                      'Elle sera ensuite complétée par les lois du 23 octobre 1984, du 1ᵉʳ août 1986 et du '
                      '27 novembre 1986.',
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Par une décision importante du 11 octobre 1984, le Conseil constitutionnel fait du ',
                ),
                TextSpan(
                  text: 'pluralisme des courants d’expression',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' un principe à valeur constitutionnelle. Il souligne également la nécessité de '
                      'la transparence pour garantir un équilibre entre liberté d’opinion et moyens '
                      'd’expression.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Aujourd’hui, le régime de la liberté de la presse repose donc sur quatre piliers :',
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(text: '• Article 11 de la D.D.H.C. de 1789 ;'),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: '• Loi du 29 juillet 1881 ;'),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: '• Loi du 1ᵉʳ août 1986 ;'),
              ]),
              const _BulletPoint.rich([
                TextSpan(text: '• Loi du 27 novembre 1986.'),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — CONTENU DE LA LIBERTÉ DE LA PRESSE
          // =====================================================
          const _NotaBox(
            title: 'Chapitre 2 — Le contenu de la liberté de la presse',
            bodySpans: [
              TextSpan(
                text:
                    'La liberté de la presse peut être menacée par plusieurs facteurs : un régime '
                    'préventif (autorisation préalable ou censure), la dépendance à l’égard des '
                    'pouvoirs publics, ou encore la domination des puissances financières. Les textes '
                    'postérieurs à 1881 cherchent précisément à protéger l’indépendance de la presse, '
                    'tout en rappelant les responsabilités des acteurs.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 2.1 ENTREPRISE DE PRESSE
          _HypoCard(
            title: '2.1 — L’entreprise de presse',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '2.1.1 — La création d’une entreprise de presse',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’article 5 de la loi de 1881 prévoit que « tout journal ou écrit périodique peut être publié '
                'sans autorisation préalable, ni dépôt de cautionnement ». Il s’agit d’un régime de simple '
                'déclaration, beaucoup plus libéral que celui de l’audiovisuel ou du cinéma.',
              ),
              const SizedBox(height: 10),
              Text(
                '2.1.2 — Le fonctionnement d’une entreprise de presse',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '2.1.2.1 — La transparence',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’objectif est de favoriser la transparence des organes de presse et de permettre au lecteur '
                'de connaître les véritables responsables. L’ordonnance de 1944, puis la loi du 23 octobre '
                '1984 et les lois des 1ᵉʳ août et 27 novembre 1986, imposent des règles de publicité sur la '
                'propriété et la direction des entreprises de presse.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Chaque journal doit avoir un directeur de la publication, véritable responsable pénal ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'L’actionnaire majoritaire ou son représentant légal doit être identifié ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Chaque numéro doit mentionner les principaux dirigeants (P.-D.G., directeurs, propriétaires, etc.) ;',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les investissements étrangers sont limités à une certaine fraction du capital (20 % dans les règles classiques).',
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                '2.1.2.2 — Le pluralisme',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le pluralisme consiste à éviter les concentrations excessives qui mettraient en péril la diversité '
                'des opinions. La décision du Conseil constitutionnel du 29 juillet 1986 fait du pluralisme des '
                'quotidiens d’information politique et générale un objectif de valeur constitutionnelle. La loi du '
                '27 novembre 1986 précise les limites de concentration admissibles (quotas de diffusion, part du '
                'tirage national, nombre maximum de titres contrôlés par une même personne).',
              ),
              const SizedBox(height: 8),
              Text(
                '2.1.2.3 — Les aides publiques',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’État soutient la presse écrite par différents mécanismes : aides fiscales (TVA réduite, exonérations), '
                'tarifs postaux préférentiels, aides directes aux titres les plus fragiles. L’objectif affiché est de '
                'favoriser le pluralisme, mais ces aides alimentent aussi le débat sur l’indépendance réelle de la presse '
                'vis-à-vis du pouvoir politique.',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2.2 LES JOURNALISTES
          _HypoCard(
            title: '2.2 — Les journalistes',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              Text(
                '2.2.1 — Le statut du journaliste',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2.2.1.1 — Définition',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'L’article 2 de la loi du 29 juillet 1881, complété par le Code du travail, définit le journaliste '
                'professionnel comme toute personne qui exerce, à titre principal et rétribué, une activité de '
                'rédaction ou de diffusion d’informations pour un ou plusieurs organes de presse ou de communication '
                'au public. Sont assimilés certains collaborateurs directs (rédacteurs, photographes, reporters, '
                'secrétaires de rédaction, etc.).',
              ),
              const SizedBox(height: 6),
              Text(
                '2.2.1.2 — La carte d’identité professionnelle',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'La carte de presse est délivrée par une Commission paritaire composée de journalistes et '
                'd’éditeurs. Elle atteste de la qualité de journaliste professionnel et ouvre certains droits '
                '(facilités de circulation, accès à certains lieux, etc.). Le refus ou le retrait de la carte '
                'peuvent être contestés devant le juge administratif par un recours pour excès de pouvoir.',
              ),
              const SizedBox(height: 6),
              Text(
                '2.2.1.3 — La clause de conscience',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'La clause de conscience permet au journaliste de rompre son contrat de travail avec indemnités '
                'majorées lorsqu’un changement important dans l’orientation du journal porte atteinte à son honneur '
                'ou à ses intérêts moraux (cession du journal, cessation de la publication, modification profonde de la '
                'ligne éditoriale…).',
              ),
              const SizedBox(height: 10),
              Text(
                '2.2.2 — La liberté du journaliste',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2.2.2.1 — Liberté dans son travail',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le journaliste se veut indépendant dans ses jugements, mais il reste salarié. Son contrat de travail '
                'est encadré par le Code du travail et par les conventions collectives. Pour protéger au mieux cette '
                'indépendance, des « sociétés de journalistes » se sont créées dans certains organes de presse, afin '
                'de veiller au respect d’une éthique professionnelle (charte de 1918, Déclaration de Munich de 1971).',
              ),
              const SizedBox(height: 6),
              Text(
                '2.2.2.2 — Les limites à la liberté du journaliste',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Le journaliste doit vérifier ses informations, refuser les méthodes déloyales (intrusion, vol de documents, '
                'enregistrements clandestins…) et respecter le secret des sources recueillies dans l’exercice de sa fonction. '
                'Le Code de procédure pénale et le Code pénal organisent également un secret professionnel renforcé '
                'pour protéger ses sources, sous peine de faire du journaliste un auxiliaire de police plutôt qu’un '
                'acteur indépendant de l’information.',
              ),
              const SizedBox(height: 10),
              Text(
                '2.2.3 — La protection du secret des sources',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '2.2.3.1 — Principe général',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La loi du 29 juillet 1881, complétée par le Code de procédure pénale, dispose qu’il ne peut être porté atteinte '
                      'au secret des sources que si un impératif prépondérant d’intérêt public l’exige, et si les mesures d’investigation '
                      'sont strictement nécessaires et proportionnées. ',
                ),
                TextSpan(
                  text:
                      'Le journaliste a le droit de refuser de révéler l’origine de ses informations.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                '2.2.3.2 — Perquisitions et saisies',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Les perquisitions dans les locaux d’une entreprise de presse, d’une agence ou au domicile d’un journaliste '
                'sont encadrées : elles doivent être décidées et dirigées par un magistrat, qui doit préciser l’infraction '
                'visée et les documents recherchés. Toute perquisition irrégulière est frappée de nullité, de même que les '
                'saisies qui en résulteraient.',
              ),
              const SizedBox(height: 6),
              Text(
                '2.2.3.3 — Secret des sources et témoignage',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Lorsqu’un journaliste est entendu comme témoin sur des informations recueillies dans le cadre de son activité, '
                'il bénéficie d’une protection renforcée : il peut refuser de révéler l’identité de la source. Les décisions de '
                'la Cour de cassation et de la Cour européenne des droits de l’Homme sont venues rappeler que la protection '
                'des sources est une condition essentielle de la liberté de la presse.',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — LIMITES À LA LIBERTÉ DE LA PRESSE
          // =====================================================
          _HypoCard(
            title: 'Chapitre 3 — Les limites à la liberté de la presse',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La liberté de la presse ne consiste pas à pouvoir dire ou écrire n’importe quoi. '
                'La société et les individus doivent être protégés contre certains abus. La loi de '
                '1881 et les textes ultérieurs définissent donc un ensemble d’infractions commises par '
                'voie de presse.',
              ),
              const SizedBox(height: 10),
              Text(
                '3.1 — Les infractions commises par voie de presse',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '3.1.1 — Protection des particuliers',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Les injures publiques : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'toute expression outrageante ou terme de mépris ne renfermant l’imputation d’aucun fait. '
                      'Le régime est aggravé lorsque l’injure vise un agent public ou repose sur un motif discriminatoire '
                      '(origine, appartenance à une race ou une religion déterminée, sexe, orientation sexuelle, handicap…).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'La diffamation : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'allégation ou imputation d’un fait précis portant atteinte à l’honneur ou à la considération '
                      'd’une personne. Elle nécessite la preuve d’un fait susceptible de contrôle. La victime peut '
                      'demander la publication d’un droit de réponse et obtenir réparation. La diffamation non publique '
                      'constitue une contravention moins gravement sanctionnée.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Atteintes à la vie privée : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'divulgation non autorisée d’éléments de la vie personnelle (adresse, santé, vie sentimentale…). '
                      'Elles sont réprimées par les dispositions relatives au droit au respect de la vie privée.',
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                '3.1.2 — Protection de la société',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Publication de fausses nouvelles : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'diffusion de nouvelles inexactes ou falsifiées de nature à troubler la paix publique ou à '
                      'démoraliser les forces armées (article 27 loi 1881).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Publication d’informations secrètes : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'divulgation d’informations relatives à la défense nationale, aux opérations de police, à la justice '
                      'ou au secret de l’instruction. De nombreux textes (articles 38 à 41-1 de la loi de 1881, article 39 sexies, etc.) '
                      'encadrent ces atteintes.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Provocation ou apologie de crimes et délits, notamment crimes de guerre, crimes contre l’humanité '
                      'ou actes terroristes (articles 23, 24 et 24 bis loi 1881). ',
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                '3.1.3 — Protection de l’autorité de l’État et de ses représentants',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Sont notamment réprimés : le non-respect des décisions de justice, la pression exercée sur les magistrats, '
                'l’injure ou la diffamation envers le Président de la République ou les membres du Gouvernement, '
                'dans les conditions prévues par le Code pénal et la loi de 1881.',
              ),
              const SizedBox(height: 8),
              Text(
                '3.1.4 — Personnes responsables et prescription',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Personne responsable principale : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'pour les écrits périodiques, il s’agit du directeur de la publication ; pour les autres, l’éditeur. '
                      'À défaut, l’auteur, puis l’imprimeur, peuvent être poursuivis.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Les complices : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'ceux qui ont participé à la diffusion ou à la publication peuvent être poursuivis comme complices, '
                      'dans les conditions du Code pénal.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Prescription : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'le délai de prescription de l’action publique en matière de délits de presse est en principe de '
                      'trois mois à compter de la publication, porté à un an pour certains délits à caractère raciste ou '
                      'discriminatoire.',
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                '3.2 — Contrôles et saisies en matière de presse',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '3.2.1 — Les contrôles',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph(
                'Certaines publications sont plus strictement encadrées, notamment celles destinées à la jeunesse : '
                'contenu à caractère violent, pornographique ou discriminatoire. Les tribunaux peuvent ordonner la saisie '
                'ou la destruction des supports. En période d’état de siège ou d’état d’urgence, des mesures de censure '
                'exceptionnelles peuvent également être décidées.',
              ),
              const SizedBox(height: 8),
              Text(
                '3.2.2 — Les perquisitions',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              const _Paragraph.rich([
                TextSpan(
                  text:
                      'Les perquisitions dans les locaux de presse ou chez les journalistes sont particulièrement sensibles. '
                      'Elles ne peuvent être décidées que par un magistrat et doivent respecter le principe de proportionnalité. ',
                ),
                TextSpan(
                  text:
                      'Toute dérive peut remettre en cause la confiance entre les médias et les forces de l’ordre.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: dangerColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _ExempleBox(
                title: 'Réflexe pratique pour le policier',
                bodySpans: [
                  TextSpan(
                    text:
                        'Lorsqu’une enquête touche un média ou un journaliste, l’agent doit toujours garder à l’esprit la '
                        'protection de la liberté de la presse : prudence dans les contacts avec les rédactions, respect '
                        'des réquisitions judiciaires, attention particulière à la confidentialité des sources. La recherche '
                        'de la vérité ne doit jamais servir de prétexte à une pression illégitime sur le travail journalistique.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),
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
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

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
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
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
/// BLOC NOTA / MISE EN GARDE
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
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
