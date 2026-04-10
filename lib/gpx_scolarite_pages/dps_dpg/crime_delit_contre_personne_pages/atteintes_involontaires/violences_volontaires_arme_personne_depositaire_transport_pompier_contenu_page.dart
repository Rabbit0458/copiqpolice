import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViolencesVolontairesArmePersonneDepositaireTransportPompierPage
    extends StatelessWidget {
  const ViolencesVolontairesArmePersonneDepositaireTransportPompierPage({
    super.key,
  });

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteintes_involontaires/violences_volontaires_arme_personne_depositaire_transport_pompier';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
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
          "Violences avec arme",
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
            "Violences volontaires avec arme\nsur personne dépositaire / pompier / transport public",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (propre + claire)
          _ConditionCard(
            title: "Définition",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Lorsqu’elles sont commises en bande organisée ou avec guet-apens, les violences commises avec "
                "usage ou menace d’une arme sur certaines victimes (personnes dépositaires de l’autorité publique, "
                "sapeur-pompiers, agents d’un réseau de transport public de voyageurs) dans l’exercice, "
                "à l’occasion, ou en raison des fonctions/missions, constituent une infraction.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Sont également visées, dans les mêmes conditions, les violences commises à l’encontre du conjoint, "
                "d’un ascendant, d’un descendant en ligne directe ou de toute autre personne vivant habituellement au "
                "domicile d’une personne protégée, en raison des fonctions exercées par cette dernière.",
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
                TextSpan(
                  text: "Article 222-14-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : définit et réprime l’infraction."),
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
              const _SubTitle(
                "A) Une commission en bande organisée ou avec guet-apens",
              ),
              const _Paragraph(
                "Les deux conditions sont alternatives : il suffit de l’une ou de l’autre.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "• Bande organisée : "),
                TextSpan(
                  text: "article 132-71 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " — « tout groupement formé ou toute entente établie en vue de la préparation, caractérisée par "
                      "un ou plusieurs faits matériels, d’une ou de plusieurs infractions » (les violences sont alors préméditées).",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "• Guet-apens : fait d’attendre la victime un certain temps, dans un lieu déterminé, "
                "créant un effet de surprise l’empêchant de se défendre.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Des violences commises avec usage ou menace d’une arme",
              ),
              const _Paragraph(
                "Les violences doivent être commises avec une arme (arme par nature ou par destination). "
                "L’usage ou la menace d’une arme suffit.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les violences peuvent être physiques ou psychologiques (au sens large des articles 222-7 et suivants).",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF3E2723),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Une victime particulière (protégée par la loi)",
              ),
              const _Paragraph(
                "La loi vise expressément certaines victimes. Exemples :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Agents de la force publique : fonctionnaires de la police nationale, militaires de la gendarmerie.",
              ),
              const _BulletPoint(
                text: "Membre du personnel de l’administration pénitentiaire.",
              ),
              const _BulletPoint(
                text:
                    "Toute autre personne dépositaire de l’autorité publique (pouvoir de décision/contrainte, par délégation de puissance publique : maires, adjoints, élus délégués…).",
              ),
              const _BulletPoint(text: "Sapeur-pompier civil ou militaire."),
              const _BulletPoint(
                text:
                    "Agent d’un exploitant de réseau de transport public de voyageurs (ex. RATP, SNCF, ramassage scolaire…).",
              ),
              const SizedBox(height: 10),
              const _Paragraph(
                "Sont également protégés : le conjoint, l’ascendant, le descendant en ligne directe, "
                "ou toute personne vivant habituellement au domicile des personnes visées, lorsque les violences "
                "sont commises en raison des fonctions exercées par la personne protégée.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Un contexte lié aux fonctions / mission"),
              const _Paragraph("L’infraction doit être commise :"),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Dans l’exercice des fonctions (victime en service / en train d’accomplir un acte de ses attributions).",
              ),
              const _BulletPoint(
                text:
                    "À l’occasion des fonctions (en raison d’un acte déterminé lié à la fonction, même antérieur).",
              ),
              const _BulletPoint(
                text:
                    "En raison des fonctions (l’auteur agit parce qu’il connaît la qualité de la victime et que cette qualité motive l’agression).",
              ),

              const SizedBox(height: 14),

              const _SubTitle("E) Un résultat dommageable (préjudices)"),
              const _Paragraph(
                "Les violences supposent une atteinte à l’intégrité physique et/ou psychique. "
                "La réalité de cette atteinte doit être établie (souvent par certificat médical).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-14-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : distingue quatre types de préjudices selon que les violences ont entraîné :",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "La mort."),
              const _BulletPoint(
                text: "Une mutilation ou une infirmité permanente.",
              ),
              const _BulletPoint(text: "Une ITT > 8 jours."),
              const _BulletPoint(text: "Une ITT ≤ 8 jours (ou absence d’ITT)."),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Expertise",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’ITT peut, à la demande de la victime ou de la personne poursuivie, être constatée par un médecin expert.",
                  ),
                ],
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
              _SubTitle("A) Conscience d’affecter l’intégrité d’autrui"),
              _Paragraph(
                "L’auteur a conscience de commettre un acte de violence qui va affecter l’intégrité physique "
                "et/ou psychique d’autrui.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Volonté visant une victime à qualité déterminée"),
              _Paragraph(
                "L’auteur veut commettre des violences sur une personne dont la qualité est déterminée "
                "(qualité protégée par le texte).",
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
                "Aucune (le texte incriminant est déjà construit sur des conditions aggravées).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Peines encourues — personnes physiques"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-14-1 4° du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (violences ITT 0 à 8 jours) : "),
                const TextSpan(
                  text:
                      "10 ans d’emprisonnement et 150 000 € d’amende (période de sûreté).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-14-1 3° du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (violences ITT > 8 jours) : "),
                const TextSpan(
                  text: "15 ans de réclusion (période de sûreté).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-14-1 2° du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (mutilation / infirmité permanente) : "),
                const TextSpan(
                  text: "20 ans de réclusion (période de sûreté).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-14-1 1° du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " (mort sans intention de la donner) : "),
                const TextSpan(
                  text: "30 ans de réclusion (période de sûreté).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Personnes morales"),
              _Paragraph.rich([
                const TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 222-16-1 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " (amende + peines complémentaires prévues notamment par l’article 131-39 du Code pénal).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("Tentative & complicité"),
              const _BulletPoint(
                text:
                    "Tentative : NON (les textes relatifs aux violences délictuelles ne visent pas la tentative).",
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                "En matière criminelle, la tentative est théoriquement punissable, mais peut être difficile à établir "
                "car l’infraction est en partie fonction du résultat qu’elle provoque.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(text: "Complicité : OUI."),
              _Paragraph.rich([
                const TextSpan(text: "Punissable conformément aux "),
                TextSpan(
                  text: "articles 121-6 et 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Logique du texte",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’infraction pouvant être commise en bande organisée, cela implique souvent plusieurs auteurs ou complices.",
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
