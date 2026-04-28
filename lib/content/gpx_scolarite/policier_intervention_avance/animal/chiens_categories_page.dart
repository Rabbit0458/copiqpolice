import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          tooltip: 'Retour',
        ),
        title: Text(
          "Intervention — Animal",
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
            "Chiens d’attaque, de garde ou de défense",
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
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Le Code rural classe certains chiens considérés comme les plus dangereux en deux catégories : ",
                ),
                const TextSpan(
                  text: "1ʳᵉ catégorie (chiens d’attaque) ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "et "),
                const TextSpan(
                  text: "2ᵉ catégorie (chiens de garde ou de défense).",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Cadre juridique : "),
                _law("articles L. 211-12 et suivants du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law("Articles L. 211-12 et suivants du C.R.P.M."),
                const TextSpan(
                  text:
                      " : fondent la classification des chiens dangereux et les règles particulières applicables à leur détention.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Article L. 211-13 du C.R.P.M."),
                const TextSpan(
                  text:
                      " : fixe les personnes interdites de détention (mineurs, tutelle sans autorisation, condamnations, retrait de garde…).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Articles L. 211-14 et R. 215-2 du C.R.P.M."),
                const TextSpan(
                  text:
                      " : encadrent le permis de détention et les documents à présenter aux forces de l’ordre.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _law("Article L. 211-16 du C.R.P.M."),
                const TextSpan(
                  text:
                      " : règles de présence des chiens de 1ʳᵉ / 2ᵉ catégorie dans les lieux (transports, lieux publics, parties communes…).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Image (zoom + rotation)
          _ConditionCard(
            title: "Schéma d’identification (zoom + rotation)",
            cardColor: cardImg,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Astuce : pince pour zoomer, glisse pour déplacer. "
                "Tu peux aussi tourner l’image pour lire le tableau facilement.",
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
                      label: const Text("Réinitialiser"),
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
                      builder: (_) => const ChiensImageFullScreenPage(
                        assetPath: 'assets/images/chien-1.png',
                        title: 'Schéma d’identification',
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    color: isDark ? Colors.black.withOpacity(.2) : Colors.white,
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
            title: "II — Catégories de chiens susceptibles d’être dangereux",
            cardColor: cardCat,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _SubTitle("A) 1ʳᵉ catégorie : chiens d’attaque"),
              _Paragraph(
                "Chiens issus de croisements incontrôlés, sans inscription au Livre des origines français (LOF), "
                "donc sans traçabilité. Ils sont assimilables (morphologie) à certaines races.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Chiens assimilables aux races Staffordshire Terrier / American Staffordshire Terrier (dit « pit-bull »).",
              ),
              _BulletPoint(
                text: "Chiens assimilables aux Mastiff (dit « boer-bull »).",
              ),
              _BulletPoint(
                text: "Chiens assimilables aux Tosa-Inu (plus rare en France).",
              ),
              SizedBox(height: 12),
              _SubTitle("B) 2ᵉ catégorie : chiens de garde ou de défense"),
              _Paragraph(
                "Chiens de races reconnues par la Société Centrale Canine et disposant de documents LOF "
                "(certificat de naissance et/ou pedigree). Races citées par l’arrêté du 27/04/1999.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Staffordshire Terrier / American Staffordshire Terrier (races reconnues).",
              ),
              _BulletPoint(
                text:
                    "Rottweiler (ou assimilable) : classé en 2ᵉ catégorie, même sans LOF.",
              ),
              _BulletPoint(text: "Tosa-Inu (race reconnue)."),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "NOTA (diagnose & chiens nés à l’étranger)",
            cardColor: cardLieux,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Un vétérinaire agréé peut réaliser une diagnose pour déterminer la catégorie (1 ou 2) et délivrer un document officiel.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Pour un chien né à l’étranger, le maître doit détenir un document généalogique reconnu par la ",
                  ),
                  const TextSpan(
                    text: "F.C.I.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text: " (Fédération Cynologique Internationale).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Obligations (avec articles rouges)
          _ConditionCard(
            title: "III — Obligations de détention (1ʳᵉ / 2ᵉ catégorie)",
            cardColor: cardObl,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Personnes interdites de détention"),
              _Paragraph.rich([
                _law("Article L. 211-13 du C.R.P.M."),
                const TextSpan(
                  text: " : ces chiens ne peuvent être détenus par :",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Les personnes de moins de 18 ans."),
              const _BulletPoint(
                text:
                    "Les majeurs en tutelle (sauf autorisation du juge des tutelles).",
              ),
              const _BulletPoint(
                text:
                    "Les personnes condamnées (crime ou certains délits au bulletin n°2, ou équivalent pour étrangers).",
              ),
              const _BulletPoint(
                text:
                    "Les personnes auxquelles la propriété/la garde d’un chien a été retirée (décision du maire ; à Paris : préfet de police).",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "B) Permis de détention (propriétaire / détenteur)",
              ),
              const _Paragraph(
                "La détention est subordonnée à un permis délivré par le maire de la commune de résidence. "
                "Le permis prend la forme d’un arrêté (identité du détenteur, identité du chien, catégorie…).",
              ),
              const SizedBox(height: 10),

              const _SubTitle("Pièces à justifier"),
              const _BulletPoint(
                text: "Identification (tatouage ou puce électronique).",
              ),
              const _BulletPoint(
                text: "Vaccination antirabique en cours de validité.",
              ),
              const _BulletPoint(
                text:
                    "Assurance responsabilité civile (dommages causés aux tiers par l’animal).",
              ),
              const _BulletPoint(
                text:
                    "Stérilisation (chiens mâles et femelles de 1ʳᵉ catégorie).",
              ),
              const _BulletPoint(text: "Attestation d’aptitude (formation)."),
              const _BulletPoint(
                text: "Évaluation comportementale (vétérinaire agréé).",
              ),

              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le maire (ou à défaut le préfet) peut imposer des mesures de prévention à tout type de chien présentant un danger, notamment formation + attestation après évaluation : ",
                  ),
                  _law("article L. 211-11 du C.R.P.M."),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 10),

              _Paragraph.rich([
                const TextSpan(text: "Présentation aux forces de l’ordre : "),
                _law("article R. 215-2 du C.R.P.M."),
                const TextSpan(
                  text:
                      " (le permis de détention, l’assurance et la vaccination antirabique doivent pouvoir être présentés à tout moment).",
                ),
              ]),

              const SizedBox(height: 12),

              const _SubTitle("C) Détenteur à titre temporaire"),
              const _Paragraph(
                "Le détenteur temporaire doit pouvoir justifier de sa qualité : "
                "original ou copie du permis (ou permis provisoire) au nom du propriétaire/détenteur, sur réquisition des forces de l’ordre.",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "D) Commerce des chiens de 1ʳᵉ catégorie (interdit)",
              ),
              const _Paragraph(
                "Acquisition, cession (gratuite ou onéreuse), importation et introduction sur le territoire "
                "métropolitain / DOM / Saint-Pierre-et-Miquelon : interdits (sauf exceptions prévues, ex : fourrière / association).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Règles de présence
          _ConditionCard(
            title: "IV — Présence dans certains lieux",
            cardColor: cardLieux,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Règles principales : "),
                _law("article L. 211-16 du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              const _SubTitle("1ʳᵉ catégorie : lieux interdits"),
              const _BulletPoint(
                text:
                    "Accès interdit aux transports en commun, lieux publics (sauf voie publique) et locaux ouverts au public, même muselé et tenu en laisse.",
              ),
              const _BulletPoint(
                text:
                    "Stationnement interdit dans les parties communes des immeubles collectifs.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("Mesures communes (1ʳᵉ + 2ᵉ catégorie)"),
              const _BulletPoint(
                text:
                    "Sur la voie publique et dans les parties communes : muselé + tenu en laisse par une personne majeure.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("2ᵉ catégorie : lieux publics / transports"),
              const _BulletPoint(
                text:
                    "Dans les lieux publics, lieux ouverts au public et transports en commun : muselé + tenu en laisse par une personne majeure.",
              ),

              const SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Danger grave et immédiat : le maire (ou à défaut le préfet) peut ordonner le placement en dépôt adapté et, le cas échéant, l’euthanasie. Est notamment réputé danger grave un chien 1 ou 2 détenu par une personne non autorisée, présent dans un lieu interdit, ou circulant sans muselière/laisse, ou sans attestation d’aptitude : ",
                  ),
                  _law("article L. 211-11 du C.R.P.M."),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions (structure claire)
          _ConditionCard(
            title: "V — Infractions (repères opérationnels)",
            cardColor: cardInfra,
            accent: accentOrange,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Voici les manquements les plus fréquents (contraventions / délits) avec leurs fondements. "
                "Objectif : lecture rapide et pédagogique en intervention.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("A) Détention / cession / acquisition (délits)"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Interdits de détention (mineur, incapacité…) : ",
                ),
                _law("article L. 211-13 du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Détention par mineur / malgré incapacité (catégorie 1 ou 2).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Interdiction commerce catégorie 1 : "),
                _law("article L. 211-15 du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Acquisition / cession / importation / introduction de chiens d’attaque (1ʳᵉ catégorie) : interdit.",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "B) Défaut de permis de détention (contravention)",
              ),
              _Paragraph.rich([
                _law("Articles L. 211-14, L. 211-12 et R. 215-2 du C.R.P.M."),
                const TextSpan(
                  text:
                      " : détention d’un chien de 1ʳᵉ ou 2ᵉ catégorie sans permis (ou permis provisoire si < 8 mois).",
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Défaut de permis (1ʳᵉ catégorie) / Défaut de permis (2ᵉ catégorie).",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "C) Défaut d’assurance / vaccination / identification",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Base documents à présenter : "),
                _law("article R. 215-2 du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "Sans assurance responsabilité civile (dommages aux tiers).",
              ),
              const _BulletPoint(
                text: "Sans vaccination antirabique en cours de validité.",
              ),
              const _BulletPoint(
                text:
                    "Chien de plus de 4 mois non identifié (tatouage ou puce).",
              ),

              const SizedBox(height: 12),

              const _SubTitle("D) Présence interdite / muselière / laisse"),
              _Paragraph.rich([
                const TextSpan(
                  text: "Règles lieux / transports / voie publique : ",
                ),
                _law("article L. 211-16 du C.R.P.M."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint(
                text:
                    "1ʳᵉ catégorie : transports en commun / lieux publics (hors voie publique) / locaux ouverts au public : interdit.",
              ),
              const _BulletPoint(
                text:
                    "Non muselé ou non tenu en laisse (selon lieux) : infraction, pour 1ʳᵉ et/ou 2ᵉ catégorie.",
              ),

              const SizedBox(height: 12),

              const _SubTitle(
                "E) Atteintes involontaires à la personne (délits)",
              ),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Responsabilité pénale possible du propriétaire/détenteur en cas de décès/blessures causés par le chien : ",
                ),
                _law("articles 221-6-2, 222-19-2 et 222-20-2 du Code pénal"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              // 3 éléments (pédagogique)
              _ConditionCard(
                title: "Lecture rapide — 3 éléments (atteintes involontaires)",
                cardColor: cardDef,
                accent: accentGrey,
                titleColor: textMain,
                children: [
                  const _SubTitle("1) Élément légal"),
                  _Paragraph.rich([
                    _law("221-6-2 / 222-19-2 / 222-20-2 du Code pénal"),
                    const TextSpan(
                      text:
                          " : incriminent ces atteintes involontaires liées à une agression par chien.",
                    ),
                  ]),
                  const SizedBox(height: 10),
                  const _SubTitle("2) Élément matériel"),
                  const _BulletPoint(
                    text:
                        "Un décès ou des blessures résultant d’une agression commise par l’animal.",
                  ),
                  const _BulletPoint(
                    text:
                        "Lien de causalité entre les manquements (garde/maîtrise) et le dommage.",
                  ),
                  const SizedBox(height: 10),
                  const _SubTitle("3) Élément moral"),
                  const _BulletPoint(
                    text:
                        "Faute d’imprudence / négligence / manquement à une obligation de prudence ou de sécurité.",
                  ),
                  const SizedBox(height: 10),
                  const _SubTitle("Tentative & complicité (repère)"),
                  const _BulletPoint(
                    text:
                        "Tentative : non pertinente en matière d’involontaire (le texte vise un résultat).",
                  ),
                  _Paragraph.rich([
                    const TextSpan(
                      text: "Complicité : possible pour un délit, selon ",
                    ),
                    _law("articles 121-6 et 121-7 du Code pénal"),
                    const TextSpan(text: ", si les conditions sont réunies."),
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
            tooltip: "Tourner 90°",
            onPressed: () {
              setState(() {
                _rotationTurns += 0.25;
              });
            },
            icon: const Icon(Icons.rotate_right_rounded, color: Colors.white),
          ),
          IconButton(
            tooltip: "Réinitialiser",
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
