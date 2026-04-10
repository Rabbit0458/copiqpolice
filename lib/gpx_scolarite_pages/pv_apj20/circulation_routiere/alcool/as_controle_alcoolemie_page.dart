import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AsControleAlcoolemiePage extends StatelessWidget {
  const AsControleAlcoolemiePage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/circulation_routiere/alcool/generalites';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardFacts = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardModal = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
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
          "Alcoolémie",
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
            "Cas de contrôle de l’alcoolémie",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro (objectif pédagogique)
          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Synthèse opérationnelle des cas de contrôle de l’alcoolémie : "
                "quand le contrôle est obligatoire, facultatif ou préventif, "
                "et quelles vérifications peuvent être réalisées.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (obligatoire)
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: "Article L.234-3 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : fixe les hypothèses de contrôle (notamment après accident corporel et certaines infractions entraînant S.P.C.).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: "Article L.234-9 du Code de la route",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : prévoit le contrôle préventif (instructions du procureur / initiative O.P.J. ou A.P.J.), sans infraction préalable nécessaire.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les vérifications destinées à établir la preuve de la présence d’alcool dans l’organisme peuvent aussi être réalisées dans les cas prévus par ",
                  ),
                  TextSpan(
                    text: "l’article L.3354-1 du Code de la santé publique",
                    style: const TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: ". "),
                  const TextSpan(
                    text:
                        "Un dépistage préalable peut être effectué (loi n°70-597 du 09/07/1970 – art.3).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I/ Faits constatés (table “propre” en cartes)
          _ConditionCard(
            title: "II — Cas de contrôle (faits constatés)",
            cardColor: cardFacts,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Contrôle OBLIGATOIRE"),
              _Paragraph.rich([
                TextSpan(
                  text: "C.R. — Article L.234-3 alinéa 1",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " : accident corporel de la circulation."),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Personnes concernées : conducteur ou accompagnateur d’un élève conducteur.",
              ),
              const _BulletPoint(
                text:
                    "Condition : être en présence des conducteurs/accompagnateurs impliqués dans l’accident, ou de l’auteur présumé de l’infraction.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Modalités : vérifications sans dépistage préalable OU dépistage puis vérifications le cas échéant.",
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "B) Contrôle OBLIGATOIRE (infractions entraînant S.P.C.)",
              ),
              _Paragraph.rich([
                TextSpan(
                  text: "C.R. — Article L.234-3 alinéa 2",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : infractions au code de la route entraînant S.P.C. (ex : excès de vitesse ≥ 30 km/h, C.E.I.).",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Modalités : dépistage puis vérifications le cas échéant.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Contrôle FACULTATIF"),
              _Paragraph.rich([
                TextSpan(
                  text: "C.R. — Article L.234-3 alinéa 2",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text: " : toutes les autres infractions au code de la route.",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Modalités : dépistage puis vérifications le cas échéant.",
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Contrôle PRÉVENTIF"),
              _Paragraph.rich([
                TextSpan(
                  text: "C.R. — Article L.234-9",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(
                  text:
                      " : instructions du procureur ou initiative de l’O.P.J./A.P.J. (aucune infraction préalable nécessaire).",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Modalités : dépistage puis vérifications le cas échéant.",
              ),
              const _BulletPoint(
                text:
                    "OU vérifications sans dépistage préalable uniquement si réalisées immédiatement et sur les lieux (ex : éthylomètre embarqué).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Personnes / conditions complémentaires (bloc très pédagogique)
          _ConditionCard(
            title: "III — Personnes concernées & conditions",
            cardColor: cardModal,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Faits ouvrant la possibilité de vérifications",
              ),
              const _IntroBullet(text: "Accident de la circulation"),
              const _IntroBullet(text: "Crime"),
              const _IntroBullet(text: "Délit"),
              const SizedBox(height: 10),
              const _SubTitle("B) Qui peut être contrôlé ? (auteur présumé)"),
              const _BulletPoint(
                text: "Conducteur de véhicule soumis au Code de la route.",
              ),
              _BulletPoint(
                text:
                    "Conducteur de véhicule non soumis au Code de la route (train, tramway — R.110-3 et R.422-3 C.R.).",
              ),
              const _BulletPoint(
                text:
                    "Autre personne : piéton, cavalier, conducteur de troupeaux, conducteur d’un bateau ou membre d’équipage participant à la conduite/manœuvre/exploitation, responsable(s) d’un accident du travail, auteur de violences, etc.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Conditions pratiques"),
              const _BulletPoint(
                text:
                    "Être en présence d’un mis en cause dont le comportement extérieur laisse présumer un état alcoolique au moment des faits.",
              ),
              const _BulletPoint(
                text:
                    "Être en présence d’un mort : vérifications possibles même sans présomption d’alcoolémie.",
              ),
              const _BulletPoint(
                text:
                    "Victime(s) : si les vérifications paraissent utiles à l’administration de la preuve.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Modalités / procédure (éthylomètre + prélèvement sanguin)
          _ConditionCard(
            title: "IV — Nature & modalités des vérifications",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Principe : privilégier l’éthylomètre"),
              const _Paragraph(
                "Le choix du mode de vérifications revient exclusivement aux policiers intervenants, "
                "qui doivent privilégier l’utilisation de l’éthylomètre. "
                "La valeur juridique des mesures par éthylomètre est équivalente à celle d’une analyse sanguine.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Quand recourir au prélèvement sanguin ?"),
              const _BulletPoint(text: "Éthylomètre en panne ou indisponible."),
              const _BulletPoint(
                text:
                    "Conducteur gravement blessé (sauf contre-indication médicale) ou décédé.",
              ),
              const _BulletPoint(
                text: "Handicap / incapacité physique attestée par un médecin.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Dépistage impossible ou refus"),
              const _BulletPoint(
                text:
                    "Dépistage impossible : conducteur gravement blessé/décédé/incapacité physique attestée.",
              ),
              const _BulletPoint(
                text:
                    "Refus de dépistage : conducteur ou accompagnateur d’un élève conducteur (quel que soit le cas de contrôle).",
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) Réquisitions médicales & formalités"),
              const _Paragraph(
                "Réquisition d’un médecin (ou à défaut : interne/étudiant autorisé, ou infirmier). "
                "Deux échantillons de sang sont prélevés, avec examen clinique.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Fiche A renseignée par le policier."),
              const _BulletPoint(text: "Fiche B-C renseignée par le médecin."),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Circuit d’analyse",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Envoi au laboratoire/biologiste expert : 1 échantillon + 4 exemplaires des fiches A et B-C. "
                        "Le 2e échantillon + 1 exemplaire des fiches A et B-C sont envoyés à un autre laboratoire pour une éventuelle analyse de contrôle.",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const _SubTitle("E) Notification du taux & marge d’erreur"),
              const _Paragraph(
                "Doivent être notifiés à l’intéressé :\n"
                "• le taux affiché (mg/l)\n"
                "• le taux retenu après soustraction de la marge d’erreur (mg/l) :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Taux affiché < 0,40 mg/l → soustraire 0,032 mg/l.",
              ),
              const _BulletPoint(
                text: "Taux affiché entre 0,40 mg/l et 2 mg/l → soustraire 8%.",
              ),
              const _BulletPoint(
                text: "Taux affiché > 2 mg/l → soustraire 30%.",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "Référence pratique : application CONVERTAUX via NEO.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Qualification selon seuils (contrav/délit) — rendu net
          _ConditionCard(
            title: "V — Seuils & qualification (rappel)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Contravention"),
              const _BulletPoint(
                text:
                    "≥ 0,10 et < 0,40 mg/l air expiré (ou ≥ 0,20 et < 0,80 g/l sang) : transport en commun, EAD, permis probatoire, apprentissage → contravention.",
              ),
              const _BulletPoint(
                text:
                    "≥ 0,25 et < 0,40 mg/l air expiré (ou ≥ 0,50 et < 0,80 g/l sang) : autre conducteur ou accompagnateur d’un élève conducteur → contravention.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Délit"),
              const _BulletPoint(
                text:
                    "≥ 0,40 mg/l air expiré (ou ≥ 0,80 g/l sang) : tout conducteur ou accompagnateur d’un élève conducteur → délit.",
              ),
              const SizedBox(height: 10),
              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si C.E.I. : penser à constater les deux délits (selon la situation).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité (comme tu l’exiges)
          _ConditionCard(
            title: "VI — Tentative & complicité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Tentative"),
              const _Paragraph(
                "Non applicable ici : il s’agit d’un régime de contrôle et de constatations (pas une infraction autonome).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Complicité"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "En matière d’infractions liées à l’alcool au volant : la complicité peut être retenue selon le droit commun, conformément à ",
                ),
                TextSpan(
                  text: "l’article 121-6 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: " et "),
                TextSpan(
                  text: "l’article 121-7 du Code pénal",
                  style: const TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 18),
          _ConditionCard(
            title: "Source",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Recueil de PV / Retour Sommaire — mise à jour : 16/07/2024.",
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
