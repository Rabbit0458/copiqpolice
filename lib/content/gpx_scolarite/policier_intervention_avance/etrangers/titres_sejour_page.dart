import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class TitresSejourPage extends StatelessWidget {
  const TitresSejourPage({super.key});

  static const String routeName = '/gpx/intervention/etrangers/titres-sejour';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMaj = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMin = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAsile = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardProv = isDark
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
            "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
            "f00002",
            "Étrangers",
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
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
              "f00003",
              "Les différents titres de séjour",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
              "f00004",
              "Point de départ (contrôle)",
            ),
            cardColor: cardProv,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00005",
                      "Dès que la qualité d’étranger est établie, il appartient au gardien de la paix ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00006",
                      "d’examiner le titre de séjour présenté : type, validité, mentions, cohérence avec la situation.",
                    ),
              ),
              SizedBox(height: 10),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00007",
                  "Toujours vérifier : identité / dates / mentions (activité, étudiant…) / intégrité du document.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00008",
                  "En cas de doute : recoupements via les outils et canaux habituels (procédures internes).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
              "f00009",
              "Cadre légal (référence)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00010",
                    "Article L. 411-1 du C.E.S.E.D.A.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00011",
                    " : présente les principaux titres de séjour délivrés aux majeurs (typologie).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00012",
                      "La mention exacte portée sur le titre est déterminante (ex. « salarié », « vie privée et familiale », « étudiant »…).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Majeurs
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
              "f00013",
              "I — Titres de séjour délivrés aux majeurs",
            ),
            cardColor: cardMaj,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00014",
                  "A) Les différents titres",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00015",
                    "Base : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00016",
                    "article L. 411-1 du C.E.S.E.D.A.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00017",
                  "1) Carte de résident",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00018",
                      "Délivrable aux étrangers résidant en France qui remplissent les conditions fixées par la loi. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00019",
                      "Validité : 10 ans. La carte de résident permanent est délivrée de droit dès le 2ᵉ renouvellement (selon régime applicable).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00020",
                  "2) Carte de séjour temporaire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00021",
                      "Validité : 1 an. Concerne notamment les étrangers ne remplissant pas les conditions pour une carte de résident. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00022",
                      "Peut se présenter sous forme de carte plastifiée ou de vignette apposée sur le passeport. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00023",
                      "Elle comporte des mentions (ex. « salarié », « vie privée et familiale »).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00024",
                  "3) Carte de séjour pluriannuelle",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00025",
                      "Porte des mentions (ex. « talent », « étudiant-programme de mobilité », « salarié détaché ICT »). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00026",
                      "Validité : de 2 à 4 ans, renouvelable.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00027",
                    "Article L. 411-4 du C.E.S.E.D.A.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00028",
                    " : durée/renouvellement (référence).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00029",
                  "4) Carte de séjour « retraité »",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00030",
                      "Validité : 10 ans, renouvelée de plein droit. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00031",
                      "Le bénéficiaire peut entrer en France à tout moment pour y effectuer des séjours n’excédant pas 1 an.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00032",
                  "5) Certificat de résidence algérien",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00033",
                  "Régime particulier lié à un accord bilatéral. Les ressortissants algériens se voient délivrer un certificat de résidence algérien.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00034",
                  "Tout ressortissant algérien majeur doit être titulaire d’un titre de séjour pour résider en France.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00035",
                  "Entre 16 et 18 ans : titre requis s’il souhaite travailler.",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00036",
                      "Un certificat d’1 an peut être délivré avec mentions (« vie privée et familiale », « salarié », « étudiant »…). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00037",
                      "Un certificat de 10 ans peut aussi être délivré sous certaines conditions.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00038",
                  "6) Résidents U.E / E.E.E",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00039",
                      "Les résidents de l’Union européenne et de l’Espace économique européen peuvent séjourner en France ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00040",
                      "avec un passeport ou une carte nationale d’identité en cours de validité.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00041",
                      "Ils peuvent également demander une carte de séjour « Ressortissant d’un État membre de l’U.E » ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00042",
                      "(convenances personnelles). Certains cas peuvent exiger une mention autorisant l’activité professionnelle.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00043",
                      "E.E.E. : États membres de l’U.E + Islande, Liechtenstein, Norvège.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00044",
                  "7) Visas de long séjour (visa D)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00045",
                      "Trois grands types existent, selon les mentions : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00046",
                      "« vie privée et familiale », « visiteur », « étudiant », « salarié », « travailleur temporaire », ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00047",
                      "« scientifique-chercheur », « stagiaire », etc. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00048",
                      "Certains visent une dispense temporaire de carte de séjour ou imposent une demande de carte dans les 2 mois.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00049",
                      "Ces visas valent titre de séjour (durée > 3 mois et ≤ 1 an). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00050",
                      "Les titulaires sont soumis à une procédure d’enregistrement auprès de l’O.F.I.I. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00051",
                      "Une vignette spécifique est apposée dans le passeport.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00052",
                  "8) Mention « Accord de retrait » (Royaume-Uni)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00053",
                      "Depuis le 1er janvier 2022, les ressortissants britanniques doivent détenir soit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00054",
                      "un titre spécifique portant la mention « Accord de retrait », soit un titre de droit commun.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Mineurs
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
              "f00055",
              "II — Titres / documents pour les mineurs",
            ),
            cardColor: cardMin,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00056",
                      "Les mineurs étrangers résidant en France sont dispensés de détenir un titre de séjour. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00057",
                      "Cependant, pour faciliter les déplacements à l’étranger et le retour sur le territoire, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00058",
                      "un document spécifique est requis.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00059",
                  "Document de Circulation pour Étranger Mineur (D.C.E.M.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00060",
                      "Le D.C.E.M. facilite les déplacements et la réadmission sur le territoire français. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00061",
                      "Sa durée de validité ne peut excéder 5 ans (conditions de délivrance simplifiées).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00062",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00063",
                    "articles L.414-4, L.414-5, L.414-6, L.414-9 et L. 236-1 du C.E.S.E.D.A.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                          "f00064",
                          "Un D.C.E.M. délivré par le préfet de Mayotte ne permet la réadmission qu’à Mayotte. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                          "f00065",
                          "Le document est inscrit dans l’application A.G.D.R.E.F.2.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Asile / apatrides
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
              "f00066",
              "III — Demandeurs d’asile, réfugiés, apatrides",
            ),
            cardColor: cardAsile,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00067",
                  "A) Définitions",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00068",
                  "Réfugié : craint d’être persécuté (race, religion, nationalité, groupe social, opinions politiques).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00069",
                  "Apatride : aucun État ne le considère comme ressortissant (Convention de New York, 28/09/1954).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00070",
                  "Protection subsidiaire : ne remplit pas les critères du réfugié, mais risque des menaces graves (peine de mort, tortures, traitements inhumains, menace grave contre la vie).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00071",
                  "B) Documents délivrés pendant la procédure",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00072",
                      "Les demandeurs déposent un dossier auprès de l’O.F.P.R.A. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00073",
                      "Ils reçoivent un récépissé constatant le dépôt (valable 3 mois). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00074",
                      "Il existe plusieurs types de récépissés (dépôt, reconnaissance de protection, admission au titre de l’asile).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00075",
                  "C) En cas de décision favorable de l’O.F.P.R.A.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00076",
                      "Les réfugiés et apatrides peuvent obtenir une carte de séjour pluriannuelle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00077",
                      "mention « bénéficiaire du statut d’apatride » (4 ans) ou une carte de résident (10 ans), selon le cas.",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00078",
                    "Articles L.424-1 et L. 424-18 du C.E.S.E.D.A.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00079",
                      "Les bénéficiaires de la protection subsidiaire reçoivent de plein droit une carte de séjour pluriannuelle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00080",
                      "mention « bénéficiaire de la protection subsidiaire » (4 ans). Une carte de résident (10 ans) peut être obtenue ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00081",
                      "après une résidence régulière d’au moins 4 ans (selon conditions).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                    "f00082",
                    "Articles L.424-9 et L. 424-13 du C.E.S.E.D.A.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Titres provisoires
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
              "f00083",
              "IV — Titres provisoires de séjour",
            ),
            cardColor: cardProv,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00084",
                  "A) Autorisation provisoire de séjour (A.P.S.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00085",
                      "Document autorisant la présence en France pendant sa durée de validité. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00086",
                      "Délivrée pour 15 jours, 1 mois, 3 mois ou 6 mois, renouvelable. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00087",
                      "Elle peut porter une mention autorisant (ou non) l’exercice d’un emploi.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00088",
                  "B) Récépissé de demande de carte de séjour (R.C.S.)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00089",
                      "Tout étranger autorisé à déposer une première demande ou un renouvellement reçoit un document provisoire appelé « récépissé ». ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                      "f00090",
                      "Il permet de demeurer régulièrement en France pendant l’instruction du dossier.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_avance/etrangers/titres_sejour_page.dart",
                  "f00091",
                  "Durée : au minimum 1 mois (souvent 3 mois), renouvelable si nécessaire.",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;

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
