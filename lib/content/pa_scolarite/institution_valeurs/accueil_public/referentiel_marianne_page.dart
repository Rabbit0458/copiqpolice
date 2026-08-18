import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaReferentielMariannePage extends StatelessWidget {
  const PaReferentielMariannePage({super.key});

  static const String routeName = '/pa/institution/accueil_public/marianne';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardCharte = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardRef = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMesures = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDelais = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardBonnesPratiques = isDark
        ? const Color(0xFF202633)
        : const Color(0xFFF3F6FF);

    // ✅ Nouvelles cartes ajoutées (Discri / Harcèlement / Victimes)
    final Color cardDiscriIntro = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFEAF2FF);
    final Color cardDiscriDef = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFEFFAF2);
    final Color cardHarcDef = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF0F7);
    final Color cardCellule = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF6E0);
    final Color cardSanctions = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardVictimes = isDark
        ? const Color(0xFF202633)
        : const Color(0xFFF3F6FF);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
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
            "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
            "f00002",
            "Accueil du public",
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
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00003",
              "De la charte d’accueil du public\nau référentiel Marianne",
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
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00004",
              "Idée générale",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00005",
                      "La charte Marianne formalise des engagements simples de qualité d’accueil. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00006",
                      "Le référentiel Marianne prolonge cette logique sous forme de certification, avec des exigences ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00007",
                      "mesurables et un suivi interne.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Charte Marianne
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00008",
              "I — La charte Marianne",
            ),
            cardColor: cardCharte,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00009",
                      "Adoptée par plus de 2 000 services publics, la charte Marianne décline des critères ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00010",
                      "d’engagement garantissant la qualité de l’accueil, qu’il soit physique, par téléphone, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00011",
                      "par courrier ou par courriel.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00012",
                  "Engagements clés",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00013",
                  "Faciliter l’accès des usagers dans les services.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00014",
                  "Accueillir les usagers de manière attentive et courtoise.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00015",
                  "Répondre de manière compréhensible et dans un délai annoncé.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00016",
                  "Traiter systématiquement les réclamations.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00017",
                  "Recueillir les propositions des usagers pour améliorer la qualité du service public.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Référentiel Marianne (certification)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00018",
              "II — Le référentiel Marianne",
            ),
            cardColor: cardRef,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00019",
                      "Dans le prolongement de la charte, le référentiel Marianne est une certification ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00020",
                      "de la qualité de l’accueil, délivrée par un organisme indépendant.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00021",
                      "Il comprend 19 engagements structurés en 6 rubriques : les 5 premières reprennent ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00022",
                      "les critères de la charte et engagent directement les services vis-à-vis des usagers ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00023",
                      "la dernière est dédiée au pilotage et au suivi interne des exigences de qualité.",
                    ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00024",
                  "Dans la Police nationale",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00025",
                          "La charte d’accueil du public et d’assistance aux victimes reste le texte de référence. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00026",
                          "Toutefois, des mesures permettent de répondre aux engagements du référentiel Marianne.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mesures concrètes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00027",
              "Mesures concrètes dans les services de police",
            ),
            cardColor: cardMesures,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00028",
                  "1) Évaluation externe",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00029",
                      "Des « enquêtes mystère » (ou contrôles inopinés) peuvent être diligentées par les services ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00030",
                      "de contrôle du ministère de l’Intérieur (DNSP, IGPN, etc.). Elles prennent la forme ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00031",
                      "d’appels téléphoniques ou de visites à l’accueil des commissariats/bureaux de police.",
                    ),
              ),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00032",
                  "Objectif : obtenir une appréciation extérieure de la qualité de l’accueil dans les services.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Délais du référentiel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00033",
              "Délais de réponse attendus (référentiel)",
            ),
            cardColor: cardDelais,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00034",
                  "Téléphone",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00035",
                  "Prise en charge en moins de 5 sonneries (agent ou serveur vocal interactif).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00036",
                  "Courrier électronique",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00037",
                  "Première réponse sous 5 jours ouvrés : réponse sur le fond OU réponse d’attente indiquant le délai prévisionnel.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00038",
                  "Accusé de réception électronique adressé systématiquement suite à toute sollicitation.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00039",
                  "Courrier postal",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00040",
                  "Traitement sous 15 jours ouvrés (si délai non tenu : réponse d’attente indiquant le délai prévisionnel).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bonnes pratiques / adaptation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00041",
              "Exigences de qualité (attitude & accessibilité)",
            ),
            cardColor: cardBonnesPratiques,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00042",
                      "Les agents doivent être sensibilisés à l’accueil des personnes en difficulté ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00043",
                      "(handicap, âge, état d’anxiété, non-maîtrise de la langue française…) et adapter ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00044",
                      "leur comportement selon la difficulté perçue.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00045",
                  "Points de vigilance",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00046",
                  "Adapter le langage : réponses compréhensibles et accessibles au destinataire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00047",
                  "Mentionner les références de l’agent chargé du dossier (quand c’est prévu/possible).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00048",
                  "Faciliter l’accomplissement des démarches pour les personnes à mobilité réduite.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Récap express
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00049",
              "Synthèse (mémo rapide)",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00050",
                  "Charte Marianne : engagements de qualité d’accueil (physique, téléphone, courrier, e-mail).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00051",
                  "Référentiel Marianne : certification indépendante + exigences mesurables + suivi interne.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00052",
                  "Police : la charte accueil du public/victimes reste la référence, mais des mesures permettent d’atteindre les engagements du référentiel.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // /////////////////////////////////////////////////////////////////////////////
          // //////////////////////  AJOUT — DISCRIMINATION / HARCELEMENT  //////////////
          // /////////////////////////////////////////////////////////////////////////////
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00053",
              "Discrimination & harcèlement : en parler, c’est agir",
            ),
            cardColor: cardDiscriIntro,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00054",
                      "Ces supports institutionnels rappellent les définitions, les démarches possibles ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00055",
                      "et les dispositifs d’écoute et de signalement du ministère de l’Intérieur.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Source",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00056",
                      "Affiches et flyers (kit graphique) — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00057",
                      "egalite-diversite.interieur.ader.gouv.fr",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00058",
                  "Référence",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00059",
                      "INSTITUTIONS ET VALEURS / Retour Sommaire 130 — Mis à jour le 13/03/2025.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Témoins : que faire ?
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00060",
              "Vous êtes témoin direct",
            ),
            cardColor: cardBonnesPratiques,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00061",
                  "Si vous êtes témoin direct d’une situation de discrimination sur votre lieu de travail, vous pouvez :",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00062",
                  "Rendre compte à votre hiérarchie.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00063",
                  "Signaler les faits aux interlocuteurs mentionnés (cellules d’écoute), si toute démarche auprès de votre hiérarchie a été rejetée et en l’absence d’initiative de la part de la victime.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Auteurs : sanctions
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00064",
              "Vous êtes auteur : sanctions possibles",
            ),
            cardColor: cardSanctions,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00065",
                  "Sanctions pénales",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00066",
                  "Discrimination : 3 ans d’emprisonnement et 45 000 € d’amende.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00067",
                  "Harcèlement moral : 2 ans de prison et 30 000 € d’amende.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00068",
                  "Harcèlement sexuel : 2 à 3 ans de prison et 30 000 € à 45 000 € d’amende.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00069",
                  "Sanctions disciplinaires",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00070",
                  "Après étude du dossier et selon la gravité : jusqu’à la radiation des cadres ou la révocation.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00071",
                  "Mesures administratives",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00072",
                  "Suspension de fonction.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00073",
                  "Mutation dans l’intérêt du service.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00074",
                      "Référence document : @SICoP/2017.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Cellule d'écoute : définition + phases
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00075",
              "Qu’est-ce qu’une cellule d’écoute et de signalement ?",
            ),
            cardColor: cardCellule,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00076",
                      "Communément appelés « cellules d’écoute », les dispositifs d’alerte et de signalement ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00077",
                      "ont pour vocation d’écouter, analyser la situation et aider les agents à trouver une solution ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00078",
                      "pour mettre fin aux pratiques discriminatoires et de harcèlement.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00079",
                  "Les 4 phases du traitement",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00080",
                  "Recueil du signalement du déclarant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00081",
                  "Entretien individuel avec le déclarant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00082",
                  "Traitement par l’administration.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00083",
                  "Clôture du signalement.",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00084",
                  "Confidentialité",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00085",
                          "Soumises à des obligations de confidentialité et d’impartialité, les cellules peuvent être saisies par tout agent, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00086",
                          "victime ou témoin (discrimination ou harcèlement moral/sexuel).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00087",
                  "Signalement anonyme",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00088",
                          "Les signalements anonymes (ou par un tiers) sont possibles, mais le traitement ne sera poursuivi ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00089",
                          "qu’avec l’accord de l’agent concerné.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définitions : discrimination / harcèlement
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00090",
              "Définitions essentielles",
            ),
            cardColor: cardDiscriDef,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00091",
                  "Qu’est-ce qu’une discrimination ?",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00092",
                  "C’est un traitement défavorable appliqué à une personne :",
                ),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00093",
                  "Sur un des critères interdits par la loi (origine, sexe, orientation sexuelle, handicap, lieu de résidence… etc.).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00094",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00095",
                    "article 225-1 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00096",
                    " (énonce les critères de distinction constitutifs d’une discrimination).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00097",
                  "Dans un domaine spécifié par la loi (ex. accès à l’emploi, sanctions disciplinaires, relations fournisseurs, etc.).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00098",
                  "À retenir",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00099",
                          "Certaines différences de traitement sont prévues par la loi et ne constituent pas une discrimination ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00100",
                          "(ex. critère objectif de sélection pour un avancement).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00101",
                  "Qu’est-ce que le harcèlement ?",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00102",
                    "Harcèlement moral : ",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00103",
                    "Article 222-33-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00104",
                    "article 6 quinquies de la loi n°83-634",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                        "f00105",
                        " : propos ou comportements répétés ayant pour objet/effet une dégradation des conditions de travail ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                        "f00106",
                        "susceptible de porter atteinte aux droits et à la dignité, d’altérer la santé, ou de compromettre l’avenir professionnel.",
                      ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00107",
                    "Harcèlement sexuel : ",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00108",
                    "article 222-33 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00109",
                    "article 6 ter de la loi n°83-634",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                        "f00110",
                        " : imposer de façon répétée des propos/comportements à connotation sexuelle ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                        "f00111",
                        "portant atteinte à la dignité (dégradant/humiliant) ou créant une situation intimidante, hostile ou offensante. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                        "f00112",
                        "Peut aussi être constitué par une pression grave, même non répétée, pour obtenir un acte de nature sexuelle.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Que faire + cellules
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00113",
              "Que faire en cas de discrimination ou de harcèlement ?",
            ),
            cardColor: cardHarcDef,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00114",
                  "Premiers réflexes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00115",
                  "Solliciter un entretien avec sa hiérarchie de proximité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00116",
                  "Saisir un référent de proximité : référent RH local, assistant de prévention, référent diversité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00117",
                  "Demander un rendez-vous à l’assistant de service social ou au médecin de prévention.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00118",
                  "Contacter une cellule d’écoute",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00119",
                  "SIGNAL-DISCRI (Police nationale) : mail igpn-signal-discri@interieur.gouv.fr — tél. 01 86 21 55 55 — courrier IGPN, place Beauvau, 75800 Paris Cedex 08.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00120",
                  "ALLO-DISCRI (Secrétariat général) : mail cellule-allo-discri@interieur.gouv.fr — tél. 01 80 15 33 00 — courrier Ministère de l’Intérieur, Place Beauvau, 75800 Paris Cedex 08.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00121",
                  "STOP DISCRI (Gendarmerie nationale) : mail alerte-signalement@gendarmerie.interieur.gouv.fr — tél. 01 84 22 15 67 — courrier IGGN, 1 boulevard Henri Barbusse, 92240 Malakoff.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Victimes violences sexistes/sexuelles (fiche)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
              "f00122",
              "Victime de violences sexistes et sexuelles",
            ),
            cardColor: cardVictimes,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00123",
                      "Une violence sexuelle peut être : un acte sexuel (avec ou sans pénétration) commis ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00124",
                      "avec violence, contrainte, menace ou surprise, donc sans consentement. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                      "f00125",
                      "Aucune tenue, parole ou comportement (même sous alcool) ne justifie ces violences.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00126",
                  "Déposer plainte (24h/24 – 7j/7)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00127",
                    "Les policiers ou gendarmes sont tenus de recevoir toutes les plaintes (",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                    "f00128",
                    "article 15-3 du Code de procédure pénale",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ")."),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00129",
                  "Urgences & contacts essentiels",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00130",
                  "En danger : 17 (Police/Gendarmerie).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00131",
                  "Depuis un portable : 112.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00132",
                  "Pour personnes sourdes/malentendantes/muettes : 114.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00133",
                  "Sapeurs-pompiers : 18.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00134",
                  "Urgences médicales : 15.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00135",
                  "Portail en ligne (tchat)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00136",
                  "Signalement violences sexuelles et sexistes : 7j/7 24h/24 (service-public.fr / signalement-violences-sexuelles-sexistes.gouv.fr).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00137",
                  "Numéro d’écoute",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                  "f00138",
                  "3919 : violences femmes info (appel gratuit et anonyme).",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00139",
                          "Dans la procédure pénale, des mesures de protection peuvent être mises en place et la victime peut demander réparation ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/referentiel_marianne_page.dart",
                          "f00140",
                          "en se constituant partie civile.",
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
