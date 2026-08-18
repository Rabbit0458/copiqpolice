import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaJuridictionsExecutionDecisionsJusticePage extends StatelessWidget {
  const PaJuridictionsExecutionDecisionsJusticePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/juridictions_execution_decisions_justice';

  // Helpers pour articles en rouge
  TextSpan _cpp(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _cp(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _cr(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  TextSpan _autreCode(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title:  Text(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00001", "Exécution des décisions de justice"))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00002", 'Version au 01/07/2025  © COPIQ'),
                  style: GoogleFonts.fustat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white60
                        : const Color(0xFF424242).withValues(alpha: .85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),

              ////////////////////////////////////////////////////////////
              /// INTRO GÉNÉRALE – EXÉCUTION DES DÉCISIONS DE JUSTICE
              ////////////////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00003", "L'exécution des décisions de justice"),
                cardColor: isDark
                    ? const Color(0xFF111820)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                  const _SubTitle('Introduction'),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00004", "La loi n° 2019-222 du 23 mars 2019 de programmation 2018-2022 ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00005", "et de réforme pour la justice a refondé le droit de la peine, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00006", "afin de rendre son application plus lisible et plus efficace, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00007", "en favorisant sa mise à exécution rapide dans le respect du ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00008", "principe d'individualisation des peines."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00009", "La loi n° 2012-409 du 27 mars 2012 relative à l'exécution des ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00010", "peines a apporté plusieurs dispositions de procédure pénale ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00011", "visant à garantir l'effectivité de l'exécution des peines, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00012", "renforcer les dispositifs de prévention de la récidive et ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00013", "améliorer la prise en charge des mineurs délinquants."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00014", "La loi portant adaptation de la justice aux évolutions de la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00015", "criminalité du 9 mars 2004 a apporté de nouvelles modifications ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00016", "substantielles au droit de l'application des peines, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00017", "complétant la réforme entamée en 2000 et poursuivant le ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00018", "mouvement de juridictionnalisation des peines, notamment par ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00019", "l’abandon définitif de la notion de mesures d'administration ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00020", "judiciaire."),
                    ),
                  ]),
                  const SizedBox(height: 10),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00021", "Selon les termes de la loi, le procureur de la République ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00022", "poursuit l'exécution des peines privatives de liberté et de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00023", "certaines peines de substitution ainsi que des peines ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00024", "complémentaires. Mais l’exécution des peines relève de plus en ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00025", "plus du juge de l'application des peines, qui gère notamment ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00026", "les modalités d'application de la peine."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00027", "Le juge intervient de plus en plus dans l'exécution des ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00028", "décisions de justice, par exemple pour le retrait de la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00029", "semi-liberté ou du placement à l'extérieur accordé par jugement ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00030", "Article 723-2 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00031", "Pour les peines privatives de liberté, l'individualisation de la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00032", "peine doit permettre le retour progressif du condamné à la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00033", "liberté, mais également éviter une remise en liberté sans ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00034", "aucune forme de suivi judiciaire."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00035", "Pour les peines pécuniaires, le législateur a prévu le système ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00036", "de la contrainte judiciaire afin de garantir l'exécution des ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00037", "amendes et autres condamnations pécuniaires."),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// CHAPITRE 1 – EXÉCUTION DES PEINES
              ////////////////////////////////////////////////
              _ConditionCard(
                title:
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00038", "Chapitre 1 : L'exécution des peines – principes généraux"),
                cardColor: isDark
                    ? const Color(0xFF101318)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF1A237E),
                titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
                children: [
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00039", '1.1 - Les parties intervenantes')),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00040", "L’Article 707-1 alinéa 1 du Code de procédure pénale dispose : ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00041", "« Le ministère public et les parties poursuivent l'exécution de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00042", "la sentence, chacun en ce qui le concerne »."),
                    ),
                  ]),
                  const SizedBox(height: 8),

                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00043", '1.1.1 - La partie civile')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00044", "La partie civile obtient en principe réparation sous la forme du ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00045", "versement de dommages et intérêts, mais elle peut aussi bénéficier ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00046", "d’autres formes de réparation (publication de la décision, remise en ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00047", "état du bien, etc.)."),
                  ),
                  const SizedBox(height: 6),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00048", "Elle a seule qualité pour faire exécuter les condamnations prononcées ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00049", "à son profit par les voies civiles (saisies, mesures d’exécution sur ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00050", "les biens du débiteur)."),
                  ),
                  const SizedBox(height: 8),

                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00051", '1.1.2 - Les administrations')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00052", "Certaines administrations représentant l’État poursuivent l’exécution ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00053", "de certaines peines ou sanctions."),
                  ),
                  const SizedBox(height: 6),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00054", "Administration des impôts : recouvrement des amendes à caractère ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00055", "fiscal et des confiscations ayant le caractère d’une peine et ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00056", "d’une indemnité au profit du Trésor."),
                  ),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00057", "Administration des douanes : exécution des sanctions d’ordre ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00058", "pécuniaire prononcées suite à des infractions douanières."),
                  ),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00059", "Elles disposent notamment d’un droit de transaction qu’elles ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00060", "peuvent exercer avant ou après jugement."),
                    ),
                  ]),

                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00061", '1.1.3 - Le ministère public')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00062", "C’est au ministère public qu’il appartient essentiellement ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00063", "d’assurer l’exécution des sanctions pénales. L’"),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00064", "Article 707-1 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00065", " précise son rôle dans l’exécution des peines de toutes natures."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00066", "Il : "))]),
                  const SizedBox(height: 4),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00067", "fait exécuter toutes les peines privatives de liberté ;"),
                  ),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00068", "fait exécuter les peines prévues aux articles 131-1 à 131-49 du "),
                    ),
                    _cp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00069", "Code pénal")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00070", " (peines principales, complémentaires et accessoires) ;"),
                    ),
                  ]),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00071", "poursuit l’exécution des sanctions pécuniaires prononcées par ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00072", "les autorités compétentes des États membres de l’Union ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00073", "européenne ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00074", "Article 707-1 alinéa 6 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00075", "Pour les peines pécuniaires, le recouvrement est assuré soit par ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00076", "le comptable public compétent, soit par l’Agence de gestion et ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00077", "de recouvrement des avoirs saisis et confisqués lorsque la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00078", "confiscation porte sur des biens meubles ou immeubles ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00079", "Article 707-1 alinéa 2 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00080", "L’Article 709 du Code de procédure pénale prévoit que le ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00081", "procureur de la République et le procureur général peuvent ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00082", "requérir directement l’assistance de la force publique pour ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00083", "assurer l’exécution des décisions de justice."),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// 1.2 – DÉCISION DÉFINITIVE
              ////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00084", "1.2 - La décision doit être définitive"),
                cardColor: isDark
                    ? const Color(0xFF12151C)
                    : const Color(0xFFE8F5E9),
                accent: const Color(0xFF2E7D32),
                titleColor: isDark ? Colors.white : const Color(0xFF1B5E20),
                children: [
                  _Paragraph.rich([
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00085", "L’")),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00086", "Article 708 alinéa 1 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00087", " dispose que l’exécution a lieu lorsque la décision est ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00088", "devenue définitive."),
                    ),
                  ]),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00089", '1.2.1 - Le délai d’opposition')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00090", "Lorsque la décision est rendue par défaut, elle ne peut être mise à ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00091", "exécution tant que court le délai d’opposition. Ce délai suspend ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00092", "l’exécution de la peine."),
                  ),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00093", "1.2.2 - Le délai d'appel")),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00094", "Le délai d’appel est de 10 jours à compter du prononcé de la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00095", "décision : "),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00096", "Article 380-9 du Code de procédure pénale")),
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00097", " (cour d’assises), ")),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00098", "Article 498 du Code de procédure pénale")),
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00099", " (tribunal correctionnel), ")),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00100", "Article 547 du Code de procédure pénale")),
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00101", " (tribunal de police).")),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00102", "Pendant le délai d’appel et durant l’instance d’appel, il est ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00103", "généralement sursis à l’exécution, sauf exceptions (exécution ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00104", "provisoire de certaines mesures, maintien en détention, etc.)."),
                  ),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00105", '1.2.3 - Le pourvoi en cassation')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00106", "Le pourvoi en cassation n’est en principe pas suspensif, sauf dans ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00107", "certains cas prévus par la loi. Il n’empêche donc pas ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00108", "l’exécution de la décision sauf texte contraire."),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// 1.3 – PEINES PRIVATIVES DE LIBERTÉ
              ////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00109", "1.3 - L'exécution des peines privatives de liberté"),
                cardColor: isDark
                    ? const Color(0xFF15161F)
                    : const Color(0xFFFFF3E0),
                accent: const Color(0xFFEF6C00),
                titleColor: isDark ? Colors.white : const Color(0xFFE65100),
                children: [
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00110", '1.3.1 - Le rôle du ministère public')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00111", "Le ministère public doit faire exécuter les peines privatives de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00112", "liberté, qu’elles soient prononcées par le tribunal correctionnel ou ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00113", "la cour d’assises."),
                  ),
                  const SizedBox(height: 6),
                   _IntroBullet(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00114", "Lorsque la cour d’assises siège au niveau de la cour d’appel, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00115", "l’exécution est assurée par le parquet général."),
                  ),
                   _IntroBullet(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00116", "Lorsque la cour d’assises siège dans les locaux du tribunal ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00117", "judiciaire, c’est le parquet de ce tribunal qui assure ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00118", "l’exécution."),
                  ),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00119", '1.3.2 - Modalités pratiques')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00120", "Le Code de procédure pénale ne fixe pas de délai précis pour ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00121", "l’incarcération des condamnés, mais l’instruction générale pour ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00122", "l’application du C.P.P. ("),
                    ),
                    _autreCode(
                      ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00123", "Article C 816 de l’instruction générale pour l’application du Code de procédure pénale"),
                    ),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00124", ") prescrit que la peine d’emprisonnement doit être mise à ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00125", "exécution dans un délai de 15 jours."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00126", "Un extrait de la décision exécutoire est établi par le greffe puis ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00127", "adressé à l’établissement pénitentiaire à l’appui de l’écrou."),
                  ),
                  const SizedBox(height: 6),
                   _IntroBullet(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00128", "Si le condamné est déjà détenu, l’écrou est régularisé sur place."),
                  ),
                   _IntroBullet(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00129", "S’il est libre, le parquet peut le faire convoquer pour une mise ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00130", "à exécution ou délivrer un réquisitoire d’arrestation aux forces ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00131", "de police ou de gendarmerie."),
                  ),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00132", "Les agents de la force publique peuvent être autorisés à ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00133", "pénétrer au domicile d’une personne condamnée afin d’assurer ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00134", "l’exécution d’une peine d’emprisonnement. Cette intrusion est ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00135", "encadrée par l’"),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00136", "Article 716-5 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00137", " et doit respecter les heures légales et les règles relatives à ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00138", "la protection du domicile."),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// 1.4 – PEINES NON PRIVATIVES
              ////////////////////////////////////////////////
              _ConditionCard(
                title: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00139", "1.4 - L'exécution des peines non privatives de liberté"),
                cardColor: isDark
                    ? const Color(0xFF17171F)
                    : const Color(0xFFE3F2FD),
                accent: const Color(0xFF1565C0),
                titleColor: isDark ? Colors.white : const Color(0xFF0D47A1),
                children: [
                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00140", '1.4.1 - Peines applicables aux personnes physiques'),
                  ),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00141", '1.4.1.1 - Les amendes')),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00142", "Les condamnations pécuniaires (amendes pénales, civiles ou ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00143", "administratives, certaines condamnations fiscales, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00144", "confiscations, réparations, dommages et intérêts…) sont ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00145", "exigibles dès que la décision les prononçant est devenue ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00146", "exécutoire."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00147", "Le recouvrement des amendes est assuré par le comptable public ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00148", "compétent au nom du procureur de la République. Les extraits de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00149", "jugement ou d’arrêt doivent être adressés au Trésorier principal ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00150", "dans un délai de 35 jours (45 jours en cas de pourvoi en ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00151", "cassation)."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00152", "Le paiement de l’amende est toujours privilégié. Le défaut total ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00153", "ou partiel de paiement peut entraîner l’incarcération du ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00154", "condamné dans le cadre de la contrainte judiciaire ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00155", "Article 707-1 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00156", '1.4.1.2 - Les jours-amende')),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00157", "Les jours-amende sont une peine pécuniaire particulière. ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00158", "L’intéressé s’acquitte d’une somme journalière ; à défaut de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00159", "paiement, le juge de l’application des peines peut ordonner un ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00160", "emprisonnement pour une durée égale au nombre de jours-amende ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00161", "impayés."),
                    ),
                  ]),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00162", '1.4.1.3 - Autres sanctions')),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00163", '1.4.1.3.1 - Les peines de substitution')),
                  _Paragraph.rich([
                     TextSpan(
                      text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00164", "Les peines de substitution prévues à l’"),
                    ),
                    _cp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00165", "Article 131-6 du Code pénal")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00166", " comprennent notamment la suspension ou l’annulation du permis ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00167", "de conduire, l’interdiction de conduire certains véhicules, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00168", "l’interdiction de détenir ou porter une arme, la confiscation de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00169", "la chose qui a servi ou était destinée à commettre l’infraction, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00170", "etc."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00171", '1.4.1.3.2 - Peines complémentaires pouvant se substituer'),
                  ),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00172", "Il existe également des peines complémentaires prévues à divers ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00173", "articles du "),
                    ),
                    _cp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00174", "Code pénal")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00175", " : interdiction de droits civiques, civils et de famille, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00176", "interdiction d’exercer certaines fonctions, fermeture ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00177", "d’établissement, affichage ou diffusion de la décision, etc."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00178", '1.4.1.3.3 - La peine de sanction-réparation'),
                  ),
                  _Paragraph.rich([
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00179", "L’")),
                    _cp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00180", "Article 131-8-1 du Code pénal")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00181", " dispose qu’en cas de délit, la juridiction peut prononcer, à la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00182", "place ou en même temps que la peine d’emprisonnement ou ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00183", "d’amende, une peine de sanction-réparation. Elle consiste pour ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00184", "le condamné à indemniser la victime (remise en état d’un bien, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00185", "versements, etc.)."),
                    ),
                  ]),
                  const SizedBox(height: 8),
                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00186", '1.4.2 - Peines applicables aux personnes morales'),
                  ),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00187", "Les personnes morales peuvent être condamnées à des peines ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00188", "d’amende et à diverses peines complémentaires. Le recouvrement ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00189", "des amendes s’effectue comme pour les personnes physiques, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00190", "sauf pour la contrainte judiciaire qui ne leur est pas ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00191", "applicable."),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// CHAPITRE 2 – CONTRAINTE JUDICIAIRE
              ////////////////////////////////////////////////
              _ConditionCard(
                title:
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00192", "Chapitre 2 : Garantie d’exécution – la contrainte judiciaire"),
                cardColor: isDark
                    ? const Color(0xFF15151D)
                    : const Color(0xFFFFF8E1),
                accent: const Color(0xFFF9A825),
                titleColor: isDark ? Colors.white : const Color(0xFF5D4037),
                children: [
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00193", '2.1 - Définition')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00194", "La contrainte judiciaire est une voie d’exécution qui permet, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00195", "en cas d’inexécution volontaire d’une condamnation pécuniaire, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00196", "d’incarcérer le condamné pour une durée déterminée. Elle succède ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00197", "à l’ancienne contrainte par corps. La loi du 9 mars 2004 a ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00198", "consacré le rôle du juge de l’application des peines chargé ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00199", "d’ordonner cette mesure ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00200", "Article 749 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00201", '2.2 - Conditions de mise en œuvre')),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00202", "Inexécution volontaire de la condamnation pécuniaire par le ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00203", "condamné ;"),
                  ),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00204", "Condamnation consistant en une peine d’amende prononcée pour un ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00205", "crime ou un délit puni d’une peine d’emprisonnement ;"),
                  ),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00206", "Ne s’applique pas lorsque seule une peine d’amende contraventionnelle est encourue."),
                  ),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00207", '2.3 - Personnes soumises à la contrainte')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00208", "La contrainte judiciaire ne peut s’exercer que contre le délinquant ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00209", "dont la culpabilité a été judiciairement constatée (auteur, co-auteur ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00210", "ou complice)."),
                  ),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00211", '2.4 - Causes d’exemption')),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00212", "Minorité pénale : la contrainte judiciaire ne peut être ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00213", "prononcée contre les mineurs de moins de 18 ans ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00214", "Article 751 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00215", "Personnes âgées : elle ne peut être exercée contre les débiteurs ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00216", "âgés d’au moins 65 ans à l’époque des faits ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00217", "Article 751 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00218", "Personnes insolvables : pas de contrainte judiciaire contre les ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00219", "condamnés qui justifient par tout moyen de leur insolvabilité ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00220", "Article 752 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  _BulletPoint.rich([
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00221", "Époux : l’")),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00222", "Article 753 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00223", " interdit d’exercer simultanément la contrainte judiciaire ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00224", "contre deux époux, même en cas de condamnations différentes."),
                    ),
                  ]),
                  const SizedBox(height: 8),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00225", '2.5 - Procédure (Article 754 du C.P.P.)')),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00226", '2.5.1 - Commandement')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00227", "Avant toute incarcération, la partie poursuivante doit inviter une ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00228", "dernière fois le débiteur à payer : un commandement de payer lui est ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00229", "signifié sous peine de contrainte judiciaire."),
                  ),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00230", '2.5.2 - Demande d’incarcération')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00231", "Si, dans l’année de la signification du commandement, le ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00232", "condamné n’a pas payé, le procureur de la République peut ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00233", "requérir le juge de l’application des peines pour qu’il ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00234", "prononce la contrainte judiciaire. La procédure se déroule en ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00235", "débat contradictoire ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00236", "Article 712-6 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00237", '2.5.3 - Durée de la contrainte')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00238", "La contrainte judiciaire est exclue lorsque le montant de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00239", "l’amende est inférieur à 2 000 €. Au-delà, la durée maximale ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00240", "varie selon des tranches de montant (20 jours, 1 mois, 2 mois, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00241", "3 mois), avec un plafond fixé notamment par l’"),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00242", "Article 750 du Code de procédure pénale")),
                    const TextSpan(text: "."),
                  ]),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00243", "En matière de trafic de stupéfiants, la durée maximale peut être ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00244", "portée à un an ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00245", "Article 706-31 alinéa 3 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00246", '2.5.4 - Fin de la contrainte')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00247", "La libération peut être anticipée si le débiteur s’acquitte de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00248", "sa dette, verse un acompte jugé suffisant ou fournit une ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00249", "caution reconnue bonne et valable. Néanmoins, la dette ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00250", "subsiste malgré l’exécution de la contrainte ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00251", "Article 761-1 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                ],
              ),
              const SizedBox(height: 18),

              ////////////////////////////////////////////////
              /// CHAPITRE 3 – JURIDICTIONS D’APPLICATION DES PEINES
              ////////////////////////////////////////////////
              _ConditionCard(
                title:
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00252", "Chapitre 3 : Les juridictions de l'application des peines"),
                cardColor: isDark
                    ? const Color(0xFF171822)
                    : const Color(0xFFE8EAF6),
                accent: const Color(0xFF1A237E),
                titleColor: isDark ? Colors.white : const Color(0xFF1A237E),
                children: [
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00253", "La loi n° 2000-516 du 15 juin 2000 a prévu la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00254", "juridictionnalisation des décisions du juge de l'application ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00255", "des peines, notamment pour la semi-liberté, le placement à ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00256", "l’extérieur, le fractionnement et la suspension des peines et ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00257", "la libération conditionnelle. Toute décision d’octroi, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00258", "d’ajournement, de refus, de retrait ou de révocation de ces ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00259", "mesures doit être prise après un débat contradictoire."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00260", "La loi n° 2004-204 du 9 mars 2004 a clarifié les règles ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00261", "relatives à l’application des peines et renforcé la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00262", "juridictionnalisation des mesures de milieu ouvert."),
                    ),
                  ]),
                  const SizedBox(height: 10),

                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00263", '3.1 - Juridictions de l’application des peines du premier degré'),
                  ),
                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00264", '3.1.1 - Le juge de l’application des peines'),
                  ),
                  _Paragraph.rich([
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00265", "L’")),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00266", "Article 712-2 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00267", " prévoit que dans chaque tribunal judiciaire, un ou plusieurs ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00268", "magistrats du siège exercent les fonctions de juge de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00269", "l’application des peines."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _Paragraph.rich([
                    TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00270", "Le juge de l’application des peines (JAP) fixe les principales ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00271", "modalités d’exécution des peines privatives ou restrictives de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00272", "liberté et en contrôle les conditions d’application."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00273", '3.1.1.1 - Décisions en milieu fermé')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00274", "En milieu fermé, le JAP intervient notamment pour : le placement à ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00275", "l’extérieur, la semi-liberté, la suspension ou le fractionnement des ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00276", "peines, la détention à domicile sous surveillance électronique, la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00277", "libération conditionnelle, après avis de la commission de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00278", "l’application des peines."),
                  ),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00279", '3.1.1.2 - Décisions en milieu ouvert')),
                  _Paragraph.rich([
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00280", "En milieu ouvert, l’")),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00281", "Article 712-6 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00282", " précise que le JAP détermine les conditions d’exécution de la ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00283", "peine en fonction de la situation du condamné (sursis ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00284", "probatoire, travail d’intérêt général, suivi socio-judiciaire, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00285", "interdiction de séjour, etc.)."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00286", '3.1.1.3 - Pouvoirs du JAP')),
                   _BulletPoint(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00287", "Peut ordonner la suspension d’une mesure (semi-liberté, placement ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00288", "extérieur, détention à domicile sous surveillance électronique) ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00289", "en cas de non-respect des obligations ;"),
                  ),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00290", "Peut ordonner l’incarcération provisoire du condamné après avis ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00291", "du procureur de la République dans certaines hypothèses ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00292", "Article 712-19 du Code de procédure pénale")),
                    const TextSpan(text: ");"),
                  ]),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00293", "Peut révoquer ou retirer les mesures prises en application des "),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00294", "Articles 712-6 et 712-7 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00295", " lorsque le condamné ne respecte pas ses obligations ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00296", "Article 712-20 du Code de procédure pénale")),
                    const TextSpan(text: ");"),
                  ]),
                  _BulletPoint.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00297", "Peut informer la victime ou la partie civile de ses droits et ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00298", "lui permettre de présenter des observations ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00299", "Article 712-16-1 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 8),

                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00300", '3.1.2 - Le tribunal de l’application des peines'),
                  ),
                  _Paragraph.rich([
                     TextSpan(text: ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00301", "L’")),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00302", "Article 712-3 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00303", " prévoit que dans le ressort de chaque cour d’appel est établi ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00304", "un tribunal de l’application des peines (TAP)."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00305", '3.1.2.2 - Composition')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00306", "Le TAP est composé d’un président et de deux assesseurs, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00307", "désignés parmi les juges de l’application des peines du ressort ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00308", "de la cour d’appel ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00309", "Article 712-10 alinéa 4 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00310", '3.1.2.3 - Compétence')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00311", "Le TAP est compétent pour les mesures qui ne relèvent pas du ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00312", "JAP, en particulier pour les décisions relatives : au ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00313", "relèvement de la période de sûreté, à la libération ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00314", "conditionnelle des condamnés à des peines supérieures à 10 ans, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00315", "à certaines suspensions de peine ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00316", "Article 712-11 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00317", '3.1.2.4 - Pouvoirs et voies de recours')),
                   _Paragraph(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00318", "Les décisions du TAP sont exécutoires par provision. Lorsque ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00319", "l’appel du ministère public est formé dans les 24 heures, il est ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00320", "suspensif. Les décisions peuvent être attaquées par la voie de ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00321", "l’appel par le condamné, le procureur de la République ou le ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00322", "procureur général."),
                  ),
                  const SizedBox(height: 10),

                   _SubTitle(
                    ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00323", '3.2 - La chambre de l’application des peines'),
                  ),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00324", "La chambre de l’application des peines de la cour d’appel est ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00325", "compétente pour connaître des appels formés contre les décisions ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00326", "du JAP et du TAP ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00327", "Article 712-13 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00328", '3.2.2 - Composition')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00329", "Elle est composée d’un président et de deux conseillers. Pour ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00330", "certains jugements (notamment ceux de l’"),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00331", "Article 712-7 du Code de procédure pénale")),
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00332", "), la chambre peut être complétée par un responsable d’une ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00333", "association de réinsertion et un responsable d’une association ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00334", "d’aide aux victimes."),
                    ),
                  ]),
                  const SizedBox(height: 6),
                   _SubTitle(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00335", '3.2.3 - Décisions')),
                  _Paragraph.rich([
                     TextSpan(
                      text:
                          ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00336", "La chambre de l’application des peines statue par arrêt motivé ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00337", "après débat contradictoire. Les arrêts peuvent faire l’objet, ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00338", "dans les 5 jours de leur notification, d’un pourvoi en ") + ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00339", "cassation non suspensif ("),
                    ),
                    _cpp(ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00340", "Article 712-15 du Code de procédure pénale")),
                    const TextSpan(text: ")."),
                  ]),
                ],
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  ScolariteText.value("lib/content/pa_scolarite/procedure_penale_pages/juridictions_execution_decisions_justice_page.dart", "f00341", '© COPIQ - Tous droits réservés'),
                  style: GoogleFonts.fustat(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : const Color(0xFF757575),
                  ),
                ),
              ),
            ],
          ),
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
  const _BulletPoint({this.text, this.spans})
    : assert(
        text != null || spans != null,
        'Vous devez fournir soit text soit spans',
      ),
      assert(
        text == null || spans == null,
        'Impossible d’utiliser text et spans en même temps',
      );

  /// Texte simple
  final String? text;

  /// Version riche (spans) pour gérer les articles en rouge
  final List<TextSpan>? spans;

  /// Nouveau constructeur nommé : .rich()
  const _BulletPoint.rich(this.spans) : text = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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

          /// Si texte simple → Text()
          if (text != null)
            Expanded(
              child: Text(
                text!,
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: color,
                ),
              ),
            ),

          /// Si version riche → RichText()
          if (spans != null)
            Expanded(
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: GoogleFonts.fustat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                    color: color,
                  ),
                  children: spans!,
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
          children: [
            ...bodySpans,
          ],
        ),
      ),
    );
  }
}

class _BulletPointRich extends StatelessWidget {
  const _BulletPointRich({required this.spans});

  final List<TextSpan> spans;

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
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: isDark
                      ? Colors.white70
                      : const Color(0xFF1F1F1F).withValues(alpha: .92),
                ),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
