import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PatrouillePatrouillePage extends StatelessWidget {
  const PatrouillePatrouillePage({super.key});

  static const String routeName = '/gpx/intervention/patrouille/patrouille';

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
            "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00002",
              "La patrouille",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Cadre (en haut) — pas d’article fourni dans ton cours, donc pas d’invention
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00003",
              "Cadre & idée clé",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00004",
                      "La patrouille est l’activité la plus fréquente et l’une des plus importantes exercées ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00005",
                      "par les gardiens de la paix assistés des policiers adjoints.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00006",
                      "Elle vise la surveillance générale de la voie publique, l’assistance aux personnes, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00007",
                      "le maintien de l’ordre et la tranquillité/salubrité publiques. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00008",
                      "C’est le domaine où le policier a le plus de responsabilités et d’initiative.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "RAPPEL",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00009",
                      "La patrouille n’est pas une “promenade” : elle représente une image directe de la Police pour le public.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Buts
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00010",
              "I — Les buts de la patrouille",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00011",
                  "Effectuer correctement une patrouille signifie qu’à son issue, un double rôle a été rempli.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00012",
                  "A) ÊTRE VU",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00013",
                  "Dissuasion & prévention : objectifs primordiaux de la patrouille.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00014",
                  "Présence et passage à faible allure : dissuadent, rassurent et protègent les usagers.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00015",
                  "B) VOIR ET AGIR",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00016",
                  "Repérer tout ce qui trouble l’ordre public (de l’embarras de circulation au flagrant délit).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00017",
                  "Intervenir pour faire cesser les troubles, renseigner le public, faciliter la circulation piétons/véhicules.",
                ),
              ),
              SizedBox(height: 12),
              _NotaBox(
                title: "RADIO",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00018",
                      "La patrouille doit toujours disposer d’un moyen radio. Toute intervention est annoncée (localisation précise + motif).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Formes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00019",
              "II — Les différentes formes de patrouille",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00020",
                      "La patrouille peut être réalisée selon plusieurs modalités : à pied, en deux-roues (cyclomoteur, moto, VTT), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00021",
                      "ou en automobile/fourgon.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00022",
                      "L’efficacité n’est pas liée au nombre de kilomètres parcourus : elle dépend du comportement de surveillance ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00023",
                      "et de prévention (ralentir, s’arrêter, observer, intervenir).",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00024",
                  "A) Patrouille à pied",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00025",
                  "Généralement 2 à 3 fonctionnaires en tenue, itinéraire défini ou adapté selon le contexte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00026",
                  "Avant départ : tenue adaptée + armement et moyens matériels (gilet pare-balles, radio…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00027",
                  "Principe : ne pas progresser groupés (alignements/hauteurs différentes).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00028",
                  "QUARTIERS SENSIBLES",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00029",
                      "Rester vigilant, observer les zones de danger potentiel et garder une distance suffisante pour :\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00030",
                      "• se protéger des jets de projectiles\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00031",
                      "• détecter des individus en position haute (prise à partie / alerte)",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00032",
                  "Surveiller les “points hauts” (étages, fenêtres, toits, halls, coursives, passerelles, buttes…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00033",
                  "Garder du recul par rapport aux immeubles pour augmenter la distance de sécurité et élargir l’angle d’observation.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00034",
                  "B) Patrouille en deux-roues",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00035",
                  "Adaptée au trafic urbain et à la surveillance de secteurs étendus grâce à la mobilité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00036",
                  "Limite : l’attention de conduite réduit la capacité d’observation fine de l’environnement.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00037",
                  "C) Patrouille automobile",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00038",
                  "Couvre de grandes distances et permet de rester en contact permanent avec le CIC.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00039",
                  "Le commandement est assuré par un gradé ou le plus ancien ; il embarque le matériel de protection/intervention nécessaire.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00040",
                  "SÉCURITÉ MATÉRIEL",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00041",
                      "Le matériel doit être rangé avec rigueur : certains objets peuvent devenir des projectiles en cas de freinage brusque (radio, équipements de protection, LBD, etc.).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Focus quartiers sensibles en véhicule
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00042",
              "Conduite en quartiers sensibles (automobile)",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00043",
                  "Ne s’engager que sur des itinéraires connus ; détour possible pour éviter une zone à risques (dalles, passerelles, impasses…).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00044",
                  "Stationner à distance du lieu direct de l’intervention ; garder une échappatoire avant ou arrière.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00045",
                  "À l’arrêt : chauffeur debout à côté du véhicule, radio en main (surveillance + demande de renfort si besoin).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00046",
                  "Ne pas laisser le véhicule sans surveillance (sauf force majeure) : retirer les clés, fermer portières et coffres.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00047",
                  "DÉGAGEMENT",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00048",
                      "En situation dangereuse difficilement gérable : le véhicule est un moyen de dégagement d’urgence. Pour jets de projectiles, la carrosserie peut servir d’abri temporaire (en restant à l’extérieur). Dès que l’embarquement est possible : se soustraire immédiatement.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00049",
                  "ARME À FEU",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00050",
                      "En cas de tir sur des policiers, seul le bloc moteur du véhicule offre une protection efficace.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Moyens
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00051",
              "III — Les moyens de la patrouille",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00052",
                      "L’action du policier doit s’effectuer en sécurité. Le chef de service fixe les moyens matériels ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00053",
                      "mis à disposition des équipages.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00054",
                  "Catégories de moyens",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00055",
                  "Moyens de protection : signalisation, éclairage, vêtements rétro-réfléchissants…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00056",
                  "Moyens de liaisons : radio.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00057",
                  "Moyens de riposte : armes collectives, armes individuelles, lacrymogènes…",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00058",
                  "AVANT DÉPART",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00059",
                      "Vérifier le bon état et le bon fonctionnement du matériel emporté.",
                    ),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV — Principes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00060",
              "IV — Les principes essentiels",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00061",
                  "A) Liaison radio constante (CIC)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00062",
                  "Essai radio avant l’annonce du départ.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00063",
                  "Comptes-rendus en temps réel concernant les interventions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00064",
                  "Retour au service (momentané ou fin de vacation) systématiquement signalé.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00065",
                  "B) Mission cadrée",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00066",
                  "Accomplir la mission dans un temps et un lieu précis : la circonscription est divisée en secteurs de patrouille.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                  "f00067",
                  "En fin de patrouille : rendre compte à la hiérarchie.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
              "f00068",
              "Synthèse opérationnelle",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00069",
                      "Une bonne patrouille = présence visible + observation active + intervention adaptée, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00070",
                      "le tout en sécurité et en lien radio constant.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/patrouille/patrouille_patrouille_page.dart",
                      "f00071",
                      "Le public juge souvent la Police à travers l’attitude et le professionnalisme de la patrouille.",
                    ),
              ),
            ],
          ),

          // (réservé au cas où tu ajoutes plus tard des articles : _lawRed déjà prêt)
          const SizedBox(height: 2),
          const SizedBox(height: 2),
          // ignore: dead_code
          const SizedBox(height: 0),
          // ignore: dead_code
          const _Paragraph.rich([
            TextSpan(
              text: "",
              style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
            ),
          ]),
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
