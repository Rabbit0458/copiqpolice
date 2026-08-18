import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

TextSpan _lawRef(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w700),
  );
}

class PPMandatsTypesPage extends StatelessWidget {
  const PPMandatsTypesPage({super.key});

  static const String routeName =
      '/gpx_scolarite/procedure_penale/mandats_types';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ==== Couleurs de fond & texte cohérentes avec ton thème ====
    final Color bg = isDark ? const Color(0xFF10141A) : const Color(0xFFFFFFFF);

    final textMain = GoogleFonts.fustat(
      fontSize: 15.5,
      fontWeight: FontWeight.w800,
      // Titre des cartes en bleu comme tu avais
      color: isDark ? Colors.white : const Color(0xFF0D47A1),
    );

    final textSoft = GoogleFonts.fustat(
      fontSize: 13.5,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.white70 : const Color(0xFF424242),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        // plus de barre bleue : fond identique à la page
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
          tooltip: ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
            "f00002",
            'Les différents mandats',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF050505),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête général
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF0D47A1), const Color(0xFF002171)]
                            : [
                                const Color(0xFFE3F2FD),
                                const Color(0xFFBBDEFB),
                              ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00003",
                            'CHAPITRE 2 : LES DIFFÉRENTS MANDATS',
                          ),
                          style: textMain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00004",
                            'Les mandats de justice sont des actes judiciaires écrits permettant de rechercher une personne, de la contraindre à comparaître ou d’assurer sa détention, selon des règles très encadrées par le Code de procédure pénale.',
                          ),
                          style: textSoft,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),

                  ////////////////////////////////////////////////////////////
                  /// 2.1 — MANDAT DE RECHERCHE
                  ////////////////////////////////////////////////////////////
                  _ConditionCard(
                    title: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                      "f00005",
                      '2.1 — Le mandat de recherche',
                    ),
                    cardColor: isDark
                        ? const Color(0xFF10141A)
                        : const Color(0xFFF5F7FB),
                    accent: isDark
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1565C0),
                    titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                    children: [
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00006",
                          '2.1.1 — Définition et délivrance',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00007",
                            'Le mandat de recherche est « l’ordre donné à la force publique de rechercher la personne à l’encontre de laquelle il est décerné et de la placer en garde à vue » (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00008",
                            'article 122 alinéa 2 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00009",
                            '). Il peut être décerné à l’encontre d’une personne contre laquelle il existe une ou plusieurs raisons plausibles de soupçonner qu’elle a commis ou tenté de commettre une infraction.',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00010",
                          'Il ne peut être délivré ni contre le mis en examen, ni contre le témoin assisté, ni contre la personne visée nommément dans un réquisitoire nominatif.',
                        ),
                      ),
                      const SizedBox(height: 10),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00011",
                          'Remarques importantes',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00012",
                            '• Lorsque l’enquête porte sur un crime ou un délit flagrant puni d’au moins trois ans d’emprisonnement, le procureur de la République peut décerner un mandat de recherche sur le fondement de ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00013",
                            'l’article 70 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00014",
                            ' à l’encontre de toute personne contre laquelle il existe des raisons plausibles de soupçonner une infraction.',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 4),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00015",
                            '• En enquête préliminaire, un dispositif identique est prévu à ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00016",
                            'l’article 77-4 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ]),
                      const SizedBox(height: 4),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00017",
                            '• En cas d’urgence, le président de la chambre de l’instruction ou le conseiller désigné peut décerner un mandat d’amener, d’arrêt ou de recherche (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00018",
                            'article 201 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),

                      const SizedBox(height: 14),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00019",
                          '2.1.2 — Notification et exécution du mandat de recherche',
                        ),
                      ),

                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00020",
                          '2.1.2.1 — Agents habilités',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00021",
                            'Le mandat de recherche est notifié et exécuté par un officier ou un agent de police judiciaire ou un agent de la force publique, qui en fait exhibition à la personne et lui en délivre copie (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00022",
                            'article 123 alinéa 4 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00023",
                            'Si la personne est déjà détenue pour une autre cause, la notification est réalisée, sur instructions du procureur de la République, par le chef de l’établissement pénitentiaire qui remet également une copie du mandat (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00024",
                            'article 123 alinéa 5 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),

                      const SizedBox(height: 10),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00025",
                          '2.1.2.2 — Règles générales d’exécution',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00026",
                            'Les règles d’exécution sont fixées par ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00027",
                            'l’article 134 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00028",
                            ', et sont communes au mandat de recherche, au mandat d’arrêt et au mandat d’amener.',
                          ),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00029",
                          'L’agent chargé de l’exécution ne peut s’introduire dans le domicile d’un citoyen avant 6 heures ni après 21 heures. Il peut se faire accompagner d’une force suffisante, prélevée dans le lieu le plus proche, afin que la personne ne puisse se soustraire à la loi.',
                        ),
                      ),
                      const SizedBox(height: 6),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00030",
                            'Lorsque la personne ne peut être trouvée, l’agent doit adresser au magistrat mandant un procès-verbal de perquisition et de recherches infructueuses, conformément au dernier alinéa de ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00031",
                            'l’article 134 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ]),
                      const SizedBox(height: 6),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00032",
                          'En pratique, la perquisition s’effectue au dernier domicile connu ou, à défaut, à la dernière résidence de la personne recherchée. Elle a pour seul but de localiser la personne et ne permet pas la saisie d’objets ou documents utiles à l’enquête.',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00033",
                            'Cette « perquisition » ne renvoie pas aux exigences de ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00034",
                            'l’article 57 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00035",
                            ' : la présence de la personne ou de témoins n’est pas requise.',
                          ),
                        ),
                      ]),

                      const SizedBox(height: 10),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00036",
                          '2.1.2.3 — Effets du mandat de recherche',
                        ),
                      ),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00037",
                          '• Pour les mandats délivrés par le juge d’instruction : si la personne n’a pas pu être découverte au cours de l’instruction, elle est considérée comme mise en examen.',
                        ),
                      ),
                      const SizedBox(height: 4),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00038",
                            '• Pour les mandats délivrés par le procureur de la République : lorsque la personne n’est pas découverte au cours de l’enquête, le procureur peut requérir l’ouverture d’une information contre personne non dénommée. Le mandat de recherche reste alors valable pendant toute la durée de l’information (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00039",
                            'article 70 alinéa 3 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                    ],
                  ),

                  const SizedBox(height: 18),

                  ////////////////////////////////////////////////////////////
                  /// 2.2 — MANDAT DE COMPARUTION
                  ////////////////////////////////////////////////////////////
                  _ConditionCard(
                    title: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                      "f00040",
                      '2.2 — Le mandat de comparution',
                    ),
                    cardColor: isDark
                        ? const Color(0xFF10141A)
                        : const Color(0xFFF5F7FB),
                    accent: isDark
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1565C0),
                    titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                    children: [
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00041",
                          '2.2.1 — Définition et délivrance',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00042",
                            'Le mandat de comparution a pour objet de mettre en demeure la personne à l’encontre de laquelle il est décerné de se présenter devant le juge à la date et à l’heure indiquées par ce mandat (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00043",
                            'article 122 alinéa 4 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      const SizedBox(height: 6),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00044",
                          'Il est utilisé à l’égard de personnes domiciliées dont on suppose qu’elles ne se soustrairont pas aux poursuites. Il ne peut pas servir à convoquer un témoin.',
                        ),
                      ),
                      const SizedBox(height: 6),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00045",
                          'Il vise principalement des personnes à l’encontre desquelles il existe des indices graves ou concordants rendant vraisemblable leur participation, comme auteur ou complice, à la commission d’une infraction, y compris lorsqu’elles ont le statut de témoin assisté ou de mis en examen.',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00046",
                            'En pratique, les juges recourent plus volontiers à la citation à comparaître (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00047",
                            'article 101 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00048",
                            ') ou à l’ordre de conduite (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00049",
                            'article 109 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00050",
                            ') plutôt qu’au mandat de comparution.',
                          ),
                        ),
                      ]),

                      const SizedBox(height: 12),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00051",
                          '2.2.2 — Notification et exécution du mandat de comparution',
                        ),
                      ),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00052",
                          'Le mandat de comparution ne fait jamais l’objet d’une diffusion générale. Il doit être signifié ou notifié à la personne concernée.',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00053",
                            '• La signification est faite par un huissier de justice.\n• La notification est réalisée par un OPJ, un APJ ou un agent de la force publique, qui remet copie du mandat à l’intéressé (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00054",
                            'article 123 alinéa 3 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00055",
                            'Le juge d’instruction interroge immédiatement la personne qui fait l’objet d’un mandat de comparution, conformément à ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00056",
                            'l’article 125 alinéa 1 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ]),
                      const SizedBox(height: 6),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00057",
                          'Le mandat de comparution constitue une simple assignation à comparaître : aucune contrainte physique ne peut être mise en œuvre pour l’exécuter. Si la personne ne se présente pas, le juge dresse un procès-verbal de non-comparution et décide soit de délivrer un mandat d’amener, soit de renouveler la convocation, soit éventuellement de renvoyer directement la personne devant le tribunal correctionnel.',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  ////////////////////////////////////////////////////////////
                  /// 2.3 — MANDAT D’AMENER
                  ////////////////////////////////////////////////////////////
                  _ConditionCard(
                    title: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                      "f00058",
                      '2.3 — Le mandat d’amener',
                    ),
                    cardColor: isDark
                        ? const Color(0xFF10141A)
                        : const Color(0xFFF5F7FB),
                    accent: isDark
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1565C0),
                    titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                    children: [
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00059",
                          '2.3.1 — Définition et délivrance',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00060",
                            'Le mandat d’amener est « l’ordre donné par le juge à la force publique de conduire immédiatement la personne à l’encontre de laquelle il est décerné devant lui » (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00061",
                            'article 122 alinéa 5 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      const SizedBox(height: 6),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00062",
                          'Il ne constitue pas un titre de détention : l’arrestation est une mesure précaire visant à mettre la personne à la disposition de la justice.',
                        ),
                      ),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00063",
                          'Il peut être décerné à l’encontre de personnes qui n’ont pas déféré à un mandat de comparution ou dont on craint qu’elles ne s’y soumettent pas. Il peut viser une personne contre laquelle existent des indices graves ou concordants, ainsi qu’une personne mise en examen ou bénéficiant du statut de témoin assisté.',
                        ),
                      ),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00064",
                          'Le mandat d’amener peut s’appliquer à toute infraction susceptible de donner lieu à l’ouverture d’une information judiciaire.',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00065",
                            'En principe, il n’a pas vocation à être diffusé, mais il peut être inscrit au fichier des personnes recherchées en application de la loi du 18 mars 2003 pour la sécurité intérieure. En cas de nécessité, un mandat d’amener urgent peut être transmis par tout moyen (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00066",
                            'article 123 alinéa 6 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),

                      const SizedBox(height: 10),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00067",
                          '2.3.2 — Notification et exécution',
                        ),
                      ),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00068",
                          '2.3.2.1 — Agents habilités',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00069",
                            'Le mandat d’amener est notifié et exécuté par un officier ou agent de police judiciaire ou par un agent de la force publique, qui en fait exhibition et en délivre copie (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00070",
                            'article 123 alinéa 4 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00071",
                            'L’exécution est en pratique confiée, en vertu de ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00072",
                            'l’article R.188 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00073",
                            ', aux militaires de la gendarmerie et aux fonctionnaires de police autres que les commissaires et leurs adjoints.',
                          ),
                        ),
                      ]),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00074",
                          'La personne faisant l’objet d’un mandat d’amener peut, si nécessaire, être appréhendée avec la force strictement indispensable et faire l’objet d’une palpation de sécurité.',
                        ),
                      ),

                      const SizedBox(height: 8),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00075",
                          '2.3.2.2 — Règles générales d’exécution',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00076",
                            'Les règles générales d’exécution sont celles de ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00077",
                            'l’article 134 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00078",
                            ' (communes au mandat d’amener, au mandat d’arrêt et au mandat de recherche) : respect des horaires 6h–21h, possibilité de recourir à une force suffisante et obligation d’établir un procès-verbal de perquisition et de recherches infructueuses lorsque la personne n’est pas trouvée.',
                          ),
                        ),
                      ]),

                      const SizedBox(height: 8),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00079",
                          '2.3.2.3 — Formalités en cas d’appréhension',
                        ),
                      ),

                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00080",
                          'Exécution à 200 km au plus',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00081",
                            'Lorsque la personne est appréhendée à 200 km au plus du siège du juge d’instruction mandant, l’exécution obéit aux règles des ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00082",
                            'articles 125 et 133-1 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00083",
                            ' : présentation rapide devant le magistrat, délai maximal de rétention de 24 heures et bénéfice de certains droits de garde à vue (information d’un proche, médecin, avocat).',
                          ),
                        ),
                      ]),

                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00084",
                          'Exécution à plus de 200 km',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00085",
                            'Au-delà de 200 km, l’exécution est encadrée par ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00086",
                            'les articles 127 à 130-1 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00087",
                            ' : présentation devant le juge d’instruction ou, à défaut, devant le juge des libertés et de la détention du lieu d’arrestation, possibilité de transfèrement, délais stricts et contrôle systématique du respect de ces délais par le juge d’instruction.',
                          ),
                        ),
                      ]),
                    ],
                  ),

                  const SizedBox(height: 18),

                  ////////////////////////////////////////////////////////////
                  /// 2.4 — MANDAT D’ARRÊT
                  ////////////////////////////////////////////////////////////
                  _ConditionCard(
                    title: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                      "f00088",
                      '2.4 — Le mandat d’arrêt',
                    ),
                    cardColor: isDark
                        ? const Color(0xFF10141A)
                        : const Color(0xFFF5F7FB),
                    accent: isDark
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1565C0),
                    titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                    children: [
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00089",
                          '2.4.1 — Définition et délivrance',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00090",
                            'Le mandat d’arrêt est « l’ordre donné à la force publique de rechercher la personne à l’encontre de laquelle il est décerné et de la conduire devant le juge d’instruction après l’avoir, le cas échéant, conduite à la maison d’arrêt indiquée sur le mandat où elle sera reçue et détenue » (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00091",
                            'article 122 alinéa 6 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      const SizedBox(height: 6),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00092",
                          'Il s’agit à la fois d’un ordre de recherche avec force coercitive et d’un véritable titre de détention. Il est délivré en principe à l’encontre d’une personne en fuite ou résidant hors du territoire de la République.',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00093",
                            'Il est décerné par le juge d’instruction, après avis du procureur de la République lorsque les faits sont punis d’une peine d’emprisonnement correctionnelle ou plus grave (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00094",
                            'article 131 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00095",
                          'Le mandat d’arrêt peut être délivré à tout moment de l’information. Il fait l’objet d’une inscription au fichier des personnes recherchées et peut, dans certains cas, être diffusé de manière générale.',
                        ),
                      ),
                      const SizedBox(height: 6),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00096",
                            'Lorsque la personne se soustrait aux obligations du contrôle judiciaire après décision de renvoi devant la juridiction de jugement, le procureur de la République peut saisir le juge des libertés et de la détention afin qu’il délivre un mandat d’arrêt (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00097",
                            'articles 135-2 et 179 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),

                      const SizedBox(height: 10),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00098",
                          '2.4.2 — Notification et exécution',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00099",
                            'Les agents habilités et les règles générales d’exécution sont les mêmes que pour le mandat d’amener, en application de ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00100",
                            'l’article 123 alinéas 4 et 5, R.188 et 134 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ]),

                      const SizedBox(height: 8),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00101",
                          'Formalités en cas d’arrestation',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00102",
                            'Les formalités à respecter après l’arrestation de la personne visée par un mandat d’arrêt sont décrites aux ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00103",
                            'articles 133, 133-1, 135-2 et 135-3 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00104",
                            ', avec distinction selon que l’arrestation intervient à moins ou à plus de 200 km du siège de la juridiction, et selon que le mandat est exécuté avant ou après le règlement de l’information.',
                          ),
                        ),
                      ]),
                    ],
                  ),

                  const SizedBox(height: 18),

                  ////////////////////////////////////////////////////////////
                  /// 2.5 — MANDAT DE DÉPÔT
                  ////////////////////////////////////////////////////////////
                  _ConditionCard(
                    title: ScolariteText.value(
                      "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                      "f00105",
                      '2.5 — Le mandat de dépôt',
                    ),
                    cardColor: isDark
                        ? const Color(0xFF10141A)
                        : const Color(0xFFF5F7FB),
                    accent: isDark
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF1565C0),
                    titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                    children: [
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00106",
                          '2.5.1 — Définition et délivrance',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00107",
                            'Le mandat de dépôt est « l’ordre donné par le juge des libertés et de la détention au chef de l’établissement pénitentiaire de recevoir et de détenir la personne mise en examen ayant fait l’objet d’une ordonnance de placement en détention provisoire » (',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00108",
                            'article 122 alinéa 8 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: ').'),
                      ]),
                      const SizedBox(height: 6),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00109",
                            'En matière criminelle comme en matière correctionnelle, il ne peut être décerné qu’en exécution de l’ordonnance prévue par ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00110",
                            'l’article 145 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ]),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00111",
                          'Le mandat de dépôt peut aussi, lorsqu’il a déjà été notifié, servir à rechercher une personne évadée ou permettre son transfèrement d’un établissement pénitentiaire à un autre.',
                        ),
                      ),

                      const SizedBox(height: 10),
                      _SubTitle(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00112",
                          '2.5.2 — Notification et exécution',
                        ),
                      ),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00113",
                            'La notification verbale de l’ordonnance de placement en détention provisoire prévue à ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00114",
                            'l’article 145 du Code de procédure pénale',
                          ),
                        ),
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00115",
                            ' vaut notification du mandat de dépôt lui-même.',
                          ),
                        ),
                      ]),
                      _Paragraph.rich([
                        TextSpan(
                          text: ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00116",
                            'L’agent de la force publique qui exécute un mandat de dépôt accomplit une mission purement matérielle : il conduit la personne du cabinet du magistrat jusqu’à la maison d’arrêt désignée. Il peut utiliser, si besoin, la force strictement nécessaire, conformément à ',
                          ),
                        ),
                        _lawRef(
                          ScolariteText.value(
                            "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                            "f00117",
                            'l’article 135 alinéa 2 du Code de procédure pénale',
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ]),
                      _Paragraph(
                        ScolariteText.value(
                          "lib/content/gpx_scolarite/dps_dpg/procédure_pénale_pages/pp_mandats_types.dart",
                          "f00118",
                          'Une copie du mandat de dépôt est laissée au chef d’établissement par le chef d’escorte, qui se voit délivrer une reconnaissance de la remise du détenu.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
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
