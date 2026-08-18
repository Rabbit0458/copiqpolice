import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PermisConduirePage extends StatelessWidget {
  const PermisConduirePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/permis_conduire';

  static const Color _lawRed = Color(0xFFE53935);

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
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardCats = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardDocs = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDelits = isDark
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
            "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
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
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00003",
              "Le permis de conduire",
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
            title: "Principe",
            cardColor: cardDelits,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00004",
                      "Nul ne peut conduire un véhicule (ou ensemble de véhicules) pour lequel un permis est exigé ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00005",
                      "s’il n’est titulaire de la catégorie correspondante, ou si son droit de conduire fait l’objet d’une mesure ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00006",
                      "administrative ou judiciaire (rétention, suspension, annulation, invalidation, interdiction).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (exigence)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00007",
              "I — Élément légal (textes de référence)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00008",
                    "L. 221-1",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00009",
                    "L. 221-2",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00010",
                    "R. 221-1 à R. 222-7",
                  ),
                ),
                const TextSpan(text: ", "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00011",
                    "D. 221-3",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00012",
                    "D. 222-8 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00013",
                      "Le permis est un titre unique de conduite délivré par l’autorité administrative. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00014",
                      "Il répertorie l’ensemble des catégories détenues par son titulaire.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00015",
              "II — Mesures qui retirent / limitent le droit de conduire",
            ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00016",
                  "A) Rétention (mesure conservatoire)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00017",
                    "Mesure obligatoirement prise par les policiers, pour 72 h (ou 120 h selon les cas) en attente d’une décision administrative : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00018",
                    "L. 224-1 à L. 224-4",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00019",
                    "L. 224-6 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00020",
                  "B) Suspension",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00021",
                      "• Par le préfet : mesure de sûreté administrative, notamment pendant la rétention, ou à la suite d’un PV / contrôle médical d’aptitude.\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00022",
                      "• Par la juridiction pénale : peine alternative ou complémentaire (durées variables selon le fondement).",
                    ),
              ),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00023",
                  "Repères NATINF",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00024",
                      "Suspension liée au Code de la route : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00025",
                      "NATINF 5707",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00026",
                      " ; suspension suite à infraction à un autre code : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00027",
                      "NATINF 7953",
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00028",
                  "C) Annulation / interdiction / invalidation",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00029",
                  "Annulation préfectorale : notamment après contrôle médical d’aptitude (NATINF 7536).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00030",
                  "Annulation judiciaire : peut être assortie d’une interdiction de solliciter un nouveau permis (NATINF 5708).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00031",
                  "Interdiction d’obtenir la délivrance du permis si l’auteur n’est pas titulaire (NATINF 5709).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00032",
                  "Invalidation : solde de points nul (permis à points).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00033",
              "III — Catégories de permis (repères essentiels)",
            ),
            cardColor: cardCats,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00034",
                  "A) Deux-roues / tricycles",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00035",
                  "A1 (16 ans) : motocyclettes légères (≤125 cm³, ≤11 kW, rapport ≤0,1 kW/kg) + tricycles ≤15 kW.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00036",
                  "A2 (18 ans) : motocyclettes ≤35 kW, rapport ≤0,2 kW/kg.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00037",
                  "A : accès progressif (A2 depuis 2 ans + formation). Tricycles >15 kW : âge mini 21 ans (sauf exceptions anciennes).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00038",
                  "B) Voitures / ensembles",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00039",
                  "B1 (16 ans) : quadricycles lourds à moteur.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00040",
                  "B (dès 17 ans selon conditions) : véhicules PTAC ≤3,5 t (8 passagers max hors conducteur). Remorques selon règles (formation « 96 » pour certains ensembles).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00041",
                  "BE (18 ans) : ensemble catégorie B + remorque/semiremorque selon seuils (quand l’ensemble ne relève pas de B).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00042",
                  "C) Poids lourds / transport",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00043",
                  "C1/C1E : transport de marchandises PTAC >3,5 t et ≤7,5 t (avec règles remorque).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00044",
                  "C/CE : marchandises >3,5 t (conditions d’âge / diplôme possibles).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00045",
                  "D1/D1E/D/DE : transport de personnes (conditions d’âge + qualifications type FIMO / titres).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00046",
              "IV — Équivalences & validité des anciens titres (repère)",
            ),
            cardColor: cardDocs,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00047",
                      "Les permis délivrés avant le 19 janvier 2013 restent valables pour la conduite des véhicules concernés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00048",
                      "Ils doivent être échangés contre un nouveau modèle avant le 19/01/2033. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00049",
                      "Les équivalences associées sont reconnues même si elles ne sont pas mentionnées sur le titre.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                          "f00050",
                          "NOTA : une catégorie B obtenue avant le 20/01/1975 autorise la conduite des camping-cars de PTAC > 3,5 t ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                          "f00051",
                          "(mention « 79 : B motorhome >3500 kg »).",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00052",
              "V — Permis délivrés à l’étranger (reconnaissance)",
            ),
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00053",
                  "A) UE / EEE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00054",
                      "Reconnu en France s’il est en cours de validité. Échange possible sans nouvel examen si le titulaire réside normalement en France. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00055",
                      "L’échange devient obligatoire notamment en cas d’infraction en France ayant entraîné une mesure de restriction/suspension/retrait du droit de conduire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00056",
                      "ou un retrait de points (NATINF 21944).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00057",
                  "B) Hors UE / hors EEE",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00058",
                      "Reconnu pendant 1 an après l’acquisition de la résidence normale en France. Au-delà, le permis n’est plus reconnu et le titulaire perd le droit de conduire ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00059",
                      "pour les véhicules soumis à permis (NATINF 7536). Échange possible pendant un an si accord de réciprocité.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00060",
                  "Définition",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00061",
                      "Résidence normale : lieu où une personne demeure habituellement, soit 185 jours par année civile.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00062",
              "VI — Visites médicales (délivrance / prorogation)",
            ),
            cardColor: cardDocs,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00063",
                    "Références : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00064",
                    "R. 221-10",
                  ),
                ),
                const TextSpan(text: " et "),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00065",
                    "R. 221-11 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00066",
                      "Le permis peut être délivré pour une durée limitée si le titulaire est atteint d’une affection susceptible de s’aggraver (NATINF 7538). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00067",
                      "Certaines catégories ou usages sont subordonnés à un avis médical favorable (ex. transport de personnes, taxis/VTC, ambulances, ramassage scolaire, etc.).",
                    ),
              ),
              const SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00068",
                      "Périodicité (repère) :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00069",
                      "• Tous les 5 ans avant 60 ans\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00070",
                      "• Tous les 2 ans entre 60 et 76 ans\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00071",
                      "• Tous les ans à partir de 76 ans\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00072",
                      "Pour C/D : contrôles renforcés (repères du mémento).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00073",
              "VII — Mentions additionnelles / restrictives",
            ),
            cardColor: cardCats,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00074",
                      "Des mentions codifiées peuvent figurer sur le permis : restrictions médicales, adaptations du véhicule, conditions d’usage restreint ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00075",
                      "(ex : 01.01 lunettes, 67 pas d’autoroute, 69 EAD, 96 remorque, 79 L5e…).",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00076",
                      "Le non-respect d’une restriction d’usage mentionnée sur le permis constitue une infraction (NATINF 25611).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
              "f00077",
              "VIII — SNPC : états du dossier & délits fréquents",
            ),
            cardColor: cardDelits,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00078",
                  "A) États du dossier (repères)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00079",
                  "SUSPENDU (médical ou décision admin/judiciaire) : plus de droit de conduire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00080",
                  "INTERDIT SOLLICITER : non titulaire, interdiction judiciaire d’obtenir la délivrance du permis.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00081",
                  "ANNULÉ (judiciaire/médical) : plus de droit de conduire.",
                ),
              ),
              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                  "f00082",
                  "B) Délits « défaut de permis » (NATINF)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00083",
                    "Conduite sans permis : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00084",
                    "NATINF 7536",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00085",
                    "Conduite avec catégorie non autorisante : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00086",
                    "NATINF 22872",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00087",
                    " — base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00088",
                    "L. 221-2 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00089",
                    "Usage d’un permis faux/falsifié (catégorie) : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00090",
                    "NATINF 32042",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00091",
                    " — base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00092",
                    "L. 221-2-1 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00093",
                    "Conduite malgré suspension administrative/judiciaire : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00094",
                    "NATINF 5707",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00095",
                    "Conduite malgré annulation judiciaire : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00096",
                    "NATINF 5708",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00097",
                    " — base : ",
                  ),
                ),
                _lawSpan(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00098",
                    "L. 224-16 du Code de la route",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00099",
                    "Conduite malgré interdiction d’obtenir la délivrance : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                    "f00100",
                    "NATINF 5709",
                  ),
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/controle_routier/permis_conduire_page.dart",
                      "f00101",
                      "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
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
