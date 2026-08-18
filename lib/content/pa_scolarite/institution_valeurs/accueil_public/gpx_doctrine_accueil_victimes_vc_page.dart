import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaGpxDoctrineAccueilVictimesVcPage extends StatelessWidget {
  const PaGpxDoctrineAccueilVictimesVcPage({super.key});

  static const String routeName = '/pa/institution/accueil_public/doctrine';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardIntro = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardBlue = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardGreen = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardAmber = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardPink = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);

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
            "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
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
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00003",
              "Doctrine relative à l’accueil et la prise en charge des victimes de violences conjugales",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00004",
              "Mise à jour : décembre 2021",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Élément légal / base (en haut, comme tu veux)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00005",
              "Base juridique à connaître (en priorité)",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00006",
                    "Articles 10-2 à 10-5 du Code de procédure pénale",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00007",
                    " : encadrent les droits des victimes (information, interprète, accompagnement, évaluation personnalisée).",
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00008",
                  "Ces articles servent de repère immédiat pour l’accueil, l’information et l’orientation.",
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00009",
                    "À retenir : ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00010",
                    "le recueil des déclarations ne dépend jamais d’un certificat médical",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // 1. Propos liminaires
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00011",
              "1 — Propos liminaires",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00012",
                      "Le Grenelle « lutte contre les violences conjugales » (lancé le 3 septembre 2019) a conduit à renforcer ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00013",
                      "les dispositifs d’accueil, de prise en charge et de sécurisation des victimes. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00014",
                      "La mission d’accueil du public a été professionnalisée (référents accueil, formation dédiée). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00015",
                      "Des policiers spécialisés (GPF / unités de protection de la famille) sont formés à ce contentieux et s’appuient ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00016",
                      "sur les associations, ISC, psychologues et permanences locales.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2. Prise en charge
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00017",
              "2 — La prise en charge des victimes",
            ),
            cardColor: cardBlue,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00018",
                  "2.1 Dans les services de police",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00019",
                  "2.1.1 Le TAC (Tableau Accueil-Confidentialité)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00020",
                      "Dispositif visant à renforcer la confidentialité dès l’accueil : la victime indique une couleur correspondant ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00021",
                      "au motif de sa venue (ex. violences sexuelles / conjugales / intrafamiliales). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00022",
                      "En cas de situation sensible, la prise en charge est priorisée de manière discrète.",
                    ),
              ),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00023",
                  "Objectif : éviter l’exposition, préserver la discrétion, déclencher une prise en compte prioritaire sans verbalisation publique.",
                ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00024",
                  "2.1.2 Le recueil des déclarations",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00025",
                      "Dès qu’elle est identifiée comme victime, la personne doit être reçue dans un lieu sécurisant et confidentiel. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00026",
                      "Les personnels doivent faire preuve de discernement, neutralité, absence de jugement, et soutenir la démarche de plainte.",
                    ),
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00027",
                  "Règle",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00028",
                      "Le recueil des déclarations ne doit en aucun cas être subordonné à la présentation préalable d’un certificat médical.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00029",
                    "Accompagnement : la victime peut être accompagnée par une personne majeure de son choix, ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00030",
                    "article 10-2 8° du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00031",
                    "Domiciliation : possibilité de choisir l’adresse d’un tiers avec accord exprès, ",
                  ),
                ),
                _law(
                  ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                    "f00032",
                    "article 10-2 9° du Code de procédure pénale",
                  ),
                ),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00033",
                  "Principe : plainte ou audition",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00034",
                      "Le policier incite fortement la victime à déposer plainte ; à défaut, elle peut faire l’objet d’une audition. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00035",
                      "La qualité de la première prise en charge conditionne la confiance, la suite procédurale et l’efficacité de l’enquête.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00036",
                  "Exception : MCI / mention / PV",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00037",
                      "La MCI n’est utilisée qu’en cas de refus explicite de plainte/audition et si aucun fait grave n’est révélé. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00038",
                      "Le refus doit être mentionné. Si la victime souhaite partir après un recueil minimal, une mention détaillée est rédigée ; ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00039",
                      "si des faits graves sont révélés, un PV de saisine peut être établi.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00040",
                  "2.2 Prise de déclaration en milieu hospitalier",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00041",
                      "Des conventions permettent le dépôt de plainte à l’hôpital lorsque l’état de santé empêche le déplacement. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00042",
                      "L’établissement doit garantir confort, dignité et confidentialité ; il met à disposition un local et les moyens nécessaires ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00043",
                      "en complément des outils numériques des enquêteurs.",
                    ),
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00044",
                  "2.3 Portail de signalement (violences sexuelles et sexistes)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00045",
                      "Accessible 24h/24 – 7j/7 via service-public.fr : échange par tchat avec des policiers formés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00046",
                      "Quand des éléments pénaux existent, un signalement est rédigé et transmis au CIC pour prise de contact par le service compétent. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00047",
                      "En cas d’urgence, l’intervention est déclenchée sans délai (victime identifiée ou via localisation IP).",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 3. Sécurisation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00048",
              "3 — La sécurisation de la victime",
            ),
            cardColor: cardGreen,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00049",
                  "3.1 Interventions « police-secours » au domicile",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00050",
                      "Toute sollicitation pour violences conjugales/intrafamiliales est traitée en priorité. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00051",
                      "Les renseignements doivent être complets (présence d’armes, enfants, antécédents TAJ/MCI). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00052",
                      "Les primo-intervenants agissent avec prudence : les faits exacts et les moyens utilisés ne sont pas toujours connus.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00053",
                  "Deux situations typiques",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00054",
                  "Traces/indices apparents : interpellation de l’auteur pour présentation OPJ, préservation traces/indices, relevé témoins, enquête de voisinage, incitation à plainte/audition, transport commissariat si possible.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00055",
                  "Absence d’indices apparents : versions recueillies séparément, enquête de voisinage, doute → compte rendu à l’OPJ de permanence (consultation antécédents).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00056",
                  "3.2 Mise en sécurité",
                ),
              ),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00057",
                  "A) Hébergement d’urgence",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00058",
                      "Si la victime ne peut rester en sécurité au domicile : activation des dispositifs locaux (nuitées d’hôtel, 115). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00059",
                      "En cas d’indisponibilité du 115, consultation d’outils de géolocalisation des places d’hébergement d’urgence. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00060",
                      "Transport possible par équipage selon contraintes opérationnelles.",
                    ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00061",
                  "B) Récupération sécurisée d’effets personnels",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00062",
                      "Si la victime craint pour sa sécurité pour récupérer des effets personnels incontestables, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00063",
                      "elle peut solliciter l’assistance des policiers selon la disponibilité opérationnelle.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 4. Traitement procédure
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00064",
              "4 — Le traitement de la procédure",
            ),
            cardColor: cardAmber,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00065",
                  "4.1 Actes à réaliser lors de la prise de plainte",
                ),
              ),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00066",
                  "4.1.1 Évaluation du danger",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00067",
                      "À l’occasion d’une plainte, audition ou déclaration MCI, l’évaluation du danger est réalisée via une grille dédiée ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00068",
                      "(23 questions). Elle doit être complétée par le policier après questionnement : la remettre à la victime pour qu’elle la remplisse seule est proscrit.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Important",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00069",
                      "La grille complétée est jointe à la procédure (ou à la MCI) et transmise au parquet avec la plainte/audition (ou déclaration).",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00070",
                  "Danger caractérisé si : au moins 2 réponses « rouges » positives OU 12 réponses positives (toutes couleurs).",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00071",
                  "4.1.2 Consultation des fichiers (systématique)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00072",
                  "Les consultations permettent d’éclairer l’OPJ et l’autorité judiciaire, surtout quand une situation à risque est identifiée.",
                ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00073",
                  "TAJ (traitement des antécédents judiciaires)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00074",
                  "MCI (main courante informatisée)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00075",
                  "FPR (fichier des personnes recherchées)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00076",
                  "LRPPN (base locale procédures)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00077",
                  "AGRIPPA (armes déclarées)",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00078",
                  "4.1.3 Avis systématique hiérarchie + parquet",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00079",
                      "Plainte/audition/MCI : avis parquet après avis hiérarchique, avec grille danger. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00080",
                      "Les situations dangereuses font l’objet d’un avis téléphonique systématique au parquet.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00081",
                  "Exemples (non exhaustifs) : antécédents violences conjugales, rupture envisagée, conflit garde/enfants, grossesse, accès possible à arme à feu.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00082",
                  "4.1.4 Réquisition examen médical",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00083",
                  "Si enquête ouverte : prise de rendez-vous UMJ et remise d’une réquisition pour descriptif lésions + retentissement psychologique.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00084",
                  "4.1.5 Saisie des armes (systématique dès la première plainte)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00085",
                      "La recherche et saisie d’armes en possession de l’auteur est un axe majeur, notamment en perquisition. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00086",
                      "La consultation AGRIPPA est un préalable utile à l’interpellation et à la perquisition.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00087",
                  "4.2 Document d’information aux victimes (systématique)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00088",
                      "Remise d’un document (A4 ou carte de visite) avec coordonnées locales : ISC, psychologues, associations. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00089",
                      "Remise possible au commissariat, à l’hôpital, et lors d’intervention à domicile si cela peut être fait discrètement.",
                    ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00090",
                  "4.3 Priorisation des procédures",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00091",
                      "Les situations dangereuses sont traitées en priorité. La hiérarchie distingue les dossiers à traiter immédiatement, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00092",
                      "précise les diligences et contrôle l’exécution.",
                    ),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00093",
                  "Localisation/interpellation auteur (initiative ou parquet)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00094",
                  "Consultations fichiers (TAJ/MCI/FPR/LRPPN/AGRIPPA)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00095",
                  "Perquisition + recherche/saisie armes",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00096",
                  "Propositions de protection (BAR, TGD) si nécessaire",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 5. Dispositifs judiciaires
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00097",
              "5 — Dispositifs judiciaires de protection",
            ),
            cardColor: cardPink,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00098",
                  "5.1 Bracelet anti-rapprochement (BAR)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00099",
                      "La victime est informée qu’elle peut demander ce dispositif. Il peut être mis en place dans une procédure pénale ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00100",
                      "(avant ou après jugement) ou civile (ordonnance de protection). L’autorité judiciaire fixe des zones ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00101",
                      "(protection / pré-alerte / alerte) et inscription FPR.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00102",
                  "Si l’auteur entre dans la zone : conseils de mise en sûreté + avis CIC → déclenchement intervention.",
                ),
              ),
              SizedBox(height: 10),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00103",
                  "Priorité opérationnelle",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00104",
                  "Protéger la victime : elle est mise en sûreté dès qu’elle est protégée par l’équipage ou que l’auteur est sorti des zones.",
                ),
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00105",
                  "5.2 Ordonnance de protection (JAF) & saisie des armes",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00106",
                      "Après ordonnance de protection interdisant port/détention d’armes : notification rapide, convocation sous 1 jour ouvré, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00107",
                      "accompagnement domicile pour remise. En cas de refus/carence : ouverture enquête pour violation.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 6. Partenariat & coordination
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00108",
              "6 — Partenariat & coordination des acteurs",
            ),
            cardColor: cardBlue,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00109",
                  "6.1 Officier référent & coordination parquet",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00110",
                      "Un officier référent « violences intrafamiliales » est désigné. Il contrôle l’application des instructions, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00111",
                      "le suivi des portefeuilles, la qualité des investigations et les délais. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00112",
                      "La coordination vise une circulation fiable de l’information et une réponse cohérente avec les partenaires.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00113",
                  "6.2 Participation aux instances locales",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00114",
                      "Participation aux instances de coordination stratégique (co-présidées préfet/procureur) et opérationnelle ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00115",
                      "(pilotage parquet) afin d’assurer un suivi individuel des situations.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 7. Formation
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00116",
              "7 — Formation des policiers",
            ),
            cardColor: cardGreen,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00117",
                      "Un parcours renforcé est proposé aux primo-accueillants (emprise, évaluation danger, interventions domicile). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00118",
                      "Les chefs de service veillent à l’accès à ces formations et à la prise en compte par les généralistes comme les spécialisés. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00119",
                      "Des formations interprofessionnelles magistrats/enquêteurs renforcent l’efficacité et l’alignement des pratiques.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mémo ultra opérationnel (pédagogique)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
              "f00120",
              "Mémo opérationnel — Accueil d’une victime de violences conjugales",
            ),
            cardColor: cardIntro,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle("Objectif"),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00121",
                      "Un traitement procédural de qualité ne peut fonctionner que si la victime bénéficie d’un accueil adapté. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00122",
                      "La réussite de l’enquête dépend fortement de la qualité de cette première prise en charge.",
                    ),
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00123",
                  "Les 3 réflexes à appliquer",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00124",
                  "1) Accueillir sans délai, sans condition (pas de pièce d’identité, pas de certificat médical, hors ressort, etc.).",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00125",
                  "2) Mettre la victime à l’abri (confidentialité), limiter l’attente et éviter la multiplication d’intervenants.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00126",
                  "3) Orienter vers un enquêteur référent (GPF) si possible, et remettre le document d’information victimes.",
                ),
              ),

              SizedBox(height: 12),

              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                  "f00127",
                  "Droits des victimes",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00128",
                      "Ils doivent être expliqués dès le début (information, accompagnement, interprète, évaluation). Références : ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/accueil_public/gpx_doctrine_accueil_victimes_vc_page.dart",
                      "f00129",
                      "articles 10-2 à 10-5 du Code de procédure pénale",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
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
