import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnqueteVoisinagePage extends StatelessWidget {
  const EnqueteVoisinagePage({super.key});

  static const String routeName = '/gpx/pv_apj20/temoignage/enquete_voisinage';

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
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMethod = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardOps = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardClose = isDark
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
          "Témoignage",
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
            "Canevas — Procès-verbal d’enquête de voisinage",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Image demandée
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/canva_temoignage.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 14),

          // ✅ (Élément légal en haut) — ici pas d’article “définissant” spécifique dans ton texte,
          // mais on met une carte "Cadre juridique" en premier, comme tu veux.
          _ConditionCard(
            title: "Cadre juridique (à mentionner)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’agent de police judiciaire doit situer l’enquête de voisinage dans un cadre juridique précis :\n"
                "• enquête de flagrance\n"
                "• ou enquête préliminaire\n\n"
                "Ce point doit apparaître clairement dès l’entête / les premières lignes du procès-verbal.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "1 — Lieu de l’opération",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Il convient de mentionner l’endroit exact où se situe l’enquête de voisinage.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Adresse / secteur (ville, rue, numéro, immeuble, étage si nécessaire).",
              ),
              _BulletPoint(
                text:
                    "Contexte : proximité immédiate du lieu des faits ou itinéraire suivi.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "2 — Instructions",
            cardColor: cardMethod,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("Selon la nature de la procédure"),
              _BulletPoint(
                text:
                    "En flagrant délit : l’agent de police judiciaire agit conformément aux instructions reçues de l’officier de police judiciaire.",
              ),
              _BulletPoint(
                text:
                    "En préliminaire : il agit sous le contrôle de l’officier de police judiciaire.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Astuce rédaction : une phrase simple suffit en début de PV (ex. « agissant sur instructions de… » / « sous le contrôle de… »).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "3 — Cadre juridique (rappel rédactionnel)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le rédacteur doit indiquer expressément le cadre juridique retenu pour l’opération : "
                "enquête de flagrance ou enquête préliminaire.\n\n"
                "Ce choix conditionne le vocabulaire employé et les mentions procédurales.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "4 — Assistants éventuels",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le rédacteur mentionne les fonctionnaires qui l’accompagnent pour l’accomplissement de la mission.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Nom / qualité / service (si exigé par tes habitudes de rédaction).",
              ),
              _BulletPoint(
                text: "Rôle sur place (appui, prise de notes, sécurité, etc.).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "5 — Opération (contenu cœur du PV)",
            cardColor: cardOps,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph("L’enquêteur indique de façon structurée :"),
              SizedBox(height: 8),
              _SubTitle("A) Le lieu (adresses)"),
              _IntroBullet(
                text:
                    "Énumérer avec précision les adresses où se déroule l’enquête.",
              ),
              SizedBox(height: 10),
              _SubTitle("B) Les personnes contactées"),
              _IntroBullet(
                text:
                    "Lister les personnes contactées, susceptibles de fournir des éléments utiles à l’enquête.",
              ),
              SizedBox(height: 10),
              _SubTitle("C) Le résultat"),
              _IntroBullet(
                text:
                    "Enquête négative OU présence de témoins (identifiés succinctement).",
              ),
              _IntroBullet(
                text:
                    "Mentionner un résumé du témoignage en style indirect (pas de verbatim ici).",
              ),
              _IntroBullet(
                text:
                    "Préciser qu’une convocation au service est faite pour audition ultérieure par procès-verbal, si nécessaire.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Objectif : que la lecture donne immédiatement « où / qui / quoi / résultat » sans ambiguïté.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "6 — Énonciation terminale (clôture)",
            cardColor: cardClose,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’indication de l’heure est facultative.\n\n"
                "La clôture doit rester simple et conforme à tes usages rédactionnels (fin d’opération, retour service, etc.).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "7 — Avis O.P.J.",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’agent de police judiciaire avise l’officier de police judiciaire de l’enquête de voisinage effectuée.",
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    "Préciser le mode (téléphone, radio, compte-rendu, mention au dossier) selon tes habitudes.",
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
