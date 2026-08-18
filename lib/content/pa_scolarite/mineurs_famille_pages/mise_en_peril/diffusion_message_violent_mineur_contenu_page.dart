import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaDiffusionMessageViolentMineurPage extends StatelessWidget {
  const PaDiffusionMessageViolentMineurPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur';

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
            "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
            "f00002",
            "Mise en péril",
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
              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
              "f00003",
              "La diffusion d’un message violent / terroriste / pornographique ou dangereux susceptible d’être vu ou perçu par un mineur",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20.5,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00005",
                      "Le fait soit de fabriquer, de transporter, de diffuser par quelque moyen que ce soit et quel qu’en soit le support ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00006",
                      "un message à caractère violent, incitant au terrorisme, pornographique (y compris des images pornographiques impliquant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00007",
                      "un ou plusieurs animaux), ou de nature à porter gravement atteinte à la dignité humaine, ou à inciter des mineurs à se livrer ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00008",
                      "à des jeux les mettant physiquement en danger, soit de faire commerce d’un tel message, lorsque ce message est susceptible ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00009",
                      "d’être vu ou perçu par un mineur, constitue une infraction.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
              "f00010",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00011",
                    "Article 227-24 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00012",
                    " : prévoit et réprime la diffusion de ce type de message lorsqu’il est susceptible d’être vu ou perçu par un mineur.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (3 éléments pédagogiques + actes incriminés)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
              "f00013",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00014",
                  "A) Un message (notion large)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00015",
                      "Le terme « message » s’entend au sens le plus large : il peut s’agir d’une communication au sens strict ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00016",
                      "(lettre, appel, message, etc.) mais aussi d’un contenu transmis par une œuvre (fiction, peinture, représentation, etc.).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00017",
                    "Le support est indifférent : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00018",
                    "la loi vise la diffusion « par quelque moyen que ce soit et quel qu’en soit le support » (écrits, œuvres audio/vidéo, représentations matérielles, productions télématiques, etc.). — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00019",
                    "article 227-24 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00020",
                  "B) Le caractère du message",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00021",
                      "Le message doit présenter l’un des caractères suivants : violent, incitant au terrorisme, pornographique ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00022",
                      "(y compris des images pornographiques impliquant un ou plusieurs animaux), portant gravement atteinte à la dignité humaine, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00023",
                      "ou incitant les mineurs à se livrer à des jeux les mettant physiquement en danger.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00024",
                      "Ces notions peuvent viser des actes dégradants ou d’une grande violence, susceptibles de provoquer des effets traumatisants ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00025",
                      "sur la jeunesse.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Exemple",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00026",
                      "Sont notamment visées des pratiques comme le « jeu du foulard » : compétition consistant à résister le plus longtemps possible à une strangulation.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00027",
                  "C) Les actes incriminés",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00028",
                    "Sont réprimés : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00029",
                    "la fabrication, le transport, la diffusion, ou le commerce d’un tel message. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00030",
                    "article 227-24 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00031",
                      "Ces actes visent tous ceux qui interviennent dans l’exploitation des messages interdits : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00032",
                      "fabrication, diffusion, ou profit. Le commerce peut inclure les financeurs en amont et les bénéficiaires en aval, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00033",
                      "même s’ils n’ont pas participé matériellement à la diffusion.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00034",
                  "D) Un mineur susceptible de voir / percevoir le message",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00035",
                      "L’infraction est constituée dès lors que le message est « susceptible d’être vu ou perçu par un mineur ». ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00036",
                      "Il n’est pas nécessaire qu’un mineur (ou même le public) ait effectivement été atteint par le message.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00037",
                      "La diffusion sciemment réalisée est sanctionnée, mais aussi l’imprudence ou la négligence ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00038",
                      "permettant l’accès des mineurs à des messages réservés aux majeurs (absence de précautions suffisantes).",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00039",
                      "L’infraction peut être constituée même si l’accès du mineur résulte d’une simple déclaration de celui-ci ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00040",
                      "affirmant avoir au moins 18 ans.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
              "f00041",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00042",
                  "Conscience de la possible diffusion à des mineurs",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00043",
                  "L’élément moral est caractérisé dès lors que l’auteur a conscience que le message est susceptible d’être vu ou perçu par un mineur.",
                ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00044",
                      "Il est réalisé si la diffusion est délibérément effectuée à destination de mineurs, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00045",
                      "mais aussi lorsque l’accès des mineurs résulte d’un manque de précautions suffisantes.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
              "f00046",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00047",
                  "Aucune circonstance aggravante prévue.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
              "f00048",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00049",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00050",
                    "Délit — qualification simple : ",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00051",
                    "3 ans d’emprisonnement et 75 000 € d’amende — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00052",
                    "article 227-24 alinéa 1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00053",
                      "Lorsque le délit est commis par voie de presse écrite/audiovisuelle ou communication au public en ligne, des règles spécifiques déterminent les responsables : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00054",
                      "article 227-24 alinéa 2 du Code pénal",
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
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00055",
                      "Lorsque l’infraction est commise à l’étranger par un Français (ou une personne résidant habituellement en France), la loi française peut s’appliquer même sans plainte ni dénonciation : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                      "f00056",
                      "article 227-27-1 du Code pénal",
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
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00057",
                  "Personnes morales",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00058",
                    "Responsabilité pénale prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00059",
                    "l’article 227-28-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00060",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                  "f00061",
                  "Tentative : NON (non punissable).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00062",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00063",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/mise_en_peril/diffusion_message_violent_mineur_contenu_page.dart",
                    "f00064",
                    " (aide/assistance, provocation, instructions).",
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
