import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class EnregistrementDiffusionImagesParolesPage extends StatelessWidget {
  const EnregistrementDiffusionImagesParolesPage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/enregistrement-diffusion-images-paroles';

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
    final Color cardPrinciple = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardExceptions = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardSpecial = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPractice = isDark
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
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Patrouille",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
              "f00002",
              "Enregistrement et diffusion d’images/paroles des policiers",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
              "f00003",
              "Idée clé",
            ),
            cardColor: cardPrinciple,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                      "f00004",
                      "Sur la voie publique (ou dans un lieu ouvert au public), un policier en mission ne peut ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                      "f00005",
                      "pas, en principe, s’opposer au fait d’être filmé ou enregistré.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                      "f00006",
                      "➡️ En revanche, certaines règles protègent la vie privée, la dignité, les victimes, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                      "f00007",
                      "le secret de l’enquête/instruction, et l’anonymat de certains services.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Cadre légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
              "f00008",
              "I — Cadre juridique",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00009",
                    "Article 226-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                        "f00010",
                        " : interdit la captation, l’enregistrement et la transmission, sans consentement, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                        "f00011",
                        "de paroles prononcées à titre privé/confidentiel (même en lieu public) et de l’image d’une personne ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                        "f00012",
                        "se trouvant dans un lieu privé.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00013",
                    "Article 35 ter de la loi du 29 juillet 1881",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                        "f00014",
                        " : protège l’image d’une personne identifiée/identifiable mise en cause dans une procédure pénale ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                        "f00015",
                        "non condamnée, lorsque l’image montre menottes/entraves ou détention provisoire.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00016",
                    "Article 39 sexies de la loi du 29 juillet 1881",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00017",
                    " : base de la protection de l’anonymat de certains fonctionnaires de police (services listés par arrêté).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00018",
                          "Important : en intervention, la liberté d’information peut primer, tant qu’elle n’est pas dévoyée ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00019",
                          "par une atteinte à la dignité ou par une atteinte au secret de l’enquête/instruction.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
              "f00020",
              "II — Principe (voie publique)",
            ),
            cardColor: cardPrinciple,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00021",
                  "Ce que je ne peux pas faire",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00022",
                  "Interdire à quelqu’un de filmer/registrer un policier en mission sur la voie publique, sur ce seul motif.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00023",
                  "Interpeller une personne uniquement parce qu’elle filme.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00024",
                  "Retirer le matériel, exiger la destruction, ou détruire l’enregistrement / son support.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00025",
                          "Une action de confiscation/destruction « pour empêcher de filmer » expose l’agent à des risques ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00026",
                          "disciplinaires et judiciaires.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00027",
                  "Posture pro",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                      "f00028",
                      "Soumis à des règles de déontologie, le policier doit s’y conformer dans chacune de ses missions ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                      "f00029",
                      "et apprendre à travailler sous l’œil de l’objectif, y compris à très courte distance.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
              "f00030",
              "III — Exceptions et limites",
            ),
            cardColor: cardExceptions,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00031",
                  "A) Limiter l’enregistrement (dans certains cas)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00032",
                  "Préservation des traces et indices / respect du secret de l’enquête et de l’instruction (maintenir à distance d’une scène).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00033",
                  "Sécurité : tenir à distance lors d’une action présentant un risque (protéger policiers, collègues, public).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00034",
                  "B) Limiter la diffusion / publication",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00035",
                  "Protection de la dignité de certaines personnes (ex. victimes blessées, personnes dénudées…).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00036",
                    "Article 35 ter de la loi du 29 juillet 1881",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00037",
                    " : attention aux images de personnes mises en cause non condamnées si menottes/entraves ou détention provisoire apparaissent.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00038",
                  "Conseil pratique",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00039",
                          "Sans contrainte légale, on peut suggérer un floutage/mosaïque avant diffusion : ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00040",
                          "l’anonymat participe à l’efficacité et à la sécurité.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
              "f00041",
              "IV — Protection spéciale (certains services)",
            ),
            cardColor: cardSpecial,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00042",
                    "Certains services d’intervention / anti-terrorisme / contre-espionnage (listés par arrêté) bénéficient d’une garantie d’anonymat. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00043",
                    "Article 39 sexies de la loi du 29 juillet 1881",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                    "f00044",
                    " : publication interdite si l’image permet l’identification.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                      "f00045",
                      "Dans ce cadre, l’anonymat est protégé en toute circonstance, y compris sur la voie publique et dans des lieux ouverts au public.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
              "f00046",
              "V — Conduite à tenir sur intervention",
            ),
            cardColor: cardPractice,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00047",
                  "Réflexes terrain (pédagogique)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00048",
                  "Rester concentré sur la mission : sécurité, maîtrise, cadre déontologique.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00049",
                  "Si nécessaire, tenir la personne à distance pour sécurité ou préservation d’une scène (sans viser l’interdiction de filmer).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00050",
                  "Protéger les victimes et préserver la dignité (éviter exposition inutile).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00051",
                  "Éviter tout geste illégal : pas de confiscation, pas de suppression, pas de destruction.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                  "f00052",
                  "Information hiérarchique",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00053",
                          "Tout enregistrement connu d’images/paroles de policiers en lien avec l’exercice des fonctions doit faire, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/enregistrement_diffusion_images_paroles_page.dart",
                          "f00054",
                          "dès que possible, l’objet d’une information de la hiérarchie.",
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
