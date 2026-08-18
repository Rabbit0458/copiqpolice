import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — ENQUÊTE DE FLAGRANT DÉLIT
///  CHAPITRE 3 : LA PROCÉDURE DE FLAGRANT DÉLIT
///
///  Plan repris du mémento :
///   3.1  Les autorités habilitées
///        3.1.1  Le procureur de la République
///        3.1.2  Les officiers de police judiciaire
///   3.2  La durée de l’enquête
///        3.2.1  Durée initiale
///        3.2.2  Prolongation de la durée
///   3.3  Les actes de la procédure
///        3.3.1  La saisine
///        3.3.2  La plainte (généralités, en ligne, visio-plainte,
///               violences conjugales, droits et protection des victimes)
///        3.3.3  Les constatations (traces, indices, investissement des lieux,
///               prélèvements externes et relevés signalétiques)
///        3.3.4  Les perquisitions (principes + limitations liées aux lieux)
/// ===================================================================
class PaFlagrantDelitProcedurePage extends StatelessWidget {
  const PaFlagrantDelitProcedurePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/enquete_flagrant_delit/chapitre3';

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
          tooltip: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00001", 'Retour'),
        ),
        title: Text(
          ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00002", 'Procédure de flagrant délit'),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ---------------------------------------------------------
          // TITRE GÉNÉRAL
          // ---------------------------------------------------------
          Text(
            ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00003", 'Chapitre 3 — La procédure de flagrant délit'),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),

           _Paragraph(
            ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00004", 'L’enquête de flagrant délit se caractérise par l’urgence et par des pouvoirs ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00005", 'élargis reconnus aux autorités de police judiciaire. Ce chapitre précise : ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00006", 'quelles autorités peuvent agir, pendant combien de temps l’enquête peut se ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00007", 'poursuivre, et quels sont les principaux actes de procédure réalisables en ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00008", 'flagrance (saisine, plainte, constatations, perquisitions, etc.).'),
          ),
          const SizedBox(height: 14),

           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00009", 'Les autorités habilitées à conduire une enquête de flagrant délit sont strictement déterminées par le code de procédure pénale.'),
          ),
           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00010", 'La durée de l’enquête est limitée dans le temps mais peut être prolongée dans des conditions précises.'),
          ),
           _IntroBullet(
            text:
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00011", 'Les actes de la procédure (plainte, constatations, perquisitions…) sont encadrés afin de concilier efficacité de l’enquête et protection des libertés.'),
          ),
          const SizedBox(height: 20),

          // =========================================================
          // 3.1 — LES AUTORITÉS HABILITÉES
          // =========================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00012", '3.1 — Les autorités habilitées'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00013", 'Plusieurs autorités peuvent accomplir les actes de police judiciaire en ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00014", 'flagrant délit : le procureur de la République, les officiers de police ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00015", 'judiciaire de “plein exercice” et, pour certains actes déterminés, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00016", 'd’autres acteurs mentionnés par le code de procédure pénale.'),
              ),
              SizedBox(height: 12),

              // 3.1.1 Procureur
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00017", '3.1.1 — Le procureur de la République')),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00018", 'En plus de ses pouvoirs de direction et de contrôle de l’enquête, le procureur de la République peut lui-même accomplir les actes de police judiciaire en flagrant délit. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00019", 'Il dispose, sur tout le territoire national, des pouvoirs attachés à la qualité d’officier de police judiciaire prévus par le code de procédure pénale.'),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ]),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00020", 'Il peut se transporter sur tout le territoire, y compris dans le cadre d’une demande d’entraide adressée à un État étranger, afin d’y procéder à des actes d’enquête ou à des auditions.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00021", 'En matière d’infractions flagrantes, il exerce les pouvoirs qui lui sont attribués par les dispositions du code de procédure pénale (direction des opérations, instructions données à l’officier de police judiciaire, décisions relatives à la garde à vue, etc.).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00022", 'Il peut décider du recours à certaines mesures coercitives : mandat de recherche en cas de crime ou délit flagrant puni d’au moins trois années d’emprisonnement, demandes de prolongation de garde à vue, ouverture d’une information judiciaire lorsque le juge d’instruction est présent sur les lieux, etc.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00023", 'En dehors du cadre strict de la flagrance, le procureur de la République choisit librement le service ou la unité de police auxquels il confie l’enquête, sans être obligé de se déplacer personnellement sur les lieux.'),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 3.1.2 OPJ
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00024", '3.1.2 — Les officiers de police judiciaire')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00025", 'Seuls les officiers de police judiciaire de “plein exercice”, énumérés par les articles 16 et 16-1 du code de procédure pénale, sont compétents pour conduire une enquête de flagrant délit.'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00026", 'Ils disposent, en flagrance, de pouvoirs élargis portant atteinte aux libertés individuelles (perquisitions, saisies, placements en garde à vue, etc.), dans le strict respect des conditions légales.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00027", 'Certaines infractions particulières (infractions routières, atteintes involontaires à la vie ou à l’intégrité physique à l’occasion d’accidents de la circulation) relèvent de règles de compétence spécifiques prévues par le code.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00028", 'Autres intervenants possibles'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00029", 'En plus des magistrats et des officiers de police judiciaire, la loi peut confier l’accomplissement de certains actes relevant de la flagrance à : '),
                  ),
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00030", 'des agents de police judiciaire, des assistants d’enquête ou encore, pour l’appréhension de l’auteur présumé dans un lieu public, à tout citoyen en vertu de l’article 73 du code de procédure pénale.'),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =========================================================
          // 3.2 — LA DURÉE DE L’ENQUÊTE
          // =========================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00031", '3.2 — La durée de l’enquête de flagrant délit'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00032", 'L’enquête de flagrant délit est par nature une enquête d’urgence. Sa durée est strictement encadrée par le code de procédure pénale, avec une durée initiale et une éventuelle prolongation sous conditions.'),
              ),
              SizedBox(height: 12),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00033", '3.2.1 — La durée initiale')),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00034", 'L’enquête de flagrance peut se poursuivre “sans discontinuer” pendant une durée maximale de huit jours, sous le contrôle du procureur de la République. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00035", 'La jurisprudence retient qu’il doit exister une continuité dans les actes d’investigation réalisés, et non simplement dans la rédaction des procès-verbaux.'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00036", 'Jurisprudence'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00037", 'Ce qui importe pour apprécier la validité de l’enquête, c’est la continuité des actes d’enquête et non la date à laquelle ils sont consignés par écrit. Une interruption prolongée rompt le caractère de flagrance et impose de basculer, le cas échéant, sur un autre cadre (enquête préliminaire, commission rogatoire…).'),
                  ),
                ],
              ),

              SizedBox(height: 16),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00038", '3.2.2 — La prolongation de la durée')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00039", 'Le procureur de la République peut décider de prolonger l’enquête de flagrant délit pour une nouvelle durée maximale de huit jours, lorsque deux conditions cumulatives sont réunies.'),
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00040", 'L’infraction en cause est un crime ou un délit puni d’une peine d’emprisonnement d’au moins cinq années.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00041", 'Les investigations nécessaires à la manifestation de la vérité ne peuvent pas être différées sans compromettre l’enquête (complexité des faits, multiplicité des actes à réaliser, opération de grande ampleur, etc.).'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00042", 'Dès lors qu’il n’y a plus urgence ou qu’une interruption durable survient dans le déroulement des opérations, l’enquête ne peut plus être poursuivie sous le régime de la flagrance et doit être requalifiée (enquête préliminaire ou information judiciaire).'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =========================================================
          // 3.3 — LES ACTES DE LA PROCÉDURE
          // =========================================================
          _ConditionCard(
            title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00043", '3.3 — Les actes de la procédure de flagrant délit'),
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00044", 'L’enquête de flagrant délit comprend de nombreux actes permettant, si nécessaire, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00045", 'le recours à la contrainte. Ils relèvent exclusivement de l’officier de police ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00046", 'judiciaire, sous la direction du procureur de la République.'),
              ),
              SizedBox(height: 14),

              // 3.3.1 SAISINE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00047", '3.3.1 — La saisine')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00048", 'La saisine de l’officier de police judiciaire résulte de la connaissance d’une ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00049", 'situation de flagrance : appel de la victime, information par un témoin, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00050", 'interpellation directe, découverte de faits en patrouille, etc. Dès le premier ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00051", 'procès-verbal de saisine, l’enquête de flagrant délit est ouverte et doit être ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00052", 'conduite sans délai.'),
              ),

              SizedBox(height: 12),

              // 3.3.2 PLAINTE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00053", '3.3.2 — La plainte')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00054", 'La plainte constitue un acte central de la procédure : elle permet au victime ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00055", 'd’officialiser les faits dont elle a été la cible, ouvre la possibilité de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00056", 'poursuites et déclenche des obligations précises à la charge des services de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00057", 'police judiciaire.'),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00058", '3.3.2.1 — Généralités (article 15-3 du code de procédure pénale)'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00059", 'Les officiers et agents de police judiciaire sont tenus de recevoir les plaintes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00060", 'déposées par les victimes d’infractions à la loi pénale, quel que soit le lieu ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00061", 'de commission des faits.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00062", 'Toute plainte donne lieu à procès-verbal et à la délivrance d’un récépissé ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00063", 'mentionnant les délais de prescription de l’action publique et la possibilité ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00064", 'd’interrompre ce délai par une constitution de partie civile.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00065", 'Si la victime en fait la demande, une copie du procès-verbal de plainte lui est remise immédiatement.'),
              ),

              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00066", '3.3.2.2 — Les plaintes en ligne')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00067", 'Un dispositif de plainte dématérialisée permet, pour certains types d’infractions, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00068", 'de déposer plainte ou de prendre rendez-vous avec un service de police ou de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00069", 'gendarmerie via une plateforme en ligne. Il concerne notamment certaines escroqueries ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00070", 'ou arnaques commises sur internet.'),
              ),

              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00071", '3.3.2.3 — La « visio-plainte »')),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00072", 'Le code de procédure pénale autorise, dans des conditions strictement définies, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00073", 'la prise de plainte à distance par moyen de télécommunication audiovisuelle. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00074", 'Ce dispositif vise en particulier les victimes d’infractions graves ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00075", '(violences, infractions sexuelles, etc.), afin de limiter leurs déplacements ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00076", 'tout en garantissant la confidentialité de leurs déclarations.'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),

              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00077", '3.3.2.4 — La plainte pour violences conjugales')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00078", 'Dans le cadre de la politique publique de lutte contre les violences conjugales, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00079", 'des mesures spécifiques améliorent l’accueil et la prise en charge des victimes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00080", 'dans les services de police et de gendarmerie : circuits dédiés, formation des ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00081", 'intervenants, possibilité de plaintes accompagnées, etc.'),
              ),

              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00082", '3.3.2.5 — Les droits des victimes d’infraction')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00083", 'Le code de procédure pénale recense de nombreux droits qui doivent être notifiés ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00084", 'aux victimes dès le dépôt de plainte, par les officiers ou agents de police ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00085", 'judiciaire ou, sous leur contrôle, par les assistants d’enquête.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(text: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00086", 'Droit à la réparation du préjudice subi.')),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00087", 'Droit de se constituer partie civile et d’être assistée par un avocat.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00088", 'Droit d’être aidée par un service ou une association d’aide aux victimes.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00089", 'Droit d’obtenir des informations sur la procédure, sur les suites données à la plainte et sur les mesures de protection possibles.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00090", 'Droit, dans certains cas, de déclarer une adresse de domiciliation (professionnelle ou celle d’un tiers) pour la réception du courrier judiciaire.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00091", 'Information des droits'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00092", 'L’information de ces droits peut être faite par tout moyen, notamment par la remise d’un document écrit ou d’un récépissé de dépôt de plainte conforme aux modèles officiels. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00093", 'Le non-respect de ces obligations peut être analysé comme une atteinte aux droits de la défense ou aux droits des victimes.'),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00094", '3.3.2.7 — Mesures de protection applicables à toute victime'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00095", 'Plusieurs dispositions prévoient des mesures de protection dès le stade de la plainte ou au cours de l’enquête :'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00096", 'Droit à l’assistance d’un interprète et à la traduction des documents essentiels lorsque la victime ne comprend pas la langue française.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00097", 'Droit d’être accompagnée, à tous les stades de la procédure, par un tiers de confiance (parent, proche, association d’aide aux victimes) ou par un avocat.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00098", 'Possibilité d’organiser les auditions dans des locaux adaptés, à huis clos, et de limiter le nombre d’intervenants pour éviter toute revictimisation.'),
              ),

              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00099", '3.3.2.8 — Évaluation personnalisée des besoins de protection'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00100", 'Les articles 10-5 et suivants du code de procédure pénale imposent une ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00101", 'évaluation personnalisée des besoins de protection de la victime afin de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00102", 'déterminer si des mesures spéciales doivent être mises en œuvre :'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00103", 'Importance du préjudice subi et gravité des faits (violences, infractions sexuelles, etc.).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00104", 'Situation particulière de la victime (âge, grossesse, handicap, vulnérabilité psychologique ou sociale).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00105", 'Existence d’un risque d’intimidation, de représailles, ou d’une emprise exercée par l’auteur présumé.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00106", 'Cette évaluation initiale est réalisée par l’officier ou l’agent de police judiciaire et transmise à l’autorité judiciaire, qui décidera de l’opportunité de mesures de protection renforcées ou de l’orientation de la victime vers une association spécialisée.'),
                  ),
                ],
              ),

              SizedBox(height: 14),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00107", '3.3.2.9 — Mesures de protection spécifiques (articles D.1-6 et D.1-7 du code de procédure pénale)'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00108", 'Compte tenu de l’évaluation personnalisée, l’enquêteur peut mettre en place des mesures adaptées : auditions dans des locaux spécialement aménagés, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00109", 'auditions par un enquêteur formé, dispositifs de protection technique ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00110", '(téléphone grave danger, dispositif électronique anti-rapprochement, etc.), ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00111", 'ou accompagnement renforcé pour certaines victimes (en particulier en cas de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00112", 'violences sexuelles, violences conjugales, infractions commises en raison du ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00113", 'genre ou de l’orientation de la victime).'),
              ),

              SizedBox(height: 18),

              // 3.3.3 CONSTATATIONS
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00114", '3.3.3 — Les constatations')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00115", 'Les constatations sont précédées, si nécessaire, d’un transport sur les lieux qui doit intervenir sans délai. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00116", 'Il s’agit d’examiner visuellement les lieux de l’infraction, de conserver les indices ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00117", 'et tout élément pouvant servir à la manifestation de la vérité.'),
              ),
              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00118", '3.3.3.1 — Préservation des traces et indices')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00119", 'L’officier de police judiciaire veille à la conservation des indices susceptibles de disparaître ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00120", 'et de tout ce qui peut servir à la manifestation de la vérité : saisie d’armes, d’instruments, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00121", 'd’objets ou de tout bien paraissant provenir de l’infraction. Des périmètres de sécurité, scellés ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00122", 'ou mesures conservatoires peuvent être mis en place.'),
              ),

              SizedBox(height: 8),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00123", '3.3.3.2 — Investissement des lieux')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00124", 'Présent sur les lieux, l’officier de police judiciaire peut interdire à toute personne de quitter ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00125", 'les lieux de l’infraction avant la clôture des opérations, conserver sur place des témoins clés, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00126", 'et, le cas échéant, prendre des mesures coercitives pour maintenir un suspect à disposition le temps ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00127", 'nécessaire aux premières vérifications, dans le respect des règles encadrant la garde à vue.'),
              ),

              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00128", '3.3.3.3 — Prélèvements externes et relevés signalétiques'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00129", 'L’officier de police judiciaire peut faire procéder à des prélèvements externes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00130", '(traces biologiques, empreintes digitales, relevés signalétiques) ou à des prises ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00131", 'de photographies, dans les conditions prévues par le code de procédure pénale. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00132", 'Ces opérations sont strictement encadrées, notamment lorsqu’elles sont réalisées ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00133", 'sans le consentement de la personne mise en cause.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00134", 'Jurisprudence'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00135", 'Le refus injustifié de se soumettre à certaines opérations de signalisation ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00136", 'ou de prélèvement ordonnées dans le cadre légal peut constituer un délit autonome. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00137", 'Lorsque la prise d’empreintes ou de photographies est le seul moyen d’identifier ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00138", 'une personne gardée à vue, son refus est pénalement sanctionné.'),
                  ),
                ],
              ),

              SizedBox(height: 18),

              // 3.3.4 PERQUISITIONS
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00139", '3.3.4 — Les perquisitions')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00140", 'La perquisition est la recherche, dans les lieux privés, d’objets, de documents ou ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00141", 'de données informatiques relatifs aux faits incriminés. Elle ne peut être réalisée ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00142", 'que par le procureur de la République ou par un officier de police judiciaire, dans ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00143", 'les conditions fixées par le code de procédure pénale.'),
              ),
              SizedBox(height: 8),

              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00144", 'Le “domicile” s’entend largement : résidence principale, résidence secondaire, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00145", 'dépendances (cave, garage) ou tout local assimilé à un domicile par la jurisprudence. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00146", 'Certaines catégories de lieux bénéficient toutefois d’une protection renforcée ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00147", '(cabinet d’avocat, entreprise de presse, lieux couverts par le secret de la défense nationale, etc.), ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00148", 'impliquant l’intervention d’un magistrat et le respect de règles complémentaires.'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00149", '3.3.4.1 — Limitation de la perquisition quant aux lieux'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00150", 'En raison de la nature particulière de certains lieux, la perquisition est encadrée ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00151", 'par des formalités renforcées : locaux diplomatiques, cabinets d’avocats, entreprises ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00152", 'de presse ou de communication audiovisuelle, locaux abritant des éléments couverts par ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00153", 'le secret de la défense nationale, etc. Dans ces situations, la loi exige la présence ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00154", 'ou l’autorisation préalable d’un magistrat, ainsi que le respect strict du secret ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00155", 'professionnel, du secret des sources et de la liberté de la presse.'),
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00156", 'Exemple pratique'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00157", 'La perquisition dans un cabinet d’avocat ne peut être réalisée que par un magistrat, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00158", 'en présence du bâtonnier ou de son représentant. Les documents saisis doivent être ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00159", 'directement liés à l’infraction recherchée, et l’ordonnance autorisant la perquisition ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00160", 'peut faire l’objet d’un recours dans un délai strictement encadré.'),
                  ),
                ],
              ),
              SizedBox(height: 14),

              // --- Lieux spécialement protégés (presse, médecins, défense, etc.) ---
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00161", 'Dans les locaux d’une entreprise de presse ou d’une entreprise de communication audiovisuelle, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00162", 'les perquisitions ne peuvent être effectuées que par un magistrat. Elles doivent respecter ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00163", 'la liberté de la presse et le secret des sources : la décision doit être écrite, motivée, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00164", 'et le contenu des documents saisis ne peut être examiné qu’aux conditions prévues par la loi. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00165", 'Un procès-verbal spécifique est dressé et un double du document saisi est remis à ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00166", 'l’entreprise de presse ou de communication audiovisuelle.'),
                ),
              ]),
              SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00167", 'Les perquisitions réalisées dans le cabinet d’un médecin, d’un notaire, d’un huissier, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00168", 'ou dans les locaux d’une juridiction ou d’une juridiction internationale, sont également ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00169", 'strictement encadrées : elles nécessitent l’intervention d’un magistrat et, le plus souvent, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00170", 'la présence du responsable de l’ordre ou de l’organisation professionnelle concernée.'),
              ),
              SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00171", 'Lorsque les lieux sont couverts par le secret de la défense nationale, la perquisition ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00172", 'est soumise à un régime très spécifique : liste limitative de sites, information de la Commission ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00173", 'du secret de la défense nationale, mise sous scellés des éléments classifiés et conservation ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00174", 'de ceux-ci par la Commission, selon des modalités entièrement dérogatoires.'),
              ),
              SizedBox(height: 16),

              // 3.3.4.2 LIMITATION DANS LE TEMPS
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00175", '3.3.4.2 — Limitation de la perquisition dans le temps'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00176", 'La durée et l’horaire des perquisitions sont, en principe, encadrés. Les règles varient ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00177", 'selon qu’elles sont réalisées pendant les heures légales (6h–21h) ou en dehors de ces heures, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00178", 'dans les hypothèses de perquisitions dites “de nuit”.'),
              ),
              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00179", '3.3.4.2.1 — Les heures légales')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00180", 'Les perquisitions ne peuvent commencer qu’entre 6 heures et 21 heures (art. 59 C.P.P.). ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00181", 'Toute perquisition entamée avant 21 heures peut se poursuivre au-delà de cette heure, à condition ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00182", 'qu’elle se déroule sans discontinuer dans les différents lieux concernés.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: 'Principe',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00183", 'Le respect des heures légales s’apprécie au moment de la première ouverture de porte. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00184", 'Le procès-verbal de perquisition doit permettre de vérifier que la perquisition a bien ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00185", 'débuté dans cette plage horaire.'),
                  ),
                ],
              ),
              SizedBox(height: 8),

              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00186", 'Si des constatations ou une découverte incidente sont réalisées en dehors des heures légales ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00187", 'alors qu’aucune perquisition n’a été autorisée de nuit, l’O.P.J. informe le magistrat, décrit les ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00188", 'éléments constatés et, le cas échéant, suspend les opérations pour les reprendre ultérieurement ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00189", 'dans le cadre légal.'),
              ),
              SizedBox(height: 12),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00190", '3.3.4.2.2 — Hors heures légales')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00191", 'En dehors des heures légales, la perquisition n’est possible que dans les cas strictement prévus ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00192", 'par la loi, notamment :'),
              ),
              SizedBox(height: 4),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00193", 'Une “réclamation faite de l’intérieur de la maison”, c’est-à-dire une demande claire et ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00194", 'non équivoque de l’occupant d’ouvrir aux enquêteurs (art. 59 C.P.P.).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00195", 'Certaines enquêtes en matière de criminalité organisée, de trafic de stupéfiants, de traite ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00196", 'des êtres humains ou de proxénétisme, sur autorisation du juge des libertés et de la détention ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00197", 'à la requête du procureur de la République (art. 59-1 et 706-89 et s. C.P.P.).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00198", 'La nécessité de prévenir un risque imminent d’atteinte à la vie ou à l’intégrité physique, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00199", 'ou un risque de disparition immédiate de preuves et d’indices (conditions de fond du régime ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00200", 'des perquisitions de nuit).'),
              ),
              SizedBox(height: 8),

              _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00201", 'Perquisitions de nuit (art. 59-1 C.P.P.)'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00202", 'Elles concernent principalement les crimes flagrants contre les personnes ou les infractions ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00203", 'relevant de la criminalité organisée. Elles nécessitent une ordonnance écrite et motivée du ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00204", 'juge des libertés et de la détention, saisie à la requête du procureur. Le magistrat contrôle ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00205", 'le déroulement des opérations et doit être informé dans les meilleurs délais des actes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00206", 'accomplis par l’O.P.J.'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // 3.3.4.3 PERSONNES POUVANT FAIRE L’OBJET D’UNE PERQUISITION
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00207", '3.3.4.3 — Personnes pouvant faire l’objet d’une perquisition'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00208", 'Selon l’article 56 alinéa 1 du C.P.P., les perquisitions s’effectuent au domicile des personnes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00209", 'qui “paraissent avoir participé au crime ou au délit” ou qui paraissent détenir des pièces, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00210", 'documents ou objets relatifs aux faits incriminés. Elles ne peuvent être réalisées qu’en présence ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00211", 'de la personne concernée ou, à défaut, de son représentant ou de témoins requis.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00212", 'Présence sur les lieux'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00213", 'L’article 57 C.P.P. impose, en flagrant délit, la présence de la personne au domicile de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00214", 'laquelle la perquisition a lieu ou, à défaut, celle de deux témoins requis par l’O.P.J. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00215", 'Le procès-verbal mentionne cette présence et est signé par les personnes présentes.'),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // 3.3.4.4 RÉTENTION DES PERSONNES
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00216", '3.3.4.4 — Rétention des personnes lors des perquisitions'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00217", 'Les personnes présentes lors d’une perquisition peuvent être retenues sur place pendant le temps ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00218", 'strictement nécessaire à l’accomplissement des opérations, afin de recueillir leurs explications ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00219", 'ou d’éviter la disparition d’objets, de documents ou de données informatiques (art. 56 al. 11 C.P.P.).'),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00220", 'Si la rétention se prolonge ou si les éléments recueillis justifient une mesure privative de liberté, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00221", 'il peut être recouru à la garde à vue, dans le strict respect des conditions légales et des formalités ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00222", 'd’information des droits.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Recours',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00223", 'Toute personne ayant fait l’objet d’une perquisition ou d’une visite domiciliaire, non suivie ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00224", 'de poursuites devant une juridiction d’instruction ou de jugement, peut saisir le juge des ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00225", 'libertés et de la détention pour contester la régularité de l’acte dans le délai d’un an ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00226", '(art. 802-2 C.P.P.).'),
                  ),
                ],
              ),
              SizedBox(height: 18),

              // ===================================================
              // 3.3.5 — LES FOUILLES DE PERSONNES
              // ===================================================
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00227", '3.3.5 — Les fouilles de personnes')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00228", 'Les fouilles de personnes obéissent à un régime distinct de celui des perquisitions. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00229", 'Elles peuvent relever soit de la fouille intégrale judiciaire, assimilée à une perquisition, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00230", 'soit des investigations corporelles décidées par un magistrat, soit encore des mesures de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00231", 'sécurité imposées à la personne gardée à vue.'),
              ),
              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00232", '3.3.5.1 — La fouille intégrale judiciaire')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00233", 'Prévue à l’article 63-7 du C.P.P., la fouille intégrale judiciaire est assimilée à une perquisition. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00234", 'Elle doit être motivée par les nécessités de l’enquête et respecter la dignité de la personne. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00235", 'Elle consiste en un examen minutieux des vêtements et, le cas échéant, en un déshabillage complet ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00236", 'lorsque aucun autre moyen moins intrusif ne permet d’atteindre le même résultat.'),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00237", 'La fouille intégrale doit être réalisée par un O.P.J. ou sous son contrôle, par une personne du même ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00238", 'sexe que la personne concernée. Les saisies utiles à l’enquête sont ensuite placées sous scellés.'),
              ),
              SizedBox(height: 12),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00239", '3.3.5.2 — Les investigations corporelles')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00240", 'Lorsque des investigations corporelles internes sont indispensables à la manifestation de la vérité ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00241", '(par exemple, recherche de corps étrangers), elles doivent être pratiquées par un médecin requis à cet effet, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00242", 'dans le strict respect de l’intégrité physique de la personne (art. 63-7 al. 2 C.P.P.).'),
              ),
              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00243", '3.3.5.3 — Les mesures de sécurité')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00244", 'Les mesures de sécurité prévues aux articles 63-5 et 63-6 du C.P.P. visent à s’assurer que la personne ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00245", 'gardée à vue ne détient aucun objet dangereux pour elle-même ou pour autrui. Elles ont un caractère ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00246", 'administratif et se distinguent de la fouille intégrale judiciaire.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(text: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00247", 'La palpation de sécurité ;')),
              _BulletPoint(
                text: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00248", 'L’utilisation de moyens de détection électronique ;'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00249", 'Le retrait d’objets ou d’effets susceptibles de constituer un danger pour la personne ou pour autrui ;'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00250", 'Le retrait de certains vêtements, lorsque le contexte et la gravité des faits l’exigent, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00251", 'dans des conditions respectueuses de la dignité de la personne.'),
              ),
              SizedBox(height: 8),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00252", '3.3.5.3.1 — La palpation de sécurité')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00253", 'Définie par le code de la sécurité intérieure, la palpation de sécurité consiste à découvrir et saisir ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00254", 'tout objet susceptible de constituer un danger pour la sécurité de la personne interpellée, des policiers ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00255", 'ou de tiers. Elle doit être pratiquée de façon méthodique et non humiliante, par une personne du même ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00256", 'sexe, au travers des vêtements.'),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00257", '3.3.5.3.2 — Utilisation de moyens de détection électronique'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00258", 'Les moyens de détection électronique (portiques, détecteurs manuels, etc.) complètent les palpations de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00259", 'sécurité. En cas d’impossibilité matérielle d’y recourir, l’O.P.J. ou l’A.P.J. en fait mention dans la procédure.'),
              ),
              SizedBox(height: 8),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00260", '3.3.5.3.3 — Retrait d’objets ou d’effets dangereux')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00261", 'Le retrait d’objets ou d’effets vise tout élément pouvant constituer un danger (lacets, ceintures, foulards, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00262", 'écharpes, bijoux, etc.). Les objets retirés sont placés sous scellés ou consignés dans un local sécurisé.'),
              ),
              SizedBox(height: 8),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00263", '3.3.5.3.4 — Retrait de vêtements')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00264", 'Le retrait de vêtements ne peut être systématique. Il doit être apprécié au cas par cas, en fonction notamment ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00265", 'des conditions de l’interpellation, de la nature des faits reprochés, des antécédents judiciaires, de l’état ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00266", 'de santé et de la vulnérabilité de la personne, ainsi que de la découverte éventuelle d’objets dangereux lors ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00267", 'de la palpation de sécurité.'),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00268", 'Cette mesure est limitée au strict nécessaire : la personne ne peut être invitée à retirer qu’un sous-vêtement ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00269", 'si celui-ci est susceptible de dissimuler un objet dangereux. Elle doit toujours être exécutée par une personne ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00270", 'du même sexe, dans un local fermé et hors la vue de tiers, et faire l’objet d’une mention précise dans le procès-verbal.'),
              ),
              SizedBox(height: 16),

              // ===================================================
              // 3.3.6 — FOUILLES DE VÉHICULES
              // ===================================================
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00271", '3.3.6 — Les fouilles de véhicules')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00272", 'Le véhicule n’est ni automatiquement assimilé au domicile, ni à sa dépendance. En flagrant délit, la fouille ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00273", 'du véhicule peut être réalisée par un O.P.J. sans le consentement de la personne, dès lors qu’il existe des ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00274", 'raisons plausibles de soupçonner une infraction et que les investigations sont utiles à la manifestation de la vérité.'),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00275", 'Les objets découverts et présentant un intérêt pour l’enquête sont saisis et placés sous scellés. Lorsque la fouille ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00276", 'intervient dans le cadre de contrôles routiers ou d’infractions spécifiques au code de la route, les règles particulières ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00277", 'des articles R.233-1, R.413-15 et suivants peuvent trouver à s’appliquer.'),
              ),
              SizedBox(height: 14),

              // ===================================================
              // 3.3.7 — LES SAISIES ET SCELLÉS
              // ===================================================
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00278", '3.3.7 — Les saisies et scellés')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00279", 'Saisir et placer sous scellés consiste à assurer l’authentification et la conservation des pièces à conviction ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00280", 'en vue de leur exploitation ultérieure au cours du procès pénal. Les saisies interviennent le plus souvent à ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00281", 'l’occasion de constatations, de fouilles ou de perquisitions.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00282", 'En matière de constatations, les objets saisis sont mentionnés conformément à l’article 54 C.P.P. ;'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00283", 'En matière de perquisitions, l’inventaire des objets, documents et données informatiques saisis est ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00284", 'réalisé dans les formes prévues aux articles 56 et 57 C.P.P. ;'),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00285", 'Les données informatiques utiles à la manifestation de la vérité peuvent être copiées et placées sous contrôle de la justice. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00286", 'La restitution ou la destruction de ces données s’effectue, le cas échéant, sur instruction du procureur de la République.'),
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00287", 'Information de la personne'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00288", 'Lorsque la saisie concerne un bien susceptible de confiscation ultérieure, la personne concernée doit être ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00289", 'informée, au moment de la perquisition ou lors d’une audition ultérieure, des motifs de la saisie et de la ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00290", 'possibilité d’en demander la restitution.'),
                  ),
                ],
              ),
              SizedBox(height: 18),

              // ===================================================
              // 3.3.8 — L’INTERPELLATION DE L’AUTEUR PRÉSUMÉ
              // ===================================================
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00291", '3.3.8 — L’interpellation de l’auteur présumé')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00292", 'En matière de crime ou de délit flagrant puni d’une peine d’emprisonnement, l’article 73 C.P.P. autorise toute personne ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00293", 'à appréhender l’auteur présumé et à le conduire immédiatement devant l’O.P.J. le plus proche. L’O.P.J. reste toutefois ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00294", 'responsable de la régularité de l’interpellation et des suites procédurales.'),
              ),
              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00295", '3.3.8.1 — L’appréhension de l’auteur présumé')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00296", 'L’appréhension doit intervenir dans un temps très voisin de l’infraction et se faire, autant que possible, dans un lieu public ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00297", 'et durant les heures légales. L’usage de la contrainte et, le cas échéant, de la force publique doit rester nécessaire, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00298", 'proportionné et faire l’objet d’une traçabilité dans la procédure.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00299", 'Usage des menottes'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00300", 'L’utilisation des menottes relève de l’appréciation de l’agent, au regard notamment des conditions de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00301", 'l’interpellation, de la nature des faits reprochés, des antécédents judiciaires, de l’âge, de l’état de santé, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00302", 'de l’agressivité de la personne ou de la découverte d’objets dangereux. Cet usage doit toujours rester proportionné ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00303", 'et compatible avec la présomption d’innocence.'),
                  ),
                ],
              ),
              SizedBox(height: 14),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00304", '3.3.8.2 — Le mandat de recherche')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00305", 'En flagrant délit, le procureur de la République peut décerner un mandat de recherche à l’encontre d’une personne ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00306", 'contre laquelle il existe une ou plusieurs raisons plausibles de soupçonner la commission d’un crime ou d’un délit ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00307", 'puni d’au moins trois ans d’emprisonnement (art. 70 C.P.P.).'),
              ),
              SizedBox(height: 6),
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00308", '3.3.8.2.1 — La délivrance du mandat de recherche')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00309", 'Le mandat de recherche permet l’interpellation et la conduite de la personne devant l’O.P.J. ou le magistrat indiqué. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00310", 'Il est délivré par écrit, motivé en fait et en droit et notifié à la personne lors de son arrestation.'),
              ),
              SizedBox(height: 6),
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00311", '3.3.8.2.2 — Les actes d’investigations')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00312", 'Les opérations réalisées en exécution d’un mandat de recherche obéissent au régime de l’enquête de flagrance ou de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00313", 'l’enquête préliminaire, selon le cadre juridique appliqué. Les actes doivent être consignés dans des procès-verbaux détaillés ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00314", 'et portés à la connaissance du procureur de la République.'),
              ),
              SizedBox(height: 6),
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00315", '3.3.8.2.3 — La découverte de la personne recherchée')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00316", 'Lorsque la personne recherchée est découverte, elle peut être placée en garde à vue dans les conditions habituelles. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00317", 'L’avis au procureur de la République mentionne le mandat de recherche exécuté et les circonstances de l’interpellation.'),
              ),
              SizedBox(height: 8),

              // ===================================================
              // 3.3.9 — LA GARDE À VUE (DROIT COMMUN)
              // ===================================================
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00318", '3.3.9 — La garde à vue (droit commun)')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00319", 'La garde à vue est une mesure de contrainte décidée par l’O.P.J., sous le contrôle permanent ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00320", 'de l’autorité judiciaire, à l’encontre d’une personne soupçonnée d’avoir commis ou tenté de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00321", 'commettre une infraction punie d’emprisonnement. Elle est strictement encadrée par le code de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00322", 'procédure pénale et entourée de garanties particulières.'),
              ),
              SizedBox(height: 10),

              // 3.3.9.1 DOMAINE D’APPLICATION QUANT AUX PERSONNES
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00323", '3.3.9.1 — Domaine d’application de la garde à vue quant aux personnes'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00324", 'En principe, toute personne contre laquelle il existe une ou plusieurs raisons plausibles de soupçonner ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00325", 'qu’elle a commis ou tenté de commettre un crime ou un délit puni d’emprisonnement peut être placée ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00326", 'en garde à vue. Certaines catégories bénéficient cependant d’un statut particulier.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00327", 'Les agents diplomatiques et certaines personnes bénéficiant d’immunités internationales ne peuvent être soumis à la garde à vue.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00328", 'Le président de la République bénéficie d’une inviolabilité pendant la durée de son mandat, hors hypothèses spéciales prévues par la Constitution.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00329", 'Les parlementaires peuvent, en cas de crime ou délit flagrant, être placés en garde à vue sous réserve de conditions renforcées et d’une information immédiate de l’autorité compétente.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00330", 'Les mineurs peuvent être placés en garde à vue sous des règles spécifiques, adaptées à leur âge et à leur vulnérabilité.'),
              ),
              SizedBox(height: 8),
              _NotaBox(
                title: 'Principe',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00331", 'La garde à vue constitue une atteinte grave à la liberté individuelle. Elle ne peut être décidée que lorsque les nécessités de l’enquête le justifient et dans le strict respect du principe de proportionnalité.'),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 3.3.9.2 DOMAINE D’APPLICATION QUANT AUX INFRACTIONS
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00332", '3.3.9.2 — Domaine d’application de la garde à vue quant aux infractions'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00333", 'La garde à vue n’est possible que s’il s’agit d’un crime ou d’un délit puni d’une peine ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00334", 'd’emprisonnement. Elle n’est pas applicable pour les simples contraventions.'),
              ),

              SizedBox(height: 12),

              // 3.3.9.3 CONDITIONS DE PLACEMENT EN GARDE À VUE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00335", '3.3.9.3 — Les conditions de placement en garde à vue')),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00336", 'La décision de placer une personne en garde à vue relève de l’O.P.J., qui exerce cette prérogative sous le contrôle de l’autorité judiciaire. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00337", 'Elle doit répondre à un double test : nécessité pour l’enquête et proportionnalité de l’atteinte à la liberté individuelle.'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00338", 'Il doit exister une ou plusieurs raisons plausibles de soupçonner que la personne a commis ou tenté de commettre un crime ou un délit puni d’emprisonnement.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00339", 'La garde à vue doit constituer l’unique moyen de parvenir à au moins un des objectifs prévus par la loi (exécution des investigations, présentation au magistrat, prévention des pressions sur les témoins ou des concertations avec les complices, etc.).'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00340", 'Rappel jurisprudentiel'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00341", 'Toute mesure privative de liberté doit être justifiée par les nécessités de la procédure, adaptée à la gravité des faits et ne pas porter atteinte à la dignité de la personne. L’O.P.J. doit motiver la mesure dans le procès-verbal de placement en garde à vue.'),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 3.3.9.4 DURÉE DE LA GARDE À VUE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00342", '3.3.9.4 — La durée de la garde à vue')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00343", 'La durée initiale de la garde à vue est de vingt-quatre heures. Elle peut être prolongée une fois pour une nouvelle période de vingt-quatre heures, lorsque la personne est soupçonnée d’un crime ou d’un délit dont la peine d’emprisonnement encourue est supérieure ou égale à un an et que cette prolongation constitue toujours le seul moyen d’atteindre les objectifs légaux.'),
              ),
              SizedBox(height: 6),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00344", 'La prolongation est autorisée par le procureur de la République, après présentation de la personne ou, le cas échéant, par un moyen de télécommunication audiovisuelle. Elle doit être spécialement motivée au regard des éléments propres au dossier.'),
              ),

              SizedBox(height: 14),

              // 3.3.9.5 CARACTÈRE FACULTATIF DE LA GARDE À VUE
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00345", '3.3.9.5 — Le placement en garde à vue a un caractère facultatif'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00346", 'Même si les conditions légales sont réunies, le placement en garde à vue n’est jamais automatique. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00347", 'L’article 73 alinéa 2 C.P.P. permet, dans certains cas, de laisser la personne libre après interpellation, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00348", 'lorsqu’elle présente des garanties suffisantes de représentation et que les nécessités de l’enquête peuvent être satisfaites autrement.'),
              ),
              SizedBox(height: 6),
              _ExempleBox(
                title: 'Illustration',
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00349", 'Une personne interpellée pour un délit flagrant, identifiée, domiciliée et sans antécédent peut, si le risque de fuite apparaît faible, être laissée libre avec convocation ultérieure plutôt que placée en garde à vue.'),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 3.3.9.6 DÉBUT DE LA GARDE À VUE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00350", '3.3.9.6 — Le début de la garde à vue')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00351", 'Pour le calcul des délais, le point de départ de la garde à vue est fixé, selon les cas, au moment ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00352", 'de l’appréhension (interpellation en application de l’article 73), de la contrainte pour se présenter devant ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00353", 'les services d’enquête ou de la notification formelle de la mesure à la personne. Toute rétention antérieure ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00354", 'devant être prise en compte pour respecter la durée maximale autorisée, elle doit être précisément mentionnée en procédure.'),
              ),

              SizedBox(height: 14),

              // 3.3.9.7 ISSUE DE LA GARDE À VUE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00355", '3.3.9.7 — L’issue de la garde à vue')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00356", 'À l’issue de la garde à vue, le procureur de la République décide, au vu des éléments recueillis, de la suite à ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00357", 'donner : remise en liberté, éventuellement accompagnée de convocations ultérieures, ou déferrement devant la juridiction compétente.'),
              ),

              SizedBox(height: 18),

              // 3.3.9.8 GARANTIES ENTOURANT LA GARDE À VUE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00358", '3.3.9.8 — Les garanties entourant la garde à vue')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00359", 'La garde à vue est encadrée par un ensemble de garanties visant à assurer le respect des droits fondamentaux ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00360", 'de la personne retenue et le contrôle de la mesure par l’autorité judiciaire.'),
              ),
              SizedBox(height: 10),

              // 3.3.9.8.1 Garanties concernant la mise en œuvre
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00361", '3.3.9.8.1 — Garanties concernant la mise en œuvre de la garde à vue'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00362", 'La mise en œuvre matérielle de la garde à vue relève de l’O.P.J., qui ne peut déléguer que certaines tâches pratiques ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00363", 'à des A.P.J. ou assistants d’enquête. Les conditions de déroulement (hébergement, alimentation, hygiène, accès aux soins, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00364", 'temps de repos, déplacements) doivent respecter la dignité de la personne gardée à vue.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00365", 'Traçabilité'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00366", 'Un procès-verbal de fin de garde à vue récapitule l’ensemble de la mesure : horaires de début et de fin, auditions, temps de repos, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00367", 'recours à des fouilles intégrales ou investigations corporelles, ainsi que les motifs justifiant le placement et, le cas échéant, la prolongation.'),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // 3.3.9.8.2 Garanties touchant au contrôle
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00368", '3.3.9.8.2 — Garanties touchant au contrôle de la garde à vue'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00369", 'La garde à vue est placée sous le contrôle des autorités hiérarchiques et judiciaires : visites périodiques des locaux, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00370", 'vérification des registres, contrôle du procureur de la République et, le cas échéant, du juge des libertés et de la détention. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00371", 'Des autorités indépendantes (Contrôleur général des lieux de privation de liberté, Défenseur des droits, C.P.T., etc.) peuvent également visiter les locaux de garde à vue.'),
              ),

              SizedBox(height: 16),

              // 3.3.9.8.3 DROITS DE LA PERSONNE GARDEE À VUE
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00372", '3.3.9.8.3 — Droits de la personne gardée à vue')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00373", 'Dès le début de la mesure, puis tout au long de la garde à vue, la personne bénéficie de droits fondamentaux dont ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00374", 'l’O.P.J. doit assurer l’effectivité : être informée de ses droits, faire prévenir un tiers, communiquer, être examinée par un médecin, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00375", 'bénéficier de l’assistance d’un avocat, être assistée d’un interprète si nécessaire, et exercer son droit de se taire.'),
              ),
              SizedBox(height: 10),

              // 3.3.9.8.3.1 Droit d’être informée
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00376", '3.3.9.8.3.1 — Le droit d’être informée')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00377", 'Toute personne placée en garde à vue doit être immédiatement informée, dans une langue qu’elle comprend, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00378", 'de la nature de l’infraction, de la durée possible de la mesure, de la possibilité de la prolonger, ainsi que ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00379", 'de l’ensemble de ses droits (prévenir un proche, consulter un médecin, être assistée par un avocat, garder le silence, etc.).'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00380", 'Les droits sont notifiés verbalement et, en principe, par la remise d’un formulaire écrit récapitulant ces informations.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00381", 'Si la personne ne comprend pas le français, les droits lui sont communiqués avec l’aide d’un interprète ou au moyen de formulaires adaptés.'),
              ),

              SizedBox(height: 12),

              // 3.3.9.8.3.2 Droit de faire prévenir un tiers
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00382", '3.3.9.8.3.2 — Le droit de faire prévenir un tiers de la mesure'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00383", 'La personne gardée à vue peut désigner une ou plusieurs personnes à prévenir (proche, membre de la famille, employeur, autorités consulaires). ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00384", 'Sauf circonstances insurmontables ou décision motivée du procureur de la République, cette information doit intervenir dans un délai maximal de trois heures ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00385", 'à compter de la demande.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00386", 'Refus exceptionnel'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00387", 'L’O.P.J. peut, à titre exceptionnel et sur instruction ou accord du procureur de la République, différer l’avis à un tiers lorsque cette information ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00388", 'risquerait de compromettre la conservation des preuves ou de créer un danger grave pour une personne.'),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // 3.3.9.8.3.3 Droit de communiquer
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00389", '3.3.9.8.3.3 — Le droit de communiquer')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00390", 'Sous le contrôle de l’O.P.J., la personne gardée à vue peut communiquer, par écrit, par téléphone ou lors d’un entretien, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00391", 'avec la personne prévenue de la mesure (proche, tiers, employeur, autorités consulaires). Ce droit ne concerne qu’une seule personne, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00392", 'et la communication peut être refusée ou limitée si elle risque de favoriser la commission d’une infraction ou de nuire gravement à l’enquête.'),
              ),

              SizedBox(height: 12),

              // 3.3.9.8.3.4 Droit à un examen médical
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00393", '3.3.9.8.3.4 — Le droit à un examen médical')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00394", 'Toute personne gardée à vue peut demander à être examinée par un médecin. Ce droit peut être exercé dès le début de la garde à vue, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00395", 'puis renouvelé en cas de prolongation. Le médecin est désigné par le procureur de la République ou par l’O.P.J. sur instruction de celui-ci.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00396", 'L’examen a lieu à l’abri des regards, dans le respect du secret médical et de la dignité de la personne.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00397", 'Le médecin apprécie l’aptitude de la personne à rester en garde à vue et peut formuler des prescriptions ou recommandations relatives à son état de santé.'),
              ),

              SizedBox(height: 12),

              // 3.3.9.8.3.5 Droit de garder le silence
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00398", '3.3.9.8.3.5 — Le droit de garder le silence')),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00399", 'En matière pénale, toute personne soupçonnée dispose du droit de se taire sur les faits qui lui sont reprochés. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00400", 'Ce droit, rappelé par le code de procédure pénale, s’applique dès la première audition en garde à vue et tout au long de la procédure.'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00401", 'La notification du droit au silence doit être faite dès le placement en garde à vue et rappelée en cas de besoin.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00402", 'La personne peut choisir de répondre à certaines questions seulement, ou de ne faire aucune déclaration sans que cela puisse être interprété comme un aveu.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00403", 'Conséquence procédurale'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00404", 'Aucune condamnation ne peut être prononcée sur le seul fondement de déclarations obtenues en méconnaissance du droit au silence. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00405", 'L’absence de notification régulière de ce droit est susceptible d’entraîner la nullité des actes subséquents.'),
                  ),
                ],
              ),
              SizedBox(height: 18),

              // 3.3.9.8.3.6 — Le droit à l’assistance d’un avocat
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00406", '3.3.9.8.3.6 — Le droit à l’assistance d’un avocat')),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00407", 'Dès le début de la garde à vue et à tout moment de la mesure, la personne peut demander à être assistée par un avocat ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00408", '(art. 63-3-1 et 63-4 C.P.P.). '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00409", 'Ce droit constitue une garantie essentielle de la défense et de l’équilibre de la procédure pénale.'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00410", 'Principe et contenu du droit')),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00411", 'Entretien confidentiel avec l’avocat, dans la limite de trente minutes par tranche de vingt-quatre heures.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00412", 'Possibilité pour l’avocat de consulter certaines pièces de la procédure limitativement énumérées (procès-verbal de notification, certificat médical, procès-verbaux d’audition et de confrontation, etc.).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00413", 'Possibilité pour l’avocat d’assister aux auditions, confrontations, reconstitutions d’infraction et présentations pour identification de la victime ou du témoin.'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00414", 'Notification et renonciation')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00415", 'Le droit à l’assistance d’un avocat doit être notifié à la personne dès le début de la garde à vue, puis à chaque éventuelle prolongation. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00416", 'Si la personne renonce à l’assistance d’un avocat, cette renonciation doit être exprimée de manière claire et non équivoque et actée dans la procédure. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00417", 'La personne peut revenir sur sa décision à tout moment et demander finalement l’assistance d’un avocat.'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00418", 'Personne ne parlant pas français')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00419", 'Lorsque la personne gardée à vue ne comprend pas la langue française, elle a droit à l’assistance d’un interprète pour l’informer de son droit à un avocat ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00420", 'et pour permettre les échanges avec celui-ci, y compris au moyen d’outils de télécommunication lorsque cela est nécessaire.'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00421", 'Désignation et contact de l’avocat')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00422", 'La personne gardée à vue peut demander à être assistée par un avocat choisi ou par un avocat commis d’office. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00423", 'L’assistance peut également être sollicitée par un tiers (membre de la famille, employeur, autorités consulaires) qui informe l’O.P.J. de cette demande. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00424", 'L’avocat doit être avisé sans délai de la demande d’assistance, par tout moyen (appel, message, fax, courriel…).'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00425", 'En cas de choix d’un avocat déterminé, l’O.P.J. ou l’assistant d’enquête tente de le joindre par tous moyens et consigne les diligences accomplies (nombre d’appels, horaires, etc.).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00426", 'En cas de difficulté ou d’impossibilité de joindre l’avocat choisi, le bâtonnier est saisi pour désigner un avocat de permanence (art. 21-3 C.P.P.).'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00427", 'Information donnée à l’avocat')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00428", 'L’avocat doit être informé de la nature et de la date présumée de l’infraction reprochée, afin de pouvoir exercer utilement son rôle. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00429", 'Cette information peut être délivrée lors de son arrivée dans les locaux de police ou par échange téléphonique préalable.'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00430", 'Consultation de certaines pièces')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00431", 'L’avocat peut consulter, sans en prendre copie, certaines pièces limitativement prévues à l’article 63-4-1 C.P.P. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00432", '(procès-verbal de notification, certificat médical, procès-verbaux d’audition et de confrontation, etc.). ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00433", 'Il peut choisir de les lire avant ou après l’entretien avec la personne gardée à vue.'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00434", 'Entretien et présence aux actes')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00435", 'L’avocat peut s’entretenir avec la personne gardée à vue pendant trente minutes, au début de la mesure puis à chaque tranche de vingt-quatre heures. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00436", 'Il peut, sous réserve des dispositions spécifiques, assister aux auditions et confrontations de la personne, aux opérations de reconstitution, ainsi qu’aux séances d’identification auxquelles elle participe.'),
              ),
              SizedBox(height: 6),

              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00437", 'Limites à la présence de l’avocat'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00438", 'En cas de nécessité impérieuse liée au bon déroulement de l’enquête (risque de compromission grave de la procédure, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00439", 'menace grave et imminente pour la vie ou l’intégrité d’une personne), le procureur de la République peut différer la présence de l’avocat ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00440", 'ou l’accès aux procès-verbaux pendant une durée limitée, par décision écrite et motivée.'),
                  ),
                ],
              ),
              SizedBox(height: 18),

              // 3.3.10 — LES AUDITIONS
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00441", '3.3.10 — Les auditions')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00442", 'Les auditions sont les actes par lesquels l’O.P.J., ou l’A.P.J. agissant sous son contrôle, recueille les déclarations des témoins, des personnes mises en cause ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00443", 'ou des personnes suspectes. Elles peuvent être réalisées en enquête de flagrance ou dans tout autre cadre procédural.'),
              ),
              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00444", '3.3.10.1 — Les parties à l’acte')),
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00445", '3.3.10.1.1 — Les agents habilités')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00446", 'Il s’agit de l’O.P.J. ou, sous son contrôle, de l’A.P.J. Les procès-verbaux d’audition dressés par les A.P.J. sont transmis à l’O.P.J., qui vérifie leur régularité ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00447", 'et leur conformité aux règles de procédure (circ. 1er mars 1993).'),
              ),
              SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00448", '3.3.10.1.2 — Les personnes susceptibles d’être entendues'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00449", 'Peuvent être entendues toutes personnes susceptibles de fournir des renseignements utiles sur les faits : victimes, témoins, personnes mises en cause, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00450", 'ou toute personne en possession d’éléments relatifs à l’infraction. Certaines catégories (agents diplomatiques, représentants d’États étrangers, etc.) ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00451", 'bénéficient toutefois de règles particulières ou d’immunités.'),
              ),
              SizedBox(height: 10),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00452", '3.3.10.2 — L’audition de témoin')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00453", 'Le témoin est une personne à l’encontre de laquelle il n’existe aucune raison plausible de soupçonner qu’elle a commis ou tenté de commettre une infraction ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00454", '(art. 62 al. 1 C.P.P.). Il est entendu sans mesure de garde à vue. L’audition peut, si les nécessités de l’enquête le justifient, se dérouler sous contrainte ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00455", 'pendant une durée maximale de quatre heures (art. 62 al. 2 C.P.P.).'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00456", 'Le témoin convoqué doit comparaître. Il peut, dans certains cas, être contraint à comparaître par la force publique sur autorisation du magistrat.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00457", 'Dans le cadre d’infractions graves, la loi permet de protéger l’adresse réelle de certains témoins en ne mentionnant qu’une adresse administrative (art. 706-58 C.P.P.).'),
              ),
              SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00458", '3.3.10.3 — Audition du témoin qui devient auteur présumé'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00459", 'Si, au cours de l’audition, apparaissent des raisons plausibles de soupçonner que le témoin a commis ou tenté de commettre une infraction, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00460", 'il ne peut plus être entendu comme simple témoin. L’enquêteur doit soit lui faire immédiatement bénéficier des droits du mis en cause entendu librement ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00461", 'ou placé en garde à vue, soit mettre fin à l’audition et lui notifier ses droits avant toute nouvelle audition.'),
              ),
              SizedBox(height: 8),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00462", '3.3.10.4 — Audition du mis en cause')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00463", 'Le mis en cause peut être entendu sous différents statuts : personne gardée à vue, suspect libre ou personne entendue dans un autre cadre procédural. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00464", 'Dans tous les cas, il doit être informé de ses droits fondamentaux (droit à un interprète, à un avocat, au silence, etc.).'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00465", '3.3.10.4.1 — La personne placée en garde à vue')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00466", 'La personne gardée à vue est informée de la possibilité d’être assistée par un avocat aux auditions et confrontations. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00467", 'L’avocat peut poser des questions à la fin de l’audition, qui sont consignées au procès-verbal si elles sont pertinentes pour la manifestation de la vérité.'),
              ),
              SizedBox(height: 6),

              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00468", '3.3.10.4.2 — Le suspect libre')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00469", 'Le suspect libre bénéficie d’un véritable statut depuis la loi du 27 mai 2014. Avant toute audition, il doit être informé de la nature, de la date et du lieu ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00470", 'des faits supposés, de son droit de quitter les locaux à tout moment, d’être assisté par un avocat, de se taire ou de répondre aux questions, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00471", 'et d’être assisté par un interprète si nécessaire.'),
              ),
              SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00472", '3.3.10.5 — Enregistrement audiovisuel des auditions en matière criminelle'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00473", 'En matière criminelle, lorsque la personne est placée en garde à vue pour un crime mentionné à l’article 706-73 C.P.P. ou pour atteinte grave aux intérêts fondamentaux de la nation, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00474", 'les auditions doivent faire l’objet d’un enregistrement audiovisuel (art. 64-1 et D. 15-6 C.P.P.), sauf impossibilité technique dûment constatée.'),
              ),
              SizedBox(height: 6),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00475", '3.3.10.6 — Auditions sur le territoire d’un État étranger'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00476", 'L’article 18 al. 4 C.P.P. permet à l’O.P.J. de procéder à des auditions sur le territoire d’un État étranger, avec l’accord des autorités compétentes de cet État ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00477", 'et sur réquisitions du procureur de la République. Ces opérations sont strictement encadrées par le droit international et la coopération judiciaire.'),
              ),
              SizedBox(height: 18),

              // 3.3.11 — LES RÉQUISITIONS
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00478", '3.3.11 — Les réquisitions')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00479", 'La réquisition est l’acte par lequel une autorité judiciaire ou un O.P.J., agissant dans les conditions prévues par la loi, demande à une personne, un service ou une ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00480", 'organisation de lui communiquer des informations, de réaliser un examen technique ou scientifique ou de fournir une prestation utile à l’enquête.'),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00481", '3.3.11.1 — Les réquisitions à personnes qualifiées (art. 60 C.P.P.)'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00482", 'Les personnes qualifiées (médecins, experts, services de police technique et scientifique, etc.) peuvent être requises pour procéder à des examens, constatations ou analyses. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00483", 'Elles interviennent en raison de leurs compétences dans une discipline donnée et peuvent placer sous scellés les objets examinés ou les prélèvements effectués.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00484", 'Les examens techniques ou scientifiques peuvent être réalisés en urgence, sans réquisition formalisée immédiatement, lorsque les nécessités de l’enquête l’imposent, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00485", 'la régularisation intervenant ensuite en procédure.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00486", 'La différence entre examen technique et expertise résulte de la jurisprudence : l’expertise implique une analyse et des conclusions pouvant être débattues contradictoirement.'),
              ),
              SizedBox(height: 8),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00487", '3.3.11.2 — Les réquisitions d’ordre général (art. 60-1 C.P.P.)'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00488", 'Le procureur de la République, l’O.P.J. ou, sous son contrôle, l’A.P.J. peuvent, par réquisition écrite ou électronique, demander à toute personne, organisme ou service ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00489", 'de communiquer des documents, informations ou enregistrements utiles à l’enquête (données administratives, images de vidéosurveillance, données de transport, etc.).'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00490", 'Secret professionnel et limites'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00491", 'Les personnes astreintes au secret professionnel peuvent refuser de répondre si la réquisition porterait atteinte au secret protégé par la loi ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00492", '(avocats, médecins, journalistes pour la protection des sources, etc.). Dans ce cas, il appartient à l’autorité judiciaire d’apprécier ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00493", 'l’opportunité d’une perquisition dans les formes prévues par le code de procédure pénale.'),
                  ),
                ],
              ),
              SizedBox(height: 10),

              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00494", '3.3.11.3 — Réquisitions portant sur les données de connexion (art. 60-1-2 C.P.P.)'),
              ),
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00495", 'Les réquisitions visant les données de connexion (données techniques permettant d’identifier la source d’une communication, données de trafic et de localisation) ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00496", 'sont strictement encadrées. Elles ne sont possibles que si : '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00497", 'les nécessités de la procédure l’exigent et que l’enquête porte sur un crime ou un délit puni d’au moins trois ans d’emprisonnement, ou dans certains cas précis (personne disparue, criminalité grave, etc.).'),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ]),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00498", 'Les données peuvent être demandées aux opérateurs de communications électroniques, aux fournisseurs d’accès à Internet ou aux hébergeurs de contenus en ligne.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00499", 'Les informations sollicitées concernent uniquement ce qui est nécessaire à l’identification de la source ou au reconstitution du parcours de communication, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00500", 'dans le respect du droit au respect de la vie privée et des décisions des juridictions nationales et européennes.'),
              ),
              SizedBox(height: 8),

              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00501", 'Protection des droits fondamentaux'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00502", 'La délivrance de réquisitions portant sur des données de connexion doit toujours être justifiée par la gravité des faits et les nécessités de l’enquête. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00503", 'Les juridictions rappellent régulièrement que ces mesures doivent être proportionnées et motivées, en tenant compte de l’atteinte potentielle à la vie privée.'),
                  ),
                ],
              ),
              SizedBox(height: 26),
              // 3.3.11.4 — Les réquisitions informatiques et téléphoniques
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00504", '3.3.11.4 — Les réquisitions informatiques et téléphoniques (art. 60-2 et 60-3 C.P.P.)'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00505", 'L’O.P.J., ou l’A.P.J. agissant sous son contrôle, peut requérir des organismes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00506", 'publics ou privés afin d’obtenir la mise à disposition de données conservées ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00507", 'dans des systèmes informatiques ou de télécommunication. Ces réquisitions ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00508", 'sont strictement encadrées par les articles 60-2 et 60-3 du code de procédure ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00509", 'pénale ainsi que par les textes relatifs à la protection des données et aux ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00510", 'secrets protégés (secret professionnel, secret des affaires, secret religieux, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00511", 'philosophique, politique ou syndical…).'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00512", 'Les organismes techniques de police ou de gendarmerie peuvent être saisis directement pour procéder à des examens techniques ou scientifiques, sans qu’il soit nécessaire d’établir une réquisition formelle.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00513", 'Les réquisitions adressées à des opérateurs de télécommunications visent à préserver, pour les besoins de l’enquête, le contenu des informations consultées ou échangées par les utilisateurs.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00514", 'Refus de déférer'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00515", 'Le refus de répondre à une réquisition régulièrement formulée, sans motif légitime, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00516", 'peut constituer une infraction passible d’amende. À l’inverse, les personnes ou ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00517", 'organismes légalement protégés (cultes, syndicats, partis politiques…) ne peuvent être ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00518", 'contraints de livrer certaines informations couvertes par un secret spécialement protégé par la loi.'),
                  ),
                ],
              ),
              SizedBox(height: 14),

              // 3.3.11.5 — Les réquisitions à interprète
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00519", '3.3.11.5 — Les réquisitions à interprète')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00520", 'L’O.P.J. peut requérir un interprète lorsqu’une personne placée en garde à vue, en retenue ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00521", 'ou entendue dans le cadre de l’enquête ne comprend pas suffisamment le français, ou lorsqu’elle ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00522", 'est atteinte d’un handicap de communication (surdité, mutisme, etc.). L’interprète garantit la ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00523", 'compréhension des droits notifiés et des questions posées, ainsi que la fidélité des réponses ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00524", 'rapportées en procédure.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00525", 'L’interprète peut intervenir physiquement ou, sous conditions de sécurité et de confidentialité, par un moyen de télécommunication audiovisuelle.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00526", 'Il prête serment de traduire fidèlement les déclarations et peut être choisi sur une liste spécialisée ou désigné à titre occasionnel.'),
              ),
              SizedBox(height: 10),

              // 3.3.11.6 — Réquisitions aux fins d’examen médical
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00527", '3.3.11.6 — Les réquisitions aux fins d’examen médical des personnes retenues'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00528", 'Toute personne placée en garde à vue, en retenue douanière ou dans un cadre assimilé peut, à sa demande ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00529", 'ou à celle d’un tiers (proche, avocat…), faire l’objet d’un examen médical. L’O.P.J. ou le procureur de la ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00530", 'République réquisitionne alors un médecin, conformément aux dispositions de l’article 63-3 C.P.P. et des textes ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00531", 'spéciaux applicables aux mineurs ou majeurs protégés.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00532", 'L’examen médical a pour objet d’apprécier l’aptitude de la personne à demeurer en garde à vue ou en retenue, et de constater les éventuelles lésions ou blessures.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00533", 'Le certificat médical doit décrire l’état clinique et les blessures éventuelles, sans préjuger de la responsabilité pénale ni des incapacités civiles ou professionnelles.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00534", 'Mineurs et personnes vulnérables'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00535", 'Des réquisitions d’examen médical renforcées sont prévues pour les mineurs, les majeurs protégés et certaines personnes retenues en application de textes particuliers (C.J.P.M., C.S.E.D.A., etc.), ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00536", 'afin de vérifier la compatibilité de la mesure avec leur état de santé.'),
                  ),
                ],
              ),
              SizedBox(height: 14),

              // 3.3.11.7 — Réquisitions aux fins d’autopsie
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00537", '3.3.11.7 — Les réquisitions aux fins d’autopsie')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00538", 'Dans le cadre d’une enquête de flagrant délit, une autopsie peut être ordonnée lorsqu’il existe un doute sur la cause ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00539", 'du décès ou lorsqu’il est nécessaire de préciser les circonstances de commission d’une infraction. L’O.P.J., sur ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00540", 'instructions du procureur de la République, réquisitionne un praticien qualifié en médecine légale au sens des articles ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00541", '230-28 et suivants du C.P.P.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00542", 'Seul un médecin spécialisé, titulaire des qualifications requises, peut être requis pour pratiquer une autopsie judiciaire.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00543", 'Les prélèvements effectués lors de l’autopsie sont placés sous scellés et destinés à une éventuelle exploitation ultérieure (analyses, contre-expertise…).'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00544", 'Information des proches'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00545", 'Sous réserve des nécessités de l’enquête, la famille ou les proches du défunt sont informés de la réalisation de l’autopsie et de la restitution ultérieure du corps.'),
                  ),
                ],
              ),
              SizedBox(height: 14),

              // 3.3.11.8 — Géolocalisation en temps réel
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00546", '3.3.11.8 — La géolocalisation en temps réel (art. 230-32 à 230-44 C.P.P.)'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00547", 'La géolocalisation en temps réel permet de suivre les déplacements d’une personne, d’un véhicule ou de tout autre ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00548", 'objet, au moyen d’un dispositif dédié (balise) ou de l’activation à distance d’un équipement électronique ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00549", '(téléphone, tablette, ordinateur, système GPS embarqué…). Elle constitue une atteinte importante à la vie privée ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00550", 'et ne peut être mise en œuvre que pour les crimes et les délits punis d’au moins trois ans d’emprisonnement, ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00551", 'lorsque les nécessités de l’enquête l’exigent.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00552", 'En enquête de flagrance, la géolocalisation est autorisée par le procureur de la République pour une durée limitée (8 ou 15 jours selon la nature de l’infraction, renouvelable sous contrôle du juge des libertés et de la détention).'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00553", 'L’introduction dans un lieu d’habitation pour installer ou retirer un dispositif de géolocalisation nécessite l’autorisation écrite et motivée du juge des libertés et de la détention.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00554", 'L’activation à distance d’un appareil électronique appartenant à certaines catégories protégées (médecin, avocat, parlementaire, journaliste…) est exclue ou soumise à un régime renforcé.'),
              ),
              SizedBox(height: 6),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00555", 'Jurisprudence'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00556", 'La géolocalisation est regardée comme une ingérence grave dans la vie privée : elle doit être exécutée sous le contrôle effectif d’un magistrat et justifiée par la gravité des faits et les besoins de l’enquête.'),
                  ),
                ],
              ),
              SizedBox(height: 12),

              _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00557", 'Tableau de synthèse — Géolocalisation'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00558", 'Champ d’application : crimes et délits punis d’au moins 3 ans ; toute personne ou tout objet, même à son insu. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00559", 'Autorisation initiale : procureur de la République (décision écrite et motivée). Renouvellement : juge des libertés ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00560", 'et de la détention, pour un mois renouvelable, dans la limite d’un an (droit commun) ou de deux ans pour certaines ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00561", 'infractions graves. L’activation à distance d’un appareil nécessite toujours l’autorisation du J.L.D., sauf pour les ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00562", 'catégories légalement exclues.'),
                  ),
                ],
              ),
              SizedBox(height: 18),

              // 3.3.11.9 — La réquisition à manœuvrer
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00563", '3.3.11.9 — La réquisition à manœuvrer')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00564", 'La réquisition à manœuvrer vise une personne dont l’intervention matérielle est nécessaire au déroulement de ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00565", 'l’enquête (par exemple, un serrurier pour ouvrir une porte, un grutier pour déplacer un conteneur…). Elle ne repose ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00566", 'pas sur des compétences d’expertise mais sur une prestation technique déterminée.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00567", 'La réquisition est fondée, en flagrant délit, sur les dispositions générales relatives aux constatations ou perquisitions ainsi que sur l’article R. 642-1 du code pénal sanctionnant le refus de déférer.'),
              ),
              SizedBox(height: 10),

              // 3.3.11.10 — Réquisition de l’art. L. 3354-1 du code de la santé publique
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00568", '3.3.11.10 — La réquisition de l’article L. 3354-1 du code de la santé publique'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00569", 'En cas de crime, de délit ou d’accident de la circulation laissant supposer un état alcoolique, les officiers ou agents ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00570", 'de police judiciaire peuvent être amenés à faire procéder à des vérifications destinées à établir la preuve de la présence ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00571", 'd’alcool (analyses cliniques, examens biologiques). Ces vérifications sont réalisées par un médecin, un interne, un étudiant ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00572", 'en médecine autorisé ou un infirmier habilité.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00573", 'Les vérifications sont obligatoires en cas d’accident mortel ou grave de la circulation et peuvent également concerner la victime.'),
              ),
              SizedBox(height: 10),

              // 3.3.11.11 — Réquisitions des articles L. 234-4 et L. 234-9 du code de la route
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00574", '3.3.11.11 — Les réquisitions des articles L. 234-4 et L. 234-9 du code de la route'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00575", 'Ces réquisitions permettent d’établir la preuve de l’état alcoolique du conducteur ou de l’accompagnateur en cas de refus ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00576", 'ou d’impossibilité de se soumettre aux épreuves de dépistage. Elles autorisent un prélèvement sanguin réalisé par un ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00577", 'professionnel de santé habilité, sur décision de l’O.P.J. ou du parquet.'),
              ),
              SizedBox(height: 6),

              // 3.3.11.12 — Réquisitions de l’art. L. 235-2 du code de la route
              _SubTitle(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00578", '3.3.11.12 — La réquisition de l’article L. 235-2 du code de la route'),
              ),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00579", 'Lorsque des raisons plausibles laissent supposer l’usage de stupéfiants par un conducteur impliqué dans un accident mortel ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00580", 'ou grave, ou en cas de refus de dépistage, l’O.P.J. peut requérir un médecin ou un autre professionnel habilité pour ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00581", 'effectuer des prélèvements destinés à rechercher la présence de substances stupéfiantes.'),
              ),
              SizedBox(height: 10),

              // 3.3.11.13 — Le policier requis
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00582", '3.3.11.13 — Le policier requis')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00583", 'En tant qu’agent de la force publique, le policier peut lui-même être requis par un magistrat pour accomplir certaines ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00584", 'missions dans le cadre de l’enquête : par le procureur général, le procureur de la République ou le juge d’instruction. ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00585", 'Dans ce cadre, il agit comme auxiliaire de justice et doit se conformer strictement aux instructions reçues.'),
              ),
              SizedBox(height: 14),

              // 3.3.12 — La saisie des comptes bancaires
              _SubTitle(ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00586", '3.3.12 — La saisie des comptes bancaires')),
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00587", 'La saisie des comptes bancaires intervient principalement dans le cadre d’une procédure de confiscation de biens ou droits ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00588", 'mobiles incorporels (sommes inscrites sur un compte de dépôt, de paiement, avoirs numériques, etc.), lorsque la loi prévoit ') + ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00589", 'une peine de confiscation ou en cas de crime ou délit puni d’une peine d’emprisonnement supérieure à un an.'),
              ),
              SizedBox(height: 6),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00590", 'L’O.P.J., sur autorisation du procureur de la République, peut saisir les sommes figurant sur les comptes visés, afin d’éviter leur disparition avant jugement.'),
              ),
              _BulletPoint(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/cadres_juridiques_pages/flagrant_delit/flagrant_delit_procedure_page.dart", "f00591", 'Le juge des libertés et de la détention, saisi par le procureur, statue par ordonnance motivée sur le maintien ou la mainlevée de la saisie dans un délai de dix jours, y compris lorsque la juridiction de jugement est déjà saisie.'),
              ),
              SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// CARTE GLOBALE POUR CHAQUE BLOC (3.1 / 3.2 / 3.3)
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
/// TITRE DE SOUS-PARTIE (3.1.1, 3.2.2, 3.3.2.5, etc.)
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
/// PARAGRAPHE SIMPLE / RICH
/// ------------------------------------------------------------------
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
/// BLOC NOTA / INFO
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
