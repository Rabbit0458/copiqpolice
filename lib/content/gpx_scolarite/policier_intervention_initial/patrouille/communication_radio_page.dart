import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CommunicationRadioPage extends StatelessWidget {
  const CommunicationRadioPage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/communication-radio';

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
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          "Patrouille",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00002",
              "La communication radioélectrique",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Introduction + finalité
          _ConditionCard(
            title: "Objectif",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00003",
                      "La « radio » est le mode de communication opérationnel entre les agents du terrain, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00004",
                      "le commandement et le Centre d’Information et de Commandement (C.I.C.).\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00005",
                      "Le policier applique strictement les règles de procédure radio : ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00006",
                      "les messages doivent être brefs, concis, clairs et à caractère opérationnel.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "PRINCIPE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00007",
                      "Ce qui fait une bonne radio : information utile + formulation courte + vocabulaire standardisé.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Règles
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00008",
              "I — Les règles à respecter",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00009",
                  "Avant et pendant l’émission",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00010",
                  "S’assurer avant la mission du bon fonctionnement des appareils radio.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00011",
                  "Avant tout appel, vérifier que le réseau est libre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00012",
                  "Après avoir appuyé sur la touche d’émission, attendre ~1 seconde avant de parler (activation des circuits).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00013",
                  "Contenu du message",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00014",
                  "Annoncer son indicatif radio et le motif (intervention / demande / information).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00015",
                  "Parler calmement et distinctement, micro légèrement éloigné (éviter souffle et chuintements).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00016",
                  "Utiliser le code phonétique international pour épeler noms, prénoms et lettres (ex : plaque d’immatriculation).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00017",
                  "Confidentialité et discipline radio",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00018",
                  "Communiquer à l’écart des personnes concernées (confidentialité des réponses).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00019",
                  "Ne jamais citer le nom des policiers ou autorités : utiliser uniquement l’indicatif radio du véhicule ou de la station.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00020",
                  "Supprimer les communications inutiles : messages brefs et nécessaires uniquement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00021",
                  "Si une station ne peut pas écouter en permanence : signaler le retrait du réseau, puis le retour.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Procédure radiotéléphonique
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00022",
              "II — Termes de procédure radiotéléphonique",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00023",
                  "Pour éviter les malentendus, certains termes standard doivent être utilisés.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00024",
                  "Termes essentiels",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00025",
                  "« Parlez » / « Transmettez »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00026",
                  "« Comment me recevez-vous ? »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00027",
                  "« Je vous reçois fort et clair »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00028",
                  "« Attente »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00029",
                  "« Correction » / « Répétez »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00030",
                  "« J’épelle »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00031",
                  "« Je décompose »",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "COLLATIONNEZ",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00032",
                      "Le collationnement consiste à répéter totalement ou partiellement une communication reçue, afin de vérifier qu’elle a été comprise et reçue correctement.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00033",
                  "Fin de transmission",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00034",
                  "« Correct »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00035",
                  "« Reçu »",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00036",
                  "« Terminé »",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Code phonétique international
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00037",
              "Code phonétique international",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00038",
                      "Les noms propres, groupes de lettres, mots importants ou pouvant prêter à confusion ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00039",
                      "sont épelés selon le tableau d’analogie phonétique. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00040",
                      "Les chiffres sont « décomposés » selon une formulation standard.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00041",
                  "A) Énoncé des lettres (exemples clés)",
                ),
              ),
              _NotaBox(
                title: "LETTRES",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00042",
                      "A Alpha — B Bravo — C Charlie — D Delta\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00043",
                      "E Écho — F Fox-trot — G Golf — H Hôtel\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00044",
                      "I India — J Juliette — K Kilo — L Lima\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00045",
                      "M Mike — N November — O Oscar — P Papa\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00046",
                      "Q Québec — R Roméo — S Sierra — T Tango\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00047",
                      "U Uniform — V Victor — W Whisky — X X-Ray\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00048",
                      "Y Yankee — Z Zoulou",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "EXEMPLE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00049",
                      "PARIS, j’épelle : « Papa » — « Alpha » — « Roméo » — « India » — « Sierra ».",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00050",
                  "B) Énoncé des chiffres",
                ),
              ),
              _NotaBox(
                title: "CHIFFRES",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00051",
                      "0 Zéro\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00052",
                      "1 Un tout seul\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00053",
                      "2 Un et un\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00054",
                      "3 Deux et un\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00055",
                      "4 Deux fois deux\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00056",
                      "5 Trois et deux\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00057",
                      "6 Deux fois trois\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00058",
                      "7 Quatre et trois\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00059",
                      "8 Deux fois quatre\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00060",
                      "9 Cinq et quatre",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Indicatifs radio (structure + catégories)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00061",
              "III — Les indicatifs radio",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00062",
                  "A) Principes généraux",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00063",
                      "Les indicatifs sont composés de lettres et de chiffres permettant d’identifier ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00064",
                      "le personnel, l’équipage ou la station, ainsi que le service et le département.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00065",
                      "En pratique :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00066",
                      "• En interne : indicatif « court » (identification adaptée au département)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00067",
                      "• Hors département : indicatif « long » (incluant le numéro de département)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00068",
                      "• Une lettre peut identifier le rang ou la station.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00069",
                  "RÉFLEXE",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00070",
                      "Tu dois être capable de donner ton indicatif + motif + localisation précise en une phrase courte.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Stations fixes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00071",
              "B) Indicatifs des stations fixes (C.I.C.)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00072",
                  "Les Centres d’Information et de Commandement (C.I.C.) ont pour indicatif : TN.",
                ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00073",
                  "CIC DDPN : TN + numéro de département (ex : TN92).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00074",
                  "Circonscriptions (selon organisation DDPN)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00075",
                  "Si DDPN ≤ 4 circonscriptions : TN 100 / 200 / 300 / 400 ; commissariats de secteur : TN 110, TN 120…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00076",
                  "Si DDPN 5 à 8 circonscriptions (avec divisions) : TN 100, 150, 200, 250, 300, 350, 400, 450 ; divisions en dizaines (ex : TN 110, TN 120…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00077",
                  "Si DDPN > 8 circonscriptions : incrémentation de 50 en 50 ; divisions/secteurs : TN 100 à TN 140 et TN 160 à TN 190.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "EXEMPLE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00078",
                      "CSP Marseille : TN 100 ; Division Marseille centre : TN 110 ; Division Marseille Nord : TN 120 ; CSP Aubagne : TN 140.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Autorités (centrales/zonales/départementales/locales)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00079",
              "C) Indicatifs des autorités",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00080",
                  "Autorités centrales",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00081",
                  "DNSP : JURA — adjoint : JURA Alpha — adjoint renseignement : JURA Bravo — chef d’État-Major : JURA Charlie.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00082",
                  "Autorités zonales",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00083",
                  "Directeur zonal : TI + numéro de zone.",
                ),
              ),
              _NotaBox(
                title: "ZONES",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00084",
                      "TI 2000 : Nord\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00085",
                      "TI 3000 : Est\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00086",
                      "TI 4000 : Sud-Est\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00087",
                      "TI 5000 : Sud\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00088",
                      "TI 6000 : Sud-Ouest\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00089",
                      "TI 7000 : Ouest",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00090",
                  "Autorités départementales",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00091",
                  "DDPN : TI + numéro du département ; DDPN adjoint : ajouter « A » (ex : TI 63, TI 63 A).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00092",
                  "Autorités locales (grades — repères)",
                ),
              ),
              _NotaBox(
                title: "GRADES",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                          "f00093",
                          "Commissaire (chef) : TI + numéro du service (ex : TI 100). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                          "f00094",
                          "Lettre A pour l’adjoint, S pour stagiaire.\n\n",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00095",
                      "Commandant chef de service : TX\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00096",
                      "Commandant : TK\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00097",
                      "Capitaine : TO\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00098",
                      "Lieutenant : TL\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00099",
                      "Lieutenant stagiaire : TL S\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00100",
                      "Major : TJ\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00101",
                      "Brigadier-chef : TR\n\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00102",
                      "Ex : TL 100 S (lieutenant stagiaire) ; TJ 200 BAC (major BAC circonscription 200).",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Services
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00103",
              "D) Indicatifs des services (exemples)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00104",
                      "Les unités correspondent souvent à des secteurs. Des lettres peuvent préciser le régime de travail.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00105",
                      "• Régime cyclique : A à D\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00106",
                      "• Régime hebdomadaire : E à H",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "EXEMPLES",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00107",
                      "Cyclique : GAJ 110 A, GAJ 120 B…\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00108",
                      "Hebdomadaire : GAJ 130 E…\n\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00109",
                      "Voie publique (circonscription 100) :\n",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00110",
                      "• TI SVP 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00111",
                      "• PS 100 (police secours)\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00112",
                      "• UAO 100 (appui opérationnel)\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00113",
                      "• BAC 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00114",
                      "• GSP 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00115",
                      "• UOP 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00116",
                      "• BAAJ 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00117",
                      "• CYNO 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00118",
                      "• TM 100 (motocycliste)\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00119",
                      "• BSR 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00120",
                      "• STC 100\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00121",
                      "• BE 100 (équestre)\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00122",
                      "• BN 100 (nautique)\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00123",
                      "• SIR 100\n",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00124",
                      "Services départementaux :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00125",
                      "• 600 : renseignement territorial\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00126",
                      "• 700 : SOPS (ex : CDI 710, BAC D 720, sécurité routière 730, FMUD 740, cynophile 750…)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00127",
                      "• 800 : sûreté départementale/urbaine (ex : GAJ 820, UPTS 890…)\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00128",
                      "• 900 : services centraux DDPN (ex : état-major 900, commandement de nuit 902…).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Véhicules + piétons
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00129",
              "E) Véhicules & piétons",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00130",
                  "Véhicules (lettres repères)",
                ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00131",
                  "VÉHICULES",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00132",
                      "Fourgon de patrouille : TC\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00133",
                      "Voiture légère : TV\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00134",
                      "Motocyclette : TM\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00135",
                      "Scooter : TSC\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00136",
                      "VTT : TT\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00137",
                      "Transport équestre : TCH\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00138",
                      "Véhicule BAC : BAC\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00139",
                      "Véhicule BST : BST\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00140",
                      "GSP : GSP\n\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00141",
                      "Ex : TV 111 A — TC 310 A — BAC 112 B — TM 122 C…",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00142",
                  "Piétons (points fixes / déplacements à pied)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00143",
                  "Point particulier : TP + numéro défini par le dispositif (ex : TP 1, TP 2…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00144",
                  "Passager d’un véhicule se déplaçant à pied : TP + indicatif du véhicule (ex : TP BAC 220).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00145",
                  "Garde statique : TG + chiffres du service (+ lettre rang si besoin) (ex : TG 110 A).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Personnalités de l'État
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00146",
              "F) Principales personnalités de l’État (repères)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _NotaBox(
                title: "INDICATIFS",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00147",
                      "Présidence de la République : VEGA\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00148",
                      "Président du Sénat : SENEQUE\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00149",
                      "Président de l’Assemblée Nationale : ANTARES\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00150",
                      "Premier Ministre : MEROVEE\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00151",
                      "Ministre de l’Intérieur : AMIENS\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00152",
                      "Ministre de la Justice : MERCURE\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00153",
                      "Ministre des Affaires étrangères : CRATER\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00154",
                      "Ministre de l’Économie : RIGEL\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00155",
                      "Ministre de l’Éducation nationale : GERMINY\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00156",
                      "Ministre de la Défense : MISAR\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00157",
                      "Préfet : ARAMIS\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00158",
                      "Sous-Préfet : BAZIN",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "NOTE",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00159",
                      "Dans l’usage opérationnel, l’essentiel est de savoir reconnaître ces indicatifs et d’éviter toute confusion d’interlocuteur.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse opérationnelle (ultra utile)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
              "f00160",
              "Synthèse opérationnelle (à retenir)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00161",
                  "Le triptyque radio",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00162",
                  "Indicatif — Motif — Localisation précise.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00163",
                  "Les erreurs à éviter",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00164",
                  "Parler trop vite / trop long / sans vérifier que le réseau est libre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00165",
                  "Citer des noms (policiers/autorités) au lieu des indicatifs.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00166",
                  "Transmettre devant la personne concernée (confidentialité).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                  "f00167",
                  "Oublier d’annoncer retrait/retour quand l’écoute permanente est impossible.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "OBJECTIF",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/communication_radio_page.dart",
                      "f00168",
                      "Être compris du premier coup, sans ambiguïté, en restant discret et opérationnel.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
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
