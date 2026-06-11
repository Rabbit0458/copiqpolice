import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaUtiliteCameraPietonPage extends StatelessWidget {
  const PaUtiliteCameraPietonPage({super.key});

  static const String routeName = '/pa/dps_dpg/policier_intervention/patrouille/utilite-camera';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardOps = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardEx = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardRef = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
          "Patrouille",
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
            "L’utilité de la caméra piéton",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Base légale en haut
          _ConditionCard(
            title: "I — Base légale & cadre de référence",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(text: "Références principales : "),
                TextSpan(
                  text:
                      "articles L. 241-1 et R. 241-1 et suivants du Code de la sécurité intérieure",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Textes internes (doctrine d’emploi) : "),
                TextSpan(
                  text:
                      "Instruction conjointe DGPN 2022-1793D et DGGN 044679 du 14/09/2022",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " relative à l’emploi des caméras piétons ; ",
                ),
                TextSpan(
                  text: "Note DGPN 2022-1793D du 28/10/2022",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " relative à l’emploi des caméras piétons mises en dotation dans les services de la police nationale.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — À quoi ça sert (concrètement) ?",
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le déploiement des caméras individuelles permet de renforcer la sécurité juridique et physique "
                "des policiers lors de leurs interventions, notamment dans un contexte tendu.",
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text:
                    "Aider à prouver la réalité d’une infraction et la légitimité de l’action des policiers.",
              ),
              _IntroBullet(
                text:
                    "Désamorcer certaines situations : la présence d’une caméra peut réduire la tension et l’agressivité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Des possibilités d’utilisation très larges",
            cardColor: cardOps,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le cadre légal prévoit un usage très large : les enregistrements audiovisuels via caméra piéton "
                "sont possibles dans toutes les missions de police, en tous lieux.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Dans un domicile, la captation audiovisuelle se limite strictement à l’intervention et aux personnes concernées.",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("Un intérêt opérationnel avéré"),
              _Paragraph(
                "De nombreux RETEX (retours d’expérience) et comptes rendus d’enquête administrative mettent en évidence "
                "l’intérêt, pour le policier, d’activer sa caméra piéton.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Point clé",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’enregistrement rétroactif des 30 secondes avant déclenchement (mémoire tampon) est une raison supplémentaire d’utiliser la caméra.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Exemples opérationnels (RETEX)",
            cardColor: cardEx,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "1) Faux signalement / mise en cause de l’action",
              ),
              _Paragraph(
                "Lors d’un contrôle d’identité, un individu se jette contre un mur et se cogne plusieurs fois la tête "
                "en criant à son fils : « Appelle l’avocat, on va dire qu’ils nous ont frappés ».",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Le fait d’indiquer qu’un agent filme l’intervention a eu un effet immédiat : l’individu s’est calmé.",
              ),

              SizedBox(height: 14),

              _SubTitle("2) Manifestation : caractériser et identifier"),
              _Paragraph(
                "Lors d’une manifestation, un individu jette une pierre au visage d’un policier, frappe un autre agent "
                "et dégrade un véhicule.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "L’exploitation de la vidéo permet de caractériser l’infraction, d’identifier l’auteur et de l’interpeller.",
              ),

              SizedBox(height: 14),

              _SubTitle("3) Usage du PIE : remise en contexte"),
              _Paragraph(
                "Des policiers ont été contraints de faire usage du PIE pour maîtriser un mis en cause. "
                "Des images sorties du contexte, diffusées sur les réseaux sociaux, cherchaient à faire croire à un usage illégitime de la force.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "L’enregistrement de la caméra piéton a permis de démontrer le bien-fondé de l’action des policiers.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(text: "Référence : "),
                  TextSpan(
                    text: "Communication RETEX DCSP",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — L’activation : un réflexe",
            cardColor: cardOps,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La caméra piéton, activée conformément à la doctrine d’emploi, est une nécessité pour le policier "
                "et doit devenir un réflexe.",
              ),
              SizedBox(height: 10),
              _SubTitle("En résumé"),
              _IntroBullet(
                text:
                    "Elle contribue à la protection du policier et peut établir la preuve des comportements délictueux des usagers.",
              ),
              _IntroBullet(
                text:
                    "Dans un environnement où tout est filmé et souvent détourné pour décrédibiliser l’action, disposer d’images issues des caméras piétons sécurise l’intervention.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Attention",
                bodySpans: [
                  TextSpan(
                    text:
                        "Cette fiche n’édicte pas de prescriptions contraignantes ou exclusives : elle apporte un éclairage et une aide dans l’accomplissement des activités professionnelles.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VI — Pour aller plus loin",
            cardColor: cardRef,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Formation"),
              _Paragraph(
                "Plate-forme eCampus : Cours / Applications police / Caméras piétons.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Lien",
                bodySpans: [
                  TextSpan(
                    text:
                        "https://e-campus.interieur.gouv.fr/course/view.php?id=2318",
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle("Esprit AMARIS"),
              _Paragraph(
                "Partageons nos expériences ; renforçons notre sécurité.",
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
