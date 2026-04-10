import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequisitionsGeneralitesPage extends StatelessWidget {
  const RequisitionsGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/requisitions/generalites';

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
    final Color cardPQ = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardGen = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardNum = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInter = isDark
        ? const Color(0xFF1E2330)
        : const Color(0xFFF3F6FF);
    final Color cardMan = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);
    final Color cardBlood = isDark
        ? const Color(0xFF2D1F1F)
        : const Color(0xFFFFF3F3);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentIndigo = isDark
        ? const Color(0xFF9FA8DA)
        : const Color(0xFF283593);
    final Color accentRed = isDark
        ? const Color(0xFFEF9A9A)
        : const Color(0xFFC62828);

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
          "Réquisitions judiciaires",
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
            "Les réquisitions judiciaires — généralités",
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
                "La réquisition est un acte permettant à une autorité judiciaire d’exiger d’une personne "
                "l’accomplissement d’une prestation ou la remise d’informations utiles à l’enquête.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (bases principales)
          _ConditionCard(
            title: "Élément légal — textes de référence",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 60 et 77-1 du Code de procédure pénale (CPP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : réquisitions à personne qualifiée."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Articles 60-1 et 77-1-1 du Code de procédure pénale (CPP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : réquisitions générales (remise d’informations/documents).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Articles 57-1, 60-2, 60-3, 77-1-2, 97-1, 99-4 et 99-5 du Code de procédure pénale (CPP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : réquisitions informatiques et téléphoniques.",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 100-3 du Code de procédure pénale (CPP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : interceptions de correspondances (commission rogatoire).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 642-1 du Code pénal (CP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : réquisition à manœuvrier."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 3354-1 du Code de la santé publique (CSP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : réquisition à des fins de prélèvement sanguin.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // I — Personne qualifiée
          _ConditionCard(
            title: "I — Réquisition à personne qualifiée",
            cardColor: cardPQ,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 60 et 77-1 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’OPJ (ou sous son contrôle l’APJ / assistant d’enquête) peut recourir à toute personne "
                      "susceptible de réaliser des constatations ou examens techniques/scientifiques utiles à l’enquête.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "En enquête préliminaire : autorisation préalable du procureur de la République requise.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les personnes requises prêtent serment par écrit (« en leur honneur et conscience »). "
                        "Le serment figure en tête du rapport ou sur déclaration séparée, sauf si la personne est inscrite sur une liste d’experts.",
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: "(référence : article 157 du CPP)",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Peut ouvrir des scellés, replacer sous scellés et placer sous scellés les objets issus de l’examen (ex : prélèvements).",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Sur instructions du procureur : communication des résultats aux personnes mises en cause (indices) et aux victimes.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Générales
          _ConditionCard(
            title: "II — Réquisition générale",
            cardColor: cardGen,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Articles 60-1 et 77-1-1 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’OPJ (ou sous son contrôle l’APJ) peut requérir toute personne, établissement, organisme privé/public "
                      "ou administration susceptible de détenir des informations intéressant l’enquête, y compris issues de systèmes informatiques.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Remise possible sous forme numérique ; le secret professionnel ne peut être opposé sans motif légitime.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En enquête préliminaire : réquisition sur autorisation préalable du procureur de la République. ",
                ),
                TextSpan(
                  text: "(article 77-1-1 du CPP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le procureur peut aussi autoriser par « instructions générales » certaines réquisitions nécessaires à la vérité. "
                        "Durée maximale : 6 mois (renouvelables / modifiables / interrompues). "
                        "Le procureur doit être immédiatement avisé des réquisitions délivrées en application de ses instructions.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _SubTitle("Sanction (non-réponse)"),
              const _Paragraph(
                "Le fait de s’abstenir de répondre dans les meilleurs délais est puni d’une amende de 3 750 €.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Informatiques & téléphoniques
          _ConditionCard(
            title: "III — Réquisitions informatiques & téléphoniques",
            cardColor: cardNum,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      "Articles 57-1, 60-2, 60-3, 77-1-2, 97-1, 99-4 et 99-5 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : principales hypothèses."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("A) Accès / protection des données"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 57-1 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : requérir toute personne ayant connaissance des mesures de protection ou permettant l’accès aux données (perquisition).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("B) Remise d’informations par organismes"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 60-2 alinéa 1 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : requérir des organismes publics / personnes morales de droit privé détenant des informations utiles (sauf secret prévu par la loi).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "En enquête préliminaire : "),
                TextSpan(
                  text: "article 77-1-2 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " → autorisation préalable du procureur."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("C) Préservation de données (opérateurs)"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 60-2 alinéa 2 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : sur réquisition du procureur après autorisation du JLD, imposer aux opérateurs de préserver certaines données (max. 1 an).",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("D) Ouverture de scellés / copies"),
              _Paragraph.rich([
                TextSpan(
                  text: "Article 60-3 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : requérir une personne qualifiée pour ouvrir des scellés supports de données, copier/exploiter sans altérer l’intégrité.",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Sanction (refus non légitime)"),
              const _Paragraph(
                "Le refus de répondre sans motif légitime à ces réquisitions est puni d’une amende de 3 750 €.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Interceptions (CR)
          _ConditionCard(
            title:
                "IV — Interceptions de correspondances (commission rogatoire)",
            cardColor: cardInter,
            accent: accentIndigo,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article 100-3 du CPP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : en commission rogatoire, l’OPJ (ou sous son contrôle l’APJ) peut requérir un agent qualifié "
                      "pour installer un dispositif d’interception (service sous tutelle ou exploitant/fournisseur autorisé).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Cette réquisition est liée à un cadre judiciaire spécifique (commission rogatoire) : rigueur maximale sur la trace et l’autorisation.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // V — Manœuvrier
          _ConditionCard(
            title: "V — Réquisition à manœuvrier",
            cardColor: cardMan,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 642-1 du Code pénal (CP)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : l’APJ, dans l’exercice de ses fonctions, peut requérir toute personne susceptible de fournir "
                      "une prestation utile (ex : serrurier) en cas d’atteinte à l’ordre public, sinistre, ou danger.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "La personne requise ne concourt pas directement à la manifestation de la vérité et ne réalise pas d’examen technique/scientifique.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Pas d’obligation de prêter serment."),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le refus ou la négligence sans motif légitime est puni de l’amende des contraventions de 2ᵉ classe.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // VI — Prélèvement sanguin
          _ConditionCard(
            title: "VI — Réquisition pour prélèvement sanguin",
            cardColor: cardBlood,
            accent: accentRed,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L. 3354-1 du CSP",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : en cas de crime/délit/accident de circulation, les OPJ/APJ doivent faire procéder aux vérifications "
                      "pour déterminer la présence d’alcool (obligatoires si mort).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Vérifications prévues par "),
                TextSpan(
                  text: "l’article L. 234-4 du Code de la route (CR)",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Peuvent être effectuées sur l’auteur présumé et, si utile, sur la victime.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Moyens : analyses/examens médicaux, cliniques, biologiques, ou éthylomètre (air expiré).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "À cette fin, l’OPJ/APJ peut requérir : médecin, interne, étudiant autorisé remplaçant, ou infirmier pour la prise de sang.",
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: "(article L. 234-4 du Code de la route)",
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
