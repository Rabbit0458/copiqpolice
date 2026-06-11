import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaVerificationIdentiteRetentionGpxSchool extends StatelessWidget {
  const PaVerificationIdentiteRetentionGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre3/retention';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFF5F7FF);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'Rétention de la personne contrôlée',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ===================== TITRE PRINCIPAL ===========================
          Text(
            'La rétention de la personne contrôlée',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Définition, motifs, conditions d’exécution, lieu et durée de la rétention dans le cadre '
            'de la vérification d’identité, sous la responsabilité de l’officier de police judiciaire.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ===================== CARTE CONTENU =============================
          _ConditionCard(
            title: '3.1 — La rétention de la personne contrôlée',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: const [
              _Paragraph(
                'Définie comme la détention d’un individu aux fins de rechercher son identité, '
                'quelle que soit la qualification (de police administrative ou de police judiciaire), '
                'la rétention est une « détention policière » dont le législateur a dû, pour respecter '
                'les droits fondamentaux du citoyen, préciser de façon extrêmement stricte les motifs, '
                'les instructions d’exécution et la durée.',
              ),

              _SubTitle('Les motifs de la rétention'),
              _Paragraph(
                'La rétention n’est possible que si la personne contrôlée ne peut pas ou ne veut pas '
                'fournir justification de son identité. Le policier devra alors relater dans le procès-verbal '
                'les circonstances de fait de nature à induire objectivement l’impossibilité ou le refus.',
              ),

              _SubTitle('L’impossibilité de justifier de son identité'),
              _Paragraph(
                'Cela recouvre des situations extrêmement diverses. Il peut s’agir d’une personne '
                'dépourvue de tout document justificatif d’identité habitant dans une ville éloignée, '
                'ou encore d’une personne qui a laissé ses papiers à son domicile et qui habite à proximité.',
              ),

              _SubTitle('Le refus de justifier de son identité'),
              _Paragraph(
                'C’est l’exemple de la personne qui refuse délibérément de communiquer son identité. '
                'C’est aussi le cas de la personne qui communique une identité imaginaire ou erronée.',
              ),

              _SubTitle('Les conditions d’exécution de la rétention'),
              _Paragraph(
                'Cela concerne la décision du placement et le lieu d’exécution de la rétention.',
              ),

              _SubTitle('La décision de placement en rétention'),
              _Paragraph(
                'La décision juridique définitive d’ordonner le placement en rétention est de la '
                'compétence de l’officier de police judiciaire. Cependant, elle est souvent décidée sur '
                'place par le policier contrôleur, même s’il ne dispose que de la qualité d’agent de police '
                'judiciaire, puisque c’est lui qui constate, au moment du contrôle, que la personne '
                'interpellée ne peut pas ou ne veut pas justifier de son identité.',
              ),
              _Paragraph(
                'Cette rétention provisoire se poursuit naturellement par la conduite de l’interpellé devant '
                'l’officier de police judiciaire qui, en fonction de l’attitude de l’intéressé, constatera à son '
                'tour la nécessité d’une vérification d’identité par une rétention.',
              ),

              _SubTitle(
                'Les pouvoirs des agents de police judiciaire adjoints',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’agent de police judiciaire adjoint peut user de la coercition pour maintenir le '
                      'contrevenant sur place en attente des instructions de l’officier de police judiciaire. '
                      'La violation de cette obligation par le contrevenant est punie de deux mois '
                      'd’emprisonnement et 7 500 euros d’amende (',
                ),
                TextSpan(
                  text: 'article 78-6 du code de procédure pénale, alinéa 2',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),

              _SubTitle('Le lieu d’exécution de la rétention'),
              _Paragraph.rich([
                TextSpan(text: 'L’alinéa 1 de l’'),
                TextSpan(
                  text: 'article 78-3 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      ' précise que l’intéressé peut être retenu « sur place ou dans un local de police ». '
                      'La plupart du temps, l’officier de police judiciaire n’étant pas sur place mais dans un local '
                      'de police, l’intéressé doit être conduit devant lui.',
                ),
              ]),

              _SubTitle('La durée de la rétention'),
              _Paragraph(
                'Cette mesure débute à l’instant où le policier constate que la personne contrôlée ne '
                'peut pas ou ne veut pas justifier de son identité. En effet, à cet instant, le policier, qu’il '
                'possède la qualité d’agent de police judiciaire ou d’officier de police judiciaire, peut '
                'décider de retenir la personne et, s’il n’est pas officier de police judiciaire, de la présenter '
                'immédiatement à celui-ci aux fins de recherches de son identité.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'La mesure de rétention policière, qui commence donc au moment où la personne est '
                      'soumise au contrôle d’identité, ne peut durer que le temps strictement nécessaire pour '
                      'établir la preuve de son identité, et ne peut excéder 4 heures, ou 8 heures à Mayotte et '
                      'dans la collectivité territoriale de Guyane (',
                ),
                TextSpan(
                  text: 'article 78-3 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(
                  text:
                      '). Cependant, le procureur de la République peut y mettre fin à tout moment.',
                ),
              ]),
              _Paragraph(
                'Au terme de cette durée maximale de 4 heures, l’intéressé devra être relâché même si '
                'la recherche d’identité s’est avérée négative.',
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      'L’officier de police judiciaire a toutefois la possibilité de placer l’intéressé en garde à vue '
                      'si les conditions sont réunies. Dans cette hypothèse, la durée de la rétention s’impute sur '
                      'celle de la garde à vue (',
                ),
                TextSpan(
                  text: 'article 78-4 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                TextSpan(text: ').'),
              ]),
            ],
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
