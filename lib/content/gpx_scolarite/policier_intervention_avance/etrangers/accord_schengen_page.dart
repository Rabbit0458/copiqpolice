import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AccordSchengenPage extends StatelessWidget {
  const AccordSchengenPage({super.key});

  static const String routeName = '/gpx/intervention/etrangers/schengen';

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
    final Color cardInfo = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCircu = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCoop = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardTools = isDark
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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
            "f00002",
            "Étrangers",
          ),
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
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
              "f00003",
              "L’accord de Schengen",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte (clair, sans répéter les titres)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
              "f00004",
              "Idée clé",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00005",
                      "La convention de Schengen repose sur la disparition des contrôles aux frontières intérieures ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00006",
                      "et le renforcement des frontières extérieures, afin d’assurer la sécurité dans un espace de libre circulation.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00007",
                  "Libre circulation : franchissement des frontières intérieures sans contrôle systématique des personnes.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00008",
                  "Sécurité : coordination renforcée aux frontières extérieures + coopération policière/judiciaire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Référence juridique en haut (cadre légal)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
              "f00009",
              "Référence juridique (cadre)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                    "f00010",
                    "En cas de rétablissement des contrôles : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                    "f00011",
                    "article L.332-3 du CESEDA",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                    "f00012",
                    " — le périmètre de contrôle est une zone comprise entre la frontière intérieure terrestre et une ligne tracée à 10 km en deçà.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00013",
                      "Dans ce périmètre, l’étranger contrôlé en situation irrégulière peut faire l’objet d’un refus d’entrée sur le territoire.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Libre circulation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
              "f00014",
              "I — Libre circulation des personnes",
            ),
            cardColor: cardCircu,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00015",
                  "A) Suppression des contrôles aux frontières intérieures",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00016",
                      "Les frontières intérieures correspondent aux frontières terrestres communes des États parties, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00017",
                      "ainsi qu’aux aéroports pour les vols intérieurs et aux ports maritimes pour les liaisons intérieures. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00018",
                      "Elles peuvent être franchies sans contrôle systématique des personnes.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00019",
                      "Cette libre circulation bénéficie à tous les individus, quelle que soit leur nationalité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00020",
                      "(ressortissants Schengen, UE ou pays tiers) ou leur statut.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00021",
                      "Certains territoires ne sont pas couverts par l’accord (ex. en France : Guadeloupe, Martinique, Réunion, Mayotte, Nouvelle-Calédonie, Polynésie française).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00022",
                  "B) Limites et points d’attention",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00023",
                  "Un État peut rétablir temporairement les contrôles pour ordre public / sécurité nationale (évènements prévisibles ou urgence).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00024",
                  "La suppression des contrôles ne fait pas obstacle aux contrôles d’identité ou de régularité du séjour sur l’ensemble du territoire.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00025",
                      "Déclaration d’entrée sur le territoire (D.E.T.) : ancienne obligation pour certains ressortissants de pays tiers lors du franchissement des frontières intérieures (en France, non exigée depuis 1998).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Frontières extérieures
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
              "f00026",
              "II — Frontières extérieures : contrôles coordonnés",
            ),
            cardColor: cardInfo,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00027",
                  "A) Contrôles aux points de passage autorisés",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00028",
                      "Avec la suppression des frontières intérieures, les contrôles sont reportés aux frontières extérieures ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00029",
                      "(terrestres, maritimes, aéroports et ports pour le trafic extra-Schengen). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00030",
                      "Le franchissement se fait aux points de passage autorisés et aux heures d’ouverture fixées.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00031",
                  "B) Politique commune des visas",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00032",
                      "Les États Schengen ont harmonisé la délivrance des visas pour les séjours de courte durée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00033",
                      "(n’excédant pas 3 mois). Les données d’identité/biométriques des demandeurs peuvent être vérifiées aux postes de contrôle.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00034",
                  "C) Demandeurs d’asile",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00035",
                  "La demande d’asile est traitée par un seul État de l’espace Schengen, en principe celui de l’entrée sur le territoire.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00036",
                  "D) Lutte contre l’immigration illégale",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00037",
                      "La convention vise l’harmonisation des politiques : règles communes d’éloignement, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00038",
                      "répression de l’aide à l’immigration irrégulière et mécanismes de rapatriement.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Mesures compensatoires : coopération
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
              "f00039",
              "III — Mesures compensatoires (sécurité)",
            ),
            cardColor: cardCoop,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00040",
                  "A) Coopération policière et judiciaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00041",
                      "La convention prévoit l’assistance entre services de police pour prévenir et constater les infractions, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00042",
                      "ainsi que la mise en commun des informations et la coordination de la lutte contre la criminalité (notamment via EUROPOL).",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00043",
                  "Observation transfrontalière : possibilité de poursuivre une filature sur le territoire d’un État voisin (conditions + infractions graves).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00044",
                  "Poursuite transfrontalière : possibilité, sous conditions, de poursuivre au-delà de la frontière sans autorisation préalable lorsque l’auteur prend la fuite.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — SIS / SIRENE
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
              "f00045",
              "IV — SIS & SIRENE : l’outil opérationnel",
            ),
            cardColor: cardTools,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00046",
                  "A) Le Système d’Information Schengen (SIS)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00047",
                      "Le SIS est une banque de données commune aux États Schengen, mise à jour en permanence. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00048",
                      "Il contient des signalements concernant des personnes (disparues, recherchées, surveillées) et des objets recherchés.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00049",
                  "Lors de l’interrogation d’un fichier (ex. FPR), la réponse nationale apparaît d’abord ; en cas de correspondance, la réponse Schengen s’affiche avec une conduite à tenir.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                  "f00050",
                  "B) Les bureaux SIRENE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00051",
                      "Les informations complémentaires et la coordination opérationnelle passent par les bureaux SIRENE. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00052",
                      "En France, le bureau SIRENE (policiers, gendarmes, douaniers, magistrats) apporte un soutien logistique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/accord_schengen_page.dart",
                      "f00053",
                      "aux utilisateurs 24h/24, 365 jours/an, pour l’exécution des conduites à tenir liées aux signalements.",
                    ),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color borderColor = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color bgColor = isDark
        ? const Color(0xFF26200F)
        : const Color(0xFFFFF8E1);

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
          children: [...bodySpans],
        ),
      ),
    );
  }
}
