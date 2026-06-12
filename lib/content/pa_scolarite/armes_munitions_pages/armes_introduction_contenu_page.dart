import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaArmesIntroductionPage extends StatelessWidget {
  const PaArmesIntroductionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/armes_munitions_pages/armes_introduction';

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
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardGoals = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardMeasures = isDark
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
          "Armes & munitions",
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
            "Introduction",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Élément légal (texte fondateur)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Loi n°2012-304 du 06 mars 2012",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : relative à l’établissement d’un contrôle des armes moderne, simplifié et préventif.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Cette loi met en place une nomenclature des armes selon leur régime juridique d’acquisition et de détention, "
                "avec un objectif de modernisation des procédures et de renforcement de la sécurité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Présentation générale
          _ConditionCard(
            title: "Ce que la loi organise",
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La réglementation répartit les armes en 4 catégories, en fonction du régime juridique applicable "
                "(interdiction, autorisation, déclaration, liberté).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Catégories
          _ConditionCard(
            title: "Les 4 catégories",
            cardColor: cardCat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Catégorie A : matériels de guerre et armes interdits (acquisition et détention interdites).",
              ),
              _IntroBullet(
                text:
                    "Catégorie B : armes soumises à autorisation (acquisition/détention sous conditions strictes).",
              ),
              _IntroBullet(
                text:
                    "Catégorie C : armes soumises à déclaration (détention possible après déclaration).",
              ),
              _IntroBullet(
                text:
                    "Catégorie D : armes et matériels dont l’acquisition et la détention sont libres (selon conditions prévues).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Finalités de la loi
          _ConditionCard(
            title: "Les finalités de la réglementation",
            cardColor: cardGoals,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Moderniser les procédures administratives"),
              _Paragraph(
                "La réglementation vise à simplifier et moderniser les démarches : "
                "des allègements de formalités ont été mis en place pour les détenteurs légaux d’armes à feu.",
              ),
              SizedBox(height: 12),
              _SubTitle("2) Renforcer la sécurité et préserver l’ordre public"),
              _Paragraph(
                "Le texte cherche à préserver une diffusion maîtrisée des armes, afin de garantir l’ordre public, "
                "en renforçant les outils de prévention et de répression.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mesures prévues par le législateur
          _ConditionCard(
            title: "Mesures prévues par le législateur",
            cardColor: cardMeasures,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle(
                "A) Rendre obligatoires certaines peines complémentaires",
              ),
              _Paragraph(
                "Dans le cadre de certaines infractions (atteintes à la vie, atteintes à l’intégrité physique ou psychique…), "
                "les peines complémentaires auparavant laissées à l’appréciation du juge peuvent être rendues obligatoires.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: "Interdiction de détenir et de porter une arme.",
              ),
              _BulletPoint(text: "Retrait du permis de chasser."),
              _BulletPoint(text: "Confiscation des armes."),
              SizedBox(height: 12),

              _SubTitle(
                "B) Renforcer le volet pénal (trafic illégal d’armes)",
              ),
              _Paragraph(
                "Renforcer la répression pour mieux lutter contre les filières et le trafic illégal d’armes.",
              ),
              SizedBox(height: 12),

              _SubTitle(
                "C) Créer de nouvelles mesures pour interdire l’accès aux armes",
              ),
              _Paragraph(
                "L’objectif est d’empêcher l’accès aux armes aux personnes condamnées pour des infractions "
                "révélant un comportement violent.",
              ),
              SizedBox(height: 12),

              _SubTitle("D) Renforcer les saisies administratives"),
              _Paragraph(
                "Désormais, toutes les catégories d’armes peuvent faire l’objet d’une saisie administrative.",
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En pratique : la logique de la loi = simplifier pour les détenteurs légitimes, "
                        "mais durcir l’accès et les mesures contre les comportements dangereux et le trafic.",
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
