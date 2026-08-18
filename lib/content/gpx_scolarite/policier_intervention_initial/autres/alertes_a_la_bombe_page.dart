import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class AlertesALaBombePage extends StatelessWidget {
  const AlertesALaBombePage({super.key});

  static const String routeName = '/gpx/intervention/autres/alertes-a-la-bombe';

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
            "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
            "f00002",
            "Intervention — Domicile/Autres",
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
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00003",
              "Alertes à la bombe & objets/engins/véhicules suspects",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition / esprit général
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00004",
              "Rappel essentiel",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00005",
                      "Qu’il s’agisse de munitions/engins de guerre, de bagages oubliés/abandonnés, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00006",
                      "d’objets/engins suspects (EEI, ENRI, ECI, EBI ou leurre), d’un véhicule suspect ou d’une alerte à la bombe, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00007",
                      "l’intervention exige un maximum de précautions.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00008",
                      "Ces engins sont conçus pour blesser, tuer, détruire ou contaminer.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00009",
                      "Un engin explosif improvisé ayant déjà fonctionné peut encore blesser ou tuer (fonctionnement partiel possible).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut (ici: pas d’articles explicitement cités dans ton extrait)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00010",
              "I — Cadre de référence",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00011",
                      "La fiche fournie est principalement opérationnelle. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00012",
                      "Lorsque des textes (CP / CPP / CSI…) sont cités dans ton support, ils doivent être affichés en rouge dans cette section.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00013",
                      "Ici, l’objectif est d’appliquer les consignes de sécurité et d’alerter immédiatement la chaîne compétente (CIC / déminage).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // PRINCIPES DE BASE
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00014",
              "II — Principes de base",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00015",
                  "A) Situer très vite l’origine de l’information",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00016",
                      "Les objets suspects sont parfois signalés sous anonymat ou identité empruntée : téléphone, lettre, message… ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00017",
                      "Le contexte du lieu visé (nature du site, événement en cours, zone sensible) permet une première évaluation du risque.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00018",
                  "Danger connu (ex. munitions découvertes) : un délai peut exister, estimé uniquement par les démineurs.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00019",
                  "Danger/heure inconnus (engins improvisés) : prendre au plus vite les premières mesures de sécurité.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00020",
                  "B) Recueillir le maximum d’informations",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00021",
                  "Mode de réquisition : identité/coordonnées du requérant, lieu précis, numéro d’appel, localisation du site menacé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00022",
                  "Teneur du message : auteur (si possible), motivations, mouvement revendiqué, heure/lieu annoncés de l’explosion.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00023",
                  "Localisation de l’objet/engin : cheminement d’accès, obstacles, superficie autour, accès possibles.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00024",
                  "Aspect extérieur : dimensions, texture, inscriptions, fils/adhésifs, antenne/interrupteur, récipients/bouteilles, odeurs, effets secondaires à l’approche, stabilité/instabilité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00025",
                  "Pourquoi c’est suspect : cible potentielle (bâtiment, installation, personne/groupe…), moment de dépôt/découverte, menaces associées.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00026",
                  "Manipulations éventuelles : en aucun cas ne pas déplacer/ouvrir/modifier un bagage, un objet ou un engin suspect.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00027",
                  "Présence de témoins (les inviter à rester), suspects, risques additionnels (gaz, essence, fuel…).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00028",
              "III — Indices principaux de suspicion",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00029",
                  "A) Objet / engin suspect",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00030",
                  "Contexte particulier (événements politiques, sociaux, religieux…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00031",
                  "Proximité d’une zone sensible, d’individus/personnalités pouvant constituer une cible.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00032",
                  "Action signalée : appel, message revendicatif, tract, témoignage…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00033",
                  "Indications sur l’emballage : inscriptions, sigles…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00034",
                  "Abandon en lieu public : absence de propriétaire, fuite constatée.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00035",
                  "Éléments insolites : fils, adhésifs, antenne, interrupteur, récipients, odeurs, effets secondaires à l’approche…",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00036",
                  "B) Véhicule suspect",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00037",
                  "Signalement : information, appel, message revendicatif, tract, témoignage…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00038",
                  "Indices véhicule : zone sensible/fréquentée, stationnement inapproprié, volé, plaque suspecte, inscriptions/sigles.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00039",
                  "Indices conducteur/passager : habitacle inoccupé, personnes suspectes quittant le véhicule.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00040",
                  "Signes : fils/adhésifs/antenne/interrupteur, fumée, fuite de liquide, affaissement du véhicule.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00041",
                  "C) Personne potentiellement porteuse (charge/arme)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00042",
                  "Comportements : nervosité, agitation, sudation, « effet tunnel ».",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00043",
                  "Marquage/indices : portiques dédiés, unités cynotechniques (REXPEMO) si engagées.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // MODE OPÉRATOIRE
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00044",
              "IV — Mode opératoire : dispositifs de sécurité",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00045",
                  "Règles immédiates (toujours)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00046",
                  "Ne pas toucher / ne pas déplacer l’objet, l’engin ou le véhicule. Éviter toute vibration à proximité.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00047",
                  "Ne pas jeter d’eau, ne pas recouvrir, ne pas provoquer de vibrations sonores/thermiques/mécaniques.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00048",
                  "Établir un périmètre de sécurité et ne le rendre accessible qu’aux personnes spécialisées (avant neutralisation : démineurs uniquement).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00049",
                      "Prévoir un seul point d’accès au périmètre (filtrage : un policier + un responsable sécurité du site).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00050",
                  "Périmètres (repères opérationnels)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00051",
                  "Objet/engin en local : rayon 100 m (penser étages supérieurs/inférieurs).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00052",
                  "Individu potentiellement porteur : 60 m minimum à couvert.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00053",
                  "Véhicule : périmètre le plus large possible, repère 200 m.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00054",
                  "NRBC possible : repère 500 m minimum (périmètre élargi sur demande démineurs).",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00055",
                  "Télécom / radios",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00056",
                  "Ne pas utiliser d’émetteurs-récepteurs radio ni téléphones mobiles à proximité immédiate de l’objet/engin suspect.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00057",
              "V — Aviser / Évacuer / Réglementer",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00058",
                  "1) Aviser",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00059",
                  "Avis au C.I.C immédiat : il répercute l’appel aux services de déminage (seuls compétents pour neutraliser).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00060",
                  "Informer autorités administratives & judiciaires compétentes, et services de secours si besoin (pompiers, SAMU, EDF-GDF…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00061",
                  "Informer le responsable du bâtiment / maître des lieux.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00062",
                      "À l’intérieur : mesures de sécurité relèvent du responsable de l’établissement. À l’extérieur : ordre public. En cas de menace avérée/doutes suffisants, l’autorité de police peut imposer l’évacuation.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00063",
                  "2) Évacuer",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00064",
                  "S’informer de l’existence d’un plan d’évacuation et décider avec le responsable de sa mise en œuvre.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00065",
                  "S’assurer que l’itinéraire d’évacuation a été soigneusement contrôlé.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00066",
                  "Ne jamais laisser une garde statique près d’un objet/engin/véhicule suspect.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00067",
                  "Toujours envisager un second engin à proximité après une première explosion.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00068",
                  "Ne pas lever le dispositif de sécurité sans ordre des autorités (après avis démineurs). Maintien environ 1 h en cas de fausse alerte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00069",
                  "Traiter les blessés en liaison avec les services médicaux et préserver les traces/indices.",
                ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00070",
                  "3) Réglementer",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00071",
                  "Faciliter l’accès des démineurs : itinéraire préférentiel, gestion circulation, point de rendez-vous clair.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00072",
                  "Écarter les curieux, canaliser les flux, maintenir le périmètre.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ALERTE A LA BOMBE
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00073",
              "VI — Alerte à la bombe : message & exploitation",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00074",
                  "1) Supports possibles",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00075",
                      "Une alerte peut être directe ou indirecte (appel au 17 ou via un tiers). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00076",
                      "Supports : téléphone, fax, mail, vidéo, lettre, message…",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00077",
                  "2) Documents écrits",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00078",
                  "Éviter de manipuler excessivement et de écrire dessus (traces papillaires, foulage…).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00079",
                  "3) Audio / vidéo",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00080",
                  "Éviter de laisser les supports près d’une source de rayonnement ou champ magnétique (radiateur, écran, aimant…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00081",
                  "Éviter les arrêts intempestifs sur l’enregistrement original.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00082",
                  "4) Message téléphoné : relever les détails",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00083",
                  "Origine : appel direct anonyme / indirect, numéro si possible, identité du requérant.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00084",
                  "Sexe, caractéristiques de la voix (grave, déformée, joyeuse/ivresse, enrouée…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00085",
                  "Accent, élocution (rapide, lente, claire, en colère…), termes employés (ordinaires, argotiques, obscènes…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00086",
                  "Bruits de fond : bureau, usine, rue, gare, aéroport, bar, dispute…",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00087",
                      "Si téléphone mobile abandonné : éviter toute manipulation intempestive.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00088",
              "VII — Procédure de recherche (alerte à la bombe)",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00089",
                      "En cas d’alerte à la bombe, une opération de recherche doit être menée sous la responsabilité du maître des lieux ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00090",
                      "ou de son représentant afin de localiser un éventuel objet non identifié.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00091",
                      "Tout objet découvert est traité comme un engin explosif : appliquer immédiatement les consignes « objet/engin suspect ».",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // GLOSSAIRE (propre et clair)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00092",
              "VIII — Glossaire (définitions opérationnelles)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00093",
                  "Objet suspect",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00094",
                      "Objet de forme/nature quelconque déclaré suspect, contenu inconnu : peut être actif (EEI, ENRI, EBI, ECI), ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00095",
                      "inerte (leurre) ou simple bagage abandonné/oublié sans risque.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00096",
                  "Engin suspect",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00097",
                  "Objet déclaré suspect dont le contenu est connu : peut être actif (EEI, ENRI, EBI, ECI) ou inactif (leurre).",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00098",
                  "Bagage abandonné / bagage oublié",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00099",
                      "Terminologie non employée par les services de déminage (souvent utilisée en transport). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00100",
                      "À l’instant où le bagage est signalé aux démineurs, il devient un objet suspect.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00101",
                  "Dislocation / démantèlement",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00102",
                  "Opération visant à séparer les composants d’un engin suspect afin de le rendre inoffensif.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Neutralisation"),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00103",
                  "Action permettant de séparer les composants d’un engin improvisé.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle("Sigles"),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00104",
                  "ENRI : Engin nucléaire ou radiologique improvisé",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00105",
                  "ECI : Engin chimique improvisé",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00106",
                  "EBI : Engin biologique improvisé",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00107",
                  "EEI : Engin explosif improvisé",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00108",
                  "Leurre : engin « ressemblant » mais ne pouvant fonctionner nominalement (explosif inerte, élément manquant…).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Résumé ultra clair
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
              "f00109",
              "En résumé (réflexe primo-intervenant)",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00110",
                  "Ne touche pas. Ne déplace pas. Ne manipule pas.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00111",
                  "Périmètre. Filtrage. Évacuation maîtrisée.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00112",
                  "Alerte C.I.C immédiate → déminage uniquement dans la zone.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                  "f00113",
                  "Rendre compte. Préserver les traces/indices. Prévoir un second engin.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/policier_intervention_initial/autres/alertes_a_la_bombe_page.dart",
                      "f00114",
                      "Les distances sont des repères : elles peuvent être élargies sur demande des démineurs.",
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
