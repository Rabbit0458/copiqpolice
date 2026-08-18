import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PrivationAlimentsSoinsMineur15Page extends StatelessWidget {
  const PrivationAlimentsSoinsMineur15Page({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15';

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
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

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
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
            "f00002",
            "Mise en péril",
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
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
              "f00003",
              "La privation d’aliments ou de soins à mineur de quinze ans",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00005",
                      "Le fait, par un ascendant ou toute autre personne exerçant à l’égard d’un mineur de quinze ans ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00006",
                      "l’autorité parentale ou une autorité, de priver celui-ci d’aliments ou de soins au point de compromettre sa santé, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00007",
                      "constitue une infraction.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00008",
                      "Constitue notamment une privation de soins le fait de maintenir un enfant de moins de six ans sur la voie publique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00009",
                      "ou dans un espace affecté au transport collectif de voyageurs, dans le but de solliciter la générosité des passants.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
              "f00010",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00011",
                    "Article 227-15 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00012",
                    " : définit et réprime la privation d’aliments ou de soins à mineur de quinze ans.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel — 3 blocs pédagogiques
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00014",
                  "A) Une victime mineure de moins de quinze ans",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00015",
                      "L’infraction n’est constituée que si la victime est un mineur âgé de moins de quinze ans. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00016",
                      "La loi pénale étant d’interprétation stricte, l’article 227-15 ne s’applique pas à un mineur de plus de quinze ans.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00017",
                  "À retenir",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00018",
                      "Si la victime a plus de quinze ans, d’autres qualifications peuvent être envisagées (ex. séquestration : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00019",
                      "articles 224-1 et suivants du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00020",
                      ", ou soustraction d’un parent à ses obligations légales : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00021",
                      "article 227-17 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ")."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00022",
                  "B) La qualité de l’auteur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00023",
                  "Le texte vise trois catégories d’auteurs :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00024",
                  "Les ascendants : père, mère, grands-parents, arrière-grands-parents.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00025",
                  "Les personnes exerçant l’autorité parentale : peut inclure le tuteur, et les personnes ayant reçu une délégation d’autorité parentale (code civil).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00026",
                  "Les personnes exerçant une autorité de fait : nouveau conjoint/concubin, personne à qui l’enfant est confié, responsables/employés de l’aide sociale à l’enfance, etc.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00027",
                  "C) Une privation d’aliments ou de soins + compromission de la santé",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00028",
                  "La privation d’aliments consiste à ne pas fournir une nourriture en quantité ou en qualité suffisante.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00029",
                      "La privation de soins est constituée lorsqu’on ne s’occupe pas matériellement de l’enfant au quotidien ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00030",
                      "et qu’on ne lui fournit pas les soins nécessaires (hygiène, soins médicaux, prise en charge adaptée).",
                    ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00031",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00032",
                      "Infraction retenue : laisser deux enfants seuls à la maison, sans gaz, ni eau, ni électricité, avec un réfrigérateur rempli parfois de nourriture qu’ils ne pouvaient pas cuire ; voisins les nourrissant ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00033",
                      "(C.A. Douai, 15 février 2006)",
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

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00034",
                    "Une présomption de privation de soins figure au 2ᵉ alinéa : est notamment visé le fait de maintenir un enfant de moins de six ans sur la voie publique / transport collectif pour solliciter la générosité. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00035",
                    "article 227-15 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00036",
                  "Attention",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00037",
                      "Le simple fait de mendier avec un enfant en bas âge n’est pas, en soi, constitutif du délit ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00038",
                      "(Cass. crim., 12 octobre 2005)",
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

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00039",
                    "La privation doit être « au point de compromettre la santé » du mineur : exigence confirmée par la jurisprudence. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00040",
                    "(T.G.I. Paris, 13 janvier 2004)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00041",
                      "Il n’est pas nécessaire que l’atteinte soit grave ni que le dommage soit effectif : il suffit que les privations ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00042",
                      "soient susceptibles d’altérer la santé du mineur. Les juges apprécient au cas par cas l’impact réel ou potentiel.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00043",
                    "Dans l’arrêt du 12 octobre 2005, la Cour de cassation a validé une relaxe : l’enfant était en bonne santé au vu des pièces produites, malgré le maintien sur la voie publique. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00044",
                    "(Cass. crim., 12 octobre 2005)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
              "f00045",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00046",
                  "Conscience que les privations risquent de causer un dommage",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00047",
                      "La privation d’aliments ou de soins est une infraction intentionnelle : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00048",
                      "elle nécessite la conscience, la connaissance ou la prévision qu’il en résulterait un mal pour l’enfant.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00049",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00050",
                    "(Cass. crim., 11 mars 1975)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00051",
                      "La volonté de nuire ou de causer un dommage n’est pas exigée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00052",
                      "Les convictions religieuses ou le souci d’éducation ne justifient pas les privations dès lors que ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                      "f00053",
                      "l’auteur a conscience que la santé du mineur risque d’être altérée.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
              "f00054",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00055",
                    "Article 227-15 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00056",
                  "Lorsque la personne visée à l’alinéa 1 s’est rendue coupable, sur le même mineur, du délit de non-déclaration de naissance.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00057",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00058",
                    "article 433-18-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00059",
                    "Article 227-16 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00060",
                  "Lorsque la privation d’aliments ou de soins a entraîné la mort de la victime.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
              "f00061",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00062",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00063",
                    "Qualification simple (délit) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00064",
                    "7 ans d’emprisonnement et 100 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00065",
                    "article 227-15 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00066",
                    "Aggravée (délit — al. 3) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00067",
                    "10 ans d’emprisonnement et 300 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00068",
                    "article 227-15 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00069",
                    "Si la mort de la victime est entraînée (crime) : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00070",
                    "30 ans de réclusion criminelle — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00071",
                    "article 227-16 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00072",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00073",
                    "Responsabilité pénale possible : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00074",
                    "article 227-17-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00075",
                    " (amende selon l’article 131-38 et peines complémentaires de l’article 131-39).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00076",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00077",
                    "article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00078",
                    "article 131-39 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00079",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                  "f00080",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00081",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00082",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/mineurs_famille_pages/mise_en_peril/privation_aliments_soins_mineur_15_contenu_page.dart",
                    "f00083",
                    " (aide/assistance, provocation, instructions).",
                  ),
                ),
              ]),
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
