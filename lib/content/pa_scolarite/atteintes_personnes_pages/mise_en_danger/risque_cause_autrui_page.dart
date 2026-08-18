import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaRisqueCauseAutruiPage extends StatelessWidget {
  const PaRisqueCauseAutruiPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/mise_en_danger/risque_cause_autrui';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cards colors (cohérent avec tes pages)
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
              "f00003",
              "Le risque causé à autrui",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00005",
                      "Le fait d’exposer directement autrui à un risque immédiat de mort ou de blessures de nature ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00006",
                      "à entraîner une mutilation ou une infirmité permanente, par la violation manifestement délibérée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00007",
                      "d’une obligation particulière de prudence ou de sécurité imposée par la loi ou le règlement, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00008",
                      "constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
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
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00010",
                    "Article 223-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00011",
                    " : prévoit et réprime les risques causés à autrui.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00013",
                  "A) Obligation particulière de prudence ou de sécurité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00014",
                  "1) Imposée par la loi ou le règlement",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00015",
                        "La source textuelle de l’obligation est une condition essentielle. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00016",
                        "S’agissant du « règlement », ne sont retenus que les actes des autorités administratives ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00017",
                        "à caractère général et impersonnel ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00018",
                    "(Cass. crim., 10 mai 2000)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00019",
                        ". Sont exclus notamment : un règlement intérieur d’entreprise, ou un arrêté préfectoral ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00020",
                        "déclarant un immeuble insalubre.",
                      ),
                ),
              ]),
              SizedBox(height: 12),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00021",
                  "2) Obligation « particulière »",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00022",
                      "Le texte ne définit pas précisément l’obligation particulière. La jurisprudence retient ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00023",
                      "des critères : règles objectives, précises et claires, ne laissant aucune place à une interprétation ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00024",
                      "subjective personnelle.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00025",
                          "Exemple (CAA / CA) : obligation particulière = règle objective précise, claire, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00026",
                          "ne permettant aucune part d’interprétation subjective personnelle ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00027",
                      "(C.A. Grenoble, 19 février 1999)",
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
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00028",
                      "Obligation particulière reconnue : prescription du ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00029",
                      "Code de la route, article R. 414-4",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00030",
                          " imposant au conducteur de se porter suffisamment sur la gauche pour ne pas risquer ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00031",
                          "d’accrocher l’usager dépassé ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00032",
                      "(Cass. crim., 23 juin 1999)",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00033",
                  "B) Exposition directe au risque",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00034",
                  "1) Risque de mort, mutilation ou infirmité permanente",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00035",
                      "Seules les mises en danger les plus graves sont incriminées : il doit s’agir d’un péril physique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00036",
                      "d’extrême gravité. Le danger peut être individuel ou collectif, mais doit être potentiellement certain. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00037",
                      "Si le risque n’est pas d’une gravité suffisante, le délit n’est pas constitué.",
                    ),
              ),
              SizedBox(height: 12),

              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00038",
                  "2) Risque direct et immédiat : lien de causalité",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00039",
                        "Le lien entre la violation de l’obligation et le risque doit être direct : ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00040",
                        "le comportement dangereux doit être la seule cause du risque (cause directe, exclusive et unique). ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00041",
                        "Le délit n’est constitué que si le manquement a été la « cause directe et immédiate du risque » ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00042",
                    "(Cass. crim., 16 février 1999)",
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
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00043",
                          "Jurisprudence : mise en cause de la société TOTAL pour un pic de pollution ; ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00044",
                          "absence de risque de mort ou de blessures établi dans les termes du Code pénal ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00045",
                      "(Cass. crim., 4 octobre 2005)",
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
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00046",
                          "Jurisprudence : la seule vitesse excessive ne suffit pas ; il faut un comportement ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00047",
                          "exposant autrui à un risque immédiat de mort ou blessures graves en plus du dépassement ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00048",
                      "(Cass. crim., 16 décembre 2015)",
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
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00049",
                      "Les juges du fond apprécient concrètement la gravité du risque, ce qui explique des écarts ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00050",
                      "de jurisprudence selon les circonstances.",
                    ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00051",
                          "Délit non retenu : automobiliste à 200 km/h sur autoroute en journée, circulation fluide, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00052",
                          "conditions atmosphériques et visibilité excellentes ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00053",
                      "(C.A. Douai, 26 octobre 1994)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Exemple",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00054",
                          "Délit retenu : automobiliste roulant de nuit à 180 km/h en zone urbaine, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00055",
                          "multiples déplacements droite/gauche ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00056",
                      "(C.A. Paris, 27 octobre 1995)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
                title: "Exemple",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
              "f00057",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00058",
                  "Violation manifestement délibérée d’une obligation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00059",
                      "Le risque de mort ou de blessures graves est l’effet de la violation. Il importe peu que l’auteur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00060",
                      "ait une vision précise des risques réellement encourus : l’élément moral tient à la conscience de ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00061",
                      "violer la norme de prudence ou de sécurité destinée à éviter le danger.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00062",
                      "Lorsque la personne viole délibérément une obligation légale ou réglementaire, elle a ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00063",
                      "nécessairement conscience du risque créé pour autrui : il s’agit d’une faute délibérée.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00064",
                      "L’intention coupable est donc celle de violer la règle, et non celle de porter atteinte à l’intégrité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00065",
                      "physique d’autrui.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00066",
                        "L’élément intentionnel résulte de la violation manifestement délibérée d’une obligation particulière ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00067",
                        "exposant autrui à un risque grave ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00068",
                    "(Cass. crim., 1er juin 1999)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
              "f00069",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00070",
                  "Aucune circonstance aggravante spécifique prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
              "f00071",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00072",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00073",
                    "Délit — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00074",
                    "article 223-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00075",
                    " : 1 an d’emprisonnement et 15 000 € d’amende.",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00076",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00077",
                    "Article 223-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00078",
                        " : les personnes morales peuvent être déclarées responsables pénalement des infractions définies ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                        "f00079",
                        "à l’article 223-1.",
                      ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00080",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                  "f00081",
                  "Tentative : NON",
                ),
              ),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00082",
                    "Complicité : OUI — conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00083",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                    "f00084",
                    "l’article 121-7 du Code pénal",
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
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00085",
                          "Même si l’infraction est classée parmi les infractions non intentionnelles, elle n’exclut pas ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                          "f00086",
                          "la complicité ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00087",
                      "(Cass. crim., 6 juin 2000)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/mise_en_danger/risque_cause_autrui_page.dart",
                      "f00088",
                      ". Exemple : complicité par instigation retenue pour un passager ordonnant à son chauffeur de franchir un feu rouge.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),
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
