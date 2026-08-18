import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PPEffetsNullitePage extends StatelessWidget {
  const PPEffetsNullitePage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_effets_nullite';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
            "f00002",
            'Effets de la nullité',
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
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
              "f00003",
              'Les effets de la nullité\ndes actes de procédure',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00004",
                  'Conséquences de l’annulation sur la procédure pénale elle-même et sur la ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00005",
                  'situation procédurale des parties (purge des nullités, mémoires, débats…).',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
              "f00006",
              '2.2 – Les effets de la nullité',
            ),
          ),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00007",
                  'Lorsqu’elle est prononcée, la nullité ne se limite pas à « effacer » un acte isolé. ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00008",
                  'Elle a des effets directs sur le dossier de procédure (retrait, classement, portée de ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00009",
                  'l’annulation) et des effets pratiques importants pour les parties (purge des nullités, ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00010",
                  'organisation des moyens, recevabilité des contestations ultérieures).',
                ),
          ),

          const SizedBox(height: 18),

          // ================= CARD 1 — EFFETS SUR LA PROCÉDURE =================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
              "f00011",
              '2.2.1 – Les effets sur la procédure',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00012",
                    'Les effets de la nullité sur la procédure sont principalement encadrés par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00013",
                    'l’Article 174 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00014",
                        '. La chambre de l’instruction dispose d’un pouvoir d’appréciation sur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00015",
                        'l’étendue de l’annulation.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00016",
                      'La chambre de l’instruction détermine si l’annulation est limitée à tout ou partie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00017",
                      'des actes ou pièces viciés, ou si elle s’étend à tout ou partie de la procédure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00018",
                      'ultérieure qui en découle.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00019",
                      'En cas d’annulation, la chambre peut évoquer elle-même l’affaire ou renvoyer le dossier ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00020",
                      'soit au même juge d’instruction, soit à un autre juge d’instruction.',
                    ),
              ),

              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00021",
                        'Les actes annulés sont retirés du dossier d’instruction et classés au greffe de la cour ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00022",
                        'd’appel. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00023",
                    'L’Article 174 alinéa 3 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00024",
                        ' prévoit qu’il est interdit d’y puiser le moindre renseignement contre les parties, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00025",
                        'à peine de poursuites disciplinaires pour les avocats et les magistrats.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00026",
                      'Lorsque l’annulation est partielle, les actes ou pièces de la procédure sont « cancellés » : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00027",
                      'ils sont rayés ou bâtonnés de manière à devenir matériellement illisibles. Avant cette ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00028",
                      'opération, une copie certifiée conforme à l’original est établie et classée au greffe de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00029",
                      'cour d’appel, afin de conserver une trace archivée de la pièce annulée sans qu’elle puisse ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00030",
                      'être utilisée contre les parties.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ================= CARD 2 — EFFETS POUR LES PARTIES =================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
              "f00031",
              '2.2.2 – Les effets pour les parties',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00032",
                        'Les effets de la nullité pour les parties sont étroitement liés au mécanisme de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00033",
                        '« purge successive » des nullités qui peuvent affecter une information. ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00034",
                    'L’Article 174 alinéa 1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00035",
                    ' et la jurisprudence organisent cette purge aﬁn d’éviter les manœuvres dilatoires.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00036",
                  'Organisation des moyens de nullité par les parties',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00037",
                        'En principe, la partie requérante doit présenter ses moyens de nullité dans sa requête motivée. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00038",
                        'Les autres parties formulent leurs moyens dans les mémoires qu’elles peuvent déposer en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00039",
                    'l’Article 198 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00040",
                    ' qui organise la production des mémoires devant la chambre de l’instruction.',
                  ),
                ),
              ]),
              const SizedBox(height: 6),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00041",
                      'À compter du 30 septembre 2025, le dernier mémoire déposé par une partie devra récapituler ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00042",
                      'l’ensemble des moyens pris de la nullité de la procédure. À défaut, ces moyens sont réputés ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00043",
                      'avoir été abandonnés. Cette exigence renforce la logique de concentration des moyens.',
                    ),
              ),

              const SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00044",
                  'Jusqu’au jour de l’audience, les parties peuvent produire des mémoires qu’elles communiquent au ministère public et aux autres parties.',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00045",
                  'Lors des débats devant la chambre de l’instruction, chacune des parties peut encore développer tout moyen de nullité dont elle se prévaut.',
                ),
              ),

              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                  "f00046",
                  'Limites temporelles : ce qui ne peut plus être soulevé',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00047",
                      'Après la clôture des débats devant la chambre de l’instruction, les parties qui avaient la possibilité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00048",
                      'de connaître les nullités entachant la procédure antérieure à la saisine ne peuvent plus soulever de nouveaux moyens de ce chef. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00049",
                      'Seules les personnes devenues parties à la procédure après cette saisine conservent la possibilité d’invoquer des nullités antérieures.',
                    ),
              ),

              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00050",
                    'Ce mécanisme reprend le principe posé par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                    "f00051",
                    'l’Article 595 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00052",
                        ' : lorsque la chambre de l’instruction statue sur le règlement d’une procédure autre que criminelle, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00053",
                        'les moyens pris de nullité doivent lui avoir été proposés pour être ensuite recevables devant la chambre criminelle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                        "f00054",
                        'de la Cour de cassation.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00055",
                      'Ce dispositif vise clairement à éviter les manœuvres dilatoires de certaines parties. Il interdit en pratique ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00056",
                      'les saisines répétées et tardives de la chambre de l’instruction fondées sur des irrégularités qui auraient pu être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00057",
                      'invoquées plus tôt, et sécurise ainsi la progression de la procédure pénale.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
              "f00058",
              'À RETENIR',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00059",
                      'La nullité d’un acte de procédure n’est jamais neutre : elle purge le dossier de toutes les traces ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00060",
                      'juridiques exploitables de l’acte annulé, encadre la manière dont les parties peuvent organiser et présenter ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00061",
                      'leurs moyens, et verrouille la possibilité de revenir indéfiniment sur les mêmes irrégularités. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00062",
                      'Les Articles 174, 198 et 595 du Code de Procédure Pénale constituent des repères essentiels pour comprendre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_effets_nullite_page.dart",
                      "f00063",
                      'l’articulation entre effets sur la procédure et effets sur les droits des parties.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
//                   TES WIDGETS PERSONNALISÉS EXACTS                       ///
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
