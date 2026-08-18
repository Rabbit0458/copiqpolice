import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaGPXSchoolElementsConstitutifsInfractionPage extends StatelessWidget {
  const PaGPXSchoolElementsConstitutifsInfractionPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/droit_penal_general/loi_penale/elements_constitutifs_infraction';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

    TextSpan redLaw(String s) => TextSpan(
      text: s,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
    );

    TextSpan normal(String s) => TextSpan(text: s);

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
            "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
            "f00002",
            "Éléments constitutifs de l’infraction",
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
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        children: [
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
              "f00003",
              "Les éléments constitutifs de l’infraction",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00004",
                  "Toute infraction suppose la réunion de trois éléments : un élément légal, ",
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00005",
                  "un élément matériel et un élément moral. Sans l’un d’eux, l’infraction n’existe pas.",
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 16),

          // ========================= CHAPITRE 1 =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
              "f00006",
              "CHAPITRE 1 : L’ÉLÉMENT LÉGAL",
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00007",
                  "Sans texte légal, il n’y a pas d’infraction, même si l’acte commis apporte un trouble à l’ordre public.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00008",
                    "Le principe de légalité est posé par ",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00009",
                    "l’article 111-3 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00010",
                    " : « nul ne peut être puni pour un crime ou pour un délit dont les éléments ne sont pas définis par la loi, ou pour les contraventions dont les éléments ne sont pas définis par le règlement ».",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00011",
                      "C’est un principe essentiel sur lequel repose l’ensemble du droit pénal. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00012",
                      "Si la norme suprême est la Constitution de 1958, les sources essentielles du droit pénal sont la loi ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00013",
                      "ainsi que les textes qui lui sont assimilés, et le règlement.",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00014",
                  "1.1 — LES LOIS PROPREMENT DITES ET TEXTES ASSIMILÉS",
                ),
              ),
              _Paragraph.rich([
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00015",
                    "L’article 111-2 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00016",
                    " dispose que la loi détermine les crimes et délits et fixe les peines applicables à leurs auteurs.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00017",
                  "Certains actes ont aussi valeur de loi :",
                ),
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00018",
                  "Décisions présidentielles prises en vertu de l’article 16 de la Constitution.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00019",
                  "Ordonnances, essentiellement celles prises en application de l’article 38 de la Constitution, ratifiées par le Parlement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00020",
                  "Décrets-lois (IIIe et IVe Républiques).",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00021",
                    "L’article 34 de la Constitution de 1958",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00022",
                    " précise que la loi fixe les règles concernant la détermination des crimes et délits, ainsi que les peines qui leur sont applicables.",
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00023",
                  "1.2 — LES TRAITÉS INTERNATIONAUX OU CONVENTIONS INTERNATIONALES",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00024",
                      "Selon la Constitution de 1958, les conventions internationales négociées par le Président de la République, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00025",
                      "signées par la France, ratifiées et publiées au Journal officiel ont une valeur supérieure à la loi interne.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00026",
                    "C’est le sens de ",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00027",
                    "l’article 55 de la Constitution",
                  ),
                ),
                normal(
                  ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                        "f00028",
                        ". Les plus importants sont notamment le Traité de Rome instituant la Communauté économique européenne ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                        "f00029",
                        "et la Convention européenne des droits de l’Homme. Le juge pénal français doit écarter le texte qui méconnaît une disposition du traité.",
                      ),
                ),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00030",
                  "1.3 — LES RÈGLEMENTS ADMINISTRATIFS",
                ),
              ),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00031",
                    "Ils émanent du pouvoir exécutif (gouvernement) en vertu de ",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00032",
                    "l’article 37 de la Constitution de 1958",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00033",
                    ". Ils sont hiérarchisés et ne peuvent aller à l’encontre de la loi.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00034",
                  "1.3.1 — Les décrets en Conseil d’État",
                ),
              ),
              _Paragraph.rich([
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00035",
                    "L’article 111-2 alinéa 2 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00036",
                    " dispose : « Le règlement détermine les contraventions et fixe les peines applicables aux contrevenants ».",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00037",
                    "Les contraventions, notamment au Code de la route, sont déterminées par des décrets pris en cette forme (",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00038",
                    "articles R. 610-1 et suivants du Code pénal",
                  ),
                ),
                normal(")."),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00039",
                  "1.3.2 — Les autres règlements",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00040",
                      "Il s’agit des décrets émanant du Président de la République ou du Premier ministre, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00041",
                      "des arrêtés pris par les ministres, les préfets, les maires.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00042",
                      "Tant qu’un décret d’application prévu par une loi pour en permettre la mise en vigueur n’est pas paru, cette loi reste lettre morte.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00043",
                  "1.4 — LES CIRCULAIRES",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00044",
                      "Ce sont des « instructions de service écrites adressées par une autorité supérieure à des agents subordonnés » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00045",
                      "(Direction des Affaires criminelles et des grâces). Elles ne sont pas source de droit pénal.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00046",
                    "Les circulaires et instructions sont publiées sur un site relevant du Premier ministre. Elles sont réputées abrogées si elles n’ont pas été publiées (",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00047",
                    "article L. 312-2 du Code des relations entre le public et l’administration",
                  ),
                ),
                normal(")."),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00048",
                  "1.5 — LA JURISPRUDENCE ET LA DOCTRINE",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00049",
                  "La jurisprudence est l’ensemble des décisions rendues par les tribunaux, et plus particulièrement par la Cour de cassation. Le principe de l’interprétation restrictive de la loi pénale a pour but d’empêcher la jurisprudence de devenir une source de droit pénal. Cependant, elle a souvent un rôle interprétatif de la règle de droit pénal.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00050",
                  "La doctrine consiste en l’énoncé des positions de juristes éminents. Elle n’a pas de valeur normative, et ne peut être qu’une source d’inspiration pour le législateur.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 2 =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
              "f00051",
              "CHAPITRE 2 : L’ÉLÉMENT MATÉRIEL",
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00052",
                      "L’élément matériel consiste en l’attitude positive ou négative réprimée par la loi : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00053",
                      "c’est la manifestation concrète de la volonté délictueuse du délinquant.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00054",
                      "Il peut prendre des formes variées : acte positif ou abstention, acte unique ou pluralité d’actes, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00055",
                      "acte instantané ou qui se prolonge dans le temps.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00056",
                      "La seule pensée criminelle n’est pas répréhensible si elle n’est pas matérialisée concrètement. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00057",
                      "Ainsi, la résolution criminelle (décision de commettre l’infraction) n’est pas punissable : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00058",
                      "il n’existe pas de manifestation extérieure d’une conduite répréhensible ; on est au stade de la pure intention.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00059",
                      "Les actes préparatoires échappent également à la répression (ex : collecter des renseignements précis sur les habitudes d’une victime…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00060",
                      "Ils peuvent être équivoques et la personne peut encore se désister.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00061",
                      "L’infraction consommée ne soulève pas de problème. En revanche, peut-on réprimer des actes qui, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00062",
                      "sans aller jusqu’à la réalisation complète de l’infraction, manifestent une volonté criminelle ? ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00063",
                      "C’est la tentative.",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00064",
                  "2.1 — LA TENTATIVE PUNISSABLE",
                ),
              ),
              _Paragraph.rich([
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00065",
                    "L’article 121-5 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                        "f00066",
                        " dispose : « la tentative est constituée dès lors que, manifestée par un commencement d’exécution, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                        "f00067",
                        "elle n’a été suspendue ou n’a manqué son effet qu’en raison de circonstances indépendantes de la volonté de son auteur ».",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00068",
                      "Pour qu’il y ait tentative, il faut la réunion de deux éléments : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00069",
                      "un commencement d’exécution et une absence de désistement volontaire.",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00070",
                  "2.1.1 — Le commencement d’exécution",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00071",
                  "2.1.1.1 — Définition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00072",
                      "Il est nécessaire de distinguer le commencement d’exécution des actes préparatoires qui, eux, ne sont pas punissables. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00073",
                      "Le Code pénal ne donne pas de définition du commencement d’exécution.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00074",
                  "2.1.1.2 — La position jurisprudentielle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00075",
                      "La Cour de cassation estime que la notion de commencement d’exécution est une question de droit soumise à son contrôle. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00076",
                      "Elle exige toujours la présence d’un double élément pour admettre l’existence d’un commencement d’exécution :",
                    ),
              ),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00077",
                  "Un acte univoque, caractéristique d’un commencement d’exécution.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00078",
                  "Une intention irrévocable de réaliser telle infraction précise.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00079",
                      "On est en présence d’un commencement d’exécution lorsque le comportement de l’agent traduit sans ambiguïté ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00080",
                      "sa volonté de commettre l’infraction.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00081",
                      "Dans l’affaire Lacour (Cass. crim. 5/10/1962), la Cour de cassation a décidé que le fait de payer un homme de main ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00082",
                      "pour commettre un assassinat, et de lui communiquer des renseignements dans ce but, ne constituait pas un commencement d’exécution.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00083",
                      "Caractérise la tentative d’évasion le fait, pour des détenus, de commencer à creuser le béton autour de la fenêtre de leur cellule ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00084",
                      "afin de provoquer le descellement des barreaux (CA Douai 11/08 et 21/09/2004).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00085",
                      "En revanche, le simple fait d’extérioriser oralement son intention de commettre une infraction n’est pas punissable, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00086",
                      "puisque rien ne prouve que l’intéressé passera à l’action.",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00087",
                  "2.1.2 — L’absence de désistement volontaire",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00088",
                  "2.1.2.1 — La notion de désistement",
                ),
              ),
              _Paragraph.rich([
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00089",
                    "L’article 121-5 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00090",
                    " précise que la tentative est punissable uniquement si « elle n’a été suspendue (…) qu’en raison de circonstances indépendantes de la volonté de son auteur ».",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00091",
                      "Si l’interruption de l’action est volontaire (renonciation sans cause extérieure), l’auteur n’est pas punissable. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00092",
                      "Peu importe la cause (pitié, remords, crainte du châtiment…).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00093",
                      "Lorsqu’il est déterminé par une cause extérieure, le désistement est involontaire : la tentative est alors punissable ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00094",
                      "(intervention de la police, passants, résistance de la victime, obstacle matériel : alarme, résistance d’un coffre-fort…).",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00095",
                  "2.1.2.2 — Le repentir actif",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00096",
                      "Le désistement doit être antérieur à la consommation de l’infraction. Pour bénéficier de l’impunité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00097",
                      "le délinquant doit abandonner son projet criminel avant la réalisation de l’infraction.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00098",
                      "Une fois l’infraction consommée, l’attitude postérieure est sans influence sur la responsabilité pénale ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00099",
                      "(ex : restitution après un abus de confiance).",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00100",
                  "2.1.3 — Le régime juridique de la tentative",
                ),
              ),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00101",
                    "Toutes les tentatives ne sont pas punissables. ",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00102",
                    "L’article 121-4 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                        "f00103",
                        " prévoit que la tentative est systématiquement poursuivie en matière de crime. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                        "f00104",
                        "Elle ne peut l’être en matière de délit que si le texte d’incrimination le spécifie. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                        "f00105",
                        "La tentative de contravention n’est jamais punissable.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00106",
                  "L’auteur d’une tentative est assimilé entièrement, quant à la répression, à l’auteur d’une infraction consommée.",
                ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00107",
                  "2.2 — LA TENTATIVE INFRUCTUEUSE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00108",
                      "L’auteur a fait tout ce qui était en son pouvoir pour que l’infraction se réalise, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00109",
                      "celle-ci n’ayant échoué qu’indépendamment de sa volonté et sans intervention extérieure.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00110",
                  "2.2.1 — L’infraction manquée",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00111",
                  "2.2.1.1 — Définition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00112",
                      "L’infraction manquée suppose une exécution complète des éléments de l’infraction qui ne réussit pas ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00113",
                      "à la suite de circonstances indépendantes de la volonté de l’auteur.",
                    ),
              ),
              const SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00114",
                  "Ex : celui qui tire un coup de feu, mais du fait de sa maladresse rate sa victime.",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00115",
                  "2.2.1.2 — Répression",
                ),
              ),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00116",
                    "L’infraction manquée est punie comme l’infraction tentée. ",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00117",
                    "L’article 121-5 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00118",
                    " vise la tentative qui « n’a manqué son effet qu’en raison de circonstances indépendantes de la volonté de son auteur ».",
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00119",
                  "2.2.2 — L’infraction impossible",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00120",
                  "2.2.2.1 — Définition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00121",
                      "L’auteur a mis tous les moyens en œuvre pour accomplir l’infraction, mais celle-ci ne pouvait se réaliser ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00122",
                      "en raison d’une impossibilité qu’il ignorait.",
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00123",
                  "Les causes d’impossibilité peuvent être diverses : tenir à l’objet (poche vide), aux moyens inefficaces (coup de feu tiré à blanc)…",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00124",
                  "2.2.2.2 — Répression",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00125",
                      "Le cas de l’infraction impossible n’étant pas prévu par la loi, sa répression ne peut se faire que dans le cadre de la tentative. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00126",
                      "Elle n’est donc punissable que lorsque la tentative est incriminée (crime et certains délits).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= CHAPITRE 3 =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
              "f00127",
              "CHAPITRE 3 : L’ÉLÉMENT MORAL",
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00128",
                  "Il n’y a pas d’infraction sans élément moral : l’acte répréhensible doit être issu de la volonté de son auteur.",
                ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00129",
                  "3.1 — DÉFINITION",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00130",
                      "Pour qu’une infraction soit constituée, il est nécessaire qu’existe un dol général : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00131",
                      "la conscience ou la volonté d’accomplir un acte illicite.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00132",
                      "La jurisprudence, dans un arrêt de la chambre criminelle de la Cour de cassation du 13 décembre 1956, rappelle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00133",
                      "que « toute infraction même non intentionnelle suppose que son auteur ait agi avec intelligence et volonté ».",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00134",
                      "Le mobile (raison concrète et personnelle) est indifférent au droit pénal : ce qui compte, c’est la conscience de l’illicéité. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00135",
                      "En pratique, le juge peut toutefois en tenir compte dans la détermination de la peine.",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00136",
                  "3.2 — FORMES DE L’ÉLÉMENT MORAL",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00137",
                  "3.2.1 — La faute intentionnelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00138",
                  "L’auteur a conscience du caractère illicite de son acte et a la volonté de l’accomplir et de produire un résultat dommageable.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00139",
                    "L’article 121-3 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00140",
                    " dispose qu’ « il n’y a point de crime ou délit sans intention de le commettre ».",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00141",
                  "Les infractions pour lesquelles l’élément moral est une faute intentionnelle sont des infractions intentionnelles.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00142",
                  "Parfois, la loi exige une intention particulière : c’est le dol spécial (ex : intention de tuer pour le meurtre, volonté de détruire pour la destruction de biens…).",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00143",
                  "Le dol peut être aggravé : la préméditation est une forme aggravée d’intention criminelle.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00144",
                  "Dol déterminé : le résultat obtenu correspond à celui voulu. Dol indéterminé : le résultat n’est pas connu à l’avance, la sanction dépend du résultat réellement produit.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00145",
                    "Dol praeter intentionnel : le résultat va au-delà de ce que l’auteur voulait. Exemple : frapper pour blesser mais tuer finalement : ",
                  ),
                ),
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00146",
                    "article 222-7 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00147",
                    " (violences ayant entraîné la mort sans intention de la donner).",
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00148",
                  "3.2.2 — La faute non intentionnelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00149",
                  "L’individu ne recherche aucun résultat particulier, mais ne respecte pas les valeurs sociales protégées pénalement.",
                ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00150",
                  "3.2.2.1 — La faute d’imprudence ou de négligence",
                ),
              ),
              _Paragraph.rich([
                redLaw(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00151",
                    "L’article 121-3 alinéa 3 du Code pénal",
                  ),
                ),
                normal(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                    "f00152",
                    " dispose qu’elle consiste en une imprudence, négligence ou manquement à une obligation de prudence ou de sécurité prévue par la loi ou le règlement.",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00153",
                      "La faute consiste à ne pas avoir prévu qu’un dommage pouvait survenir : l’auteur a fait courir un danger aux autres par son imprudence. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00154",
                      "Il n’a ni prévu ni voulu le résultat dommageable.",
                    ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00155",
                  "3.2.2.1.1 — Formes de la faute",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00156",
                      "Ces fautes s’apprécient par comparaison avec le comportement d’un individu « normalement » adroit, attentif, prudent et diligent. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00157",
                      "Pour un professionnel, on se réfère au professionnel moyen ou diligent.",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00158",
                  "La faute pénale peut aussi résider dans la violation d’un texte : manquement à une obligation de prudence ou de sécurité prévue par la loi ou le règlement.",
                ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00159",
                  "3.2.2.1.2 — Existence d’un lien de causalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00160",
                      "Si le lien de causalité est direct, toute imprudence, négligence ou manquement suffit. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00161",
                      "Si la causalité est indirecte, il faut prouver une faute caractérisée.",
                    ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00162",
                  "3.2.2.2 — La faute de mise en danger délibérée de la personne d’autrui",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00163",
                  "La personne a délibérément pris un risque en espérant qu’aucun dommage n’en résulterait.",
                ),
              ),
              const SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00164",
                  "Exemple : entrepreneur qui fait monter ses ouvriers sur un échafaudage en sachant qu’il n’est pas conforme aux normes de sécurité.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00165",
                  "Elle suppose :",
                ),
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00166",
                  "Soit une violation manifestement délibérée d’une législation ou d’une réglementation comportant des prescriptions de sécurité ou de prudence.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00167",
                  "Soit une faute caractérisée exposant autrui à un risque d’une particulière gravité qu’il n’était pas possible d’ignorer.",
                ),
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00168",
                  "3.2.2.3 — La faute contraventionnelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00169",
                      "Elle consiste en la simple violation de la prescription légale ou réglementaire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                      "f00170",
                      "Elle est indépendante de la survenance d’un dommage : le simple fait de commettre l’acte interdit suffit.",
                    ),
              ),
              const SizedBox(height: 8),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00171",
                  "Ex : individu qui grille un feu rouge et explique qu’il n’a pas vu qu’il était rouge.",
                ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00172",
                  "La responsabilité de l’auteur pourra être écartée s’il prouve la contrainte ou la force majeure.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================= TABLEAUX (repris en texte structuré) =========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
              "f00173",
              "SYNTHÈSE — ÉLÉMENT MATÉRIEL : CONDITIONS",
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00174",
                  "ÉLÉMENT MATÉRIEL",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00175",
                  "ACTE POSITIF :",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00176",
                  "Une action physique de l’auteur",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00177",
                  "Un résultat",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00178",
                  "Un lien de causalité action / résultat",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00179",
                  "ACTE NÉGATIF :",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00180",
                  "Attitude passive dont il est résulté un dommage",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("TYPOLOGIE"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00181",
                  "Infraction de commission : l’individu commet un acte interdit par la loi.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00182",
                  "Infraction d’omission : l’individu omet de réaliser un acte prévu par la loi.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00183",
                  "Infraction de commission par omission.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
              "f00184",
              "SYNTHÈSE — ÉLÉMENT MORAL",
            ),
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00185",
                  "INTENTION COUPABLE",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00186",
                  "Faute intentionnelle",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00187",
                  "PAS D’INTENTION COUPABLE",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00188",
                  "Faute non intentionnelle",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00189",
                  "DOL GÉNÉRAL",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00190",
                  "Volonté d’accomplir un acte en sachant qu’il est défendu par la loi.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00191",
                  "DOL SPÉCIAL",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00192",
                  "Volonté d’accomplir les faits tels qu’ils sont décrits par la loi.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00193",
                  "FAUTE D’IMPRUDENCE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00194",
                  "Consiste en : maladresse, imprudence, inattention, négligence, manquement à une obligation de prudence ou de sécurité.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00195",
                  "FAUTE CONTRAVENTIONNELLE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/dpg_pages/gpx_school_elements_constitutifs_infraction_page.dart",
                  "f00196",
                  "Elle est présumée et consiste dans la violation de la prescription légale ou réglementaire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
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
