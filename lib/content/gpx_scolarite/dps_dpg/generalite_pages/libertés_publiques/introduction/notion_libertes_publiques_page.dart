import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
class NotionLibertesPubliquesPage extends StatelessWidget {
  const NotionLibertesPubliquesPage({super.key});

  static const String routeName =
      '/gpx/generalites/libertes_publiques/introduction/notion';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);
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
          'Notion de libertés publiques',
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
            'Comprendre la notion de libertés publiques',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Dans le langage courant, on confond souvent "droits de l’Homme" et '
                  '"libertés publiques". Or, en droit, la notion de libertés publiques '
                  'a un contenu beaucoup plus précis : il s’agit d’une catégorie de droits '
                  'fondamentaux reconnus et organisés par l’État. ',
            ),
            TextSpan(
              text:
                  'Pour le policier, maîtriser cette distinction est essentiel : elle '
                  'conditionne la légalité des mesures de police et la protection des citoyens.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: referenceColor,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          const _NotaBox(
            title: 'Plan de la fiche',
            bodySpans: [
              TextSpan(
                text:
                    '1. Libertés publiques et droits de l’Homme : comment les distinguer ?\n'
                    '2. Notion juridique de liberté et définition des libertés publiques.\n'
                    'L’objectif est d’identifier ce qui fait qu’une liberté devient une '
                    'véritable "liberté publique" protégée par le droit.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // CHAPITRE 1 — LIBERTÉS PUBLIQUES ET DROITS DE L’HOMME
          // =====================================================
          _HypoCard(
            title: 'Chapitre 1 — Libertés publiques et droits de l’Homme',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              _Paragraph(
                'La tendance contemporaine est de superposer "libertés publiques" et '
                '"droits de l’Homme". Pourtant, la notion de libertés publiques relève '
                'd’abord du droit : c’est une catégorie de droits de l’Homme intégrée '
                'dans le droit positif et assortie de garanties juridiques précises.',
              ),
              const SizedBox(height: 10),
              Text(
                'Trois idées issues du polycopié :',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: '1) Des droits "attendus" de l’État : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'les individus n’attendent pas seulement que l’État ne porte pas '
                      'atteinte à leurs droits ; ils attendent aussi qu’il mette en place '
                      'les moyens concrets permettant de les exercer. '
                      'Par exemple, la liberté d’enseignement prend tout son sens lorsque '
                      'l’État organise des établissements publics et contrôle que les '
                      'subventions au privé sont distribuées sans discrimination.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: '2) Des droits reconnus par l’État : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'ce qui caractérise une liberté publique, c’est qu’elle est consacrée '
                      'par un texte juridique : constitutionnel, législatif, voire '
                      'réglementaire. Le droit objectif (la règle écrite) vient ainsi '
                      'organiser les rapports entre l’État et les individus autour de ces droits.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      '3) Des droits bénéficiant d’une protection particulière : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'certaines libertés, dites "fondamentales", profitent d’un régime '
                      'juridique plus favorable que celui applicable aux autres droits '
                      '(contrôle du juge administratif, procédures d’urgence, valeur '
                      'constitutionnelle, etc.). C’est particulièrement vrai en matière '
                      'de libertés publiques.',
                ),
              ]),
              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Illustration opérationnelle',
                bodySpans: [
                  TextSpan(
                    text:
                        'La liberté d’aller et venir n’est pas seulement une valeur abstraite : '
                        'elle est expressément protégée par la Déclaration de 1789 et par la '
                        'jurisprudence de la Cour européenne des droits de l’Homme. '
                        'Toute mesure de contrôle d’identité, de garde à vue ou d’assignation '
                        'à résidence doit donc être appréciée à la lumière de ce double ancrage '
                        'constitutionnel et conventionnel.',
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
            title: 'Chapitre 2 — Liberté et libertés publiques',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              // ---------------- 2.1 NOTION DE LIBERTÉ ----------------
              Text(
                '2.1 — Notion de liberté',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph(
                'La liberté, dans son sens le plus large, est une notion complexe qui '
                'intéresse autant la philosophie que la politique, la culture, l’économie '
                'ou encore les sciences humaines. Le polycopié la définit comme le pouvoir '
                'd’autodétermination : la capacité pour un individu de choisir lui-même son '
                'comportement personnel.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Définition simple mais incomplète : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'cette approche purement individuelle ne prend pas en compte le rôle '
                      'de l’État, ni les contraintes nécessaires à la vie en société '
                      '(sécurité, ordre public, droits d’autrui).',
                ),
              ]),
              const SizedBox(height: 14),

              // ---------------- 2.2 NOTION DE LIBERTÉS PUBLIQUES ----------------
              Text(
                '2.2 — Notion de libertés publiques',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'La notion de libertés publiques présente deux facettes complémentaires :\n\n',
                ),
                TextSpan(
                  text: '• La notion de liberté : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'elle renvoie aux choix individuels, aux convictions, à la vie privée.\n',
                ),
                TextSpan(
                  text: '• Le qualificatif "publiques" : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'il souligne l’intervention de l’État, qui reconnaît, encadre et '
                      'protège ces libertés par le biais de normes juridiques.',
                ),
              ]),
              const SizedBox(height: 10),
              Text(
                'Définition juridique issue du cours',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  color: referenceColor,
                ),
              ),
              const SizedBox(height: 4),
              _Paragraph.rich([
                const TextSpan(
                  text: 'Les libertés publiques peuvent être définies comme : ',
                ),
                TextSpan(
                  text:
                      '« les libertés fondamentales reconnues par l’État, consacrées par un '
                      'texte (constitutionnel, législatif, éventuellement réglementaire ou '
                      'convention internationale ratifiée), dont l’exercice est organisé et '
                      'encadré, et dont les atteintes sont sanctionnées. »',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Reconnaissance par un texte : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'une liberté n’est "publique" que si elle est formellement inscrite '
                      'dans l’ordre juridique (Constitution, loi, convention internationale).',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Réglementation de l’exercice : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'l’État fixe les conditions d’exercice de la liberté (déclarations '
                      'préalables, autorisations, contrôles…). Ces règles ne doivent jamais '
                      'vider la liberté de sa substance.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Sanction des atteintes : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'toute restriction illégale peut être censurée par le juge, ce qui '
                      'garantit concrètement l’effectivité des libertés publiques.',
                ),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: 'À retenir pour la pratique policière',
                bodySpans: [
                  TextSpan(
                    text:
                        'Toutes les libertés n’entrent pas dans la catégorie des libertés '
                        'publiques. Sont des libertés publiques celles qui intéressent les '
                        'rapports entre les particuliers et les autorités publiques et que '
                        'l’État a choisi de consacrer, d’organiser et de protéger. '
                        'Lorsqu’un policier intervient dans ce domaine (manifestation, '
                        'contrôle d’identité, perquisition, mesures administratives, etc.), '
                        'il agit donc au cœur même des droits fondamentaux : la légalité et la '
                        'proportionnalité de son action seront particulièrement contrôlées.',
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
          border: Border.all(color: accent.withOpacity(.22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
  const _BulletPoint.rich(this.spans, {super.key});

  final List<InlineSpan> spans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.95);

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
  const _ExempleBox({required this.title, required this.bodySpans});

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
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
                    : const Color(0xFF102027).withOpacity(.95),
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
  const _NotaBox({required this.bodySpans, this.title = 'NOTA'});

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
        color: bgColor.withOpacity(isDark ? .75 : .96),
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
                : const Color(0xFF3E2723).withOpacity(.95),
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
