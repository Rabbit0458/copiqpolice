import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEnregistrementImagesViolencePage extends StatelessWidget {
  const PaEnregistrementImagesViolencePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/enregistrement_diffusion_images/enregistrement';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _t(String text, {bool bold = false}) => TextSpan(
    text: text,
    style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

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
          "Crimes & délits contre la personne",
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
            "L’enregistrement d’images de violence (happy slapping)",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le fait d’enregistrer sciemment, par quelque moyen que ce soit et sur tout support, "
                "des images relatives à la commission d’atteintes volontaires à l’intégrité de la personne "
                "(violences, viol, agressions sexuelles délictuelles, administration de substance à fin sexuelle, "
                "harcèlement sexuel…) constitue un acte de complicité de ces infractions.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law("Article 222-33-3 du Code pénal"),
                _t(
                  " : incrimine le fait d’enregistrer sciemment des images relatives à des atteintes volontaires "
                  "à l’intégrité physique de la personne. La répression est celle des infractions enregistrées.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Un enregistrement d’images de violence"),
              const _Paragraph(
                "L’acte d’enregistrement est assimilé à un cas de complicité au sens du droit commun. "
                "Il doit s’agir d’une représentation visuelle obtenue par un procédé technique (photo, film…). "
                "Sont exclus : dessin/peinture (représentation analogique) et fixation sonore (cris, audio seul).",
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "B) Des violences visées limitativement par la loi",
              ),
              _Paragraph.rich([
                _t("Sont visées par "),
                _law("l’article 222-33-3 du Code pénal"),
                _t(" (liste limitative) :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Tortures et actes de barbarie."),
              const _BulletPoint(
                text:
                    "Violences volontaires délictuelles (même aggravées), à l’exclusion des violences sur forces de sécurité intérieure prévues à l’article 222-14-5 du Code pénal.",
              ),
              const _BulletPoint(text: "Viol."),
              const _BulletPoint(text: "Agressions sexuelles délictuelles."),
              const _BulletPoint(
                text:
                    "Administration d’une substance afin de commettre un viol ou une agression sexuelle.",
              ),
              const _BulletPoint(text: "Harcèlement sexuel."),
              const SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  _t(
                    "La liste est limitative : les infractions voisines sont exclues du champ d’application.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("C) Moment décisif : pendant l’exécution"),
              const _Paragraph(
                "L’objet de l’enregistrement doit porter sur des images relatives à la commission de l’infraction : "
                "cela couvre la consommation et la tentative, mais seulement pendant la phase d’exécution.\n\n"
                "Ne relèvent pas du texte : images antérieures (menaces, approche) ou postérieures (victime au sol) "
                "si l’atteinte n’est plus en cours.",
              ),
              const SizedBox(height: 12),

              _NotaBox(
                title: "À retenir",
                bodySpans: [
                  _t(
                    "Enregistrer un contenu violent déjà existant (ex. vidéo trouvée sur Internet) ne relève pas de cet article : "
                    "on pourra retenir une autre qualification (ex. recel), selon les faits.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("D) Victime consentante : infraction possible"),
              const _Paragraph(
                "Le fait d’enregistrer des violences volontaires commises sur un individu consentant peut entrer dans le champ "
                "du texte, car les violences volontaires sont constituées même si la victime est consentante.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Un enregistrement réalisé sciemment"),
              _Paragraph(
                "L’acte doit être volontaire : l’auteur a conscience de filmer/photographier une scène de violences.",
              ),
              SizedBox(height: 10),
              _SubTitle(
                "B) Conscience de filmer une infraction de violence",
              ),
              _Paragraph(
                "La responsabilité est exclue en cas d’erreur de fait : par exemple si l’auteur croit que les coups portés sont feints.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Faits justificatifs (placé visuellement comme une zone clé)
          _ConditionCard(
            title: "Faits justificatifs",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _t("Selon "),
                _law("l’article 222-33-3 alinéa 3 du Code pénal"),
                _t(", l’incrimination ne s’applique pas lorsque :"),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "L’enregistrement ou la diffusion résulte de l’exercice normal d’une profession ayant pour objet d’informer le public (journalisme), sous réserve du respect des règles (dignité, identification…).",
              ),
              const _BulletPoint(
                text:
                    "L’enregistrement est réalisé afin de servir de preuve en justice (établir la matérialité des faits, identifier les auteurs).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’enregistrement étant un fait de complicité, les circonstances aggravantes de l’infraction principale "
                "peuvent être communicables au complice.\n\n"
                "De même, la circonstance aggravante de réunion peut être retenue si l’auteur de l’enregistrement est complice de l’infraction initiale.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — principe"),
              _Paragraph.rich([
                _t(
                  "Les peines sont celles prévues pour les infractions faisant l’objet de l’enregistrement — ",
                ),
                _law("article 222-33-3 alinéa 1 du Code pénal"),
                _t("."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                _t("Responsabilité pénale prévue par "),
                _law("l’article 121-2 du Code pénal"),
                _t("."),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(text: "Tentative : NON."),
              _Paragraph.rich([
                _t("Complicité : OUI, conformément aux "),
                _law("articles 121-6"),
                _t(" et "),
                _law("121-7 du Code pénal"),
                _t("."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  _t("La complicité de complicité est répréhensible "),
                  _law("(Cass. crim., 15 décembre 2004)"),
                  _t("."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  _t(
                    "L’auteur de l’infraction principale ne peut pas être considéré comme complice si c’est lui qui demande à être filmé.",
                  ),
                ],
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
