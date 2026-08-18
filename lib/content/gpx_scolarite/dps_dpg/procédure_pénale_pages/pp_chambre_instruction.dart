import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PPChambreInstructionPage extends StatelessWidget {
  const PPChambreInstructionPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_chambre_instruction';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
            "f00001",
            'Chambre de l’instruction',
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
              // Titre principal
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00002",
                  'CHAPITRE 5',
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
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00003",
                  'Rôle de la chambre de l’instruction',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '('),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00004",
                        'articles 191 à 221-3 du Code de procédure pénale',
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: ')'),
                  ],
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1F1F1F).withValues(alpha: .75),
                ),
              ),
              const SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00005",
                      'La chambre de l’instruction est la juridiction d’instruction du second ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00006",
                      'degré. Elle exerce un contrôle sur le déroulement de l’instruction, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00007",
                      'sur la régularité de la procédure et sur certaines décisions du juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00008",
                      'd’instruction et du juge des libertés et de la détention.',
                    ),
              ),

              const SizedBox(height: 20),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00009",
                  '5.1 – Composition et rôle',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00010",
                      'Il existe au moins une chambre de l’instruction par cour d’appel. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00011",
                      'Juridiction d’instruction du second degré, elle est composée d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00012",
                      'président et de deux conseillers. Elle statue par arrêts, qui ne sont ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00013",
                      'susceptibles que d’un pourvoi en cassation.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00014",
                      'Les fonctions du ministère public sont assurées auprès d’elle par le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00015",
                      'procureur général près la cour d’appel.',
                    ),
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00016",
                  'Recours portés devant la chambre de l’instruction',
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
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00017",
                          'L’appel des ordonnances du juge d’instruction ou du juge des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00018",
                          'libertés et de la détention.',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00019",
                      'Le contentieux des nullités de la procédure.',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00020",
                          'Le contentieux de la détention provisoire et du contrôle ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00021",
                          'judiciaire.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00022",
                        'La chambre de l’instruction peut confirmer, infirmer ou annuler l’acte ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00023",
                        'litigieux qui lui est soumis. Chaque fois qu’elle est saisie, elle doit ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00024",
                        'examiner la régularité de la procédure et annuler les actes entachés ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00025",
                        'd’irrégularité, ainsi que, s’il y a lieu, tout ou partie de la procédure ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00026",
                        'postérieure, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                    "f00027",
                    'l’article 206 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00028",
                      'Seule la chambre de l’instruction peut prononcer une annulation : le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00029",
                      'juge d’instruction ne peut pas annuler lui-même l’un de ses propres ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00030",
                      'actes, même s’il y découvre une irrégularité.',
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00031",
                          'La chambre de l’instruction peut également condamner une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00032",
                          'partie civile à une amende civile pouvant aller jusqu’à 15 000 € ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00033",
                          'lorsqu’elle estime que la constitution de partie civile a été ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00034",
                          'abusive ou dilatoire. ',
                        ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00035",
                          'Lorsque la partie civile est une personne morale, l’amende ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00036",
                          'peut être prononcée contre son représentant légal, si sa ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00037",
                          'mauvaise foi est établie.',
                        ),
                  ),
                ],
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00038",
                  'Partie civile abusive',
                ),
              ),

              const SizedBox(height: 18),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00039",
                  'Certains recours permettent à la chambre de l’instruction d’exercer :',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00040",
                      'un pouvoir de révision, lui permettant de refaire ou compléter ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00041",
                      'l’instruction ;',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00042",
                      'un droit d’évocation, lui permettant de se saisir elle-même de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00043",
                      'l’information au-delà du seul point contesté.',
                    ),
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00044",
                  '5.2 – Le pouvoir de révision',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00045",
                      'Le pouvoir de révision s’exerce lorsque le juge d’instruction n’est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00046",
                      'plus en charge de l’affaire, par exemple en cas d’appel d’une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00047",
                      'ordonnance de règlement. Dans ce cadre, la chambre de l’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00048",
                      'peut décider de refaire totalement l’instruction.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00049",
                        'Ce pouvoir se traduit essentiellement par un supplément d’information ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00050",
                        'confié à un magistrat désigné, qui agit conformément aux règles de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00051",
                        'l’instruction préparatoire, en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                    "f00052",
                    'l’article 205 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00053",
                  'Pouvoir de révision – caractéristiques',
                ),
                cardColor: isDark
                    ? const Color(0xFF1A237E)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF283593),
                titleColor: isDark
                    ? const Color(0xFFC5CAE9)
                    : const Color(0xFF1A237E),
                children: [
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00054",
                          'Le juge d’instruction n’est plus saisi de l’affaire (ex. : ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00055",
                          'appel d’une ordonnance de règlement).',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00056",
                      'La chambre peut ordonner un supplément d’information.',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00057",
                          'Le magistrat désigné exerce tous les pouvoirs d’investigation ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00058",
                          'du juge d’instruction et peut délivrer commission rogatoire.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00059",
                  '5.3 – Le droit d’évocation',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00060",
                      'Le droit d’évocation s’exerce alors que l’information est encore en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00061",
                      'cours devant le juge d’instruction. Il permet à la chambre de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00062",
                      'l’instruction de dessaisir ce magistrat et de prendre en charge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00063",
                      'l’ensemble de la procédure.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00064",
                        'L’évocation peut être totale ou partielle : la chambre peut décider ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00065",
                        'de ne procéder qu’à certains actes d’instruction avant de renvoyer ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00066",
                        'le dossier au juge d’instruction, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                    "f00067",
                    'l’article 207 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00068",
                  'Situations permettant l’évocation',
                ),
                cardColor: isDark
                    ? const Color(0xFF263238)
                    : const Color(0xFFE0F2F1),
                accent: const Color(0xFF00796B),
                titleColor: isDark
                    ? const Color(0xFFB2DFDB)
                    : const Color(0xFF004D40),
                children: [
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00069",
                      'Saisine par requête directe devant la chambre de l’instruction.',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00070",
                      'Annulation d’un acte de procédure par la chambre.',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00071",
                          'Infirma­tion d’une ordonnance dans un domaine autre que la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00072",
                          'détention provisoire.',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00073",
                          'Durée exagérée de l’instruction constatée par le président de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00074",
                          'la chambre de l’instruction.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00075",
                      'Lorsque la chambre use de son droit d’évocation, elle accède ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00076",
                      'également au pouvoir de révision, qui s’exerce alors dans les mêmes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00077",
                      'conditions que précédemment décrites.',
                    ),
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00078",
                  '5.4 – Autres conséquences possibles d’une infirmation ou d’une annulation',
                ),
              ),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00079",
                      'Dans les situations où l’usage du droit d’évocation serait possible, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00080",
                      'la chambre de l’instruction dispose de deux autres options pour la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00081",
                      'suite de la procédure lorsqu’elle choisit de ne pas évoquer :',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00082",
                      'laisser le juge d’instruction initialement saisi poursuivre son ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00083",
                      'information ;',
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00084",
                  'ou confier l’affaire à un autre juge d’instruction.',
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00085",
                      'Dans ces deux hypothèses, la chambre de l’instruction ne peut pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00086",
                      'adresser de directives sur le fond au magistrat instructeur. Elle ne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00087",
                      'peut que fixer le cadre procédural (annulations, renvois, dessaisissement...).',
                    ),
              ),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00088",
                  '5.5 – Audience de contrôle',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                    "f00089",
                    'L’',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                    "f00090",
                    'article 221-3 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00091",
                        ' prévoit une audience publique de contrôle de l’ensemble de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                        "f00092",
                        'procédure d’instruction devant la chambre de l’instruction.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00093",
                      'Cette audience peut intervenir en cas de détention provisoire datant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00094",
                      'de trois mois, sur décision du président de la chambre de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00095",
                      'l’instruction, statuant :',
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00096",
                  'à la demande de la personne détenue ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00097",
                  'à la demande du ministère public ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00098",
                  'ou d’office.',
                ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00099",
                      'Lorsque l’instruction a déjà donné lieu à une audience de contrôle, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00100",
                      'une nouvelle saisine est possible six mois après que l’arrêt est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00101",
                      'devenu définitif, à condition qu’une détention provisoire soit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00102",
                      'toujours en cours.',
                    ),
              ),

              const SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                  "f00103",
                  'Décisions possibles',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00104",
                      'Les alinéas 7 à 14 de ',
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                      "f00105",
                      'l’article 221-3 du Code de procédure pénale',
                    ),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00106",
                          ' énumèrent les décisions que peut prendre la chambre de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00107",
                          'l’instruction à l’issue de l’audience de contrôle : mise en liberté, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00108",
                          'nullité d’un ou de plusieurs actes de procédure, évocation du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00109",
                          'dossier, co-saisine d’un autre magistrat, et plus largement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00110",
                          'toutes mesures utiles pour assurer la régularité et la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_chambre_instruction.dart",
                          "f00111",
                          'bonne conduite de l’instruction.',
                        ),
                  ),
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
