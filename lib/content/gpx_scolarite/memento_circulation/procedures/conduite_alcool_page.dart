import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class ConduiteAlcoolPage extends StatelessWidget {
  const ConduiteAlcoolPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/procedures/conduite_alcool';

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
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardProc = isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF6F7FB);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);

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
            "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
            "f00002",
            "Mémento — circulation",
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
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00003",
              "Conduite sous l’influence de l’alcool",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00004",
              "I — Élément légal",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00005",
                    "Articles L. 234-1 et L. 234-8 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00006",
                    "article R. 234-1 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00007",
                    "article L. 3354-2 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00008",
                          "Deux grands blocs : C.E.E.A. (taux mesuré) + C.E.I. (ivresse manifeste). ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00009",
                          "Les vérifications (éthylomètre / sang) sont le cœur de la preuve.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Définition / panorama
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00010",
              "II — Définition & faits réprimés",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00011",
                  "C.E.E.A. — Conduite sous l’empire d’un état alcoolique",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00012",
                      "Infraction fondée sur la constatation d’un taux d’alcool dans l’air expiré ou dans le sang. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00013",
                      "Selon les seuils, l’infraction est délictuelle ou contraventionnelle.",
                    ),
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00014",
                  "C.E.I. — Conduite en état d’ivresse manifeste",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00015",
                      "Infraction fondée sur des signes extérieurs (haleine alcoolisée, propos incohérents, titubation, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00016",
                      "somnolence, etc.). Elle est indépendante du taux d’alcool : le taux peut être inférieur au seuil légal.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel : vérifications / modes / seuils
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00017",
              "III — Élément matériel (preuve & seuils)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00018",
                  "A) Obligation de se soumettre aux vérifications",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00019",
                      "Le conducteur (ou l’accompagnateur d’un élève conducteur) doit se soumettre aux vérifications ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00020",
                      "destinées à établir l’état alcoolique :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00021",
                      "• lorsque la loi permet des vérifications sans dépistage préalable ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00022",
                      "• en cas de dépistage positif ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00023",
                      "• en cas de refus de dépistage.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "IMPORTANT",
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00024",
                      "Sauf impossibilité, les vérifications sont réalisées à l’éthylomètre. En cas d’impossibilité (incapacité physique attestée par médecin), prélèvement sanguin.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00025",
                  "B) Seuils de qualification (taux retenu)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00026",
                      "Les seuils ci-dessous déterminent la qualification (délit / contravention). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00027",
                      "Le taux retenu est calculé après soustraction de la marge d’erreur.",
                    ),
              ),
              const SizedBox(height: 10),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00028",
                  "Seuils délictuels (C.E.E.A.)",
                ),
                cardColor: cardProc,
                accent: accentGrey,
                titleColor: textMain,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00029",
                        "Délit si : ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00030",
                        "≥ 0,40 mg/l",
                      ),
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00031",
                        " d’air expiré ",
                      ),
                    ),
                    TextSpan(
                      text: "ou",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(text: " "),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00032",
                        "≥ 0,80 g/l",
                      ),
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00033",
                        " de sang. — ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00034",
                        "L. 234-1 du Code de la route",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 12),

              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00035",
                  "Seuils contraventionnels (C.E.E.A.)",
                ),
                cardColor: cardProc,
                accent: accentGrey,
                titleColor: textMain,
                children: [
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00036",
                      "1) Conducteurs à seuil abaissé",
                    ),
                  ),
                  _Paragraph(
                    ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00037",
                          "Concerne notamment :\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00038",
                          "• transport en commun ;\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00039",
                          "• droit de conduire limité aux véhicules équipés E.A.D. ;\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00040",
                          "• permis probatoire ;\n",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00041",
                          "• apprentissage de la conduite (élève conducteur / accompagnateur).",
                        ),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00042",
                      "Contravention si ≥ 0,10 mg/l et < 0,40 mg/l (air expiré) OU ≥ 0,20 g/l et < 0,80 g/l (sang).",
                    ),
                  ),
                  SizedBox(height: 10),
                  _SubTitle(
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00043",
                      "2) Autres conducteurs / accompagnateur",
                    ),
                  ),
                  _BulletPoint(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00044",
                      "Contravention si ≥ 0,25 mg/l et < 0,40 mg/l (air expiré) OU ≥ 0,50 g/l et < 0,80 g/l (sang).",
                    ),
                  ),
                  SizedBox(height: 10),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00045",
                        "Référence : ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00046",
                        "R. 234-1 du Code de la route",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                        "f00047",
                        " (contravention 4e classe).",
                      ),
                    ),
                  ]),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00048",
                  "C) Vérifications par éthylomètre (règles clés)",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00049",
                  "Deux fonctionnaires procèdent au contrôle.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00050",
                  "Mentionner l’identification de l’éthylomètre et la date de dernière vérification en procédure.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00051",
                  "Notifier immédiatement : taux affiché (mesuré) + taux retenu (après marge d’erreur).",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00052",
                  "MARGE D’ERREUR (arrêté du 08/07/2003)",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00053",
                      "• Taux affiché < 0,40 mg/l : soustraire 0,032 mg/l.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00054",
                      "• Entre 0,40 et 2 mg/l : soustraire 8 %.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00055",
                      "• > 2 mg/l : soustraire 30 %.\n",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00056",
                      "Puis arrondir à la 2e décimale inférieure.",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00057",
                  "Second contrôle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00058",
                    "L’intéressé peut demander un second contrôle ; les agents peuvent aussi le décider d’office. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00059",
                    "R. 234-4 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00060",
                  "RÈGLE",
                ),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00061",
                          "Si le taux retenu du second contrôle est inférieur au premier, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00062",
                          "c’est lui qui détermine la nature de l’infraction.",
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00063",
                  "D) Vérifications par prélèvement sanguin (quand ? + procédure)",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00064",
                      "Recours au sang lorsque l’éthylomètre est impossible (panne/indisponible) ou lorsque :\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00065",
                      "• blessure grave / décès ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00066",
                      "• ivresse manifeste empêchant de souffler ;\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00067",
                      "• incapacité physique attestée par médecin.",
                    ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "MINEUR",
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00068",
                          "Pour un mineur : prélèvement sanguin uniquement après autorisation du parquet ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00069",
                          "ou de la personne ayant autorité. Mentionner l’autorisation ou l’impossibilité de l’obtenir rapidement.",
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00070",
                  "Conduire à l’hôpital + réquisition médecin/infirmier + fiche A (comportement) + fiches B-C (constatations).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00071",
                  "Assister au prélèvement, sceller les flacons, faire apposer les signatures (ou mentionner refus/incapacité).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral : ici = intention pas nécessaire; mais on explique logique + CEI
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00072",
              "IV — Élément moral (logique pénale)",
            ),
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00073",
                      "En pratique, ces infractions reposent sur un constat objectif (taux) ou des signes extérieurs (ivresse manifeste). ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00074",
                      "L’élément déterminant est la matérialité des constatations et la régularité de la procédure.",
                    ),
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00075",
                  "C.E.I. : signes extérieurs suffisent (haleine alcoolisée, élocution hésitante, titubation, somnolence…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00076",
                  "Même en C.E.I., l’auteur présumé doit être soumis aux vérifications (éthylomètre ou sang si impossible).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Aggravantes / alcool + stup
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00077",
              "V — Circonstances aggravantes & cumul stupéfiants",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00078",
                    "Alcool + stupéfiants : une alcoolémie supérieure aux seuils aggrave les peines du délit de conduite après usage de stupéfiants. — ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00079",
                    "L. 235-1 alinéa 2 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00080",
                  "Dans tous les cas liés à l’alcool : procéder aussi au dépistage stupéfiants (et vérifications si nécessaire).",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité + refus
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00081",
              "VI — Tentative, complicité & refus",
            ),
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00082",
                  "Refus de se soumettre aux vérifications (délit)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00083",
                    "Refus C.R. : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00084",
                    "L. 234-8 du Code de la route",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00085",
                    " — puni de 2 ans d’emprisonnement et 4 500 € d’amende.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00086",
                    "Refus C.S.P. : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00087",
                    "L. 3354-2 du Code de la santé publique",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00088",
                    " — puni de 1 an d’emprisonnement et 3 750 € d’amende.",
                  ),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00089",
                  "À SAVOIR",
                ),
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                      "f00090",
                      "Le refus de dépistage n’est pas une infraction : il entraîne l’obligation de se soumettre aux vérifications.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00091",
                  "Tentative & complicité",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00092",
                  "Tentative : non pertinente ici (infraction consommée dès la conduite sous influence / constat).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00093",
                    "Complicité : possible selon les règles générales de complicité. ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00094",
                    "Articles 121-6 et 121-7 du Code pénal",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Table NATINF (délits + contraventions)
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00095",
              "VII — NATINF (repères opérationnels)",
            ),
            cardColor: cardProc,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _NatinfAlcoolTable(),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00096",
                          "Les A.P.J.A. ne sont pas habilités à constater par procès-verbal les délits et contraventions ",
                        ) +
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                          "f00097",
                          "en matière de conduite sous l’influence de l’alcool.",
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                "f00098",
                "Mis à jour le ",
              ),
            ),
            TextSpan(
              text: "15/06/2025",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            TextSpan(text: "."),
          ]),
        ],
      ),
    );
  }
}

class _NatinfAlcoolTable extends StatelessWidget {
  const _NatinfAlcoolTable();

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color headerBg = isDark
        ? const Color(0xFF101010)
        : const Color(0xFFF0F0F0);
    final Color rowBg = isDark ? const Color(0xFF151515) : Colors.white;
    final Color border = isDark ? Colors.white12 : Colors.black12;
    final Color text = isDark ? Colors.white : const Color(0xFF111111);
    final Color subText = isDark ? Colors.white70 : const Color(0xFF444444);

    Widget headerCell(
      String t, {
      int flex = 3,
      TextAlign align = TextAlign.left,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 13.5,
            color: text,
          ),
        ),
      );
    }

    Widget cell(
      String t, {
      int flex = 3,
      TextAlign align = TextAlign.left,
      bool strong = false,
    }) {
      return Expanded(
        flex: flex,
        child: Text(
          t,
          textAlign: align,
          style: GoogleFonts.fustat(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            fontSize: 13.5,
            color: subText,
            height: 1.25,
          ),
        ),
      );
    }

    Widget row({
      required String natinf,
      required String intitule,
      required List<TextSpan> refSpans,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: rowBg,
          border: Border(top: BorderSide(color: border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cell(natinf, flex: 2, strong: true),
            const SizedBox(width: 8),
            cell(intitule, flex: 7),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: GoogleFonts.fustat(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: subText,
                    height: 1.25,
                  ),
                  children: refSpans,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                headerCell("NATINF", flex: 2),
                const SizedBox(width: 8),
                headerCell("Fait", flex: 7),
                const SizedBox(width: 8),
                headerCell(
                  ScolariteText.value(
                    "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                    "f00099",
                    "Réf.",
                  ),
                  flex: 4,
                  align: TextAlign.right,
                ),
              ],
            ),
          ),

          // DÉLITS
          row(
            natinf: "1247",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00100",
              "Conduite sous l’empire d’un état alcoolique (≥ 0,80 g/l sang ou ≥ 0,40 mg/l air)",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00101",
                  "L. 234-1 CR",
                ),
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          row(
            natinf: "41",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00102",
              "Conduite en état d’ivresse manifeste",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00103",
                  "C.E.I.",
                ),
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          row(
            natinf: "51",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00104",
              "Refus de se soumettre aux vérifications tendant à établir l’état alcoolique (Code de la route)",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00105",
                  "L. 234-8 CR",
                ),
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          row(
            natinf: "2000",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00106",
              "Refus de se soumettre aux vérifications (cas prévus par le Code de la santé publique)",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00107",
                  "L. 3354-2 CSP",
                ),
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
            ],
          ),

          // CONTRAVENTIONS (regroupées)
          row(
            natinf: "25434",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00108",
              "Conduite avec alcool ≥ 0,10 mg/l (air) / 0,20 g/l (sang) — conducteurs à seuil abaissé",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00109",
                  "R. 234-1 CR",
                ),
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          row(
            natinf: "33329",
            intitule: ScolariteText.value(
              "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
              "f00110",
              "Conduite avec alcool ≥ 0,25 mg/l (air) / 0,50 g/l (sang) — autres conducteurs",
            ),
            refSpans: [
              TextSpan(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/memento_circulation/procedures/conduite_alcool_page.dart",
                  "f00111",
                  "R. 234-1 CR",
                ),
                style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
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
