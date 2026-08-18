import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AgentsVerbalisateursCirculationPage extends StatelessWidget {
  const AgentsVerbalisateursCirculationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/socle_initial/circulation/agents_verbalisateurs';

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

    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);

    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);

    final Color cardTypes = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

    final Color cardProb = isDark
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
            "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
            "f00002",
            "Circulation routière",
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
              "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
              "f00003",
              "Compétence des agents verbalisateurs\n(en matière de circulation routière)",
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
              "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
              "f00004",
              "Cadre général",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00005",
                      "Le formalisme procédural de constatation (procès-verbal ou rapport) des infractions routières ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00006",
                      "varie selon la nature de l’infraction (délit ou contravention) et la qualification judiciaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00007",
                      "de l’agent verbalisateur.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00008",
                      "Le non-respect de ces règles peut modifier la valeur probante de l’acte rédigé ou entraîner ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00009",
                      "la nullité de la procédure.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (article(s) en rouge)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
              "f00010",
              "I — Fondement légal (compétence générale)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00011",
                    "Articles 12 et 14 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00012",
                    " : définissent la mission de police judiciaire et la compétence générale pour rechercher et constater les infractions.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00013",
                    "Article 21 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00014",
                    " : encadre l’action des agents de police judiciaire (APJ) dans la constatation des infractions.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00015",
                    "Article 21-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00016",
                    " : fixe les règles relatives aux agents de police judiciaire adjoints (APJA).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00017",
                    "Article 429 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00018",
                    " : précise la valeur probante des procès-verbaux et rapports (régularité, compétence, constatations personnelles).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
              "f00019",
              "II — Recherche & constatation des infractions routières",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00020",
                      "Les O.P.J., A.P.J. et A.P.J.A. disposent d’une compétence générale pour rechercher et constater ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00021",
                      "les infractions, conformément au code de procédure pénale.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00022",
                      "La constatation des délits et contraventions en matière de circulation routière ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00023",
                      "(code de la route, code des assurances, code de la voirie routière, réglementation des transports routiers) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00024",
                      "relève également de leur compétence.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00025",
                      "D’autres agents d’administrations (ex : gardes champêtres, contrôleurs des transports terrestres, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00026",
                      "agents des douanes) peuvent aussi constater certaines infractions routières.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
              "f00027",
              "III — Formes procédurales de constatation",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00028",
                      "Le code de procédure pénale confère aux O.P.J., A.P.J. et A.P.J.A. une compétence générale ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00029",
                      "pour constater les infractions à la loi pénale, y compris celles du domaine routier.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00030",
                  "Qui peut rédiger quoi ? (règles essentielles)",
                ),
              ),
              SizedBox(height: 6),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00031",
                  "OPJ : procès-verbal « ordinaire » ou PVe — délits et contraventions à la circulation routière.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00032",
                  "APJ : procès-verbal « ordinaire » ou PVe — contraventions au code de la route dont la liste est fixée par le code de la route.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00033",
                  "APJA (policiers adjoints / réservistes opérationnels non OPJ ou APJ) : rapport — notamment pour les contraventions pour lesquelles ils ne sont pas autorisés à dresser procès-verbal.",
                ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00034",
                      "En dehors de leur ressort territorial, les OPJ, APJ et APJA peuvent rendre compte par rapport au procureur de la République compétent de toute infraction dont ils ont été témoins.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
              "f00035",
              "IV — Deux types de procès-verbaux utilisés",
            ),
            cardColor: cardTypes,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00036",
                  "1) Procès-verbal électronique (PVe)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00037",
                      "Toutes les contraventions soumises à la procédure de l’amende forfaitaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00038",
                      "(ex : stationnement, vitesse, équipements…) peuvent être relevées au moyen d’appareils électroniques sécurisés.",
                    ),
              ),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00039",
                  "Terminal mobile NEO 2 (smartphone/tablette) : appareil portatif avec écran tactile permettant notamment de recueillir la signature du contrevenant.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00040",
                  "IHM web (interface homme-machine/web) : application informatique permettant notamment de constater certaines infractions au service (ex : non justification dans les 5 jours de l’attestation d’assurance).",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00041",
                      "L’application PVe automatise et dématérialise la procédure, de la constatation à l’envoi de l’avis de contravention ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00042",
                      "au domicile du contrevenant (ou du titulaire du certificat d’immatriculation) par le centre national de traitement de Rennes.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00043",
                  "2) Procès-verbal « ordinaire »",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00044",
                  "Le procès-verbal « ordinaire », rédigé via le logiciel de rédaction de procédure, est utilisé pour constater :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00045",
                  "Les délits.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00046",
                  "Les contraventions non forfaitisées (plusieurs infractions simultanées dont au moins une ne peut donner lieu à amende forfaitaire).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00047",
                  "Les contraventions de 5e classe, et celles de 4e classe entraînant S.P.C. sur instructions du parquet.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
              "f00048",
              "V — Valeur probante des actes",
            ),
            cardColor: cardProb,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(text: "Selon "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00049",
                    "l’article 429 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                        "f00050",
                        ", le procès-verbal ou le rapport n’a valeur probante que s’il est régulier en la forme, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                        "f00051",
                        "si l’auteur agit dans l’exercice de ses fonctions et rapporte, sur une matière de sa compétence, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                        "f00052",
                        "ce qu’il a vu, entendu ou constaté personnellement.",
                      ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00053",
                  "1) Délits",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00054",
                    "Les procès-verbaux et rapports constatant les délits ne valent qu’à titre de simples renseignements — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00055",
                    "article 430 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                  "f00056",
                  "2) Contraventions",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00057",
                    "En règle générale, les procès-verbaux et rapports constatant les contraventions font foi jusqu’à preuve contraire — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00058",
                    "article 537 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00059",
                    "En matière routière, les agents verbalisateurs autres que les OPJ et APJ doivent être assermentés afin que les procès-verbaux conservent leur valeur probante — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00060",
                    "article L. 130-7 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                    "f00061",
                    "article 537 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00062",
                      "La prestation de serment initiale des APJA n’a pas à être renouvelée en cas de changement de lieu d’affectation.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00063",
                      "Le défaut d’assermentation modifie la force probante : l’acte ne fait plus foi jusqu’à preuve contraire, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                      "f00064",
                      "mais ne vaut qu’à titre de simples renseignements.",
                    ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                          "f00065",
                          "Tout procès-verbal doit être soigneusement rédigé en respectant le formalisme imposé. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/agents_verbalisateurs_circulation_page.dart",
                          "f00066",
                          "Les erreurs (date, lieu, chiffres, immatriculation, etc.) peuvent créer un doute et conduire à l’annulation de la procédure.",
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
