import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaContrainteAtteinteSexuelleTiersPage extends StatelessWidget {
  const PaContrainteAtteinteSexuelleTiersPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/viol_inceste_agressions/contrainte_atteinte_sexuelle_tiers';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color pageBg = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF6F7FB);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    // Palette par section (cohérente avec tes autres pages)
    final Color cIntro = isDark
        ? const Color(0xFF101A2B)
        : const Color(0xFFEAF2FF);
    final Color cIntroAccent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    final Color cLegal = isDark
        ? const Color(0xFF1B1420)
        : const Color(0xFFFFEBEE);
    final Color cLegalAccent = isDark
        ? const Color(0xFFE57373)
        : const Color(0xFFC62828);

    final Color cMat = isDark
        ? const Color(0xFF0F1E19)
        : const Color(0xFFE8F5E9);
    final Color cMatAccent = isDark
        ? const Color(0xFF81C784)
        : const Color(0xFF2E7D32);

    final Color cMoral = isDark
        ? const Color(0xFF1A1A11)
        : const Color(0xFFFFF8E1);
    final Color cMoralAccent = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

    final Color cAggr = isDark
        ? const Color(0xFF1A1411)
        : const Color(0xFFFFF3E0);
    final Color cAggrAccent = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFEF6C00);

    final Color cRepr = isDark
        ? const Color(0xFF121821)
        : const Color(0xFFE8EAF6);
    final Color cReprAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF283593);

    // ✅ Articles en rouge (CP/CPP/CSI/etc.)
    TextSpan lawRef(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
    );
    TextSpan normal(String s) => TextSpan(text: s);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: Text(
          "Contrainte en vue de subir une atteinte sexuelle (tiers)",
          style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : const Color(0xFF0D1B2A),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ EXIGENCE : l’article qui définit l’élément légal en tout premier
              _ConditionCard(
                title: "Article de référence (élément légal)",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-22-2 du Code pénal"),
                    normal(
                      " : prévoit et réprime le fait d’imposer à une personne, par violence, contrainte, menace ou surprise, "
                      "de subir une atteinte sexuelle de la part d’un tiers ou de procéder sur elle-même à une telle atteinte.",
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _ConditionCard(
                title: "Définition",
                cardColor: cIntro,
                accent: cIntroAccent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    "Le fait d’imposer à une personne, par violence, contrainte, menace ou surprise, "
                    "de subir une atteinte sexuelle de la part d’un tiers ou de procéder sur elle-même à une telle atteinte "
                    "est une agression sexuelle et constitue une infraction.",
                  ),
                  SizedBox(height: 10),
                  _SubTitle("À retenir"),
                  _IntroBullet(
                    text:
                        "Infraction d’« agression sexuelle » : on impose à la victime de subir une atteinte sexuelle par un tiers (ou sur elle-même).",
                  ),
                  _IntroBullet(
                    text:
                        "Les moyens visés par le texte (violence, contrainte, menace, surprise) excluent un consentement libre.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // I — Élément légal
              _ConditionCard(
                title: "I — Élément légal",
                cardColor: cLegal,
                accent: cLegalAccent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    lawRef("Article 222-22-2 du C.P."),
                    normal(
                      " : incrimine le fait d’imposer, par violence, contrainte, menace ou surprise, "
                      "à une personne de subir une atteinte sexuelle de la part d’un tiers ou de procéder sur elle-même à une telle atteinte.",
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              // II — Élément matériel
              _ConditionCard(
                title: "II — Élément matériel",
                cardColor: cMat,
                accent: cMatAccent,
                titleColor: titleColor,
                children: [
                  const _Paragraph(
                    "Les agissements sont commis par une personne qui impose à la victime de subir des atteintes sexuelles. "
                    "Ils supposent l’emploi de violence, contrainte, menace ou surprise.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("1) Absence de consentement de la victime"),
                  _Paragraph.rich([
                    normal(
                      "L’auteur utilise certains moyens pour atteindre son but en dehors de la volonté de la victime (",
                    ),
                    normal("Cass. crim., 29 avril 1960"),
                    normal("). "),
                    normal("Ces moyens sont fixés par "),
                    lawRef("l’article 222-22-2 du C.P."),
                    normal(
                      " : violence, contrainte, menace ou surprise, exclusives de tout consentement libre.",
                    ),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle(
                    "2) Les moyens : violence, contrainte/menace, surprise",
                  ),
                  const _SubTitle("• La violence"),
                  const _Paragraph(
                    "Il s’agit de violences physiques exercées directement sur la victime. "
                    "Elles doivent être suffisantes pour paralyser sa résistance. "
                    "Les juges apprécient concrètement la résistance de la victime (jurisprudence aujourd’hui moins exigeante qu’avant).",
                  ),

                  const SizedBox(height: 10),

                  const _SubTitle("• La contrainte ou la menace"),
                  _Paragraph.rich([
                    normal(
                      "Ces moyens visent à supprimer le consentement de la victime ; ils peuvent relever de violences morales. ",
                    ),
                    lawRef("L’article 222-22-1 du C.P."),
                    normal(
                      " précise que la contrainte peut être physique ou morale. "
                      "La menace ou la contrainte doivent inspirer une crainte sérieuse et immédiate, appréciée concrètement "
                      "selon la capacité de résistance de la victime (",
                    ),
                    normal("Cass. crim., 8 juin 1994"),
                    normal(")."),
                  ]),

                  const SizedBox(height: 10),

                  const _SubTitle("• La surprise"),
                  const _Paragraph(
                    "La surprise s’entend comme « surprendre le consentement », et non comme la surprise ressentie par la victime. "
                    "Elle concerne notamment les victimes dont la maturité est insuffisante pour comprendre l’acte imposé, "
                    "ou des personnes dont l’état (troubles mentaux/handicap) les rend incapables de consentir. "
                    "Le juge apprécie l’impossibilité de consentir au moment des faits.",
                  ),

                  const SizedBox(height: 12),

                  _NotaBox(
                    title: "NOTA",
                    bodySpans: [
                      normal(
                        "L’imprégnation alcoolique ou la consommation de stupéfiants en toute connaissance de cause ne suffit pas, "
                        "à elle seule, à caractériser un état de vulnérabilité pour certaines aggravations. "
                        "En revanche, l’administration à l’insu de la victime d’une substance altérant le discernement est une "
                        "circonstance aggravante (loi n°2018-703 du 3 août 2018).",
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("3) Faits commis sur un mineur"),
                  const _Paragraph(
                    "La contrainte morale ou la surprise peuvent résulter d’une différence d’âge et/ou de l’autorité de droit ou de fait "
                    "exercée sur la victime. Une autorité de fait peut être caractérisée par une différence d’âge significative entre "
                    "une victime mineure et un auteur majeur. "
                    "Pour un mineur de 15 ans, la contrainte morale ou la surprise peuvent être caractérisées par l’abus de vulnérabilité "
                    "lié à l’absence de discernement nécessaire.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle(
                    "4) Une atteinte sexuelle par un tiers… ou sur soi-même",
                  ),
                  const _Paragraph(
                    "L’incrimination vise celui qui contraint une personne à avoir des relations à caractère sexuel avec un tiers, "
                    "même si ce tiers n’était pas informé de la contrainte. "
                    "Elle vise aussi celui qui impose à la victime de procéder sur elle-même à une atteinte sexuelle.",
                  ),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "L’infraction est assimilée à un viol ou à une agression sexuelle selon la nature de l’atteinte subie.",
                  ),

                  const SizedBox(height: 12),

                  const _SubTitle("Repères : viol vs agression sexuelle"),
                  _Paragraph.rich([
                    lawRef("Article 222-23 du C.P."),
                    normal(
                      " (viol) : « tout acte de pénétration sexuelle, de quelque nature qu’il soit, ou tout acte bucco-génital » "
                      "commis sur autrui ou sur l’auteur. Cela inclut notamment pénétration dans le sexe ou par le sexe, "
                      "ainsi que des actes bucco-génitaux (ex. fellation, cunnilingus).",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _Paragraph(
                    "L’agression sexuelle implique un contact physique entre l’agresseur et la victime, sans pénétration ni acte bucco-génital.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // III — Élément moral
              _ConditionCard(
                title: "III — Élément moral",
                cardColor: cMoral,
                accent: cMoralAccent,
                titleColor: titleColor,
                children: const [
                  _SubTitle("Intention coupable"),
                  _Paragraph(
                    "Comme pour tout crime ou délit, l’incrimination exige une intention coupable. "
                    "L’auteur sait qu’il va faire subir à la victime, par un tiers ou par la victime elle-même, un acte à caractère sexuel contre son gré. "
                    "Cette intention est le plus souvent indissociable de l’acte matériel.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // IV — Circonstances aggravantes
              _ConditionCard(
                title: "IV — Circonstances aggravantes",
                cardColor: cAggr,
                accent: cAggrAccent,
                titleColor: titleColor,
                children: const [
                  _Paragraph(
                    "Les circonstances aggravantes applicables dépendent de la qualification finale (viol ou agression sexuelle) "
                    "et renvoient aux fiches relatives à ces infractions.",
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text:
                        "Circonstances aggravantes des viols : voir les fiches relatives aux viols.",
                  ),
                  _BulletPoint(
                    text:
                        "Circonstances aggravantes des agressions sexuelles : voir les fiches relatives aux agressions sexuelles.",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // V — Répression / tentative / complicité
              _ConditionCard(
                title: "V — Répression, tentative et complicité",
                cardColor: cRepr,
                accent: cReprAccent,
                titleColor: titleColor,
                children: [
                  const _SubTitle("Peines encourues"),
                  _Paragraph.rich([
                    normal("Selon "),
                    lawRef("l’article 222-22-2 alinéa 2 du C.P."),
                    normal(
                      ", ces faits sont punis des peines prévues aux articles 222-23 à 222-30 du C.P., "
                      "selon la nature de l’atteinte subie et les circonstances mentionnées à ces mêmes articles.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _Paragraph.rich([
                    normal("Sont notamment visés les viols définis aux "),
                    lawRef("articles 222-23, 222-23-1 et 222-23-2 du C.P."),
                    normal(
                      ", ainsi que les agressions sexuelles définies aux ",
                    ),
                    lawRef(
                      "articles 222-27, 222-29, 222-29-1, 222-29-2 et 222-29-3 du C.P.",
                    ),
                    normal(", avec leurs aggravations éventuelles."),
                  ]),
                  const SizedBox(height: 12),
                  _Paragraph.rich([
                    normal("Responsabilité pénale des personnes morales : "),
                    lawRef("article 222-33-1 du C.P."),
                    normal(" (amende + peines complémentaires prévues à "),
                    lawRef("l’article 131-39 du C.P."),
                    normal(")."),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Tentative"),
                  _Paragraph.rich([
                    normal("Tentative : OUI — spécialement prévue par "),
                    lawRef("l’article 222-22-2 alinéa 3 du C.P."),
                    normal(
                      ". Elle couvre notamment les situations où les pressions exercées sur la victime n’ont pas été suivies d’effet.",
                    ),
                  ]),

                  const SizedBox(height: 12),

                  const _SubTitle("Complicité"),
                  _Paragraph.rich([
                    normal(
                      "Complicité : OUI — s’applique au fait principal punissable. Fondement : ",
                    ),
                    lawRef("article 121-7 du C.P."),
                    normal(
                      ". Elle suppose un fait de complicité prévu par la loi : aide et assistance, provocation ou instructions données.",
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
