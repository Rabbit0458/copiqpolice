import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AtteinteSecretProfessionnelPage extends StatelessWidget {
  const AtteinteSecretProfessionnelPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
            "f00002",
            "Atteinte à la personnalité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
              "f00003",
              "L’atteinte au secret professionnel",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00005",
                      "La révélation d’une information à caractère secret par une personne qui en est dépositaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00006",
                      "soit par état ou par profession, soit en raison d’une fonction ou d’une mission temporaire, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00007",
                      "constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
              "f00008",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00009",
                    "Article 226-13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00010",
                    " : définit et réprime l’atteinte au secret professionnel.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00012",
                    "L’article 226-13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                        "f00013",
                        " incrimine la révélation d’une information à caractère secret par une personne qui en est dépositaire. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                        "f00014",
                        "Ce délit protège la confiance nécessaire à l’exercice de certaines professions ou fonctions, mais aussi ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                        "f00015",
                        "l’intérêt des particuliers.",
                      ),
                ),
              ]),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00016",
                  "A) Une personne dépositaire d’un secret",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00017",
                    "L’article 226-13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                        "f00018",
                        " vise la personne dépositaire « soit par son état ou sa profession, soit en raison d’une fonction ou d’une mission temporaire ». ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                        "f00019",
                        "Cette formule évite une énumération trop longue (médecin, pharmacien, policier, magistrat, greffier, avocat, banquier, expert-comptable, etc.).",
                      ),
                ),
              ]),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00020",
                  "En l’absence de texte spécial, les juges apprécient au cas par cas si une personne est tenue au secret professionnel.",
                ),
              ),
              SizedBox(height: 12),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00021",
                      "Le dépositaire n’est pas seulement un confident : c’est celui qui a appris des données à caractère confidentiel, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00022",
                      "de quelque manière que ce soit, à l’occasion de son état, profession, fonction ou mission.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00023",
                  "• Dépositaire en raison de son état",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00024",
                      "L’« état » renvoie à une situation de fait ou de droit et à un statut juridique professionnel. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00025",
                      "Exemples : ministre du culte, étudiants/élèves en formation vers une profession soumise au secret ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00026",
                      "(ex. élèves orthophonistes, masseurs-kinésithérapeutes, etc.).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00027",
                  "• Dépositaire en raison de sa profession",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00028",
                      "La profession est l’activité habituellement exercée pour subvenir à ses besoins. Certaines professions, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00029",
                      "par leurs règles, astreignent leurs membres au secret (professions médicales, avocats, professions financières/commerciales, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00030",
                      "policiers, magistrats, etc.).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00031",
                  "• Dépositaire en raison de sa fonction",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00032",
                      "La fonction est une charge et l’activité qu’elle occasionne. Le secret s’applique aux destinataires d’informations ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00033",
                      "en raison de leurs fonctions (catégorie interprétée par la jurisprudence : agents de la fonction publique, services divers, etc.).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00034",
                  "• Dépositaire en raison d’une mission temporaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00035",
                      "La mission temporaire vise une tâche ponctuelle confiée : jurés, membres assesseurs, experts, etc. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00036",
                      "Il faut que l’intéressé ait accès à des informations confidentielles ou destinées à l’être.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00037",
                  "B) Un secret",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00038",
                      "Le secret peut être une confidence, une situation, une formule, ou plus largement toute information ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00039",
                      "dont le dépositaire a connaissance à l’occasion de sa profession/fonction.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00040",
                      "La Cour de cassation étend la notion à tout ce que la personne tenue au secret a pu constater, découvrir ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00041",
                      "ou déduire personnellement dans l’exercice de ses missions.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00042",
                  "Le caractère secret de l’information ne s’éteint pas avec le décès de la personne concernée.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00043",
                  "C) Un acte de révélation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00044",
                      "La forme de la révélation importe peu : elle peut être orale, écrite, ou résulter de la transmission d’un document ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00045",
                      "couvert par le secret.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00046",
                      "Le délit est constitué dès que l’information est communiquée à une seule personne, même si elle est elle-même soumise ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00047",
                      "au secret professionnel.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00048",
                      "Si l’information a déjà été rendue publique, l’infraction peut quand même être retenue contre le dépositaire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00049",
                      "qui la confirme ou l’infirme.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
              "f00050",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00051",
                  "Conscience de révéler un secret",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00052",
                      "L’infraction est intentionnelle : l’auteur a conscience de révéler une information secrète dont il est dépositaire, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                      "f00053",
                      "et la révélation est volontaire.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00054",
                  "L’intention de nuire n’est pas requise : le mobile importe peu.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
              "f00055",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00056",
                  "Aucune circonstance aggravante prévue.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + NOTA 226-14
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
              "f00057",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00058",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00059",
                    "Article 226-13 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00060",
                    " : 1 an d’emprisonnement et 15 000€ d'amende (peine principale) et délit constitué par la révélation d’un secret.",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00061",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00062",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00063",
                    "l’article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00064",
                    "Peines complémentaires possibles (notamment) via ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00065",
                    "l’article 226-12 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00066",
                    " : affichage/diffusion de la décision, interdiction définitive ou temporaire d’exercer une activité sociale ou professionnelle.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00067",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00068",
                  "Tentative : NON (non prévue / non punissable).",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00069",
                    "Complicité : OUI — conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00070",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                    "f00071",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00072",
                  "Elle suppose un des faits constitutifs de complicité prévus par la loi : aide et assistance, provocation ou instructions données.",
                ),
              ),

              SizedBox(height: 14),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                  "f00073",
                  "Exception (article 226-14 C.P.)",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00074",
                          "L’article 226-14 du Code pénal prévoit des cas où l’article 226-13 n’est pas applicable, notamment :\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00075",
                          "• Signalement aux autorités (judiciaires, médicales ou administratives) de maltraitances, privations ou sévices ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00076",
                          "infligés à un mineur ou à une personne vulnérable.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00077",
                          "• Signalement par un professionnel de santé, avec l’accord de la victime (ou sans accord si mineur/personne vulnérable), ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00078",
                          "au procureur ou aux cellules compétentes pour les mineurs en danger.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00079",
                          "• Signalement au procureur de faits de sujétion psychologique/physique (au sens de l’article 223-15-3 C.P.) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00080",
                          "avec accord de la victime (ou sans accord si mineur/personne vulnérable), sous conditions.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00081",
                          "• Signalement de violences au sein du couple mettant la vie de la victime majeure en danger immédiat, lorsque la victime ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00082",
                          "n’est pas en mesure de se protéger en raison de l’emprise (le professionnel doit s’efforcer d’obtenir l’accord, et informer la victime en cas d’impossibilité).\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00083",
                          "• Information du préfet (ou du préfet de police à Paris) par des professionnels de santé/action sociale du caractère dangereux ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00084",
                          "d’une personne détenant une arme ou ayant manifesté l’intention d’en acquérir une.\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00085",
                          "• Signalement par un vétérinaire de sévices graves, acte de cruauté ou atteinte sexuelle sur un animal.\n\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00086",
                          "Le signalement effectué dans ces conditions ne peut engager la responsabilité civile, pénale ou disciplinaire de son auteur, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/atteinte_personnalite/atteinte_secret_professionnel.dart",
                          "f00087",
                          "sauf s’il est établi qu’il n’a pas agi de bonne foi.",
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
