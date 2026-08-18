import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

/// ===================================================================
///  COP'IQ — NOTION DE LIBERTÉS PUBLIQUES
///
///  Page d’étude complète inspirée du polycopié :
///
///   CHAPITRE 1 : LIBERTÉS PUBLIQUES ET DROITS DE L’HOMME
///     - Distinction entre droits de l’Homme (catégorie large)
///       et libertés publiques (notion strictement juridique)
///     - Droits attendus de l’État, reconnus par l’État
///       et bénéficiant d’une protection particulière
///
///   CHAPITRE 2 : LIBERTÉ ET LIBERTÉS PUBLIQUES
///     - Notion générale de liberté (pouvoir d’autodétermination)
///     - Définition juridique des libertés publiques
///       et idée d’intervention de l’État
/// ===================================================================
class PaNotionLibertesPubliquesPage extends StatelessWidget {
  const PaNotionLibertesPubliquesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/introduction/notion';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF00897B)
        : const Color(0xFF00796B);
    final Color referenceColor = isDark
        ? const Color(0xFF80CBC4)
        : const Color(0xFF00695C);

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
          ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00001", 'Notion de libertés publiques'),
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
            ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00002", 'Comprendre la notion de libertés publiques'),
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
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00003", 'Dans le langage courant, on confond souvent "droits de l’Homme" et ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00004", '"libertés publiques". Or, en droit, la notion de libertés publiques ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00005", 'a un contenu beaucoup plus précis : il s’agit d’une catégorie de droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00006", 'fondamentaux reconnus et organisés par l’État. '),
            ),
            TextSpan(
              text:
                  ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00007", 'Pour le policier, maîtriser cette distinction est essentiel : elle ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00008", 'conditionne la légalité des mesures de police et la protection des citoyens.'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 16),
           _NotaBox(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00009", 'Plan de la fiche'),
            bodySpans: [
              TextSpan(
                text:
                    ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00010", '1. Libertés publiques et droits de l’Homme : comment les distinguer ?\n') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00011", '2. Notion juridique de liberté et définition des libertés publiques.\n') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00012", 'L’objectif est d’identifier ce qui fait qu’une liberté devient une ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00013", 'véritable "liberté publique" protégée par le droit.'),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — LIBERTÉS PUBLIQUES ET DROITS DE L’HOMME
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00014", 'Chapitre 1 — Libertés publiques et droits de l’Homme'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00015", 'La tendance contemporaine est de superposer "libertés publiques" et ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00016", '"droits de l’Homme". Pourtant, la notion de libertés publiques relève ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00017", 'd’abord du droit : c’est une catégorie de droits de l’Homme intégrée ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00018", 'dans le droit positif et assortie de garanties juridiques précises.'),
              ),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00019", 'Trois idées issues du polycopié :'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00020", '1) Des droits "attendus" de l’État : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00021", 'les individus n’attendent pas seulement que l’État ne porte pas ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00022", 'atteinte à leurs droits ; ils attendent aussi qu’il mette en place ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00023", 'les moyens concrets permettant de les exercer. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00024", 'Par exemple, la liberté d’enseignement prend tout son sens lorsque ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00025", 'l’État organise des établissements publics et contrôle que les ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00026", 'subventions au privé sont distribuées sans discrimination.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00027", '2) Des droits reconnus par l’État : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00028", 'ce qui caractérise une liberté publique, c’est qu’elle est consacrée ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00029", 'par un texte juridique : constitutionnel, législatif, voire ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00030", 'réglementaire. Le droit objectif (la règle écrite) vient ainsi ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00031", 'organiser les rapports entre l’État et les individus autour de ces droits.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00032", '3) Des droits bénéficiant d’une protection particulière : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00033", 'certaines libertés, dites "fondamentales", profitent d’un régime ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00034", 'juridique plus favorable que celui applicable aux autres droits ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00035", '(contrôle du juge administratif, procédures d’urgence, valeur ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00036", 'constitutionnelle, etc.). C’est particulièrement vrai en matière ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00037", 'de libertés publiques.'),
                ),
              ]),
              const SizedBox(height: 10),
               _ExempleBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00038", 'Illustration opérationnelle'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00039", 'La liberté d’aller et venir n’est pas seulement une valeur abstraite : ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00040", 'elle est expressément protégée par la Déclaration de 1789 et par la ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00041", 'jurisprudence de la Cour européenne des droits de l’Homme. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00042", 'Toute mesure de contrôle d’identité, de garde à vue ou d’assignation ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00043", 'à résidence doit donc être appréciée à la lumière de ce double ancrage ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00044", 'constitutionnel et conventionnel.'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 2 — LIBERTÉ ET LIBERTÉS PUBLIQUES
          // =====================================================
          _HypoCard(
            title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00045", 'Chapitre 2 — Liberté et libertés publiques'),
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // ---------------- 2.1 NOTION DE LIBERTÉ ----------------
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00046", '2.1 — Notion de liberté'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
               _Paragraph(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00047", 'La liberté, dans son sens le plus large, est une notion complexe qui ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00048", 'intéresse autant la philosophie que la politique, la culture, l’économie ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00049", 'ou encore les sciences humaines. Le polycopié la définit comme le pouvoir ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00050", 'd’autodétermination : la capacité pour un individu de choisir lui-même son ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00051", 'comportement personnel.'),
              ),
              const SizedBox(height: 6),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00052", 'Définition simple mais incomplète : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00053", 'cette approche purement individuelle ne prend pas en compte le rôle ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00054", 'de l’État, ni les contraintes nécessaires à la vie en société ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00055", '(sécurité, ordre public, droits d’autrui).'),
                ),
              ]),
              const SizedBox(height: 14),

              // ---------------- 2.2 NOTION DE LIBERTÉS PUBLIQUES ----------------
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00056", '2.2 — Notion de libertés publiques'),
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
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00057", 'La notion de libertés publiques présente deux facettes complémentaires :\n\n'),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00058", '• La notion de liberté : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00059", 'elle renvoie aux choix individuels, aux convictions, à la vie privée.\n'),
                ),
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00060", '• Le qualificatif "publiques" : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00061", 'il souligne l’intervention de l’État, qui reconnaît, encadre et ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00062", 'protège ces libertés par le biais de normes juridiques.'),
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00063", 'Définition juridique issue du cours'),
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                 TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00064", 'Les libertés publiques peuvent être définies comme : '),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00065", '« les libertés fondamentales reconnues par l’État, consacrées par un ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00066", 'texte (constitutionnel, législatif, éventuellement réglementaire ou ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00067", 'convention internationale ratifiée), dont l’exercice est organisé et ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00068", 'encadré, et dont les atteintes sont sanctionnées. »'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00069", 'Reconnaissance par un texte : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00070", 'une liberté n’est "publique" que si elle est formellement inscrite ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00071", 'dans l’ordre juridique (Constitution, loi, convention internationale).'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00072", 'Réglementation de l’exercice : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00073", 'l’État fixe les conditions d’exercice de la liberté (déclarations ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00074", 'préalables, autorisations, contrôles…). Ces règles ne doivent jamais ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00075", 'vider la liberté de sa substance.'),
                ),
              ]),
               _BulletPoint.rich([
                TextSpan(
                  text: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00076", 'Sanction des atteintes : '),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00077", 'toute restriction illégale peut être censurée par le juge, ce qui ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00078", 'garantit concrètement l’effectivité des libertés publiques.'),
                ),
              ]),
              const SizedBox(height: 10),
               _NotaBox(
                title: ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00079", 'À retenir pour la pratique policière'),
                bodySpans: [
                  TextSpan(
                    text:
                        ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00080", 'Toutes les libertés n’entrent pas dans la catégorie des libertés ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00081", 'publiques. Sont des libertés publiques celles qui intéressent les ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00082", 'rapports entre les particuliers et les autorités publiques et que ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00083", 'l’État a choisi de consacrer, d’organiser et de protéger. ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00084", 'Lorsqu’un policier intervient dans ce domaine (manifestation, ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00085", 'contrôle d’identité, perquisition, mesures administratives, etc.), ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00086", 'il agit donc au cœur même des droits fondamentaux : la légalité et la ') + ScolariteText.value("lib/content/pa_scolarite/libertes_publiques_pages/introduction/notion_libertes_publiques_page.dart", "f00087", 'proportionnalité de son action seront particulièrement contrôlées.'),
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
/// BLOC NOTA / MISE EN GARDE
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
