import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPersonnesFuiteProcedureGpxSchool extends StatelessWidget {
  const PaPersonnesFuiteProcedureGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/recherche_personnes_fuite/chapitre2';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
? const Color(0xFF111218)
: const Color(0xFFFDFDFE);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Art. 74-2 – Procédure',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle(
                'Chapitre 2 : La procédure de l’Article 74-2 '
                'du Code de procédure pénale',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'Ce chapitre présente les autorités compétentes et les principaux actes '
                'd’enquête pouvant être mis en œuvre dans le cadre de la recherche des '
                'personnes en fuite prévue par l’Article 74-2 du Code de procédure pénale.',
              ),
              const SizedBox(height: 20),

              // 2.1 – LES AUTORITÉS HABILITÉES
              const _SubTitle('2.1 – Les autorités habilitées'),
              const SizedBox(height: 8),

              // 2.1.1 Les magistrats – Procureur
              _ConditionCard(
                title:
                    '2.1.1 – Les magistrats\n2.1.1.1 – Le procureur de la République',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Aux termes de l’Article 74-2 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          '(alinéa 1), le cadre d’enquête visant à rechercher et découvrir '
                          'une personne en fuite ne peut être mis en œuvre que sur '
                          'instructions du procureur de la République.',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _Paragraph('Le procureur de la République peut notamment :'),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        'demander aux officiers de police judiciaire d’user des moyens '
                        'd’investigation de l’enquête de flagrance prévus aux '
                        'Articles 56 à 62 du Code de procédure pénale ;',
                  ),
                  _BulletPoint.rich(
                    text:
                        'demander au juge des libertés et de la détention l’autorisation '
                        'de procéder à l’interception, l’enregistrement et la transcription '
                        'des correspondances émises par la voie des télécommunications, '
                        'selon les modalités prévues par les ',
                    articleSpan: TextSpan(
                      text:
                          'Articles 100, 100-1 et 100-3 à 100-7 du Code de procédure pénale',
                      style: TextStyle(color: Colors.red),
                    ),
                    endText: ' (référence à l’Article 74-2, alinéa 8).',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Dans le cadre des opérations d’interception, les attributions '
                          'habituellement confiées au juge d’instruction par les ',
                    ),
                    TextSpan(
                      text:
                          'Articles 100-3 à 100-5 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'sont, dans ce dispositif, exercées par le procureur de la '
                          'République (ou par l’officier de police judiciaire requis par lui).',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 22),

              // 2.1.1.2 Juge des libertés et de la détention
              _ConditionCard(
                title: '2.1.1.2 – Le juge des libertés et de la détention',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text: 'L’Article 74-2 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          '(alinéa 8) prévoit que les écoutes téléphoniques sont autorisées, '
                          'en raison des nécessités de l’enquête, par le juge des libertés et '
                          'de la détention du tribunal judiciaire, à la demande du procureur '
                          'de la République.',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’autorisation du magistrat doit respecter les modalités prévues par les '
                    'Articles 100, 100-1 et 100-3 à 100-7 du Code de procédure pénale.',
                  ),
                  SizedBox(height: 10),
                  _BulletPoint(
                    text:
                        'L’interception téléphonique est possible en matière criminelle et en '
                        'matière correctionnelle lorsque la peine encourue est égale ou '
                        'supérieure à trois ans ;',
                  ),
                  _BulletPoint(
                    text:
                        'la décision d’interception est écrite, n’est susceptible d’aucun '
                        'recours et doit être motivée par référence aux éléments de fait et '
                        'de droit justifiant que ces opérations sont nécessaires. Elle doit '
                        'comporter tous les éléments d’identification de la liaison à '
                        'intercepter, l’infraction qui motive le recours à l’interception '
                        'ainsi que la durée de celle-ci ;',
                  ),
                  _BulletPoint(
                    text:
                        'aucune interception ne peut porter sur une ligne dépendant du '
                        'cabinet d’un avocat ou de son domicile, sauf s’il existe des '
                        'raisons plausibles de le soupçonner d’avoir commis ou tenté de '
                        'commettre, en tant qu’auteur ou complice, l’infraction objet de la '
                        'procédure ou une infraction connexe ;',
                  ),
                  _BulletPoint(
                    text:
                        'à peine de nullité, les lignes dépendant du cabinet ou du domicile '
                        'd’un député, sénateur, avocat ou magistrat ne peuvent être '
                        'interceptées qu’après avis à leur autorité supérieure.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Le juge des libertés et de la détention doit être informé sans délai de '
                    'tous les actes accomplis, depuis la mise en place de l’interception '
                    'jusqu’à la transcription des correspondances.',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // 2.1.2 OPJ
              _ConditionCard(
                title: '2.1.2 – L’officier de police judiciaire',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Un officier de police judiciaire peut se voir déléguer les pouvoirs '
                    'visant à rechercher une personne en fuite. Cette délégation émane du '
                    'procureur de la République, qui adresse ses instructions aux seuls '
                    'officiers de police judiciaire. Ceux-ci peuvent se faire assister des '
                    'agents de police judiciaire, mais seuls les officiers de police '
                    'judiciaire sont habilités à rédiger les actes de procédure.',
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // 2.2 – ACTES DE L’ENQUÊTE
              const _SubTitle('2.2 – Les actes de l’enquête'),
              const SizedBox(height: 8),

              // 2.2.1 actes délégués
              _ConditionCard(
                title:
                    '2.2.1 – Les actes délégués par le procureur de la République',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’officier de police judiciaire, assisté le cas échéant par des '
                          'agents de police judiciaire, peut accomplir les actes prévus par '
                          'les ',
                    ),
                    TextSpan(
                      text: 'Articles 56 à 62 du Code de procédure pénale ',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          'aux fins de rechercher une personne en fuite (référence à '
                          'l’Article 74-2, alinéa 1 du Code de procédure pénale).',
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’officier de police judiciaire peut ainsi procéder à tous les actes de '
                    'l’enquête de flagrant délit : auditions, perquisitions, réquisitions, '
                    'examens techniques et scientifiques.',
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    'Dans ce cadre spécifique de la recherche des personnes en fuite, il ne '
                    'peut toutefois pas prendre de mesure de garde à vue.',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // 2.2.2 Interceptions téléphoniques
              _ConditionCard(
                title: '2.2.2 – Les interceptions téléphoniques',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Le procureur de la République, préalablement autorisé à procéder à des '
                    'interceptions téléphoniques par le juge des libertés et de la '
                    'détention, délègue habituellement à l’officier de police judiciaire le '
                    'soin de mettre en place les opérations d’interception.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Ces interceptions sont réalisées en application des ',
                    ),
                    TextSpan(
                      text:
                          'Articles 100, 100-1 et 100-3 à 100-7 du Code de procédure pénale',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text:
                          ' (référence à l’Article 74-2, alinéa 8 du Code de procédure '
                          'pénale).',
                    ),
                  ]),
                  SizedBox(height: 10),
                  _BulletPoint(
                    text:
                        'l’autorisation est délivrée pour une durée de deux mois, '
                        'renouvelable dans les mêmes conditions de forme et de durée ; ce '
                        'renouvellement est limité à six mois en matière correctionnelle, '
                        'mais n’est pas limité en matière criminelle ;',
                  ),
                  _BulletPoint(
                    text:
                        'l’officier de police judiciaire peut requérir tout agent qualifié du '
                        'ministère des télécommunications, d’un exploitant de réseau ou '
                        'd’un fournisseur de services de télécommunications afin de procéder '
                        'à l’installation du dispositif d’interception ;',
                  ),
                  _BulletPoint(
                    text:
                        'l’officier de police judiciaire rédige un procès-verbal relatant '
                        'précisément les opérations d’interception et d’enregistrement ; les '
                        'enregistrements sont placés sous scellés fermés ;',
                  ),
                  _BulletPoint(
                    text:
                        'il transcrit sur procès-verbal les correspondances utiles à la '
                        'manifestation de la vérité. Un interprète doit être requis pour les '
                        'correspondances en langue étrangère.',
                  ),
                  _Paragraph(
                    'À peine de nullité, les correspondances échangées avec un avocat ne '
                    'peuvent être transcrites lorsqu’elles relèvent de l’exercice des '
                    'droits de la défense et sont couvertes par le secret professionnel de '
                    'la défense et du conseil, sauf dans les cas limitativement prévus par '
                    'les textes relatifs aux perquisitions chez l’avocat.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Il appartient à l’officier de police judiciaire d’informer '
                          'régulièrement le procureur de la République, afin que ce dernier '
                          'puisse informer sans délai le juge des libertés et de la '
                          'détention, conformément aux dispositions du dernier alinéa de ',
                    ),
                    TextSpan(
                      text: 'l’Article 74-2 du Code de procédure pénale.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Petit helper pour avoir un bullet avec un morceau d’article en rouge
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text}) : articleSpan = null, endText = null;

  const _BulletPoint.rich({
    required this.text,
    required this.articleSpan,
    required this.endText,
  });

  final String text;
  final TextSpan? articleSpan;
  final String? endText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (articleSpan == null) {
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
                      : const Color(0xFF1F1F1F).withValues(alpha: .92),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1F1F1F).withValues(alpha: .92),
                ),
                children: [
                  TextSpan(text: text),
                  articleSpan!,
                  if (endText != null) TextSpan(text: endText),
                ],
              ),
            ),
          ),
        ],
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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

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
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
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
