import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAtteintesInvolontairesIttInferieure3MoisPage extends StatelessWidget {
  const PaAtteintesInvolontairesIttInferieure3MoisPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois';

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
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
            "f00002",
            "Atteintes involontaires",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
              "f00003",
              "Atteintes involontaires à l’intégrité de la personne\n(I.T.T. ≤ 3 mois — Contraventions)",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition (sans répéter des titres inutilement)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00005",
                    "Hors les cas prévus par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00006",
                    "les articles 222-20 et 222-20-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                        "f00007",
                        ", le fait de causer à autrui, par maladresse, imprudence, inattention, négligence ou manquement à une obligation de sécurité ou de prudence imposée par la loi ou le règlement, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                        "f00008",
                        "dans les conditions et selon les distinctions prévues à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00009",
                    "l’article 121-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                        "f00010",
                        ", une incapacité totale de travail d’une durée inférieure ou égale à trois mois constitue une infraction.\n\n",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                        "f00011",
                        "Le fait, par la violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence prévue par la loi ou le règlement, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                        "f00012",
                        "de porter atteinte à l’intégrité d’autrui sans qu’il résulte d’I.T.T. constitue également une infraction.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
              "f00013",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00014",
                    "Infractions prévues et réprimées par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00015",
                    "les articles R. 625-2, R. 625-3 et R. 622-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00016",
                  "Point-clé",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00017",
                      "On est ici sur des contraventions : le régime est particulier (élément moral non exigé, distinctions selon ITT, etc.).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (pédagogique + visuel)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
              "f00018",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00019",
                  "A) Un acte involontaire : la faute",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00020",
                    "L’article R. 610-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00021",
                    " précise que les dispositions des 3e et 4e alinéas de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00022",
                    "l’article 121-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00023",
                    " sont applicables aux contraventions lorsque le règlement exige une faute d’imprudence ou de négligence.",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00024",
                  "1) La faute simple (imprudence simple)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00025",
                    "L’article R. 625-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00026",
                    ", en référence à l’article 121-3, énumère une liste limitative de comportements fautifs (les juges doivent en caractériser au moins un).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00027",
                  "Maladresse, imprudence, inattention, négligence.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00028",
                      "• Imprudence / maladresse / inattention : agir sans précautions.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00029",
                      "• Négligence : ne pas se soucier des conséquences de son abstention.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00030",
                      "Ces fautes s’apprécient par comparaison avec la conduite d’une personne « normalement » adroite, attentive, prudente et diligente ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00031",
                      "(ou du professionnel moyen/diligent selon le cas).",
                    ),
              ),
              SizedBox(height: 12),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00032",
                  "Manquement à une obligation de sécurité ou de prudence imposée par la loi ou le règlement.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00033",
                      "Le terme « règlement » vise des actes administratifs à caractère général et impersonnel. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00034",
                      "L’inobservation d’une obligation textuelle suffit : il n’est pas nécessaire de viser des devoirs généraux de prudence. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00035",
                      "Les magistrats doivent pouvoir préciser la source et la nature exacte de l’obligation violée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00036",
                      "Cass. crim., 18 juin 2002",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00037",
                      " : nécessité de préciser la source et la nature exacte de l’obligation violée.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00038",
                  "2) La faute caractérisée (cas de causalité indirecte)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00039",
                      "Si la faute est en lien direct avec le dommage, une faute simple suffit. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00040",
                      "Pour un auteur dont la faute n’est qu’indirectement à l’origine du dommage, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00041",
                      "il faut démontrer une faute caractérisée : lourde, exposant autrui à un danger d’une particulière gravité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00042",
                      "que l’auteur ne pouvait ignorer (faute grossière, inacceptable).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00043",
                      "Exemples de jurisprudence :\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00044",
                      "• Remettre volontairement les clés à une personne sans permis et alcoolisée — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00045",
                      "Cass. crim., 14 décembre 2010",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00046",
                      "• Médecin du SAMU n’ayant pas posé les bonnes questions — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00047",
                      "Cass. crim., 2 décembre 2003",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00048",
                  "3) Violation manifestement délibérée d’une obligation particulière",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00049",
                      "Il faut :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00050",
                      "• une obligation particulière de prudence/sécurité prévue par la loi ou le règlement,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00051",
                      "• la connaissance de cette obligation,\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00052",
                      "• un choix délibéré de ne pas la respecter.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00053",
                  "B) Un lien de causalité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00054",
                      "Un lien de causalité entre la faute et l’atteinte (physique ou psychique) est nécessaire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00055",
                      "Quand plusieurs fautes concourent au dommage, la causalité n’a pas à être immédiate : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00056",
                      "le dommage est apprécié dans son dernier état.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00057",
                  "Causalité directe / indirecte (personnes physiques)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00058",
                    "L’article 121-3 alinéa 4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00059",
                    " définit les auteurs indirects : ils ne sont pas directement à l’origine du dommage mais ont créé/contribué à créer la situation dangereuse ou n’ont pas pris les mesures permettant de l’éviter.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00060",
                      "Jurisprudence : professionnel de location confiant un scooter des mers à une personne sans permis — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00061",
                      "Cass. crim., 5 octobre 2004",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00062",
                      "La causalité indirecte est souvent retenue pour le chef d’entreprise/directeur d’établissement en matière d’accidents du travail — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00063",
                      "Cass. crim., 28 mars 2006",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00064",
                      "Exemples (maire : lien indirect) :\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00065",
                      "• Aire de jeux : buse non fixée écrasant un enfant — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00066",
                      "Cass. crim., 20 mars 2001",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00067",
                      "• Absence de réglementation des déplacements de dameuses sur piste de luge — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00068",
                      "Cass. crim., 18 mars 2003",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00069",
                  "C) Sur la personne d’autrui (victime)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00070",
                  "Une personne humaine.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00071",
                  "Une personne vivante.",
                ),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00072",
                      "Jurisprudence : enfant ayant survécu une heure après sa naissance et décédé des suites d’un accident — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00073",
                      "Cass. crim., 2 décembre 2003",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00074",
                  "D) Un dommage",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00075",
                    "Article R. 625-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00076",
                    " : atteinte physique/psychique entraînant une I.T.T. ≤ 3 mois consécutifs (pas de périodes additionnées).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00077",
                    "Article R. 625-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00078",
                    " : atteinte sans I.T.T., mais résultant d’une violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00079",
                    "Article R. 622-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00080",
                    " : atteinte sans I.T.T.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
              "f00081",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00082",
                  "Non exigé en matière contraventionnelle.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
              "f00083",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00084",
                      "La contravention de 5e classe prévue par R. 625-3 constitue l’aggravation de la contravention de 2e classe prévue par R. 622-1 ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00085",
                      "en cas de violation manifestement délibérée d’une obligation particulière de sécurité ou de prudence imposée par la loi ou le règlement.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00086",
                    "Fondement : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00087",
                    "article R. 625-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00088",
                    " (aggravation de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00089",
                    "R. 622-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité (pédago + propre)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
              "f00090",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00091",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00092",
                  "Les qualifications sont contraventionnelles (2e ou 5e classe selon les cas).",
                ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00093",
                    "• Atteintes involontaires sans I.T.T. (2e classe) — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00094",
                    "article R. 622-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " : "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00095",
                    "amende de 2e classe.",
                  ),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00096",
                    "• I.T.T. ≤ 3 mois (5e classe) — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00097",
                    "article R. 625-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " : "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00098",
                    "amende de 5e classe.",
                  ),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00099",
                    "• Sans I.T.T. + violation manifestement délibérée d’une obligation particulière (5e classe) — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00100",
                    "article R. 625-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " : "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00101",
                    "amende de 5e classe.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00102",
                  "Responsabilité pénale des personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00103",
                    "Prévue notamment par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00104",
                    "l’article R. 625-5 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                    "f00105",
                    "l’article R. 622-1 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                      "f00106",
                      "Même si la causalité avec le dommage est indirecte, la responsabilité peut être engagée en cas de faute simple.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00107",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00108",
                  "Tentative : NON.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteintes_involontaires/atteintes_involontaires_itt_inferieure_3_mois_contenu_page.dart",
                  "f00109",
                  "Complicité : NON.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

/* ///////////////////////////////////////////////////////////////////////////
   ///                   TES WIDGETS PERSONNALISÉS EXACTS                  ///
   ///////////////////////////////////////////////////////////////////////////

   ✅ Colle ici exactement tes widgets (_ConditionCard, _SubTitle, _Paragraph, etc.)
   (Tu m’as dit qu’ils sont déjà prêts, donc je ne les réécris pas.)
*/

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
