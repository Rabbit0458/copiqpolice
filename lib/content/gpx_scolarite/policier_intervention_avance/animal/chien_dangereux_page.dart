import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ChienDangereuxPage extends StatelessWidget {
  const ChienDangereuxPage({super.key});

  static const String routeName = '/gpx/intervention/animal/chien-dangereux';

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
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Animal",
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
            ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00002",
              "Intervenir face à un chien dangereux",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00003",
              "De quoi s’agit-il ?",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00004",
                      "Au cours de leurs missions, les policiers peuvent avoir à gérer des situations impliquant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00005",
                      "des individus accompagnés d’un chien. L’objectif est d’identifier rapidement les risques ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00006",
                      "et d’adopter les bons réflexes face à un chien agressif.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément “légal” en haut (cadre général : nécessité / usage de la force)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00007",
              "I — Cadre légal (principes)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                    "f00008",
                    "En situation d’urgence, l’intervention peut être justifiée par l’état de nécessité : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                    "f00009",
                    "article 122-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00010",
                      "L’usage de la force doit rester strictement proportionné et adapté à la menace. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00011",
                      "En cas d’attaque caractérisée et de danger immédiat, des moyens de neutralisation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00012",
                      "peuvent être envisagés (selon les règles d’emploi et la situation).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Ce qu’il faut savoir
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00013",
              "II — Ce qu’il faut savoir",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00014",
                  "Un chien peut être dangereux même muselé : il peut griffer, mordre/pincer, ou percuter et provoquer hématomes, fractures, hémorragies internes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00015",
                  "Une attaque peut survenir en instinct (intrusion perçue) ou sur ordre du maître.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00016",
                  "À courte distance (≈ 10 mètres), l’animal peut considérer la présence humaine comme une intrusion dans l’espace du maître.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Signaux annonciateurs
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00017",
              "III — Signaux annonciateurs d’une attaque",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00018",
                  "Certains signaux peuvent précéder une attaque (variables selon races) :",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00019",
                  "Animal immobile, corps tendu, tête en avant, yeux dilatés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00020",
                  "Oreilles droites ou couchées, babines supérieures retroussées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00021",
                  "Queue dirigée vers le haut, poils du dos hérissés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00022",
                  "Grognements et/ou aboiements.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bons réflexes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00023",
              "IV — Bons réflexes face à un chien hostile",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00024",
                  "A) Priorité sécurité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00025",
                  "Recourir chaque fois que possible à l’assistance d’une unité cynotechnique.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00026",
                  "Adopter une attitude calme : éviter gestes brusques, ne pas crier ni hurler.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00027",
                  "Ne pas fixer le chien : le regarder en biais.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00028",
                  "B) Réduire la perception de menace",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00029",
                  "Ôter les éléments pouvant être perçus comme menaçants : casquette, lunettes de soleil, tour de cou relevé masquant le visage.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00030",
                  "C) Gestion de l’espace",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00031",
                  "Ne jamais fuir en courant devant un chien.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00032",
                  "Ne jamais empêcher un chien de s’enfuir.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00033",
                  "Interposer un obstacle (mobilier, containers, barrière, porte) entre soi et le chien.",
                ),
              ),
              _NotaBox(
                title: "Astuce",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00034",
                      "Le chien a tendance à mordre ce qu’on lui présente : sac, porte-document, objet tenu à distance.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Neutralisation / moyens
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00035",
              "V — Neutralisation (si attaque caractérisée)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00036",
                      "Dès lors que l’attaque est caractérisée, l’usage de moyens de neutralisation peut être envisagé ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00037",
                      "(selon les règles et la situation) : lanceur de balles de défense, pistolet à impulsions électriques. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00038",
                      "L’usage de l’arme de service peut se justifier en cas d’absolue nécessité.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Protection en cas d’impossibilité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00039",
              "VI — Si l’attaque ne peut être évitée",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00040",
                  "Protéger les zones sensibles : opposer l’avant-bras côté main faible avec un vêtement/ protection improvisée (BTD, tonfa…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00041",
                  "En cas de morsure maintenue : ne pas dégager brusquement la partie mordue.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00042",
                  "Attraper le chien par le collier pour tenter de le suspendre et l’asphyxier (si possible et sécurisé).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                      "f00043",
                      "Éviter l’usage d’aérosols lacrymogènes : généralement inopérants sur le chien et incapacitants pour les intervenants.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Interpellation d’un maître avec chien
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00044",
              "VII — Interpeller un individu accompagné d’un chien",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00045",
                  "Obtenir si possible que l’animal soit muselé et attaché à un point fixe.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00046",
                  "Ne procéder à la palpation ou au menottage que si le chien est séparé de son maître.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00047",
                  "Si danger réel ou environnement défavorable : différer l’intervention pour éviter une exposition inutile.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // En résumé
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
              "f00048",
              "En résumé",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00049",
                  "En présence d’un chien agressif/potentiellement dangereux : solliciter si possible une unité cynotechnique.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00050",
                  "Rester calme, éviter la provocation, utiliser obstacles et protection.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/animal/chien_dangereux_page.dart",
                  "f00051",
                  "En cas de morsure/griffure : consulter immédiatement les urgences et, si possible, récupérer l’animal pour examen vétérinaire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
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
