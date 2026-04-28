import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmendeForfaitaireDelictuelleStupPage extends StatelessWidget {
  const AmendeForfaitaireDelictuelleStupPage({super.key});

  static const String routeName =
      '/gpx/intervention/stupefiants/amende-forfaitaire-delictuelle';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardApply = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardModal = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardMoney = isDark
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
          "Stupéfiants",
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
            "Amende forfaitaire délictuelle (AFD)\nUsage illicite de stupéfiants",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal (en haut)
          _ConditionCard(
            title: "I — Élément légal (textes applicables)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "L’action publique peut être éteinte par le paiement d’une AFD : ",
                ),
                TextSpan(
                  text: "articles 495-17 à 495-25 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ; "),
                TextSpan(
                  text:
                      "articles D. 45-3 à D. 45-21 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " ; "),
                TextSpan(
                  text:
                      "articles A. 36-14 à A. 36-18 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Usage illicite de stupéfiants : "),
                TextSpan(
                  text:
                      "article L. 3421-1 alinéa 1 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (Natinf 180)."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "AFD applicable à l’usage : "),
                TextSpan(
                  text:
                      "article L. 3421-1 alinéa 3 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Définition / idée générale
          _ConditionCard(
            title: "Définition (à retenir)",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Lorsque la loi le prévoit, l’action publique peut être éteinte par le paiement d’une "
                "amende forfaitaire délictuelle (AFD).\n\n"
                "En matière d’usage illicite de stupéfiants, l’AFD peut être mise en œuvre si le délit est constaté "
                "dans un cadre juridique adapté et si les conditions de procédure sont réunies.\n\n"
                "La constatation se fait via un procès-verbal électronique (PVe).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Champ d'application
          _ConditionCard(
            title: "II — Champ d’application",
            cardColor: cardApply,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Quand l’AFD peut être mise en œuvre"),
              _BulletPoint(
                text:
                    "Lorsque le délit d’usage illicite de stupéfiants est constaté (PVe).",
              ),
              _BulletPoint(
                text:
                    "La personne est avisée qu’elle recevra un avis d’amende forfaitaire à son domicile (mention dans le PVe).",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Cas où l’AFD ne doit pas être mise en œuvre"),
              _BulletPoint(text: "Mis en cause mineur (AFD exclue)."),
              _BulletPoint(
                text:
                    "Plusieurs infractions constatées simultanément dont au moins une non forfaitisable.",
              ),
              _BulletPoint(
                text:
                    "Auteur dépositaire de l’autorité publique / chargé de mission de service public, ou personnel de transport exerçant des fonctions impactant la sécurité du transport (AFD non applicable).",
              ),
              SizedBox(height: 10),

              _SubTitle(
                "C) Situations excluant en pratique (ou à apprécier selon parquet)",
              ),
              _BulletPoint(text: "Plusieurs délits forfaitisables constatés."),
              _BulletPoint(
                text: "Plusieurs types de produits différents découverts.",
              ),
              _BulletPoint(
                text:
                    "Nécessité d’investigations complémentaires (suspicion trafic, procédure incidente…).",
              ),
              _BulletPoint(
                text:
                    "Conduite d’un véhicule : la conduite après usage de stupéfiants relève du Code de la route.",
              ),
              _BulletPoint(
                text:
                    "Impossibilité d’établir l’identité ou absence d’adresse postale déclarée/confirmée.",
              ),
              _BulletPoint(
                text:
                    "Contestations des faits ou refus de renoncer au droit de contester la destruction des produits/accessoires saisis.",
              ),
              _BulletPoint(
                text:
                    "Absence de pleine capacité de compréhension/décision (barrière langue, troubles manifestes, état incompatible).",
              ),
              _BulletPoint(
                text:
                    "Absence de produit découvert (procédure fondée uniquement sur aveux : non).",
              ),
              _BulletPoint(
                text:
                    "Personne notoirement connue pour plusieurs procédures stupéfiants (appréciation).",
              ),
              _BulletPoint(
                text:
                    "Besoin apparent de prise en charge sanitaire/sociale (signes d’addiction, désociabilisation, troubles psychiques).",
              ),
              _BulletPoint(
                text:
                    "Quantités importantes : > 50 g cannabis, ou > 5 g cocaïne, ou jusqu’à 5 cachets / 5 g de poudre d’ecstasy (MDMA) : AFD normalement non (sauf autorisation exceptionnelle du procureur).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Modalités de constatation
          _ConditionCard(
            title: "III — Modalités de constatation (PVe)",
            cardColor: cardModal,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Cadre juridique de la constatation"),
              _Paragraph.rich([
                const TextSpan(
                  text: "La procédure repose sur une constatation flagrante : ",
                ),
                TextSpan(
                  text: "article 53 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (initiative), ou après contrôle d’identité sur réquisitions : ",
                ),
                TextSpan(
                  text: "articles 78-2 ou 78-2-2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Lieu de rédaction du PVe"),
              const _BulletPoint(
                text:
                    "Le PVe doit être établi sur les lieux de constatation du délit.",
              ),
              const _BulletPoint(
                text:
                    "Exception : retour au service possible pour ordre public / protection agents, avec acceptation du mis en cause de suivre librement.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Description précise des produits"),
              const _BulletPoint(
                text:
                    "Renseigner : nature (cannabis/cocaïne/MDMA…), type (résine/herbe/poudre…), conditionnement (barrette/sachet…).",
              ),
              const _BulletPoint(
                text:
                    "Compléter si besoin (champ libre) : odeur, apparence, objets liés à la consommation, etc.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) Gestion des produits et accessoires saisis"),
              const _BulletPoint(
                text:
                    "Produits et accessoires (grinder, feuilles, pipe…) : saisis et destinés à destruction selon modalités fixées avec le procureur.",
              ),
              const _BulletPoint(
                text:
                    "Acter le consentement du mis en cause à la destruction (et à la remise des objets le cas échéant) via le champ prévu.",
              ),
              const _BulletPoint(
                text:
                    "Aucun scellé ni échantillonnage ne doivent être constitués dans ce cadre.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Montant
          _ConditionCard(
            title: "IV — Montant de l’AFD",
            cardColor: cardMoney,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Montant fixé par "),
                TextSpan(
                  text:
                      "l’article L. 3421-1 alinéa 3 du Code de la santé publique",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " :"),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(text: "Amende forfaitaire minorée : 150 €"),
              const _BulletPoint(
                text: "Amende forfaitaire « ordinaire » : 200 €",
              ),
              const _BulletPoint(text: "Amende forfaitaire majorée : 450 €"),
            ],
          ),

          const SizedBox(height: 14),

          // Paiement / contestation
          _ConditionCard(
            title: "V — Paiement ou contestation",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Amende minorée (délais)"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Paiement minoré possible : entre les mains de l’agent, ou dans les ",
                ),
                const TextSpan(text: "15 jours"),
                const TextSpan(
                  text: " suivant l’envoi de l’avis d’infraction — ",
                ),
                TextSpan(
                  text: "article 495-18 alinéa 2 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Paiement ou requête en exonération"),
              const _Paragraph(
                "Dans les 45 jours suivant la date d’envoi de l’avis d’infraction :\n"
                "• payer l’amende, ou\n"
                "• déposer une requête en exonération.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Amende majorée / réclamation"),
              const _Paragraph(
                "À défaut de paiement ou de requête, le montant est majoré.\n"
                "La majoration peut faire l’objet d’une réclamation dans les 30 jours suivant l’envoi de l’avis au domicile.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) Modes de paiement"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Modes identiques à l’amende forfaitaire contraventionnelle (télépaiement, chèque, virement…) — ",
                ),
                TextSpan(
                  text: "article D. 45-8 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "article R. 49-3 du Code de procédure pénale",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("E) Requête / réclamation"),
              const _BulletPoint(
                text:
                    "Par LRAR, ou en dématérialisé via le site ANTAI (antai.fr).",
              ),
              const SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les conditions de recevabilité et, le cas échéant, la consignation sont précisées dans les documents adressés à l’intéressé.",
                  ),
                  const TextSpan(text: "\n\n"),
                  TextSpan(
                    text:
                        "Dispense de consignation en cas d’usurpation d’identité : article 434-23 du Code pénal",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
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
