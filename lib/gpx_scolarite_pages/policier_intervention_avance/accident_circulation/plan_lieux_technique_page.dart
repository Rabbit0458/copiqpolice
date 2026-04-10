import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlanLieuxTechniquePage extends StatelessWidget {
  const PlanLieuxTechniquePage({super.key});

  static const String routeName =
      '/gpx/intervention/accident-circulation/plan-lieux-technique';

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
    final Color cardTech = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMethod = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNota = isDark
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
          "Accident de circulation",
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
            "Techniques du plan des lieux",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / utilité
          _ConditionCard(
            title: "Pourquoi le croquis est essentiel",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Une procédure de constat d'accident gagne en pertinence si elle est accompagnée d’un croquis : "
                "il fait ressortir et éclaire les faits, et aide à déterminer le rôle et la responsabilité de chaque partie.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Un bon croquis devient un support fidèle du dossier, notamment lors d’une éventuelle reconstitution demandée par un magistrat.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ⚖️ Principe général (obligation)
          _ConditionCard(
            title: "I — Rappel du principe général",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph("Le croquis est obligatoire dans les cas suivants :"),
              SizedBox(height: 10),
              _BulletPoint(
                text: "Accident avec dommages corporels (blessures ou décès).",
              ),
              _BulletPoint(text: "Dégâts importants au domaine public."),
              _BulletPoint(text: "Transport de marchandises dangereuses."),
              _BulletPoint(
                text: "Implication d’un véhicule des forces armées alliées.",
              ),
              _BulletPoint(
                text:
                    "Implication d’un véhicule de l’État ou d’une collectivité publique (armée, police, équipement, département, etc.) "
                    "lorsque les dégâts matériels sont importants.",
              ),
              SizedBox(height: 12),
              _Paragraph(
                "Le croquis montre la position des véhicules, des corps, des traces et des indices par rapport aux lieux.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le croquis doit être réalisé à l’encre afin d’éviter toute falsification.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Communication du croquis
          _ConditionCard(
            title: "Communication du croquis",
            cardColor: cardNota,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Si une des parties se présente et demande à voir le croquis, il convient de ne pas le lui montrer.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Seul son conseil (assureur ou avocat) peut obtenir communication du dossier en faisant une demande à un magistrat.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Techniques du croquis (généralités)
          _ConditionCard(
            title: "II — Techniques du croquis",
            cardColor: cardTech,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) Généralités"),
              _Paragraph(
                "Pour exécuter un croquis, il est recommandé de respecter des règles de topographie : "
                "choisir des points fixes, coter les éléments utiles et utiliser des signes conventionnels "
                "pour une représentation schématique claire.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Points fixes + cotes
          _ConditionCard(
            title: "1) Points fixes & cotes (règles de base)",
            cardColor: cardTech,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Choix des points fixes"),
              const _Paragraph(
                "Les points fixes doivent être quasi définitifs et matérialisés sur le plan "
                "(ex : angle de mur, borne, pylône, plaque d’égout, numéro d’habitation, point kilométrique (PK), signalisation verticale…).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("Règle des cotes"),
              const _Paragraph(
                "Toute distance relevée est représentée par une cote : un trait plein avec une pointe de flèche à chaque extrémité. "
                "La valeur chiffrée est écrite horizontalement pour éviter de manipuler le plan.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "La mesure peut être inscrite sur le trait de cote ou en intervalle.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Prise de mesures : exigences incontournables"),
              const _BulletPoint(
                text:
                    "Relever 3 cotes obligatoires : elles ne se croisent jamais et ne croisent jamais l’élément à coter (ni un autre élément).",
              ),
              const _BulletPoint(
                text:
                    "Sur chaque élément à coter, retenir 2 points pour la prise de mesures (exemples ci-dessous).",
              ),
              const SizedBox(height: 10),
              const _SubTitle("Points de référence à retenir"),
              const _BulletPoint(
                text:
                    "Véhicule : avant / arrière, ou axe des roues, côté droit ou gauche (toujours le même côté sur la longueur).",
              ),
              const _BulletPoint(
                text: "Victime : sommet de la tête + talon ou pointe du pied.",
              ),
              const _BulletPoint(
                text:
                    "Deux-roues : axe de la roue avant + axe de la roue arrière.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: const [
                  TextSpan(
                    text:
                        "Pour un élément circulaire/cylindrique (plaque d’égout, poteau…), la cote part du centre : éviter une mesure sur tangente.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Signes conventionnels
          _ConditionCard(
            title: "2) Signes conventionnels (lecture immédiate)",
            cardColor: cardMethod,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les éléments du plan sont représentés avec des signes conventionnels. "
                "Pour les objets de petite taille (ex : casque, chapeau…), deux cotes suffisent.",
              ),
              SizedBox(height: 12),
              _SubTitle("Règles pratiques"),
              _BulletPoint(
                text:
                    "Les véhicules sont cotés (hors tout ou axe des roues) du même côté sur la longueur.",
              ),
              _BulletPoint(
                text:
                    "Une cote ne doit jamais être prise depuis une partie accidentée du véhicule.",
              ),
              _BulletPoint(
                text:
                    "Les traces de freinage : mesurer la longueur entre les deux extrémités.",
              ),
              _BulletPoint(
                text:
                    "Arbres, flaques de sang, débris de verre, taches d’huile : positionnés sans être cotés.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Relevé topo
          _ConditionCard(
            title: "B) Relevé topographique (le plan des lieux)",
            cardColor: cardTech,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Indépendant des faits, il présente la configuration des lieux : largeur des chaussées, accotements, directions, signalisation, orientation du plan.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "Agir simplement : privilégier la clarté et ne reporter que ce qui facilite la compréhension.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Le croquis est fait à l’échelle pour respecter les proportions.",
              ),
              _BulletPoint(
                text:
                    "Échelles courantes : 1/100 (1 m terrain = 1 cm plan) ou 1/200 (1 m terrain = 0,5 cm plan).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Positionnement véhicule
          _ConditionCard(
            title: "C) Positionnement d’un véhicule",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _SubTitle("1) Principe"),
              _Paragraph(
                "Le véhicule doit être positionné fidèlement tel qu’il est observé à l’arrivée sur les lieux. "
                "Il est repéré par 3 cotes ne traversant aucun élément du plan (véhicule, personne…).",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Si les véhicules ont été déplacés/enlevés avant l’arrivée : ne pas les dessiner. "
                        "Relever la topographie, les directions prises et surtout le point de choc présumé + tous les indices utiles (avant dégagement de la chaussée).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Méthodes
          _ConditionCard(
            title: "2) Méthodes de relevé des cotes",
            cardColor: cardMethod,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("Méthode 1 — Coordonnées directes"),
              _Paragraph(
                "Le véhicule est repéré avec 3 cotes prises à partir d’un même côté du véhicule, dont 2 issues d’un même point du véhicule. "
                "Nécessite 2 points fixes.",
              ),
              SizedBox(height: 12),
              _SubTitle("Méthode 2 — Coordonnées rectangulaires"),
              _Paragraph(
                "Le recoupement se fait par angles droits à partir d’un alignement fictif (prolongement de trottoir, façade d’immeuble, etc.). "
                "Une cote perpendiculaire est prise vers un angle du véhicule (P1/P2) ou l’axe des roues si l’angle est indéterminable.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Variante : création d’un point fictif O pour aérer le croquis (intersection d’alignements imaginaires).",
              ),
              _BulletPoint(
                text:
                    "Variante : création d’un point P plus proche (défini depuis un point fixe : entrée d’immeuble, bouche d’égout, PK…).",
              ),
              SizedBox(height: 12),
              _SubTitle("Méthode 3 — Méthode mixte"),
              _Paragraph(
                "Combinaison de points fixes et de coordonnées rectangulaires. "
                "C’est la méthode la plus utilisée : 2 cotes en rectangulaire + 1 cote depuis un point fixe.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Le positionnement de chaque élément (véhicule, victime, indices) peut être fait indifféremment par l’une des trois méthodes.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Légende
          _ConditionCard(
            title: "D) La légende (indispensable)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La légende conserve au plan sa simplicité et sa clarté : elle doit comporter l’échelle utilisée.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Les symboles du plan sont repérés par lettres (parties en cause) ou chiffres romains (points fixes).",
              ),
              _BulletPoint(
                text:
                    "Véhicule présumé responsable : lettre A (A’, A”, A1…). Autres : B, C…",
              ),
              _BulletPoint(
                text:
                    "Piéton : Y (Y’, Y” sens de marche). Plusieurs piétons : Y1, Y2…",
              ),
              _BulletPoint(text: "Témoin : T (T1, T2…)."),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Traces : sang lié à une victime → même lettre que la victime (si relation certaine), sinon lettre S. "
                        "Huile liée à un véhicule → lettre du véhicule, sinon lettre H.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Titre
          _ConditionCard(
            title: "E) Le titre (ce qu’il doit contenir)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Nature de l’accident : matériel / corporel / mortel (en ou hors agglomération).",
              ),
              _BulletPoint(text: "Date et heure des faits."),
              _BulletPoint(
                text:
                    "Lieu : intersection / numéro / PK… + commune + département.",
              ),
              _BulletPoint(
                text:
                    "Affaire : noms/prénoms des parties (le présumé responsable en premier).",
              ),
              _BulletPoint(
                text: "Conséquences : blessé(s), hospitalisation, identité.",
              ),
              _BulletPoint(text: "Numéro de procédure correspondant au plan."),
            ],
          ),

          const SizedBox(height: 14),

          // Photographies
          _ConditionCard(
            title: "F) Les photographies (en complément)",
            cardColor: cardNota,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En cas d’accident grave, les photographies complètent le plan des lieux et renforcent la compréhension du dossier.",
              ),
              SizedBox(height: 10),
              _Paragraph("Sont notamment photographiés :"),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "La chaussée (de part et d’autre du point de l’accident).",
              ),
              _BulletPoint(text: "L’intersection, si elle existe."),
              _BulletPoint(
                text: "Les véhicules accidentés (pour distinguer les dégâts).",
              ),
              _BulletPoint(
                text:
                    "Les traces (freinage, dérapage, ripage) en lien avec le véhicule / point de choc.",
              ),
              _BulletPoint(
                text: "Autres indices : terre, sang, objets, pièces détachées…",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Un album photographique est constitué et joint au plan des lieux.",
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
