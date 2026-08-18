import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PneumatiquesPage extends StatelessWidget {
  const PneumatiquesPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/pneumatiques';

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
    final Color cardExigences = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMontage = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardHiver = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardInfra = isDark
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
            "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
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
              "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
              "f00003",
              "Les pneumatiques",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / idée générale
          _ConditionCard(
            title: "Objectif",
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00004",
                      "Les pneumatiques doivent garantir l’adhérence et la sécurité. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00005",
                      "Leur état et leur montage sont encadrés par le Code de la route : usure, déchirures, toile apparente, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00006",
                      "profondeur de sculptures, et règles de montage par essieu.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
              "f00007",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00008",
                    "R. 314-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00009",
                    "R. 314-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00010",
                    "Référence mémento : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00011",
                    "NATINF 6124",
                  ),
                ),
                const TextSpan(text: " et "),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00012",
                    "NATINF 22622",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00013",
                    " (montage).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Exigences techniques (R.314-1)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
              "f00014",
              "II — Exigences des pneumatiques",
            ),
            cardColor: cardExigences,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00015",
                  "A) État général obligatoire",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00016",
                  "Sculptures apparentes sur toute la surface de roulement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00017",
                  "Aucune toile ne doit apparaître (ni en surface, ni à fond de sculptures).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00018",
                  "Aucune déchirure profonde sur les flancs.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00019",
                  "B) Profondeur minimale des rainures",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00020",
                  "Au moins 1,6 mm dans les rainures principales de la bande de roulement.",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00021",
                  "Pour les véhicules de PTAC > 3,5 T : profondeur minimale de 1 mm.",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                          "f00022",
                          "Des indicateurs d’usure (dans les rainures principales) permettent de constater l’usure maximum autorisée ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                          "f00023",
                          "sur les voitures particulières et leurs remorques.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Montage interdit (R.314-1) + pneus interdits
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
              "f00024",
              "III — Montage interdit / pneus interdits",
            ),
            cardColor: cardMontage,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00025",
                  "A) Différences de structure ou de type (même essieu)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00026",
                    "Il est interdit de monter sur un même essieu deux pneumatiques de structures ou de type différents (voir ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00027",
                    "NATINF 22622",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00028",
                      "Exemples :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00029",
                      "• Structure : radial (lettre « R »)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00030",
                      "• Type : dimension (ex. 195/65R15), catégorie (neige), code vitesse, indice de charge…",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00031",
                      "Une dérogation temporaire est possible lorsqu’il est fait usage du pneumatique de secours.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00032",
                  "B) Marquages explicitement interdits",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00033",
                  "Pneumatiques portant les indications : Max. 30 km/h, Max. 10 km/h, TA, AGRI ou AGRO.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Dispositions hivernales (R.314-3)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
              "f00034",
              "IV — Période hivernale & massifs montagneux",
            ),
            cardColor: cardHiver,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00035",
                    "Dispositions particulières du 1er novembre au 31 mars (année suivante) — communes désignées par arrêté préfectoral. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00036",
                    "Référence : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00037",
                    "R. 314-3 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00038",
                  "A) Véhicules sans remorque (règle générale)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00039",
                      "À compter du 1er novembre 2021, le conducteur :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00040",
                      "• d’un véhicule de transport de personnes (8 places maxi + conducteur),\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00041",
                      "• d’un véhicule utilitaire léger,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00042",
                      "• d’un véhicule de transport en commun de personnes,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00043",
                      "• ou d’un véhicule de transport de marchandises de PTAC > 3,5 T,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00044",
                      "sans remorque ni semi-remorque, doit :",
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00045",
                  "Soit détenir des dispositifs antidérapants amovibles (chaînes/chaussettes) pour équiper au moins 2 roues motrices.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00046",
                  "Soit conduire un véhicule équipé de 4 pneumatiques « hiver ».",
                ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00047",
                  "B) PTAC > 3,5 T avec remorque ou semi-remorque",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00048",
                      "Doit détenir des dispositifs antidérapants amovibles pour équiper au moins 2 roues motrices, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00049",
                      "que le véhicule soit équipé ou non de pneumatiques hiver.",
                    ),
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00050",
                  "C) Chaînes & pneus à clous",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00051",
                      "Pneumatiques à clous (dispositifs inamovibles) autorisés uniquement pendant la période hivernale ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00052",
                      "(VP, VUL, véhicules de transport en commun).",
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00053",
                  "L’usage des chaînes n’est autorisé que sur routes enneigées.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00054",
                    "Référence : ",
                  ),
                ),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00055",
                    "NATINF 6125",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions / constatation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
              "f00056",
              "V — Infractions & constatation",
            ),
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00057",
                    "NATINF 6124",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00058",
                    " — Circulation avec pneumatique lisse, déchiré ou dont la toile est apparente.",
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00059",
                    "NATINF 22622",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00060",
                    " — Circulation avec pneumatique interdit ou irrégulièrement monté.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00061",
                    "Base légale : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00062",
                    "R. 314-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: " ("),
                _boldSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                    "f00063",
                    "AF min. 4e classe",
                  ),
                ),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00064",
                  "Immobilisation possible.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00065",
                  "D.I.A. et dépistage stupéfiants : facultatifs.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00066",
                      "Plusieurs pneumatiques non conformes sur un même véhicule = une seule contravention ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00067",
                      "(Cass. crim., 25/05/1994)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                  "f00068",
                  "Bon réflexe P.V.",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/equipements/pneumatiques_page.dart",
                      "f00069",
                      "Noter au P.V. le n° du (des) pneumatique(s) non conforme(s) (n° gravé sur le flanc du pneu).",
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
