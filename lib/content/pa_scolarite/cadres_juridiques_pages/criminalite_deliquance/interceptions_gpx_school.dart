import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaInterceptionsGpxSchool extends StatelessWidget {
  const PaInterceptionsGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/interceptions';

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
        title: Text(
          'Interceptions de correspondances',
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SubTitle('2.1.6 - Les interceptions de correspondances'),
              const SizedBox(height: 4),
              const _Paragraph(
                'Les interceptions de correspondances sont des mesures fortement '
                'encadrées, qui permettent, sous contrôle judiciaire, d’intercepter '
                'des communications électroniques ou d’accéder à des messages déjà '
                'stockés, dans le cadre des infractions de criminalité organisée.',
              ),

              const SizedBox(height: 20),
              const _SubTitle(
                '2.1.6.1 - Les interceptions de correspondances émises',
              ),

              const SizedBox(height: 10),
              _ConditionCard(
                title:
                    'Fondement légal – article 706-95 du Code de procédure pénale',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-95 du Code de procédure pénale dispose : ',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '« Si les nécessités de l’enquête de flagrance ou de l’enquête '
                          'préliminaire relative à l’une des infractions entrant dans le champ '
                          'd’application des articles 706-73 et 706-73-1 l’exigent, le juge des '
                          'libertés et de la détention du tribunal judiciaire peut, à la requête '
                          'du procureur de la République, autoriser l’interception, '
                          'l’enregistrement et la transcription de correspondances émises par '
                          'la voie des communications électroniques selon les modalités '
                          'prévues aux deuxième et dernier alinéas de l’article 100 ainsi '
                          'qu’aux articles 100-1 et 100-3 à 100-7, pour une durée maximum '
                          'd’un mois, renouvelable une fois dans les mêmes conditions de forme '
                          'et de durée. Ces opérations sont faites sous le contrôle du juge des '
                          'libertés et de la détention. Les dispositions de l’article 100-8 sont '
                          'applicables aux interceptions ordonnées en application du présent '
                          'article. Pour l’application des dispositions des articles 100-3 à '
                          '100-5 et 100-8, les attributions confiées au juge d’instruction ou à '
                          'l’officier de police judiciaire commis par lui sont exercées par le '
                          'procureur de la République ou l’officier de police judiciaire requis '
                          'par ce magistrat. Le juge des libertés et de la détention qui a '
                          'autorisé l’interception est informé sans délai par le procureur de la '
                          'République des actes accomplis en application de l’alinéa précédent, '
                          'notamment des procès-verbaux dressés en exécution de son '
                          'autorisation, par application des articles 100-4 et 100-5. »',
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title: 'Conditions de mise en œuvre des écoutes téléphoniques',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    'Les écoutes téléphoniques sont possibles à condition de respecter un '
                    'ensemble de règles cumulatives :',
                  ),
                  SizedBox(height: 6),
                  _BulletPoint(
                    text:
                        'L’enquête doit porter sur une infraction visée aux articles 706-73 et '
                        '706-73-1 du Code de procédure pénale.',
                  ),
                  _BulletPoint(
                    text:
                        'Les écoutes téléphoniques sont autorisées, en raison des nécessités de '
                        'l’enquête, par le juge des libertés et de la détention, à la demande '
                        'du procureur de la République.',
                  ),
                  _BulletPoint(
                    text:
                        'La décision d’interception est écrite, non susceptible de recours, et '
                        'doit comporter tous les éléments d’identification de la ligne ou du '
                        'moyen de communication visé.',
                  ),
                  _BulletPoint(
                    text:
                        'L’écoute est autorisée pour une durée d’un mois, renouvelable une fois '
                        'dans les mêmes conditions de forme et de durée.',
                  ),
                  _BulletPoint(
                    text:
                        'Le procureur de la République doit informer sans délai le juge des '
                        'libertés et de la détention des actes accomplis. De la même façon, '
                        'l’officier de police judiciaire doit rendre compte sans délai au '
                        'procureur de la République qui l’a commis.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Les dispositions générales relatives aux interceptions téléphoniques, '
                          'ordonnées par le juge d’instruction, restent applicables (article 100 '
                          'alinéa 2 et dernier alinéa, articles 100-1 et 100-3 à 100-7 du Code '
                          'de procédure pénale). Les attributions respectivement confiées au '
                          'juge d’instruction, à l’officier de police judiciaire ou à l’agent de '
                          'police judiciaire agissant sous son contrôle sont, en flagrance ou en '
                          'préliminaire, exercées par le procureur de la République, l’officier '
                          'de police judiciaire et l’agent de police judiciaire agissant sous le '
                          'contrôle de ce dernier.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 16),
              _ConditionCard(
                title:
                    'Précisions jurisprudentielles et protections particulières',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _NotaBox(
                    title: 'Jurisprudence',
                    bodySpans: [
                      TextSpan(
                        text:
                            'Au cours d’une enquête préliminaire, l’article 100-3 du Code de '
                            'procédure pénale, auquel renvoie l’article 706-95 du Code de '
                            'procédure pénale, autorise l’agent de police judiciaire, sous le '
                            'contrôle d’un officier de police judiciaire, à requérir tout agent '
                            'qualifié d’un exploitant de réseau ou fournisseur de services de '
                            'communications électroniques autorisé, en vue de procéder à '
                            'l’installation d’un dispositif d’interception de correspondances '
                            'émises par la voie des communications électroniques '
                            '(chambre criminelle, décision n°24-81.301 du 22 octobre 2024).',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'Ainsi, aucune interception ne peut porter sur une ligne dépendant du '
                          'cabinet d’un avocat ou de son domicile, sauf s’il existe des raisons '
                          'plausibles de le soupçonner d’avoir commis ou tenté de commettre, en '
                          'tant qu’auteur ou complice, l’infraction objet de la procédure ou une '
                          'infraction connexe (article 100 du Code de procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'À peine de nullité, pour les lignes dépendant du cabinet ou du domicile '
                          'd’un député, d’un sénateur, d’un avocat ou d’un magistrat, '
                          'l’interception n’est possible qu’après avis donné à leur autorité '
                          '« supérieure » : président de l’assemblée, bâtonnier de l’ordre, '
                          'premier président ou procureur général (article 100-7 du Code de '
                          'procédure pénale).',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            'Version au 01/07/2025 – SDCP – Tous droits réservés.',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),
              const _SubTitle('2.1.6.2 - L’accès aux correspondances stockées'),

              const SizedBox(height: 10),
              _ConditionCard(
                title:
                    'Accès aux correspondances stockées – article 706-95-1 du Code de procédure pénale',
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: const [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          'L’article 706-95-1 du Code de procédure pénale permet de recueillir, à '
                          'distance et à l’insu de la personne concernée, les correspondances '
                          'stockées par la voie des communications électroniques accessibles au '
                          'moyen d’un identifiant informatique, notamment les données de '
                          'messagerie électronique.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    'Cette technique est particulièrement utile pour exploiter la messagerie '
                    'électronique des suspects lorsque les réquisitions ou les éléments de '
                    'l’enquête ont permis d’obtenir des identifiants de connexion. Il peut '
                    's’agir, par exemple, de récupérer le contenu de boîtes e-mail ou encore '
                    'des échanges sécurisés intervenus via certaines applications telles que '
                    'WhatsApp ou Skype.',
                  ),
                  SizedBox(height: 8),
                  _Paragraph(
                    'L’autorisation d’accéder à ces correspondances stockées est délivrée par '
                    'le juge des libertés et de la détention, à la requête du procureur de la '
                    'République. Le contrôle judiciaire reste donc central, comme pour les '
                    'interceptions de correspondances émises.',
                  ),
                ],
              ),

              const SizedBox(height: 26),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Veiller systématiquement à vérifier la base légale (article 706-95 ou '
                        '706-95-1 du Code de procédure pénale) avant toute mise en œuvre d’une '
                        'interception ou d’un accès aux correspondances stockées. Les régimes '
                        'sont strictement encadrés et toute irrégularité peut entraîner la '
                        'nullité des actes.',
                  ),
                ],
              ),
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
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
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
