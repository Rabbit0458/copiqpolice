import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaEnquetePreliminaireConstatationsRequisitionsPage extends StatelessWidget {
  const PaEnquetePreliminaireConstatationsRequisitionsPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_preliminaire/actes/constatations_requisitions';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
? const Color(0xFF1E1E1E)
: const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
          tooltip: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00001", 'Retour'),
        ),
        title: Text(
          ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00002", 'Constatations & réquisitions'),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU ============================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------- TITRE --------------------------
          Text(
            ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00003", '2.3 — Les actes de l’enquête préliminaire\n') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00004", 'Constatations, réquisitions et prélèvements'),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

          // -------------------- INTRO ----------------------------
           _Paragraph.rich([
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00005", 'Dans le cadre de l’enquête préliminaire, les officiers de police judiciaire (O.P.J.) ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00006", 'et, sous leur contrôle, les agents de police judiciaire (A.P.J.) disposent d’une large ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00007", 'palette d’actes : saisine, transport sur les lieux, constatations, réquisitions, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00008", 'prélèvements et relevés signalétiques. '),
            ),
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00009", 'Ces actes demeurent encadrés par le code de procédure pénale afin de concilier efficacité de l’enquête et protection des libertés individuelles.'),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ]),
          const SizedBox(height: 12),

           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00010", 'Le procès-verbal de saisine ouvre concrètement l’enquête préliminaire.'),
          ),
           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00011", 'Les constatations et réquisitions permettent de rechercher la vérité en s’appuyant sur des examens techniques, scientifiques ou documentaires.'),
          ),
           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00012", 'Les prélèvements externes et relevés signalétiques complètent ces opérations en identifiant les personnes mises en cause.'),
          ),
          const SizedBox(height: 22),

          // =======================================================
          // 2.3.1 – SAISINE & TRANSPORT SUR LES LIEUX
          // (rappel synthétique pour situer les constatations)
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00013", '2.3.1 – La saisine & 2.3.2 – Le transport sur les lieux'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00014", '2.3.1 – La saisine')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00015", 'Le procès-verbal de saisine est le plus souvent ouvert :\n') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00016", '• à l’initiative de l’O.P.J., ou sous le contrôle de celui-ci, de l’A.P.J. ;\n') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00017", '• sur instructions écrites ou verbales du procureur de la République (art. 75 C.P.P.) ;\n') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00018", '• à la suite d’une plainte ou d’une dénonciation (art. 17 C.P.P.).'),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00019", 'À compter de ce premier procès-verbal, l’enquête préliminaire est formellement ouverte. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00020", 'L’O.P.J. dirige les premières investigations et rend compte au procureur des suites données.'),
              ),
              SizedBox(height: 14),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00021", '2.3.2 – Le transport sur les lieux')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00022", 'Le code de procédure pénale ne décrit pas spécifiquement le transport sur les lieux en matière ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00023", 'd’enquête préliminaire. Les enquêteurs conservent pourtant la faculté de se rendre sur place ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00024", 'pour effectuer les premières constatations utiles.'),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00025", 'Lorsque les lieux sont privés, l’introduction dans ceux-ci est subordonnée à l’autorisation ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00026", 'expresse de l’occupant habituel ou de son représentant. Cette autorisation est verbale mais ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00027", 'doit être consignée dans la procédure. Elle ne doit pas être confondue avec l’assentiment ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00028", 'exprès et écrit exigé en matière de perquisition ou de saisie de pièces à conviction.'),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3 – LES CONSTATATIONS ET RÉQUISITIONS
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00029", '2.3.3 – Les constatations et réquisitions'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00030", 'Les constatations regroupent l’ensemble des opérations d’examen des lieux, objets, documents ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00031", 'ou personnes, destinées à conserver les traces et indices utiles à la manifestation de la vérité. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00032", 'Elles peuvent s’accompagner de réquisitions, qui permettent à l’autorité judiciaire ou à l’O.P.J. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00033", 'de solliciter l’intervention de personnes ou organismes extérieurs (médecins, experts, opérateurs, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00034", 'banques, administrations, etc.).'),
              ),
              SizedBox(height: 10),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00035", 'Les constatations et réquisitions en enquête préliminaire sont principalement encadrées par les articles '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00036", '77-1 à 77-1-4, 60, 60-1, 60-2, 60-3, 230-28 et suivants, 230-32 à 230-44 du C.P.P., '),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00037", 'ainsi que par les dispositions relatives aux données de connexion et à la géolocalisation.'),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3.1 – LES RÉQUISITIONS JUDICIAIRES (ART. 77-1 C.P.P.)
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00038", '2.3.3.1 – Les réquisitions judiciaires (art. 77-1 C.P.P.)'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00039", 'Les constatations ne sont évoquées qu’indirectement par l’article 77-1 du C.P.P. qui dispose que : '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00040", '“S’il y a lieu de procéder à des constatations ou à des examens techniques ou scientifiques, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00041", 'le procureur de la République, ou, sur autorisation de celui-ci, l’officier ou l’agent de police ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00042", 'judiciaire ou, sous le contrôle de ces derniers, l’assistant d’enquête, a recours à toutes personnes qualifiées.”'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00043", 'Les dispositions des quatre derniers alinéas de l’article 60 sont applicables : la personne requise ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00044", 'intervient sous serment, à charge pour elle de déposer un rapport détaillé et d’apposer sa signature ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00045", 'sur les scellés le cas échéant.'),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00046", 'Objectif du dispositif'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00047", 'Le législateur a souhaité encadrer les nombreuses réquisitions d’examens ou d’expertises en ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00048", 'matière de petites infractions, en rappelant que seules les opérations réellement nécessaires ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00049", 'à la manifestation de la vérité doivent être ordonnées.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================================================
          // 2.3.3.1.1 – RÉQUISITIONS À PERSONNES QUALIFIÉES
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00050", '2.3.3.1.1 – Les réquisitions à personnes qualifiées (art. 77-1 & 60 C.P.P.)'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00051", 'Le procureur de la République peut, par la voie d’instructions générales prises en application ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00052", 'de l’article 39-3, autoriser les O.P.J. et, sous leur contrôle, les A.P.J. ou assistants d’enquête, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00053", 'à requérir toutes personnes qualifiées afin d’effectuer des examens techniques ou scientifiques : ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00054", 'médecins, psychologues, techniciens, experts, services de police technique et scientifique, etc.'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00055", 'Examens ou constatations sur la victime ou la personne mise en cause (traumatologie, alcoolémie, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00056", 'toxicologie, examens psychologiques…).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00057", 'Examens médicaux ou psychologiques demandés à la victime d’infractions graves, notamment celles visées ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00058", 'à l’article 706-47 ou réalisées dans le cadre de l’article 706-115 C.P.P.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00059", 'Jurisprudence'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00060", 'La mission confiée en application de l’article 77-1 du C.P.P. à une “personne qualifiée” ne peut pas ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00061", 'dégénérer en véritable expertise judiciaire cachée. Lorsque les investigations requises dépassent la ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00062", 'simple constatation technique pour emporter une analyse approfondie, il convient de recourir au régime ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00063", 'de l’expertise contradictoire.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3.1.2 – RÉQUISITIONS D’ORDRE GÉNÉRAL
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00064", '2.3.3.1.2 – Les réquisitions d’ordre général (art. 77-1-1 C.P.P.)'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00065", 'Le procureur de la République ou, sur son autorisation, l’O.P.J. ou l’A.P.J. peut adresser des réquisitions ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00066", 'd’ordre général à toute personne, service ou organisme, public ou privé, pour la remise d’informations ou de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00067", 'documents utiles à l’enquête : enregistrements de vidéo-protection, images, listes de salariés ou d’usagers, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00068", 'contrats, données administratives, etc.'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00069", 'Les réquisitions peuvent viser, par exemple, des établissements bancaires, des sociétés de transport, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00070", 'des employeurs, des collectivités, des organismes sociaux ou des sociétés privées.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00071", 'Le secret professionnel ne peut être opposé que lorsqu’il est directement et légalement protégé ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00072", '(avocats, médecins, journalistes pour la protection des sources, etc.).'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00073", 'Le refus injustifié de déférer à une réquisition régulièrement formulée est susceptible de constituer ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00074", 'l’infraction prévue par l’article R. 642-1 du code pénal.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3.1.3 – DONNÉES DE CONNEXION
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00075", '2.3.3.1.3 – Réquisitions portant sur les données de connexion (art. 77-1-2 & 77-1-3 C.P.P.)'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00076", 'Les réquisitions visant les données de connexion ne peuvent être effectuées que si l’enquête porte sur un crime ou sur un délit puni '),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00077", 'd’au moins trois ans d’emprisonnement, '),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00078", 'ou dans certaines hypothèses particulières (entraîde pénale internationale, disparition inquiétante, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00079", 'criminalité grave, etc.).'),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00080", 'Données techniques permettant d’identifier la source de la connexion ou les équipements terminaux utilisés ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00081", '(adresse IP, identifiant de connexion, numéro de téléphone, données de facturation, etc.).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00082", 'Données de trafic et de localisation, permettant de reconstituer le parcours d’une communication ou les ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00083", 'déplacements d’un appareil.'),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00084", 'Ces données sont détenues par les fournisseurs d’accès à Internet, les hébergeurs de contenus en ligne ou les ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00085", 'opérateurs de communications électroniques. La Cour de cassation, à la suite de décisions européennes, a insisté ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00086", 'sur la nécessité d’un contrôle renforcé du recours à ces réquisitions, compte tenu de l’atteinte portée à la vie privée.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00087", 'Contrôle de proportionnalité'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00088", 'Le juge doit vérifier, en cas de contestation, que la réquisition de données de connexion était justifiée ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00089", 'par la gravité des faits, la complexité de l’enquête et l’existence d’indices sérieux, et qu’elle ne portait ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00090", 'pas atteinte de façon disproportionnée aux droits fondamentaux.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3.1.4 – RÉQUISITIONS INFORMATIQUES OU TÉLÉPHONIQUES
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00091", '2.3.3.1.4 – Les réquisitions informatiques ou téléphoniques'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00092", 'Sur autorisation du procureur de la République, l’O.P.J. ou l’A.P.J. peut requérir des organismes publics ou des ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00093", 'personnes morales de droit privé la mise à disposition d’informations utiles conservées dans des systèmes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00094", 'informatiques : historique de connexions, contenus de comptes, données techniques, enregistrements de vidéosurveillance, etc.'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00095", 'Les limitations de l’article 60-1-2 du C.P.P. s’appliquent, notamment pour les données de connexion et les ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00096", 'données sensibles relatives à la vie privée.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00097", 'Les services de police technique et scientifique peuvent être réquisitionnés directement pour procéder ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00098", 'aux extractions et analyses, sans qu’il soit nécessaire d’établir une réquisition distincte pour chaque agent intervenant.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00099", 'Refus de déférer'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00100", 'Le refus, sans motif légitime, de répondre à ces réquisitions est sanctionné. À l’inverse, les personnes ou ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00101", 'organismes bénéficiant d’un secret spécialement protégé par la loi peuvent opposer ce secret lorsque les ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00102", 'demandes d’informations le mettraient gravement en péril.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3.1.5 – RÉQUISITIONS AUX FINS D’AUTOPSIE
          // =======================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00103", '2.3.3.1.5 – Les réquisitions aux fins d’autopsie'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00104", 'L’article 230-28 du C.P.P. prévoit que, dans le cadre d’une enquête préliminaire, une autopsie peut être ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00105", 'ordonnée lorsque les circonstances du décès apparaissent suspectes ou lorsque la cause de la mort doit être ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00106", 'déterminée avec précision. L’O.P.J. agit alors sur réquisitions écrites du procureur de la République.'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00107", 'Seul un médecin qualifié en médecine légale, titulaire des titres requis, peut être désigné pour pratiquer une autopsie judiciaire.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00108", 'Les prélèvements effectués lors de l’autopsie (sang, organes, fragments biologiques) sont placés sous scellés et peuvent ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00109", 'donner lieu à des analyses complémentaires ou à une contre-expertise.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00110", 'Information des proches'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00111", 'Sous réserve des nécessités de l’enquête, la famille ou les proches du défunt sont informés de la ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00112", 'réalisation de l’autopsie et de la restitution ultérieure du corps. La conservation prolongée du corps ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00113", 'ou de certaines pièces n’est admise que si elle est indispensable à la manifestation de la vérité.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3.1.6 – GÉOLOCALISATION EN TEMPS RÉEL
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00114", '2.3.3.1.6 – La géolocalisation en temps réel (art. 230-32 à 230-44 C.P.P.)'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00115", 'Des réquisitions peuvent être établies afin de suivre, en temps réel et à son insu ou avec son consentement, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00116", 'les déplacements d’une personne, d’un véhicule ou d’un objet au moyen d’un dispositif de géolocalisation ou ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00117", 'du système intégré d’un terminal (téléphone, boîtier GPS embarqué, etc.).'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00118", 'La mesure ne peut être utilisée que pour les crimes et délits punis d’au moins trois ans d’emprisonnement, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00119", 'lorsque les nécessités de l’enquête l’exigent.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00120", 'En enquête préliminaire, l’autorisation initiale appartient au procureur de la République pour une durée ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00121", 'limitée (8 jours pour le droit commun, 15 jours pour certaines infractions graves), renouvelable sous le contrôle du J.L.D.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00122", 'L’introduction dans un domicile pour installer ou retirer un dispositif de géolocalisation suppose une ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00123", 'ordonnance écrite et motivée du juge des libertés et de la détention.'),
              ),
              SizedBox(height: 10),
              _ExempleBox(
                title:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00124", 'Tableau de synthèse – Mise en œuvre de la géolocalisation'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00125", 'Champ d’application : crimes et délits punis d’au moins 3 ans ; toute personne ou tout objet, même à son insu. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00126", 'Décision initiale : procureur de la République ; renouvellements : J.L.D. pour des périodes d’un mois renouvelables ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00127", 'dans la limite d’un an pour le droit commun (ou de deux ans pour certaines infractions de criminalité organisée). ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00128", 'Activation à distance d’un appareil électronique : réservée aux infractions les plus graves, sur autorisation écrite ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00129", 'et motivée du J.L.D., sans possibilité de viser certaines catégories protégées (avocat, magistrat, journaliste, parlementaire…).'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00130", 'Lien avec les lieux privés'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00131", 'Lorsque l’installation du dispositif nécessite une pénétration dans des lieux privés (domicile, dépendance, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00132", 'cabinet professionnel), les règles applicables à l’introduction dans les lieux privés et au contrôle du J.L.D. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00133", 'doivent être scrupuleusement respectées.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =======================================================
          // 2.3.3.2 – PRÉLÈVEMENTS EXTERNES & RELEVÉS SIGNALETIQUES
          // =======================================================
          _ConditionCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00134", '2.3.3.2 – Les prélèvements externes et les relevés signalétiques'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00135", 'Le procureur de la République ou, sur son autorisation, l’O.P.J. ou l’A.P.J. peut faire procéder, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00136", 'sur toute personne mise en cause ou tout témoin utile, à des prélèvements externes ou à des relevés ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00137", 'signalétiques nécessaires aux examens techniques et scientifiques de comparaison (art. 76-2-1 C.P.P.).'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00138", 'Empreintes digitales, palmaires ou photographies destinées à l’alimentation de fichiers de police.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00139", 'Prélèvements biologiques superficiels (salive, cheveux, etc.) aux fins d’analyses génétiques ou d’autres comparaisons scientifiques.'),
              ),
              SizedBox(height: 8),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00140", 'Le refus injustifié de se soumettre à certaines opérations de signalisation ou de prélèvement, alors qu’elles ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00141", 'constituent le seul moyen d’identifier une personne ou de vérifier son implication, est pénalement sanctionné. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00142", 'Les règles protectrices de l’article 55-1 du C.P.P. restent applicables en enquête préliminaire.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00143", 'Ces opérations doivent respecter la dignité de la personne et, sauf urgence particulière, être réalisées ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00144", 'dans des locaux adaptés, à l’abri du regard du public. Lorsque la mesure porte sur un mineur ou une personne ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/enquete_preliminaire/enquete_preliminaire_constatations_requisitions_page.dart", "f00145", 'vulnérable, des garanties supplémentaires (présence d’un représentant légal, information adaptée) sont nécessaires.'),
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

/// ------------------------------------------------------------------
/// CARTE GLOBALE POUR CHAQUE BLOC (A / B / C…)
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// TITRE DE SOUS-PARTIE (2.3.3.1, 2.3.3.1.1, etc.)
/// ------------------------------------------------------------------
class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.fustat(
          fontWeight: FontWeight.w700,
          fontSize: 14.5,
          color: color,
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PARAGRAPHES SIMPLES OU RICHES
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;

  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final isRich = spans != null;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    if (!isRich) {
      return Text(
        text ?? '',
        textAlign: TextAlign.justify,
        style: GoogleFonts.fustat(
          fontSize: 14,
          height: 1.4,
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
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: spans,
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// PUCE D’INTRO
/// ------------------------------------------------------------------
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

/// ------------------------------------------------------------------
/// PUCE CLASSIQUE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_rounded, size: 18, color: bulletColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.fustat(
                fontSize: 14,
                height: 1.35,
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

/// ------------------------------------------------------------------
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .65 : .9),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: GoogleFonts.fustat(
                fontSize: 13.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? Colors.white70
                    : const Color(0xFF102027).withValues(alpha: .95),
              ),
              children: bodySpans,
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC NOTA / INFO / SANCTION
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

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
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 13.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
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
