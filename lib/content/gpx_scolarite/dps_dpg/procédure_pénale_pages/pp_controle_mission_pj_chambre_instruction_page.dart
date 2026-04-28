import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PPControleMissionPJChambreInstructionPage extends StatelessWidget {
  const PPControleMissionPJChambreInstructionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_controle_mission_pj_chambre_instruction';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color textMain = isDark
        ? Colors.white
        : const Color(0xFF0D47A1); // bleu foncé
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.88);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark ? const Color(0xFF111317) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chambre de l’instruction',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================== TITRE PRINCIPAL =======================
              Text(
                'Chapitre 3 – Le rôle de la chambre\nde l’instruction',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  height: 1.15,
                  color: textMain,
                ),
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’activité de police judiciaire est placée sous le contrôle de la chambre de l’instruction. ',
                ),
                TextSpan(
                  text: 'L’Article 13 du Code de Procédure Pénale',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ' lui confère un pouvoir de contrôle renforcé, qui prend notamment la forme d’un pouvoir quasi disciplinaire à l’égard des officiers et agents de police judiciaire. '
                      'Depuis la loi n° 2016-731 du 3 juin 2016, ce contrôle est étendu aux manquements professionnels graves ou atteintes graves à l’honneur ou à la probité, '
                      'lorsqu’ils ont une incidence sur la capacité à exercer des missions de police judiciaire, conformément à ',
                ),
                TextSpan(
                  text: 'l’Article 229-1 du Code de Procédure Pénale',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Ce dispositif est complété par les dispositions des ',
                ),
                TextSpan(
                  text: 'Articles 224 à 230 du Code de Procédure Pénale',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', applicables également aux agents de police judiciaire adjoints, aux assistants d’enquête et à certains fonctionnaires ou agents chargés de fonctions de police judiciaire.',
                ),
              ]),
              const SizedBox(height: 10),

              const _IntroBullet(
                text:
                    'Contrôle juridictionnel de l’activité de police judiciaire.',
              ),
              const _IntroBullet(
                text:
                    'Pouvoir quasi disciplinaire à l’égard des officiers et agents de police judiciaire.',
              ),
              const _IntroBullet(
                text:
                    'Possibilité de suspension temporaire ou définitive de fonctions de police judiciaire.',
              ),

              const SizedBox(height: 20),

              // ==================== 3.1 SAISINE =============================
              _ConditionCard(
                title: '3.1 La saisine de la chambre de l’instruction',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'La chambre de l’instruction peut être saisie de différentes manières lorsqu’une faute est reprochée à un officier ou à un agent de police judiciaire dans l’exercice de ses fonctions judiciaires.',
                    ),
                  ]),
                  const SizedBox(height: 10),

                  const _SubTitle(
                    'Saisine par le procureur général ou le président',
                  ),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'La chambre de l’instruction peut être saisie soit par le procureur général, soit par son président. '
                          'Ces autorités déclenchent alors le contrôle de la chambre sur le comportement ou les actes du policier ou du gendarme mis en cause.',
                    ),
                  ]),
                  const SizedBox(height: 8),

                  const _SubTitle(
                    'Saisine d’office par la chambre de l’instruction',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La chambre de l’instruction peut également se saisir d’office à l’occasion de l’examen d’une procédure d’instruction qui lui est soumise. '
                          'En tant que juridiction du second degré, elle connaît des appels formés contre les ordonnances du juge d’instruction et, à ce titre, elle apprécie '
                          'l’action des officiers de police judiciaire auxquels le juge d’instruction a délégué certains actes ou adressé des réquisitions. '
                          'Si elle découvre une faute commise par un officier ou un agent de police judiciaire, ',
                    ),
                    TextSpan(
                      text: 'l’Article 225 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' lui permet de se saisir sans attendre d’être formellement saisie par le procureur général ou par son président.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    bodySpans: const [
                      TextSpan(
                        text:
                            'Cette faculté de saisine d’office renforce le rôle de la chambre de l’instruction comme garante de la régularité des enquêtes '
                            'et du respect des droits fondamentaux dans le cadre des missions de police judiciaire.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ==================== 3.2 PROCÉDURE ===========================
              _ConditionCard(
                title: '3.2 La procédure devant la chambre de l’instruction',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  const _SubTitle(
                    '3.2.1 Dans le cadre de l’exécution des fonctions judiciaires',
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La procédure applicable dans ce cadre est prévue par ',
                    ),
                    TextSpan(
                      text: 'l’Article 226 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. Elle débute par une enquête ordonnée par la chambre de l’instruction sur les faits reprochés à l’officier ou à l’agent de police judiciaire. '
                          'La personne concernée doit avoir été mise en mesure de consulter son dossier, tenu au parquet général, qui contient notamment ses notices annuelles.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’officier ou l’agent de police judiciaire peut se faire assister par un avocat. À l’audience, sont entendus :\n',
                    ),
                  ]),
                  const _BulletPoint(text: 'le procureur général ;'),
                  const _BulletPoint(
                    text:
                        'l’officier ou l’agent de police judiciaire mis en cause ;',
                  ),
                  const _BulletPoint(
                    text: 'éventuellement son conseil (avocat).',
                  ),
                  const SizedBox(height: 8),

                  const _SubTitle(
                    'Les décisions possibles de la chambre de l’instruction',
                  ),
                  const _Paragraph.rich([
                    TextSpan(
                      text:
                          'Au terme de la procédure, la chambre de l’instruction peut prendre plusieurs types de décisions à l’égard de l’officier ou de l’agent de police judiciaire :',
                    ),
                  ]),
                  const SizedBox(height: 6),
                  const _BulletPoint(
                    text: 'adresser de simples observations à l’intéressé ;',
                  ),
                  const _BulletPoint(
                    text:
                        'décider qu’il ne pourra plus, momentanément, exercer ses fonctions d’agent ou d’officier de police judiciaire et de délégué du juge d’instruction ;',
                  ),
                  const _BulletPoint(
                    text:
                        'prononcer une interdiction définitive d’exercer ces fonctions.',
                  ),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'La décision de suspension temporaire ou définitive prend effet immédiatement, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article 227 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          '. L’interdiction, qu’elle soit momentanée ou définitive, peut être limitée au ressort de la cour d’appel ou étendue à l’ensemble du territoire français.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Si la faute reprochée constitue également une infraction pénale (par exemple, une violation de domicile commise à l’occasion d’une perquisition), '
                          'la chambre de l’instruction, après avoir statué sur les mesures disciplinaires, ordonne la transmission du dossier au procureur général à toutes fins utiles. '
                          'Cette transmission est prévue par ',
                    ),
                    TextSpan(
                      text: 'l’Article 228 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ', ainsi que par l’Article C 408 de l’instruction générale du 27 février 1959 relative au Code de Procédure Pénale. '
                          'Il appartient alors au ministère public d’apprécier l’opportunité de poursuites pénales.',
                    ),
                  ]),

                  const SizedBox(height: 16),

                  const _SubTitle('3.2.2 En raison du comportement'),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'L’Article 229-1 du Code de Procédure Pénale met en place une procédure spécifique permettant au président de la chambre de l’instruction, '
                          'saisi par le procureur général près la cour d’appel, de prendre en urgence une décision de suspension de toute fonction de police judiciaire. '
                          'Cette procédure vise les personnes mentionnées à ',
                    ),
                    TextSpan(
                      text: 'l’Article 224 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' en raison de leur comportement, d’un manquement professionnel grave ou d’une atteinte grave à l’honneur ou à la probité.',
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Ce dispositif est également applicable aux agents de police judiciaire adjoints, aux assistants d’enquête de la police nationale et de la gendarmerie nationale, '
                          'ainsi qu’aux fonctionnaires et agents chargés de certaines fonctions de police judiciaire, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article 230 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 8),
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Lorsque le comportement du fonctionnaire a une incidence sur la qualité d’exercice de ses missions de police judiciaire, '
                          'le président de la chambre de l’instruction peut décider de le suspendre immédiatement de toute fonction de police judiciaire, pour une durée maximale d’un mois. '
                          'Cette décision prend effet immédiatement et est notifiée, à la diligence du procureur général, aux autorités dont dépend l’intéressé, conformément à ',
                    ),
                    TextSpan(
                      text: 'l’Article 229 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ]),
                  const SizedBox(height: 10),
                  _NotaBox(
                    title: 'Suspension d’urgence',
                    bodySpans: const [
                      TextSpan(
                        text:
                            'La procédure de suspension d’urgence a pour finalité de protéger immédiatement la crédibilité de l’enquête pénale et la confiance du public, '
                            'sans attendre l’issue d’éventuelles procédures disciplinaires ou pénales plus longues. Elle ne préjuge pas des suites disciplinaires ou pénales ultérieures, '
                            'mais suspend temporairement la capacité de l’intéressé à exercer des missions de police judiciaire.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ==================== 3.3 VOIES DE RECOURS ====================
              _ConditionCard(
                title: '3.3 Les voies de recours',
                cardColor: cardColor,
                accent: accent,
                titleColor: textMain,
                children: [
                  _Paragraph.rich([
                    const TextSpan(
                      text:
                          'Les décisions de la chambre de l’instruction prises en application de ',
                    ),
                    TextSpan(
                      text: 'l’Article 227 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' et de '),
                    TextSpan(
                      text: 'l’Article 229-1 du Code de Procédure Pénale',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' sont susceptibles de pourvoi en cassation. Le contrôle de la Cour de cassation porte sur la régularité juridique de la décision rendue par la chambre de l’instruction, '
                          'et permet d’assurer une protection supplémentaire des droits de la défense comme des exigences de bonne administration de la justice.',
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Le pourvoi en cassation ne suspend pas nécessairement les effets immédiats de la décision (notamment une suspension de fonctions), '
                            'mais il permet un contrôle ultime de la légalité de la procédure suivie et de la décision prise par la chambre de l’instruction.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                   TES WIDGETS PERSONNALISÉS EXACTS                    ///
///////////////////////////////////////////////////////////////////////////////

class _ConditionCard extends StatelessWidget {
  const _ConditionCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
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
          border: Border.all(color: accent.withOpacity(.22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
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

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 15.5,
          color: isDark ? Colors.white : const Color(0xFF0D47A1),
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    if (!isRich) {
      return Text(
        text!,
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.45,
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
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans!,
      ),
    );
  }
}

class _IntroBullet extends StatelessWidget {
  const _IntroBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bulletColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.arrow_right_rounded,
              size: 18,
              color: bulletColor,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_rounded,
            size: 18,
            color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF1565C0),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF1F1F1F).withOpacity(.92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        color: bgColor.withOpacity(isDark ? .7 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: isDark
                ? Colors.white70
                : const Color(0xFF3E2723).withOpacity(.95),
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
