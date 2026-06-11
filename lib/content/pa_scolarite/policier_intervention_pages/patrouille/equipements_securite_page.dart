import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaEquipementsSecuritePage extends StatelessWidget {
  const PaEquipementsSecuritePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/policier_intervention/patrouille/equipements-securite';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardWear = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMat = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLight = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardVeh = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardPractice = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
            "Les équipements de sécurité",
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
            title: "I — Base réglementaire (signalisation lumineuse)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Pour l’injonction « RALENTIR », la signalisation repose sur l’usage d’un feu jaune orangé. — ",
                ),
                TextSpan(
                  text:
                      "article 7-1 de l’arrêté interministériel du 24 novembre 1967",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le projecteur « LAP » (feu blanc) sert à éclairer la zone accidentée et ne doit jamais être utilisé pour obtenir le ralentissement des véhicules.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Objectif & logique d’emploi",
            cardColor: cardMat,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Sur accident routier ou contrôle routier, de jour comme de nuit, les policiers disposent "
                "d’équipements adaptés pour intervenir en sécurité : vêtements et matériels rétroréfléchissants "
                "ou fluorescents, et moyens lumineux spécifiques.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Vêtements réfléchissants",
            cardColor: cardWear,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) La chasuble réfléchissante"),
              _Paragraph(
                "Gilet sans manches, ouvert sur les côtés et doté d’une matière réfléchissante. "
                "Sur les deux faces, une inscription « POLICE » réfléchissante est fixée.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) L’imperméable de signalisation"),
              _Paragraph(
                "Vêtement imperméable aux coloris : jaune fluorescent, gris rétroréfléchissant et bleu police.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Matériels réfléchissants (balisage)",
            cardColor: cardMat,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les matériels de balisage sont recouverts d’un revêtement possédant les mêmes propriétés "
                "réfléchissantes que les tissus. On retrouve notamment :",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Panneau de signalisation « Tri flash » (avec support repliable).",
              ),
              _BulletPoint(
                text: "Panneaux : « Police ralentir », « Halte police ».",
              ),
              _BulletPoint(text: "Dispositifs coniques : « cônes de Lubeck »."),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Moyens lumineux (balisage nocturne)",
            cardColor: cardLight,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les moyens lumineux les plus utilisés lors d’un balisage nocturne sont :",
              ),
              SizedBox(height: 10),
              _SubTitle("A) Palette de signalisation lumineuse"),
              _Paragraph(
                "À feu clignotant, avec disques colorés orange ou rouge devant la lentille. "
                "Elle permet d’obtenir soit le ralentissement, soit l’arrêt des véhicules.",
              ),
              SizedBox(height: 12),
              _SubTitle("B) Raquette de signalisation"),
              _Paragraph(
                "À feux rouge et orange, fixes ou clignotants. Peut être tenue à la main ou placée sur un mât "
                "démontable pour être employée à poste fixe.",
              ),
              SizedBox(height: 12),
              _SubTitle("C) Bâton lumineux"),
              _Paragraph(
                "Utilisé en étant balancé à bout de bras dans un plan vertical.",
              ),
              SizedBox(height: 12),
              _SubTitle("D) Projecteur « LAP » (feu blanc fixe)"),
              _Paragraph(
                "Sert à éclairer la zone accidentée (véhicule, débris, etc.).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: "Interdiction d’emploi pour « ralentir » : ",
                  ),
                  TextSpan(
                    text:
                        "article 7-1 de l’arrêté interministériel du 24 novembre 1967",
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        " (seul le feu jaune orangé signifie l’injonction « RALENTIR »).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VI — Feux spéciaux des véhicules de police",
            cardColor: cardVeh,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les véhicules de police peuvent être équipés de dispositifs lumineux spéciaux, notamment :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Feux individuels tournants (gyrophares) émettant une lumière bleue.",
              ),
              _BulletPoint(
                text:
                    "Rampe spéciale de signalisation : feux à faisceaux tournants ou stationnaires clignotants bleus ; "
                    "des feux orangés peuvent y être associés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VII — La pratique du policier (conseils terrain)",
            cardColor: cardPractice,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Aucun texte réglementaire (hors l’arrêté évoqué ci-dessus) ne fixe précisément les conditions de mise "
                "en place d’un ensemble de signalisation. L’expérience professionnelle se résume en réflexes à adopter, "
                "notamment lors d’une intervention nocturne :",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "S’équiper de la protection individuelle avant de descendre du véhicule.",
              ),
              _BulletPoint(
                text:
                    "Rester constamment mobile (même équipé d’effets réfléchissants) pour accroître visibilité et sécurité.",
              ),
              _BulletPoint(
                text:
                    "Utiliser uniquement la palette de signalisation (ou éventuellement la raquette) pour obtenir le ralentissement.",
              ),
              _BulletPoint(
                text:
                    "Ne jamais diriger les feux blancs du projecteur « LAP » vers les usagers (risque d’éblouissement et usage non réglementaire).",
              ),
              _BulletPoint(
                text:
                    "Utiliser des cônes coniques à bon pouvoir réfléchissant : propres, récents (durée de vie du revêtement ≈ 6 ans).",
              ),
              _BulletPoint(
                text:
                    "Privilégier les feux à éclats plutôt que les feux fixes/tournants : "
                    "les premiers attirent l’attention sans diminuer la capacité de réaction ; "
                    "les seconds peuvent diminuer les capacités de réaction.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "À retenir",
                bodySpans: [
                  TextSpan(
                    text:
                        "En général, les feux à éclats du panneau tri flash, du véhicule de police et de la palette de signalisation, "
                        "combinés aux effets vestimentaires et matériels réfléchissants, suffisent pour la grande majorité des accidents nocturnes.",
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
