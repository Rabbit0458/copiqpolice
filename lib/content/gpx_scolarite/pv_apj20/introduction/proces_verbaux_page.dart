import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PVProcesVerbauxPage extends StatelessWidget {
  const PVProcesVerbauxPage({super.key});

  static const String routeName = '/gpx/pv_apj20/introduction/proces_verbaux';

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
    final Color cardValue = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRedac = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardStruct = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
            "f00002",
            "PV — APJ 20",
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
              "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
              "f00003",
              "Les procès-verbaux",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
              "f00004",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00005",
                    "Article 429 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00006",
                    " : encadre la valeur probante du procès-verbal, qui n’est reconnue que s’il est régulier en la forme, établi par un auteur compétent, dans l’exercice de ses fonctions, et sur une matière de sa compétence (faits vus, entendus ou constatés personnellement).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
              "f00007",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00008",
                  "Le procès-verbal est un acte écrit, rédigé et signé par un magistrat, un officier ou un agent de police judiciaire, agissant conformément aux règles de leur compétence, et dans le cadre d’une mission de police judiciaire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Valeur des PV (articles 430, 431, 433)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
              "f00009",
              "II — La valeur des procès-verbaux",
            ),
            cardColor: cardValue,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "Principe",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                      "f00010",
                      "Sauf disposition contraire, ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                      "f00011",
                      "les procès-verbaux et rapports constatant les délits",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                      "f00012",
                      " ne valent qu’à titre de simples renseignements — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                      "f00013",
                      "article 430 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00014",
                  "A) PV valant simples renseignements",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00015",
                    "Article 430 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00016",
                    " : en enquête de flagrance (sauf loi spéciale), en enquête préliminaire ou en exécution d’une commission rogatoire, les PV n’apportent pas de valeur probante aux faits relatés : ils jouent un rôle d’information.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00017",
                  "Conséquence : le juge apprécie librement, le PV informe mais ne « prouve » pas à lui seul.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00018",
                  "B) PV valant jusqu’à preuve contraire",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00019",
                    "Article 431 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00020",
                    " : une disposition expresse de la loi peut conférer au PV une force probante renforcée. La preuve contraire ne peut alors être apportée que par écrit ou par témoins (ex. : dispositions spéciales, comme certains domaines du droit du travail).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00021",
                  "Règle d’or : le rédacteur relate uniquement ce qu’il a personnellement vu, entendu ou constaté.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00022",
                  "C) PV valant jusqu’à inscription de faux",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00023",
                    "Article 433 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00024",
                    " : certaines matières, prévues par des lois spéciales, donnent lieu à des PV faisant foi jusqu’à inscription de faux (souvent rédigés par des agents spécialisés : douanes, ONF, etc.).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00025",
                  "Autorité",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                      "f00026",
                      "L’autorité de ces PV est très forte : le juge est lié tant que les conditions légales sont réunies (infraction constituée, compétence de l’agent, absence de prescription/amnestie, absence de vice de forme).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Principes de rédaction
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
              "f00027",
              "III — Les principes de rédaction",
            ),
            cardColor: cardRedac,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00028",
                  "A) Principes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00029",
                  "Simultanéité : le PV doit être rédigé « sur-le-champ » ou dès que possible (perquisition, constatations, audition…).",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00030",
                  "Spécificité : traditionnellement, un PV par opération de police judiciaire.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00031",
                    "Article D.11 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00032",
                    " : autorise, en flagrance ou en préliminaire, à relater dans un seul PV les opérations effectuées au cours d’une même enquête (procédure simplifiée : vol à l’étalage, vente à la sauvette, usage de stupéfiants, etc.).",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00033",
                  "Unicité du rédacteur : l’en-tête comporte l’identité du rédacteur (ou R.I.O. selon conditions), grade, service et qualité CPP.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00034",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00035",
                    "articles D.9 et D.10 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00036",
                  "Copie : une copie du PV doit toujours être établie et jointe à l’original destiné au magistrat.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00037",
                    "Article 19 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00038",
                    " : impose la copie jointe à l’original.",
                  ),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00039",
                  "B) Protection du rédacteur & assistants",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00040",
                    "Article 15-3 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00041",
                    " : le rédacteur d’un PV de plainte (OPJ/APJ) peut s’identifier par son numéro d’immatriculation administrative (R.I.O.) sans autorisation préalable.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00042",
                    "Article 15-4 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00043",
                    " : tout agent de la police nationale peut s’identifier par son R.I.O. dans les actes qu’il rédige ou dans lesquels il est cité comme assistant, sans faire apparaître nom et prénom (sous réserve des conditions légales et, dans certains cas, d’une autorisation).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: "But",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                      "f00044",
                      "Cette protection vise les situations où la révélation de l’identité est susceptible de mettre en danger la vie ou l’intégrité physique de l’agent ou de ses proches, compte tenu des conditions d’exercice ou de la nature des faits constatés.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Structure & techniques
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
              "f00045",
              "IV — Structure & techniques de rédaction",
            ),
            cardColor: cardStruct,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00046",
                  "Chaque feuillet du procès-verbal doit être écrit et signé par son rédacteur. Seule la langue française doit être utilisée. Le procès-verbal peut être manuscrit ou dactylographié.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00047",
                  "Les 6 parties du procès-verbal",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00048",
                  "1) Le titre (« PROCÈS-VERBAL »).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00049",
                  "2) L’incipit.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00050",
                  "3) Le corps du procès-verbal.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00051",
                  "4) L’énonciation terminale (clôture).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00052",
                  "5) La marge.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00053",
                  "6) Les mentions et annexes.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00054",
                  "2) L’incipit : contenu attendu",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00055",
                  "Date et heure en toutes lettres.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00056",
                  "Identité du rédacteur : nom/prénom ou R.I.O., grade, qualité, service, résidence.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00057",
                  "Lieu de rédaction.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00058",
                  "Fait / pièce ouvrant la procédure ou motivant l’opération.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00059",
                  "Cadre juridique de l’action de PJ.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00060",
                  "Personnes présentes (assistants, civilement responsable, etc.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00061",
                  "Identité de la personne objet de l’opération (sauf impossibilité).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00062",
                  "Avis aux autorités.",
                ),
              ),

              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00063",
                    "Références R.I.O. : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00064",
                    "articles 15-3 et 15-4 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00065",
                  "3) Le corps : règles pratiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00066",
                  "Relater uniquement ce qui est personnellement vu, constaté ou entendu.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00067",
                  "Temps : présent de l’indicatif ; style : première personne du pluriel.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00068",
                  "Objectivité : reflet fidèle des déclarations enregistrées et des faits constatés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00069",
                  "Questions/Réponses : si utile, inscrire le texte exact des questions et enregistrer la réponse.",
                ),
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00070",
                    "Article 107 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                    "f00071",
                    " : les PV doivent être établis sans interligne, sans rature ni surcharge. Chaque rature/renvoi doit être approuvé en marge. Les blancs peuvent être comblés par des pointillés.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: "NOTA",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                      "f00072",
                      "L’utilisation du L.R.P. permet, en principe, d’éviter ratures et renvois en modifiant le texte directement à l’écran, avec l’accord du déclarant avant impression.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00073",
                  "4) Clôture (énonciation terminale)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00074",
                  "Signatures : rédacteur + assistants mentionnés + déclarant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00075",
                  "Heure de fin : facultative pour la plainte ; mentionnée dans les autres actes mettant en cause un suspect.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00076",
                  "Adapter la formule de clôture : interprète, refus/impossibilité de lecture ou de signature, etc.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00077",
                  "5) La marge : pagination & mentions",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00078",
                  "Pagination : seul le recto est utilisé ; pour les feuillets suivants, documents sans en-tête.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00079",
                  "Rappels en tête : objet de l’acte, n° du registre / n° d’ordre, numéro de feuillet (suite).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00080",
                  "Mentions marginales : N° procédure, cote des PV (1, 2, 3…), affaire (contre X / contre personne dénommée), objet (plainte, audition, perquisition…).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00081",
                  "6) Mentions & annexes",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00082",
                  "Elles indiquent une diligence accessoire en rapport direct avec le PV et la jonction d’un document ou d’une pièce (remise par une personne ou jugée nécessaire à l’enquête).",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00083",
                  "À placer en marge après la clôture, sous la rubrique « MENTION » ou « ANNEXE ».",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "Conclusion",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/introduction/proces_verbaux_page.dart",
                  "f00084",
                  "Outre les principes applicables à tous les procès-verbaux, chaque type de procès-verbal de la procédure de police judiciaire obéit à des règles particulières, qui seront abordées dans l’étude des différents actes.",
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
