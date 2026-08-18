import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PVVictimeViolencesConjugalesPage extends StatelessWidget {
  const PVVictimeViolencesConjugalesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/plainte/violences_conjugales/pv_victime';

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
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDocs = isDark
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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
            "f00002",
            "Violences conjugales",
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
              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
              "f00003",
              "Canevas & PV de plainte d’une victime de violences conjugales",
            ),
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
            title: "Objectif",
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00004",
                      "Cette page regroupe un canevas opérationnel et des modèles de procès-verbaux utiles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00005",
                      "pour la prise de plainte d’une victime de violences conjugales. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00006",
                      "Le but : une procédure claire, chronologique, exploitable, et une prise en charge adaptée.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (articles en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00008",
                    "Obligation de recevoir les plaintes — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00009",
                    "article 15-3 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00010",
                    "Information des droits des victimes — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00011",
                    "article 10-2 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00012",
                    "Récépissé / copie sur demande — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00013",
                    "article 15-3 alinéa 2 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                          "f00014",
                          "Selon la situation, préciser le cadre juridique : enquête de flagrance ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                          "f00015",
                          "(articles 53 et suivants) ou enquête préliminaire (articles 75 et suivants).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Canevas (pratique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
              "f00016",
              "II — Canevas (prise de plainte)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00017",
                  "1) Accueil & confidentialité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00018",
                  "Installer la victime dans un lieu calme, confidentiel et sécurisant, dans la mesure du possible.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00019",
                  "Autoriser qu’elle soit accompagnée (si elle le souhaite), tout en veillant à la liberté de parole.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00020",
                  "2) Recueil du récit",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00021",
                  "Commencer par un récit libre, puis questions ouvertes (ne jamais suggérer).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00022",
                  "Faire ressortir : chronologie, fréquence, contexte, menaces, témoins, preuves, blessures, retentissement psychologique.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00023",
                  "3) Points essentiels à qualifier",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00024",
                  "Lien victime/auteur : conjoint, ex-conjoint, concubin, ex-concubin, partenaire PACS, ex-partenaire…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00025",
                  "Caractéristiques : violences physiques / sexuelles / psychologiques / verbales / économiques, contrôle, harcèlement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00026",
                  "Présence d’enfants, grossesse, isolement, dépendance financière, armes, addictions, antécédents.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00027",
                  "4) Diligences",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00028",
                  "Selon le contexte : avis OPJ / parquet, réquisition médicale, clichés, consultation fichiers (TAJ, FPR, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00029",
                  "Proposer / organiser la mise en sécurité (proche, foyer, 115, dispositifs locaux).",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00030",
                  "5) Clôture",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00031",
                  "Lecture + signature. Mentionner tout refus (ITT, mise en sécurité, etc.) en procédure.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Élément moral (pédagogique, sans inventer l’infraction précise)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
              "f00032",
              "III — Élément moral (rappel)",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00033",
                      "Pour la plupart des infractions, l’élément moral correspond à la volonté de commettre les faits ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00034",
                      "(intention), ou à la conscience de l’acte et de ses conséquences. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00035",
                      "En matière de violences au sein du couple, l’analyse s’appuie sur les déclarations, le contexte, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00036",
                      "la répétition, les menaces, le contrôle, et tout élément objectif (messages, témoins, certificats…).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Circonstances aggravantes (générique + visuel)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
              "f00037",
              "IV — Circonstances aggravantes (à rechercher)",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00038",
                  "Lien conjugal / ex-conjugal / concubinage / PACS (cadre violences conjugales).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00039",
                  "Présence de mineurs, violences en leur présence, menaces envers eux.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00040",
                  "Usage ou détention d’arme, alcool/drogues, escalade de fréquence ou de gravité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00041",
                  "Vulnérabilité particulière de la victime (grossesse, handicap, isolement, dépendance).",
                ),
              ),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                          "f00042",
                          "Ces éléments orientent la qualification et les mesures de protection (TGD, ordonnance de protection, etc.) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                          "f00043",
                          "selon les consignes locales et l’autorité judiciaire.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // V — Tentative & complicité (générique, sans copyWith)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
              "f00044",
              "V — Tentative & complicité (rappel)",
            ),
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle("Tentative"),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00045",
                      "La tentative est punissable lorsqu’un commencement d’exécution a eu lieu et que l’infraction ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00046",
                      "n’a pas été consommée en raison de circonstances indépendantes de la volonté de l’auteur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00047",
                      "(selon la qualification retenue).",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00048",
                  "Complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00049",
                    "La complicité est réprimée par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00050",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00051",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                    "f00052",
                    " (aide/assistance, provocation, instructions…).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // VI — Modèles (images)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
              "f00053",
              "VI — Modèles & canevas (images)",
            ),
            cardColor: cardDocs,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                  "f00054",
                  "Appuie sur l’image pour l’ouvrir en plein écran. Tu peux zoomer et tourner.",
                ),
              ),
              SizedBox(height: 10),

              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif1.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif2.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif3.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif4.png'),
              SizedBox(height: 12),
              _ZoomRotateImage(assetPath: 'assets/images/pv_canva_vif5.png'),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///  Image : zoom + rotation + plein écran + anti-overflow (Row scrollable)
///////////////////////////////////////////////////////////////////////////////

class _ZoomRotateImage extends StatefulWidget {
  const _ZoomRotateImage({required this.assetPath});

  final String assetPath;

  @override
  State<_ZoomRotateImage> createState() => _ZoomRotateImageState();
}

class _ZoomRotateImageState extends State<_ZoomRotateImage> {
  int _quarterTurns = 0;

  void _rotateLeft() => setState(() => _quarterTurns = (_quarterTurns - 1) % 4);
  void _rotateRight() =>
      setState(() => _quarterTurns = (_quarterTurns + 1) % 4);
  void _reset() => setState(() => _quarterTurns = 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color border = isDark
        ? Colors.white.withValues(alpha: .18)
        : Colors.black.withValues(alpha: .10);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: .18)
                  : Colors.black12,
              border: Border(bottom: BorderSide(color: border, width: 1)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _rotateLeft,
                    tooltip: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00055",
                      'Tourner à gauche',
                    ),
                    icon: const Icon(Icons.rotate_left_rounded),
                  ),
                  IconButton(
                    onPressed: _rotateRight,
                    tooltip: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                      "f00056",
                      'Tourner à droite',
                    ),
                    icon: const Icon(Icons.rotate_right_rounded),
                  ),
                  const SizedBox(width: 6),
                  TextButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                        "f00057",
                        "Réinitialiser",
                      ),
                      style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 6),
                  TextButton.icon(
                    onPressed: () => _openFullscreen(context),
                    icon: const Icon(Icons.fullscreen_rounded),
                    label: Text(
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                        "f00058",
                        "Plein écran",
                      ),
                      style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 6,
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(80),
              child: Center(
                child: RotatedBox(
                  quarterTurns: _quarterTurns,
                  child: Image.asset(widget.assetPath, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    int turns = _quarterTurns;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .92),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(12),
              backgroundColor: Colors.transparent,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () =>
                                setLocalState(() => turns = (turns - 1) % 4),
                            tooltip: ScolariteText.value(
                              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                              "f00059",
                              'Tourner à gauche',
                            ),
                            icon: const Icon(
                              Icons.rotate_left_rounded,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setLocalState(() => turns = (turns + 1) % 4),
                            tooltip: ScolariteText.value(
                              "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                              "f00060",
                              'Tourner à droite',
                            ),
                            icon: const Icon(
                              Icons.rotate_right_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          TextButton.icon(
                            onPressed: () => setLocalState(() => turns = 0),
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              ScolariteText.value(
                                "lib/content/gpx_scolarite/pv_apj20/plainte/pv_victime_violences_conjugales_page.dart",
                                "f00061",
                                "Réinitialiser",
                              ),
                              style: GoogleFonts.fustat(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            tooltip: 'Fermer',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 10,
                      panEnabled: true,
                      boundaryMargin: const EdgeInsets.all(200),
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: turns,
                          child: Image.asset(
                            widget.assetPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() => _quarterTurns = turns);
    });
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
