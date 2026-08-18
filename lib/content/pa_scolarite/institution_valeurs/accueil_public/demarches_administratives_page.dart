import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaDemarchesAdministrativesPage extends StatelessWidget {
  const PaDemarchesAdministrativesPage({super.key});

  static const String routeName = '/pa/institution/accueil_public/demarches';

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
    final Color cardCni = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMineur = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardPermis = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardEtatCivil = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardVote = isDark
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
            "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
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
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00003",
              "Quelques démarches administratives",
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
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00004",
              "But de la fiche",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00005",
                      "Cette page regroupe des repères pratiques (CNI, sortie de territoire du mineur, permis, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00006",
                      "passeport, état civil, livret de famille, nationalité, procuration de vote). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00007",
                      "Objectif : orienter rapidement le public et sécuriser les démarches.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — CNI
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00008",
              "I — Carte Nationale d’Identité (CNI)",
            ),
            cardColor: cardCni,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00009",
                      "La carte nationale d’identité est délivrée gratuitement. Elle n’est pas obligatoire. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00010",
                      "Même périmée, elle peut justifier l’identité d’un Français tant que la photo est ressemblante. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00011",
                      "En cours de validité, elle permet l’entrée dans certains pays sans passeport (selon règles du pays).",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00012",
                  "Durée de validité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00013",
                  "CNI sécurisée : 15 ans (majeurs) / 10 ans (mineurs).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00014",
                  "Nouvelle CNI électronique (format carte bancaire) : 10 ans (majeurs et mineurs).",
                ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                          "f00015",
                          "La prolongation de 10 à 15 ans est automatique pour certaines CNI sécurisées (délivrées entre 2004 et 2013 pour des majeurs). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                          "f00016",
                          "La date sur le titre n’est pas modifiée. ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                          "f00017",
                          "Vérifier les pays acceptant l’extension de validité (diplomatie).",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00018",
                  "Où la demander ?",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00019",
                  "Dans n’importe quelle mairie équipée d’une station d’enregistrement (pas lié au domicile).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00020",
                  "Liste des mairies disponibles sur service-public.fr.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00021",
                  "Comment la faire établir ?",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00022",
                  "Pré-demande possible en ligne via ants.gouv.fr.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00023",
                  "Présence du demandeur indispensable (prise d’empreintes).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00024",
                  "Cas particuliers",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00025",
                  "Mineurs : l’enfant + le responsable légal doivent être présents. Le responsable présente sa propre pièce d’identité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00026",
                  "Parents séparés/divorcés : jugement utile uniquement si résidence alternée (inscrire 2 adresses).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00027",
                  "Perte / vol",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00028",
                  "Vol : déclaration préalable en commissariat/gendarmerie (ou autorités locales + consulat à l’étranger) contre récépissé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00029",
                  "Perte : si renouvellement immédiat, déclaration faite au guichet lors du dépôt ; sinon déclaration en commissariat/gendarmerie.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — SORTIE DU TERRITOIRE DU MINEUR
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00030",
              "II — Sortie de territoire du mineur",
            ),
            cardColor: cardMineur,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00031",
                  "A) Autorisation de sortie du territoire (AST)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00032",
                      "Un mineur résidant en France qui voyage à l’étranger seul ou sans l’un de ses parents ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00033",
                      "doit avoir une AST. Un mineur voyageant avec son père ou sa mère n’a pas besoin d’AST.",
                    ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(text: "Formulaire "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00034",
                    "CERFA n°15646*01",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00035",
                    " disponible sur service-public.fr (aucun passage en mairie/préfecture).",
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00036",
                  "Documents à avoir (voyage sans parent)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00037",
                  "Pièce d’identité valide du mineur (CNI ou passeport) + visa si nécessaire (selon pays).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00038",
                  "Photocopie du titre d’identité du parent signataire (valide ou périmé depuis moins de 5 ans).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00039",
                  "Original de l’AST signée par un parent titulaire de l’autorité parentale.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00040",
                  "B) Opposition à sortie du territoire (OST)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00041",
                  "En cas d’urgence et face à un risque avéré, un parent peut demander une OST.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00042",
                  "Demande en préfecture / sous-préfecture.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00043",
                  "Nuits / week-ends / jours fériés : possible en commissariat ou brigade de gendarmerie.",
                ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Effets",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00044",
                      "Si OST décidée : inscription au FPR et signalement au SIS. Durée maximale : 15 jours (non prolongeable).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00045",
                  "C) Interdiction de sortie du territoire (IST)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00046",
                      "Mesure judiciaire décidée par le JAF (autorité parentale / protection) ou le juge des enfants ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00047",
                      "(assistance éducative).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Nota",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00048",
                      "Un mineur sous IST peut voyager si les deux parents autorisent expressément : autorisation recueillie au commissariat sur PV (au moins 5 jours avant).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — PERMIS / ÉCHANGES + PERMIS INTERNATIONAL
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00049",
              "III — Permis de conduire (échanges & permis international)",
            ),
            cardColor: cardPermis,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00050",
                  "A) Échanger un permis UE/EEE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00051",
                      "Concerne les résidents en France titulaires d’un permis délivré par un autre État UE/EEE. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00052",
                      "L’échange n’est pas obligatoire sauf dans certains cas (infraction entraînant suspension/retrait, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00053",
                      "ou permis obtenu en échange d’un pays tiers sans réciprocité).",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00054",
                  "Demande (par courrier)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(text: "Formulaire "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00055",
                    "CERFA n°14879*01",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00056",
                    " + formulaire ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00057",
                    "CERFA n°14948*01 (référence 06)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00058",
                    " (imprimé en couleur).",
                  ),
                ),
              ]),
              SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00059",
                  "Copie couleur recto/verso du permis + justificatifs d’identité et de domicile + photos + enveloppe lettre suivie.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00060",
                  "Dossier adressé au CERT (ou CREPIC si Paris).",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00061",
                  "B) Échanger un permis hors UE/EEE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00062",
                      "Obligatoire pour continuer à conduire : échange à demander dans l’année suivant l’acquisition de la résidence habituelle en France ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00063",
                      "(sauf étudiants étrangers pendant leurs études).",
                    ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                title: "Conditions",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00064",
                      "Permis valide, pays pratiquant l’échange, conditions de reconnaissance (traduction officielle si nécessaire, âge requis, absence de suspension/retrait…).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00065",
                  "C) Permis international",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00066",
                      "Certains pays exigent un permis international (traduction officielle du permis français). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00067",
                      "Coût : gratuit. Demande par courrier.",
                    ),
              ),
              SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(text: "Formulaire "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00068",
                    "CERFA n°14881*01",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00069",
                    " (1er volet) + copies permis/identité/domicile + 2 photos + enveloppe lettre suivie.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00070",
                  "Dossier au CERT Permis internationaux (ou CREPIC si Paris).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — PASSEPORT + ÉTAT CIVIL + LIVRET + NATIONALITÉ
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00071",
              "IV — Passeport & actes d’état civil",
            ),
            cardColor: cardEtatCivil,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle("Passeport"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00072",
                  "Demande en mairie équipée (pas lié au domicile). Pré-demande possible sur ants.gouv.fr. Présence obligatoire (empreintes).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00073",
                  "Mineur : enfant + responsable légal présents. Un enfant ne peut pas être inscrit sur le passeport d’un parent.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00074",
                  "Validité : 10 ans (majeur) / 5 ans (mineur) / 1 an (urgence, sur justificatifs).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00075",
                  "Extrait / copie d’acte de naissance",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00076",
                  "3 formats : copie intégrale, extrait avec filiation, extrait sans filiation.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00077",
                  "Demande : mairie du lieu de naissance (en ligne, sur place, ou par courrier) ou service central de Nantes pour Français nés à l’étranger.",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00078",
                  "Copie d’acte de décès",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00079",
                  "Toute personne peut en demander une (gratuit).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00080",
                  "Demande : mairie du décès / mairie du dernier domicile, ou via service-public.fr, ou Nantes si décès à l’étranger (Français).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00081",
                  "Livret de famille",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00082",
                  "Peut être demandé comme justificatif (CNI/passeport), avec d’autres pièces selon le cas.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00083",
                  "Mise à jour à la charge du titulaire (présentation à chaque changement d’état civil).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00084",
                  "Certificat de nationalité française",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00085",
                  "Prouve la nationalité française (peut être exigé pour 1ère CNI, passeport, concours FP).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00086",
                  "Pas de durée de validité limitée (fait foi jusqu’à preuve contraire).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // X — VOTE PAR PROCURATION
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00087",
              "V — Vote par procuration",
            ),
            cardColor: cardVote,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00088",
                      "Permet à un électeur absent (mandant) de choisir un autre électeur (mandataire) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                      "f00089",
                      "pour voter à sa place.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00090",
                  "Conditions pour le mandataire",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00091",
                  "Inscrit dans la même commune que le mandant (pas forcément même bureau).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00092",
                  "Ne détient pas plus de 2 procurations (selon règles France/étranger).",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00093",
                  "Où faire la démarche ?",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00094",
                  "Commissariat / gendarmerie (où que soit le mandant), ou tribunal judiciaire (domicile / travail).",
                ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00095",
                  "Comment faire ?",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00096",
                    "Option 1 : formulaire papier sur place.\n",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00097",
                    "Option 2 : formulaire ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00098",
                    "CERFA n°14952*02",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00099",
                    " rempli en ligne puis imprimé (2 feuilles, pas recto-verso) et finalisé au guichet.\n",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                    "f00100",
                    "Option 3 : demande en ligne via maprocuration.gouv.fr (puis déplacement obligatoire pour validation d’identité).",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00101",
                  "Délais",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                          "f00102",
                          "Même si la procuration peut être établie jusqu’au jour du vote, il est recommandé d’anticiper ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                          "f00103",
                          "pour éviter que la mairie ne la reçoive trop tard.",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00104",
                  "Déroulement du vote",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00105",
                  "Le mandataire vote avec sa propre pièce d’identité, au bureau du mandant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00106",
                  "Le mandant peut voter lui-même s’il se présente avant le mandataire.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse rapide
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
              "f00107",
              "Synthèse (mémo)",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00108",
                  "CNI/Passeport : mairie équipée + pré-demande possible sur ANTS + empreintes obligatoires.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00109",
                  "Mineur à l’étranger sans parent : AST (CERFA) + pièces d’identité + copie du parent signataire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00110",
                  "Permis : échanges via CERFA + CERT/CREPIC ; permis international gratuit via CERFA.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00111",
                  "État civil : actes via mairie / en ligne / courrier (Nantes pour Français à l’étranger).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/demarches_administratives_page.dart",
                  "f00112",
                  "Vote : procuration possible commissariat/gendarmerie/tribunal + option maprocuration.",
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
