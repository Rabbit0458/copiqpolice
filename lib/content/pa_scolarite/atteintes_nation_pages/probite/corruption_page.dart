import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaCorruptionPage extends StatelessWidget {
  const PaCorruptionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_nation_pages/probite/corruption';

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
          "Probité",
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
            "La corruption",
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
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La corruption consiste, pour une personne dépositaire de l’autorité publique, chargée d’une mission de service public "
                "ou investie d’un mandat électif public, à solliciter ou agréer, sans droit, directement ou indirectement, "
                "des offres, promesses, dons, présents ou avantages quelconques (pour elle-même ou pour autrui) "
                "afin d’accomplir (ou d’avoir accompli), ou de s’abstenir (ou de s’être abstenue) d’accomplir :\n"
                "• un acte de sa fonction, de sa mission ou de son mandat,\n"
                "• ou un acte facilité par sa fonction, sa mission ou son mandat.",
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
            children: const [
              _Paragraph(
                "La qualification « active » ou « passive » ne dépend pas de l’initiative, mais de la qualité de l’auteur :\n"
                "• Un particulier : corruption active (même s’il accepte une proposition).\n"
                "• Un agent public : corruption passive (même s’il est à l’origine de la demande).",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "La corruption passive est prévue et réprimée par ",
                ),
                TextSpan(
                  text: "l’article 432-11 alinéas 1 et 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
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
            children: const [
              _Paragraph(
                "Il y a corruption passive lorsqu’un agent public utilise sa fonction en sollicitant ou en acceptant "
                "des avantages pour accomplir ou avoir accompli, ou pour s’abstenir ou s’être abstenu d’accomplir "
                "un acte de sa fonction (ou facilité par sa fonction).",
              ),
              SizedBox(height: 12),

              _SubTitle("A) Un auteur : le corrompu"),
              _Paragraph(
                "Le texte vise :\n"
                "• la personne dépositaire de l’autorité publique ;\n"
                "• la personne chargée d’une mission de service public ;\n"
                "• la personne investie d’un mandat électif public.",
              ),
              SizedBox(height: 10),

              _SubTitle("1) Personne dépositaire de l’autorité publique"),
              _Paragraph(
                "Est dépositaire de l’autorité publique celui qui dispose d’un pouvoir de décision fondé sur une parcelle d’autorité publique "
                "conférée par ses fonctions (fonctionnaire, militaire, magistrat, officier public ou ministériel, etc.).\n\n"
                "Sont notamment concernés : policiers, gendarmes, douaniers, huissiers, commissaires-priseurs, fonctionnaires des eaux et forêts.",
              ),
              SizedBox(height: 10),

              _SubTitle(
                "2) Personne investie d’un mandat électif public",
              ),
              _Paragraph(
                "Sont visés les membres des grands corps nationaux (Sénat, Assemblée nationale), mais aussi les assemblées régionales, "
                "départementales et communales (conseil municipal, conseiller départemental, etc.).\n\n"
                "Sont également visés les présidents et membres élus de certains établissements publics administratifs "
                "(chambres de commerce et d’industrie, chambres d’agriculture, chambres des métiers).",
              ),
              SizedBox(height: 10),

              _SubTitle(
                "3) Personne chargée d’une mission de service public",
              ),
              _Paragraph(
                "Est chargée d’une mission de service public la personne qui accomplit, à titre temporaire ou permanent, volontairement "
                "ou sur réquisition, un service public quelconque. Elle participe à une mission d’intérêt général sans pouvoir de décision "
                "ou de commandement.",
              ),

              SizedBox(height: 14),

              _SubTitle("B) Un comportement : solliciter ou agréer"),
              _SubTitle("1) La sollicitation"),
              _Paragraph(
                "La sollicitation suppose une démarche de l’intéressé : il fait comprendre, directement ou indirectement, "
                "qu’il faut « payer » pour obtenir l’accomplissement (ou le non-accomplissement) de l’acte.",
              ),
              SizedBox(height: 10),
              _SubTitle("2) L’agrément"),
              _Paragraph(
                "L’agrément est l’accord donné à la proposition : il existe alors un accord de volontés entre corrupteur et corrompu, "
                "souvent appelé « pacte de corruption ». Il est indifférent que cet accord soit suivi d’exécution.",
              ),
              SizedBox(height: 10),

              _SubTitle("Modalités importantes"),
              _BulletPoint(
                text:
                    "Directement ou indirectement : la sollicitation par personne interposée est punissable (si le rôle délictueux est établi).",
              ),
              _BulletPoint(
                text:
                    "À tout moment : le pacte peut être conclu avant l’acte, après l’acte, ou même pour remercier un acte déjà accompli.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Acceptation d’avantages postérieurement à l’accomplissement d’un acte de la fonction (mandat électif) : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 27 octobre 1997",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("C) Un bénéfice attendu"),
              _Paragraph(
                "Les « offres, promesses, dons, présents ou avantages quelconques » s’entendent largement : "
                "argent, objets de valeur, immeubles, voyages, droits de chasse, etc.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Prise en charge de dépenses personnelles imposée à des entreprises (voyages d’agrément, frais de chasse) : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 16 mai 2001",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                "D) Un lien avec un acte de la fonction (ou facilité)",
              ),
              _Paragraph(
                "Il faut un lien entre la sollicitation/l’agrément et l’accomplissement (ou l’abstention) d’un acte :\n"
                "• acte de la fonction/mission/mandat (au sens large : textes + discipline de la fonction) ;\n"
                "• ou acte « facilité » par la fonction/mission/mandat (ex. monnayer des renseignements obtenus grâce aux facilités du poste).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Fonctionnaire de police proposant/acceptant qu’on ne dresse pas procès-verbal d’un fait délictueux qu’il avait compétence pour constater : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 17 novembre 1955",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence",
                bodySpans: [
                  TextSpan(
                    text:
                        "Fonctionnaire de préfecture recevant de l’argent pour faciliter la délivrance d’un titre de séjour : ",
                  ),
                  TextSpan(
                    text: "Cass. crim., 03 juin 1997",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                "E) L’avantage peut profiter à l’auteur ou à un tiers",
              ),
              _Paragraph(
                "L’avantage peut être reçu par l’agent public lui-même ou par un tiers : proche, ami, ou une personne morale "
                "(ex. parti, société écran, etc.).",
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
              _SubTitle("A) Conscience de violer le devoir de probité"),
              _Paragraph(
                "L’agent public doit avoir conscience d’agir en violation de son devoir de probité.",
              ),
              SizedBox(height: 10),
              _SubTitle("B) Volonté d’obtenir (ou d’accepter) un avantage"),
              _Paragraph(
                "Il faut établir que l’avantage a été accepté ou recherché en sachant qu’il constituait la contrepartie "
                "d’un acte (ou d’une abstention) de la fonction, ou facilité par la fonction. Le mobile importe peu.",
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 432-11 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : aggravation lorsque l’infraction est commise en bande organisée.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(text: "Qualification simple : "),
                TextSpan(
                  text: "10 ans d’emprisonnement et 1 000 000 € d’amende ",
                ),
                TextSpan(
                  text:
                      "(montant pouvant être porté au double du produit tiré de l’infraction). — ",
                ),
                TextSpan(
                  text: "article 432-11 alinéas 1 et 2 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Bande organisée : "),
                TextSpan(
                  text: "10 ans d’emprisonnement et 2 000 000 € d’amende ",
                ),
                TextSpan(
                  text:
                      "(montant pouvant être porté au double du produit tiré de l’infraction). — ",
                ),
                TextSpan(
                  text: "article 432-11 alinéa 4 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph(
                "Les personnes morales peuvent être reconnues responsables pénalement (selon les règles générales).",
              ),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _BulletPoint(text: "Tentative : NON (non punissable)."),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI — application de "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: " (aide/assistance, provocation, instructions).",
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle("Réduction ou exemption de peine"),
              _Paragraph.rich([
                TextSpan(text: "OUI — "),
                TextSpan(
                  text: "article 432-11-1 du Code pénal",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : l’auteur ou le complice qui permet de faire cesser l’infraction ou d’identifier les autres auteurs/complices "
                      "peut voir sa peine privative de liberté réduite de moitié.",
                ),
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
