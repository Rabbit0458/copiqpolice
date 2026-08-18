import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaDisparitionInquietanteProcedureGpxSchool extends StatelessWidget {
  const PaDisparitionInquietanteProcedureGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/disparitions_inquietantes/chapitre2';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF303030)
        : const Color(0xFFF3F4F6);
    final Color textMain = isDark ? Colors.white : const Color(0xFF111827);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF374151).withValues(alpha: .88);

    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFFFFFFF);
    final Color accent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMain),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
            "f00001",
            'Disparitions inquiétantes',
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
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
              "f00002",
              'Chapitre 2 – Procédures des articles 74-1 et 80-4 du code de procédure pénale',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 19,
              height: 1.25,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00003",
                  'Autorités compétentes et actes d’enquête mis en œuvre dans le cadre spécifique ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00004",
                  'des disparitions inquiétantes (articles 74-1 et 80-4 du code de procédure pénale).',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.4,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // ========================= 2.1 - AUTORITÉS =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
              "f00005",
              '2.1 – Les autorités habilitées',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00006",
                  '2.1.1 – Les magistrats',
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00007",
                  '2.1.1.1 – Le procureur de la République',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00008",
                      'Aux termes de l’article 74-1 alinéa 1 du code de procédure pénale, ce cadre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00009",
                      'spécifique d’enquête ne peut être mis en œuvre que sur instructions du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00010",
                      'procureur de la République. Ce magistrat doit donc être avisé de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00011",
                      'disparition dès que les enquêteurs estiment nécessaire de recourir aux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00012",
                      'dispositions prévues par les articles 74-1 ou 80-4 du code de procédure pénale.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00013",
                      'Une fois avisé par l’officier de police judiciaire ou l’agent de police ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00014",
                      'judiciaire, le procureur de la République peut :',
                    ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00015",
                      'Décider de ne pas ouvrir l’une des procédures judiciaires de l’article 74-1 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00016",
                      'et privilégier la procédure administrative de recherches prévue par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00017",
                      'l’article 26 de la loi n° 95-73 du 21 janvier 1995.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00018",
                      'Ordonner la poursuite des investigations dans le cadre de l’article 74-1 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00019",
                      'du code de procédure pénale.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00020",
                      'Demander la poursuite des investigations dans les formes de l’enquête ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00021",
                      'préliminaire, par exemple en l’absence de caractère flagrant de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00022",
                      'disparition ou lorsque les recherches menées au titre de l’article 74-1 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00023",
                      'n’ont pas abouti dans les huit jours.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00024",
                      'Requérir l’ouverture d’une information pour recherche des causes de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00025",
                      'disparition.',
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: 'NOTA',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                          "f00026",
                          'Lors de l’enlèvement avéré d’un mineur, le procureur de la République, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                          "f00027",
                          'sur le ressort duquel a eu lieu l’enlèvement, apprécie l’opportunité de ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                          "f00028",
                          'déclencher le plan d’alerte de la population « ALERTE ENLÈVEMENT », ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                          "f00029",
                          'conformément aux circulaires et notes ministérielles en vigueur.',
                        ),
                  ),
                ],
              ),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00030",
                  '2.1.1.2 – Le juge d’instruction',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00031",
                      'L’ouverture d’une information est prévue par l’article 74-1 alinéa 2 du code ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00032",
                      'de procédure pénale : le procureur de la République peut requérir l’ouverture ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00033",
                      'd’une information pour recherche des causes de la disparition.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00034",
                      'Le deuxième alinéa de l’article 80-4 du code de procédure pénale prévoit que ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00035",
                      'les membres de la famille ou les proches de la personne disparue peuvent se ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00036",
                      'constituer partie civile à titre incident. Ils ne peuvent pas, en revanche, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00037",
                      'provoquer directement l’ouverture d’une information pour recherche des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00038",
                      'causes de la disparition, qui reste une prérogative exclusive du procureur de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00039",
                      'la République. En cas d’inaction du parquet, la famille peut toutefois déposer ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00040",
                      'plainte avec constitution de partie civile en invoquant la commission d’une ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00041",
                      'infraction.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00042",
                      'L’information ouverte dans le cadre des articles 74-1 et 80-4 du code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00043",
                      'procédure pénale est dite exorbitante du droit commun car :',
                    ),
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00044",
                      'Elle a pour seul objet la recherche des causes de la disparition, le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00045",
                      'd’instruction n’étant pas saisi de l’ensemble des faits.',
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00046",
                  'Elle ne met pas, à ce stade, en mouvement l’action publique.',
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00047",
                      'Le juge d’instruction dispose de tous les pouvoirs de l’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00048",
                      'préparatoire (article 80-4 du code de procédure pénale). Les interceptions de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00049",
                      'correspondances émises par voie de télécommunications ne peuvent toutefois ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00050",
                      'excéder une durée de deux mois renouvelable.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00051",
                      'Il peut, par commission rogatoire, déléguer un officier de police judiciaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00052",
                      'pour la recherche des causes de la disparition.',
                    ),
              ),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00053",
                  '2.1.2 – L’officier ou l’agent de police judiciaire',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00054",
                      'Lorsque la disparition d’une personne est portée à sa connaissance, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00055",
                      'l’officier de police judiciaire, ou l’agent de police judiciaire agissant sous ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00056",
                      'son contrôle, doit apprécier le caractère inquiétant de la disparition. Si les ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00057",
                      'conditions sont réunies pour appliquer les articles 74-1 ou 80-4 du code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00058",
                      'procédure pénale, il avise le procureur de la République, qui décide de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00059",
                      'l’opportunité d’organiser les recherches dans un cadre juridique ou ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00060",
                      'administratif.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00061",
                      'L’officier de police judiciaire ou l’agent, agissant sous son contrôle, peut se ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00062",
                      'voir déléguer les pouvoirs visant à déterminer les causes de la disparition. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00063",
                      'L’officier de police judiciaire peut également se voir déléguer les pouvoirs du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00064",
                      'juge d’instruction par commission rogatoire.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ========================= 2.2 - ACTES D'ENQUÊTE ===================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
              "f00065",
              '2.2 – Les actes de l’enquête',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00066",
                  '2.2.1 – Les actes délégués par le procureur de la République',
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00067",
                  '2.2.1.1 – Les actes prévus par les articles 56 à 62 du code de procédure pénale',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00068",
                      'Les officiers de police judiciaire ou les agents de police judiciaire, agissant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00069",
                      'sous leur contrôle, peuvent procéder, chacun dans la limite de ses ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00070",
                      'prérogatives, à tous les actes de l’enquête de flagrance prévus aux articles 56 ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00071",
                      'à 62 du code de procédure pénale. Il s’agit notamment :',
                    ),
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00072",
                  'Des perquisitions (y compris sans l’accord de l’intéressé) et des saisies.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00073",
                  'Des réquisitions diverses et des interdictions de s’éloigner des lieux.',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00074",
                  'Des convocations, comparutions forcées et auditions.',
                ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00075",
                      'Dans ce cadre, aucune mesure de garde à vue ne peut être prise, car il n’existe ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00076",
                      'pas encore de suspicion suffisamment caractérisée de crime ou de délit.',
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00077",
                  '2.2.1.2 – La poursuite des investigations',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00078",
                      'Après l’expiration du délai de huit jours suivant les instructions du procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00079",
                      'de la République, les investigations peuvent se poursuivre, sans limitation de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00080",
                      'durée, dans les formes de l’enquête préliminaire (article 75 du code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00081",
                      'procédure pénale).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00082",
                      'Il en va de même lorsque l’enquête est ouverte un certain temps après la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00083",
                      'disparition, alors que le caractère flagrant de celle-ci n’est plus constitué.',
                    ),
              ),
              SizedBox(height: 16),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                  "f00084",
                  '2.2.2 – Les actes délégués par le juge d’instruction',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00085",
                      'Dans le cadre d’une information judiciaire pour recherche des causes de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00086",
                      'disparition (article 80-4 du code de procédure pénale), le juge d’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00087",
                      'peut charger l’officier de police judiciaire, par commission rogatoire, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00088",
                      'd’exécuter les actes nécessaires à la recherche des causes de la disparition.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00089",
                      'L’officier de police judiciaire peut alors réaliser des constatations, saisies et ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00090",
                      'scellés, réquisitions, auditions et perquisitions. Sous l’autorité et le contrôle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00091",
                      'du juge d’instruction, les interceptions de correspondances émises par voie ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00092",
                      'de télécommunications peuvent être réalisées pour une durée maximale de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00093",
                      'deux mois renouvelable.',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00094",
                      'Le placement en garde à vue est possible à l’encontre des personnes contre ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00095",
                      'lesquelles il existe une ou plusieurs raisons plausibles de soupçonner qu’elles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00096",
                      'ont commis une infraction. Ce placement peut ensuite justifier la délivrance ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00097",
                      'd’un réquisitoire introductif ouvrant une information relative à l’infraction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00098",
                      'ainsi découverte, permettant, le cas échéant, des mises en examen et des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00099",
                      'placements en détention provisoire.',
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00100",
                      'Dans ce contexte, les officiers de police judiciaire, sous le contrôle du juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00101",
                      'd’instruction, peuvent notamment :',
                    ),
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00102",
                      'Au cours d’une perquisition, accéder à des données informatiques stockées ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00103",
                      'sur des serveurs distants (articles 97-1 et 57-1 alinéa 1 du code de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00104",
                      'procédure pénale).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00105",
                      'Requérir toute personne susceptible d’avoir connaissance des mesures ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00106",
                      'appliquées pour protéger ces données, ou susceptible de remettre des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00107",
                      'informations permettant d’y accéder (articles 97-1 et 57-1 alinéa 5 du code ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00108",
                      'de procédure pénale).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00109",
                      'Requérir les opérateurs de télécommunications afin de prendre, sans délai, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00110",
                      'toutes mesures propres à assurer la préservation du contenu des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00111",
                      'informations consultées par les utilisateurs de leurs services ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00112",
                      '(articles 99-4 et 60-2 alinéa 2 du code de procédure pénale).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00113",
                      'Procéder à des réquisitions pour l’installation d’un dispositif d’interception ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00114",
                      'des communications électroniques et pour la transcription des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00115",
                      'correspondances utiles à la manifestation de la vérité ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00116",
                      '(articles 100-3 à 100-5 du code de procédure pénale).',
                    ),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00117",
                      'Dans le cadre des interceptions de correspondances émises par la voie des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00118",
                      'communications électroniques, les assistants d’enquête peuvent, à la demande ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00119",
                      'expresse et sous le contrôle de l’officier de police judiciaire commis par le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00120",
                      'juge d’instruction, procéder à la transcription de la correspondance utile à la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/cadres_juridiques_pages/disparition/disparitions_inquietantes_procedure_gpx_school.dart",
                      "f00121",
                      'manifestation de la vérité (article 100-5 du code de procédure pénale).',
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
