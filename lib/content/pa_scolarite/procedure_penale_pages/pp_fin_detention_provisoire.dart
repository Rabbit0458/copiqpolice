import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPPFinDetentionProvisoirePage extends StatelessWidget {
  const PaPPFinDetentionProvisoirePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_fin_detention_provisoire';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

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
            "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
            "f00002",
            'Fin de la détention provisoire',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
        children: [
          // ====================== CHAPITRE & TITRE ==========================
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00003",
              'CHAPITRE 3',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? const Color(0xFF64B5F6) : const Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00004",
              'Fin de la détention provisoire',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00005",
                  'Règlement de la procédure, demandes de mise en liberté, mises en ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00006",
                  'liberté de plein droit, d’office, sur réquisitions ou pour raisons ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00007",
                  'de santé.',
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          // ====================== 3.1 – RÈGLEMENT DE LA PROCÉDURE ==========
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00008",
              '3.1 – Le règlement de la procédure',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00009",
                    'La détention provisoire prend fin notamment en cas de non-lieu ou ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00010",
                    'lorsque les faits sont requalifiés en contravention ou en délit ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00011",
                    'n’entrant plus dans les prévisions de ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00012",
                'l’article 144 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00013",
                    '. De plus, le juge d’instruction ou, s’il est saisi, le juge des ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00014",
                    'libertés et de la détention doit ordonner la mise en liberté ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00015",
                    'immédiate de la personne détenue dès que les conditions de ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00016",
                'l’article 144 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00017",
                ' ne sont plus réunies, conformément à ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00018",
                'l’article 144-1 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 16),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00019",
              '3.1.1 – En cas de renvoi devant le tribunal correctionnel\n(art. 179 C. proc. pén.)',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00020",
                'En cas de renvoi devant le tribunal correctionnel, ',
              ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00021",
                'l’article 179 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00022",
                    ' prévoit que l’ordonnance de renvoi met normalement fin à la ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00023",
                    'détention provisoire. Toutefois, le juge d’instruction peut, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00024",
                    'par ordonnance distincte spécialement motivée, maintenir la ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00025",
                    'personne en détention jusqu’à sa comparution devant le tribunal.',
                  ),
            ),
          ]),

          const SizedBox(height: 12),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00026",
              '3.1.2 – En cas de renvoi devant la cour d’assises\n(art. 181 C. proc. pén.)',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00027",
                    'Lorsque le juge d’instruction ou la chambre de l’instruction estime ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00028",
                    'que les faits retenus à la charge de la personne mise en examen ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00029",
                    'constituent un crime, ils prononcent une mise en accusation devant ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00030",
                    'la cour d’assises, en application de ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00031",
                'l’article 181 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00032",
                    '. La détention provisoire se poursuit alors selon le régime des ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00033",
                    'accusés détenus en attente de jugement par la cour d’assises, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00034",
                    'sous le contrôle des juridictions compétentes.',
                  ),
            ),
          ]),

          const SizedBox(height: 22),

          // ====================== 3.2 – DEMANDE DE MISE EN LIBERTÉ =========
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00035",
              '3.2 – La demande de mise en liberté',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00036",
                    'La mise en liberté peut être demandée à tout moment au juge ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00037",
                    'd’instruction par la personne mise en examen ou par son avocat, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00038",
                    'en application de ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00039",
                'l’article 148 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00040",
                    '. De même, tout prévenu ou accusé peut demander sa mise en liberté, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00041",
                    'conformément à ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00042",
                'l’article 148-1 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 14),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00043",
              '3.2.1 – Procédure devant le juge d’instruction',
            ),
          ),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00044",
                  'Le juge d’instruction communique immédiatement la demande de mise en ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00045",
                  'liberté au procureur de la République pour réquisitions. Il dispose ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00046",
                  'ensuite de deux options :',
                ),
          ),
          const SizedBox(height: 6),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00047",
                  'S’il accepte de faire droit à la demande, il rend lui-même une ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00048",
                  'ordonnance de mise en liberté, éventuellement assortie d’un ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00049",
                  'contrôle judiciaire.',
                ),
          ),
          _IntroBullet(
            text:
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00050",
                  'S’il n’entend pas y faire droit, il ne peut pas rejeter lui-même la ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00051",
                  'demande : il transmet celle-ci, avec son avis motivé, au juge des ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00052",
                  'libertés et de la détention dans les dix jours suivant la ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00053",
                  'communication au procureur de la République.',
                ),
          ),
          const SizedBox(height: 6),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00054",
                  'Saisi, le juge des libertés et de la détention peut soit accorder la ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00055",
                  'mise en liberté, avec ou sans contrôle judiciaire, soit rejeter la ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00056",
                  'demande.',
                ),
          ),

          const SizedBox(height: 16),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00057",
              '3.2.2 – Saisine de la chambre de l’instruction',
            ),
          ),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00058",
              'Saisine de la chambre de l’instruction\n(contentieux de la détention)',
            ),
            cardColor: isDark
                ? const Color(0xFF263238)
                : const Color(0xFFE3F2F1),
            accent: const Color(0xFF00838F),
            titleColor: isDark
                ? const Color(0xFFB2EBF2)
                : const Color(0xFF004D40),
            children: [
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00059",
                      'En cas de carence du juge des libertés et de la détention : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00060",
                      'l’intéressé peut saisir la chambre lorsque le J.L.D. n’a pas ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00061",
                      'statué dans les cinq jours ouvrables sur une demande de mise ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00062",
                      'en liberté.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00063",
                      'En cas de carence du juge d’instruction : l’intéressé ou son ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00064",
                      'avocat peut saisir la chambre à l’expiration d’un délai de ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00065",
                      'six mois depuis la dernière comparution, conformément à ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00066",
                      'l’article 148-4 du Code de procédure pénale.',
                    ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00067",
                      'Lorsque la chambre de l’instruction s’est réservée le ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00068",
                      'contentieux de la détention, elle demeure seule compétente ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00069",
                      'pour statuer sur les demandes de mise en liberté.',
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00070",
                  'La chambre de l’instruction dispose d’un délai de 30 jours à compter ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00071",
                  'de la réception de la demande de mise en liberté pour rendre sa ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00072",
                  'décision.',
                ),
          ),

          const SizedBox(height: 16),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00073",
              '3.2.3 – Saisine de la juridiction de jugement',
            ),
          ),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00074",
                  'Après le renvoi devant une juridiction de jugement (tribunal ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00075",
                  'correctionnel ou cour d’assises), la personne peut demander sa mise ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00076",
                  'en liberté à tout moment de la procédure. C’est alors la juridiction ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00077",
                  'de jugement saisie qui statue sur cette demande, selon les textes qui ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00078",
                  'lui sont applicables.',
                ),
          ),

          const SizedBox(height: 22),

          // ====================== 3.3 – MISE EN LIBERTÉ DE PLEIN DROIT =====
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00079",
              '3.3 – La mise en liberté de plein droit',
            ),
          ),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00080",
              '3.3.1 – À la fin de la durée de la détention provisoire',
            ),
          ),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00081",
                  'Lorsque la durée légale maximale de la détention provisoire est ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00082",
                  'atteinte, prolongations éventuelles comprises, la mise en liberté de ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00083",
                  'la personne est automatique : la juridiction n’a plus la faculté de ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00084",
                  'maintenir la détention au-delà des limites fixées par la loi.',
                ),
          ),

          const SizedBox(height: 10),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00085",
              '3.3.2 – Inobservation des délais',
            ),
          ),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00086",
                  'L’inobservation par les juridictions des délais légaux pour statuer sur ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00087",
                  'les demandes de mise en liberté entraîne également la mise en liberté ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00088",
                  'de plein droit de la personne détenue.',
                ),
          ),

          const SizedBox(height: 16),

          _NotaBox(
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00089",
              'Conséquence pratique',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00090",
                      'La maîtrise des délais (durée de la détention, délais pour ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00091",
                      'statuer sur les demandes, délais de recours) est essentielle : ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00092",
                      'leur non-respect se traduit par la remise en liberté de la ',
                    ) +
                    ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                      "f00093",
                      'personne, indépendamment du fond du dossier.',
                    ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ====================== 3.4 – MISE EN LIBERTÉ D’OFFICE ===========
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00094",
              '3.4 – La mise en liberté d’office',
            ),
          ),

          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00095",
                  'La mise en liberté d’office est prononcée sans qu’elle ait été ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00096",
                  'demandée par la personne détenue ou requise par le ministère public. ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00097",
                  'Elle doit être ordonnée lorsque la mise en liberté est de droit, mais ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00098",
                  'aussi lorsque la juridiction estime que la détention n’est plus utile ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00099",
                  'à la bonne marche de l’instruction ou à la protection de l’ordre public.',
                ),
          ),

          const SizedBox(height: 10),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00100",
              '3.4.1 – Décision du juge d’instruction',
            ),
          ),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00101",
                  'Avant d’ordonner une mise en liberté d’office, le juge d’instruction ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00102",
                  'sollicite l’avis du procureur de la République. Il prend ensuite sa ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00103",
                  'décision sans débat contradictoire. La personne mise en examen doit ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00104",
                  's’engager à se présenter à tous les actes de la procédure et à tenir ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00105",
                  'le juge informé de ses changements de domicile ou de déplacements ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00106",
                  'importants.',
                ),
          ),

          const SizedBox(height: 10),

          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00107",
              '3.4.2 – Décision de la chambre de l’instruction',
            ),
          ),
          _Paragraph(
            ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00108",
                  'La chambre de l’instruction peut, quel que soit son mode de saisine, ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00109",
                  'décider la mise en liberté d’office lorsqu’elle estime que les ',
                ) +
                ScolariteText.value(
                  "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                  "f00110",
                  'conditions d’un maintien en détention ne sont plus remplies.',
                ),
          ),

          const SizedBox(height: 22),

          // ====================== 3.5 – SUR RÉQUISITIONS DU PARQUET ========
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00111",
              '3.5 – La mise en liberté sur réquisitions du parquet',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00112",
                    'Le procureur de la République peut, à tout moment, requérir auprès ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00113",
                    'du juge d’instruction la mise en liberté d’une personne placée en ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00114",
                    'détention provisoire, en application de ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00115",
                'l’article 147 alinéa 2 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 22),

          // ====================== 3.6 – POUR RAISON DE SANTÉ ===============
          _SubTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
              "f00116",
              '3.6 – La mise en liberté pour raison de santé',
            ),
          ),

          _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00117",
                    'Sauf s’il existe un risque grave de renouvellement de l’infraction, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00118",
                    'la mise en liberté d’une personne placée en détention provisoire ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00119",
                    'peut être ordonnée, d’office ou à la demande de l’intéressé, ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00120",
                    'lorsqu’une expertise médicale établit que cette personne est ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00121",
                    'atteinte d’une pathologie engageant le pronostic vital ou que son ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00122",
                    'état de santé physique ou mentale est incompatible avec le maintien ',
                  ) +
                  ScolariteText.value(
                    "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                    "f00123",
                    'en détention, conformément à ',
                  ),
            ),
            TextSpan(
              text: ScolariteText.value(
                "lib/content/pa_scolarite/procedure_penale_pages/pp_fin_detention_provisoire.dart",
                "f00124",
                'l’article 147-1 du Code de procédure pénale',
              ),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
            ),
            TextSpan(text: '.'),
          ]),

          const SizedBox(height: 26),
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
