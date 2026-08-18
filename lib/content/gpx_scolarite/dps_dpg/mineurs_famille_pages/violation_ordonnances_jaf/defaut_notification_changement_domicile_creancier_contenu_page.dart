import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DefautNotificationChangementDomicileCreancierPage
    extends StatelessWidget {
  const DefautNotificationChangementDomicileCreancierPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
            "f00002",
            "Violation d’ordonnances JAF",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
              "f00003",
              "Le défaut de notification de changement de domicile au créancier",
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
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00005",
                      "Le fait, pour une personne tenue de verser une contribution ou des subsides au titre ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00006",
                      "de l’ordonnance de protection rendue en application de l’article 515-9 du code civil, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00007",
                      "de ne pas notifier son changement de domicile au créancier dans un délai d’un mois ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00008",
                      "à compter de ce changement, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal (en haut)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00010",
                    "Article 227-4-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00011",
                    " : définit et réprime le défaut de notification de changement de domicile au créancier.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00013",
                      "Le juge aux affaires familiales pouvant être amené à se prononcer, dans le cadre du référé protection, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00014",
                      "sur la contribution aux charges du ménage, il était nécessaire de prévoir, à des fins dissuasives, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00015",
                      "l’infraction du défaut de communication de changement d’adresse du débiteur.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00016",
                  "A) Une personne tenue de verser une contribution ou des subsides",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00017",
                    "Dans le cadre de l’ordonnance de protection, le juge peut intervenir sur le fondement de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00018",
                    "l’article 515-9 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00019",
                    ", selon les modalités fixées par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00020",
                    "l’article 515-11 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00021",
                  "Statuer sur la résidence séparée des époux, préciser qui demeure dans le logement conjugal et les modalités de prise en charge des frais afférents ; en principe, la jouissance est attribuée au conjoint non auteur des violences.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00022",
                  "Préciser lequel des partenaires PACS ou concubins demeure dans le logement commun et statuer sur la prise en charge des frais ; en principe, la jouissance est attribuée au partenaire/concubin non auteur des violences.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00023",
                  "Se prononcer sur l’autorité parentale et, le cas échéant, sur la contribution : charges du mariage (couples mariés), aide matérielle (PACS) et contribution à l’entretien/éducation des enfants.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00024",
                  "B) Un défaut de notification de changement de domicile au créancier",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00025",
                      "Le débiteur doit, dans un délai d’un mois, notifier au créancier son changement de domicile. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00026",
                      "Aucune exigence particulière n’est imposée quant à la forme de cette notification.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00027",
                      "Point clé : l’infraction vise le silence volontaire du débiteur, malgré l’existence d’une obligation de contribution/subsides au titre de l’ordonnance de protection.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
              "f00028",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00029",
                  "Volonté de ne pas informer le créancier",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00030",
                      "Le défaut de notification de changement de domicile est une infraction intentionnelle. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00031",
                      "La simple négligence n’est pas punissable : la volonté coupable consiste à vouloir, par son silence, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00032",
                      "priver le titulaire du droit de l’exercice de ce droit.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
              "f00033",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00034",
                  "Aucune circonstance aggravante prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
              "f00035",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00036",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00037",
                    "Délit — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00038",
                    "article 227-4-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " : "),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00039",
                  "6 mois d’emprisonnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00040",
                  "7 500 € d’amende.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00041",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00042",
                    "Responsabilité pénale possible via ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00043",
                    "l’article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00044",
                    " (généralisation de la responsabilité des personnes morales).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                      "f00045",
                      "En pratique, l’engagement de la responsabilité des personnes morales s’apprécie au regard des conditions légales d’imputabilité (organe/représentant, intérêt, etc.).",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00046",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                  "f00047",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00048",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00049",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/defaut_notification_changement_domicile_creancier_contenu_page.dart",
                    "f00050",
                    " (aide/assistance, provocation ou instructions).",
                  ),
                ),
              ]),
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
