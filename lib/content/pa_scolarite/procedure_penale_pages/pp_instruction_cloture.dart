import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPPInstructionCloturePage extends StatelessWidget {
  const PaPPInstructionCloturePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_instruction_cloture';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
            "f00001",
            'Clôture de l’instruction',
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // plus de barre bleue
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CHAPITRE + titre général
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00002",
                  'CHAPITRE 4',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: isDark
                      ? const Color(0xFF64B5F6)
                      : const Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00003",
                  'La clôture de l’instruction',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00004",
                      'La clôture de l’instruction marque la fin des actes d’enquête ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00005",
                      'conduits par le juge d’instruction. À ce stade, il doit décider ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00006",
                      'des suites à donner au dossier : renvoi devant une juridiction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00007",
                      'de jugement, mise en accusation ou non-lieu.',
                    ),
              ),

              const SizedBox(height: 18),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00008",
                  '4.1 – Le moment de la clôture',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00009",
                      'Dès que l’information lui paraît terminée, le juge d’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00010",
                      'communique le dossier au procureur de la République et en avise ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00011",
                      'les avocats des parties, ou les parties elles-mêmes lorsqu’elles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00012",
                      'ne sont pas assistées par un avocat. Cet avis peut être donné ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00013",
                      'verbalement ou par lettre recommandée.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00014",
                        'Lorsque la personne mise en examen est détenue, l’avis peut ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00015",
                        'également être notifié par le chef de l’établissement pénitentiaire, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00016",
                        'conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00017",
                    'l’article 175 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00018",
                    'L’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00019",
                    'article 175-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00020",
                        ' permet à la personne mise en examen, au témoin assisté et à la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00021",
                        'partie civile de demander au juge d’instruction de clore son ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00022",
                        'instruction, éventuellement par voie de disjonction, afin de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00023",
                        'prononcer soit le renvoi devant une juridiction de jugement, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00024",
                        'soit une décision de non-lieu.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00025",
                      'La demande de clôture peut être formée lorsque aucun acte ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00026",
                      'd’instruction n’a été accompli pendant quatre mois.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00027",
                      'Le juge doit répondre à cette demande par une ordonnance ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00028",
                      'motivée dans le délai d’un mois.',
                    ),
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00029",
                  '4.2 – Les ordonnances de règlement',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00030",
                      'Lorsque tous les actes d’information ont été accomplis, le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00031",
                      'd’instruction doit se prononcer sur les suites à donner à l’affaire. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00032",
                      'Il rend alors une ordonnance de règlement, également appelée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00033",
                      'ordonnance de clôture de l’information. Cette ordonnance dessaisit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00034",
                      'le juge d’instruction.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00035",
                      'L’ordonnance de règlement peut prendre plusieurs formes : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00036",
                      'ordonnance de renvoi, ordonnance de mise en accusation ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00037",
                      'ordonnance de non-lieu.',
                    ),
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00038",
                  'Les trois grandes issues possibles',
                ),
                cardColor: isDark
                    ? const Color(0xFF102027)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark
                    ? const Color(0xFFBBDEFB)
                    : const Color(0xFF0D47A1),
                children: [
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00039",
                          'Ordonnance de renvoi devant une juridiction de jugement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00040",
                          '(tribunal de police, tribunal correctionnel).',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00041",
                          'Ordonnance de mise en accusation devant la cour d’assises ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00042",
                          'pour les crimes.',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00043",
                          'Ordonnance de non-lieu lorsque les conditions de poursuite ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00044",
                          'ne sont pas réunies.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00045",
                  '4.2.1 – L’ordonnance de renvoi',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00046",
                      'Si le juge d’instruction estime que les faits constituent une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00047",
                      'infraction, il prononce par ordonnance le renvoi de l’affaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00048",
                      'devant la juridiction de jugement compétente. Une fois devenue ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00049",
                      'définitive, l’ordonnance de renvoi couvre les vices de la procédure, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00050",
                      's’il en existe, sauf lorsque les parties n’auraient pas pu en avoir ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00051",
                      'connaissance.',
                    ),
              ),

              const SizedBox(height: 16),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00052",
                  '4.2.1.1 – Renvoi devant le tribunal de police\n(en cas de contravention)',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00053",
                        'Lorsque le juge d’instruction estime que les faits ne constituent ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00054",
                        'qu’une contravention, il rend une ordonnance de renvoi devant le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00055",
                        'tribunal de police, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00056",
                    'l’article 178 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00057",
                  '4.2.1.2 – Renvoi devant le tribunal correctionnel\n(en cas de délit)',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00058",
                        'Si le juge d’instruction estime que les faits constituent un délit, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00059",
                        'il rend une ordonnance de renvoi devant le tribunal correctionnel, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00060",
                        'en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00061",
                    'l’article 179 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00062",
                  'En principe, cette ordonnance met fin :',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00063",
                  'à l’assignation à résidence avec surveillance électronique,',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00064",
                  'au contrôle judiciaire,',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00065",
                  'à la détention provisoire.',
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00066",
                      'Si un mandat d’arrêt a été décerné, il conserve sa force exécutoire. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00067",
                      'En revanche, les mandats d’amener ou de recherche cessent de pouvoir ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00068",
                      'être exécutés. Le juge d’instruction peut, le cas échéant, décerner ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00069",
                      'un nouveau mandat d’arrêt.',
                    ),
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00070",
                  '4.2.2 – L’ordonnance de mise en accusation',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00071",
                        'Lorsque le juge d’instruction estime que les faits reprochés aux ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00072",
                        'personnes mises en examen constituent une infraction qualifiée ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00073",
                        'crime, il rend une ordonnance de mise en accusation devant la cour ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00074",
                        'd’assises, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00075",
                    'l’article 181 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00076",
                        'L’ordonnance précise, le cas échéant, si l’accusé bénéficie des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00077",
                        'dispositions applicables au « repenti ». Lorsqu’elle est devenue ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00078",
                        'définitive, l’ordonnance de mise en accusation couvre les vices de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00079",
                        'procédure, s’il en existe, sous réserve de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00080",
                    'l’article 269-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00081",
                        ' (absence d’information régulière de l’accusé) et hors le cas où les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00082",
                        'parties n’auraient pas pu les connaître.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00083",
                      'Le juge d’instruction transmet le dossier accompagné de son ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00084",
                      'ordonnance au procureur de la République. Celui-ci doit l’adresser ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00085",
                      'sans retard au greffe de la cour d’assises, avec les pièces à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00086",
                      'conviction.',
                    ),
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00087",
                  '4.2.3 – L’ordonnance de non-lieu',
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00088",
                  '4.2.3.1 – Le fondement de l’ordonnance de non-lieu',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00089",
                      'Lorsque le juge d’instruction estime que les faits ne constituent pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00090",
                      'une infraction, il rend une ordonnance de non-lieu. Il peut également ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00091",
                      'prendre cette décision lorsque l’auteur de l’infraction demeure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00092",
                      'inconnu ou lorsqu’il n’existe pas de charges suffisantes contre la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00093",
                      'personne mise en examen.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00094",
                        'Si l’ordonnance de non-lieu est motivée par l’existence d’une cause ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00095",
                        'd’irresponsabilité pénale (contrainte, erreur de droit, légitime ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00096",
                        'défense, etc.) ou par le décès de la personne mise en examen, elle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00097",
                        'doit préciser s’il existe des charges suffisantes établissant que ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00098",
                        'l’intéressé a commis les faits qui lui sont reprochés, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00099",
                    'l’alinéa 2 de l’article 177 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00100",
                    '. Le juge d’instruction se prononce ainsi sur la culpabilité.',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00101",
                        'Lorsqu’une ordonnance de non-lieu a été rendue, la personne ne peut ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00102",
                        'plus être recherchée pour les mêmes faits, sauf si apparaissent de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00103",
                        'nouvelles charges, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00104",
                    'l’article 188 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(text: 'Selon '),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00105",
                    'l’article 189 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00106",
                    ', constituent des charges nouvelles :',
                  ),
                ),
              ]),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00107",
                      'les déclarations de témoins, pièces et procès-verbaux qui, n’ayant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00108",
                      'pu être soumis au juge d’instruction, sont de nature à renforcer ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00109",
                      'des charges jugées auparavant insuffisantes,',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00110",
                      'ou à apporter aux faits de nouveaux développements utiles à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00111",
                      'manifestation de la vérité.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00112",
                        'La décision de rouvrir une information sur charges nouvelles ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                        "f00113",
                        'appartient au procureur de la République, en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                    "f00114",
                    'l’article 190 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 18),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00115",
                  '4.2.3.2 – Les effets de l’ordonnance de non-lieu',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00116",
                      'L’ordonnance de non-lieu met fin à l’action publique. Elle s’oppose à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00117",
                      'ce qu’une nouvelle action soit engagée pour les mêmes faits, en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00118",
                      'dehors bien entendu de la réouverture de l’information sur charges ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00119",
                      'nouvelles.',
                    ),
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00120",
                  'Réparation en cas de détention provisoire',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00121",
                          'Le bénéficiaire d’un non-lieu qui a subi une détention ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00122",
                          'provisoire doit être informé de son droit de demander à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00123",
                          'l’État réparation du préjudice matériel et moral causé par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00124",
                          'cette détention, conformément à ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00125",
                      'l’article 149 du Code de procédure pénale',
                    ),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00126",
                          '. L’octroi de cette réparation ouvre à l’État un recours contre ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00127",
                          'le dénonciateur de mauvaise foi ou le faux témoin ayant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00128",
                          'provoqué la détention ou sa prolongation, en application de ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00129",
                      'l’article 150 du Code de procédure pénale',
                    ),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),

              const SizedBox(height: 14),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                  "f00130",
                  'Effets civils pour la partie civile',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00131",
                          'Le bénéficiaire d’un non-lieu, dans une information ouverte ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00132",
                          'sur constitution de partie civile, peut demander au plaignant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00133",
                          'des dommages-intérêts, conformément à ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00134",
                      'l’article 91 du Code de procédure pénale',
                    ),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00135",
                          '. Le non-lieu peut également conduire le juge d’instruction à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00136",
                          'condamner la partie civile à une amende civile pouvant aller ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00137",
                          'jusqu’à 15 000 € lorsque la constitution de partie civile est ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                          "f00138",
                          'jugée abusive ou dilatoire, en application de ',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_instruction_cloture.dart",
                      "f00139",
                      'l’article 177-2 du Code de procédure pénale',
                    ),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
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
