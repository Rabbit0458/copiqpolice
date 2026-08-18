import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PPJLDPage extends StatelessWidget {
  const PPJLDPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_jld';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // garde le bouton retour automatiquement si tu viens via Navigator.push
        automaticallyImplyLeading: true,
        elevation: 0, // pas d’ombre moche
        backgroundColor: Colors.transparent, // plus de barre bleue
        surfaceTintColor:
            Colors.transparent, // évite le voile gris/bleu en Material 3
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
            "f00001",
            'Juge des libertés et de la détention',
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CHAPITRE + titre
              Text(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00002",
                  'CHAPITRE 6',
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
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00003",
                  'Le juge des libertés et de la détention (J.L.D.)',
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // INTRO
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00004",
                      'La loi du 15 juin 2000 renforçant la protection de la présomption ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00005",
                      'd’innocence et les droits des victimes a profondément réformé la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00006",
                      'procédure pénale. Elle a créé le juge des libertés et de la détention ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00007",
                      '(J.L.D.), initialement compétent en matière de détention provisoire, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00008",
                      'avant que le législateur ne lui confère progressivement d’autres ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00009",
                      'attributions dans le domaine des libertés individuelles.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00010",
                      'Depuis le 1er septembre 2017, la fonction de juge des libertés et de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00011",
                      'la détention est une fonction statutaire : le J.L.D. devient un juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00012",
                      'spécialisé, au même titre que le juge d’instruction, le juge des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00013",
                      'enfants ou le juge de l’application des peines.',
                    ),
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00014",
                  '6.1 – Statut du juge des libertés et de la détention',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00015",
                        'Le juge des libertés et de la détention (J.L.D.) est un magistrat du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00016",
                        'siège. Il est nommé par décret en Conseil d’État, après avis conforme ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00017",
                        'du Conseil supérieur de la magistrature, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00018",
                    'l’article 3 de l’ordonnance n° 58-1270 du 22 décembre 1958',
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
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00019",
                        'En cas de vacance d’emploi, d’absence ou d’empêchement, le J.L.D. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00020",
                        'peut être suppléé par un magistrat du siège du premier grade ou hors ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00021",
                        'hiérarchie, désigné par le président du tribunal judiciaire. En cas ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00022",
                        'd’empêchement de ces magistrats, le président peut désigner un ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00023",
                        'magistrat du second grade, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00024",
                    'l’article 137-1-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00025",
                  '6.2 – Le J.L.D. et l’instruction préparatoire',
                ),
              ),

              // 6.2.1
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00026",
                  '6.2.1 – La détention provisoire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00027",
                  'Le J.L.D. est compétent pour statuer sur :',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00028",
                  'les demandes de placement en détention provisoire ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00029",
                  'les demandes de prolongation de la détention provisoire ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00030",
                  'les demandes de mise en liberté.',
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00031",
                        'Lorsque la qualification criminelle ne peut être retenue et que les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00032",
                        'faits sont correctionnalisés, le J.L.D. reste saisi pour le maintien ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00033",
                        'en détention provisoire de l’intéressé, conformément aux ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00034",
                    'articles 137-1 et 137-3 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 16),
              // 6.2.2
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00035",
                  '6.2.2 – Le contrôle judiciaire',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00036",
                        'Le contrôle judiciaire est en principe ordonné par le juge ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00037",
                        'd’instruction. Cependant, lorsqu’il est saisi, le J.L.D. peut également ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00038",
                        'ordonner un contrôle judiciaire et déterminer les obligations imposées ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00039",
                        'à la personne mise en examen, en application des ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00040",
                    'articles 137-2 et 138 du Code de procédure pénale',
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
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00041",
                  'En cas d’inobservation des obligations, le J.L.D. peut :',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00042",
                  'révoquer le contrôle judiciaire ;',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00043",
                      'décider un placement en détention provisoire, après saisine par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00044",
                      'le juge d’instruction par ordonnance motivée, accompagnée des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00045",
                      'réquisitions du procureur de la République ;',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00046",
                      'Dans ce cadre, le J.L.D. peut décerner un mandat de dépôt à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00047",
                      'l’encontre de l’intéressé.',
                    ),
              ),

              const SizedBox(height: 16),
              // 6.2.3
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00048",
                  '6.2.3 – L’assignation à résidence\navec surveillance électronique',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00049",
                        'L’assignation à résidence avec surveillance électronique peut être ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00050",
                        'ordonnée par le juge d’instruction ou par le juge des libertés et de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00051",
                        'la détention, par ordonnance motivée, en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00052",
                    'l’article 142-5 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00053",
                  '6.3 – Intervention du J.L.D. durant l’enquête de police',
                ),
              ),

              // 6.3.1 – Écoutes téléphoniques
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00054",
                  '6.3.1 – Les écoutes téléphoniques',
                ),
              ),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00055",
                  'Domaines d’intervention du J.L.D. (écoutes téléphoniques)',
                ),
                cardColor: isDark
                    ? const Color(0xFF102027)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark
                    ? const Color(0xFFBBDEFB)
                    : const Color(0xFF0D47A1),
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00056",
                            'Procédure de recherche d’une personne en fuite : sur requête ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00057",
                            'du procureur de la République, le J.L.D. peut autoriser ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00058",
                            'l’interception, l’enregistrement et la transcription de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00059",
                            'correspondances émises par la voie des télécommunications, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00060",
                            'sous son autorité et son contrôle, conformément à ',
                          ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00061",
                        'l’article 74-2 du Code de procédure pénale',
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00062",
                            'Écoutes sur une ligne dépendant d’un cabinet d’avocat ou de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00063",
                            'son domicile : la décision est prise par ordonnance motivée ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00064",
                            'du J.L.D., saisi par le juge d’instruction après avis du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00065",
                            'procureur de la République, conformément à ',
                          ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00066",
                        'l’article 100 du Code de procédure pénale',
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00067",
                            'Écoutes judiciaires en matière de criminalité organisée : sur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00068",
                            'requête du procureur de la République, le J.L.D. peut autoriser ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00069",
                            'l’interception de correspondances électroniques pour certaines ',
                          ) +
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                            "f00070",
                            'infractions relevant de la criminalité organisée, en application ',
                          ) +
                          'de ',
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00071",
                        'l’article 706-95 du Code de procédure pénale',
                      ),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ]),
                ],
              ),

              const SizedBox(height: 20),
              // 6.3.2 – Perquisitions
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00072",
                  '6.3.2 – Les perquisitions, visites domiciliaires et saisies',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00073",
                        'En enquête préliminaire, les perquisitions sont en principe subordonnées ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00074",
                        'à l’assentiment de la personne chez laquelle elles ont lieu. Toutefois, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00075",
                        'pour une enquête relative à un crime ou un délit puni d’au moins trois ans ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00076",
                        'd’emprisonnement, ou pour la recherche de biens susceptibles de confiscation ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00077",
                        'en vertu de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00078",
                    'l’article 131-21 du Code pénal',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00079",
                    ', le J.L.D. peut autoriser une perquisition sans assentiment, conformément à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00080",
                    'l’article 76 du Code de procédure pénale',
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
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00081",
                  'Le J.L.D. intervient également :',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00082",
                      'pour autoriser les perquisitions au cabinet ou au domicile d’un ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00083",
                      'avocat, par ordonnance écrite et motivée, en présence du bâtonnier ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00084",
                      'ou de son délégué ;',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00085",
                    'Cette intervention est prévue par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00086",
                    'l’article 56-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00087",
                      'pour trancher, dans les cinq jours, les contestations du bâtonnier ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00088",
                      'relatives à la saisie de documents, après mise sous scellés.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00089",
                        'En matière de délinquance et de criminalité organisées, le J.L.D. peut, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00090",
                        'sur requête du procureur de la République, autoriser l’O.P.J. à procéder ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00091",
                        'à des perquisitions, visites domiciliaires et saisies en dehors des heures ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00092",
                        'légales, en application des ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00093",
                    'articles 706-89, 706-90 et 706-92 du Code de procédure pénale',
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
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00094",
                        'Il peut aussi, en enquête de flagrance portant sur certains crimes contre ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00095",
                        'les personnes, autoriser des perquisitions et saisies en dehors des heures ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00096",
                        'légales, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00097",
                    'l’article 59-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00098",
                    ' et à ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00099",
                    'l’article 706-92 du Code de procédure pénale',
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
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00100",
                        'En enquête préliminaire, le J.L.D. peut autoriser une perquisition sans ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00101",
                        'présence ni assentiment de la personne lorsque le transport d’une ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00102",
                        'personne gardée à vue présente un risque grave de trouble à l’ordre public, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00103",
                        'd’évasion ou de disparition de preuves, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00104",
                    'l’article 706-94 du Code de procédure pénale',
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
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00105",
                        'Il intervient aussi pour autoriser la saisie de biens dont la confiscation ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00106",
                        'est prévue par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00107",
                    'l’article 131-21 du Code pénal',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00108",
                        ', à la suite d’une perquisition, ainsi que pour statuer sur la saisie de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00109",
                        'documents susceptibles d’être couverts par le secret du délibéré lors de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00110",
                        'perquisitions dans les locaux d’une juridiction ou au domicile d’un magistrat, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00111",
                        'en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00112",
                    'l’article 56-5 du Code de procédure pénale',
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
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00113",
                        'Enfin, le J.L.D. intervient pour autoriser certaines visites domiciliaires et ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00114",
                        'saisies conduites par : les douanes, en vertu de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00115",
                    'l’article 64 du Code des douanes',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00116",
                    ', l’administration fiscale, en application de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00117",
                    'l’article L.16 B du Livre des procédures fiscales',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00118",
                    ', ou la DGCCRF, en vertu de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00119",
                    'l’article L.450-4 du Code de commerce',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 20),
              // 6.3.3 – Garde à vue
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00120",
                  '6.3.3 – La garde à vue',
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00121",
                  '6.3.3.1 – Prolongation de garde à vue',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00122",
                    'Pour certaines infractions relevant de la criminalité organisée, au sens des ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00123",
                    'articles 706-73 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00124",
                        ' (sauf 21°), la garde à vue peut, à titre exceptionnel, faire l’objet de deux ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00125",
                        'prolongations supplémentaires de vingt-quatre heures chacune. Ces prolongations ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00126",
                        'sont autorisées, sur requête du procureur de la République, par décision écrite ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00127",
                        'et motivée du J.L.D., conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00128",
                    'l’article 706-88 du Code de procédure pénale',
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
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00129",
                      'Par dérogation, si la durée prévisible des investigations à l’issue des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00130",
                      'premières quarante-huit heures le justifie, le J.L.D. peut décider une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00131",
                      'seule prolongation supplémentaire de quarante-huit heures.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00132",
                    'En matière de terrorisme, pour les infractions visées au 11° de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00133",
                    'l’article 706-73 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00134",
                        ', et en présence d’un risque sérieux d’action terroriste imminente ou de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00135",
                        'nécessités impérieuses de coopération internationale, le J.L.D. peut décider ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00136",
                        'une prolongation supplémentaire de vingt-quatre heures, renouvelable une fois, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00137",
                        'conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00138",
                    'l’article 706-88-1 du Code de procédure pénale',
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
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00139",
                  '6.3.3.2 – Report de l’intervention de l’avocat',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00140",
                        'En droit commun, le report de l’intervention de l’avocat au-delà de la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00141",
                        '12e heure et jusqu’à la 24e heure de garde à vue peut être autorisé par ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00142",
                        'le J.L.D., sur requête du procureur de la République ou du juge ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00143",
                        'd’instruction, pour les crimes et délits punis d’au moins cinq ans ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00144",
                        'd’emprisonnement, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00145",
                    'l’article 63-4-2 du Code de procédure pénale',
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
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00146",
                      'En matière de criminalité organisée, le procureur ou le juge d’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00147",
                      'peut différer la présence de l’avocat jusqu’à la 24e heure. Le procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00148",
                      'peut saisir le J.L.D. pour reporter cette présence jusqu’à la 48e heure. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00149",
                      'Pour les infractions de trafic de stupéfiants (3°) ou de terrorisme (11° ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00150",
                      'de l’article 706-73), l’intervention de l’avocat peut être différée jusqu’à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00151",
                      '72 heures. Pour ces infractions, le juge d’instruction est seul compétent ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00152",
                      'pour autoriser ce report.',
                    ),
              ),

              const SizedBox(height: 20),
              // 6.3.4 – Réquisitions
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00153",
                  '6.3.4 – Les réquisitions',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00154",
                        'En enquête de flagrance ou en enquête préliminaire, sur réquisition du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00155",
                        'procureur de la République et autorisation du J.L.D. par ordonnance, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00156",
                        'l’O.P.J. ou, sous son contrôle, l’A.P.J. peut demander aux opérateurs ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00157",
                        'de télécommunications de prendre sans délai toutes mesures propres à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00158",
                        'assurer la préservation, pour une durée maximale d’un an, du contenu ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00159",
                        'des informations consultées par les utilisateurs, en application des ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00160",
                    'articles 60-2 alinéa 2 et 77-1-2 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 16),
              // 6.3.5 – Protection des témoins
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00161",
                  '6.3.5 – La protection des témoins',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00162",
                        'Pour les crimes ou délits punis d’au moins trois ans d’emprisonnement, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00163",
                        'lorsque l’audition d’une personne au sens de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00164",
                    'l’article 706-57 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00165",
                        ' est susceptible de mettre gravement en danger sa vie ou son intégrité, ou ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00166",
                        'celle de ses proches, le J.L.D., saisi par requête motivée du procureur ou ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00167",
                        'du juge d’instruction, peut autoriser que ses déclarations soient recueillies ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00168",
                        'sans que son identité figure au dossier, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00169",
                    'l’article 706-58 et aux articles R.53-29 et R.53-32 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00170",
                    '. Il peut décider de procéder lui-même à l’audition.',
                  ),
                ),
              ]),

              const SizedBox(height: 16),
              // 6.3.6 – Techniques spéciales d’enquête
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00171",
                  '6.3.6 – Les techniques spéciales d’enquête\n(articles 706-95-11 et suivants du Code de procédure pénale)',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00172",
                        'Au cours de l’enquête de flagrance ou de l’enquête préliminaire, certaines ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00173",
                        'techniques spéciales d’enquête sont autorisées par le J.L.D., sur requête ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00174",
                        'du procureur de la République, en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00175",
                    'l’article 706-95-12 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00176",
                    '. Sont notamment concernées :',
                  ),
                ),
              ]),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00177",
                      'le recueil de données techniques de connexion et l’interception de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00178",
                      'correspondances électroniques ;',
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00179",
                  'les sonorisations et fixations d’images de certains lieux ou véhicules ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00180",
                  'la captation de données informatiques.',
                ),
              ),

              const SizedBox(height: 16),
              // 6.3.7 – Saisies du patrimoine
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00181",
                  '6.3.7 – Les saisies du patrimoine\n(article 706-148 du Code de procédure pénale)',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00182",
                        'En enquête préliminaire ou de flagrance pour une infraction punie d’au ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00183",
                        'moins cinq ans d’emprisonnement, le J.L.D. peut ordonner, sur requête du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00184",
                        'procureur, la saisie de tout ou partie du patrimoine d’une personne, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00185",
                        'conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00186",
                    'l’article 706-148 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00187",
                        ', lorsque l’origine de ces biens ne peut être établie ou lorsque la loi ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00188",
                        'réprimant l’infraction prévoit la confiscation de tout ou partie des biens ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00189",
                        'du condamné.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00190",
                      'L’O.P.J. peut, sur autorisation du procureur ou du juge d’instruction, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00191",
                      'procéder d’urgence à la saisie de ces biens lorsqu’il existe un risque ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00192",
                      'imminent de disparition. Le J.L.D., saisi ensuite, statue dans les dix jours ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00193",
                      'sur le maintien ou la mainlevée de la saisie, même si la juridiction de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00194",
                      'jugement est saisie.',
                    ),
              ),

              const SizedBox(height: 16),
              // 6.3.8 – Saisies conservatoires
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00195",
                  '6.3.8 – Les saisies conservatoires',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00196",
                        'Les saisies conservatoires visent à appréhender le patrimoine des ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00197",
                        'délinquants pour garantir le paiement des amendes et l’indemnisation ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00198",
                        'éventuelle des victimes. Pour les infractions entrant dans le champ des ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00199",
                    'articles 706-73, 706-73-1 et 706-74 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00200",
                        ', le J.L.D. peut, sur requête du procureur de la République, ordonner des mesures ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00201",
                        'conservatoires sur les biens de la personne mise en examen, en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00202",
                    'l’article 706-103 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00203",
                  '6.4 – Autres interventions du J.L.D. au cours d’une procédure judiciaire',
                ),
              ),

              // 6.4.1 – Détention provisoire et contrôle judiciaire
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00204",
                  '6.4.1 – Détention provisoire et contrôle judiciaire',
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00205",
                  '6.4.1.1 – En cas de convocation par procès-verbal',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00206",
                        'En matière correctionnelle, en cas de convocation par procès-verbal, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00207",
                        'si le procureur de la République estime nécessaire de soumettre le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00208",
                        'prévenu à des obligations de contrôle judiciaire ou à une assignation ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00209",
                        'à résidence avec surveillance électronique jusqu’à sa comparution, il le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00210",
                        'fait présenter devant le J.L.D., qui statue en chambre du conseil avec ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00211",
                        'l’assistance d’un greffier, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00212",
                    'l’article 394 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00213",
                  '6.4.1.2 – Comparution immédiate ou différée',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00214",
                        'En cas de comparution immédiate, si le tribunal ne peut être réuni le ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00215",
                        'jour même et que les éléments de l’espèce justifient une détention ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00216",
                        'provisoire, le procureur peut traduire le prévenu devant le J.L.D., qui ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00217",
                        'statue en chambre du conseil, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00218",
                    'l’article 396 du Code de procédure pénale',
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
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00219",
                        'Dans le cadre de la comparution à délai différé, le J.L.D. statue dans les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00220",
                        'mêmes conditions sur les réquisitions du ministère public aux fins de contrôle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00221",
                        'judiciaire, d’assignation à résidence avec surveillance électronique ou de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00222",
                        'détention provisoire, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00223",
                    'l’article 397-1-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00224",
                  '6.4.1.3 – Comparution sur reconnaissance préalable de culpabilité',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00225",
                        'Lorsqu’une comparution sur reconnaissance préalable de culpabilité ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00226",
                        '(C.R.P.C.) est proposée, la personne peut demander un délai de réflexion ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00227",
                        'de 10 jours. Pendant ce délai, elle peut être placée sous contrôle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00228",
                        'judiciaire, assignée à résidence avec surveillance électronique ou placée ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00229",
                        'en détention provisoire par décision du J.L.D., conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00230",
                    'l’article 495-11 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00231",
                  '6.4.1.4 – Renvoi devant le tribunal correctionnel',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00232",
                      'Lorsqu’une personne renvoyée devant le tribunal correctionnel est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00233",
                      'placée ou maintenue sous contrôle judiciaire, le J.L.D. peut, à tout ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00234",
                      'moment, sur réquisitions du ministère public ou demande du prévenu :',
                    ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00235",
                  'imposer de nouvelles obligations ou interdictions ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00236",
                  'supprimer ou modifier certaines obligations ;',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00237",
                      'accorder une dispense occasionnelle ou temporaire d’observer ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00238",
                      'certaines obligations.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00239",
                    'Ces pouvoirs sont exercés en application de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00240",
                    'l’article 141-1 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00241",
                  '6.4.1.5 – Arrestation après clôture de l’information',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00242",
                        'Si une personne faisant l’objet d’un mandat d’arrêt est découverte après ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00243",
                        'le règlement de l’information, elle est conduite devant le procureur de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00244",
                        'la République, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00245",
                    'l’article 135-2 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00246",
                    ', qui la présente ensuite devant le J.L.D. après notification du mandat.',
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00247",
                  'Le J.L.D. peut alors, sur réquisitions du parquet :',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00248",
                  'placer la personne sous contrôle judiciaire ;',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00249",
                      'ou ordonner son placement en détention provisoire jusqu’à sa ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00250",
                      'comparution devant la juridiction de jugement.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00251",
                      'Il statue par ordonnance motivée, après débat contradictoire. Lorsque la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00252",
                      'personne est arrêtée à plus de 200 km de la juridiction de jugement et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00253",
                      'qu’elle ne peut être présentée dans les 24 h, elle est conduite devant le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00254",
                      'J.L.D. du lieu d’arrestation.',
                    ),
              ),

              const SizedBox(height: 20),
              // 6.4.2 – Application des peines
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00255",
                  '6.4.2 – Application des peines',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00256",
                      'Le juge de l’application des peines (J.A.P.) peut délivrer un mandat ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00257",
                      'd’amener contre un condamné placé sous son contrôle judiciaire en cas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00258",
                      'd’inobservation des obligations. Si le condamné ne peut être présenté ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00259",
                      'immédiatement au J.A.P., il est présenté devant le J.L.D.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00260",
                        'Sur réquisitions du procureur, le J.L.D. peut ordonner l’incarcération du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00261",
                        'condamné jusqu’à sa comparution devant le J.A.P., dans un délai de huit ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00262",
                        'jours en matière correctionnelle ou d’un mois en matière criminelle, en ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                        "f00263",
                        'application des ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                    "f00264",
                    'articles 122 et 712-17 du Code de procédure pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ]),

              const SizedBox(height: 24),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                  "f00265",
                  '6.5 – Autre domaine d’intervention : sécurité intérieure\net lutte contre le terrorisme',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00266",
                      'La loi n° 2017-1510 du 30 octobre 2017 renforçant la sécurité intérieure ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00267",
                      'et la lutte contre le terrorisme a confié au J.L.D. de Paris de nouvelles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00268",
                      'prérogatives spécifiques en matière de mesures de sûreté et de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00269",
                      'surveillance.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00270",
                      'Les développements détaillés relatifs à ces compétences particulières du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00271",
                      'J.L.D. peuvent être consultés dans le fascicule 8 consacré aux libertés ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_jld.dart",
                      "f00272",
                      'publiques.',
                    ),
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
