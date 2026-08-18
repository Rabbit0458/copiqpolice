import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaExtraditionSimplifieeUEPage extends StatelessWidget {
  const PaExtraditionSimplifieeUEPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/entraide_judiciaire/extradition_simplifiee_ue';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    Color lawRed() => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
            "f00001",
            'Retour',
          ),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
            "f00002",
            'Extradition simplifiée U.E.',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // =============================================================
          // EN-TÊTE
          // =============================================================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00003",
              '3 — L’extradition',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00004",
              '3.2 — La procédure simplifiée d’extradition\nentre États membres de l’Union européenne',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.25,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                  "f00005",
                  'La procédure simplifiée d’extradition entre États membres de l’Union européenne est un ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                  "f00006",
                  'mécanisme spécifique destiné à accélérer la remise des personnes recherchées, lorsque ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                  "f00007",
                  'la procédure du mandat d’arrêt européen n’est pas applicable.',
                ),
          ),
          const SizedBox(height: 16),

          // =============================================================
          // CADRE JURIDIQUE
          // =============================================================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00008",
              'Cadre juridique et champ d’application',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00009",
                      'Cette procédure n’est applicable qu’aux demandes d’extradition émanant d’un État partie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00010",
                      'à la convention du 10 mars 1995 relative à la procédure simplifiée d’extradition entre les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00011",
                      'États membres de l’Union européenne, et uniquement lorsque la procédure du mandat d’arrêt ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00012",
                      'européen ne peut pas être utilisée.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00013",
                      'Elle s’applique également aux demandes d’arrestation provisoire aux fins d’extradition ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00014",
                      'adressées à la France par un État partie au troisième protocole additionnel du 10 novembre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00015",
                      '2010 à la convention européenne d’extradition du 13 décembre 1957.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00016",
                    'En droit interne, cette procédure est prévue par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00017",
                    'les articles 696-25 à 696-33 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
            ],
          ),
          const SizedBox(height: 18),

          // =============================================================
          // 3.2.1 CONDITIONS DE MISE EN ŒUVRE
          // =============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00018",
              '3.2.1 — Conditions de mise en œuvre',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00019",
              'Conditions de mise en œuvre',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00020",
                      'Les conditions de mise en œuvre de la procédure simplifiée sont identiques à celles de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00021",
                      'procédure d’extradition de droit commun : gravité suffisante des faits, absence de caractère ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00022",
                      'politique, respect de la double incrimination, compétences territoriales et matérielles des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00023",
                      'juridictions concernées.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00024",
                      'La différence essentielle réside dans la simplification et l’accélération de la phase ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00025",
                      'décisionnelle lorsqu’il existe un consentement formel de la personne réclamée.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // =============================================================
          // 3.2.2 PROCÉDURE SIMPLIFIÉE
          // =============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00026",
              '3.2.2 — La procédure simplifiée',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00027",
              'Déroulement de la procédure simplifiée',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00028",
                    'La procédure se déroule, pour l’essentiel, conformément aux dispositions de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00029",
                    'l’article 696-10 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00030",
                    ' et de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00031",
                    'l’article 696-11 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                        "f00032",
                        ', relatives à l’interpellation de la personne réclamée, à sa présentation devant le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                        "f00033",
                        'procureur général puis devant le premier président de la cour d’appel ou le magistrat ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                        "f00034",
                        'désigné, ainsi qu’à son éventuelle incarcération sous écrou extraditionnel.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00035",
                      'Lorsque la personne comparaît devant la chambre de l’instruction et réitère son ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00036",
                      'consentement à l’extradition, elle est informée de manière précise et compréhensible des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00037",
                      'conséquences juridiques de ce consentement.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00038",
                      'Il lui est notamment demandé si elle renonce au bénéfice de la règle de la spécialité. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00039",
                      'En cas de renonciation, la personne pourra être poursuivie, condamnée et détenue en vue de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00040",
                      'l’exécution d’une peine privative de liberté pour tout fait antérieur à sa remise, autre que ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00041",
                      'celui ayant motivé la demande d’extradition.',
                    ),
              ),
              const SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                          "f00042",
                          'Règle de la spécialité : en l’absence de renonciation, la personne extradée ne peut ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                          "f00043",
                          'être poursuivie, jugée ou détenue que pour les faits ayant servi de fondement à la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                          "f00044",
                          'demande d’extradition, sauf exceptions prévues par les textes internationaux ou le ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                          "f00045",
                          'Code de Procédure Pénale.',
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // =============================================================
          // 3.2.3 EFFETS DE LA PROCÉDURE
          // =============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00046",
              '3.2.3 — Effets de la procédure',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
              "f00047",
              'Décision de la chambre de l’instruction et remise',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00048",
                      'Si les conditions légales de l’extradition sont réunies, la chambre de l’instruction rend un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00049",
                      'arrêt par lequel elle donne acte à la personne réclamée de son consentement formel à être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00050",
                      'extradée, ainsi que, le cas échéant, de sa renonciation à la règle de la spécialité, puis ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00051",
                      'accorde l’extradition.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00052",
                      'La chambre de l’instruction doit statuer dans un délai de sept jours à compter de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00053",
                      'comparution de la personne. L’arrêt rendu est susceptible de recours.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00054",
                    'Le recours contre cet arrêt est organisé par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                    "f00055",
                    'l’article 696-30 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00056",
                      'Lorsque l’arrêt accordant l’extradition est devenu définitif, la procédure revêt un caractère ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00057",
                      'entièrement judiciaire : l’extradition n’est plus accordée par décret, contrairement à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00058",
                      'procédure de droit commun.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00059",
                      'Le procureur général avise le ministre de la Justice, qui informe l’État requérant de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00060",
                      'décision définitive. La personne doit être remise aux autorités de cet État dans un délai de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00061",
                      'vingt jours à compter de la notification de la décision à ces autorités.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00062",
                      'Si, à l’expiration de ce délai de vingt jours, la personne extradée se trouve encore sur le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/entraide_judiciaire/extradition_simplifiee_ue_page.dart",
                      "f00063",
                      'territoire de la République, sa mise en liberté doit être ordonnée.',
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
