import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class SuspectLibreGeneralitesPage extends StatelessWidget {
  const SuspectLibreGeneralitesPage({super.key});

  static const String routeName =
      '/gpx/pv_apj20/gav_suspect_libre/suspect_libre_generalites';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Cards
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardStatus = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardScope = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInfo = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRights = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMinor = isDark
        ? const Color(0xFF1F2B33)
        : const Color(0xFFF2FBFF);

    // Accents
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
    final Color accentCyan = isDark
        ? const Color(0xFF4DD0E1)
        : const Color(0xFF00838F);

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
            "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
            "f00002",
            "Suspect libre",
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
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
              "f00003",
              "Généralités — statut du suspect libre",
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
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
              "f00004",
              "Idée clé",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00005",
                  "Le suspect libre permet d’entendre une personne soupçonnée en dehors du cadre de la garde à vue.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00006",
                  "Elle est libre de quitter les locaux à tout moment : l’audition n’a pas de durée maximale.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00007",
                  "Les droits doivent être notifiés avant toute audition.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
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
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00009",
                    "Article 61-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00010",
                    " : définit les conditions d’audition libre d’une personne soupçonnée et impose l’information préalable sur ses droits.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00011",
                      "Le témoin (absence de raisons plausibles de soupçonner) relève d’un autre cadre : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00012",
                      "article 62 C.P.P.",
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

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
              "f00013",
              "II — Le statut du suspect libre",
            ),
            cardColor: cardStatus,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00014",
                  "A) Définition",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00015",
                    "Le suspect libre est une personne (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00016",
                    "art. 61-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ") :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00017",
                  "À l’encontre de laquelle il existe des raisons plausibles de soupçonner qu’elle a commis ou tenté de commettre une infraction (contravention, délit ou crime).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00018",
                  "Qui accepte d’être entendue sans contrainte par les services d’enquête.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00019",
                      "La personne est libre de quitter à tout moment les locaux où elle est entendue : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00020",
                      "la durée de l’audition n’est pas limitée dans le temps.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00021",
                  "À distinguer : le témoin",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00022",
                    "Le témoin est une personne à l’encontre de laquelle il n’existe aucune raison plausible de soupçonner (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00023",
                    "article 62 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00024",
                  "Aucun droit spécifique n’a à être notifié ; audition sans limite de temps.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00025",
                  "Il peut toutefois être retenu sous contrainte si nécessaire, pendant le temps strictement nécessaire, sans excéder 4 heures.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
              "f00026",
              "III — Champ d’application",
            ),
            cardColor: cardScope,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00027",
                  "1) Absence de contrainte",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00028",
                    "Principe : pas de contrainte (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00029",
                    "article 61-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00030",
                      "Si la personne a été conduite sous contrainte par la force publique devant l’O.P.J., ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00031",
                      "elle ne peut pas être entendue librement.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00032",
                  "Indicateurs typiques de contrainte",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00033",
                  "Personne contrainte à monter dans le véhicule de police.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00034",
                  "Personne menottée durant le trajet.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00035",
                      "Avant toute audition, l’enquêteur doit demander à la personne de confirmer qu’elle a suivi de son plein gré les agents et qu’elle n’a subi aucune contrainte lors du transport.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00036",
                  "Conséquences si contrainte",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00037",
                  "Placement en garde à vue si les conditions sont réunies.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00038",
                  "Ou remise en liberté avec convocation pour une audition ultérieure.",
                ),
              ),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00039",
                  "2) Cas particuliers",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00040",
                  "Certains contextes permettent une audition libre si les conditions sont respectées.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00041",
                  "• Chambre de sûreté (ivresse publique et manifeste)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00042",
                      "Une personne placée en chambre de sûreté le temps de recouvrer la raison peut ensuite être entendue librement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00043",
                      "sur la contravention d’ivresse publique et manifeste : les dispositions de l’audition libre s’appliquent.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00044",
                  "• Dépistage alcool/stupéfiants positif",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00045",
                    "La personne retenue pour dépistage/vérifications peut être entendue librement si : elle n’a pas été contrainte de demeurer à disposition, et si elle a été informée des droits de l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00046",
                    "article 61-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00047",
                  "• Personne gardée à vue entendue sur des faits distincts",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00048",
                    "Si, pendant une garde à vue, la personne est entendue sur des faits distincts en tant que suspect, certains droits de l’audition libre doivent être notifiés (1°, 3°, 4° et 5° de l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00049",
                    "article 61-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00050",
                    "), conformément à l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00051",
                    "article 65 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00052",
                  "3) Cadres d’enquête",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00053",
                  "Enquête de flagrance.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00054",
                  "Enquête préliminaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00055",
                  "Commission rogatoire (exécution).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
              "f00056",
              "IV — Information du suspect libre",
            ),
            cardColor: cardInfo,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00057",
                  "A) Convocation du mis en cause",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00058",
                  "Si l’enquête le permet, une convocation écrite peut être adressée. Elle peut préciser :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00059",
                  "L’infraction soupçonnée (commise ou tentée).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00060",
                  "Le droit d’être assisté d’un avocat dès le début de l’audition ou à tout moment.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00061",
                  "Les conditions d’accès à l’aide juridictionnelle.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00062",
                  "Les modalités de désignation d’un avocat commis d’office.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00063",
                  "Les lieux où obtenir des conseils juridiques.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00064",
                  "B) Notification des droits",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00065",
                    "Même en présence d’une convocation écrite préalable, les droits doivent être notifiés avant toute audition et consignés par PV, conformément à l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00066",
                    "article 61-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00067",
                  "PV spécifique possible, ou intégration dans le PV d’audition.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
              "f00068",
              "V — Droits du suspect libre",
            ),
            cardColor: cardRights,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00069",
                  "A) Droits à notifier avant toute audition",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00070",
                    "Droits visés à l’",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00071",
                    "article 61-1 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00072",
                  "Qualification, date et lieu présumés de l’infraction soupçonnée (toutes les infractions retenues doivent être communiquées).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00073",
                  "Droit de quitter les locaux à tout moment (si volonté de partir : aviser immédiatement l’O.P.J.).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00074",
                  "Droit à un interprète, si nécessaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00075",
                  "Droit de faire des déclarations, répondre aux questions ou se taire.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00076",
                  "Assistance d’un avocat (conditions)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00077",
                      "Le droit à l’assistance d’un avocat s’exerce au cours de l’audition, de la confrontation, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00078",
                      "ou lors d’opérations de reconstitution et séances d’identification, lorsque la personne est soupçonnée d’un crime ou d’un délit puni d’emprisonnement.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00079",
                  "Possibilité de s’entretenir au préalable avec l’avocat (temps suffisant).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00080",
                  "Choix libre de l’avocat ou désignation d’office par le bâtonnier.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00081",
                  "Frais d’avocat à la charge de la personne, sauf conditions d’aide juridictionnelle (remise d’une notice d’information).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00082",
                  "La personne peut changer d’avis à tout moment et demander un avocat en cours de procédure.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00083",
                  "Accès à certaines pièces",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00084",
                  "Si l’infraction est un crime ou un délit puni d’emprisonnement : la personne est informée de son droit de consulter les PV d’audition ou de confrontation antérieurs.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00085",
                  "Aucune copie ne peut être obtenue ou réalisée.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00086",
                  "Conseils juridiques (accès au droit)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00087",
                      "La personne peut bénéficier, le cas échéant gratuitement, de conseils juridiques dans une structure d’accès au droit ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00088",
                      "(maison de justice et du droit ou autres structures départementales).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00089",
                      "Un formulaire de notification des droits peut être remis (traductions disponibles sur le site du ministère de la Justice).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00090",
                  "Majeur protégé",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00091",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00092",
                    "article 706-112-2 C.P.P.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00093",
                    " : si tutelle/curatelle, avis au tuteur/curateur. Celui-ci peut désigner un avocat ou demander un avocat commis d’office.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00094",
                      "Si le majeur protégé n’a pas été assisté par un avocat et que le tuteur/curateur n’a pu être avisé, ses déclarations ne pourront pas servir à elles seules de fondement à une condamnation.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
              "f00095",
              "VI — Garanties spécifiques applicables au mineur",
            ),
            cardColor: cardMinor,
            accent: accentCyan,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00096",
                  "1) Avis aux représentants légaux",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00097",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00098",
                    "articles L. 412-1 et L. 412-2 C.J.P.M.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00099",
                  "Obligation d’aviser par tout moyen les représentants légaux, la personne ou le service auquel le mineur est confié.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00100",
                  "2) Assistance d’un avocat",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00101",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00102",
                    "article L. 412-2 C.J.P.M.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00103",
                    " : le mineur est assisté d’un avocat.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00104",
                  "À défaut de désignation par le mineur ou ses représentants, le bâtonnier est informé afin qu’un avocat soit commis d’office.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00105",
                  "3) Droit à l’information",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00106",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00107",
                    "article R. 412-1 C.J.P.M.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00108",
                  "Droit à ce que les représentants légaux ou l’adulte approprié soient informés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00109",
                  "Droit d’être accompagné (si décidé) lors des auditions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00110",
                  "Droit à la protection de la vie privée (interdiction de diffusion, publicité restreinte, interdiction de publier des éléments d’identification).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00111",
                  "4) Droit à l’accompagnement",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00112",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00113",
                    "article L. 311-1 C.J.P.M.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00114",
                      "Le mineur a le droit d’être accompagné par ses représentants légaux lors des auditions/interrogatoires. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00115",
                      "L’enquêteur apprécie selon les circonstances (intérêt supérieur de l’enfant, absence de préjudice à la procédure).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00116",
                  "5) Remplacement des titulaires de l’autorité parentale",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00117",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                    "f00118",
                    "article L. 311-2 C.J.P.M.",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00119",
                  "Information/accompagnement écartés si contraire à l’intérêt supérieur de l’enfant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00120",
                  "Ou si aucun représentant légal n’a pu être joint malgré des efforts raisonnables / identité inconnue.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                  "f00121",
                  "Ou si cela compromet significativement la procédure (ex : parents impliqués).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/pv_apj20/gav_suspect_libre/suspect_libre_generalites_page.dart",
                      "f00122",
                      "Dans ces cas, un adulte approprié peut être désigné par le mineur (personne majeure acceptée par l’enquêteur) ou par le magistrat. L’enquêteur ne peut pas désigner lui-même un adulte approprié.",
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
