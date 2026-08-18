import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — LA LÉGITIME DÉFENSE DES BIENS
///
///  II. La légitime défense d’un bien (art. 122-5 al. 2 C. pén.)
///   - Définition générale
///   - 1) Bien menacé par l’exécution d’un crime ou d’un délit
///   - 2) Acte de défense : strictement nécessaire, autre qu’un homicide
///      volontaire et proportionné à la gravité de l’infraction
/// ===================================================================
class LdBiensPage extends StatelessWidget {
  const LdBiensPage({super.key});

  static const String routeName = '/gpx/generalites/legitime-defense/biens';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : Colors.white;
    final Color card = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);
    final Color accent = isDark
        ? const Color(0xFF1976D2)
        : const Color(0xFF1565C0);
    const Color redAccent = Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
            "f00001",
            'La légitime défense – Biens',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
              "f00002",
              'II. La légitime défense d’un bien\n(Article 122-5 alinéa 2 du Code pénal)',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00003",
                  'N’est pas pénalement responsable la personne qui, pour interrompre ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00004",
                  'l’exécution d’un crime ou d’un délit contre un bien, accomplit un acte ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00005",
                  'de défense, autre qu’un homicide volontaire, lorsque cet acte est ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00006",
                  'strictement nécessaire au but poursuivi, dès lors que les moyens ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00007",
                  'employés sont proportionnés à la gravité de l’infraction.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00008",
                  'La légitime défense des biens est plus limitée que celle des personnes. ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00009",
                  'Elle ne joue que dans des cas précis :',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.3,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),

          _BulletPoint.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                "f00010",
                'Un bien doit être menacé par l’exécution d’un crime ou d’un délit.',
              ),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),
          _BulletPoint.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                "f00011",
                'L’acte de défense doit interrompre cette exécution dans des limites strictes.',
              ),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ]),

          const SizedBox(height: 20),

          // ============================================
          // 1 — LE BIEN MENACÉ PAR L’EXÉCUTION D’UNE INFRACTION
          // ============================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
              "f00012",
              '1. Le bien menacé par l’exécution d’un crime ou d’un délit',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                      "f00013",
                      'La protection porte ici sur les biens (véhicule, commerce, habitation, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                      "f00014",
                      'matériel professionnel, etc.). La légitime défense n’est ouverte que ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                      "f00015",
                      'si le bien est menacé par l’exécution d’un crime ou d’un délit.',
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                    "f00016",
                    'Infraction visée : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00017",
                        'l’atteinte doit être un crime ou un délit contre un bien ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00018",
                        '(vol, dégradation grave, destruction, pillage…). Les simples ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00019",
                        'contraventions ne suffisent pas.',
                      ),
                ),
              ]),
              SizedBox(height: 6),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                    "f00020",
                    'Moment : ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00021",
                        'l’infraction doit être en cours d’exécution ou sur le point ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00022",
                        'd’être commise ; la défense vise à interrompre ou empêcher ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00023",
                        'la réalisation de cette infraction.',
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00024",
                          'Un commerçant surprend de nuit plusieurs individus en train de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00025",
                          'forcer le rideau métallique de sa boutique. Il intervient pour ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00026",
                          'les faire fuir en utilisant un moyen de défense mesuré : le bien ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00027",
                          'est directement menacé par l’exécution d’un délit.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ============================================
          // 2 — L’ACTE DE DÉFENSE SUR LES BIENS
          // ============================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
              "f00028",
              '2. L’acte de défense sur les biens',
            ),
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                      "f00029",
                      'La réaction de la personne poursuivie doit respecter trois conditions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                      "f00030",
                      'cumulatives pour être couverte par la légitime défense des biens.',
                    ),
              ),
              SizedBox(height: 10),

              // STRICTEMENT NÉCESSAIRE
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                    "f00031",
                    '« STRICTEMENT » NÉCESSAIRE',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00032",
                        ' : l’acte de défense doit être rigoureusement adapté au but ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00033",
                        'poursuivi (interrompre l’infraction). Il ne doit pas aller au-delà ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00034",
                        'de ce qui est indispensable pour empêcher le crime ou le délit.',
                      ),
                ),
              ]),

              // AUTRE QU’UN HOMICIDE VOLONTAIRE
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                    "f00035",
                    'AUTRE QU’UN HOMICIDE VOLONTAIRE',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00036",
                        ' : le législateur considère qu’aucun crime ou délit contre un bien, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00037",
                        'aussi grave soit-il, ne peut justifier de donner volontairement la mort ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00038",
                        'à une personne.',
                      ),
                ),
              ]),

              // PROPORTIONNÉE
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                    "f00039",
                    'PROPORTIONNÉE',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00040",
                        ' : les moyens employés doivent rester en rapport avec la gravité ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00041",
                        'de l’infraction. Une défense manifestement excessive ne sera pas ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                        "f00042",
                        'couverte par la légitime défense.',
                      ),
                ),
              ]),

              SizedBox(height: 10),

              _ExempleBox(
                title: 'Exemples',
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                      "f00043",
                      '• Un propriétaire déclenche l’alarme, crie et repousse un intrus en le poussant hors de son garage : la défense est strictement nécessaire et proportionnée.\n',
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00044",
                          '• En revanche, tirer avec une arme à feu sur un voleur en fuite ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00045",
                          'pour protéger un simple bien matériel ne respecte ni la condition ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00046",
                          'd’homicide exclu, ni celle de proportionnalité.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                  "f00047",
                  'Charge de la preuve',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00048",
                          'Il appartient souvent à la personne poursuivie de démontrer que ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00049",
                          'le principe de proportionnalité a été respecté. La jurisprudence ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00050",
                          'impose un contrôle strict : la défense d’un bien ne doit jamais ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/legitime_defense/ld_biens_page.dart",
                          "f00051",
                          'mettre en jeu de manière excessive la vie ou l’intégrité des personnes.',
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

/// ------------------------------------------------------------------
/// CARTE HYPOTHÈSE
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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

/// ------------------------------------------------------------------
/// PARAGRAPHE SIMPLE / RICH
/// ------------------------------------------------------------------
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
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  final List<InlineSpan> spans;

  const _BulletPoint.rich(this.spans);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA
/// ------------------------------------------------------------------
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
