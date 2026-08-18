import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaMiseEnDangerDiffusionInformationsPage extends StatelessWidget {
  const PaMiseEnDangerDiffusionInformationsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/mise_en_danger/mise_en_danger_diffusion_informations';

  static const _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cartes (harmonie visuelle)
    final Color card1 = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color card2 = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color card3 = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color card4 = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color card5 = isDark
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
            "f00002",
            "Mise en danger",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00003",
              "La mise en danger par la diffusion d’informations personnelles",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro pédagogique (propre + concise)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: card5,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00005",
                      "Révéler, diffuser ou transmettre (par quelque moyen que ce soit) des informations ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00006",
                      "relatives à la vie privée, familiale ou professionnelle d’une personne, permettant de ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00007",
                      "l’identifier ou de la localiser, dans le but de l’exposer (elle ou sa famille) à un risque direct ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00008",
                      "d’atteinte à la personne ou aux biens, constitue une infraction lorsque l’auteur ne pouvait ignorer ce risque.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ ÉLÉMENT LÉGAL EN HAUT (demandé)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00009",
              "I — Élément légal",
            ),
            cardColor: card1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00010",
                    "Infraction définie et réprimée par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00011",
                    "l’article 223-1-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                          "f00012",
                          "L’objectif est notamment de viser des comportements (souvent en ligne) ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                          "f00013",
                          "qui, sans être une provocation directe ou une complicité, recherchent en pratique ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                          "f00014",
                          "le même résultat : exposer la personne à un risque direct.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ÉLÉMENT MATÉRIEL
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00015",
              "II — Élément matériel",
            ),
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00016",
                  "A) Révélation / diffusion / transmission (par quelque moyen)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00017",
                      "L’incrimination n’exige pas que la révélation, la diffusion ou la transmission soient publiques. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00018",
                      "L’infraction vise particulièrement les réseaux sociaux, mais des moyens plus confidentiels ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00019",
                      "(courriels, SMS, messageries) peuvent également être concernés.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00020",
                  "La simple réception, la captation ou la détention des informations n’est pas répréhensible.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00021",
                  "B) Informations de vie privée, familiale ou professionnelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00022",
                      "Exemples : numéro de téléphone, adresse, informations professionnelles. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00023",
                      "Une photographie peut aussi constituer une information personnelle, notamment si elle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00024",
                      "a été prise dans un lieu privé à l’insu de la personne.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00025",
                  "C) Permettant d’identifier ou de localiser",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00026",
                      "Les informations doivent permettre d’identifier ou de localiser la personne. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00027",
                      "Il peut s’agir d’une personne distincte de celle visée à titre principal par la divulgation.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00028",
                  "D) Auteur : toute personne",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00029",
                      "L’incrimination vise toute personne, y compris un journaliste si la preuve est rapportée d’une ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00030",
                      "intention de nuire gravement à autrui. Elle n’a toutefois pas pour objet de réprimer la diffusion ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00031",
                      "d’éléments dans le but d’informer le public, même si ces éléments pourraient être réutilisés par un tiers.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Jurisprudence (mise en valeur)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00032",
              "Jurisprudence",
            ),
            cardColor: card4,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                        "f00033",
                        "La diffusion concomitante d’informations sur la qualité de fonctionnaire de police ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                        "f00034",
                        "dans un contexte visant les forces de l’ordre peut exposer la personne et/ou sa famille ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                        "f00035",
                        "à un risque direct d’atteinte à la personne ou aux biens. ",
                      ),
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00036",
                    "Cass. crim., n° 24-82.090, 11 février 2025",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ÉLÉMENT MORAL
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00037",
              "III — Élément moral",
            ),
            cardColor: card3,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00038",
                  "Intention de nuire gravement à autrui",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00039",
                      "L’auteur doit avoir l’intention manifeste qu’il soit porté une atteinte grave à la personne, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00040",
                      "à ses proches ou à ses biens. L’intention peut être caractérisée par des propos explicites ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00041",
                      "ou déduite d’un faisceau d’indices.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // CIRCONSTANCES AGGRAVANTES
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00042",
              "IV — Circonstances aggravantes",
            ),
            cardColor: card1,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00043",
                    "Article 223-1-1 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00044",
                      "Victime dépositaire de l’autorité publique, chargée d’une mission de service public, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00045",
                      "titulaire d’un mandat électif public, candidat à un mandat pendant la campagne, ou journaliste ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00046",
                      "(au sens de l’art. 2, al. 2, loi du 29 juillet 1881).",
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00047",
                      "Faits commis dans les mêmes conditions envers le conjoint, ascendant, descendant en ligne directe ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                      "f00048",
                      "ou toute personne vivant habituellement au domicile de la personne protégée, en raison des fonctions exercées.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00049",
                    "Article 223-1-1 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00050",
                    " : victime mineure.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00051",
                    "Article 223-1-1 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                        "f00052",
                        " : victime présentant une particulière vulnérabilité (âge, maladie, infirmité, déficience, grossesse), ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                        "f00053",
                        "apparente ou connue de l’auteur.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // RÉPRESSION + tentative/complicité + personnes morales
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
              "f00054",
              "V — Répression",
            ),
            cardColor: card2,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00055",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00056",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00057",
                    "3 ans d’emprisonnement et 45 000 € d’amende. ",
                  ),
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00058",
                    "Article 223-1-1 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00059",
                    "Qualification aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00060",
                    "5 ans d’emprisonnement et 75 000 € d’amende. ",
                  ),
                ),
                TextSpan(text: "— "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00061",
                    "Article 223-1-1 alinéas 2 à 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00062",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00063",
                    "Responsabilité pénale des personnes morales selon le principe général : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00064",
                    "article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00065",
                    "Article 223-1-1 alinéa 5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                        "f00066",
                        " : en cas de diffusion par voie de presse, audiovisuelle ou communication au public en ligne, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                        "f00067",
                        "application des règles spécifiques de ces matières pour la détermination des responsables.",
                      ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00068",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                  "f00069",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00070",
                    "Complicité : OUI, selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/mise_en_danger_diffusion_informations_page.dart",
                    "f00071",
                    "les articles 121-6 et 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
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
