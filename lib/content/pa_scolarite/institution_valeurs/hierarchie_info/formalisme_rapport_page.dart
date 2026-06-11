import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaFormalismeRapportPage extends StatelessWidget {
  const PaFormalismeRapportPage({super.key});

  static const String routeName =
      '/pa/institution/hierarchie_info/formalisme_rapport';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Hiérarchie & information",
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
            "Le formalisme du rapport",
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
                "Le rapport est un compte-rendu adressé à l’autorité hiérarchique dans le but "
                "de l’informer de tout fait ou incident à caractère personnel ou se rapportant "
                "à l’exécution du service, et des circonstances dans lesquelles ils se sont produits.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (textes cités)
          _ConditionCard(
            title: "I — Le formalisme (cadre de référence)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Les seuls textes relatifs au rapport, de façon presque incidente, sont : ",
                ),
                TextSpan(
                  text:
                      "articles D. 14-1, 430 et 537 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      ". Ces dispositions sont muettes quant au formalisme : celui-ci découle donc de la pratique, de circulaires et du bon sens.",
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Objectif : produire un document exploitable, lisible et immédiatement compréhensible par la hiérarchie.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // A. En-tête
          _ConditionCard(
            title: "A — L’en-tête du rapport",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph("Le rapport est établi sur un modèle comportant :"),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "En haut à gauche : logo du Ministère de l’Intérieur + identification de la direction d’emploi et du service (ex. commissariat / SDPJ…).",
              ),
              _BulletPoint(
                text:
                    "En haut à droite : logo Police nationale + lieu et date de rédaction du rapport.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le lieu indiqué à l’en-tête est celui de la rédaction (pas celui de la constatation des faits). La rédaction peut être différée.",
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),

          const SizedBox(height: 14),

          // En-tête (suite) : identité rédacteur + destinataire
          _ConditionCard(
            title: "À faire figurer après l’en-tête",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph("Doivent ensuite apparaître :"),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Qualité administrative (grade), matricule, nom et prénom du rédacteur.",
              ),
              _BulletPoint(
                text: "Service d’appartenance (unité, section…).",
              ),
              _BulletPoint(
                text: "Destinataire (supérieur hiérarchique direct).",
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "Conformément à "),
                TextSpan(
                  text: "l’article D. 14-1 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      ", le destinataire est le supérieur hiérarchique direct du rédacteur. Si un autre destinataire est visé : mentionner « sous couvert de la voie hiérarchique ».",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(text: "À la différence du procès-verbal ("),
                TextSpan(
                  text: "article 66 du Code de procédure pénale",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      "), le rapport n’est pas réputé établi « dans le même trait de temps » que les opérations.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // B. Mentions obligatoires
          _ConditionCard(
            title: "B — Mentions obligatoires (1ʳᵉ page)",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La première page doit comporter des mentions obligatoires, qui varient selon que le rapport est "
                "de type administratif ou judiciaire. On retient quatre mentions principales :",
              ),
              SizedBox(height: 10),
              _IntroBullet(text: "L’objet"),
              _IntroBullet(text: "L’affaire (si rapport judiciaire)"),
              _IntroBullet(text: "La référence"),
              _IntroBullet(text: "Les pièces jointes"),
            ],
          ),

          const SizedBox(height: 14),

          // Détail des mentions
          _ConditionCard(
            title: "Détail des mentions",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("1) L’objet"),
              _Paragraph(
                "L’objet résume en quelques mots précis le corps du rapport.\n"
                "• Administratif : ex. demande d’absence exceptionnelle, demande de fermeture administrative…\n"
                "• Judiciaire : résume la nature des faits, le lieu et la date de commission.",
              ),
              SizedBox(height: 12),
              _SubTitle("2) L’affaire (rapport judiciaire)"),
              _Paragraph(
                "Indique la « petite identité » de l’individu objet du rapport :\n"
                "• ex. C/ Albert M… (qualité, naissance, domicile) ou C/ X…",
              ),
              SizedBox(height: 12),
              _SubTitle("3) La référence"),
              _Paragraph(
                "Rappelle les instructions verbales/écrites auxquelles le rapport se réfère.\n"
                "En pratique : indiquer la date et le numéro d’enregistrement de la pièce visée.",
              ),
              SizedBox(height: 12),
              _SubTitle("4) Les pièces jointes"),
              _Paragraph(
                "Récapitule les documents à joindre au rapport (annexes, copies, justificatifs…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // C. Préambule
          _ConditionCard(
            title: "C — Le préambule",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le préambule est une formule stéréotypée, par exemple :\n"
                "• « J’ai l’honneur de vous rendre compte des faits suivants… »\n"
                "• « J’ai l’honneur de vous rendre compte de l’enquête diligentée conformément à vos instructions… »\n"
                "• « J’ai l’honneur de solliciter de votre bienveillance… »",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Rigueur : l’unicité du rédacteur est de rigueur. Les autres intervenants sont mentionnés dans le préambule ou dans le corps du rapport.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // D. Corps
          _ConditionCard(
            title: "D — Le corps du rapport",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le rédacteur relate :\n"
                "• ce qu’il a vu, entendu ou constaté ;\n"
                "• ce qu’il a fait ;\n"
                "• les mesures prises ;\n"
                "• les diligences effectuées et leur résultat.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // E. Signature / destinataires
          _ConditionCard(
            title: "E — Signature & destinataires",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le rédacteur signe le rapport à droite, sous la dernière phrase, "
                "après mention de sa qualité administrative (grade).\n\n"
                "Une rubrique « destinataires » peut être ajoutée en bas à gauche du dernier feuillet, après la signature.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // F. Présentation / style
          _ConditionCard(
            title: "F — Présentation & style",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph("Une présentation correcte dépend notamment de :"),
              SizedBox(height: 10),
              _BulletPoint(text: "Une mise en page aérée."),
              _BulletPoint(
                text: "Une orthographe et une ponctuation correctes.",
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Règles de rédaction :\n"
                "• Rédaction au passé (passé composé ou imparfait).\n"
                "• Style impersonnel (éviter « nous »).\n"
                "• Dans certains cas : rédaction à la première personne « je » (ex. rapport d’autorisation d’absence).\n\n"
                "Éviter les phrases interminables : le rapport doit être clair, précis et concis.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse
          _ConditionCard(
            title: "En résumé",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Un rapport = informer la hiérarchie de faits/incidents et des circonstances.",
              ),
              _BulletPoint(
                text:
                    "Respecter une structure : en-tête, mentions obligatoires, préambule, corps, signature.",
              ),
              _BulletPoint(
                text:
                    "Références : D. 14-1, 430, 537 CPP ; distinction PV/rapport (art. 66 CPP).",
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
