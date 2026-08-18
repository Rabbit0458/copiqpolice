import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PPInstructionPouvoirsPage extends StatelessWidget {
  const PPInstructionPouvoirsPage({super.key});

  static const String routeName =
      '/gpx_scolarite_pages/procédure_pénale_pages/pp_instruction_pouvoirs';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .70);

    final Color cardLight = isDark
        ? const Color(0xFF424242)
        : const Color(0xFFF5F7FB);
    final Color cardAccent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

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
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
            "f00002",
            "Pouvoirs du juge d'instruction",
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
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ====================== TITRE PRINCIPAL ===========================
          Text(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00003",
              "Chapitre 3 – Les pouvoirs du juge d'instruction",
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
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00004",
                  "Rôle général du juge d’instruction, constatations matérielles, recours aux experts, ",
                ) +
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00005",
                  "auditions des témoins, témoins assistés, personnes mises en examen et parties civiles.",
                ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),

          const SizedBox(height: 18),

          ////////////////////////////////////////////////////////////////////
          // 3.1 – CARACTÈRES GÉNÉRAUX
          ////////////////////////////////////////////////////////////////////
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00006",
              '3.1 – Caractères généraux',
            ),
          ),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00007",
              "3.1 – Caractères généraux de l'instruction",
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00008",
                        "Le juge d’instruction a pour première mission de rechercher avec précision les ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00009",
                        "circonstances dans lesquelles l’infraction a été commise, ainsi que les conditions ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00010",
                        "dans lesquelles les différentes personnes concernées y ont participé. Il doit aussi ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00011",
                        "porter son attention sur la personnalité du mis en cause, prise en compte au moment ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00012",
                        "de la répression, mais également sur la personnalité de la victime. Cette exigence est ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00013",
                        "rappelée par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00014",
                    "l’Article 81-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00015",
                        ", qui consacre l’importance de la recherche de la vérité tout en tenant compte ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00016",
                        "de la situation personnelle des protagonistes.",
                      ),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00017",
                        "La recherche de la vérité doit être menée de la manière la plus objective possible. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00018",
                        "Pour y parvenir, le juge instruit à charge et à décharge : il doit rechercher et ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00019",
                        "examiner avec soin tous les éléments susceptibles soit de confirmer la culpabilité ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00020",
                        "de la personne mise en cause, soit au contraire de la disculper. Ce principe d’objectivité ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00021",
                        "et de double regard est au cœur de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00022",
                    "l’Article 81 alinéa 1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00023",
                      "Pour mener à bien cette mission délicate, le juge d’instruction dispose de mesures ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00024",
                      "très diverses : mandats de justice, contrôle judiciaire, détention provisoire, commissions ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00025",
                      "rogatoires, expertises, auditions, perquisitions, saisies… Certaines de ces mesures font l’objet ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00026",
                      "d’un traitement détaillé dans d’autres chapitres (mandats, contrôle judiciaire, détention ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00027",
                      "provisoire, commissions rogatoires). Dans ce chapitre, l’accent est mis sur les constatations ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00028",
                      "matérielles et les différentes catégories de personnes que le juge peut entendre.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ////////////////////////////////////////////////////////////////////
          // 3.2 – LES CONSTATATIONS MATÉRIELLES
          ////////////////////////////////////////////////////////////////////
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00029",
              '3.2 – Les constatations matérielles',
            ),
          ),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00030",
              '3.2.1 – Les constatations effectuées par le juge',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00031",
                        "Le juge d’instruction peut procéder lui-même à un certain nombre de constatations ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00032",
                        "matérielles venant compléter celles déjà effectuées par les services d’enquête. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00033",
                        "Dans ce cadre, ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00034",
                    "l’Article 92 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00035",
                        " l’autorise à se transporter sur les lieux pour effectuer toutes constatations utiles ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00036",
                        "ou procéder à des perquisitions, le cas échéant en donnant avis au procureur de la ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00037",
                        "République qui peut l’accompagner.",
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00038",
                      "Lors de ces déplacements, le juge d’instruction est assisté de son greffier, chargé de ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00039",
                      "rédiger le procès-verbal des constatations. Cet acte de procédure doit être signé par le ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00040",
                      "juge et par le greffier. Le juge peut se déplacer, être assisté de son greffier et, sans ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00041",
                      "être obligé de dresser un procès-verbal détaillé pour chaque observation, doit diriger et ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00042",
                      "contrôler personnellement l’exécution d’une éventuelle commission rogatoire.",
                    ),
              ),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00043",
                        "Il peut également, dans le cadre de l’exécution d’une commission rogatoire, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00044",
                        "ordonner la prolongation de gardes à vue déjà décidées, conformément aux conditions ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00045",
                        "posées par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00046",
                    "l’Article 152 alinéa 3 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00047",
                        ". Certaines constatations peuvent aussi être réalisées au cabinet du juge, qui examine ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00048",
                        "les pièces saisies et évalue leur intérêt pour l’information.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 16),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00049",
              '3.2.2 – L’expertise',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00050",
                        "Lorsque la technicité d’une question dépasse ses compétences juridiques, le juge ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00051",
                        "d’instruction peut recourir à des experts. L’expertise est encadrée par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00052",
                    "les Articles 156 à 169-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00053",
                        " et a pour objet l’examen de questions d’ordre technique nécessitant, au-delà de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00054",
                        "constatations objectives, une véritable interprétation spécialisée : police scientifique, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00055",
                        "balistique, faux documents, médecine légale, psychiatrie, biologie, chimie, toxicologie, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00056",
                        "comptabilité, etc.",
                      ),
                ),
              ]),
              const SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00057",
                  '3.2.2.1 – La nomination des experts',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00058",
                        "L’initiative d’une expertise peut appartenir au ministère public, au juge d’instruction ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00059",
                        "qui ordonne d’office, à l’une des parties ou encore au témoin assisté. Lorsque le juge ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00060",
                        "refuse de donner suite à une demande d’expertise, il doit rendre une ordonnance motivée ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00061",
                        "dans le délai d’un mois à compter de la demande, conformément à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00062",
                    "l’Article 156 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00063",
                        "Les experts sont en principe choisis parmi les personnes physiques ou morales ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00064",
                        "inscrites sur les listes nationales ou régionales dressées par les juridictions. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00065",
                        "Cette organisation est prévue par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00066",
                    "l’Article 157 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00067",
                        ", qui permet également de recourir à des services spécialisés, notamment les services ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00068",
                        "de police technique et scientifique de la police nationale et de la gendarmerie nationale. ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00069",
                        "L’Article 157-2 du Code de procédure pénale prévoit ces recours. Dans des cas exceptionnels, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00070",
                        "le juge peut désigner un expert non inscrit sur ces listes, à condition de motiver ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00071",
                        "expressément ce choix.",
                      ),
                ),
              ]),

              const SizedBox(height: 12),
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00072",
                  '3.2.2.2 – Le déroulement de l’expertise',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00073",
                        "Avant d’exercer leurs fonctions, les experts inscrits sur les listes prêtent serment ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00074",
                        "« d’apporter leur concours à la justice, en leur honneur et en leur conscience ». Ce serment ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00075",
                        "est prêté devant la cour d’appel dont ils dépendent ou, pour certains experts, devant la ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00076",
                        "juridiction désignée. Les modalités de ce serment sont prévues par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00077",
                    "l’Article 160 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00078",
                        ". Les experts non inscrits sur une liste prêtent serment devant le juge d’instruction ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00079",
                        "ou le magistrat désigné.",
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00080",
                        "Les experts accomplissent leur mission sous le contrôle du juge d’instruction, qui doit ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00081",
                        "être tenu informé des opérations en cours et peut prendre toute mesure utile. Ce contrôle ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00082",
                        "est rappelé par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00083",
                    "l’Article 156 alinéa 3 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00084",
                    " et par les dispositions de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00085",
                    "l’Article 161 alinéa 3 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00086",
                        ". Les pièces à conviction placées sous scellés peuvent, après inventaire, être mises ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00087",
                        "à la disposition des experts qui, le cas échéant, peuvent ouvrir les scellés et procéder ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00088",
                        "à l’inventaire des objets, en application de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00089",
                    "l’Article 163 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00090",
                        "À l’issue de leurs opérations, les experts rédigent un rapport détaillé exposant la nature ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00091",
                        "des investigations réalisées et leurs conclusions. Ce rapport doit être signé par les experts, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00092",
                        "mentionner les noms et qualités des personnes les ayant assistés et être déposé entre les mains ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00093",
                        "du greffier, qui dresse procès-verbal de dépôt conformément à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00094",
                    "l’Article 166 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00095",
                        ". Avec l’accord du juge d’instruction, les conclusions peuvent être communiquées au procureur ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00096",
                        "de la République, aux officiers de police judiciaire chargés de l’exécution d’une commission ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00097",
                        "rogatoire ou aux parties.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          ////////////////////////////////////////////////////////////////////
          // 3.3 – LES AUDITIONS
          ////////////////////////////////////////////////////////////////////
          _SubTitle(
            ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00098",
              '3.3 – Les auditions',
            ),
          ),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00099",
              '3.3.1 – Les auditions de témoins',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00100",
                        "Le juge d’instruction peut entendre toute personne susceptible d’apporter des éléments ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00101",
                        "utiles à la manifestation de la vérité. Les règles applicables aux témoins sont précisées ",
                      ) +
                      "par ",
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00102",
                    "les Articles 101 à 113-8 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00103",
                  '3.3.1.1 – Les personnes concernées',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00104",
                        "En vertu de ces dispositions, le juge d’instruction peut faire citer devant lui, par huissier ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00105",
                        "ou par agent de la force publique, toute personne dont la déposition lui paraît utile. Si la ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00106",
                        "personne régulièrement citée ne comparaît pas ou refuse de comparaître, elle peut y être ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00107",
                        "contrainte par la force publique. En outre, ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00108",
                    "l’Article 105 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00109",
                        " impose au juge d’entendre comme témoins les personnes contre lesquelles existent des indices ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00110",
                        "graves ou concordants d’avoir participé à l’infraction, sauf à les placer sous un autre statut.",
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00111",
                  '3.3.1.2 – Les formalités attachées à l’audition',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00112",
                        "Les témoins doivent être entendus séparément et hors la présence des parties, sauf en cas de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00113",
                        "confrontation. Il est dressé procès-verbal de leurs déclarations, conformément à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00114",
                    "l’Article 102 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00115",
                        ". Le juge vérifie l’identité du témoin et précise ses liens éventuels avec les parties – ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00116",
                        "parenté, alliance, lien de service – en application de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00117",
                    "l’Article 103 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00118",
                    ". Le témoin prête serment de dire toute la vérité, rien que la vérité.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00119",
                    "Les obligations du témoin sont détaillées par ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00120",
                    "l’Article 109 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00121",
                        " : il doit comparaître, prêter serment et déposer. Certaines catégories de personnes sont toutefois ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00122",
                        "dispensées de l’obligation de prêter serment ou de déposer, notamment les proches parents du mis en ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00123",
                        "cause et les mineurs, conformément à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00124",
                    "l’Article 335 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00125",
                    " et aux textes relatifs à la protection de la famille et aux liens de parenté.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00126",
                        "Certaines personnes sont tenues au secret professionnel et ne peuvent déposer qu’avec l’autorisation ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00127",
                        "de la personne concernée ou dans les limites fixées par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00128",
                    "l’Article 131-26 du Code pénal",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00129",
                        ". Quant aux journalistes professionnels, ils bénéficient d’une protection spécifique quant à leurs ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00130",
                        "sources d’information.",
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00131",
                    "Le non-respect par le témoin de ses obligations peut être sanctionné pénalement. Ainsi, ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00132",
                    "l’Article 434-15-1 du Code pénal",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00133",
                        " punit d’une amende pouvant aller jusqu’à 3 750 euros le témoin qui, sans motif légitime, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00134",
                        "refuse de comparaître ou de déposer devant le juge d’instruction ou devant un officier de ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00135",
                        "police judiciaire agissant sur commission rogatoire.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 18),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00136",
              '3.3.2 – Les auditions de témoins assistés',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00137",
                        "Le témoin assisté occupe une position intermédiaire entre le simple témoin et la personne ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00138",
                        "mise en examen. Ce statut concerne des personnes à l’égard desquelles pèsent des soupçons plus ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00139",
                        "ou moins sérieux mais pour lesquelles la mise en examen n’est pas encore envisagée. Il est ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00140",
                        "notamment organisé par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00141",
                    "l’Article 80-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00142",
                  '3.3.2.1 – Les personnes concernées',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00143",
                        "Sont notamment témoins assistés, de plein droit ou à la demande, les personnes nommément ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00144",
                        "visées dans un réquisitoire introductif ou supplétif du procureur de la République, celles ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00145",
                        "contre lesquelles existent des indices graves ou concordants, ainsi que les personnes visées ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00146",
                        "par une plainte ou une plainte avec constitution de partie civile. Ces situations sont visées ",
                      ) +
                      "par ",
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00147",
                    "les Articles 113-1, 113-2 et 113-6 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00148",
                  '3.3.2.2 – Les droits du témoin assisté',
                ),
              ),

              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00149",
                  "Assistance d’un avocat, désigné par lui ou d’office, avec accès au dossier de la procédure.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00150",
                  "Droit d’obtenir l’interprétation ou la traduction des pièces essentielles du dossier.",
                ),
              ),
              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00151",
                  "Droit de demander des confrontations et de formuler des requêtes en annulation.",
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00152",
                      "Droit de demander son renvoi devant une juridiction de jugement ou la clôture de la procédure ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00153",
                      "lorsqu’aucun acte d’instruction n’a été accompli depuis quatre mois, en application de ",
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00154",
                    "l’Article 175-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00155",
                        "Le témoin assisté est avisé de la fin de l’information, peut présenter des observations et ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00156",
                        "soulever des nullités au moment où le juge statue sur le règlement du dossier, conformément à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00157",
                    "l’Article 175 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00158",
                        "En cas de non-respect de ses obligations de comparution, le témoin assisté ne peut pas, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00159",
                        "devant le juge d’instruction, faire l’objet d’une contrainte par la force publique lorsqu’il ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00160",
                        "est seulement convoqué par un officier de police judiciaire : en effet, ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00161",
                    "l’Article 152 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00162",
                        " subordonne l’audition d’un témoin assisté par un officier de police judiciaire à une demande ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00163",
                        "expresse de ce dernier.",
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00164",
                  '3.3.2.4 – La mise en examen du témoin assisté',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00165",
                        "La mise en examen d’un témoin assisté peut intervenir à sa demande ou à l’initiative du juge ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00166",
                        "d’instruction lorsque ce dernier estime que des indices graves ou concordants rendent vraisemblable ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00167",
                        "sa participation à l’infraction. ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00168",
                    "L’Article 113-6 alinéa 2 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00169",
                        " précise que, dans certains cas, le juge a la faculté de maintenir la personne sous le statut ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00170",
                        "de témoin assisté s’il n’est pas en mesure de réunir des indices suffisamment graves ou concordants.",
                      ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00171",
              '3.3.3 – Les interrogatoires de la personne mise en examen',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00172",
                  '3.3.3.1 – Les personnes concernées',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00173",
                        "La mise en examen suppose, à peine de nullité, l’existence d’indices graves ou concordants ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00174",
                        "rendant vraisemblable la participation de la personne à l’infraction. Cette condition est posée par ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00175",
                    "l’Article 80-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00176",
                        ". Lorsque la mise en examen n’est pas possible ou pas nécessaire, le juge peut recourir au statut ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00177",
                        "de témoin assisté.",
                      ),
                ),
              ]),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00178",
                  '3.3.3.2 – L’interrogatoire de première comparution d’une personne non témoin assisté',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00179",
                        "Quand le juge envisage de mettre en examen une personne qui n’a pas encore le statut de témoin ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00180",
                        "assisté, il doit procéder à un interrogatoire de première comparution, conformément aux exigences de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00181",
                    "l’Article 116 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00182",
                    ". En matière criminelle, cet interrogatoire fait l’objet d’un enregistrement audiovisuel, en application de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00183",
                    "l’Article 116-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00184",
                        ". L’Article 80-2 du Code de procédure pénale permet en outre au juge de convoquer la personne par lettre ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00185",
                        "recommandée, dans un délai compris entre dix jours et deux mois.",
                      ),
                ),
              ]),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00186",
                  '3.3.3.3 – Particularités',
                ),
              ),

              _IntroBullet(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00187",
                  "La personne mise en examen ne prête pas serment.",
                ),
              ),
              _IntroBullet(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00188",
                      "Elle peut demander à être entendue à nouveau, demander des confrontations ou la réalisation d’actes ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00189",
                      "d’instruction complémentaires, notamment sur le fondement de ",
                    ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00190",
                    "l’Article 82-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00191",
                        "Le procureur de la République et les avocats peuvent prendre la parole au cours des interrogatoires pour ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00192",
                        "formuler des observations ou poser des questions, mais c’est le juge d’instruction qui dirige les débats, ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00193",
                        "conformément à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00194",
                    "l’Article 120 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 20),

          _ConditionCard(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00195",
              '3.3.4 – Les auditions de parties civiles',
            ),
            cardColor: cardLight,
            accent: cardAccent,
            titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
            children: [
              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00196",
                  '3.3.4.1 – Personnes concernées',
                ),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00197",
                        "Toute personne qui se prétend lésée par un crime ou un délit peut se constituer partie civile devant le ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00198",
                        "juge d’instruction en déposant plainte, conformément à ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00199",
                    "l’Article 85 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00200",
                    ". La constitution de partie civile déclenche en principe l’action publique si la plainte est recevable.",
                  ),
                ),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00201",
                        "La constitution de partie civile peut être formée par simple déclaration écrite ou orale, sans formalisme ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00202",
                        "rigide, comme le rappelle ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00203",
                    "l’Article 87 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00204",
                    ". D’autres textes, tels que ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00205",
                    "l’Article 80-3 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00206",
                        ", encadrent l’information de la victime sur ses droits, sa possibilité de se constituer partie civile et les ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00207",
                        "délais pour demander la clôture de la procédure.",
                      ),
                ),
              ]),
              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00208",
                  '3.3.4.3 – Effets de la constitution de partie civile pour la victime',
                ),
              ),

              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00209",
                  "La victime devient pleinement partie à la procédure et peut intervenir dans le déroulement de l’information.",
                ),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00210",
                      "Elle peut demander l’annulation d’actes, faire appel de certaines décisions et solliciter la clôture de l’instruction ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00211",
                      "lorsque aucun acte n’a été accompli depuis quatre mois.",
                    ),
              ),
              _BulletPoint(
                text: ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00212",
                  "Elle obtient le droit d’être informée régulièrement de l’avancement du dossier.",
                ),
              ),

              const SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value(
                  "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                  "f00213",
                  '3.3.4.4 – Particularités',
                ),
              ),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00214",
                        "Lors de sa première audition, la partie civile est avisée de ses droits, notamment de la possibilité de formuler des ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00215",
                        "demandes d’actes et des requêtes en annulation, ainsi que des délais dans lesquels elle peut demander la clôture de la ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00216",
                        "procédure. Ces informations découlent notamment de ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00217",
                    "l’Article 89-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00218",
                    " et de ",
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00219",
                    "l’Article 175-1 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent,
                  ),
                ),
                TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00220",
                        "La partie civile ne prête pas serment. Elle peut demander à être entendue par le juge d’instruction, mais ne peut être ",
                      ) +
                      ScolariteText.value(
                        "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                        "f00221",
                        "auditionnée qu’en présence de son avocat, sauf renonciation expresse. Lors de l’exécution d’une commission rogatoire, ",
                      ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00222",
                    "l’Article 152 du Code de procédure pénale",
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade700,
                  ),
                ),
                TextSpan(
                  text: ScolariteText.value(
                    "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                    "f00223",
                    " précise que l’audition d’une partie civile par un officier de police judiciaire ne peut intervenir qu’à la demande de celle-ci.",
                  ),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          _NotaBox(
            title: ScolariteText.value(
              "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
              "f00224",
              'À RETENIR',
            ),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00225",
                      "Le juge d’instruction dispose de pouvoirs très étendus : constatations sur les lieux, recours à des experts, ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00226",
                      "audition de témoins, mise en place du statut de témoin assisté, mise en examen et prise en compte des droits ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00227",
                      "de la partie civile. Ces pouvoirs sont strictement encadrés par le Code de procédure pénale – en particulier ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00228",
                      "les Articles 81-1, 92, 156 à 169-1, 101 à 113-8, 80-1, 113-1 à 113-7, 116, 120, 85, 87 et 175-1 – afin de concilier ",
                    ) +
                    ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_instruction_pouvoirs.dart",
                      "f00229",
                      "efficacité de l’enquête, respect des droits de la défense et protection des victimes.",
                    ),
              ),
            ],
          ),

          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
//                   TES WIDGETS PERSONNALISÉS EXACTS                       ///
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
