import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaAtteinteSecretCorrespondancesParticulierPage extends StatelessWidget {
  const PaAtteinteSecretCorrespondancesParticulierPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/atteintes_personnes/atteinte_personnalite/atteinte_secret_correspondances_particulier';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
            "f00002",
            "Atteinte à la personnalité",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
              "f00003",
              "L’atteinte au secret des correspondances\ncommise par un particulier",
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
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00005",
                      "Le fait, commis de mauvaise foi, d’ouvrir, de supprimer, de retarder ou de détourner ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00006",
                      "des correspondances arrivées ou non à destination et adressées à des tiers, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00007",
                      "ou d’en prendre frauduleusement connaissance, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
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
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00009",
                    "Article 226-15 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00010",
                    " : définit et réprime l’atteinte au secret des correspondances commise par un particulier.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
              "f00011",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00012",
                  "A) L’objet de l’atteinte",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00013",
                  "• Une correspondance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00014",
                      "La loi ne définit pas la notion de « correspondance ». La jurisprudence considère ce terme ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00015",
                      "comme un synonyme de « message », quel qu’en soit le support, dès lors que ce message a vocation à circuler. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00016",
                      "Sont donc considérés comme correspondances : courrier, lettre, carte postale, télégramme, etc.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00017",
                  "La nature de la correspondance importe peu : elle peut être privée ou professionnelle.",
                ),
              ),

              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00018",
                  "• À destination d’un tiers",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00019",
                  "L’auteur doit s’en prendre à un message adressé à autrui : on ne viole pas le secret de sa propre correspondance.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00020",
                  "Le mode d’acheminement est indifférent (La Poste, coursier, etc.).",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00021",
                    "Article 226-15 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                        "f00022",
                        " précise que les correspondances peuvent être « arrivées ou non à destination » : l’atteinte peut se produire ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                        "f00023",
                        "alors que la correspondance n’est pas encore ou n’est plus acheminée.",
                      ),
                ),
              ]),
              SizedBox(height: 12),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                          "f00024",
                          "Pour les juges du fond, il suffit que le pli litigieux ait été, lors de son ouverture, en voie d’acheminement ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                          "f00025",
                          "(l’expéditeur s’en était dessaisi et il n’était pas encore parvenu à son destinataire).",
                        ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00026",
                  "B) Un acte matériel d’atteinte",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00027",
                    "Article 226-15 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                        "f00028",
                        " vise plusieurs comportements : ouvrir, supprimer, retarder, détourner une correspondance, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                        "f00029",
                        "ou prendre frauduleusement connaissance de son contenu.",
                      ),
                ),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00030",
                  "• Ouvrir une correspondance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00031",
                      "Cela consiste à violer la fermeture quelconque d’une correspondance. Est sanctionné tout acte portant atteinte ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00032",
                      "à l’intégrité du support et donnant accès au contenu, quel que soit le moyen utilisé : violent (déchirer) ou plus subtil ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00033",
                      "(décacheter à la vapeur).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00034",
                  "L’altération peut être totale ou partielle. Peu importe que la correspondance ait été ensuite renvoyée vers son destinataire.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00035",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00036",
                      "Un gérant d’immeuble puni pour avoir ouvert un courrier adressé à une locataire avant de lui distribuer ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00037",
                      "(C.A. Toulouse, 13 janvier 2000)",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00038",
                  "• Supprimer une correspondance",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00039",
                    "La jurisprudence définit la suppression comme « tout acte qui a pour effet d’empêcher qu’elle parvienne à destination » ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00040",
                    "(Cass. crim., 23 novembre 1849)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00041",
                  "Cela peut consister en une mise au rebut, une destruction, ou même une conservation empêchant la remise.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00042",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00043",
                      "Une secrétaire de mairie qui avait jeté à la poubelle, après l’avoir lue, une lettre envoyée au maire ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00044",
                      "(C.A. Paris, 09 janvier 1996)",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00045",
                  "• Retarder une correspondance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00046",
                      "Retarder consiste à faire arriver plus tard qu’il ne faut, après le moment fixé ou attendu. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00047",
                      "L’acte se concrétise par le fait de retenir un message en interrompant le cours normal de son acheminement.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Jurisprudences",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00048",
                      "Un individu qui réexpédie une lettre avec la mention « inconnu » ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00049",
                      "(C.A. Paris, 08 octobre 1957)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00050",
                      "Le propriétaire d’un immeuble qui réexpédie le courrier de sa locataire à une boîte postale ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00051",
                      "(Cass. crim., 09 février 1965)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: ".\n"),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00052",
                      "Le gardien d’un immeuble qui refuse de délivrer le courrier à la destinataire et le remet au préposé des postes ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00053",
                      "(C.A. Aix-en-Provence, 26 janvier 1998)",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00054",
                  "• Détourner une correspondance",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00055",
                      "Le détournement se matérialise en modifiant le cours normal de la transmission : on réprime un retard ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00056",
                      "infligé volontairement à la transmission de la correspondance.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00057",
                  "Jurisprudence",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                          "f00058",
                          "Condamné pour détournement : un secrétaire de mairie conserve une lettre anonyme adressée à une employée ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                          "f00059",
                          "plus de deux mois avant remise à la destinataire ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00060",
                      "(C.A. Aix-en-Provence, 17 mars 2003)",
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
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00061",
                  "• Prendre frauduleusement connaissance du contenu",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00062",
                    "C’est le dernier cas prévu par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00063",
                    "l’article 226-15 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                        "f00064",
                        ". C’est celui qui caractérise le mieux l’atteinte au secret : il peut être sanctionné de façon autonome, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                        "f00065",
                        "même si, en pratique, il est souvent consécutif à une ouverture, un retard ou un détournement.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00066",
                      "Dans certaines situations, une personne peut prendre connaissance frauduleusement du contenu d’une correspondance ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00067",
                      "sans avoir elle-même commis les actes d’ouverture/suppression/retard/détournement.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
              "f00068",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00069",
                  "Mauvaise foi (élément intentionnel)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00070",
                      "L’auteur doit agir en toute connaissance de cause : il sait que la correspondance ne lui était pas destinée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00071",
                      "et porte volontairement atteinte à sa transmission ou à son secret.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                          "f00072",
                          "La Cour de cassation définit la « mauvaise foi » comme la connaissance que les lettres ne lui étaient pas destinées ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                          "f00073",
                          "et le fait de les conserver volontairement pour empêcher ou retarder leur transmission ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00074",
                      "(Cass. crim., 15 mai 1990)",
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
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00075",
                      "Détourner ou ouvrir une correspondance d’autrui par erreur ne constitue pas l’infraction : il s’agit d’une simple négligence ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                      "f00076",
                      "ou imprudence (l’intention coupable fait défaut).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00077",
                  "L’intention de nuire n’est pas exigée. Le mobile importe peu.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
              "f00078",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00079",
                    "Article 226-15 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00080",
                  "Lorsque les faits sont commis par le conjoint, le concubin ou le partenaire lié à la victime par un pacte civil de solidarité (PACS).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
              "f00081",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00082",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00083",
                    "Qualification simple : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00084",
                    "1 an d’emprisonnement et 45 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00085",
                    "article 226-15 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00086",
                    "Qualification aggravée : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00087",
                    "2 ans d’emprisonnement et 60 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00088",
                    "article 226-15 alinéa 3 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00089",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00090",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00091",
                    "l’article 121-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00092",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00093",
                  "Tentative : NON (non prévue / non punissable).",
                ),
              ),
              SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00094",
                    "Complicité : OUI — conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00095",
                    "l’article 121-6 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                    "f00096",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/atteintes_personnes_pages/atteinte_personnalite/atteinte_secret_correspondances_particulier.dart",
                  "f00097",
                  "Elle suppose un des faits constitutifs de complicité prévus par la loi : aide et assistance, provocation ou instructions données.",
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
