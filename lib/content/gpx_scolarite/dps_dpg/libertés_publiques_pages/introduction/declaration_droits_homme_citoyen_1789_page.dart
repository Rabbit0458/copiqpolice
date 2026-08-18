import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class DeclarationDroitsHommeCitoyen1789Page extends StatelessWidget {
  const DeclarationDroitsHommeCitoyen1789Page({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardPreambule = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardPrincipes = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardArticles = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardSynthese = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);

    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
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
            "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
            "f00002",
            "Libertés publiques",
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
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
              "f00003",
              "Déclaration des droits de l’Homme et du Citoyen — 26 août 1789",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ===================== CONTEXTE =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
              "f00004",
              "Repères",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                      "f00005",
                      "Texte fondateur de la Révolution française, la Déclaration des droits de l’Homme et du Citoyen ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                      "f00006",
                      "(DDHC) affirme des droits « naturels, inaliénables et sacrés ». ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                      "f00007",
                      "Elle fixe des principes de valeur constitutionnelle, au cœur des libertés publiques.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== PRÉAMBULE =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
              "f00008",
              "Préambule — idées clés",
            ),
            cardColor: cardPreambule,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00009",
                  "L’ignorance, l’oubli ou le mépris des droits de l’Homme sont présentés comme causes des malheurs publics et de la corruption des gouvernements.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00010",
                  "But : exposer solennellement les droits afin qu’ils restent présents à tous, rappellent droits et devoirs, et servent de référence au pouvoir législatif et exécutif.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00011",
                  "Les réclamations des citoyens doivent désormais être fondées sur des principes simples et incontestables, orientés vers la Constitution et le bonheur de tous.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== PRINCIPES STRUCTURANTS =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
              "f00012",
              "Principes structurants",
            ),
            cardColor: cardPrincipes,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00013",
                  "Les droits naturels protégés",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00014",
                  "Liberté — propriété — sûreté — résistance à l’oppression.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00015",
                  "La souveraineté",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00016",
                    "Le principe de toute souveraineté réside dans la nation — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00017",
                    "Art. 3",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00018",
                  "La loi comme référence",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00019",
                    "La loi encadre l’exercice des libertés : elle fixe les bornes nécessaires pour permettre à chacun la jouissance des mêmes droits — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00020",
                    "Art. 4",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00021",
                    "Elle ne doit défendre que les actions nuisibles à la société — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00022",
                    "Art. 5",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== ARTICLES (SÉLECTION) =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
              "f00023",
              "Articles essentiels (sélection pédagogique)",
            ),
            cardColor: cardArticles,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00024",
                    "Art. 1",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00025",
                    " : les hommes naissent et demeurent libres et égaux en droits ; les distinctions sociales ne peuvent être fondées que sur l’utilité commune.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00026",
                    "Art. 2",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00027",
                    " : but de toute association politique = conservation des droits naturels et imprescriptibles (liberté, propriété, sûreté, résistance à l’oppression).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00028",
                    "Art. 6",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00029",
                    " : la loi est l’expression de la volonté générale ; elle doit être la même pour tous ; accès aux emplois publics selon capacité, vertus et talents.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00030",
                    "Art. 7",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00031",
                    " : nul ne peut être accusé, arrêté ou détenu que dans les cas déterminés par la loi et selon les formes qu’elle a prescrites.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00032",
                    "Art. 8",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00033",
                    " : la loi ne doit établir que des peines strictement et évidemment nécessaires ; principe de légalité des délits et des peines.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00034",
                    "Art. 9",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00035",
                    " : présomption d’innocence ; toute rigueur non nécessaire doit être sévèrement réprimée par la loi.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00036",
                    "Art. 10",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00037",
                    " : liberté d’opinion (même religieuse) tant que la manifestation ne trouble pas l’ordre public établi par la loi.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00038",
                    "Art. 11",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00039",
                    " : libre communication des pensées et opinions ; chacun peut parler, écrire, imprimer librement (sauf abus prévus par la loi).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00040",
                    "Art. 16",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00041",
                    " : une société sans garantie des droits et sans séparation des pouvoirs n’a point de constitution.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00042",
                    "Art. 17",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                    "f00043",
                    " : propriété = droit inviolable et sacré ; privation possible seulement par nécessité publique, légalement constatée, et sous juste et préalable indemnité.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== SYNTHÈSE OPÉRATIONNELLE =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
              "f00044",
              "À retenir (synthèse)",
            ),
            cardColor: cardSynthese,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00045",
                  "La DDHC pose des droits fondamentaux et des garanties contre l’arbitraire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00046",
                  "La loi encadre les libertés : elle autorise, limite et sanctionne uniquement ce qui est nécessaire à la vie sociale.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                  "f00047",
                  "Principes clés : égalité, souveraineté nationale, légalité, présomption d’innocence, libertés d’opinion et d’expression.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/libertés_publiques_pages/introduction/declaration_droits_homme_citoyen_1789_page.dart",
                      "f00048",
                      "En libertés publiques, ce texte sert de base de lecture : toute restriction doit être justifiée, encadrée et proportionnée, sous le contrôle du juge.",
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
