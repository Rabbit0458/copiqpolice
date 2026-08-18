import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class TraiteEtresHumainsPage extends StatelessWidget {
  const TraiteEtresHumainsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains';

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
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
            "f00002",
            "Atteintes à la dignité",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
              "f00003",
              "La traite des êtres humains",
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
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00005",
                      "La traite des êtres humains est le fait de recruter une personne, de la transporter, de la transférer, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00006",
                      "de l’héberger ou de l’accueillir à des fins d’exploitation, notamment lorsqu’elle est obtenue par menace, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00007",
                      "contrainte, violence, manœuvre dolosive, abus d’autorité, ou abus d’une situation de vulnérabilité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00008",
                      "ou encore en échange d’une rémunération/avantage (ou promesse).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
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
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00010",
                    "Article 225-4-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00011",
                    " : définit et réprime la traite des êtres humains.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
              "f00012",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00013",
                  "A) Un acte positif envers une personne",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00014",
                  "La traite suppose un acte positif de l’auteur : recruter, transporter, transférer, accueillir ou héberger.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00015",
                  "Recruter : démarches pour convaincre/forcer une personne à être mise à disposition d’un tiers dans un but criminel.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00016",
                  "Transporter : assurer effectivement le déplacement de la victime d’un point à un autre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00017",
                  "Transférer : faire en sorte que le déplacement s’effectue sans intervenir directement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00018",
                  "Accueillir : être présent lors de l’arrivée de la victime ; Héberger : loger la victime.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00019",
                  "B) Une circonstance de commission (pour un majeur)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00020",
                  "À l’égard d’un majeur, la traite est constituée si l’acte est commis dans au moins l’une des circonstances suivantes :",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00021",
                  "1) Menace, contrainte, violence ou manœuvre dolosive",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00022",
                  "Menace / contrainte : moyens visant à supprimer le consentement (violences morales assimilées à des violences physiques).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00023",
                  "Violence : violence physique exercée sur la victime (ou sa famille / proche).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00024",
                  "La menace/la contrainte doit inspirer une crainte sérieuse et immédiate (pour la victime ou un proche).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00025",
                  "Manœuvre dolosive : agissements trompeurs amenant la victime à être abusée (ruse).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00026",
                  "2) Ascendant / autorité / abus d’autorité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00027",
                      "Sont visées les personnes disposant :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00028",
                      "• d’une autorité de droit (ex. tuteur)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00029",
                      "• d’une autorité de fait (permanente ou discontinue) liée aux circonstances\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00030",
                      "• d’une autorité conférée par les fonctions (publiques : professeur… / privées : médecin…).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00031",
                  "3) Abus d’une situation de vulnérabilité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00032",
                      "La vulnérabilité doit être due à des causes limitativement prévues (âge, maladie, infirmité, déficience physique/psychique, grossesse) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00033",
                      "et résulter d’un état préexistant (non créé par l’infraction). Elle doit être apparente ou connue de l’auteur.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00034",
                  "4) Rémunération / avantage / promesse",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00035",
                      "Cette circonstance suppose une forme de négociation : l’échange doit être convenu initialement (avant la remise/mise à disposition). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00036",
                      "La rémunération peut être en numéraire ou en nature. L’avantage doit être tangible. La promesse est une anticipation et n’a pas besoin d’être contractualisée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00037",
                      "Si une « contrepartie » intervient seulement après la remise, l’infraction n’est pas constituée au titre de cette circonstance.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _NotaBox(
                title: "Mineur",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00038",
                      "La traite à l’égard d’un mineur est constituée même si elle n’est commise dans aucune des circonstances 1° à 4°.",
                    ),
                  ),
                  TextSpan(text: " — "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00039",
                      "article 225-4-1 II du Code pénal",
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
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00040",
                  "C) Une mise à disposition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00041",
                      "La victime doit être mise à la disposition de l’auteur ou d’un tiers (même non identifié). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00042",
                      "La mise à disposition est sanctionnée même si elle n’a pas été effectivement réalisée.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00043",
                  "Point clé",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00044",
                      "L’intervention d’un tiers n’est pas nécessaire : la traite peut être retenue si l’auteur agit pour mettre la victime à sa propre disposition.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00045",
                  "D) Un objectif criminel d’exploitation",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00046",
                      "L’exploitation consiste à mettre la victime à disposition afin de permettre notamment : proxénétisme, agressions/atteintes sexuelles, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00047",
                      "réduction en esclavage, travail ou services forcés, servitude, prélèvement d’organe, exploitation de la mendicité, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00048",
                      "conditions de travail/hébergement contraires à la dignité, ou à contraindre la victime à commettre un crime ou un délit.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00049",
                  "Il n’est pas nécessaire que les infractions d’exploitation soient effectivement commises pour que la traite soit constituée.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00050",
                      "Lorsque l’objectif est de contraindre la victime à commettre un crime/délit, la contrainte doit être ressentie comme irrésistible ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00051",
                      "(impossibilité absolue de respecter la loi).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
              "f00052",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00053",
                  "Conscience du devenir de la victime",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00054",
                      "L’infraction étant intentionnelle, il faut établir que l’auteur savait à quoi la victime était destinée : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00055",
                      "il doit connaître les infractions auxquelles elle devait être soumise, ou la contrainte exercée sur elle pour la déterminer à en commettre.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Consentement",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00056",
                      "Cette incrimination ne repose pas sur la notion de consentement : l’existence ou l’absence de consentement de la victime n’a pas à être démontrée.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
              "f00057",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00058",
                  "Traite aggravée délictuelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00059",
                    "Article 225-4-1 II du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00060",
                  "Lorsqu’elle est commise à l’égard d’un mineur, même sans les circonstances 1° à 4°.",
                ),
              ),

              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00061",
                    "Article 225-4-2 I du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00062",
                  "Lorsqu’elle est commise dans deux des circonstances 1° à 4° de l’article 225-4-1 I.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00063",
                      "Ou avec l’une des circonstances supplémentaires : plusieurs victimes ; victime hors du territoire / à l’arrivée ; contact via réseau de communication électronique ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00064",
                      "exposition à un risque immédiat de mort ou de mutilation/infirmité permanente ; violences avec ITT > 8 jours ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00065",
                      "auteur participant par ses fonctions à la lutte contre la traite ou au maintien de l’ordre public ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00066",
                      "victime placée dans une situation matérielle ou psychologique grave.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00067",
                  "Traite aggravée criminelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00068",
                    "Article 225-4-2 II du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00069",
                  "Lorsqu’elle est commise à l’égard d’un mineur + l’une des circonstances de l’article 225-4-1 I ou de l’article 225-4-2 I.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00070",
                    "Article 225-4-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00071",
                    " : bande organisée.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00072",
                    "Article 225-4-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00073",
                    " : tortures ou actes de barbarie.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité + exemption/réduction
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
              "f00074",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00075",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00076",
                    "Simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00077",
                    "7 ans d’emprisonnement et 150 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00078",
                    "article 225-4-1 I du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00079",
                    "Aggravée (mineur) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00080",
                    "10 ans d’emprisonnement et 1 500 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00081",
                    "article 225-4-1 II du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00082",
                    "Aggravée (225-4-2 I) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00083",
                    "10 ans d’emprisonnement et 1 500 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00084",
                    "article 225-4-2 I du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00085",
                    "Criminelle (225-4-2 II) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00086",
                    "15 ans de réclusion et 1 500 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00087",
                    "article 225-4-2 II du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00088",
                    "Bande organisée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00089",
                    "20 ans de réclusion et 3 000 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00090",
                    "article 225-4-3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00091",
                    "Tortures / barbarie : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00092",
                    "réclusion criminelle à perpétuité et 4 500 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00093",
                    "article 225-4-4 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                          "f00094",
                          "Si le crime ou délit commis (ou devant être commis) contre la victime est puni d’une peine privative de liberté supérieure, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                          "f00095",
                          "la traite est punie des peines attachées à ce crime/délit (et à ses circonstances aggravantes connues de l’auteur). ",
                        ),
                  ),
                  TextSpan(text: "— "),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                      "f00096",
                      "article 225-4-5 du Code pénal",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00097",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00098",
                    "Responsabilité prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00099",
                    "l’article 225-4-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00100",
                    " ; amende selon ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00101",
                    "l’article 131-38 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00102",
                    " + peines des ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00103",
                    "articles 131-39, 225-24 et 225-25 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00104",
                    " (dissolution, interdictions, confiscations…).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00105",
                  "Tentative & complicité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00106",
                    "Tentative : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00107",
                    "article 225-4-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00108",
                    "Complicité : OUI — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00109",
                    "articles 121-6 et 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00110",
                    " (aide/assistance, provocation, instructions).",
                  ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                  "f00111",
                  "Exemption & réduction de peine",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00112",
                    "Exemption de peine : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00113",
                    "article 225-4-9 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00114",
                    " (auteur au stade de la tentative qui avertit l’autorité et permet d’éviter la réalisation de l’infraction).",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00115",
                    "Réduction de peine : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                    "f00116",
                    "article 225-4-9 alinéa 2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                        "f00117",
                        " (peine réduite des 2/3 si l’auteur/complice avertit et permet de faire cesser l’infraction, d’éviter une mort/infirmité permanente, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/crime_delit_contre_personne_pages/dignite_personne/traite_etres_humains_page.dart",
                        "f00118",
                        "ou d’identifier les autres auteurs/complices ; perpétuité ramenée à 20 ans).",
                      ),
                ),
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
