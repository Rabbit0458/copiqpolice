import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AnnoncerMauvaiseNouvellePage extends StatelessWidget {
  const AnnoncerMauvaiseNouvellePage({super.key});

  static const String routeName =
      '/gpx/intervention/accident-circulation/annoncer-mauvaise-nouvelle';

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
    final Color cardDo = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDont = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSummary = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
            "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
            "f00002",
            "Accident circulation",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
              "f00003",
              "Annoncer une mauvaise nouvelle",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Références / cadre (en haut)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
              "f00004",
              "Références (cadre institutionnel)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                    "f00005",
                    "Fiche mémo AMARIS « J’annonce une mauvaise nouvelle » (FM n°8 bis — Juin 2023).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00006",
                  "Références utiles",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00007",
                      "Note du DGPN du 14/12/2022 relative à l’annonce de décès dans le cadre judiciaire et au traitement respectueux des proches du défunt.",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00008",
                      "Circulaire interministérielle du 2 décembre 2022 relative à l’annonce du décès et au traitement respectueux du défunt et de ses proches.",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00009",
                      "Ressources du Cn2r (Centre national de ressources et de résilience) : fiche réflexe + ressources professionnelles.",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
              "f00010",
              "De quoi s’agit-il ?",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00011",
                      "Tout policier, quel que soit son grade, peut être amené à annoncer une mauvaise nouvelle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00012",
                      "au cours de sa carrière : blessures graves, disparition, décès…\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00013",
                      "Cette annonce est un moment profondément marquant pour la personne qui la reçoit. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00014",
                      "Elle peut aussi être une épreuve pour le policier, qui risque de se projeter dans la douleur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00015",
                      "de la victime ou de ses proches.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00016",
                      "C’est une mission difficile où se joue l’image de l’institution : elle exige humanité, maîtrise ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00017",
                      "de soi et professionnalisme.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
              "f00018",
              "Ce qu’il faut faire",
            ),
            cardColor: cardDo,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00019",
                  "1) Se présenter physiquement",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00020",
                  "Se présenter physiquement (à deux ou trois) donne un aspect solennel et montre le respect dû aux proches.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00021",
                  "En cas d’absence, prévoir une visite ultérieure : éviter toute annonce improvisée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00022",
                  "Si déplacement impossible, faire transmettre par un équipage territorialement compétent (mission dédiée).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00023",
                  "Éviter autant que possible l’annonce par téléphone.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00024",
                          "Le déplacement doit rester discret pour ne pas susciter la curiosité. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00025",
                          "Sur place, demander la permission d’entrer au domicile.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00026",
                  "2) Annoncer sans tarder (calme, bref, tact)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00027",
                  "Un seul policier annonce : il vérifie l’exactitude des informations et prépare ses mots.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00028",
                  "S’exprimer rapidement, sur un ton calme : s’en tenir aux faits, sans détails inutiles.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00029",
                  "Exemple de formulation",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00030",
                          "« Je viens pour votre fille… Elle a eu un accident… Elle a été gravement blessée… ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00031",
                          "Elle n’a pas survécu à ses blessures. »",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00032",
                  "3) Laisser s’exprimer, répondre aux questions",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00033",
                  "Laisser le temps d’intégrer : colère, larmes, silence, agressivité, distance…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00034",
                  "Rester présent, calme et bienveillant : la posture compte autant que les mots.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00035",
                  "Éviter la présence des enfants si possible : l’annonce peut être traumatisante.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00036",
                  "Répondre de façon calme et brève, sans surenchère.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00037",
                  "Avant de partir",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00038",
                          "En cas de nouvelle très dramatique : s’assurer autant que possible que le proche ne reste pas seul. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00039",
                          "Orienter vers un professionnel du soutien ou une association si nécessaire.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
              "f00040",
              "Ce qu’il faut éviter",
            ),
            cardColor: cardDont,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00041",
                  "Faire deviner, dissimuler, enjoliver ou relativiser : cela peut créer du doute et de la colère.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00042",
                  "Propos culpabilisants (« vous n’auriez pas dû… ») ou jugements (« il n’a pas été raisonnable »).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00043",
                  "Évoquer des cas similaires : cela détourne et banalise la douleur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00044",
                  "Donner des détails morbides non demandés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00045",
                  "Vouloir “avoir réponse à tout” ou être positif à tout prix.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
              "f00046",
              "En résumé",
            ),
            cardColor: cardSummary,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00047",
                      "Annoncer une mauvaise nouvelle implique de le faire physiquement, de manière calme, brève ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00048",
                      "et diplomate, tout en se préservant soi-même.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00049",
                      "En cas de difficulté lors de l’annonce, il est important d’en parler avec ses collègues et sa hiérarchie ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                      "f00050",
                      "et de solliciter un soutien psychologique si nécessaire.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                  "f00051",
                  "Attention",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00052",
                          "Cette fiche apporte un éclairage et une aide, sans prescriptions contraignantes ni exclusives. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/accident_circulation/annoncer_mauvaise_nouvelle_page.dart",
                          "f00053",
                          "Partageons nos expériences et renforçons notre sécurité.",
                        ),
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
