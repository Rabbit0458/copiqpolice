import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class CadreLegalControleRoutierPage extends StatelessWidget {
  const CadreLegalControleRoutierPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/cadre_legal';

  static const Color _lawRed = Color(0xFFE53935);

  // ⚠️ IMPORTANT : on n'utilise PAS copyWith sur TextSpan (sinon erreur).
  // Du coup on fait une vraie factory simple :
  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardDocs = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardDelits = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardNatinf = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardNotes = isDark
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
            "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
            "f00002",
            "Contrôle routier",
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
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
              "f00003",
              "Le cadre légal du contrôle routier\net les pièces afférentes à la conduite",
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
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
              "f00004",
              "Repère utile",
            ),
            cardColor: cardNotes,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00005",
                      "Pour approfondir : guide de la police de la circulation routière ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00006",
                      "(onglet « outils professionnels / guides pratiques du policier ») via le portail Doc Pro PN.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
              "f00007",
              "I — Élément légal (base du contrôle)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00008",
                    "Fondements : ",
                  ),
                  style: GoogleFonts.fustat(fontWeight: FontWeight.w800),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00009",
                    "R. 233-1",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00010",
                    "R. 233-3 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00011",
                    ", ainsi que ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00012",
                    "R. 211-14-0 et suivants du Code des assurances",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00013",
                    ". Ces textes autorisent les policiers à demander, à tout moment, la présentation des pièces afférentes à la conduite et à la circulation du véhicule (ou à l’accompagnateur lorsqu’il y en a un).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00014",
                      "Les O.P.J. et les A.P.J. peuvent interrompre d’initiative la progression d’un véhicule à moteur ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00015",
                      "(VL, PL, deux-roues…) même en l’absence d’infraction préalable, afin de procéder au contrôle des pièces et obligations réglementaires.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
              "f00016",
              "II — Pièces et obligations contrôlables",
            ),
            cardColor: cardDocs,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00017",
                  "A) Justificatifs du droit de conduire",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00018",
                      "Le contrôle porte notamment sur le titre justifiant l’autorisation de conduire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00019",
                      "(permis de conduire ou documents équivalents).",
                    ),
              ),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00020",
                  "Permis de conduire / certificat équivalent (NATINF 6227).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00021",
                  "Attestation de formation pratique / expérience (motocyclettes légères : NATINF 28094 ; tricycles L5e : NATINF 28096).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00022",
                  "Document de demande de permis (ou copie / récépissé) pour élève conducteur (NATINF 22878).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00023",
                  "B.S.R. (référence : contrôle via la base légale).",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Info",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                          "f00024",
                          "À titre expérimental, le permis peut être présenté en version numérique via « France Identité ». ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                          "f00025",
                          "Le contrôle s’effectue depuis NEOFIC via le module « France titre » disponible sur NEO.",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00026",
                  "B) Cas particuliers liés à des restrictions judiciaires / administratives",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00027",
                    "Exemples de documents : certificat remis en échange du permis en cas de restrictions, notamment ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00028",
                    "R. 131-2 du Code pénal",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00029",
                    "R. 131-4 du Code pénal",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00030",
                    "R. 131-4-1 du Code pénal",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00031",
                    "R. 224-6 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00032",
                  "C) E.A.D. (antidémarrage éthylotest électronique)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                        "f00033",
                        "Attestation d’équipement et de bon fonctionnement (NATINF 32023) lorsque le conducteur est soumis à l’obligation (condamnation / contrôle judiciaire / décision administrative). ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                        "f00034",
                        "Références possibles : ",
                      ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00035",
                    "132-45 7° du Code pénal",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00036",
                    "41-2 4° bis du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00037",
                    "138 8° du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00038",
                    "R. 221-1-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00039",
                    "R. 226-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00040",
                    "L. 234-17 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00041",
                  "D) Certificat d’immatriculation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00042",
                    "Certificat d’immatriculation (NATINF 6204) — base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00043",
                    "R. 233-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00044",
                    ". Remorque si PTAC > 500 kg : NATINF 32028 / 32029. Récépissé de perte/vol valable 1 mois : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00045",
                    "R. 322-10 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00046",
                  "E) Assurance & équipements obligatoires",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00047",
                  "Obligation d’assurance (NATINF 6168 et 6166).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00048",
                    "Triangle de présignalisation : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00049",
                    "R. 416-19 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00050",
                    " (NATINF 26986).",
                  ),
                ),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00051",
                    "Gilet haute visibilité : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00052",
                    "R. 416-19 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00053",
                    " (NATINF 26987).",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
              "f00054",
              "III — Délits relatifs au contrôle routier",
            ),
            cardColor: cardDelits,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00055",
                  "A) Refus d’obtempérer",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00056",
                    "Constitue un délit : refuser d’obtempérer à une sommation de s’arrêter — ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00057",
                    "L. 233-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00058",
                    " (NATINF 50).",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00059",
                      "Formes aggravées : exposition directe d’autrui à un risque de mort/infirmité permanente, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00060",
                      "ou exposition directe d’un agent à un tel risque.",
                    ),
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00061",
                    "Références : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00062",
                    "L. 233-1-1 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00063",
                    " (NATINF 25124 et 34489).",
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00064",
                  "B) Refus de se soumettre aux vérifications",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00065",
                    "Constitue un délit : refuser de se soumettre aux vérifications relatives au véhicule ou au conducteur — ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00066",
                    "L. 233-2 du Code de la route",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                    "f00067",
                    " (NATINF 179).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00068",
                      "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
              "f00069",
              "IV — Non-présentation & non-justification (pédagogique)",
            ),
            cardColor: cardNatinf,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00070",
                  "A) Non-présentation immédiate (exemples)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00071",
                  "Permis de conduire / assimilé : NATINF 6227 (base : R. 233-1 CR).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00072",
                  "Attestation formation motocyclette légère (cat. B) : NATINF 28094 ; tricycle L5e : NATINF 28096.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00073",
                  "Élève conducteur — preuve de la demande : NATINF 22878.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00074",
                  "Document E.A.D. : NATINF 32023.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00075",
                  "Certificat d’immatriculation : NATINF 6204 (remorque PTAC > 500 kg : NATINF 32028/32029).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00076",
                  "Assurance (véhicules non soumis à immatriculation) : NATINF 6168 ; certificat/apposition : NATINF 6166.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00077",
                  "Triangle : NATINF 26986 — gilet : NATINF 26987.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00078",
                  "B) Obligation de justifier ensuite la possession",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00079",
                      "La non-présentation des pièces visées (et, pour les véhicules non immatriculés, l’attestation d’assurance) ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00080",
                      "entraîne l’obligation d’en justifier la possession dans un délai de 5 jours ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00081",
                      "(délai porté à 12 jours dans le cadre du PVe).",
                    ),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00082",
                  "NATINF (exemples) : 7553, 7554, 21213, 22879, 28095, 28097, 32024, 32030, 32031, 6164, 32030, 32031.",
                ),
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                          "f00083",
                          "La consultation des fichiers (SNPC, SIV, FVA) permet de traiter en temps réel les infractions ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                          "f00084",
                          "liées au défaut ou au retrait du document (ex. conduite sans permis / malgré suspension, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                          "f00085",
                          "défaut de certificat d’immatriculation, défaut d’assurance…).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
              "f00086",
              "V — Particularités & limites du contrôle",
            ),
            cardColor: cardNotes,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00087",
                  "B.S.R. (brevet de sécurité routière)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00088",
                      "La non-présentation immédiate du B.S.R. n’est pas réprimée. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00089",
                      "Le titulaire doit néanmoins justifier de ce document dans un délai de cinq jours (NATINF 21213).",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00090",
                  "Ouverture du capot moteur",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00091",
                      "La fouille ou la visite du coffre n’est pas autorisée lors d’un simple contrôle routier. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00092",
                      "En revanche, le policier peut demander l’ouverture du capot moteur afin de vérifier la conformité ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                      "f00093",
                      "du numéro d’identification du véhicule avec celui figurant sur le certificat d’immatriculation.",
                    ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00094",
                  "Conséquences fréquentes d’un contrôle",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00095",
                  "Vérifier le respect de la réglementation en matière de contrôle technique.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00096",
                  "Contrôler la présence, conformité et bon état des équipements réglementaires (pneus, éclairage…).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/cadre_legal_controle_routier_page.dart",
                  "f00097",
                  "Constater, le cas échéant, la violation de l’interdiction de fumer en présence d’un mineur (Code de la santé publique).",
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
