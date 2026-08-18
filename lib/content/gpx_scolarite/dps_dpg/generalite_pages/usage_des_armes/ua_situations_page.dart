import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — USAGE DES ARMES
///
///  II. Les cinq situations d’usage des armes
///      prévues par l’article L. 435-1 du Code de la Sécurité Intérieure
///
///   - Rappel : conditions préalables obligatoires
///   - 1) Atteintes à la vie ou à l’intégrité physique / personnes armées
///   - 2) Défense des lieux occupés et des personnes confiées
///   - 3) Fuite d’un individu dangereux placé sous garde
///   - 4) Immobilisation d’un véhicule occupé par un ou plusieurs
///        individus dangereux (refus d’obtempérer)
///   - 5) Périple meurtrier
/// ===================================================================
class UaSituationsPage extends StatelessWidget {
  const UaSituationsPage({super.key});

  static const String routeName = '/gpx/generalites/usagedesarmes/situations';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);
    final Color accentColor = isDark
        ? const Color(0xFF1976D2)
        : const Color(0xFF1565C0);
    final Color referenceColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    const Color dangerColor = Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
            "f00001",
            'Les 5 situations d’usage des armes',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00002",
                  'II. Les cinq situations prévues pour l’usage des armes\n',
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00003",
                  '(article L. 435-1 du Code de la Sécurité Intérieure)',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00004",
                    'Sous réserve que les trois conditions préalables à l’usage d’une arme soient réunies ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00005",
                    '(agir dans l’exercice de ses fonctions, être identifiable comme policier, respecter la nécessité absolue et la proportionnalité), ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00006",
                    'les policiers sont autorisés à faire usage de leur arme dans cinq situations précises définies par ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                "f00007",
                'l’article L. 435-1 du Code de la Sécurité Intérieure',
              ),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00008",
                    ', hors les cas particuliers de dispersion d’un attroupement prévus par l’article L. 211-9 du même code ',
                  ) +
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00009",
                    'et hors le régime général de la légitime défense prévu par l’article 122-5 du Code pénal.',
                  ),
            ),
          ]),
          const SizedBox(height: 14),
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
              "f00010",
              'Principe essentiel',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00011",
                      'Même lorsqu’une situation entre dans l’un des cas prévus par l’article L. 435-1 du Code de la Sécurité Intérieure, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00012",
                      'l’usage de l’arme à feu reste une mesure de dernier recours. Le policier doit toujours vérifier que le tir est absolument nécessaire ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00013",
                      'et strictement proportionné au danger, et que les autres moyens de contrainte se révèlent insuffisants ou inadaptés.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // 1 — ATTEINTES À LA VIE / PERSONNES ARMÉES
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
              "f00014",
              '1. Atteintes à la vie ou à l’intégrité physique\n   / personnes armées menaçantes',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00015",
                    'La première situation d’usage des armes est prévue par le ',
                  ),
                  style: TextStyle(),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00016",
                    '1° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00017",
                    ' et vise les cas où :',
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00018",
                    'Des atteintes à la vie ou à l’intégrité physique sont portées contre les policiers eux-mêmes ou contre un tiers ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00019",
                    'Des personnes armées menacent la vie ou l’intégrité physique des policiers ou d’un tiers.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00020",
                      'Cette situation est celle qui se rapproche le plus de la légitime défense classique prévue par le Code pénal. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00021",
                      'Compte tenu de l’imminence de l’atteinte à la vie ou à l’intégrité physique, il n’est pas prévu que les policiers procèdent à des sommations avant de faire usage de leur arme.',
                    ),
              ),
              const SizedBox(height: 10),
              _ExempleBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00022",
                  'Exemples typiques',
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00023",
                      '• Un individu tire à balles réelles sur les policiers depuis la voie publique.\n',
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00024",
                          '• Une personne armée d’un couteau se rue sur un passant en menaçant de le tuer, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00025",
                          'malgré les ordres de lâcher son arme.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 2 — DÉFENSE DES LIEUX OCCUPÉS / PERSONNES CONFIÉES
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
              "f00026",
              '2. Défense des lieux occupés\n   et des personnes confiées',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00027",
                    'La deuxième situation d’usage des armes est prévue par le ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00028",
                    '2° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00029",
                        '. Elle concerne la défense des lieux que les policiers occupent ou des personnes qui leur sont confiées. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00030",
                        'Dans cette hypothèse, les sommations sont obligatoires.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00031",
                      'L’usage de l’arme est possible après avoir procédé à deux sommations faites à haute voix, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00032",
                      'lorsque les policiers ne peuvent défendre autrement :',
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00033",
                    'Les lieux qu’ils occupent à titre permanent, par exemple un poste de police, un centre de rétention administrative ou un local de service ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00034",
                        'Les personnes qui leur sont confiées, telles qu’une personne bénéficiant d’une protection rapprochée, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00035",
                        'une personne placée en garde à vue ou en rétention, ou encore une personne interpellée ou victime se trouvant sur les lieux d’une infraction.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _ExempleBox(
                title: 'Illustration',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00036",
                          'Une patrouille assure la protection d’un centre de rétention administrative. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00037",
                          'Un groupe tente de forcer l’entrée avec des barres de fer pour libérer un retenu. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00038",
                          'Après deux sommations restées sans effet et en l’absence d’autre moyen efficace, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00039",
                          'l’usage de l’arme peut être envisagé dans le respect strict de la proportionnalité.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 3 — FUITE D’UN INDIVIDU DANGEREUX SOUS GARDE
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
              "f00040",
              '3. Fuite d’un individu dangereux\n   placé sous la garde des policiers',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00041",
                    'La troisième situation d’usage des armes est prévue par le ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00042",
                    '3° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00043",
                        '. Elle vise la fuite d’un individu dangereux placé sous la garde des policiers. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00044",
                        'Dans ce cas également, les sommations sont obligatoires.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00045",
                      'L’usage de l’arme est possible après deux sommations faites à haute voix, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00046",
                      'lorsque les policiers ne peuvent autrement arrêter :',
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00047",
                    'Une personne qui cherche à échapper à leur garde ou à leurs investigations ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00048",
                        'Une personne qui prend la fuite alors qu’elle se trouve déjà sous leur garde, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00049",
                        'par exemple une personne placée en garde à vue ou une personne conduite au tribunal.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00050",
                    'Mais cette possibilité n’existe que si les policiers disposent de ',
                  ),
                  style: TextStyle(),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00051",
                    'raisons réelles et objectives ',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: dangerColor,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00052",
                        'de penser que, au moment où la personne prend la fuite, celle-ci va porter atteinte à la vie ou à l’intégrité physique ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00053",
                        'des policiers ou d’autrui, et qu’il n’existe pas d’autres moyens de l’empêcher.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00054",
                        'Il peut s’agir, par exemple, d’un individu connu pour avoir déjà commis ou tenté de commettre des infractions violentes, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00055",
                        'ou ayant proféré des menaces de passage à l’acte crédibles.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00056",
                      'Même si l’individu en fuite pourrait être arrêté plus tard par d’autres moyens, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00057",
                      'l’usage de l’arme ne pourra être considéré comme légitime que si, au moment précis de la fuite, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00058",
                      'la personne représente encore une menace réelle. Une simple crainte ou un soupçon ne suffit pas.',
                    ),
              ),
              const SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00059",
                  'Formule des sommations',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00060",
                          'Les sommations doivent être faites à haute voix, de manière claire, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00061",
                          'pour que la personne prenne conscience du risque qu’elle encourt en refusant d’obtempérer. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00062",
                          'Elles prennent traditionnellement la forme suivante :\n\n',
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00063",
                      '• Première sommation : « Halte police ! »\n',
                    ),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00064",
                      '• Deuxième sommation : « Halte ou je fais feu ! »\n\n',
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00065",
                          'Ces sommations doivent se succéder dans un temps court, avant tout usage de l’arme, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00066",
                          'sauf impossibilité liée à l’urgence absolue de la situation.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 4 — IMMOBILISATION D’UN VÉHICULE DANGEREUX
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
              "f00067",
              '4. Immobilisation d’un véhicule occupé\n   par un ou plusieurs individus dangereux',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00068",
                        'La quatrième situation concerne l’immobilisation d’un véhicule (ou de tout autre moyen de transport) ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00069",
                        'occupé par un ou plusieurs individus dangereux. Elle est prévue par le ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00070",
                    '4° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00071",
                    ' et s’applique notamment en cas de refus d’obtempérer à un ordre d’arrêt.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00072",
                      'Les policiers peuvent faire usage de leur arme lorsqu’ils ne peuvent immobiliser autrement un véhicule, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00073",
                      'une embarcation ou tout autre moyen de transport et que les deux conditions suivantes sont réunies :',
                    ),
              ),
              const SizedBox(height: 8),

              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00074",
                        'Le conducteur n’a pas obtempéré immédiatement à un ordre d’arrêt explicite. ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00075",
                        'Cet ordre peut résulter d’un dispositif lumineux ou sonore, d’un geste réglementaire, de l’usage d’un sifflet, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00076",
                        'de la mise en place d’un barrage routier ou de tout autre moyen clairement identifiable.',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00077",
                        'Les policiers disposent de raisons réelles et objectives de penser que les occupants du véhicule ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00078",
                        'sont susceptibles de porter atteinte, dans leur fuite, à la vie ou à l’intégrité physique des policiers ou d’autrui.',
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00079",
                      'L’ordre d’arrêt doit être dépourvu d’ambiguïté et clairement compris par le conducteur. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00080",
                      'Il ne peut en aucun cas être fait usage de l’arme pour contraindre un véhicule à s’arrêter ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00081",
                      'lorsqu’aucun danger grave et actuel n’est identifié concernant ses occupants ou leur comportement.',
                    ),
              ),
              const SizedBox(height: 10),

              _ExempleBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00082",
                  'Exemple opérationnel',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00083",
                          'Un véhicule, signalé comme pouvant transporter des individus armés ayant commis une agression violente, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00084",
                          'force un contrôle routier et fonce vers une zone très fréquentée. Après un ordre d’arrêt très clairement donné et resté sans effet, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00085",
                          'et en l’absence d’autre moyen pour stopper la progression du véhicule, l’usage de l’arme dirigée vers les éléments mécaniques ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00086",
                          'peut être envisagé pour l’immobiliser, sous réserve de la stricte proportionnalité.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 5 — PÉRIPLE MEURTRIER
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
              "f00087",
              '5. Le périple meurtrier',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00088",
                        'La cinquième situation vise le cas du périple meurtrier, c’est-à-dire un individu qui vient de commettre ou de tenter de commettre ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00089",
                        'un ou plusieurs meurtres et qui semble déterminé à recommencer. Elle est prévue par le ',
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00090",
                    '5° de l’article L. 435-1 du Code de la Sécurité Intérieure',
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00091",
                  'Les policiers sont autorisés à faire usage de leur arme contre un individu dans cette situation lorsque les trois conditions suivantes sont réunies :',
                ),
              ),
              const SizedBox(height: 8),

              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00092",
                    'L’individu vient de commettre ou de tenter de commettre un ou plusieurs meurtres ;',
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00093",
                        'Au moment où il fait usage de son arme, le policier dispose de raisons réelles et objectives de penser, ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00094",
                        'au regard des informations dont il dispose à cet instant précis et du contexte, qu’une réitération de ces crimes est probable ;',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00095",
                    'L’usage de l’arme est le seul moyen et a pour but exclusif d’empêcher la réitération de ces crimes dans un temps rapproché.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00096",
                      'Cette hypothèse correspond aux scénarios les plus graves (tueur itinérant, attaque armée en plusieurs lieux, etc.). ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00097",
                      'Elle justifie un usage extrêmement déterminé de la force, mais toujours strictement encadré par l’exigence de nécessité absolue et de proportionnalité.',
                    ),
              ),
              const SizedBox(height: 10),

              _ExempleBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00098",
                  'Exemple de périple meurtrier',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00099",
                          'Un individu vient d’ouvrir le feu dans un lieu public, faisant plusieurs victimes, et prend la fuite en conservant son arme. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00100",
                          'Les informations collectées par la police laissent penser qu’il se dirige vers un autre site très fréquenté pour recommencer. ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00101",
                          'Si aucun autre moyen ne permet de mettre fin à ce périple dans un temps très court, l’usage de l’arme visant à neutraliser l’individu ',
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                          "f00102",
                          'peut être autorisé dans le cadre du 5° de l’article L. 435-1 du Code de la Sécurité Intérieure.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ====================== SYNTHÈSE FINALE ======================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
              "f00103",
              'Synthèse : lire la situation AVANT de tirer',
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                  "f00104",
                  'Avant tout usage de l’arme, le policier doit se poser deux séries de questions :',
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00105",
                        'Les trois conditions préalables sont-elles remplies ? ',
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                        "f00106",
                        '(exercice des fonctions, identification policière, nécessité absolue et proportionnalité).',
                      ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                    "f00107",
                    'La situation que je suis en train de gérer correspond-elle clairement à l’un des cinq cas prévus par l’article L. 435-1 du Code de la Sécurité Intérieure ?',
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00108",
                      'Si l’une de ces réponses est négative, l’usage de l’arme doit être écarté ou réexaminé. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00109",
                      'Dans certains cas, le policier pourra éventuellement invoquer le régime général de la légitime défense prévu par le Code pénal, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/generalite_pages/usage_des_armes/ua_situations_page.dart",
                      "f00110",
                      'mais toujours sous le contrôle strict de la nécessité et de la proportionnalité.',
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE DE CONTENU (bloc structuré)
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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

/// ------------------------------------------------------------------
/// PARAGRAPHES (texte simple ou riche)
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans);

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.title, required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / MISE EN GARDE
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
