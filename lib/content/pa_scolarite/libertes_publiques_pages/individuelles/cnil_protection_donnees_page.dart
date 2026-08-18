import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaCnilProtectionDonneesPage extends StatelessWidget {
  const PaCnilProtectionDonneesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/individuelles/cnil_protection_donnees';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF2962FF)
        : const Color(0xFF2962FF);
    final Color referenceColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);

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
            "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
            "f00001",
            'CNIL & protection des données',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
        physics: const BouncingScrollPhysics(),
        children: [
          // =====================================================
          // EN-TÊTE / INTRO
          // =====================================================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
              "f00002",
              "La Commission Nationale de l’Informatique et des Libertés",
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: .2,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00003",
                    "Selon l’article 1 de la loi n° 78-17 du 6 janvier 1978 relative à l’informatique, aux fichiers et aux libertés, ",
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00004",
                    "« l’informatique doit être au service de chaque citoyen. Son développement doit s’opérer dans le cadre de la coopération internationale. ",
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00005",
                    "Elle ne doit porter atteinte ni à l’identité humaine, ni aux droits de l’homme, ni à la vie privée, ni aux libertés individuelles ou publiques ». ",
                  ),
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00006",
                    "La loi n° 2018-493 du 20 juin 2018 a modifié la loi Informatique et Libertés afin de mettre en conformité le droit national avec le cadre juridique européen. ",
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00007",
                    "Elle permet la mise en œuvre concrète du règlement général sur la protection des données (RGPD) et de la directive « police-justice » applicable aux fichiers de la sphère pénale. ",
                  ),
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 6),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                "f00008",
                "La CNIL est le régulateur français des données personnelles : elle accompagne les professionnels dans leur mise en conformité et aide les particuliers à maîtriser leurs données et à exercer leurs droits.",
              ),
              style: TextStyle(color: textColor),
            ),
          ]),
          const SizedBox(height: 16),

          // =====================================================
          // CHAPITRE 1 — STATUT DE LA CNIL
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
              "f00009",
              "Chapitre 1 — Le statut de la CNIL",
            ),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // 1.1
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00010",
                  "1.1 — La composition",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00011",
                    "La CNIL est composée de 18 membres nommés pour cinq ans :",
                  ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00012",
                    "4 parlementaires (2 députés, 2 sénateurs) ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00013",
                    "2 représentants du Conseil économique, social et environnemental ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00014",
                    "6 représentants des hautes juridictions (2 conseillers auprès du Conseil d’État, de la Cour de cassation et de la Cour des comptes) ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00015",
                    "5 personnalités qualifiées désignées par le président de l’Assemblée nationale, le président du Sénat et en conseil des ministres ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00016",
                    "le président de la CADA (Commission d’accès aux documents administratifs).",
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00017",
                        "Elle comprend en outre, avec voix consultative, le Défenseur des droits. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00018",
                        "Depuis la loi n° 2014-873 du 4 août 2014 pour l’égalité réelle entre les femmes et les hommes, la parité doit être assurée au sein de la CNIL.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.2
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00019",
                  "1.2 — Le fonctionnement",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00020",
                        "Le président de la CNIL est nommé par décret du président de la République parmi les membres de la commission pour une durée de cinq ans (article 9). ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00021",
                        "Le gouvernement, les autorités publiques et les dirigeants d’entreprises publiques ou privées ne peuvent s’opposer à l’action de la commission ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00022",
                        "et doivent prendre toutes les mesures utiles pour faciliter sa tâche (article 18).",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00023",
                        "La CNIL établit chaque année un rapport public qu’elle présente au président de la République, au Premier ministre et au Parlement (article 8). ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00024",
                        "Dans l’exercice de leurs attributions, les agents de la commission sont soumis au secret professionnel ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00025",
                        "dans les conditions prévues aux articles 226-13 et 413-10 du Code pénal (article 11).",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 1.3
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00026",
                  "1.3 — Une autorité administrative indépendante",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00027",
                        "La CNIL est une autorité administrative indépendante (AAI). ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00028",
                        "Il s’agit d’un organisme public agissant au nom de l’État, sans être placé sous l’autorité du gouvernement ou d’un ministre. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00029",
                        "Cette indépendance renforce sa légitimité lorsqu’elle contrôle l’action de l’État lui-même, notamment en matière de fichiers de police et de justice.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — MISSIONS DE LA CNIL
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
              "f00030",
              "Chapitre 2 — Les missions de la CNIL",
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
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00031",
                        "Les missions de la CNIL sont définies par l’article 8 de la loi n° 78-17 du 6 janvier 1978. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00032",
                        "Pour accomplir ces missions, la commission peut adopter des recommandations et prendre des décisions individuelles ou réglementaires dans les cas prévus par la loi.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.1
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00033",
                  "2.1 — Informer des droits et des obligations",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00034",
                        "La CNIL informe toutes les personnes concernées et tous les responsables de traitements de leurs droits et obligations. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00035",
                        "Elle peut, à cette fin, apporter une information adaptée aux collectivités territoriales, à leurs groupements ainsi qu’aux petites et moyennes entreprises.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.2
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00036",
                  "2.2 — Veiller au respect de la loi et aux dispositions relatives à la protection des données",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00037",
                        "Elle veille à ce que les traitements de données à caractère personnel soient mis en œuvre conformément à la loi Informatique et Libertés, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00038",
                        "au RGPD et aux autres textes relatifs à la protection des données personnelles. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00039",
                        "Dans ce cadre, elle dispose de pouvoirs de contrôle sur place ou sur pièces et peut prononcer des mises en demeure ou des sanctions.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.3
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00040",
                  "2.3 — Délivrer un label",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00041",
                        "La CNIL délivre des labels à des produits ou à des procédures tendant à la protection des données à caractère personnel, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00042",
                        "attestant leur conformité aux dispositions de la loi. Ces labels constituent un outil de confiance pour les usagers et les partenaires.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.4
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00043",
                  "2.4 — Se tenir informée de l’évolution des technologies de l’information",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00044",
                        "La CNIL se tient informée de l’évolution des technologies de l’information et de la communication. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00045",
                        "Elle rend publique, le cas échéant, son appréciation des conséquences de ces évolutions sur l’exercice des droits et libertés, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00046",
                        "par exemple à propos de la vidéoprotection, des objets connectés, de l’intelligence artificielle ou de la reconnaissance faciale.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 2.5
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00047",
                  "2.5 — Présenter des observations devant toute juridiction",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00048",
                        "La CNIL peut présenter des observations devant toute juridiction, à l’occasion d’un litige relatif à l’application de la loi Informatique et Libertés ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00049",
                        "ou des dispositions relatives à la protection des données à caractère personnel prévues par les textes législatifs et réglementaires, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00050",
                        "par le droit de l’Union européenne ou par les engagements internationaux de la France.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00051",
                        "Les infractions aux dispositions de la loi du 6 janvier 1978 sont prévues et réprimées par les articles 226-16 à 226-24 du Code pénal. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00052",
                        "Il s’agit de délits, assortis de peines d’amende et parfois d’emprisonnement.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 3 — PROTECTION DES DONNÉES
          // =====================================================
          _HypoCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
              "f00053",
              "Chapitre 3 — La protection des données",
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
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00054",
                        "Constitue un fichier de données à caractère personnel tout ensemble structuré de données à caractère personnel accessibles selon des critères déterminés, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00055",
                        "que cet ensemble soit centralisé, décentralisé ou réparti de manière fonctionnelle ou géographique (article 2 de la loi).",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00056",
                        "Le RGPD a supprimé la plupart des déclarations préalables de fichiers auprès de la CNIL. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00057",
                        "Seules subsistent certaines formalités pour des secteurs sensibles, comme la santé ou la police-justice.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 12),

              // 3.1
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00058",
                  "3.1 — Conditions de mise en œuvre de certains traitements de données relevant de l’État",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00059",
                        "Le législateur a expressément maintenu, pour certaines catégories de traitements à risques relevant du secteur public, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00060",
                        "et en particulier pour les traitements dits de souveraineté, un régime de demande d’avis auprès de la CNIL. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00061",
                        "Sont visés les traitements qui intéressent la sûreté de l’État, la défense ou la sécurité publique, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00062",
                        "ou ceux ayant pour objet la prévention, la recherche, la constatation ou la poursuite des infractions pénales, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00063",
                        "ainsi que l’exécution des condamnations pénales ou des mesures de sûreté (article 31).",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00064",
                        "Les traitements de données à caractère personnel mis en œuvre pour le compte de l’État, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00065",
                        "agissant dans l’exercice de ses prérogatives de puissance publique, qui portent sur des données génétiques ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00066",
                        "ou sur des données biométriques nécessaires à l’authentification ou au contrôle de l’identité des personnes, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00067",
                        "sont autorisés par décret en Conseil d’État, après avis motivé et publié de la CNIL (article 32).",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00068",
                    "Les actes autorisant la création d’un tel traitement doivent préciser notamment :",
                  ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00069",
                    "la finalité du traitement et, le cas échéant, sa dénomination ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00070",
                    "le service auprès duquel s’exerce le droit d’accès ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00071",
                    "les catégories de données à caractère personnel enregistrées ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00072",
                    "les destinataires ou catégories de destinataires habilités à recevoir communication de ces données ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00073",
                    "le cas échéant, les dérogations à l’obligation d’information des personnes concernées ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00074",
                    "le cas échéant, les limitations et restrictions aux droits des personnes concernées ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00075",
                    "le cas échéant, la désignation, parmi les responsables conjoints du traitement, du point de contact pour les personnes concernées.",
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              // 3.2
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00076",
                  "3.2 — Les droits des personnes sur leurs données",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00077",
                        "Sont ici évoquées principalement les dispositions relatives aux traitements mis en œuvre à des fins de prévention et de détection des infractions pénales, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00078",
                        "d’enquêtes et de poursuites en la matière ou d’exécution de sanctions pénales, ainsi qu’à la libre circulation de ces données.",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 3.2.1
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00079",
                  "3.2.1 — Information de la personne concernée (article 104)",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00080",
                    "Le responsable du traitement doit mettre à disposition de la personne concernée notamment :",
                  ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00081",
                    "l’identité et les coordonnées du responsable de traitement et, le cas échéant, celles de son représentant ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00082",
                    "le cas échéant, les coordonnées du délégué à la protection des données (DPO) ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00083",
                    "les finalités poursuivies par le traitement auquel les données sont destinées ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                    "f00084",
                    "le droit d’introduire une réclamation auprès de la Commission nationale de l’informatique et des libertés (CNIL) et les coordonnées de celle-ci ;",
                  ),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00085",
                        "l’existence du droit de demander au responsable de traitement l’accès aux données personnelles, leur rectification ou leur effacement, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00086",
                        "ainsi que le droit de demander la limitation du traitement des données personnelles concernant la personne.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              // 3.2.2
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00087",
                  "3.2.2 — Un droit d’accès direct (article 105)",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00088",
                        "Toute personne peut demander si des données à caractère personnel la concernant sont ou ne sont pas traitées. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00089",
                        "Si tel est le cas, elle peut obtenir des informations sur ce traitement (finalités, base juridique, catégories de données concernées, etc.).",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),

              // 3.2.3
              Text(
                ScolariteText.value(
                  "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                  "f00090",
                  "3.2.3 — Droit de rectification, de complément et d’effacement (article 106)",
                ),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00091",
                        "La personne concernée peut demander au responsable d’un fichier de procéder à la rectification des données personnelles inexactes, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00092",
                        "au complément des données incomplètes, ainsi qu’à l’effacement des données dont la conservation serait contraire à la loi. ",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 4),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00093",
                        "Les décisions judiciaires et les dossiers faisant l’objet d’une procédure pénale ne sont pas régis par ces dispositions : ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00094",
                        "l’accès à ces données et les conditions de rectification ou d’effacement sont prévus par le Code de procédure pénale (article 111), ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                        "f00095",
                        "par exemple pour les modalités d’effacement des données inscrites dans le TAJ (articles 230-8 et 230-9 du C.P.P.).",
                      ),
                  style: TextStyle(color: textColor),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 24),

          // PETIT FOCUS OPÉRATIONNEL
          _NotaBox(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
              "f00096",
              "Enjeux pratiques pour les services de police",
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                      "f00097",
                      "Les fichiers de police (TAJ, FPR, fichiers de la circulation, etc.) sont soumis au contrôle de la CNIL. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                      "f00098",
                      "Toute création ou consultation doit reposer sur un fondement légal clair, une finalité déterminée et un accès strictement limité aux missions de service. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/libertes_publiques_pages/individuelles/cnil_protection_donnees_page.dart",
                      "f00099",
                      "En cas de doute, il convient de se référer aux textes réglementaires et aux référents « protection des données » de l’unité.",
                    ),
                style: TextStyle(color: textColor),
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
        text ?? "",
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
          Text("• ", style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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
  const _ExempleBox({required this.bodySpans});

  final String title = 'NOTA';
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
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

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
            "$title :",
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
              text: "$title : ",
              style: TextStyle(fontWeight: FontWeight.w900, color: titleColor),
            ),
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}
