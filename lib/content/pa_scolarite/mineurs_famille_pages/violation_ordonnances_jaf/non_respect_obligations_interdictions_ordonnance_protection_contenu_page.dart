import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaNonRespectObligationsInterdictionsOrdonnanceProtectionPage
    extends StatelessWidget {
  const PaNonRespectObligationsInterdictionsOrdonnanceProtectionPage({
    super.key,
  });

  static const String routeName =
      '/pa/dps_dpg/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
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
            "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
            "f00002",
            "Violation d’ordonnances JAF",
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
              "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
              "f00003",
              "Le non-respect des obligations ou interdictions imposées par une ordonnance de protection",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
              "f00004",
              "Définition",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00005",
                    "Le fait, pour une personne faisant l’objet d’une ou plusieurs obligations ou interdictions imposées dans une ordonnance de protection rendue en application des ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00006",
                    "articles 515-9 ou 515-13 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00007",
                    ", ou dans une ordonnance provisoire de protection immédiate rendue en application de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00008",
                    "l’article 515-13-1 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00009",
                    ", de ne pas s’y conformer, constitue une infraction.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00010",
                  "Extension UE",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00011",
                      "Les mêmes peines s’appliquent à la violation d’une mesure de protection civile prononcée dans un autre État membre de l’Union européenne, reconnue et exécutoire en France en application du ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00012",
                      "règlement (UE) n° 606/2013 du Parlement européen et du Conseil du 12 juin 2013",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00013",
                      " relatif à la reconnaissance mutuelle des mesures de protection en matière civile.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal (en haut)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
              "f00014",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00015",
                    "Article 227-4-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00016",
                    " : définit et réprime le non-respect des obligations ou interdictions imposées par une ordonnance de protection.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
              "f00017",
              "II — Élément matériel",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00018",
                    "Les mesures de protection des victimes de violences sont développées aux ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00019",
                    "articles 515-9 à 515-13 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00020",
                    ". Elles renforcent les pouvoirs du juge aux affaires familiales afin d’éloigner l’auteur des violences du cadre de vie de la victime, y compris hors mariage.",
                  ),
                ),
              ]),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00021",
                  "A) Une personne soumise à des obligations / interdictions",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00022",
                    "Article 515-9 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00023",
                    " : lorsque des violences au sein du couple (même sans cohabitation) ou commises par un ex-conjoint/ex-partenaire/ex-concubin mettent en danger la victime ou ses enfants, le JAF peut délivrer en urgence une ordonnance de protection.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00024",
                      "L’ordonnance de protection est délivrée dans un délai maximal de six jours à compter de la fixation de la date d’audience, si le juge estime les violences vraisemblables et le danger établi. Elle n’est pas conditionnée à un dépôt de plainte pénale.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00025",
                  "B) Des mesures précises fixées par le juge",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00026",
                    "Pour une durée maximale de 12 mois (prolongeable sous conditions), le juge peut ordonner des mesures conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00027",
                    "l’article 515-12 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00028",
                    ", notamment celles prévues par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00029",
                    "l’article 515-11 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 10),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00030",
                  "Interdiction de recevoir/rencontrer certaines personnes désignées, ou d’entrer en relation avec elles, de quelque façon que ce soit.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00031",
                  "Interdiction de se rendre dans certains lieux désignés où se trouve habituellement la partie demanderesse.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00032",
                  "Interdiction de détenir ou porter une arme ; remise des armes.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00033",
                  "Proposition de prise en charge sanitaire/sociale/psychologique ou stage de responsabilisation (information du procureur en cas de refus).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00034",
                  "Mesures sur la résidence séparée, la jouissance du logement, et la prise en charge des frais afférents.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00035",
                  "Attribution possible de la jouissance de l’animal de compagnie au sein du foyer.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00036",
                  "Mesures sur l’autorité parentale, droit de visite/hébergement et contributions (charges du mariage, aide matérielle, entretien/éducation des enfants).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00037",
                  "Dissimulation du domicile/résidence et élection de domicile (avocat, procureur, personne morale qualifiée) selon les cas.",
                ),
              ),
              SizedBox(height: 12),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00038",
                    "Lorsque l’interdiction prévue au 1° de l’article 515-11 est prononcée, le juge peut également fixer une interdiction de se rapprocher et ordonner le port d’un dispositif anti-rapprochement, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00039",
                    "l’article 515-11-1 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00040",
                  "C) L’existence d’une ordonnance provisoire de protection immédiate",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00041",
                    "Article 515-13-1 du code civil",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00042",
                    " : lorsque le JAF est saisi d’une demande d’ordonnance de protection, le ministère public peut, avec l’accord de la personne en danger, demander une ordonnance provisoire de protection immédiate.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00043",
                  "Elle peut être délivrée dans un délai de vingt-quatre heures, au vu des seuls éléments joints à la requête, si des raisons sérieuses rendent vraisemblables les violences et le danger grave et immédiat.",
                ),
              ),
              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00044",
                  "D) Une violation : le non-respect concret des obligations",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00045",
                      "L’infraction sanctionne le non-respect effectif d’une ou plusieurs obligations/interdictions fixées par le juge. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00046",
                      "Le texte vise à rendre l’ordonnance pleinement contraignante et opérationnelle, afin de garantir la protection de la victime.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
              "f00047",
              "III — Élément moral",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00048",
                  "Volonté de ne pas se conformer",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00049",
                      "Il s’agit d’une infraction intentionnelle : l’auteur agit en pleine connaissance de cause des obligations ou interdictions ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00050",
                      "dont il fait l’objet. Il doit avoir été informé des termes de l’ordonnance de protection délivrée par le juge.",
                    ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                      "f00051",
                      "En pratique : la caractérisation repose sur la preuve que la personne connaissait la décision (notification, audience contradictoire, remise, etc.) et a néanmoins violé une ou plusieurs mesures.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
              "f00052",
              "IV — Circonstances aggravantes",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00053",
                  "Aucune circonstance aggravante prévue pour cette infraction.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression + tentative/complicité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
              "f00054",
              "V — Répression",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00055",
                  "Peines encourues — personnes physiques",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00056",
                    "Délit — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00057",
                    "article 227-4-2 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " :"),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00058",
                  "3 ans d’emprisonnement.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00059",
                  "45 000 € d’amende.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00060",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                  "f00061",
                  "Tentative : NON.",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00062",
                    "Complicité : OUI, conformément à ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00063",
                    "l’article 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/mineurs_famille_pages/violation_ordonnances_jaf/non_respect_obligations_interdictions_ordonnance_protection_contenu_page.dart",
                    "f00064",
                    ". Elle suppose un des faits constitutifs de complicité prévus par la loi (aide/assistance, provocation, instructions).",
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
