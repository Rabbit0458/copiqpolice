import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaTraitePrumPage extends StatelessWidget {
  const PaTraitePrumPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/traité_prum';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Retour',
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Traité de Prüm',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===============================================================
          // EN-TÊTE GÉNÉRAL
          // ===============================================================
          Text(
            'L’entraide judiciaire internationale',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Chapitre 1 — La coopération pénale policière',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 12),

          const _SubTitle('1.2 — Le traité de Prüm'),
          const SizedBox(height: 4),

          const _Paragraph(
            'Le traité de Prüm, ratifié par la France le 1er août 2007, a pour objet '
            'l’approfondissement de la coopération transfrontalière, notamment en vue de '
            'lutter contre le terrorisme, la criminalité organisée et l’immigration illégale. '
            'Dix-sept États sont concernés par son application. '
            'Le 23 juin 2008, les décisions de Prüm ont été transposées dans le cadre '
            'juridique de l’Union européenne.',
          ),
          const SizedBox(height: 12),

          const _NotaBox(
            bodySpans: [
              TextSpan(
                text: 'Version au 01/07/2025 — COP\'IQ, tous droits réservés.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // OBJET ET PORTEE DU TRAITÉ
          // ===============================================================
          _ConditionCard(
            title: 'Objet et portée du traité de Prüm',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Le traité de Prüm renforce la coopération entre les États signataires en '
                'permettant un échange rapide et sécurisé d’informations, ainsi que la mise '
                'en œuvre d’actions communes. Il vise en particulier :',
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text:
                    'À améliorer la lutte contre le terrorisme et la criminalité organisée ;',
              ),
              _IntroBullet(
                text:
                    'À renforcer la lutte contre l’immigration illégale grâce à des outils '
                    'communs et une meilleure coordination des moyens ;',
              ),
              _IntroBullet(
                text:
                    'À faciliter la coopération opérationnelle entre forces de sécurité et '
                    'autorités judiciaires des différents États concernés.',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // PRINCIPALES MESURES PRÉVUES PAR LE TRAITÉ
          // ===============================================================
          _ConditionCard(
            title: 'Principales mesures prévues par le traité de Prüm',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: const [
              _Paragraph(
                'Le traité de Prüm permet aux États parties d’organiser à la fois des échanges '
                'de données et des interventions communes. Parmi les dispositifs majeurs :',
              ),
              SizedBox(height: 10),

              _BulletPoint(
                text:
                    'Les échanges de données génétiques et dactyloscopiques, afin de '
                    'faciliter l’identification des auteurs d’infractions et de rapprocher '
                    'les enquêtes menées dans différents États.',
              ),
              _BulletPoint(
                text:
                    'Pour prévenir les actions terroristes, les États peuvent transmettre des '
                    'données à caractère personnel dans le respect des garanties prévues '
                    'par leurs droits internes et par le droit de l’Union européenne.',
              ),
              _BulletPoint(
                text:
                    'Dans le cadre de la lutte contre l’immigration illégale, le traité prévoit '
                    'une mutualisation en matière de formation des personnels. Il organise '
                    'également la possibilité de mettre en place des vols communs pour les '
                    'mesures d’éloignement et de transiter, le cas échéant, par le territoire '
                    'd’une autre partie contractante au traité.',
              ),
              _BulletPoint(
                text:
                    'La mise en place de patrouilles mixtes et d’interventions communes pour '
                    'le maintien de l’ordre et de la sécurité publics, ainsi que pour la '
                    'prévention des infractions pénales.',
              ),
              _BulletPoint(
                text:
                    'La possibilité de franchir les frontières en cas d’urgence, en vue de '
                    'prendre, en zone frontalière sur le territoire de l’autre partie '
                    'contractante et dans le respect du droit national de celle-ci, les '
                    'mesures provisoires nécessaires afin d’écarter tout danger présent pour '
                    'la vie ou l’intégrité des personnes.',
              ),
              _BulletPoint(
                text:
                    'Les États membres peuvent également prévoir de se prêter assistance '
                    'dans la gestion d’événements d’ordre public programmés (manifestations, '
                    'grands rassemblements, sommets internationaux, etc.).',
              ),
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
