import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CasqueCyclistePage extends StatelessWidget {
  const CasqueCyclistePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/casque_cycliste';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _boldSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(fontWeight: FontWeight.w900),
  );

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
            "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
            "f00002",
            "Équipements",
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
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00003",
              'Casque de protection "cycliste"',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Présentation / idée clé
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00004",
              "À retenir",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00005",
                      "En circulation, les enfants de moins de 12 ans (conducteur ou passager) doivent porter un casque ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00006",
                      "« cycliste » conforme (marquage CE) et attaché.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00007",
                      "⚠️ Le mémento précise que le non-respect de cette obligation par le mineur n’est pas réprimé : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00008",
                      "la verbalisation vise surtout les obligations des majeurs (transport/accompagnement).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                    "f00010",
                    "R. 431-1-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00011",
                  "Définition du casque",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00012",
                      "Casque de protection « cycliste » conforme (marquage CE) et attaché.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00014",
                  "A) Qui doit porter le casque ?",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00015",
                      "En circulation : conducteur et passager d’un cycle âgés de moins de 12 ans.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00016",
                      "Le casque doit être conforme (marquage CE) et attaché.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00017",
                  "Point important",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00018",
                      "Le mémento indique que le non-respect de cette obligation par le mineur n’est pas réprimé.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00019",
                  "B) Obligations des personnes majeures",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00020",
                      "La verbalisation vise les obligations mises à la charge des adultes :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00021",
                      "• conducteur majeur transportant un passager < 12 ans ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00022",
                      "• accompagnateur majeur encadrant un ou plusieurs enfants < 12 ans conducteurs d’un cycle.",
                    ),
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00023",
                  "Conducteur majeur (transport d’un passager < 12 ans)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00024",
                      "S’assurer que le passager est coiffé d’un casque conforme et attaché — ",
                    ),
                  ),
                  _boldSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00025",
                      "NATINF 32253",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00026",
                  "Accompagnateur majeur (enfant(s) < 12 ans conducteurs)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00027",
                      "S’assurer que chacun est coiffé d’un casque conforme et attaché — ",
                    ),
                  ),
                  _boldSpan(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00028",
                      "NATINF 32254",
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00029",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00030",
                      "Manquement d’un majeur à son obligation de s’assurer du port effectif du casque (conforme et attaché) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                      "f00031",
                      "dans les situations prévues : transport d’un passager mineur < 12 ans, ou accompagnement d’un mineur < 12 ans conducteur.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00032",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00033",
                  "Aucune circonstance aggravante spécifique n’est mentionnée dans l’extrait du mémento.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00034",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                    "f00035",
                    "Base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                    "f00036",
                    "R. 431-1-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00037",
                  "Contravention (AF min. 4e classe) pour les obligations des majeurs.",
                ),
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00038",
                  "D.I.A. et dépistage stupéfiants : facultatifs (mention mémento).",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _boldSpan("32253"),
                  const TextSpan(text: " • "),
                  _boldSpan("32254"),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
              "f00039",
              "VI — Tentative & complicité",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00040",
                  "Tentative : NON (contravention liée à un manquement constaté).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/casque_cycliste_page.dart",
                  "f00041",
                  "Complicité : NON (obligation personnelle du majeur dans les cas prévus).",
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
