import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class IdentificationDetectionProduitsSuspectsPage extends StatelessWidget {
  const IdentificationDetectionProduitsSuspectsPage({super.key});

  static const String routeName =
      '/gpx/intervention/autres/identification-detection-produits-suspects';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

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
            "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
            "f00002",
            "Intervention — Autres",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00003",
              "Identification & détection des produits stupéfiants",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Rappel / objectif
          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                      "f00004",
                      "Cette fiche vise à donner des repères simples et opérationnels : vocabulaire, définitions, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                      "f00005",
                      "grandes familles de produits, présentations habituelles et principaux effets.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                      "f00006",
                      "⚠️ Ce contenu est informatif : il ne remplace pas les procédures, ni l’analyse scientifique.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00007",
              "I — Élément légal (référence)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                    "f00008",
                    "Les « substances vénéneuses » sont définies par : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                    "f00009",
                    "l’article L. 5132-1 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                    "f00010",
                    " (3 catégories : stupéfiants, psychotropes, listes I & II).",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                    "f00011",
                    "Les listes I et II sont mentionnées à : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                    "f00012",
                    "l’article L. 5132-6 du Code de la santé publique",
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
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                      "f00013",
                      "Quand d’autres articles (CP / CPP / CSI / CSP…) apparaissent dans tes supports, ils doivent être affichés en rouge, exactement comme ci-dessus.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définitions
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00014",
              "II — Quelques définitions (à connaître)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00015",
                  "Accoutumance : consommation répétée entraînant une dépendance psychique.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00016",
                  "Dépendance : impossibilité de se passer d’un produit (physique et/ou psychique).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00017",
                  "Dopage : utilisation de substances/procédés interdits pour augmenter artificiellement le rendement (souvent en contexte sportif).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00018",
                  "Drogue : substance naturelle ou de synthèse agissant sur l’organisme (SNC) et modifiant conscience, sensations, comportement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00019",
                  "Hallucinogènes : substances provoquant altérations et/ou hallucinations sensorielles.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00020",
                  "Psychotrope : molécules (souvent pharmacopée) présentant un risque important sur la santé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00021",
                  "Sevrage : arrêt du produit → symptômes psychologiques et physiologiques (« syndrome de sevrage »).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00022",
                  "Stupéfiants : substances psychoactives dangereuses (certaines totalement prohibées : héroïne, cocaïne, cannabis…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00023",
                  "Surdose (overdose) : l’organisme ne tolère pas → risque vital rapide (respiration, rythme cardiaque, coma).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00024",
                  "Tolérance : nécessité d’augmenter les doses pour obtenir le même effet.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Classification - naturelle
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00025",
              "III — Classification : substances d’origine naturelle (repères)",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00026",
                  "Cannabis — herbe (kif, marijuana, chanvre indien, ganja, zamal…)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00027",
                  "Aspect : feuilles/fleurs séchées, verdâtre à ocre, odeur poivrée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00028",
                  "Conditionnement : enveloppes, doses ~ 5 à 10 g.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00029",
                  "Effets : euphorie, troubles cognitifs (mémoire/perception), humeur, angoisse/panique, altération du jugement.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00030",
                  "Cannabis — résine (shit, haschich)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00031",
                  "Aspect : morceaux/plaquettes/barrettes, brun pâle à noir, parfois vert/ocre, consistance molle à dure.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00032",
                  "Conditionnement : barrettes 2 à 5 g (alu/adhésif), savonnettes/plaquettes 125 g à 1 kg.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00033",
                  "Effets : proches cannabis ; risque d’angoisse/panique, réactions psychotiques, jugement altéré.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00034",
                  "Huile de cannabis",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00035",
                  "Aspect : liquide épais visqueux brun-vert à noirâtre, odeur âcre forte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00036",
                  "Conditionnement : petites fioles (au gramme) ou entre plastiques thermocollés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00037",
                  "Effets : effets psychoactifs marqués, altération jugement, nausées possibles.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00038",
                  "Champignons hallucinogènes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00039",
                  "Familles : psilocybes, conocybes, strophaires.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00040",
                  "Conditionnement : frais ou séchés (doses variables).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00041",
                  "Effets : hallucinations/altérations sensorielles, anxiété possible, jugement altéré.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle("Opium"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00042",
                  "Aspect : pâte assez ferme brun/noir, odeur âcre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00043",
                  "Conditionnement : pains (250 g à 1 kg), boulettes, bâtonnets.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00044",
                  "Effets : somnolence, abattement, myosis, constipation ; forte dépendance et risque surdosage.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Classification - (semi) synthèse / produits “classiques”
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00045",
              "IV — Autres produits fréquemment rencontrés (repères)",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00046",
                  "Morphine / héroïne",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00047",
                  "Morphine : alcaloïde extrait de l’opium (médical).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00048",
                  "Héroïne : produit de semi-synthèse (à partir morphine).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00049",
                  "Présentation : poudre blanche à marron, odeur opium/vinaigre ; doses en boulettes/pailles/sachets.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00050",
                  "Signes/effets : traces de piqûres, myosis, amaigrissement ; très forte dépendance, risque surdosage.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00051",
                  "Cocaïne (chlorhydrate) / crack",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00052",
                  "Cocaïne : poudre blanche cristalline (« neige »), mydriase, tachycardie, HTA, convulsions possibles.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00053",
                  "Crack : forme solide destinée à être fumée (cailloux/rocs blanc à écru).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00054",
                  "Effets : paranoïa, délires/anxiété, dépendance forte ; crack = effet bref et prises compulsives.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00055",
                  "Rachacha (décoction de pavot)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00056",
                  "Aspect : pâte molle/visqueuse acajou, odeur de terre pourrie.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00057",
                  "Effets : calmant/apaisant, modification conscience, nausées ; dépendance et risque cardio.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Synthèse
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00058",
              "V — Substances de synthèse (repères)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00059",
                  "Amphétamines / méthamphétamine",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00060",
                  "Présentation : poudres (blanche/rose/jaune), cristaux, comprimés.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00061",
                  "Effets : stimulation, euphorie, anorexie, vigilance augmentée ; dépendance psychique forte, risque surdosage.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00062",
                  "Méthamphétamine : effets proches mais plus puissants/durables (jusqu’à 24 h).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00063",
                  "Ecstasy (MDMA & dérivés)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00064",
                  "Présentation : comprimés souvent avec logos, parfois gélules/poudre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00065",
                  "Effets : stimulant + parfois hallucinogène, sensations chaleur/flottement, déshydratation ; risque surdosage.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00066",
                  "LSD-25",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00067",
                  "Dose efficace très faible → supports imprégnés (buvard, gélatine, pointe graphite…), plus rarement liquide/gélules.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00068",
                  "Effets : hallucinations, perturbation de l’humeur et de la pensée, flash-back possible ; risque surdosage.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00069",
                  "Colles / solvants",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00070",
                  "Produits : dissolvants, détachants, diluants (acétone, toluène, benzène…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00071",
                  "Effets : euphorie/ivresse, confusion (illusions/hallucinations), toxicité importante ; risque coma/décès (respiratoire/cardio).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00072",
                  "Poppers (dérivés du nitrite)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00073",
                  "Liquide jaunâtre, volatil et inflammable (petites bouteilles).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00074",
                  "Effets : vasodilatation, tachycardie, vertiges, céphalées ; risque malaise.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Médicaments
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00075",
              "VI — Médicaments détournés (repères)",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle("GHB"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00076",
                  "Peut se présenter en poudre cristalline ou liquide incolore/jaune (« drogue du viol »).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00077",
                  "Effets : sédatif, amnésie, vertiges, nausées ; risque dépression respiratoire.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00078",
                  "Substitution aux opiacés (méthadone / buprénorphine)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00079",
                  "Méthadone : sirop (odeur vanillée), gélules/comprimés (emballage d’origine).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00080",
                  "Buprénorphine : comprimés (voie sublinguale).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00081",
                  "Risques : dépendance/tolérance/surdosage ; détournement voie d’administration (complications).",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00082",
                  "Kétamine / tiletamine",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00083",
                  "Anesthésiques (humain/vétérinaire). Présentation : liquide incolore ou poudre blanche/beige.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00084",
                  "Effets : dissociation (extra-corporalité), visions psychédéliques, troubles neuro ; risque coma.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Vocabulaire
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00085",
              "VII — Vocabulaire utilisé (argot / repères)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00086",
                  "Acid / Acide : LSD-25.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00087",
                  "Amphes : amphétamines. — Speed : amphétamines.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00088",
                  "Bang : cannabis. — Boulette : haschich.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00089",
                  "Neige : cocaïne. — CC / Coke : cocaïne.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00090",
                  "Caillou / Galettes / Slam : crack.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00091",
                  "Képa : dose individuelle.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00092",
                  "OD : overdose (surdose). — Descente : fin des effets.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00093",
                  "Shoot / Fix : injection. — Shooteuse : seringue.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00094",
                  "Flash / Super-flash : plaisir intense à l’injection.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00095",
                  "Flash-back : retour d’effets (LSD) sans reprise.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00096",
                  "Trip : sous influence d’hallucinogène.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00097",
                  "Speed ball : mélange héroïne/cocaïne (ou amphétamines).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
              "f00098",
              "En résumé (mémo rapide)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00099",
                  "Connaître les définitions (dépendance, sevrage, surdose, tolérance).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00100",
                  "Identifier les grandes familles : naturel / synthèse / médicaments détournés.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00101",
                  "Retenir les présentations typiques (poudre, cailloux, buvards, fioles, comprimés, sachets…).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                  "f00102",
                  "Savoir citer les repères légaux CSP en cas de question de classification.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/identification_detection_produits_suspects_page.dart",
                      "f00103",
                      "Si tu ajoutes d’autres références (CP/CPP/CSI/CSP) dans cette page plus tard, mets uniquement la partie “Article … du …” en rouge.",
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
