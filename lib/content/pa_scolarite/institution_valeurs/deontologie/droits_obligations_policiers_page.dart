import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaDroitsObligationsPoliciersPage extends StatelessWidget {
  const PaDroitsObligationsPoliciersPage({super.key});

  static const String routeName =
      '/pa/institution/deontologie/droits_obligations';

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
            "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
            "f00002",
            "Déontologie",
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
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00003",
              "Les droits et obligations des policiers",
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Contexte
          _ConditionCard(
            title: "Contexte",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00004",
                      "Le Code général de la fonction publique (CGFP) garantit des droits et fixe des obligations aux agents publics. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00005",
                      "Qu’ils soient fonctionnaires ou agents contractuels (ex. policiers adjoints), les policiers y sont soumis.\n\n",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00006",
                      "D’autres textes (CSI, RGEPN…) prévoient des dispositions spécifiques à la fonction policière. ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00007",
                      "Le respect des valeurs du code de déontologie conditionne la légitimité et l’efficacité de l’action policière.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Références / “élément légal” en haut
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00008",
              "Références principales",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00009",
                  "Textes de base",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00010",
                  "Code général de la fonction publique (CGFP) : droits & obligations des agents publics.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00011",
                  "Code de la sécurité intérieure (CSI) : règles déontologiques et particularités policières.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00012",
                  "Règlement général d’emploi de la Police nationale (RGEPN) : cadre interne (hiérarchie, réserve, discipline…).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00013",
                      "Avant la prise de fonctions, tout agent de la Police nationale prête serment : servir avec dignité et loyauté la République, ses principes et sa Constitution.",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I — Droits et obligations “fonction publique”
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00014",
              "I — Statut de la fonction publique",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00015",
                      "Cette partie regroupe les garanties et obligations applicables à tous les agents publics, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00016",
                      "avec des points d’attention propres à la fonction policière.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // A — Garanties générales
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00017",
              "A) Garanties générales (droits)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00018",
                  "1) Liberté d’opinion",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00019",
                    "Garantie par le ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00020",
                    "CGFP (art. L. 111-1 et L. 137-2)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00021",
                    " : la liberté d’opinion est garantie aux agents publics.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00022",
                  "Les opinions (politiques, syndicales, religieuses, philosophiques) ne doivent pas figurer dans le dossier individuel.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00023",
                  "2) Liberté d’expression",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00024",
                    "Prévue par le ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00025",
                    "CGFP (art. L. 121-2)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00026",
                  "Dans le service : neutralité = liberté d’expression exclue dans l’exercice des fonctions.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00027",
                  "Hors service : liberté relative (opinions, engagements, manifestations…), avec limite = obligation de réserve.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00028",
                  "3) Non-discrimination",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00029",
                    "Interdiction via le ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00030",
                    "CGFP (art. L. 131-1 à L. 131-6, L. 133-1, L. 133-2)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00031",
                    " : aucune distinction directe/indirecte.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00032",
                  "Aucune discrimination (opinions, origine, orientation/identité de genre, âge, situation familiale, grossesse, santé, apparence, handicap…).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00033",
                  "Aucune distinction en raison du sexe.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00034",
                  "Aucun agent ne doit subir d’agissement sexiste.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00035",
                  "4) Droit syndical",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00036",
                    "Reconnu notamment par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00037",
                    "CSI (art. L. 411-3)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00038",
                    "CGFP (art. L. 113-1)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00039",
                    ", avec cadre ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00040",
                    "décret n° 82-447 du 28 mai 1982",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00041",
                    " + références RGEPN.",
                  ),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00042",
                  "Créer/adhérer/exercer des mandats syndicaux : oui, dans la défense des intérêts professionnels.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00043",
                  "Respect du secret professionnel et du secret de l’enquête et de l’instruction.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00044",
                  "Activité syndicale compatible avec le code de déontologie et le fonctionnement du service.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00045",
                  "5) Protection fonctionnelle",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00046",
                    "Prévue par le ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00047",
                    "CGFP (art. L. 134-1 à L. 134-11)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00048",
                    " et par le ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00049",
                    "CSI (art. R. 434-7)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00050",
                  "L’État défend l’agent contre attaques, menaces, violences, injures, diffamations, outrages…",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00051",
                  "Peut concerner aussi conjoint, enfants et ascendants directs.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00052",
                  "Si absence de faute personnelle : accompagnement et protection juridique en cas de poursuites.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // B — Obligations générales
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00053",
              "B) Obligations générales",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00054",
                  "1) Obéissance hiérarchique",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00055",
                    "Principe posé par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00056",
                    "CGFP (art. L. 121-10)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00057",
                    "CSI (art. R. 434-5)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00058",
                    " et références statutaires.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00059",
                  "Se conformer aux instructions du supérieur hiérarchique.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00060",
                  "Exception : ordre manifestement illégal et compromettant gravement un intérêt public.",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00061",
                  "Idée clé : la légalité prime sur le devoir d’obéissance (discipline + loyauté attendues).",
                ),
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00062",
                  "2) Secret professionnel & discrétion",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00063",
                    "Fondé sur ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00064",
                    "CGFP (art. L. 121-6 et L. 121-7)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00065",
                    ", et renforcé par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00066",
                    "RGEPN (113-10, 133-6)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " + "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00067",
                    "CSI (art. R. 434-8 et R. 434-12)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00068",
                  "La violation expose à sanctions pénales + disciplinaires, et peut engager la responsabilité civile.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00069",
                  "Respect du secret de l’enquête et de l’instruction + discrétion professionnelle.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00070",
                  "Interdiction de divulguer à une personne non autorisée (même en interne) des infos connues du fait des fonctions.",
                ),
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00071",
                      "Réseaux sociaux / blogs : l’usage doit rester compatible avec ces obligations. Ne pas rendre visibles des renseignements professionnels (opérations, modalités d’intervention, photos/propos portant atteinte à l’institution…).",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00072",
                  "3) Probité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00073",
                    "Prévue par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00074",
                    "CGFP (art. L. 121-1)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00075",
                    "CSI (art. R. 434-9)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00076",
                    " : agir avec désintéressement.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00077",
                  "Interdiction d’intérêts personnels opposés (même indirectement) à ceux de l’administration.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00078",
                  "Interdiction de se prévaloir de sa qualité pour obtenir un avantage personnel.",
                ),
              ),
              const SizedBox(height: 10),
              _ConditionCard(
                title: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00079",
                  "Infractions pénales typiques liées à la probité",
                ),
                cardColor: isDark
                    ? const Color(0xFF1B1B1B)
                    : const Color(0xFFFFFFFF),
                accent: accentGrey,
                titleColor: textMain,
                children: [
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00080",
                        "• Corruption — ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00081",
                        "art. 432-11 1° du Code pénal",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00082",
                        "• Trafic d’influence — ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00083",
                        "art. 432-11 2° du Code pénal",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00084",
                        "• Concussion — ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00085",
                        "art. 432-10 du Code pénal",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00086",
                        "• Prise illégale d’intérêts — ",
                      ),
                    ),
                    TextSpan(
                      text: ScolariteText.value(
                        "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                        "f00087",
                        "art. 432-12 du Code pénal",
                      ),
                      style: TextStyle(
                        color: _lawRed,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(text: "."),
                  ]),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II — Particularismes policiers
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00088",
              "II — Particularismes statutaires (fonction policière)",
            ),
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00089",
                      "Ces règles renforcent les exigences professionnelles : hiérarchie, réserve, dignité, impartialité, disponibilité… ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00090",
                      "Elles s’appliquent fortement aux policiers du fait de leurs missions d’ordre public.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00091",
              "A) Obligations générales (spécifiques police)",
            ),
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00092",
                  "1) Principe hiérarchique",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00093",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00094",
                    "CSI (art. R. 434-4)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " + "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00095",
                    "RGEPN (111-1, 111-6, 113-1, 131-4, 133-1)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00096",
                  "L’autorité hiérarchique donne des instructions précises.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00097",
                  "Le policier rend compte de l’exécution des ordres (ou des raisons de leur inexécution).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00098",
                  "Le policier rend compte de tout fait (service/hors service) pouvant entraîner convocation par autorité de police/juridiction/contrôle.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00099",
                      "Policiers adjoints : pas de principe hiérarchique entre eux. Ils sont subordonnés aux personnels sous l’autorité desquels ils sont placés — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00100",
                      "art. 131-1 RGEPN",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00101",
                  "2) Devoir de réserve",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00102",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00103",
                    "RGEPN (113-10, 133-6)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00104",
                    "CSI (art. R. 434-29)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00105",
                  "Plus stricte chez les policiers : modération dans l’expression des opinions en service et hors service.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00106",
                  "Un manque de retenue peut entraîner des sanctions disciplinaires.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00107",
                      "Les fonctionnaires candidats ou investis de responsabilités syndicales disposent d’une plus grande liberté d’expression.",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00108",
                  "3) Interdiction de faire grève (personnels actifs)",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00109",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00110",
                    "CGFP (art. L. 114-3)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00111",
                  "Disposition dérogatoire justifiée par l’ordre public : toute cessation concertée ou acte collectif d’indiscipline caractérisé peut être sanctionné.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00112",
                      "Policiers adjoints : droit de grève admis — ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00113",
                      "RGEPN (133-28)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00114",
                  "4) Dignité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00115",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00116",
                    "CGFP (art. L. 121-1)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00117",
                    "RGEPN (133-2, 133-7)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00118",
                    "CSI (art. R. 434-12)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00119",
                  "Comportement exemplaire en toute circonstance (service/hors service), y compris sur les réseaux sociaux.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00120",
                  "S’abstenir d’actes/propos/comportements nuisant à la considération portée à l’institution.",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00121",
                      "Exemple jurisprudentiel : révocation d’un GPX pour des échanges racistes/discriminatoires via messagerie. ",
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00122",
                      "(C.E., n° 474289, 28/12/2023)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00123",
                  "5) Indépendance",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00124",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00125",
                    "décret n° 95-654 (art. 59 et 60)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00126",
                    "RGEPN (113-12, 113-13)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00127",
                    "CSI (art. R. 434-12)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00128",
                  "Interdiction de se prévaloir de sa qualité pour collecter des fonds/dons ou mandater un intermédiaire.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00129",
                  "Interdiction de diffuser dans les locaux de police des publications/tracts à caractère raciste, xénophobe, politique, appelant à l’indiscipline…",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00130",
                  "6) Discernement & impartialité",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00131",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00132",
                    "CSI (art. R. 434-10 et R. 434-11)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00133",
                  "Choisir la meilleure réponse légale selon les risques/menaces et les délais d’action.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00134",
                  "Agir avec professionnalisme : équité, neutralité, laïcité, sans discrimination.",
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00135",
              "B) Obligations spécifiques (exemples)",
            ),
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00136",
                  "1) Activité du conjoint / concubin",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00137",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00138",
                    "décret n° 95-654 (art. 30)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: " et "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00139",
                    "RGEPN (111-6)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00140",
                      "L’autorité compétente peut prendre des mesures pour sauvegarder l’intérêt du service si l’activité du conjoint/concubin ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00141",
                      "jette le discrédit sur la fonction policière ou crée une équivoque préjudiciable.",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00142",
                  "2) Disponibilité",
                ),
              ),
              _Paragraph(
                ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00143",
                      "Le policier doit se rendre disponible tout au long du service, en conservant une attitude d’intérêt face aux demandes ",
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00144",
                      "(information, assistance, intervention).",
                    ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00145",
                  "3) Obligation de résidence",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00146",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00147",
                    "décret n° 95-654 (art. 24)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00148",
                  "Résider au lieu d’affectation (ou à distance permettant rappel inopiné dans les délais les plus brefs).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00149",
                  "Tout changement de résidence doit être signalé par voie hiérarchique, avec date.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00150",
                  "4) Obligation d’agir même hors service",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00151",
                    "Références : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00152",
                    "décret n° 95-654 (art. 19)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00153",
                    "CSI (art. R. 434-19)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: ", "),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00154",
                    "RGEPN (113-3, 132-2, 133-3)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00155",
                  "Devoir d’intervenir de sa propre initiative ou sur réquisition (aide à personne en danger, prévention/répression des troubles à l’ordre public, protection personnes & biens).",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00156",
                    "Cela va au-delà de l’assistance à personne en péril du ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00157",
                    "Code pénal (art. 223-6)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00158",
                      "Les textes n’imposent pas « l’héroïsme à tout prix » : le policier conserve une marge d’appréciation (moyens, moment d’intervention…).",
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III — Cumul d’activité
          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
              "f00159",
              "III — Cumul d’activité",
            ),
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00160",
                    "Cadre : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00161",
                    "décret n° 2020-69 du 30/01/2020",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00162",
                    " — principe : l’agent public consacre l’intégralité de son activité professionnelle aux tâches confiées.",
                  ),
                ),
              ]),
              SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00163",
                  "A) Activités privées strictement interdites",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00164",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00165",
                    "CGFP (art. L. 123-1)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00166",
                  "Participation à la direction de sociétés/associations à but lucratif.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00167",
                  "Consultations/expertises/plaidoiries contre une personne publique (sauf exception).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00168",
                  "Prise/détention d’intérêts compromettant l’indépendance dans une entreprise en lien/contrôle avec l’administration.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00169",
                  "Création/reprise d’entreprise (certaines formes/inscriptions) selon le texte.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00170",
                  "Cumul d’un emploi permanent à temps complet avec un ou plusieurs autres emplois permanents à temps complet.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00171",
                  "B) Activités librement autorisées",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00172",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00173",
                    "CGFP (art. L. 123-2)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00174",
                  "Gestion du patrimoine personnel/familial (limite : devenir dirigeant/gérant/commerçant).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00175",
                  "Production d’œuvres de l’esprit (si compatible déontologie et réelle production).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00176",
                  "Activité bénévole au profit de personnes publiques ou privées sans but lucratif.",
                ),
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00177",
                  "C) Activités soumises à autorisation",
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00178",
                    "Référence : ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                    "f00179",
                    "CGFP (art. L. 123-8 et L. 123-7)",
                  ),
                  style: TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00180",
                  "Création/reprise d’entreprise avec service à temps partiel (durée max 3 ans + 1 an).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00181",
                  "Activités accessoires possibles (enseignement, expertise, sport/culture, services à la personne, vente de biens produits personnellement…).",
                ),
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                          "f00182",
                          "Limites police : l’activité ne doit pas porter atteinte au fonctionnement, à l’indépendance, ni à la neutralité du service, ",
                        ) +
                        ScolariteText.value(
                          "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                          "f00183",
                          "et ne doit pas placer l’agent en situation de méconnaître la prise illégale d’intérêts — ",
                        ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                      "f00184",
                      "Code pénal (art. 432-12)",
                    ),
                    style: TextStyle(
                      color: _lawRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),

              SizedBox(height: 12),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00185",
                  "D) Formalisme de la demande",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00186",
                  "Demande écrite à l’autorité hiérarchique (accusé de réception).",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00187",
                  "Tout changement substantiel = nouvelle demande.",
                ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/pa_scolarite/institution_valeurs/deontologie/droits_obligations_policiers_page.dart",
                  "f00188",
                  "L’administration peut s’opposer à tout moment si l’intérêt du service le justifie (activité plus accessoire, infos erronées, etc.).",
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
  const _NotaBox({required this.bodySpans});

  final List<TextSpan> bodySpans;
  final String title = 'NOTA';

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
