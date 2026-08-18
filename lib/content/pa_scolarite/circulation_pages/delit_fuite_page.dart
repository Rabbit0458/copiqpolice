import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaDelitFuitePage extends StatelessWidget {
  const PaDelitFuitePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/socle_initial/circulation/delit_fuite';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
        ? const Color(0xFF1E1F22)
        : const Color(0xFFF2F2F2);

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
            "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
            "f00002",
            "Infractions circulation routière",
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
              "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
              "f00003",
              "Le délit de fuite",
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
              "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00005",
                      "Le fait, pour tout conducteur d’un véhicule ou engin terrestre, fluvial ou maritime, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00006",
                      "sachant qu’il vient de causer ou d’occasionner un accident, de ne pas s’arrêter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00007",
                      "et de tenter ainsi d’échapper à la responsabilité pénale ou civile qu’il peut avoir encourue, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00008",
                      "constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal EN HAUT
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00010",
                    "Article 434-10 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00011",
                    "article L. 231-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00012",
                    " : définissent et répriment le délit de fuite.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00014",
                  "A) Un conducteur de véhicule / d’engin",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00015",
                      "Il s’agit de la personne qui assume la direction de tout véhicule (ou ensemble de véhicules). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00016",
                      "Elle possède la maîtrise matérielle des mouvements du véhicule.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00017",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00018",
                    "articles R. 412-6 et R. 412-44 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                          "f00019",
                          "Ne sont pas concernés : les piétons (y compris ceux qui poussent une voiture d’enfant, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                          "f00020",
                          "un fauteuil, un vélo/cycle à la main, un caddie…), ni les conducteurs des matériels roulants ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                          "f00021",
                          "des chemins de fer.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00022",
                  "B) Le véhicule / l’engin",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00023",
                  "Sont visés :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00024",
                  "Véhicules routiers : voitures, PL, transports en commun, motos, cyclomoteurs, camions, tracteurs, engins agricoles, tricycles/quadricycles à moteur, cycles, EDPM motorisés, engins à traction animale, voiture à bras.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00025",
                  "Engins fluviaux et maritimes : engins nautiques sans moteur (barques, planches à voile) et engins motorisés (bateaux, péniches, off-shore, jet ski, hydroglisseurs…).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00026",
                  "Engins volants",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00027",
                      "Le délit de fuite est applicable en cas d’accident causé par un aéronef (aux personnes de la surface), selon ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00028",
                      "l’article L. 6142-9 du code des transports",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00029",
                      ", sauf si l’arrêt de l’aéronef aurait compromis la sécurité des passagers (avions, hélicoptères, delta-plane, ULM, parachutes…).",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00030",
                  "C) Un accident",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00031",
                      "Il peut s’agir d’un accident mortel, corporel ou matériel : fait involontaire ayant provoqué ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00032",
                      "un dommage aux personnes ou aux biens, événement fortuit et anormal.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00033",
                    "Jurisprudence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00034",
                    "Cass. crim., 4 mai 1950",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00035",
                      "L’accident doit s’être produit en un lieu public ou privé ouvert à la circulation et au stationnement. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00036",
                      "Il peut concerner des biens meubles/immeubles (murs, véhicules, barrières…) ou des animaux, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00037",
                      "mais seulement s’il cause un préjudice à autrui.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00038",
                  "D) Lien de causalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00039",
                  "Le véhicule/engin doit avoir causé ou occasionné l’accident : le lien de causalité est exigé.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00040",
                  "Soit le véhicule est impliqué : contact avec la victime/la chose endommagée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00041",
                  "Soit le véhicule a occasionné l’accident : pas nécessairement de contact (ex. manœuvre provoquant une chute/une collision).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00042",
                  "E) Une omission de s’arrêter",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00043",
                    "Article R. 231-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00044",
                    " : tout conducteur/usager impliqué dans un accident doit :",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00045",
                  "S’arrêter aussitôt que possible sans créer un danger pour la circulation.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00046",
                  "Si dégâts matériels uniquement : communiquer son identité et son adresse à toute personne impliquée.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00047",
                  "S’il y a blessés ou tués : faire avertir/avertir les services de police ou de gendarmerie, communiquer son identité/adresse, éviter de modifier l’état des lieux et préserver les traces utiles.",
                ),
              ),

              SizedBox(height: 12),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00048",
                    "Précisions : arrêt aussitôt et sur les lieux. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00049",
                    "(Cass. crim., 19 mars 1956 ; Cass. crim., 12 juillet 1966)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                        "f00050",
                        "La durée de l’arrêt importe peu, mais elle doit être suffisante pour permettre l’identification ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                        "f00051",
                        "par la partie adverse et/ou les témoins, et un minimum de constatations matérielles. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00052",
                    "(Cass. crim., 26 mai 1910 ; Cass. crim., 2 octobre 1978)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00053",
                  "Jurisprudences (illustrations)",
                ),
              ),
              _NotaBox(
                title: "Exemples",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00054",
                      "• Le conducteur prend la fuite puis revient : délit constitué ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00055",
                      "(Cass. crim., 4 novembre 2003)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00056",
                      "• Ne s’arrête pas puis se présente ensuite à la police/gendarmerie : délit constitué ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00057",
                      "(Cass. crim., 19 mars 1956 ; 19 novembre 1974)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00058",
                      "• S’arrête mais donne un faux nom/une fausse adresse : délit constitué ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00059",
                      "(Cass. crim., 14 avril 1959)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00060",
                      "• Manifeste l’intention de fuir mais est empêché (véhicule endommagé / retenu) : délit constitué ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00061",
                      "(Cass. crim., 10 juin 1970)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00062",
                      "• S’arrête assez longtemps pour permettre le relevé de l’immatriculation : délit non constitué (même s’il refuse de décliner son identité) ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00063",
                      "(Cass. crim., 16 janvier 1958 ; 2 juillet 1969)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
              "f00064",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00065",
                  "A) Conscience d’avoir causé/occasionné un accident",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00066",
                  "Le conducteur a connaissance de l’accident : il s’en est rendu compte, il l’a vu, il l’a constaté.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00067",
                  "B) Volonté d’échapper à une responsabilité pénale ou civile",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                        "f00068",
                        "Il n’est pas nécessaire que le juge constate une responsabilité effectivement encourue : ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                        "f00069",
                        "il suffit que l’auteur ait pu l’encourir. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00070",
                    "(Cass. crim., 23 mai 1953)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00071",
                  "Le conducteur a la volonté de se soustraire à sa propre responsabilité par la fuite.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
              "f00072",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00073",
                  "Aucune (au titre du délit de fuite lui-même).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00074",
                      "Article 434-10 alinéa 2 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                          "f00075",
                          " : lorsque les articles 221-6 et 222-19 s’appliquent, les peines prévues par ces articles sont portées au double ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                          "f00076",
                          "(uniquement pour véhicule/engin terrestre sans moteur, fluvial ou maritime).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00077",
                  "À retenir",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                          "f00078",
                          "Le délit de fuite (VTM) peut aussi constituer une circonstance aggravante de l’homicide involontaire ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                          "f00079",
                          "ou des atteintes involontaires : ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00080",
                      "articles 221-6-1, 222-19-1 et 222-20-1 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
              "f00081",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00082",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00083",
                    "Qualification : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00084",
                    "délit. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00085",
                    "— Peines principales : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00086",
                    "3 ans d’emprisonnement et 75 000 € d’amende. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00087",
                    "Article 434-10 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00088",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00089",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00090",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00091",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                    "f00092",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                  "f00093",
                  "Illustration (complicité)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00094",
                      "Est complice par provocation (assortie d’abus d’autorité) le propriétaire qui ordonne à son chauffeur de poursuivre sa route après un accident ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/circulation_pages/delit_fuite_page.dart",
                      "f00095",
                      "(TGI Paris, 19 novembre 1982)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
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
