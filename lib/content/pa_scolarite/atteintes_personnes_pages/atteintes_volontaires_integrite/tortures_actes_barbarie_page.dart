import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaTorturesActesBarbariePage extends StatelessWidget {
  const PaTorturesActesBarbariePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_volontaires_integrite/tortures_actes_barbarie';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return const TextSpan(); // placeholder to satisfy analyzer in isolation
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ NOTE : la fonction _law ci-dessus est un placeholder si tu colles ce code
    // dans un environnement où tes widgets ne sont pas présents.
    // Dans TON projet, supprime la fonction _law et utilise directement les TextSpan
    // comme dans les Paragraph.rich plus bas (c’est ce que tu fais déjà ailleurs).

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
          "Atteintes volontaires à l’intégrité",
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
            "Les tortures et actes de barbarie",
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
                "Le fait de soumettre une personne à des actes de torture ou de barbarie constitue une infraction.",
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
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " : prévoit et réprime les actes de torture et de barbarie.",
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
            children: const [
              _Paragraph(
                "Le texte ne donne pas une définition exhaustive du comportement sanctionné : l’analyse repose sur la gravité des actes "
                "et la souffrance infligée à la victime.",
              ),

              SizedBox(height: 12),

              _SubTitle("A) Des actes d’une gravité exceptionnelle"),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La Convention des Nations Unies contre la torture (10 décembre 1984) vise ",
                ),
                TextSpan(
                  text:
                      "« tout acte par lequel une douleur ou des souffrances aiguës, physiques ou mentales, sont intentionnellement infligées à une personne ».",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Définition jurisprudentielle",
                bodySpans: [
                  TextSpan(
                    text:
                        "Les tortures ou actes de barbarie supposent la commission d’un ou plusieurs actes d’une gravité exceptionnelle "
                        "dépassant de simples violences, et traduisant la volonté de nier dans la victime la dignité de la personne humaine ",
                  ),
                  TextSpan(
                    text: "(C.A. Lyon, 19 janvier 1996)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text:
                        "Exemples : sévices d’une extrême violence sur une victime dénudée, ligotée et attachée, ayant entraîné la mort ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 10 janvier 2006, n° 05-86.216)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text:
                        "Exorcisme de plusieurs heures : flagellations répétées, ingestion forcée d’eau salée, étranglement, serviette enfoncée dans la bouche, immersions répétées ",
                  ),
                  TextSpan(
                    text: "(Cass. crim., 3 septembre 1996)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("B) Une souffrance infligée"),
              _Paragraph(
                "La notion de torture est souvent liée à l’intensité de la souffrance infligée (physique ou morale), "
                "ce qui permet de distinguer ces actes des violences « simples ».",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "La Cour de cassation retient que les tortures constituent des souffrances physiques pouvant faire naître un sentiment de terreur "
                      "d’une intensité insupportable physiquement ou moralement ",
                ),
                TextSpan(
                  text: "(Cass. crim., 3 septembre 1996)",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle("C) Sur la personne d’autrui"),
              _Paragraph("Les actes doivent être commis sur :"),
              SizedBox(height: 8),
              _BulletPoint(text: "Une personne humaine."),
              _BulletPoint(text: "Une personne vivante."),
              _BulletPoint(text: "Une personne distincte de l’auteur."),
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
              _SubTitle("A) Intention coupable"),
              _Paragraph(
                "L’auteur a l’intention de porter atteinte à l’intégrité d’autrui. Cette intention peut se déduire de la nature des faits commis.",
              ),
              SizedBox(height: 12),
              _SubTitle(
                "B) Volonté de causer une souffrance / nier la dignité",
              ),
              _Paragraph(
                "L’élément moral consiste dans la volonté de causer à la victime une souffrance exceptionnellement aiguë "
                "ou de nier en elle l’existence de la dignité de la personne humaine.",
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
                  text: "Article 222-3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " (1er degré d’aggravation) :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(text: "Sur un mineur de 15 ans."),
              _BulletPoint(text: "Sur une personne vulnérable."),
              _BulletPoint(
                text:
                    "Sur une personne en état de sujétion psychologique ou physique au sens de l’article 223-15-3 du Code pénal.",
              ),
              _BulletPoint(
                text:
                    "Sur un ascendant légitime/naturel ou sur les père/mère adoptifs.",
              ),
              _BulletPoint(
                text:
                    "Sur certaines personnes protégées (police/gendarmerie, administration pénitentiaire, dépositaire de l’autorité publique, sapeur-pompier, etc.) dans l’exercice ou du fait des fonctions (qualité apparente ou connue).",
              ),
              _BulletPoint(
                text:
                    "Sur enseignant/personnels scolaires, agent de transport public, mission de service public, professionnel de santé (qualité apparente ou connue).",
              ),
              _BulletPoint(
                text:
                    "Sur le conjoint/ascendants/descendants (ou personne vivant au domicile) des personnes protégées, en raison des fonctions de ces dernières.",
              ),
              _BulletPoint(
                text:
                    "Sur un témoin, une victime ou une partie civile (empêcher de dénoncer/porter plainte/déposer, ou en raison de la dénonciation/plainte/déposition).",
              ),
              _BulletPoint(
                text:
                    "Sur une personne se livrant à la prostitution (même occasionnellement), si les faits sont commis dans l’exercice de cette activité.",
              ),
              _BulletPoint(
                text:
                    "Par le conjoint/concubin/partenaire lié par un pacte civil de solidarité.",
              ),
              _BulletPoint(
                text:
                    "Pour contraindre à contracter un mariage/une union, ou en raison du refus.",
              ),
              _BulletPoint(
                text:
                    "Par une personne dépositaire de l’autorité publique ou chargée d’une mission de service public.",
              ),
              _BulletPoint(
                text:
                    "Par plusieurs personnes agissant comme auteur ou complice.",
              ),
              _BulletPoint(text: "Avec préméditation ou guet-apens."),
              _BulletPoint(text: "Avec usage ou menace d’une arme."),
              _BulletPoint(
                text:
                    "Par une personne en état d’ivresse manifeste ou sous l’emprise manifeste de stupéfiants.",
              ),
              _BulletPoint(
                text: "Avec des agressions sexuelles autres que le viol.",
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-3 alinéa 19 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (2e degré) : sur un mineur de 15 ans par un ascendant (légitime/naturel/adoptif) ou une personne ayant autorité sur le mineur.",
                ),
              ]),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-4 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " (2e degré) :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(text: "En bande organisée."),
              _BulletPoint(
                text: "De manière habituelle sur un mineur de 15 ans.",
              ),
              _BulletPoint(
                text:
                    "Sur une personne dont la vulnérabilité (âge, maladie, infirmité, déficience, grossesse) est apparente ou connue.",
              ),
              _BulletPoint(
                text:
                    "Sur une personne en état de sujétion psychologique/physique au sens de l’article 223-15-3 du Code pénal (connu de l’auteur).",
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-5 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (2e degré) : lorsque les tortures/actes de barbarie ont entraîné une mutilation ou une infirmité permanente.",
                ),
              ]),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (3e degré) : lorsque les tortures/actes de barbarie précèdent, accompagnent ou suivent un crime autre que le meurtre ou le viol.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 222-6 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (3e degré) : lorsque les tortures/actes de barbarie entraînent la mort sans intention de la donner.",
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: "Référence (CSI)",
                bodySpans: [
                  TextSpan(
                    text:
                        "Certaines aggravations mentionnent aussi un cadre spécifique lié à des fonctions de gardiennage/surveillance d’immeubles.",
                  ),
                  TextSpan(text: " Voir "),
                  TextSpan(
                    text:
                        "l’article L. 271-1 du Code de la sécurité intérieure",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + infractions connexes
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
                  text: "15 ans de réclusion criminelle + période de sûreté — ",
                ),
                TextSpan(
                  text: "article 222-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (1er degré) : "),
                TextSpan(
                  text: "20 ans de réclusion criminelle + période de sûreté — ",
                ),
                TextSpan(
                  text: "article 222-3 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (2e degré) : "),
                TextSpan(
                  text: "30 ans de réclusion criminelle + période de sûreté — ",
                ),
                TextSpan(
                  text: "articles 222-3 al. 19, 222-4 et 222-5 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Aggravée (3e degré) : "),
                TextSpan(
                  text:
                      "réclusion criminelle à perpétuité + période de sûreté — ",
                ),
                TextSpan(
                  text: "articles 222-2 et 222-6 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Personnes morales"),
              _Paragraph.rich([
                TextSpan(text: "Responsabilité pénale prévue par "),
                TextSpan(
                  text: "l’article 222-6-1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle("Tentative & complicité"),
              _Paragraph.rich([
                TextSpan(text: "Tentative : OUI — "),
                TextSpan(
                  text: "article 121-4 (2°) du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ". Exemple : ligoter la victime en vue de sévices (commencement d’exécution interrompu/empêché).",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Complicité : OUI, conformément à "),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudence (complicité)",
                bodySpans: [
                  TextSpan(
                    text:
                        "Condamnation pour complicité de tortures et actes de barbarie ayant entraîné la mort : maintien fermé d’un local dans lequel l’auteur principal brûlait la victime ",
                  ),
                  TextSpan(
                    text: "(C. assises, 8 avril 2006)",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle("Provocation (infraction distincte)"),
              _Paragraph.rich([
                TextSpan(text: "Le "),
                TextSpan(
                  text: "fait de faire des offres/promesses/dons/avantages",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " pour qu’une personne commette (y compris hors du territoire national) des tortures et actes de barbarie est incriminé : ",
                ),
                TextSpan(
                  text: "article 222-6-4 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "L’auteur de la provocation est poursuivi même si les faits ne sont pas suivis d’effet (10 ans et 150 000 €).",
              ),
              _BulletPoint(
                text:
                    "Si la provocation est suivie de faits ou d’une tentative, les règles de complicité s’appliquent.",
              ),

              SizedBox(height: 14),

              _SubTitle("Exemption & réduction de peine"),
              _Paragraph.rich([
                TextSpan(text: "Exemption de peine : "),
                TextSpan(
                  text: "article 222-6-2 alinéa 1 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (avertissement de l’autorité administrative/judiciaire permettant d’éviter la réalisation de l’infraction).",
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(text: "Réduction de peine : "),
                TextSpan(
                  text: "article 222-6-2 alinéa 2 du Code pénal",
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      " (réduction des 2/3 si avertissement permettant de faire cesser les faits, d’éviter mort/infirmité, ou d’identifier les autres auteurs/complices ; perpétuité ramenée à 20 ans).",
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
