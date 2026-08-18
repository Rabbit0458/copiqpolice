import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ExtraditionDroitCommunPage extends StatelessWidget {
  const ExtraditionDroitCommunPage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/entraide_judiciaire/extradition_droit_commun';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF2F2F2F) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color titleCardColor = isDark
        ? Colors.white
        : const Color(0xFF0D47A1);

    Color lawRed() => Colors.red.shade700;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
            "f00001",
            'Retour',
          ),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
            "f00002",
            'Extradition — Droit commun',
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
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        children: [
          // ===============================================================
          // EN-TÊTE GÉNÉRAL
          // ===============================================================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00003",
              '3 — L’extradition',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00004",
              '3.1 — La procédure d’extradition de droit commun',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.2,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00005",
                  'L’extradition consiste en la remise, par l’État où une personne s’est réfugiée ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00006",
                  '(État requis), à l’État où elle doit être jugée ou exécuter une peine ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00007",
                  '(État requérant). Elle constitue un outil classique de coopération pénale ',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00008",
                  'internationale, applicable en dehors du champ du mandat d’arrêt européen.',
                ),
          ),
          const SizedBox(height: 16),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00009",
              'Cadre juridique et champ d’application',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00010",
                    'La procédure d’extradition de droit commun est prévue par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00011",
                    'les articles 696 à 696-24 et 696-34 à 696-47-1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00012",
                    '. Elle n’est applicable qu’en l’absence de conventions internationales spécifiques.',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00013",
                      'Toutes les demandes d’extradition émanant ou adressées à des États qui ne sont pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00014",
                      'membres de l’Union européenne relèvent de cette procédure de droit commun. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00015",
                      'Il en va de même des demandes provenant d’États membres de l’Union européenne, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00016",
                      'ou à destination de ceux-ci, lorsque la procédure de mandat d’arrêt européen ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00017",
                      'n’est pas applicable.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 3.1.1  CONDITIONS DE MISE EN ŒUVRE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00018",
              '3.1.1 — Conditions de mise en œuvre',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00019",
              '3.1.1.1 — Conditions de fond',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00020",
                      'La France n’extrade pas ses nationaux, ni les étrangers qui sont justiciables ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00021",
                      'des tribunaux français. Il n’y a pas d’extradition pour des infractions à caractère ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00022",
                      'exclusivement politique.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00023",
                  'L’extradition n’est envisageable que pour des faits d’une gravité suffisante :',
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00024",
                  'Faits passibles de peines criminelles dans l’État requérant ;',
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00025",
                  'Faits passibles de peines correctionnelles dans l’État requérant :',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00026",
                      'si la personne n’a pas encore été condamnée, la peine encourue doit être ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00027",
                      'd’au moins deux ans d’emprisonnement ;',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00028",
                      'si la personne est déjà condamnée, la peine prononcée doit être d’au moins ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00029",
                      'deux mois d’emprisonnement.',
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00030",
                      'Nécessité d’une double incrimination des faits : l’infraction doit être réprimée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00031",
                      'à la fois par la loi de l’État requérant et par la loi française.',
                    ),
              ),
              SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00032",
                    'Ce principe de double incrimination est rappelé par l’ ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00033",
                    'article 696-2 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(text: '.'),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                  "f00034",
                  'En matière de compétence territoriale :',
                ),
              ),
              SizedBox(height: 6),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00035",
                      'l’infraction a été commise sur le territoire de l’État requérant par un ressortissant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00036",
                      'de cet État ou par un étranger ;',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00037",
                      'l’infraction a été commise hors du territoire de l’État requérant par un ressortissant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00038",
                      'de cet État ;',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00039",
                      'l’infraction a été commise hors du territoire de l’État requérant par une personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00040",
                      'étrangère à cet État, alors même que la loi française autorise la poursuite en France ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00041",
                      'de ce type de faits, y compris lorsqu’ils ont été commis à l’étranger par un étranger.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 3.1.1.2  PROCÉDURE APPLICABLE
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00042",
              '3.1.1.2 — Procédure applicable à l’extradition',
            ),
          ),
          const SizedBox(height: 4),

          // -------------------- France État requérant ---------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00043",
              '3.1.1.2.1 — La France « État requérant »',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00044",
                      'Lorsque la France sollicite l’extradition d’une personne se trouvant à l’étranger, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00045",
                      'le procureur de la République transmet au procureur général une demande d’extradition, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00046",
                      'accompagnée du jugement, de l’arrêt ou du mandat d’arrêt constitutif du titre exécutoire.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00047",
                      'Le procureur général adresse ensuite le dossier au ministre de la Justice. Ce dernier le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00048",
                      'transmet au ministre des Affaires étrangères, qui saisit les autorités compétentes de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00049",
                      'l’État requis.',
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00050",
                      'Au sein de l’Union européenne, la transmission peut être plus directe : le procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00051",
                      'général remet le dossier au ministre des Affaires étrangères sans passer par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00052",
                      'l’intermédiaire du ministre de la Justice.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // -------------------- France État requis ------------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00053",
              '3.1.1.2.2 — La France « État requis »',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00054",
                      'Lorsque la France est l’État requis, la demande d’extradition est en principe adressée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00055",
                      'au ministre des Affaires étrangères par l’État requérant. Celui-ci transmet la requête ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00056",
                      'au garde des Sceaux qui, après contrôle de sa régularité, la fait parvenir au procureur ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00057",
                      'général territorialement compétent.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00058",
                    'Cette étape est notamment prévue par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00059",
                    'l’article 696-9 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00060",
                      'Lorsque la demande émane d’un État membre de l’Union européenne, elle est adressée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00061",
                      'directement au ministre de la Justice, sans passer par le ministre des Affaires étrangères.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00062",
                        'Pour la recherche d’une personne faisant l’objet d’une demande d’extradition ou ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00063",
                        'd’une arrestation provisoire en vue d’extradition, ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00064",
                    'l’article 696-9-1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00065",
                        ' rend applicables les dispositions relatives notamment à la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00066",
                        'géolocalisation prévues par les articles 74-2 et 230-33. Les attributions du ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00067",
                        'procureur de la République et du juge des libertés et de la détention sont alors ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00068",
                        'exercées respectivement par le procureur général et le président de la chambre de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00069",
                        'l’instruction (ou le conseiller qu’il désigne).',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00070",
                        'L’arrestation de la personne peut être ordonnée. L’agent chargé de son exécution ne ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00071",
                        'peut s’introduire dans un domicile que dans les plages horaires prévues par ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00072",
                    'l’article 134 alinéa 1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00073",
                    ' (entre 6 heures et 21 heures).',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00074",
                    'La personne interpellée bénéficie des règles de la garde à vue, en application de ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00075",
                    'l’article 696-10 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00076",
                        ', qui renvoie aux dispositions des articles 63-1 à 63-7 du Code de Procédure Pénale. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00077",
                        'Toutefois, en pratique, le droit à l’assistance d’un avocat lors des auditions et ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00078",
                        'confrontations a peu vocation à s’appliquer, la personne n’étant pas entendue sur les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00079",
                        'faits mais uniquement sur son identité avant la notification du titre de recherche ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00080",
                        '(circulaire CRIM 11-14/E8 du 31 mai 2011).',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00081",
                        'La personne appréhendée doit être déférée dans les quarante-huit heures au procureur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00082",
                        'général territorialement compétent (toujours en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00083",
                    'l’article 696-10 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ').'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00084",
                      'Après vérification de l’identité, le procureur général informe, dans une langue que la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00085",
                      'personne comprend, de l’existence et du contenu de la demande d’extradition, ainsi que de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00086",
                      'la possibilité d’être assistée par un avocat de son choix ou commis d’office. Mention de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00087",
                      'ces informations est portée au procès-verbal, à peine de nullité de la procédure.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00088",
                        'Le procureur général informe également l’intéressé de sa faculté de consentir ou non ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00089",
                        'à l’extradition et des conséquences juridiques de ce choix, conformément à ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00090",
                    'l’article 696-10 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00091",
                      'S’il décide de ne pas laisser la personne en liberté, le procureur général la présente au ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00092",
                      'premier président de la cour d’appel ou au magistrat du siège qu’il désigne. Celui-ci peut ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00093",
                      'ordonner l’incarcération et le placement sous écrou extraditionnel à la maison d’arrêt du lieu ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00094",
                      'de la cour d’appel.',
                    ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00095",
                    'Cette décision est prévue par ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00096",
                    'l’article 696-11 alinéa 2 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00097",
                        '. Le premier président (ou le magistrat désigné) peut cependant estimer que la ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00098",
                        'représentation de la personne à tous les actes de la procédure est garantie et décider de ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00099",
                        'la placer sous contrôle judiciaire ou sous assignation à résidence avec surveillance ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00100",
                        'électronique, sur le fondement des ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00101",
                    'articles 138 et 142-5 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00102",
                      'Un mandat d’arrêt peut être délivré contre la personne laissée libre, soumise au contrôle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00103",
                      'judiciaire ou à une assignation à résidence sous surveillance électronique, si elle se ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00104",
                      'soustrait volontairement à ces obligations.',
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00105",
                      'Si la personne consent à son extradition, elle comparaît devant la chambre de l’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00106",
                      'dans un délai de cinq jours à compter de sa présentation au procureur général. Si elle confirme ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00107",
                      'son consentement, la chambre de l’instruction lui en donne acte dans les sept jours suivant sa ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00108",
                      'comparution. En cas de consentement, aucun pourvoi en cassation n’est possible.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00109",
                      'Si la personne ne consent pas à son extradition, elle comparaît devant la chambre de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00110",
                      'l’instruction dans un délai de dix jours. Si elle confirme son refus, la chambre rend un avis ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00111",
                      'motivé sur la demande dans le délai d’un mois. Un pourvoi en cassation, limité à la forme, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00112",
                      'reste alors ouvert.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ===============================================================
          // 3.1.2  EFFETS DE L’EXTRADITION
          // ===============================================================
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00113",
              '3.1.2 — Les effets de l’extradition',
            ),
          ),
          const SizedBox(height: 4),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
              "f00114",
              'Décision sur la demande et mise en liberté éventuelle',
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleCardColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00115",
                        'Si l’avis motivé de la chambre de l’instruction est défavorable à l’extradition, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00116",
                        'celle-ci ne peut pas être accordée. La personne doit alors être remise en liberté si elle ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                        "f00117",
                        'n’est pas détenue pour une autre cause, en application de ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                    "f00118",
                    'l’article 696-17 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: lawRed(),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00119",
                      'Dans les autres cas, lorsque l’avis de la chambre de l’instruction est favorable, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00120",
                      'l’extradition est autorisée par un décret du Premier ministre, pris sur le rapport ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00121",
                      'du ministre de la Justice.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00122",
                      'Si, dans le délai d’un mois suivant la notification du décret à l’État requérant, la personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00123",
                      'n’a pas été effectivement reçue par cet État, elle est remise d’office en liberté et ne peut plus ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00124",
                      'être réclamée pour la même cause.',
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00125",
                      'Lorsque l’intéressé se trouve en liberté au moment de la mise à exécution du décret ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00126",
                      'd’extradition, le procureur général peut ordonner sa recherche et son arrestation. La personne ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                      "f00127",
                      'doit alors être remise à l’État requérant dans les sept jours suivant son arrestation.',
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00128",
                          'Arrestation provisoire : en cas d’urgence, et sur demande directe des autorités ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00129",
                          'compétentes de l’État requérant, le procureur général territorialement compétent peut ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00130",
                          'ordonner l’arrestation provisoire de la personne et son placement sous écrou ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00131",
                          'extraditionnel. La demande doit mentionner l’intention de transmettre une demande ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00132",
                          'd’extradition. À défaut de réception, par l’État français, des documents nécessaires à ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00133",
                          'l’extradition dans un délai de trente jours à compter de l’arrestation, la personne est ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00134",
                          'remise en liberté. La procédure d’extradition pourra toutefois être reprise ultérieurement ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00135",
                          'si les pièces requises sont transmises, conformément aux articles 696-23 et 696-24 du ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/cadres_juridiques_pages/entraide_judiciaire/extradition_droit_commun_page.dart",
                          "f00136",
                          'Code de Procédure Pénale.',
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
