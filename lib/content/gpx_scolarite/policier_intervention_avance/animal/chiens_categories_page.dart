import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ChiensCategoriesPage extends StatefulWidget {
  const ChiensCategoriesPage({super.key});

  static const String routeName = '/gpx/intervention/animal/chiens-categories';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  State<ChiensCategoriesPage> createState() => _ChiensCategoriesPageState();
}

class _ChiensCategoriesPageState extends State<ChiensCategoriesPage> {
  double _rotationTurns = 0.0; // 0.0 = 0°, 0.25 = 90°, 0.5 = 180°, etc.

  TextSpan _law(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        color: ChiensCategoriesPage._lawRed,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardCat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardObl = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardLieux = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfra = isDark
        ? const Color(0xFF26201A)
        : const Color(0xFFFFF3E0);
    final Color cardImg = isDark
        ? const Color(0xFF1F2B34)
        : const Color(0xFFEFF7FF);

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
    final Color accentOrange = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFEF6C00);
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
          tooltip: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00001", 'Retour'),
        ),
        title: Text(
          ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00002", "Intervention — Animal"),
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
            ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00003", "Chiens d’attaque, de garde ou de défense"),
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
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00004", "Définition"),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
               _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00005", "Le Code rural classe certains chiens considérés comme les plus dangereux en deux catégories : "),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00006", "1ʳᵉ catégorie (chiens d’attaque) "),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "et "),
                TextSpan(
                  text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00007", "2ᵉ catégorie (chiens de garde ou de défense)."),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                 TextSpan(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00008", "Cadre juridique : ")),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00009", "articles L. 211-12 et suivants du C.R.P.M.")),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00010", "I — Élément légal"),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00011", "Articles L. 211-12 et suivants du C.R.P.M.")),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00012", " : fondent la classification des chiens dangereux et les règles particulières applicables à leur détention."),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00013", "Article L. 211-13 du C.R.P.M.")),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00014", " : fixe les personnes interdites de détention (mineurs, tutelle sans autorisation, condamnations, retrait de garde…)."),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00015", "Articles L. 211-14 et R. 215-2 du C.R.P.M.")),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00016", " : encadrent le permis de détention et les documents à présenter aux forces de l’ordre."),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00017", "Article L. 211-16 du C.R.P.M.")),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00018", " : règles de présence des chiens de 1ʳᵉ / 2ᵉ catégorie dans les lieux (transports, lieux publics, parties communes…)."),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Image (zoom + rotation)
          _ConditionCard(
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00019", "Schéma d’identification (zoom + rotation)"),
            cardColor: cardImg,
            accent: accentBlue,
            titleColor: textMain,
            children: [
               _Paragraph(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00020", "Astuce : pince pour zoomer, glisse pour déplacer. ") + ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00021", "Tu peux aussi tourner l’image pour lire le tableau facilement."),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _rotationTurns -= 0.25; // -90°
                        });
                      },
                      icon: const Icon(Icons.rotate_left_rounded),
                      label: const Text("Tourner"),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: isDark
                            ? const Color(0xFF0F2A3A)
                            : const Color(0xFFE3F2FD),
                        foregroundColor: textMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _rotationTurns = 0.0; // reset
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label:  Text(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00022", "Réinitialiser")),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: isDark
                            ? const Color(0xFF2B2B2B)
                            : const Color(0xFFF5F5F5),
                        foregroundColor: textMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>  ChiensImageFullScreenPage(
                        assetPath: 'assets/images/chien-1.png',
                        title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00023", 'Schéma d’identification'),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: isDark ? Colors.black.withValues(alpha: .2) : Colors.white,
                    height: 320,
                    child: Center(
                      child: Image.asset(
                        'assets/images/chien-1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Catégories
          _ConditionCard(
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00024", "II — Catégories de chiens susceptibles d’être dangereux"),
            cardColor: cardCat,
            accent: accentGreen,
            titleColor: textMain,
            children:  [
              _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00025", "A) 1ʳᵉ catégorie : chiens d’attaque")),
              _Paragraph(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00026", "Chiens issus de croisements incontrôlés, sans inscription au Livre des origines français (LOF), ") + ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00027", "donc sans traçabilité. Ils sont assimilables (morphologie) à certaines races."),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00028", "Chiens assimilables aux races Staffordshire Terrier / American Staffordshire Terrier (dit « pit-bull »)."),
              ),
              _BulletPoint(
                text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00029", "Chiens assimilables aux Mastiff (dit « boer-bull »)."),
              ),
              _BulletPoint(
                text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00030", "Chiens assimilables aux Tosa-Inu (plus rare en France)."),
              ),
              SizedBox(height: 12),
              _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00031", "B) 2ᵉ catégorie : chiens de garde ou de défense")),
              _Paragraph(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00032", "Chiens de races reconnues par la Société Centrale Canine et disposant de documents LOF ") + ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00033", "(certificat de naissance et/ou pedigree). Races citées par l’arrêté du 27/04/1999."),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00034", "Staffordshire Terrier / American Staffordshire Terrier (races reconnues)."),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00035", "Rottweiler (ou assimilable) : classé en 2ᵉ catégorie, même sans LOF."),
              ),
              _BulletPoint(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00036", "Tosa-Inu (race reconnue).")),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00037", "NOTA (diagnose & chiens nés à l’étranger)"),
            cardColor: cardLieux,
            accent: accentAmber,
            titleColor: textMain,
            children:  [
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00038", "Un vétérinaire agréé peut réaliser une diagnose pour déterminer la catégorie (1 ou 2) et délivrer un document officiel."),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00039", "Pour un chien né à l’étranger, le maître doit détenir un document généalogique reconnu par la "),
                  ),
                  TextSpan(
                    text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00040", "F.C.I."),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00041", " (Fédération Cynologique Internationale)."),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Obligations (avec articles rouges)
          _ConditionCard(
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00042", "III — Obligations de détention (1ʳᵉ / 2ᵉ catégorie)"),
            cardColor: cardObl,
            accent: accentPink,
            titleColor: textMain,
            children: [
               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00043", "A) Personnes interdites de détention")),
              _Paragraph.rich([
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00044", "Article L. 211-13 du C.R.P.M.")),
                 TextSpan(
                  text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00045", " : ces chiens ne peuvent être détenus par :"),
                ),
              ]),
              const SizedBox(height: 8),
               _BulletPoint(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00046", "Les personnes de moins de 18 ans.")),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00047", "Les majeurs en tutelle (sauf autorisation du juge des tutelles)."),
              ),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00048", "Les personnes condamnées (crime ou certains délits au bulletin n°2, ou équivalent pour étrangers)."),
              ),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00049", "Les personnes auxquelles la propriété/la garde d’un chien a été retirée (décision du maire ; à Paris : préfet de police)."),
              ),

              const SizedBox(height: 12),

               _SubTitle(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00050", "B) Permis de détention (propriétaire / détenteur)"),
              ),
               _Paragraph(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00051", "La détention est subordonnée à un permis délivré par le maire de la commune de résidence. ") + ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00052", "Le permis prend la forme d’un arrêté (identité du détenteur, identité du chien, catégorie…)."),
              ),
              const SizedBox(height: 10),

               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00053", "Pièces à justifier")),
               _BulletPoint(
                text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00054", "Identification (tatouage ou puce électronique)."),
              ),
               _BulletPoint(
                text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00055", "Vaccination antirabique en cours de validité."),
              ),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00056", "Assurance responsabilité civile (dommages causés aux tiers par l’animal)."),
              ),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00057", "Stérilisation (chiens mâles et femelles de 1ʳᵉ catégorie)."),
              ),
               _BulletPoint(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00058", "Attestation d’aptitude (formation).")),
               _BulletPoint(
                text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00059", "Évaluation comportementale (vétérinaire agréé)."),
              ),

              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                   TextSpan(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00060", "Le maire (ou à défaut le préfet) peut imposer des mesures de prévention à tout type de chien présentant un danger, notamment formation + attestation après évaluation : "),
                  ),
                  _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00061", "article L. 211-11 du C.R.P.M.")),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 10),

              _Paragraph.rich([
                 TextSpan(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00062", "Présentation aux forces de l’ordre : ")),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00063", "article R. 215-2 du C.R.P.M.")),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00064", " (le permis de détention, l’assurance et la vaccination antirabique doivent pouvoir être présentés à tout moment)."),
                ),
              ]),

              const SizedBox(height: 12),

               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00065", "C) Détenteur à titre temporaire")),
               _Paragraph(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00066", "Le détenteur temporaire doit pouvoir justifier de sa qualité : ") + ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00067", "original ou copie du permis (ou permis provisoire) au nom du propriétaire/détenteur, sur réquisition des forces de l’ordre."),
              ),

              const SizedBox(height: 12),

               _SubTitle(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00068", "D) Commerce des chiens de 1ʳᵉ catégorie (interdit)"),
              ),
               _Paragraph(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00069", "Acquisition, cession (gratuite ou onéreuse), importation et introduction sur le territoire ") + ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00070", "métropolitain / DOM / Saint-Pierre-et-Miquelon : interdits (sauf exceptions prévues, ex : fourrière / association)."),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Règles de présence
          _ConditionCard(
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00071", "IV — Présence dans certains lieux"),
            cardColor: cardLieux,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                 TextSpan(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00072", "Règles principales : ")),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00073", "article L. 211-16 du C.R.P.M.")),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00074", "1ʳᵉ catégorie : lieux interdits")),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00075", "Accès interdit aux transports en commun, lieux publics (sauf voie publique) et locaux ouverts au public, même muselé et tenu en laisse."),
              ),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00076", "Stationnement interdit dans les parties communes des immeubles collectifs."),
              ),

              const SizedBox(height: 12),

               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00077", "Mesures communes (1ʳᵉ + 2ᵉ catégorie)")),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00078", "Sur la voie publique et dans les parties communes : muselé + tenu en laisse par une personne majeure."),
              ),

              const SizedBox(height: 12),

               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00079", "2ᵉ catégorie : lieux publics / transports")),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00080", "Dans les lieux publics, lieux ouverts au public et transports en commun : muselé + tenu en laisse par une personne majeure."),
              ),

              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                   TextSpan(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00081", "Danger grave et immédiat : le maire (ou à défaut le préfet) peut ordonner le placement en dépôt adapté et, le cas échéant, l’euthanasie. Est notamment réputé danger grave un chien 1 ou 2 détenu par une personne non autorisée, présent dans un lieu interdit, ou circulant sans muselière/laisse, ou sans attestation d’aptitude : "),
                  ),
                  _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00082", "article L. 211-11 du C.R.P.M.")),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions (structure claire)
          _ConditionCard(
            title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00083", "V — Infractions (repères opérationnels)"),
            cardColor: cardInfra,
            accent: accentOrange,
            titleColor: textMain,
            children: [
               _Paragraph(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00084", "Voici les manquements les plus fréquents (contraventions / délits) avec leurs fondements. ") + ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00085", "Objectif : lecture rapide et pédagogique en intervention."),
              ),
              const SizedBox(height: 12),

               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00086", "A) Détention / cession / acquisition (délits)")),
              _Paragraph.rich([
                 TextSpan(
                  text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00087", "Interdits de détention (mineur, incapacité…) : "),
                ),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00088", "article L. 211-13 du C.R.P.M.")),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00089", "Détention par mineur / malgré incapacité (catégorie 1 ou 2)."),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                 TextSpan(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00090", "Interdiction commerce catégorie 1 : ")),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00091", "article L. 211-15 du C.R.P.M.")),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00092", "Acquisition / cession / importation / introduction de chiens d’attaque (1ʳᵉ catégorie) : interdit."),
              ),

              const SizedBox(height: 12),

               _SubTitle(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00093", "B) Défaut de permis de détention (contravention)"),
              ),
              _Paragraph.rich([
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00094", "Articles L. 211-14, L. 211-12 et R. 215-2 du C.R.P.M.")),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00095", " : détention d’un chien de 1ʳᵉ ou 2ᵉ catégorie sans permis (ou permis provisoire si < 8 mois)."),
                ),
              ]),
              const SizedBox(height: 6),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00096", "Défaut de permis (1ʳᵉ catégorie) / Défaut de permis (2ᵉ catégorie)."),
              ),

              const SizedBox(height: 12),

               _SubTitle(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00097", "C) Défaut d’assurance / vaccination / identification"),
              ),
              _Paragraph.rich([
                 TextSpan(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00098", "Base documents à présenter : ")),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00099", "article R. 215-2 du C.R.P.M.")),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00100", "Sans assurance responsabilité civile (dommages aux tiers)."),
              ),
               _BulletPoint(
                text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00101", "Sans vaccination antirabique en cours de validité."),
              ),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00102", "Chien de plus de 4 mois non identifié (tatouage ou puce)."),
              ),

              const SizedBox(height: 12),

               _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00103", "D) Présence interdite / muselière / laisse")),
              _Paragraph.rich([
                 TextSpan(
                  text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00104", "Règles lieux / transports / voie publique : "),
                ),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00105", "article L. 211-16 du C.R.P.M.")),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00106", "1ʳᵉ catégorie : transports en commun / lieux publics (hors voie publique) / locaux ouverts au public : interdit."),
              ),
               _BulletPoint(
                text:
                    ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00107", "Non muselé ou non tenu en laisse (selon lieux) : infraction, pour 1ʳᵉ et/ou 2ᵉ catégorie."),
              ),

              const SizedBox(height: 12),

               _SubTitle(
                ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00108", "E) Atteintes involontaires à la personne (délits)"),
              ),
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00109", "Responsabilité pénale possible du propriétaire/détenteur en cas de décès/blessures causés par le chien : "),
                ),
                _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00110", "articles 221-6-2, 222-19-2 et 222-20-2 du Code pénal")),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              // 3 éléments (pédagogique)
              _ConditionCard(
                title: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00111", "Lecture rapide — 3 éléments (atteintes involontaires)"),
                cardColor: cardDef,
                accent: accentGrey,
                titleColor: textMain,
                children: [
                   _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00112", "1) Élément légal")),
                  _Paragraph.rich([
                    _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00113", "221-6-2 / 222-19-2 / 222-20-2 du Code pénal")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00114", " : incriminent ces atteintes involontaires liées à une agression par chien."),
                    ),
                  ]),
                  const SizedBox(height: 10),
                   _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00115", "2) Élément matériel")),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00116", "Un décès ou des blessures résultant d’une agression commise par l’animal."),
                  ),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00117", "Lien de causalité entre les manquements (garde/maîtrise) et le dommage."),
                  ),
                  const SizedBox(height: 10),
                   _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00118", "3) Élément moral")),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00119", "Faute d’imprudence / négligence / manquement à une obligation de prudence ou de sécurité."),
                  ),
                  const SizedBox(height: 10),
                   _SubTitle(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00120", "Tentative & complicité (repère)")),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00121", "Tentative : non pertinente en matière d’involontaire (le texte vise un résultat)."),
                  ),
                  _Paragraph.rich([
                     TextSpan(
                      text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00122", "Complicité : possible pour un délit, selon "),
                    ),
                    _law(ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00123", "articles 121-6 et 121-7 du Code pénal")),
                     TextSpan(text: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00124", ", si les conditions sont réunies.")),
                  ]),
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
          children: [
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}

class ChiensImageFullScreenPage extends StatefulWidget {
  const ChiensImageFullScreenPage({
    super.key,
    required this.assetPath,
    this.title = "Schéma",
  });

  final String assetPath;
  final String title;

  @override
  State<ChiensImageFullScreenPage> createState() =>
      _ChiensImageFullScreenPageState();
}

class _ChiensImageFullScreenPageState extends State<ChiensImageFullScreenPage> {
  double _rotationTurns = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          tooltip: 'Fermer',
        ),
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16.5,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00126", "Tourner 90°"),
            onPressed: () {
              setState(() {
                _rotationTurns += 0.25;
              });
            },
            icon: const Icon(Icons.rotate_right_rounded, color: Colors.white),
          ),
          IconButton(
            tooltip: ScolariteText.value("lib/content/gpx_scolarite/policier_intervention_avance/animal/chiens_categories_page.dart", "f00127", "Réinitialiser"),
            onPressed: () {
              setState(() {
                _rotationTurns = 0.0;
              });
            },
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 8,
          boundaryMargin: const EdgeInsets.all(48),
          child: Center(
            child: Transform.rotate(
              angle: _rotationTurns * 2 * math.pi,
              child: Image.asset(widget.assetPath, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
