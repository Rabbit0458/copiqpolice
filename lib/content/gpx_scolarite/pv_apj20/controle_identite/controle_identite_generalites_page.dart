import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ControleIdentiteGeneralitesPage extends StatelessWidget {
  const ControleIdentiteGeneralitesPage({super.key});

  static const String routeName = '/gpx/pv_apj20/controle_identite/generalites';

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
    final Color cardCadre = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCas = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardVerif = isDark
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
            "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
            "f00002",
            "Contrôles d’identité",
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
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
              "f00003",
              "Généralités — cadre, cas et vérifications",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / rappel déontologique
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
              "f00004",
              "Définition & principe de dignité",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00005",
                      "Le contrôle d’identité est l’opération par laquelle une personne est invitée à justifier ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00006",
                      "sur-le-champ de son identité.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00007",
                      "Le contrôle se déroule sans qu’il soit porté atteinte à la dignité de la personne qui en fait l’objet — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00008",
                      "art. R. 434-16 du C.S.I.",
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

          // ✅ Élément légal en haut (base juridique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
              "f00009",
              "I — Base légale",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00010",
                    "Article 78-1 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00011",
                    " : toute personne sur le territoire national doit accepter de se prêter à un contrôle d’identité réalisé dans les conditions légales.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00012",
                    "Article 78-2 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00013",
                    " : fixe les principaux régimes du contrôle d’identité (judiciaire, réquisitions, préventif, zone frontière…).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Cadre général
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
              "f00014",
              "II — Cadre général du contrôle d’identité",
            ),
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00015",
                  "A) Personnes concernées",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00016",
                    "Toute personne se trouvant sur le territoire national doit accepter de se prêter à un contrôle d’identité effectué légalement — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00017",
                    "art. 78-1 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00018",
                  "B) Autorités habilitées",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00019",
                  "Seuls certains personnels peuvent procéder à des contrôles d’identité, selon le cadre juridique.",
                ),
              ),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00020",
                  "Dans les cas prévus par le C.P.P. : O.P.J. et, sur leur ordre et sous leur responsabilité, A.P.J. et certains A.P.J. adjoints.",
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00021",
                    "Certains cas spécifiques (ex. cadres prévus par les articles 78-2-2 et 78-2-4) concernent aussi des A.P.J. adjoints listés par le C.P.P. — références dans ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00022",
                    "l’art. 21-1° ter (C.P.P.)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00023",
                  "C) Moyens de preuve de l’identité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00024",
                    "La personne peut justifier de son identité ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00025",
                    "par tout moyen",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0D47A1),
                  ),
                ),
                const TextSpan(text: " — "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00026",
                    "art. 78-2 (C.P.P.)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00027",
                  "• Documents officiels probants",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00028",
                  "Documents officiels avec photographie et délivrance après procédure d’identification (CNI, passeport, permis de conduire…).",
                ),
              ),

              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00029",
                  "• Autres documents (commencement de preuve)",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00030",
                  "Ex. carte d’électeur, certificat d’immatriculation, livret de famille… À apprécier selon les circonstances.",
                ),
              ),

              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00031",
                  "D) Recours à des témoignages",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00032",
                      "En cas de document non probant, ou en l’absence de pièce d’identité, la confirmation peut être obtenue ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00033",
                      "au moyen de témoignages concomitants au contrôle. Cette pratique reste à l’appréciation des policiers.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cas dans lesquels on peut contrôler (structure claire)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
              "f00034",
              "III — Cas de contrôle d’identité",
            ),
            cardColor: cardCas,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00035",
                  "A) Contrôles relevant de la police judiciaire",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00036",
                    "Référence principale : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00037",
                    "art. 78-2 (alinéas 1 à 7) du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00038",
                  "1) À l’initiative des policiers",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00039",
                    "Raisons plausibles de soupçonner (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00040",
                    "art. 78-2 (alinéas 2 à 6) du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ") :"),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00041",
                  "Qu’elle a commis ou tenté de commettre une infraction (crime, délit ou contravention) — art. 78-2 al. 2.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00042",
                  "Qu’elle se prépare à commettre un crime ou un délit — art. 78-2 al. 3 (ex. comportement anormal, fuite, changements brusques…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00043",
                  "Qu’elle est susceptible de fournir des renseignements utiles à l’enquête en cas de crime ou délit — art. 78-2 al. 4 (contraventions exclues).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00044",
                  "Qu’elle a violé des obligations/interdictions (contrôle judiciaire, ARSE, peine/mesure suivie) — art. 78-2 al. 5.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00045",
                  "Qu’elle fait l’objet de recherches ordonnées par une autorité judiciaire — art. 78-2 al. 6.",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00046",
                  "2) Sur réquisitions du procureur",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00047",
                    "Art. 78-2 al. 7 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00048",
                        " : réquisitions écrites précisant les infractions à rechercher, les lieux et la période. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00049",
                        "Le contrôle vise toute personne présente dans le périmètre défini.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00050",
                      "Le fait que le contrôle révèle d’autres infractions que celles visées dans les réquisitions ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00051",
                      "n’est pas une cause de nullité",
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0D47A1),
                    ),
                  ),
                  const TextSpan(text: " — "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00052",
                      "art. 78-2 al. 7 (C.P.P.)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00053",
                  "B) Contrôles d’identité préventifs",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00054",
                    "Art. 78-2 al. 8 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00055",
                        " : l’identité de toute personne peut être contrôlée pour prévenir une atteinte à l’ordre public, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00056",
                        "notamment à la sécurité des personnes et des biens.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00057",
                  "Vise toute personne présente sur le lieu où le contrôle est mis en œuvre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00058",
                  "Le contrôle n’est pas strictement lié au comportement : il doit reposer sur des éléments objectifs de menace.",
                ),
              ),
              const SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00059",
                  "Conditions usuelles",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00060",
                  "Lieu : public ou ouvert au public (gare, bar, salle de spectacle, galerie marchande…).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00061",
                  "Temps : circonstances particulières (alertes, grands rassemblements…). La simple “zone propice” ne suffit pas.",
                ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00062",
                  "C) Contrôles en zone frontière",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00063",
                    "Art. 78-2 al. 9 à 17 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00064",
                    " : vérification du respect des obligations de détention, port et présentation de titres dans certaines zones (Schengen, ports/aéroports/gares, trains transnationaux, etc.).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00065",
                  "Objectif : prévention/recherche d’infractions liées à la criminalité transfrontalière.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00066",
                  "Caractère : non permanent (durée limitée) et aléatoire (non systématique).",
                ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00067",
                  "D) Contrôles dans des locaux professionnels",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00068",
                    "Art. 78-2-1 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00069",
                        " : sur réquisitions écrites du procureur (durée max 1 mois), pour vérifier notamment le travail dissimulé. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00070",
                        "Visent les personnes occupées dans l’entreprise (locaux à usage exclusivement professionnel).",
                      ),
                ),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00071",
                  "E) Visites de véhicules & inspection/fouille de bagages",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00072",
                    "Cadre principal : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00073",
                    "art. 78-2-2 à 78-2-5 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00074",
                  "Sur réquisitions du procureur : contrôles + assistance OPJ pour visites véhicules et inspection/fouille bagages (selon cadres légaux).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00075",
                  "Crime/délit flagrant : assistance OPJ pour visite de véhicules (contrôle ID et bagages non prévus par ce cadre précis).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00076",
                  "Prévention d’une atteinte grave : visite véhicule / inspection ou fouille bagages avec accord, sinon sur instructions du procureur (immobilisation/rétention max 30 min selon cas).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Vérification d'identité + situation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
              "f00077",
              "IV — Vérifications (identité & situation)",
            ),
            cardColor: cardVerif,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00078",
                  "A) Vérification d’identité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00079",
                    "Art. 78-3 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00080",
                        " : si la personne refuse ou ne peut justifier de son identité, elle peut être retenue sur place ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00081",
                        "ou conduite au local pour vérification, et doit être présentée à un O.P.J.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00082",
                  "Durée maximale : 4 heures (responsabilité exclusive de l’O.P.J.).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00083",
                      "Droits possibles notifiés par un O.P.J. (ou A.P.J. sous contrôle d’un O.P.J.) : aviser le procureur, prévenir un proche, etc. — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                      "f00084",
                      "art. 78-3 (C.P.P.)",
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
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00085",
                  "B) Vérification de situation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                    "f00086",
                    "Art. 78-3-1 du C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00087",
                        " : lorsqu’un contrôle/vérification révèle des raisons sérieuses de penser que le comportement peut être lié à des activités terroristes, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                        "f00088",
                        "une retenue peut être décidée même en présence d’un justificatif d’identité.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00089",
                  "Responsabilité exclusive de l’O.P.J., sur place ou au local.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/controle_identite/controle_identite_generalites_page.dart",
                  "f00090",
                  "Durée maximale : 4 heures, limitée au temps nécessaire (consultation fichiers, contacts services, etc.).",
                ),
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
