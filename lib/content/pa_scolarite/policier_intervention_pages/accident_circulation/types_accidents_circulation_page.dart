import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaTypesAccidentsCirculationPage extends StatelessWidget {
  const PaTypesAccidentsCirculationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/accident-circulation/types-accidents';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardI = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardII = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardIII = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNota = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
          "Accident de circulation",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            "Les différents types d’accidents de la circulation routière",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition générale
          _ConditionCard(
            title: "Définition",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’accident est, par définition, un événement imprévu et soudain entraînant des dégâts matériels ou corporels ; "
                "sont donc exclus les actes volontaires (homicides, suicides…).",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Par « accident de la circulation routière », on entend tout accident impliquant au moins un véhicule en mouvement, "
                "automoteur ou non, sur une voie ouverte à la circulation publique.",
              ),
              SizedBox(height: 12),
              _SubTitle("Catégories (selon la nature du dommage)"),
              _IntroBullet(text: "Accident mortel"),
              _IntroBullet(text: "Accident corporel"),
              _IntroBullet(text: "Accident matériel"),
            ],
          ),

          const SizedBox(height: 14),

          // I
          _ConditionCard(
            title: "I — L’accident mortel",
            cardColor: cardI,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Pour l’intervention policière sur les lieux, il s’agit d’un accident ayant des conséquences immédiatement mortelles.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Pour l’établissement des données statistiques, est considérée comme victime d’un accident mortel toute personne décédée dans les trente jours qui suivent l’accident.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II
          _ConditionCard(
            title: "II — L’accident corporel",
            cardColor: cardII,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sont considérés comme blessés les victimes ayant subi un traumatisme nécessitant des soins médicaux.",
              ),
              SizedBox(height: 12),
              _SubTitle("Catégories de blessés"),
              _BulletPoint(
                text:
                    "Blessé non hospitalisé : victime ayant reçu des soins médicaux, non hospitalisée ou admise comme patient dans un hôpital moins de 24 heures.",
              ),
              _BulletPoint(
                text:
                    "Blessé hospitalisé : victime admise comme patient dans un hôpital plus de 24 heures.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III
          _ConditionCard(
            title: "III — L’accident matériel",
            cardColor: cardIII,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les accidents n’entraînant que des dommages matériels donnent lieu, en principe, à la rédaction d’un constat amiable "
                "par les conducteurs des véhicules impliqués.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intervention police nécessaire
          _ConditionCard(
            title: "Quand l’intervention police est nécessaire",
            cardColor: cardNota,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’intervention des services de police est nécessaire notamment lorsque :",
              ),
              SizedBox(height: 10),
              _BulletPoint(text: "Un véhicule militaire est impliqué."),
              _BulletPoint(
                text:
                    "Des dégâts sont causés au domaine public, à la voie publique ou à ses dépendances, aux voies ferrées ou à leurs dépendances, aux lignes téléphoniques.",
              ),
              _BulletPoint(
                text:
                    "Un véhicule transportant des marchandises dangereuses a subi des dégâts importants.",
              ),
              _BulletPoint(
                text:
                    "L’accident a causé la mort ou des blessures à un animal domestique.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intervention possible
          _ConditionCard(
            title: "Cas où la police peut aussi intervenir",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les services de police peuvent également être amenés à intervenir dans les cas suivants :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Sur réquisition d’un conducteur (dégâts particulièrement importants, désaccord pour établir le constat amiable, conducteur étranger impliqué…).",
              ),
              _BulletPoint(
                text:
                    "Lorsque la fluidité et la sécurité du trafic sont compromises (ne pas tolérer que les véhicules demeurent en place jusqu’à la fin du constat amiable).",
              ),
              _BulletPoint(
                text:
                    "Lorsqu’il semble probable que l’accident est consécutif à une infraction susceptible d’être relevée (ex : conduite en état d’ivresse).",
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
  final String title = 'NOTA';

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
