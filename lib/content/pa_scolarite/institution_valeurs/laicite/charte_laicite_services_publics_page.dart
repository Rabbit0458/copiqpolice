import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCharteLaiciteServicesPublicsPage extends StatelessWidget {
  const PaCharteLaiciteServicesPublicsPage({super.key});

  static const String routeName = '/pa/institution/laicite/charte';

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
    final Color cardPrincipes = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardAgents = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardUsagers = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInfos = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

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
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

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
          "Institution",
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
            "Charte de la laïcité dans les services publics",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro courte (pédagogique)
          _ConditionCard(
            title: "Repère rapide",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "La laïcité garantit la liberté de conscience, l’égalité de tous devant la loi et la neutralité du service public.",
              ),
              _IntroBullet(
                text:
                    "Elle protège à la fois les usagers (droits) et fixe des obligations aux agents (neutralité, exemplarité).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principes généraux (charte)
          _ConditionCard(
            title: "I — Principes de la République",
            cardColor: cardPrincipes,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La France est une République indivisible, laïque, démocratique et sociale.\n"
                "Elle assure l’égalité devant la loi de tous les citoyens, sans distinction d’origine, de race ou de religion. "
                "Elle garantit des droits égaux aux hommes et aux femmes et respecte toutes les croyances.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Nul ne doit être inquiété pour ses opinions, notamment religieuses, pourvu que leur manifestation "
                "ne trouble pas l’ordre public établi par la loi.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "La liberté de religion ou de conviction ne rencontre que des limites nécessaires au respect du pluralisme religieux, "
                "à la protection des droits et libertés d’autrui, aux impératifs de l’ordre public et au maintien de la paix civile.",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La République assure la liberté de conscience et garantit le libre exercice des cultes dans les conditions fixées par la ",
                ),
                TextSpan(
                  text: "loi du 9 décembre 1905",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Pour assurer la conciliation entre liberté de conscience de chacun et égalité de tous, "
                "la laïcité s’impose à l’ensemble des services publics, quel que soit leur mode de gestion.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Agents du service public
          _ConditionCard(
            title: "II — Les agents du service public",
            cardColor: cardAgents,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Égalité & accès aux emplois"),
              _BulletPoint(
                text:
                    "Toute discrimination dans l’accès aux emplois publics et le déroulement de carrière des agents est interdite.",
              ),

              SizedBox(height: 10),

              _SubTitle("B) Neutralité & exemplarité"),
              _BulletPoint(
                text:
                    "Tout agent public a un devoir de stricte neutralité dans l’exercice de ses fonctions.",
              ),
              _BulletPoint(
                text:
                    "Il incarne les valeurs du service public et se montre exemplaire : traitement égal de tous les usagers et respect de leur liberté de conscience.",
              ),

              SizedBox(height: 10),

              _SubTitle("C) Interdiction de manifester ses convictions"),
              _Paragraph(
                "Le principe de laïcité interdit à l’agent de manifester ses convictions religieuses dans l’exercice de ses fonctions, "
                "quelles qu’elles soient.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le non-respect de cette règle constitue un manquement aux obligations pouvant donner lieu à des poursuites disciplinaires.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("D) Liberté de conscience des agents"),
              _Paragraph(
                "La liberté de conscience est garantie aux agents publics. Ils peuvent bénéficier d’autorisations d’absence pour participer "
                "à une fête religieuse, à condition que cela soit compatible avec les nécessités du fonctionnement normal du service.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Il appartient au chef de service de faire respecter les principes de neutralité et de laïcité par les agents sur lesquels il a autorité.",
              ),

              SizedBox(height: 12),

              _SubTitle(
                "E) Salariés de droit privé en mission de service public",
              ),
              _BulletPoint(
                text:
                    "Les mêmes obligations s’appliquent aux salariés de droit privé lorsqu’ils participent à une mission de service public.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Usagers du service public
          _ConditionCard(
            title: "III — Les usagers du service public",
            cardColor: cardUsagers,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Égalité & expression des convictions"),
              _BulletPoint(
                text: "Tous les usagers sont égaux devant le service public.",
              ),
              _BulletPoint(
                text:
                    "Ils peuvent exprimer leurs convictions religieuses dans les limites du respect de la neutralité du service public, de son bon fonctionnement, et des impératifs d’ordre public (sécurité, santé, hygiène).",
              ),

              SizedBox(height: 10),

              _SubTitle("B) Interdiction du prosélytisme"),
              _BulletPoint(
                text:
                    "Les usagers doivent s’abstenir de toute forme de prosélytisme.",
              ),

              SizedBox(height: 10),

              _SubTitle(
                "C) Règles communes : pas d’exception au nom des croyances",
              ),
              _Paragraph(
                "Le principe de laïcité interdit à quiconque de se prévaloir de ses croyances religieuses pour s’affranchir des règles communes "
                "régissant les relations entre collectivités publiques et particuliers.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Les usagers ne peuvent récuser un agent public ou d’autres usagers, ni exiger une adaptation du service ou d’un équipement public pour des motifs religieux.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Dans les cas les plus graves, des sanctions pénales peuvent être appliquées.",
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle("D) Vérification d’identité"),
              _Paragraph(
                "Lorsque la vérification de l’identité est nécessaire, les usagers doivent se conformer aux obligations qui en découlent.",
              ),

              SizedBox(height: 12),

              _SubTitle("E) Usagers accueillis à temps complet"),
              _Paragraph(
                "Les usagers accueillis à temps complet dans un service public (notamment médico-social, hospitalier ou pénitentiaire) "
                "ont droit au respect de leurs croyances et à l’exercice de leur culte, sous réserve des contraintes liées au bon fonctionnement du service.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infos / MAJ
          _ConditionCard(
            title: "Infos",
            cardColor: cardInfos,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Mis à jour le "),
                TextSpan(
                  text: "13/03/2025",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph("Pour en savoir plus : www.laicite.gouv.fr"),
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
