import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaClassificationMesuresSuretePage extends StatelessWidget {
  const PaClassificationMesuresSuretePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/classification_peines/classification_mesures_surete';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    const lawRed = Color(0xFFE53935);

    Color cardBg(Color light, Color dark) => isDark ? dark : light;

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
            "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
            "f00002",
            "Mesures de sûreté",
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
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
              "f00003",
              "La classification des mesures de sûreté",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.12,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
              "f00004",
              "Définition et logique générale",
            ),
            cardColor: cardBg(const Color(0xFFF6F7FB), const Color(0xFF2B2B2B)),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00005",
                      "La mesure de sûreté a un but préventif : elle cherche à éviter la survenance ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00006",
                      "d’infractions en neutralisant, surveillant ou traitant les individus susceptibles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00007",
                      "d’être dangereux.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00008",
                      "Les mesures de sûreté ne font pas l’objet d’un titre unique du code pénal. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00009",
                      "Elles sont éparses, et il paraît difficile d’en faire un véritable inventaire.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
              "f00010",
              "Chapitre 1 — Les mesures de sûreté curatives",
            ),
            cardColor: cardBg(const Color(0xFFEFF7FF), const Color(0xFF263244)),
            accent: const Color(0xFF42A5F5),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00011",
                  "Elles concernent essentiellement les alcooliques et toxicomanes.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00012",
                  "1.1 — Le contrôle judiciaire",
                ),
              ),
              _Paragraph.rich([
                TextSpan(text: "Seul "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00013",
                    "l’article 138 10° du C.P.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00014",
                        " prévoit, dans le cadre du contrôle judiciaire, l’obligation pour la personne ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00015",
                        "de se soumettre à des mesures de traitement ou de soins, notamment aux fins ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00016",
                        "de désintoxication.",
                      ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00017",
                  "1.2 — Les mesures thérapeutiques",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00018",
                      "Le législateur a mis en place un système qui donne la priorité aux mesures ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00019",
                      "thérapeutiques sur les sanctions pénales. Une injonction thérapeutique est prévue.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
              "f00020",
              "Chapitre 2 — Les mesures de surveillance",
            ),
            cardColor: cardBg(const Color(0xFFFFF8E1), const Color(0xFF2F2A1B)),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00021",
                  "2.1 — Le suivi socio-judiciaire",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00022",
                    "Le suivi socio-judiciaire (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00023",
                    "art. 131-36-1 à 131-36-8 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00024",
                        ") oblige le condamné, majeur ou mineur ayant commis des infractions de nature ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00025",
                        "sexuelle ou des violences, à se soumettre, sous le contrôle du juge de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00026",
                        "l’application des peines, à des mesures de surveillance et d’assistance pendant ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00027",
                        "une durée fixée par la juridiction de jugement.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00028",
                  "Peut être assorti d’une injonction de soins si cela est bénéfique au condamné.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00029",
                  "Peut être assorti d’un placement sous surveillance électronique mobile (décidé par la juridiction ou ultérieurement par le JAP).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00030",
                  "2.2 — La surveillance judiciaire des personnes dangereuses",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00031",
                    "Cette mesure prévue à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00032",
                    "l’article 723-29 du C.P.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00033",
                        " vise à prévenir la récidive lorsque le risque paraît avéré. Elle peut être ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00034",
                        "prononcée notamment pour des auteurs condamnés à une peine privative de liberté ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00035",
                        "d’une durée égale ou supérieure à sept ans (si le suivi socio-judiciaire était encouru ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00036",
                        "mais n’a pas été prononcé) ou d’une durée supérieure ou égale à cinq ans en cas de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00037",
                        "récidive légale. Dans son contenu, elle ressemble au suivi socio-judiciaire.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
              "f00038",
              "Chapitre 3 — Mesures de sûreté portant atteinte à la liberté",
            ),
            cardColor: cardBg(const Color(0xFFF3E5F5), const Color(0xFF2D2230)),
            accent: const Color(0xFF8E24AA),
            titleColor: isDark ? Colors.white : const Color(0xFF4A148C),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00039",
                  "3.1 — Mesures applicables aux mineurs",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00040",
                      "Le code de la justice pénale des mineurs érige en principe fondamental la primauté ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00041",
                      "de la réponse éducative sur la réponse répressive.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00042",
                  "3.1.1 — La mesure éducative judiciaire provisoire (M.E.J.P.)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00043",
                    "La M.E.J.P. (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00044",
                    "art. L323-1 à L323-3 du C.J.P.M.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00045",
                        ") peut être prise à tout moment au cours de la procédure, avant le prononcé de la ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00046",
                        "sanction, pour une durée d’un an renouvelable (",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00047",
                    "art. L432-2 du C.J.P.M.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00048",
                    "). Elle est modulable selon les besoins et l’évolution du mineur.",
                  ),
                ),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00049",
                  "3.1.2 — Mesures d’investigation et de sûreté",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00050",
                  "La M.E.J.P. peut s’accompagner d’une mesure judiciaire d’investigation éducative (M.J.I.E.) : évaluation approfondie et interdisciplinaire de la personnalité et de la situation du mineur.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00051",
                  "Placement sous contrôle judiciaire possible avec obligations/interdictions (lieux, contacts…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00052",
                  "Avant jugement : assignation à résidence avec surveillance électronique ou détention provisoire (sous conditions).",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00053",
                  "3.1.3 — Rétention et surveillance de sûreté",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00054",
                      "La loi du 25 février 2008 n’exclut pas les mineurs du dispositif de protection ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00055",
                      "contre les criminels dangereux.",
                    ),
              ),

              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00056",
                  "3.2 — Mesures applicables aux majeurs",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00057",
                  "3.2.1 — Interdiction de séjour",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00058",
                    "Défense de paraître dans certains lieux, avec mesures de surveillance et d’assistance (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00059",
                    "art. 131-31 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00060",
                  "3.2.2 — Interdiction de manifester",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00061",
                    "Défense de manifester sur la voie publique dans certains lieux, pour une durée ≤ 3 ans (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00062",
                    "art. 131-32-1 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: ")."),
              ]),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00063",
                  "3.2.3 — Mesures concernant les étrangers",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00064",
                  "Interdiction du territoire",
                ),
              ),
              _BulletPoint(text: "Expulsion"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00065",
                  "Assignation à résidence",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00066",
                  "Assignation à résidence avec surveillance électronique mobile",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00067",
                  "Obligation de quitter le territoire",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00068",
                  "Rétention administrative",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00069",
                  "3.2.4 — Obligation d’accomplir un stage",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00070",
                    "But : prévenir la réitération des comportements dangereux ou inciviques (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00071",
                    "art. 131-5-1 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00072",
                  "Stage de citoyenneté",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00073",
                  "Stage de sensibilisation à la sécurité routière",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00074",
                  "Stage de sensibilisation aux dangers de l’usage de stupéfiants",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00075",
                  "Stage de responsabilisation pour la prévention et la lutte contre les violences au sein du couple et sexistes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00076",
                  "Stage de sensibilisation à la lutte contre l’achat d’actes sexuels",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00077",
                  "Stage de responsabilité parentale",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00078",
                  "Stage de lutte contre le sexisme et sensibilisation à l’égalité femmes-hommes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00079",
                  "Stage de sensibilisation à la prévention et à la lutte contre la maltraitance animale",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00080",
                  "Stage de sensibilisation au respect des personnes dans l’espace numérique et à la prévention des infractions commises en ligne (dont cyberharcèlement)",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00081",
                  "3.2.5 — Interdictions et restrictions",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00082",
                    "Ensemble d’interdictions pouvant être prononcées (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00083",
                    "art. 131-6 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00084",
                    "). Exemples :",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00085",
                  "Interdictions professionnelles / d’exercer des fonctions publiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00086",
                  "Suspension / annulation du permis de conduire",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00087",
                  "Interdiction de conduire certains véhicules",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00088",
                  "Confiscation / immobilisation de véhicules",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00089",
                  "Confiscation / interdiction de port et détention d’armes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00090",
                  "Retrait du permis de chasser",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00091",
                  "Interdiction d’émettre des chèques / d’utiliser des cartes de paiement",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00092",
                  "Confiscation de la chose ayant servi / destinée / produit",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00093",
                  "Interdiction de paraître en certains lieux",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00094",
                  "Interdiction de fréquenter ou d’entrer en relation avec certaines personnes",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00095",
                  "3.2.6 — Hospitalisation complète pour trouble mental",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00096",
                    "Admission en soins psychiatriques sous forme d’hospitalisation complète possible (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00097",
                    "art. 706-135 C.P.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00098",
                    "). D’autres mesures peuvent être prononcées : interdiction de rencontrer la victime, interdiction de porter une arme…",
                  ),
                ),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00099",
                  "3.2.7 — Rétention et surveillance de sûreté",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00100",
                    "Prévue aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00101",
                    "art. 706-53-13 à 706-53-22 C.P.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00102",
                    " : placement dans un centre socio-médico-judiciaire de sûreté où des soins médicaux sont proposés.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00103",
                  "Peine prononcée ≥ 15 ans de réclusion criminelle",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00104",
                  "Condamnation portant sur des crimes précis",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00105",
                  "Dangerosité : probabilité très élevée de récidive",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00106",
                      "À l’issue de la rétention, la personne peut faire l’objet d’une surveillance de sûreté ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00107",
                      "renouvelable (injonction de soins, surveillance électronique, etc.).",
                    ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                  "f00108",
                  "3.2.8 — Placement sous surveillance électronique",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00109",
                    "Mesure prévue aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                    "f00110",
                    "art. 763-10 à 763-14 C.P.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00111",
                        " : bracelet GPS après libération pour renforcer la prévention de la récidive. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00112",
                        "Constitue une obligation possible du suivi socio-judiciaire, et peut aussi ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                        "f00113",
                        "être prononcé dans la libération conditionnelle ou la surveillance judiciaire.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00114",
                      "Les mesures de sûreté poursuivent un objectif de prévention. Elles visent la dangerosité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00115",
                      "et s’additionnent souvent à des mécanismes de suivi et d’assistance (JAP, injonction de soins, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_mesures_surete_page.dart",
                      "f00116",
                      "bracelet électronique), selon les textes applicables.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 22),
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
  final String title = 'NOTA';

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
