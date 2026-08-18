import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAutresTechniquesGpxSchool extends StatelessWidget {
  const PaAutresTechniquesGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/criminalite_organisee/techniques_speciales';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark
        ? const Color(0xFF111218)
        : const Color(0xFFFDFDFE);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
            "f00001",
            'Techniques spéciales d’enquête',
          ),
          style: GoogleFonts.fustat(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00002",
                  '2.1.7 - Les autres techniques spéciales d’enquête',
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                        "f00003",
                        'Une section dans le code de procédure pénale intitulée « Des autres ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                        "f00004",
                        'techniques spéciales d’enquête », comprenant les articles 706-95-11 à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                        "f00005",
                        '706-102-5, institue un régime commun à trois techniques d’enquête :',
                      ),
                  style: TextStyle(color: Colors.red),
                ),
              ]),
              const SizedBox(height: 6),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00006",
                  'le recours à l’IMSI-catcher ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00007",
                  'la sonorisation et la fixation d’images ;',
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00008",
                  'la captation de données informatiques.',
                ),
              ),

              const SizedBox(height: 18),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00009",
                  '2.1.7.1 - Champ d’application',
                ),
              ),
              const SizedBox(height: 8),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00010",
                  'Champ d’application des techniques spéciales',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00011",
                            'Ces techniques peuvent être mises en œuvre si les nécessités de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00012",
                            'l’enquête relative à l’une des infractions entrant dans le champ ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00013",
                            'd’application des articles 706-73 et 706-73-1 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00014",
                            'pénale l’exigent (article 706-95-11 du Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00015",
                              'Ces techniques sont également applicables à certaines infractions ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00016",
                              'relatives aux systèmes de traitement automatisé de données ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00017",
                              'commises en bande organisée (article 706-72 du code de procédure ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00018",
                              'pénale), à certaines infractions économiques et financières ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00019",
                              '(articles 706-1-1 et 706-1-2 du code de procédure pénale), et à ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00020",
                              'certaines infractions en matière de santé publique (article ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00021",
                              '706-2-2 du code de procédure pénale).',
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00022",
                  '2.1.7.2 - Modalités',
                ),
              ),
              const SizedBox(height: 8),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00023",
                  'Autorisation, durée et contrôle',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00024",
                            'L’autorisation de recourir à ces techniques d’enquête doit être ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00025",
                            'délivrée par le juge des libertés et de la détention, à la requête ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00026",
                            'du procureur de la République (article 706-95-12 du Code de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00027",
                            'procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00028",
                            'Elle est délivrée pour une durée maximale d’un mois, renouvelable ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00029",
                            'une fois dans les mêmes conditions de forme et de durée (article ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00030",
                            '706-95-16 du Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00031",
                            'Le juge des libertés et de la détention doit être informé sans délai ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00032",
                            'par le procureur de la République des actes accomplis et se voir ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00033",
                            'communiquer les procès-verbaux dressés en exécution de sa décision, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00034",
                            'de manière à ce qu’il puisse exercer son contrôle sur la légalité ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00035",
                            'des actes ainsi réalisés (article 706-95-14 du Code de procédure ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00036",
                            'pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00037",
                          'S’il estime que les opérations n’ont pas été réalisées conformément à son ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00038",
                          'autorisation ou que les dispositions applicables du code de procédure ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00039",
                          'pénale n’ont pas été respectées, il peut ordonner la destruction des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00040",
                          'procès-verbaux et des enregistrements effectués.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00041",
                          'La décision de destruction des procès-verbaux et des enregistrements ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00042",
                          'prend la forme d’une ordonnance motivée, notifiée au procureur de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00043",
                          'République, que ce dernier peut contester dans un délai de dix jours ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00044",
                          'suivant sa notification, devant le président de la chambre de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00045",
                          'l’instruction.',
                        ),
                  ),
                  SizedBox(height: 8),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00046",
                            'L’article 706-95-17 du Code de procédure pénale prévoit que ces techniques ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00047",
                            'sont mises en place par un officier de police judiciaire requis par ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00048",
                            'le procureur de la République ou, sous sa responsabilité, par un ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00049",
                            'agent de police judiciaire. Il est possible de requérir tout agent ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00050",
                            'dont la liste est fixée par décret pour l’installation et le retrait ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00051",
                            'des dispositifs techniques.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00052",
                            'Ces personnes doivent, en application de l’article 706-95-18 du Code ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00053",
                            'de procédure pénale, dresser procès-verbal de leurs diligences, en ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00054",
                            'mentionnant la date et l’heure du début et de la fin des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00055",
                            'opérations. Les enregistrements sont placés sous scellés fermés.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 8),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00056",
                          'Les données enregistrées utiles à la manifestation de la vérité sont ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00057",
                          'décrites ou transcrites dans un procès-verbal par l’officier de police ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00058",
                          'judiciaire, l’agent de police judiciaire agissant sous sa responsabilité ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00059",
                          'ou l’assistant d’enquête agissant sous son contrôle.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00060",
                            'L’assistant d’enquête ne peut cependant agir qu’à la demande expresse ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00061",
                            'et sous le contrôle de l’officier de police judiciaire, qui aura ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00062",
                            'préalablement identifié les enregistrements nécessaires à la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00063",
                            'manifestation de la vérité (articles 21-3 et 706-95-18 du Code de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00064",
                            'procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00065",
                          'Aucune séquence relative à la vie privée étrangère aux infractions visées ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00066",
                          'dans les autorisations ne peut être conservée dans le dossier de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00067",
                          'procédure.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00068",
                              'Conformément à la circulaire conjointe DACG–DGGN–DGPN du 16 novembre ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00069",
                              '2018 relative à la simplification de la procédure pénale à droit ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00070",
                              'constant, pour les enquêtes de flagrance et en préliminaire, il ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00071",
                              'est possible de relater dans un seul procès-verbal plusieurs ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00072",
                              'opérations effectuées au cours de la même enquête, sauf ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00073",
                              'prescription contraire du parquet. Ces dispositions s’appliquent ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00074",
                              'aux trois techniques d’enquête décrites ci-après.',
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00075",
                  '2.1.7.3 - IMSI-catcher : interceptions de correspondances et données de connexion',
                ),
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00076",
                  '2.1.7.3.1 - Généralités (article 706-95-20 du Code de procédure pénale)',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00077",
                            'L’IMSI-catcher est un appareil ou un dispositif technique de recueil ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00078",
                            'des données techniques de connexion permettant l’identification d’un ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00079",
                            'équipement terminal ou du numéro d’abonnement de son utilisateur, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00080",
                            'ainsi que les données relatives à la localisation d’un équipement ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00081",
                            'terminal utilisé. Il permet également d’intercepter des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00082",
                            'correspondances (article 706-95-20 du Code de procédure pénale).',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00083",
                  '2.1.7.3.2 - Mise en place dans un lieu privé',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00084",
                          'En vue de mettre en place ce dispositif et sur requête du procureur de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00085",
                          'la République, le juge des libertés et de la détention peut autoriser ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00086",
                          'l’introduction dans un lieu privé, y compris en dehors des heures ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00087",
                          'prévues à l’article 59, à l’insu ou sans le consentement du propriétaire ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00088",
                          'ou de l’occupant des lieux, ou de toute personne titulaire d’un droit ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00089",
                          'sur ceux-ci.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00090",
                          'Ces opérations, qui ne peuvent avoir d’autre fin que la mise en place du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00091",
                          'dispositif technique, sont effectuées sous le contrôle du juge des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00092",
                          'libertés et de la détention. Les mêmes règles s’appliquent aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00093",
                          'opérations de désinstallation du dispositif.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00094",
                          'La mise en place du dispositif ne peut concerner les lieux visés aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00095",
                          'articles 56-1, 56-2, 56-3 et 56-5 ni être mise en œuvre dans le bureau ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00096",
                          'ou le domicile des personnes mentionnées à l’article 100-7 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00097",
                          'procédure pénale.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00098",
                      'Elle est donc toujours illégale :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00099",
                      'dans un cabinet d’avocat ou à son domicile ;',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00100",
                          'dans les locaux professionnels d’une entreprise ou agence de presse, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00101",
                          'd’une entreprise de communication audiovisuelle ou de communication ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00102",
                          'au public en ligne ;',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00103",
                      'au domicile d’un journaliste ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00104",
                      'dans les locaux d’une juridiction ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00105",
                      'au domicile d’une personne exerçant des fonctions juridictionnelles ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00106",
                      'dans le bureau ou au domicile d’un magistrat ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00107",
                      'dans le bureau ou au domicile d’un parlementaire.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00108",
                  '2.1.7.4 - La sonorisation et la fixation d’images (articles 706-96 à 706-98 du Code de procédure pénale)',
                ),
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00109",
                  '2.1.7.4.1 - Généralités',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00110",
                          'Il peut être recouru à la mise en place d’un dispositif technique ayant ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00111",
                          'pour objet, sans le consentement des intéressés, la captation, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00112",
                          'fixation, la transmission et l’enregistrement de paroles prononcées par ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00113",
                          'une ou plusieurs personnes à titre privé ou confidentiel dans des lieux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00114",
                          'ou véhicules privés ou publics, ou de l’image d’une ou de plusieurs ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00115",
                          'personnes se trouvant dans un lieu privé.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00116",
                      'Il s’agit en général de la pose d’un micro et/ou d’une caméra.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00117",
                  '2.1.7.4.2 - Introduction dans les véhicules ou lieux privés',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00118",
                          'Au cours de l’enquête, en vue de mettre en place ou de désinstaller un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00119",
                          'dispositif permettant la sonorisation ou la fixation d’images, le juge ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00120",
                          'des libertés et de la détention peut autoriser l’introduction dans un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00121",
                          'véhicule ou un lieu privé, y compris en dehors des heures prévues à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00122",
                          'l’article 59, à l’insu ou sans le consentement du propriétaire ou du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00123",
                          'possesseur du véhicule, ou de l’occupant des lieux ou de toute personne ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00124",
                          'titulaire d’un droit sur ceux-ci. Ces opérations, qui ne peuvent avoir ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00125",
                          'd’autre fin que la mise en place ou le retrait du dispositif, sont ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00126",
                          'effectuées sous son contrôle.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00127",
                          'La mise en place de ce dispositif technique ne peut concerner les lieux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00128",
                          'visés aux articles 56-1, 56-2, 56-3 et 56-5, ni être mise en œuvre dans ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00129",
                          'le véhicule, le bureau ou le domicile des personnes visées aux articles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00130",
                          '100-7 et 803-10 du Code de procédure pénale.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00131",
                      'Elle est donc toujours illégale :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00132",
                      'dans un cabinet d’avocat, à son domicile ou dans son véhicule ;',
                    ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00133",
                          'dans les locaux ou véhicules professionnels d’une entreprise ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00134",
                          'agence de presse ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00135",
                          'dans une entreprise de communication audiovisuelle ou de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00136",
                          'communication au public en ligne ;',
                        ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00137",
                      'au domicile d’un journaliste ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00138",
                      'dans les locaux d’une juridiction ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00139",
                      'au domicile d’une personne exerçant des fonctions juridictionnelles ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00140",
                      'dans le véhicule, au bureau ou au domicile d’un magistrat ;',
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00141",
                      'dans le véhicule, au bureau ou au domicile de parlementaires.',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00142",
                  '2.1.7.4.3 - Activation à distance des appareils électroniques connectés',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00143",
                          'Pour certaines infractions graves, la loi permet de recourir à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00144",
                          'l’activation à distance d’appareils électroniques fixes ou mobiles, en ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00145",
                          'alternative à la pose physique de micros ou de caméras, qui peut être ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00146",
                          'trop risquée pour les enquêteurs.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                      "f00147",
                      'On distingue :',
                    ),
                  ),
                  SizedBox(height: 4),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00148",
                          'les appareils connectés dits fixes : tout appareil électronique ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00149",
                          'connecté nécessitant un raccordement au réseau électrique pour ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00150",
                          'fonctionner et ne pouvant, par nature, être déplacé (par exemple : ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00151",
                          'ordinateur fixe, téléphone fixe) ;',
                        ),
                  ),
                  _IntroBullet(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00152",
                          'les appareils connectés dits mobiles : ensemble des appareils ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00153",
                          'électroniques dotés d’une batterie leur assurant une autonomie ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00154",
                          'suffisante pour être portables (téléphones portables, tablettes, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00155",
                          'ordinateurs portables, etc.).',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00156",
                  '2.1.7.4.3.1 - Conditions communes aux appareils fixes et mobiles',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00157",
                          'L’activation à distance est réservée aux infractions particulièrement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00158",
                          'graves prévues aux 1° à 6° et 11° à 12° de l’article 706-73 du code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00159",
                          'procédure pénale (meurtres en bande organisée ou en concours, tortures ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00160",
                          'et actes de barbarie en bande organisée, viols en concours, trafics de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00161",
                          'stupéfiants, enlèvement et séquestration en bande organisée, traite des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00162",
                          'êtres humains, proxénétisme, actes de terrorisme, atteintes aux intérêts ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00163",
                          'fondamentaux de la nation, délits en matière d’armes et de produits ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00164",
                          'explosifs), ainsi qu’au blanchiment de ces infractions ou à une ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00165",
                          'association de malfaiteurs en vue de les préparer.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _NotaBox(
                    bodySpans: [
                      TextSpan(
                        text:
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00166",
                              'Par une réserve d’interprétation, le Conseil constitutionnel a jugé ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00167",
                              'que ces dispositions ne peuvent s’appliquer aux délits que s’ils ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00168",
                              'sont commis en bande organisée et punis d’une peine ',
                            ) +
                            ScolariteText.value(
                              "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                              "f00169",
                              'd’emprisonnement d’une durée égale ou supérieure à cinq ans.',
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00170",
                  '2.1.7.4.3.2 - Appareils électroniques fixes',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00171",
                            'L’opération doit être autorisée par le juge des libertés et de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00172",
                            'détention, à la requête du procureur de la République. ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00173",
                            'L’autorisation doit comporter tous les éléments permettant ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00174",
                            'd’identifier les lieux et l’appareil visés, ainsi que l’infraction ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00175",
                            'motivant la mesure et sa durée. Conformément à l’article 706-95-16 ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00176",
                            'du Code de procédure pénale, elle est délivrée au cours de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00177",
                            'l’enquête pour une durée maximale d’un mois, renouvelable une fois.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00178",
                          'Le procureur de la République peut désigner toute personne physique ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00179",
                          'morale habilitée, inscrite sur l’une des listes prévues à l’article 157 ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00180",
                          'du code de procédure pénale, pour effectuer les opérations techniques ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00181",
                          'permettant la mise en œuvre du dispositif. Il peut également prescrire ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00182",
                          'le recours aux moyens de l’État soumis au secret de la défense nationale, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00183",
                          'dans les formes prévues au chapitre Ier du titre IV du livre Ier du code ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00184",
                          'de procédure pénale.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00185",
                          'L’activation à distance d’un appareil électronique fixe ne peut concerner ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00186",
                          'les lieux mentionnés aux articles 56-1, 56-2, 56-3 et 56-5 du code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00187",
                          'procédure pénale, ni être mise en œuvre dans le véhicule, le bureau ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00188",
                          'le domicile d’un membre du Parlement, d’un avocat ou d’un magistrat.',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00189",
                  'Appareils électroniques mobiles (articles 706-99 et 706-100)',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00190",
                            'L’opération est prévue par les articles 706-99 et 706-100 du Code de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00191",
                            'procédure pénale.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00192",
                          'L’activation à distance d’un appareil électronique mobile n’est possible ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00193",
                          'que lorsque les circonstances de l’enquête ne permettent pas la mise en ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00194",
                          'place d’un dispositif fixe, notamment :',
                        ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00195",
                          'en cas d’impossibilité de déterminer les lieux où un dispositif ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00196",
                          'technique pourrait être utilement installé ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00197",
                          'en cas de risques d’atteinte à la vie ou à l’intégrité physique des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00198",
                          'agents chargés de la mise en œuvre du dispositif.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00199",
                          'L’opération doit être autorisée par le juge des libertés et de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00200",
                          'détention, à la requête du procureur de la République, pour une durée ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00201",
                          'strictement proportionnée à l’objectif recherché et ne pouvant excéder ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00202",
                          'quinze jours, renouvelable une fois.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00203",
                          'L’autorisation doit préciser l’infraction à l’origine de la mesure, la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00204",
                          'durée, ainsi que tous les éléments permettant d’identifier l’appareil. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00205",
                          'Elle doit être motivée par référence aux éléments de fait et de droit ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00206",
                          'justifiant la nécessité de l’opération et l’impossibilité de recourir au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00207",
                          'dispositif fixe.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00208",
                          'Le dispositif d’activation à distance d’un appareil électronique mobile ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00209",
                          'aux fins de captation de sons et d’images ne peut, à peine de nullité, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00210",
                          'concerner les appareils utilisés par un magistrat, un avocat, un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00211",
                          'parlementaire, un journaliste ou un médecin.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00212",
                          'Ne peuvent être transcrites en procédure les données relatives aux ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00213",
                          'échanges avec un avocat qui relèvent de l’exercice des droits de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00214",
                          'défense et sont couvertes par le secret professionnel, ni celles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00215",
                          'permettant d’identifier une source journalistique, ni celles captées ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00216",
                          'dans certains lieux protégés (locaux et domicile d’un avocat ou d’un ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00217",
                          'journaliste, cabinet d’un médecin, d’un notaire, d’un commissaire de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00218",
                          'justice, juridiction ou domicile d’un magistrat).',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00219",
                  '2.1.1.2 - La captation de données informatiques (articles 706-102-1 à 706-102-5)',
                ),
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00220",
                  'La captation de données informatiques',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00221",
                          'La captation de données informatiques consiste, au moyen d’un dispositif ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00222",
                          'technique, à accéder, sans le consentement des intéressés, à des données ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00223",
                          'informatiques, à les enregistrer, les conserver et les transmettre, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00224",
                          'qu’elles soient stockées dans un système informatique, qu’elles ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00225",
                          's’affichent sur l’écran utilisé par la personne ou qu’elles soient reçues ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00226",
                          'ou émises par des périphériques (clé USB, imprimante, disque dur externe, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00227",
                          'etc.).',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00228",
                            'L’article 706-102-5 du Code de procédure pénale précise qu’en vue de mettre ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00229",
                            'en place le dispositif visé à l’article 706-102-1, le juge des ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00230",
                            'libertés et de la détention, à la requête du procureur de la ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00231",
                            'République, peut autoriser l’introduction dans un véhicule ou dans ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00232",
                            'un lieu privé, y compris hors des heures prévues à l’article 59, à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00233",
                            'l’insu ou sans le consentement du propriétaire ou du possesseur du ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00234",
                            'véhicule ou de l’occupant des lieux ou de toute personne titulaire ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00235",
                            'd’un droit sur celui-ci. Lorsque le lieu est un lieu d’habitation et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00236",
                            'que l’opération doit intervenir en dehors des heures prévues à ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00237",
                            'l’article 59, l’autorisation est délivrée par le juge des libertés et ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00238",
                            'de la détention saisi à cette fin. Ces opérations, qui ne peuvent ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00239",
                            'avoir d’autre fin que la mise en place du dispositif technique, sont ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00240",
                            'effectuées sous l’autorité et le contrôle du juge des libertés et de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00241",
                            'la détention. Les mêmes règles s’appliquent aux opérations de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00242",
                            'désinstallation.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00243",
                            'Le juge des libertés et de la détention, à la requête du procureur ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00244",
                            'de la République, peut aussi autoriser la transmission du dispositif ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00245",
                            'par un réseau de communications électroniques. Ces opérations sont ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00246",
                            'également réalisées sous son autorité et son contrôle.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00247",
                          'La mise en place du dispositif technique ne peut concerner les systèmes ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00248",
                          'automatisés de traitement des données se trouvant dans les lieux visés ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00249",
                          'aux articles 56-1, 56-2, 56-3 et 56-5, ni être réalisée dans le véhicule, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00250",
                          'le bureau ou le domicile des personnes visées aux articles 100-7 et ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00251",
                          '803-10 du Code de procédure pénale (députés, sénateurs, représentants au ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00252",
                          'Parlement européen élus en France, avocats, magistrats).',
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00253",
                  '2.1.2 - Le dispositif du « dossier coffre » (articles 706-104 et 706-104-1)',
                ),
              ),

              const SizedBox(height: 8),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                  "f00254",
                  'Principe du « dossier coffre »',
                ),
                cardColor: cardColor,
                accent: accent,
                titleColor: titleColor,
                children: [
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00255",
                          'Le « dossier coffre » est un procès-verbal distinct de la procédure, auquel ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00256",
                          'les parties n’ont pas accès. On y consigne notamment :',
                        ),
                  ),
                  SizedBox(height: 4),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00257",
                          'les informations relatives à la date, l’heure et le lieu de la mise ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00258",
                          'en place des dispositifs techniques d’enquête ;',
                        ),
                  ),
                  _BulletPoint(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00259",
                          'les éléments permettant d’identifier une personne ayant concouru à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00260",
                          'l’installation ou au retrait du dispositif technique.',
                        ),
                  ),
                  SizedBox(height: 6),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00261",
                            'Sont concernés l’ensemble des dispositifs techniques visés aux articles ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00262",
                            '706-95 à 706-102-5 du Code de procédure pénale : interceptions de ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00263",
                            'correspondances émises par la voie des communications électroniques, ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00264",
                            'accès à distance aux correspondances stockées, recueil des données ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00265",
                            'techniques de connexion (IMSI-catcher), sonorisation et fixation ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00266",
                            'd’images de certains lieux ou véhicules, captation de données ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00267",
                            'informatiques.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                  SizedBox(height: 6),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00268",
                          'Le « dossier coffre » ne peut être utilisé que sur autorisation du juge ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00269",
                          'des libertés et de la détention, à la requête du procureur de la ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00270",
                          'République, et seulement lorsque la divulgation des informations ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00271",
                          'concernées serait de nature à mettre gravement en danger la vie ou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00272",
                          'l’intégrité physique d’une personne, de sa famille ou de ses proches.',
                        ),
                  ),
                  SizedBox(height: 4),
                  _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00273",
                            'L’article 706-104-1 du Code de procédure pénale précise enfin les ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00274",
                            'conditions dans lesquelles le versement d’informations dans ce ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00275",
                            'dossier distinct peut être contesté, ainsi que celles dans ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00276",
                            'lesquelles les éléments de preuve recueillis au moyen d’une ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00277",
                            'technique spéciale d’enquête donnant lieu à un tel versement ',
                          ) +
                          ScolariteText.value(
                            "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                            "f00278",
                            'peuvent être utilisés.',
                          ),
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 26),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00279",
                          'Version au 01/07/2025 – SDCP – Tous droits réservés. Toujours vérifier ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00280",
                          'la base légale exacte (articles 706-95-11 à 706-104-1 du Code de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00281",
                          'procédure pénale) avant la mise en œuvre d’une technique spéciale ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/criminalite_deliquance/autres_techniques_gpx_school.dart",
                          "f00282",
                          'd’enquête.',
                        ),
                  ),
                ],
              ),
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
