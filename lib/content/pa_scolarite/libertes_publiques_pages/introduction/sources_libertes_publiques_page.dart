import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — SOURCES DES LIBERTÉS PUBLIQUES
///
///  Page d’étude complète inspirée du polycopié :
///
///   CHAPITRE 1 : ÉVOLUTION HISTORIQUE JUSQU’EN 1958
///     - Les apports antérieurs à 1789 (sources philosophiques & juridiques)
///     - La Déclaration des droits de l’Homme et du citoyen de 1789
///     - L’évolution postérieure (Révolutions, Empires, Républiques…)
///
///   CHAPITRE 2 : LES SOURCES ACTUELLES
///     - Préambule de la Constitution de 1958
///     - Textes internationaux (ONU, CEDH, droit international humanitaire)
///
///   CHAPITRE 3 : VALEUR JURIDIQUE DES SOURCES
///     - Hiérarchie des normes & place des libertés publiques
///
/// ===================================================================
class PaSourcesLibertesPubliquesPage extends StatelessWidget {
  const PaSourcesLibertesPubliquesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/introduction/sources';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF5E35B1)
        : const Color(0xFF512DA8);
    final Color referenceColor = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00001", 'Sources des libertés publiques'),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: titleColor,
          ),
        ),
      ),

      // ===================== CONTENU =====================
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // ================= TITRE + INTRO =================
          Text(
            ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00002", 'Les sources des libertés publiques'),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
             TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00003", 'Les libertés dont nous bénéficions aujourd’hui en France sont le résultat ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00004", 'd’une construction historique longue. Textes philosophiques, déclarations ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00005", 'de droits, constitutions successives, conventions internationales : ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00006", 'chacun de ces éléments a contribué à forger le régime actuel des droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00007", 'et libertés publiques. '),
            ),
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00008", 'Comprendre leurs sources permet au policier de situer juridiquement son action, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00009", 'mais aussi de mesurer le poids symbolique de chaque atteinte à ces droits.'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 18),

          // =====================================================
          // CHAPITRE 1 — ÉVOLUTION HISTORIQUE JUSQU’EN 1958
          // =====================================================
           _NotaBox(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00010", 'Chapitre 1 — Évolution historique jusqu’en 1958'),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00011", 'Avant d’identifier les sources actuelles, il faut comprendre comment la ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00012", 'notion même de liberté publique s’est progressivement imposée : apports ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00013", 'philosophiques, révolutions politiques, textes de droits successifs…'),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // -----------------------------------------------------
          // 1.1 — APPORTS ANTÉRIEURS À 1789 : SOURCES PHILOSOPHIQUES
          // -----------------------------------------------------
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00014", '1.1 — Les apports antérieurs à 1789\n1.1.1 — Les sources philosophiques'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00015", 'Avant la Révolution française, plusieurs courants philosophiques ont ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00016", 'préparé le terrain à la reconnaissance des libertés publiques. Ils ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00017", 'constituent de véritables “sources intellectuelles” du droit des libertés.'),
                  style: TextStyle(color: textColor),
                ),
              ]),
              const SizedBox(height: 10),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00018", 'La pensée chrétienne : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00019", 'affirmation de l’égalité fondamentale de tous les hommes et valeur ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00020", 'de la personne humaine, qui doit être respectée en tant que créature ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00021", 'de Dieu. Cette idée sera reprise plus tard par le droit naturel.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00022", 'La théorie du droit naturel et du contrat social : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00023", 'développement, notamment chez Locke et Rousseau, de l’idée de droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00024", 'naturels, universels et inaliénables attachés à toute personne. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00025", 'Le contrat social justifie la création de l’État, mais celui-ci ne peut ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00026", 'porter atteinte à ces droits que dans la mesure nécessaire au bien commun.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00027", 'La philosophie des Lumières (XVIIIᵉ siècle) : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00028", 'modélisation des systèmes politiques anglo-saxons, esprit de résistance ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00029", 'au pouvoir arbitraire, défense de la tolérance religieuse, de la ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00030", 'liberté d’expression et de la séparation des pouvoirs. Ces idées ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00031", 'circulent largement dans les Parlements et parmi les élites françaises.'),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 22),

          // -----------------------------------------------------
          // 1.1.2 — SOURCES JURIDIQUES AVANT 1789
          // -----------------------------------------------------
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00032", '1.1.2 — Les sources juridiques avant 1789'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00033", 'À ces sources philosophiques s’ajoutent des textes juridiques étrangers qui ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00034", 'proclament déjà des droits et organisent des garanties contre l’arbitraire.'),
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00035", 'Les pactes anglais : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00036", 'de la Grande Charte de 1215 au Habeas Corpus (1679) puis au Bill of Rights (1689), ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00037", 'le roi s’engage progressivement à respecter certaines libertés ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00038", '(sûreté, procès équitable, liberté politique) et à accepter le contrôle ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00039", 'du Parlement sur son pouvoir.'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00040", 'Les déclarations américaines : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00041", 'les colonies américaines, influencées par ces précédents anglais, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00042", 'adoptent dès 1776 plusieurs déclarations de droits. On y retrouve ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00043", 'la notion d’égalité, l’affirmation de droits inaliénables (vie, liberté, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00044", 'bonheur). Ces textes annoncent la Déclaration française de 1789.'),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // -----------------------------------------------------
          // 1.2 — DÉCLARATION DES DROITS DE L’HOMME ET DU CITOYEN
          // -----------------------------------------------------
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00045", '1.2 — La Déclaration des droits de l’Homme et du citoyen\n       du 26 août 1789'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00046", 'Issue de l’Assemblée nationale constituante, la Déclaration de 1789 pose ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00047", 'les bases de la société nouvelle : souveraineté de la Nation, égalité, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00048", 'droits naturels et séparation des pouvoirs. Elle devient la référence ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00049", 'majeure en matière de libertés publiques. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00050", 'Ce texte a aujourd’hui valeur constitutionnelle en droit français.'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00051", 'Le polycopié met d’abord en avant les caractéristiques de la Déclaration, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00052", 'puis son contenu concret en matière de droits de l’Homme et du citoyen.'),
              ),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00053", '1.2.1 — Caractéristiques de la Déclaration de 1789'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00054", 'L’individualisme : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00055", 'la Déclaration vise d’abord l’homme en tant qu’individu titulaire ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00056", 'de droits. Elle ne reconnaît pas de droits collectifs en tant que tels ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00057", '(association, grève, syndicat…).'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00058", 'L’aspect métaphysique : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00059", 'les droits proclamés sont présentés comme naturels, inaliénables et ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00060", 'sacrés, c’est-à-dire antérieurs et supérieurs au pouvoir politique.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00061", 'L’universalité : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00062", 'les droits énoncés valent pour “tous les hommes”, même si, en pratique, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00063", 'ils ne s’appliquent alors qu’aux citoyens français.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00064", 'Le caractère abstrait : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00065", 'la Déclaration énonce de grands principes (liberté, égalité, sûreté, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00066", 'propriété…) mais prévoit peu de mécanismes concrets de mise en œuvre.'),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00067", '1.2.2 — Contenu : droits de l’Homme et droits du citoyen'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00068", 'Les droits de l’Homme : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00069", 'dignité, égalité (“les hommes naissent et demeurent libres et égaux en droits”), ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00070", 'liberté individuelle, liberté d’opinion et de religion, propriété, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00071", 'résistance à l’oppression… Ces droits inspireront la plupart des libertés ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00072", 'publiques contemporaines.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00073", 'Les droits du citoyen : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00074", 'droits politiques permettant la participation à la vie publique : ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00075", 'concours à la formation de la loi, consentement à l’impôt, accès aux ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00076", 'emplois publics, égalité devant les charges publiques, etc.'),
                ),
              ]),
              const SizedBox(height: 6),
               _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00077", 'Idée-clé à retenir'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00078", 'La Déclaration de 1789 ne se contente pas de “réciter” des valeurs. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00079", 'Elle affirme que la finalité de toute institution politique est la ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00080", 'conservation de ces droits. Toute atteinte injustifiée aux libertés ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00081", 'publiques est donc, en principe, contraire à la vocation même de l’État.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // -----------------------------------------------------
          // 1.3 — ÉVOLUTION POSTÉRIEURE
          // -----------------------------------------------------
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00082", '1.3 — L’évolution postérieure (1789–1958)'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children:  [
              _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00083", 'Après 1789, différents régimes se succèdent. Chacun réinterprète les droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00084", 'et libertés proclamés, en les renforçant ou, au contraire, en les restreignant.'),
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00085", 'La Constituante (1789–1791) : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00086", 'mise en place d’un régime de monarchie constitutionnelle. Large liberté ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00087", 'de réunion et d’expression, développement de la presse et des clubs politiques.'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00088", 'Les projets de 1793 (Girondins, Montagnards) : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00089", 'nouvelles déclarations de droits plus sociales (droit au travail, à ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00090", 'l’instruction, aux secours publics…). Leur application reste toutefois ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00091", 'limitée par l’instabilité politique.'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00092", 'Directoire, Consulat et Empire (fin XVIIIᵉ – début XIXᵉ siècle) : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00093", 'périodes globalement défavorables aux libertés : censure de la presse, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00094", 'contrôle des associations, commissions de sûreté, prisons d’État…'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00095", 'Chartes de 1814 et 1830 : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00096", 'programme politique libéral, reconnaissance de certaines libertés ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00097", 'individuelles (culte, presse, égalité civile), mais suffrage censitaire ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00098", 'et maintien de fortes limitations.'),
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00099", 'Constitution de 1848 et IIᵉ République, Second Empire, IIIᵉ République, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00100", 'préambule de 1946 : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00101", 'progressive affirmation des droits sociaux (travail, grève, protection ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00102", 'de la famille, instruction…) et élargissement du suffrage. La IIIᵉ ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00103", 'République consacre par diverses lois la liberté de réunion, de presse ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00104", 'et d’association. Le préambule de 1946 ajoute de nombreux droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00105", 'économiques et sociaux, toujours en vigueur aujourd’hui.'),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — SOURCES ACTUELLES
          // =====================================================
           _NotaBox(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00106", 'Chapitre 2 — Les sources actuelles des libertés publiques'),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00107", 'Le régime contemporain des libertés publiques repose principalement ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00108", 'sur la Constitution de 1958 et sur des conventions internationales ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00109", 'ratifiées par la France, notamment celles relatives aux droits de l’Homme.'),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // -----------------------------------------------------
          // 2.1 — PRÉAMBULE DE 1958
          // -----------------------------------------------------
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00110", '2.1 — Le préambule de la Constitution du 4 octobre 1958\n       (5ᵉ République)'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00111", 'Le préambule de 1958 est la source interne principale des libertés ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00112", 'publiques en France. Il renvoie explicitement à : '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00113", 'la Déclaration de 1789, le préambule de 1946 et la Charte de ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00114", 'l’environnement de 2004'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00115", '. Ces textes, reconnus comme ayant valeur constitutionnelle, forment ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00116", 'le “bloc de constitutionnalité”.'),
                ),
              ]),
              const SizedBox(height: 10),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00117", 'Ils ont été complétés par des lois importantes qui créent de nouveaux droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00118", 'ou précisent la protection de libertés déjà existantes.'),
              ),
              const SizedBox(height: 8),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00119", 'Droit au respect de la vie privée (loi du 17 juillet 1970) ; '),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00120", 'Informatique et libertés (loi du 6 janvier 1978) ; '),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00121", 'Droit d’accès aux documents administratifs (loi du 11 juillet 1979).'),
                ),
              ]),
              const SizedBox(height: 8),
               _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00122", 'Conséquence pratique'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00123", 'Lorsqu’un policier applique une loi ou un règlement, il doit garder en tête ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00124", 'que ces textes doivent être compatibles avec le bloc de constitutionnalité. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00125", 'En cas de doute sérieux, les justiciables peuvent saisir le Conseil ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00126", 'constitutionnel par la voie de la QPC.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // -----------------------------------------------------
          // 2.2 — TEXTES INTERNATIONAUX
          // -----------------------------------------------------
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00127", '2.2 — Les textes internationaux'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00128", 'Les libertés publiques ne sont plus seulement protégées au niveau interne. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00129", 'Elles bénéficient aussi d’un ensemble de garanties internationales, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00130", 'issues principalement de l’Organisation des Nations Unies et du Conseil de l’Europe.'),
              ),
              const SizedBox(height: 8),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00131", '2.2.1 — Le droit des conflits armés / droit international humanitaire'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00132", 'Convention de La Haye (1899–1907) : fixe des règles pour limiter les moyens ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00133", 'et méthodes de guerre, protéger les blessés et la population civile.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00134", 'Conventions de Genève (12 août 1949) : protègent les prisonniers de guerre, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00135", 'les blessés et les civils ; complétées par les protocoles additionnels de 1977 ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00136", 'qui prennent en compte les guerres de libération nationale, les conflits internes, etc.'),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00137", '2.2.2 — La Déclaration universelle des droits de l’Homme (ONU, 1948)'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00138", 'Adoptée par l’Assemblée générale des Nations Unies le 10 décembre 1948, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00139", 'la Déclaration universelle proclame un catalogue très large de droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00140", 'civils, politiques, économiques, sociaux et culturels. Elle a une valeur ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00141", 'essentiellement politique, mais a inspiré de nombreux traités contraignants.'),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00142", 'Conventions sur le génocide (1948) et sur l’imprescriptibilité des crimes contre l’humanité (1968) ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00143", 'Conventions contre l’esclavage (1926) et la traite des personnes (1950) ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00144", 'Convention contre la torture et autres peines ou traitements cruels, inhumains ou dégradants (1984) ;'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00145", 'Convention de 1951 sur le statut des réfugiés, conventions relatives aux travailleurs migrants, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00146", 'convention sur l’élimination de la discrimination raciale (1965)…'),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00147", '2.2.3 — La Convention européenne de sauvegarde des droits de l’Homme (CEDH, 1950)'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                 TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00148", 'Signée en 1950 et ratifiée par la France en 1974, la CEDH reprend l’essentiel ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00149", 'des droits de 1948 et crée surtout un mécanisme de contrôle juridictionnel ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00150", 'devant la Cour européenne des droits de l’Homme. '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00151", 'Tout justiciable qui s’estime victime d’une violation de ses droits peut, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00152", 'après épuisement des recours internes, saisir la Cour.'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00153", 'La France a été condamnée pour lenteur excessive de la justice, pour violations ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00154", 'du droit au respect de la vie privée (écoutes téléphoniques abusives), ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00155", 'pour traitements inhumains ou dégradants, etc.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00156", 'Les décisions de la Cour impliquent souvent des réformes législatives ou ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00157", 'administratives, ce qui montre l’impact concret de cette source sur le droit interne.'),
                ),
              ]),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — VALEUR JURIDIQUE DES SOURCES
          // =====================================================
          _HypoCard(
            title:
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00158", 'Chapitre 3 — Valeur juridique des sources des libertés publiques'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children:  [
              _Paragraph.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00159", 'Toutes les sources des libertés publiques n’ont pas la même force juridique. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00160", 'Plus un texte est élevé dans la hiérarchie des normes, plus la liberté qu’il ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00161", 'proclame est solidement protégée. En droit français, la hiérarchie se présente, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00162", 'du niveau le plus fort au plus faible, de la manière suivante :\n\n'),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00163", '• Constitution et textes à valeur constitutionnelle : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00164", 'Constitution de 1958, Déclaration de 1789, préambule de 1946, Charte de ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00165", 'l’environnement, principes fondamentaux reconnus par les lois de la République.\n'),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00166", '• Engagements internationaux : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00167", 'conventions de l’ONU, CEDH, traités relatifs aux droits de l’Homme…\n'),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00168", '• Lois et textes de valeur législative : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00169", 'codes et lois ordinaires qui organisent concrètement l’exercice des libertés.\n'),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00170", '• Principes généraux du droit : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00171", 'règles dégagées par la jurisprudence administrative (ex. respect des droits de la défense).\n'),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00172", '• Règlements : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00173", 'décrets, arrêtés, circulaires qui précisent les modalités pratiques ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00174", 'd’exercice ou de restriction des libertés publiques.'),
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00175", 'Réflexe opérationnel'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00176", 'Lorsqu’une mesure de police administrative porte atteinte à une liberté ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00177", 'publique, elle doit toujours respecter cette hiérarchie : un règlement ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00178", 'ne peut contredire une loi, et une loi ne peut méconnaître un texte à ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00179", 'valeur constitutionnelle ou conventionnelle. C’est ce contrôle de ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/sources_libertes_publiques_page.dart", "f00180", 'conformité qui garantit, en dernier ressort, la protection des citoyens.'),
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
/// CARTE DE CONTENU (bloc structuré)
/// ------------------------------------------------------------------
class _HypoCard extends StatelessWidget {
  const _HypoCard({
    required this.title,
    required this.cardColor,
    required this.accent,
    required this.titleColor,
    required this.textColor,
    required this.children,
  });

  final String title;
  final Color cardColor;
  final Color accent;
  final Color titleColor;
  final Color textColor;
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
/// PARAGRAPHES (texte simple ou riche)
/// ------------------------------------------------------------------
class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text) : spans = null;
  const _Paragraph.rich(this.spans) : text = null;

  final String? text;
  final List<TextSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final bool isRich = spans != null;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
/// PUCE (liste à points)
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  const _BulletPoint.rich(this.spans);

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .95);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 15, height: 1.4, color: color)),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 14, height: 1.35, color: color),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------------
/// BLOC EXEMPLE / ILLUSTRATION
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans, this.title = 'NOTA'});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF42A5F5)
        : const Color(0xFF1E88E5);
    final Color bgColor = isDark
        ? const Color(0xFF0D1B26)
        : const Color(0xFFE3F2FD);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? .70 : .95),
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
/// BLOC NOTA / MISE EN GARDE / FOCUS
/// ------------------------------------------------------------------
class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans, this.title = 'Nota bene'});

  final List<TextSpan> bodySpans;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
        color: bgColor.withValues(alpha: isDark ? .75 : .96),
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
