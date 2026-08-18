import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPPActionPubliqueChapitre2SujetsActionPubliquePage
    extends StatelessWidget {
  const PaPPActionPubliqueChapitre2SujetsActionPubliquePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_action_publique_action_civile/chapitre_2_sujets_action_publique';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .75);

    final Color cardBg = isDark
        ? const Color(0xFF2B3036)
        : const Color(0xFFF5F7FB);
    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color titleBlue = isDark ? Colors.white : const Color(0xFF0D47A1);

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
            "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
            "f00002",
            'Chapitre 2 — Sujets de l’action publique',
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
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // =================== EN-TÊTE CHAPITRE ============================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
              "f00003",
              'Les sujets de l’action publique',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00004",
                  'Qui peut exercer l’action publique, et contre qui est-elle dirigée ? ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00005",
                  'Ce chapitre distingue les sujets actifs (ceux qui mettent en mouvement ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00006",
                  'ou exercent l’action publique) et les sujets passifs (ceux contre qui ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00007",
                  'elle est dirigée).',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          // =================== INTRO GENERALE ==============================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
              "f00008",
              'Définition générale des sujets de l’action publique',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00009",
                  'L’expression « sujets de l’action publique » regroupe :',
                ),
              ),
              SizedBox(height: 6),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00010",
                  'les personnes qui exercent l’action publique : les sujets actifs ;',
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00011",
                      'les personnes contre lesquelles l’action publique est dirigée : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00012",
                      'les sujets passifs.',
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00013",
                      'L’action publique appartient à la société, qui seule a le droit de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00014",
                      'l’exercer ou d’y renoncer. En pratique, la société agit par ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00015",
                      'l’intermédiaire de représentants qualifiés : les magistrats du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00016",
                      'ministère public et, dans certains cas, des fonctionnaires de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00017",
                      'certaines administrations. Certaines juridictions et la partie lésée ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00018",
                      'peuvent également mettre en mouvement l’action publique.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =================== 2.1 SUJETS ACTIFS ==========================
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
              "f00019",
              '2.1 — Les sujets actifs de l’action publique',
            ),
          ),
          const SizedBox(height: 4),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00020",
                  'Les sujets actifs de l’action publique sont les personnes ou autorités ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00021",
                  'habilitées par la loi à mettre en mouvement et à exercer l’action publique : ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00022",
                  'principalement le ministère public, certaines administrations, mais aussi, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00023",
                  'dans des cas particuliers, les juridictions et la partie lésée.',
                ),
          ),
          const SizedBox(height: 12),

          // ----------------- 2.1.1 LE MINISTERE PUBLIC --------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
              "f00024",
              '2.1.1 — Le ministère public',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00025",
                      'L’ensemble des officiers du ministère public près d’une juridiction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00026",
                      'déterminée constitue ce que l’on appelle le parquet. Historiquement, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00027",
                      'sous l’Ancien Régime, les procureurs et avocats du Roi ne siégeaient ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00028",
                      'pas sur l’estrade des juges, mais sur le « parquet » de la salle ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00029",
                      'd’audience, au même niveau que les justiciables.',
                    ),
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00030",
                    'Article 1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00031",
                        ' : l’action publique est mise en mouvement et exercée par les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00032",
                        'magistrats auxquels elle est confiée par la loi.',
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00033",
                  'Absence de disposition de l’action publique',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00034",
                      'Le ministère public n’a pas la « disposition » de l’action publique. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00035",
                      'L’action publique appartient à la société qui l’exerce par son intermédiaire. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00036",
                      'Si les membres du ministère public disposaient librement de l’action publique, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00037",
                      'ils pourraient transiger avec le délinquant, se désister de recours, ou encore ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00038",
                      'acquiescer aux prétentions du prévenu. La loi ne leur reconnaît pas de tels ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00039",
                      'pouvoirs de renonciation générale.',
                    ),
              ),
              const SizedBox(height: 6),

              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00040",
                      'Une fois l’action publique régulièrement mise en mouvement, le ministère ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00041",
                      'public ne peut en principe plus l’arrêter unilatéralement.',
                    ),
              ),
              const SizedBox(height: 6),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00042",
                  'Point clé',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00043",
                          'l’action publique est d’ordre public. Le ministère public agit au nom ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00044",
                          'de la société : il poursuit ou renonce à poursuivre dans le cadre fixé ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00045",
                          'par la loi, et non selon des accords privés avec le délinquant.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ----------------- 2.1.2 ADMINISTRATIONS ------------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
              "f00046",
              '2.1.2 — Les administrations qui exercent l’action publique',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00047",
                      'Des pouvoirs diversifiés sont reconnus à certaines administrations ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00048",
                      'publiques pour constater, poursuivre ou réparer les infractions portant ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00049",
                      'atteinte aux intérêts dont elles ont la charge. Dans certains cas, elles ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00050",
                      'détiennent un droit direct de poursuite et exercent alors l’action publique ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00051",
                      'au même titre que le ministère public.',
                    ),
              ),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00052",
                  '2.1.2.1 — Administration chargée des forêts',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00053",
                    'En matière d’infractions forestières soumises au tribunal de police, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00054",
                    'le directeur régional de l’administration chargée des forêts ou le fonctionnaire qu’il désigne ',
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00055",
                    'remplit toutes les fonctions du ministère public, sous l’autorité du procureur de la République.',
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00056",
                    'Article L. 161-22 du code forestier',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: ' et '),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00057",
                    'article 45 alinéa 2 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00058",
                    ' encadrent ce pouvoir de représentation devant le tribunal de police.',
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00059",
                      'Ce pouvoir concerne les infractions forestières et assimilées, certains ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00060",
                      'délits de chasse dans les bois soumis au régime forestier et certaines ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00061",
                      'infractions de pêche fluviale.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00062",
                      'L’administration chargée des forêts partage le droit de poursuivre avec ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00063",
                      'le ministère public, qui conserve intégralement son propre pouvoir d’action.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00064",
                      'Contrairement au ministère public, cette administration peut transiger ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00065",
                      'avec le délinquant. Si la poursuite est déjà engagée, la transaction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00066",
                      'éteint l’action publique et dessaisit le juge.',
                    ),
              ),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00067",
                  '2.1.2.2 — Administration de l’équipement',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00068",
                    'Le directeur départemental de l’équipement ou l’agent qu’il désigne, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00069",
                    'en application des articles L. 116-4 et L. 116-5 du Code de la voirie routière',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00070",
                        ', peut, concurremment avec les magistrats du parquet, exercer les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00071",
                        'fonctions de ministère public devant le tribunal de police pour les ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00072",
                        'infractions concernant la voirie nationale (empiétement, dégradation ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00073",
                        'du domaine public, etc.).',
                      ),
                ),
              ]),
              const SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00074",
                      'Ces fonctionnaires peuvent transiger tant qu’aucun jugement définitif ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00075",
                      'n’a été rendu.',
                    ),
              ),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00076",
                  '2.1.2.3 — Administrations fiscales',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00077",
                      'Les administrations fiscales disposent de pouvoirs de poursuite, mais ceux-ci ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00078",
                      'ne s’appliquent pas aux peines d’emprisonnement. Elles prononcent des amendes ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00079",
                      'et d’autres sanctions de nature fiscale (majorations, confiscations, contraintes, etc.).',
                    ),
              ),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00080",
                  '2.1.2.4 — Contributions indirectes',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00081",
                    'L’administration des contributions indirectes, représentée par son directeur départemental, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00082",
                    'poursuit les infractions fiscales sur le fondement de l’article L. 235 du Livre des procédures fiscales',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00083",
                  '2.1.2.5 — Administration des douanes',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00084",
                    'L’administration des douanes dispose du droit de poursuivre les infractions douanières. ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00085",
                    'Article 343 du Code des douanes',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00086",
                        ' : le ministère public poursuit les délits douaniers devant le tribunal ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00087",
                        'correctionnel, mais l’administration des douanes intervient pour obtenir ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00088",
                        'les sanctions pécuniaires.',
                      ),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00089",
                    'Lorsque l’article 28-1 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00090",
                        ' est mis en œuvre, le ministère public peut saisir le service d’enquêtes ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00091",
                        'judiciaires des finances ou demander l’ouverture d’une information judiciaire ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00092",
                        'pour l’application de sanctions fiscales.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00093",
                      'Les administrations des contributions indirectes et des douanes peuvent transiger. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00094",
                      'La transaction intervenant avant jugement éteint l’action fiscale.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00095",
                      'Si le même fait présente aussi une qualification de droit commun, la transaction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00096",
                      'fiscale demeure sans effet sur l’action publique exercée au titre du droit commun.',
                    ),
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00097",
                  'À retenir',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00098",
                          'certaines administrations disposent de pouvoirs proches de ceux du ministère public, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00099",
                          'mais avec une logique de protection d’intérêts spécifiques (forêts, voirie, douanes, ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00100",
                          'fiscalité) et souvent la possibilité de transiger.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ----------------- 2.1.3 CAS PARTICULIERS -----------------------
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
              "f00101",
              '2.1.3 — Cas particuliers de mise en mouvement de l’action publique',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00102",
                  '2.1.3.1 — Juridictions de jugement et chambre de l’instruction',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00103",
                    'Lorsque des infractions sont commises à l’audience des cours et tribunaux, ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00104",
                    'les articles 675 et suivants du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00105",
                        ' permettent à la juridiction de se saisir d’office et de juger l’auteur ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00106",
                        'des faits, en appliquant les peines prévues par la loi.',
                      ),
                ),
              ]),
              const SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00107",
                      'Exception : en cas de délit d’outrage à magistrat (article 434-24 du Code pénal), ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00108",
                      'la juridiction ne se saisit pas elle-même pour éviter tout soupçon de partialité. ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00109",
                      'Les faits sont transmis au ministère public.',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00110",
                      'Exception également lorsque le fait commis à l’audience constitue un crime, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00111",
                      'car une instruction préparatoire est alors obligatoire.',
                    ),
              ),
              const SizedBox(height: 4),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00112",
                      'Dans ces cas, le président d’audience dresse procès-verbal des faits et saisit ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00113",
                      'le ministère public, qui décide de la suite à donner. La chambre de l’instruction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00114",
                      'peut par ailleurs, d’office, ordonner des poursuites pour des faits connexes.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00115",
                    'Articles 202 et suivants du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00116",
                    ' : ces textes encadrent ce pouvoir.',
                  ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00117",
                  '2.1.3.2 — Le Défenseur des droits',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00118",
                      'Le Défenseur des droits dispose, en cas de discriminations avérées, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00119",
                      'd’un pouvoir de transaction pénale lorsque l’action publique n’a pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00120",
                      'encore été mise en mouvement. L’auteur des faits peut se voir proposer ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00121",
                      'le paiement d’une amende transactionnelle et, éventuellement, l’indemnisation ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00122",
                      'de la victime (montant maximal de 3 000 euros pour une personne physique, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00123",
                      '15 000 euros pour une personne morale).',
                    ),
              ),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00124",
                  '2.1.3.3 — La partie lésée',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00125",
                    'La victime, bien qu’elle ne puisse exercer elle-même l’action publique, peut la déclencher. ',
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00126",
                    'Article 1 alinéa 2 du Code de Procédure Pénale',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00127",
                    ' : la partie lésée peut mettre en mouvement l’action publique dans les conditions prévues par la loi.',
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00128",
                      'Soit en citant directement le prévenu devant le tribunal pour une infraction ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00129",
                      'qui n’est pas un crime (citation directe).',
                    ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00130",
                      'Soit en déposant une plainte avec constitution de partie civile devant le juge ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00131",
                      'd’instruction, ce qui déclenche l’action publique.',
                    ),
              ),
              const SizedBox(height: 6),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00132",
                  'En pratique',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00133",
                          'ce droit permet à la victime de contourner l’inaction éventuelle du ministère public ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00134",
                          'et d’obtenir l’ouverture d’une procédure.',
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =================== 2.2 SUJETS PASSIFS ==========================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
              "f00135",
              '2.2 — Les sujets passifs de l’action publique',
            ),
            cardColor: cardBg,
            accent: accentBlue,
            titleColor: titleBlue,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00136",
                  '2.2.1 — Contre l’auteur ou le complice',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00137",
                      'L’action publique tend au prononcé d’une peine. En vertu du principe de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00138",
                      'la personnalité des peines, elle ne peut être dirigée que contre les auteurs ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00139",
                      'ou complices de l’infraction. Elle peut être exercée même si l’auteur est ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00140",
                      'inconnu (information ouverte contre X).',
                    ),
              ),
              const SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00141",
                      'L’action publique ne peut pas être exercée contre les héritiers du ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00142",
                      'délinquant. Si ce dernier décède au cours de la procédure, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00143",
                      'l’action publique est éteinte.',
                    ),
              ),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00144",
                  '2.2.2 — Contre le représentant légal d’une personne morale',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00145",
                      'Lorsque l’infraction est commise par une personne morale, l’action publique ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00146",
                      'est exercée à l’encontre de son représentant légal (ou d’un délégué désigné ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00147",
                      'à cet effet), qui la représente dans tous les actes de la procédure. La ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00148",
                      'personne morale encourt alors des peines spécifiques (amende, interdictions, ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00149",
                      'fermeture d’établissement, etc.).',
                    ),
              ),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00150",
                  '2.2.3 — Contre les personnes pénalement responsables du fait d’autrui',
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00151",
                      'En dépit du principe de la personnalité des peines, certaines sanctions ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00152",
                      'peuvent être prononcées contre des personnes qui n’ont pas matériellement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00153",
                      'commis l’infraction, mais dont la responsabilité est engagée à raison des ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00154",
                      'actes d’autrui. Il s’agit principalement de la responsabilité du chef ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00155",
                      'd’entreprise, prévue par la loi ou dégagée par la jurisprudence.',
                    ),
              ),
              const SizedBox(height: 6),

              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00156",
                      'Exemple : un serveur sert de l’alcool à un client en état d’ébriété en ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00157",
                      'violation des règles. La contravention est imputée au tenancier, même si ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00158",
                      'l’infraction a été matériellement commise par le préposé.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00159",
                    'Article R. 3353-2 du Code de la santé publique',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00160",
                        ' incrimine la vente ou l’offre de boissons alcooliques à ',
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                        "f00161",
                        'une personne manifestement ivre.',
                      ),
                ),
              ]),
              const SizedBox(height: 6),

              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00162",
                      'Exemple : les amendes prononcées contre les conducteurs d’un véhicule ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00163",
                      'peuvent, en tout ou partie, être supportées par l’employeur.',
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00164",
                    'Article L. 121-1 du Code de la route',
                  ),
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                    "f00165",
                    ' permet au juge de mettre à la charge de l’employeur tout ou partie de l’amende.',
                  ),
                ),
              ]),
              const SizedBox(height: 6),

              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00166",
                      'Exemple : le directeur d’une entreprise à l’origine d’une pollution des eaux ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00167",
                      'peut être condamné même s’il n’est pas démontré qu’il a personnellement ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                      "f00168",
                      'organisé la pollution. Sa responsabilité découle de sa qualité de dirigeant.',
                    ),
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                  "f00169",
                  'À garder en tête',
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00170",
                          'la responsabilité pénale du fait d’autrui ne remet pas en cause le principe ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00171",
                          'de la personnalité des peines, mais l’adapte aux réalités de la vie des ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00172",
                          'affaires : le chef d’entreprise doit répondre des manquements graves commis ',
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/procedure_penale_pages/pp_action_publique_action_civile_chapitre_2_sujets_action_publique_page.dart",
                          "f00173",
                          'dans le cadre de l’activité qu’il dirige.',
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
