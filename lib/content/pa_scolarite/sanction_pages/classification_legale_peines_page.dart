import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaClassificationLegalePeinesPage extends StatelessWidget {
  const PaClassificationLegalePeinesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/sanctions/classification_peines/classification_legale_peines';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // ✅ Tous les articles de loi doivent être rouges
    const lawRed = Color(0xFFE53935);

    Color cardBg(Color light, Color dark) => isDark ? dark : light;

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
            "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
            "f00002",
            "Classification légale des peines",
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
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
              "f00003",
              "La classification légale des peines",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.12,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
              "f00004",
              "Idée générale",
            ),
            cardColor: cardBg(const Color(0xFFF6F7FB), const Color(0xFF2B2B2B)),
            accent: const Color(0xFF1565C0),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00005",
                      "Le code pénal a établi une échelle des peines qui commande la classification ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00006",
                      "tripartite des infractions en crimes, délits ou contraventions.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00007",
                    "Elle figure aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00008",
                    "articles 131-1 à 131-18",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00009",
                    "131-37 à 131-44-1",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: " du "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00010",
                    "code pénal",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 1 =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
              "f00011",
              "Chapitre 1 — Peines applicables aux personnes physiques",
            ),
            cardColor: cardBg(const Color(0xFFEFF7FF), const Color(0xFF263244)),
            accent: const Color(0xFF42A5F5),
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00012",
                  "1.1 — Les peines criminelles",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00013",
                  "1.1.1 — Peines principales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00014",
                  "Les peines principales encourues en matière criminelle sont :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00015",
                  "Réclusion ou détention criminelle à perpétuité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00016",
                  "Réclusion ou détention criminelle de 30 ans au plus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00017",
                  "Réclusion ou détention criminelle de 20 ans au plus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00018",
                  "Réclusion ou détention criminelle de 15 ans au plus",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00019",
                  "La réclusion est applicable aux crimes de droit commun, la détention aux crimes politiques.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00020",
                    "Le juge peut prononcer une peine d’une durée inférieure à celles mentionnées à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00021",
                    "l’art. 131-1 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00022",
                    ", mais la durée de la réclusion ou de la détention doit être de 10 ans au moins.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00023",
                      "Une peine d’amende peut également être appliquée, mais uniquement lorsque le texte ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00024",
                      "réprimant le crime le prévoit expressément.",
                    ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00025",
                  "1.1.2 — Peines complémentaires",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00026",
                    "Peuvent être prononcées une ou plusieurs peines complémentaires prévues à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00027",
                    "l’article 131-10 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00028",
                        ". Elles s’ajoutent aux peines principales et sont spécialement prévues par le texte ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00029",
                        "qui réprime l’infraction.",
                      ),
                ),
              ]),

              SizedBox(height: 14),

              // ===================== 1.2 =====================
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00030",
                  "1.2 — Les peines correctionnelles",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00031",
                    "Les peines correctionnelles sont énumérées à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00032",
                    "l’article 131-3 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 8),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00033",
                  "1.2.1 — Peines principales",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00034",
                  "Emprisonnement : échelle de 8 degrés (10 ans, 7 ans, 5 ans, 3 ans, 2 ans, 1 an, 6 mois, 2 mois).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00035",
                  "L’emprisonnement peut faire l’objet d’un sursis, d’un sursis probatoire ou d’un aménagement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00036",
                  "Amende : montant minimum de 3 750 €.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00037",
                  "1.2.2 — Peines alternatives",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00038",
                      "Les peines alternatives ne figurent pas dans le texte réprimant l’infraction : elles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00039",
                      "sont prévues par des dispositions générales et peuvent être substituées par le juge.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00040",
                  "Détention à domicile sous surveillance électronique (15 jours à 6 mois) : art. 131-4-1 du C.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00041",
                  "Jour-amende à la place de l’amende si le délit est puni d’emprisonnement : art. 131-5 du C.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00042",
                  "Peines privatives ou restrictives de droits : art. 131-6 du C.P.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00043",
                  "Travail d’intérêt général (20 à 400 heures) à la place de l’emprisonnement : art. 131-8 du C.P.",
                ),
              ),
              SizedBox(height: 8),

              // ✅ Mise en rouge des articles cités dans les bullets ci-dessus
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00044",
                  "Rappel (articles)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00045",
                      "art. 131-4-1",
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  TextSpan(text: ", "),
                  TextSpan(
                    text: "131-5",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  TextSpan(text: ", "),
                  TextSpan(
                    text: "131-6",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  TextSpan(text: ", "),
                  TextSpan(
                    text: "131-8",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  TextSpan(text: " du "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00046",
                      "Code pénal",
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: lawRed,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00047",
                  "1.2.3 — Peines complémentaires",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00048",
                    "Peines complémentaires possibles, notamment celles énoncées à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00049",
                    "l’article 131-10 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00050",
                    ". Elles peuvent être prononcées en plus des peines principales ou à leur place.",
                  ),
                ),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00051",
                  "1.2.4 — Peines de stage et sanction-réparation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00052",
                    "Peine de stage : obligation d’accomplir un stage (≤ 1 mois) (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00053",
                    "art. 131-5-1 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00054",
                    "Sanction-réparation : indemnisation du préjudice de la victime (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00055",
                    "art. 131-8-1 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00056",
                        "). Ces peines peuvent être alternatives (à la place de l’emprisonnement ou de l’amende) ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00057",
                        "ou complémentaires (s’ajoutant à la peine prononcée).",
                      ),
                ),
              ]),

              SizedBox(height: 14),

              // ===================== 1.3 =====================
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00058",
                  "1.3 — Les peines contraventionnelles",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00059",
                    "Les peines contraventionnelles sont prévues à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00060",
                    "l’article 131-12 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00061",
                  "1.3.1 — Peines principales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00062",
                    "L’article 131-13 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00063",
                        " dispose que constituent des contraventions les infractions que la loi punit d’une amende ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00064",
                        "n’excédant pas 3 000 €.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00065",
                  "Montant maximal selon la classe :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00066",
                  "1ère classe : 38 € au plus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00067",
                  "2ème classe : 150 € au plus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00068",
                  "3ème classe : 450 € au plus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00069",
                  "4ème classe : 750 € au plus",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00070",
                  "5ème classe : 1 500 € au plus (pouvant être porté à 3 000 € en cas de récidive).",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00071",
                  "1.3.2 — Peines alternatives",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00072",
                    "Uniquement pour les contraventions de 5ème classe : peines privatives ou restrictives de droits prévues à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00073",
                    "l’article 131-14 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00074",
                  "1.3.3 — Peines complémentaires",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00075",
                    "Si le règlement le prévoit expressément, elles sont listées aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00076",
                    "articles 131-16 et 131-17 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00077",
                    ". Le juge peut les prononcer en plus de l’amende ou, à titre principal, à la place de l’amende.",
                  ),
                ),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00078",
                  "1.3.4 — Sanction-réparation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00079",
                    "Prévue uniquement pour les contraventions de 5ème classe : elle peut être prononcée à la place ou en même temps que l’amende (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00080",
                    "art. 131-15-1 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // ===================== CHAPITRE 2 =====================
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
              "f00081",
              "Chapitre 2 — Peines applicables aux personnes morales",
            ),
            cardColor: cardBg(const Color(0xFFFFF8E1), const Color(0xFF2F2A1B)),
            accent: const Color(0xFFF9A825),
            titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00082",
                    "La répression applicable aux personnes morales figure aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00083",
                    "articles 131-37 à 131-49 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00084",
                  "2.1 — Peines criminelles et correctionnelles",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00085",
                    "Elles figurent à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00086",
                    "l’article 131-37 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00087",
                        " : amende et, dans les cas prévus par la loi, les peines de l’article 131-39 et la peine de l’article 131-39-2. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00088",
                        "En matière correctionnelle : sanction-réparation (art. 131-39-1).",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00089",
                    "L’article 131-38 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00090",
                        " fixe le taux maximum de l’amende : quintuple de celui prévu pour les personnes physiques. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                        "f00091",
                        "Si crime sans amende prévue pour les personnes physiques : amende = 1 000 000 €.",
                      ),
                ),
              ]),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                  "f00092",
                  "2.2 — Peines contraventionnelles",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00093",
                    "Énoncées à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00094",
                    "l’article 131-40 du C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00095",
                    " : amende et, pour les contraventions de 5ème classe, peines privatives/restrictives (art. 131-42) + sanction-réparation (art. 131-44-1).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00096",
                    "Peines complémentaires possibles (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00097",
                    "art. 131-43 C.P.",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w800, color: lawRed),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                    "f00098",
                    ") : elles peuvent s’ajouter à une peine principale ou être prononcées seules à titre de peine principale.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00099",
                      "Retenez surtout la logique : la nature de la peine (criminelle, correctionnelle, contraventionnelle) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00100",
                      "structure la classification des infractions. Les articles du Code pénal encadrent l’échelle, les ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/sanction_pages/classification_legale_peines_page.dart",
                      "f00101",
                      "peines alternatives et les peines applicables aux personnes morales.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 22),
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
