import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — CONTRÔLE DE LA CONSTITUTIONNALITÉ DES LOIS
///
///  D’après le polycopié :
///
///   I.  Constitution, suprématie et distinction constitutions souples / rigides
///   II. Procédure de révision de la Constitution
///   III. Procédure de contrôle de la Constitution
///   IV. Contrôle effectif : voie d’exception, juridiction constitutionnelle,
///       question prioritaire de constitutionnalité (QPC).
/// ===================================================================
class PaControleConstitutionnaliteLoisPage extends StatelessWidget {
  const PaControleConstitutionnaliteLoisPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/garanties/controle_constitutionnalite_lois';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color background = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF5D4037);
    final Color textColor = isDark ? Colors.white70 : const Color(0xFF424242);
    final Color accentColor = isDark
        ? const Color(0xFF00796B)
        : const Color(0xFF00695C);
    final Color referenceColor = isDark
        ? const Color(0xFF80CBC4)
        : const Color(0xFF00897B);

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
          'Contrôle de la constitutionnalité des lois',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17,
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
            'Le contrôle de la constitutionnalité des lois',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          const _Paragraph.rich([
            TextSpan(
              text:
                  'La Constitution est la norme suprême de l’État : toutes les lois devraient lui être conformes. '
                  'Mais cette supériorité n’a de sens que si elle est accompagnée d’un mécanisme de contrôle. '
                  'Comprendre qui contrôle, quand et comment, est indispensable pour mesurer la solidité de la protection des libertés publiques.',
            ),
          ]),
          const SizedBox(height: 16),
          _NotaBox(
            title: 'Idée-clé',
            bodySpans: [
              TextSpan(
                text:
                    'Sans contrôle de constitutionnalité effectif, la supériorité de la Constitution resterait purement théorique : '
                    'une loi portant atteinte aux libertés pourrait être appliquée malgré tout. Le contrôle est donc un outil central de l’État de droit.',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // I — CONSTITUTION SOUPLE / RIGIDE & SUPRÉMATIE
          // =====================================================
          _HypoCard(
            title: 'I — Suprématie constitutionnelle et types de Constitution',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Dans la plupart des États modernes, la Constitution est considérée comme une norme '
                'supérieure aux autres, notamment aux lois ordinaires. Mais cette supériorité ne se '
                'manifeste pas de la même manière partout : tout dépend du type de Constitution adopté.',
              ),
              const SizedBox(height: 10),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Constitution souple : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la Constitution peut être révisée par la même procédure que la loi ordinaire. '
                      'Elle a, en pratique, la même valeur juridique que les lois votées par le Parlement. '
                      'La loi n’est pas tenue de respecter un texte supérieur intangible.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Constitution rigide : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la révision constitutionnelle obéit à une procédure distincte et plus exigeante '
                      '(majorités renforcées, référendum, etc.). La Constitution est alors clairement '
                      'supérieure aux lois ordinaires, qui doivent impérativement lui être conformes.',
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: 'Conséquence pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Dans un système de Constitution souple, la supériorité de la Constitution est faible ou inexistante. '
                        'Dans un système rigide, elle devient un véritable outil de protection des droits fondamentaux, '
                        'à condition d’être assortie d’un mécanisme de contrôle efficace.',
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 1 — PROCÉDURE DE RÉVISION
          // =====================================================
          _HypoCard(
            title: 'Chapitre 1 — La procédure de révision de la Constitution',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'La manière dont on révise la Constitution dépend du type de régime : souple ou rigide. '
                'Cette procédure révèle le degré de protection accordé au texte constitutionnel.',
              ),
              SizedBox(height: 10),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Dans un État à Constitution souple : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la Constitution peut être modifiée par le même procédé que la loi ordinaire '
                      '(même organe, même majorité, même procédure). Elle est donc facilement révisable.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Dans un État à Constitution rigide : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'une procédure spécifique est prévue : intervention obligatoire du peuple, '
                      'majorité qualifiée, double vote, délai entre les lectures… L’idée est de '
                      'rendre la révision plus solennelle et plus difficile, afin de préserver la stabilité du texte.',
                ),
              ]),
              SizedBox(height: 8),
              _ExempleBox(
                title: 'Exemple français',
                bodySpans: [
                  TextSpan(
                    text:
                        'En France, l’article 89 de la Constitution de 1958 prévoit que la révision doit être '
                        'adoptée en termes identiques par l’Assemblée nationale et le Sénat, puis approuvée '
                        'par référendum ou par le Parlement réuni en Congrès à la majorité des 3/5. '
                        'On est donc clairement dans un régime de Constitution rigide.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // CHAPITRE 2 — PROCÉDURE DE CONTRÔLE DE LA CONSTITUTION
          // =====================================================
          _HypoCard(
            title: 'Chapitre 2 — La procédure de contrôle de la Constitution',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Au-delà de la révision, se pose la question du respect quotidien de la Constitution par les lois. '
                'Là encore, tout dépend du système adopté.',
              ),
              SizedBox(height: 10),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Dans une Constitution souple : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la loi ordinaire n’est pas tenue de respecter les règles inscrites dans la Constitution. '
                      'Elle peut même les contredire sans qu’aucune sanction particulière ne soit prévue. '
                      'La supériorité de la Constitution reste alors largement théorique.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Dans une Constitution rigide : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'toute loi doit respecter la Constitution et les textes qui en font partie intégrante '
                      '(déclarations de droits, préambules, chartes). Toute norme législative contraire '
                      'est dite inconstitutionnelle et devrait être écartée ou annulée.',
                ),
              ]),
              SizedBox(height: 8),
              _Paragraph(
                'Il devient alors indispensable de prévoir un mécanisme de contrôle pour constater '
                'l’inconstitutionnalité et empêcher l’application de la loi contraire. Sans cela, '
                'la supériorité de la Constitution resterait sans effet concret.',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // =====================================================
          // CHAPITRE 3 — CONTRÔLE EFFECTIF DE LA CONSTITUTIONNALITÉ
          // =====================================================
          _HypoCard(
            title:
                'Chapitre 3 — Le contrôle effectif de la constitutionnalité des lois',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'L’exercice réel du contrôle suppose la saisine d’organes juridictionnels compétents. '
                'Deux grands modèles existent classiquement : le contrôle par voie d’exception et le '
                'contrôle par une juridiction constitutionnelle spécialisée. En France, s’ajoute un '
                'mécanisme original : la question prioritaire de constitutionnalité (QPC).',
              ),
              const SizedBox(height: 14),

              // 3.1 – Voie d’exception
              Text(
                '3.1 — Le contrôle de la constitutionnalité des lois par voie d’exception',
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 6),
              const _Paragraph(
                'Dans ce système (emblématique des États-Unis), n’importe quel juge ordinaire peut, '
                'à l’occasion d’un litige, vérifier la conformité de la loi qu’il doit appliquer à la Constitution. '
                'S’il estime que la loi est contraire à la Constitution, il refuse simplement de l’appliquer au litige en cours.',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Le juge ne “supprime” pas la loi : il écarte son application dans l’affaire dont il est saisi. '
                      'Si une juridiction supérieure confirme cette analyse (Cour suprême, Cour de cassation…), '
                      'la norme inconstitutionnelle cessera progressivement d’être appliquée dans tout l’ordre juridique.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Ce contrôle est diffus (tout juge peut l’exercer) et concret (lié à un litige précis). '
                      'Il offre une protection fine mais au prix d’une certaine incertitude juridique.',
                ),
              ]),
              const SizedBox(height: 14),

              // 3.2 – Juridiction constitutionnelle
              Text(
                '3.2 — Le contrôle par une juridiction constitutionnelle',
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
                      'Dans ce modèle, le contrôle est confié à un organe spécialisé : une juridiction constitutionnelle. '
                      'En France, il s’agit du ',
                ),
                TextSpan(
                  text: 'Conseil constitutionnel',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', créé par la Constitution de 1958. Cette juridiction a vocation à écarter toute disposition législative '
                      'contraire à la Constitution et à empêcher son entrée en vigueur.',
                ),
              ]),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Contrôle a priori : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'en France, le Conseil constitutionnel peut être saisi avant la promulgation d’une loi. '
                      'La saisine est possible par le Président de la République, le Premier ministre, '
                      'les présidents de l’Assemblée nationale ou du Sénat, ou encore par 60 députés ou 60 sénateurs.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: 'Effet de la décision : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'une disposition déclarée inconstitutionnelle ne peut être promulguée ni appliquée. '
                      'Le contrôle est donc abstrait (portant sur le texte lui-même) et concentré (exercé par une seule juridiction).',
                ),
              ]),
              const SizedBox(height: 14),

              // 3.3 – QPC
              Text(
                '3.3 — La question prioritaire de constitutionnalité (QPC)',
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
                      'La révision du 23 juillet 2008 a introduit dans la Constitution de 1958 l’article 61-1. '
                      'Il permet à tout justiciable de soutenir, à l’occasion d’un procès en cours, qu’une disposition législative '
                      'porte atteinte aux droits et libertés que la Constitution garantit. ',
                ),
                TextSpan(
                  text:
                      'Si la question est sérieuse, le Conseil constitutionnel peut être saisi pour trancher.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: referenceColor,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'La procédure se déroule en trois grandes étapes, encadrées par une loi organique et un décret de 2010 :',
              ),
              const SizedBox(height: 6),
              const _BulletPoint.rich([
                TextSpan(
                  text: '1) Devant la juridiction saisie du litige : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la partie invoque la QPC. La juridiction vérifie si la disposition est applicable au litige, '
                      'si elle n’a pas déjà été déclarée conforme dans les mêmes circonstances et si la question présente un caractère sérieux. '
                      'Si ces conditions sont réunies, elle transmet la QPC au Conseil d’État ou à la Cour de cassation.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      '2) Devant le Conseil d’État ou la Cour de cassation : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'la haute juridiction exerce un second filtre. Elle dispose d’un délai limité pour décider '
                      's’il y a lieu de renvoyer la question au Conseil constitutionnel. En cas de refus, la juridiction '
                      'initiale statue sur le litige sans renvoi.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text: '3) Devant le Conseil constitutionnel : ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'saisi par renvoi, le Conseil se prononce sur la conformité de la disposition législative '
                      'aux droits et libertés garantis par la Constitution. Sa décision a une portée générale : '
                      'si la disposition est jugée inconstitutionnelle, elle est abrogée et ne peut plus être appliquée, '
                      'sauf réintroduction ultérieure dans un contexte de “changement de circonstances”.',
                ),
              ]),
              const SizedBox(height: 8),
              _NotaBox(
                title: 'Intérêt de la QPC',
                bodySpans: [
                  TextSpan(
                    text:
                        'La QPC permet de contrôler des lois déjà en vigueur, souvent anciennes, à partir de situations concrètes. '
                        'Elle renforce considérablement la protection des libertés publiques, en donnant la parole au justiciable lui-même.',
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ====================== SYNTHÈSE FINALE ======================
          _HypoCard(
            title: 'Synthèse — Lire la loi à la lumière de la Constitution',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Pour le policier, la Constitution n’est pas un texte abstrait réservé aux juristes : '
                'elle irrigue l’ensemble des lois qu’il applique au quotidien. Savoir qu’une mesure peut '
                'être contrôlée, censurée ou abrogée en cas d’atteinte excessive aux droits fondamentaux '
                'est un repère essentiel dans l’exercice de ses missions.',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Toujours garder à l’esprit la hiérarchie des normes : la loi n’est valable '
                      'que si elle respecte la Constitution et les textes qui en font partie intégrante.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Les mécanismes de contrôle (Conseil constitutionnel, QPC, conventions internationales) '
                      'sont des garde-fous qui protègent le citoyen… mais aussi le policier, en lui fournissant un cadre juridique clair.',
                ),
              ]),
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
    final Color color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

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
/// BLOC EXEMPLE
/// ------------------------------------------------------------------
class _ExempleBox extends StatelessWidget {
  const _ExempleBox({required this.bodySpans});

  final String title;
  final List<TextSpan> bodySpans;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color borderColor = isDark
        ? const Color(0xFF26A69A)
        : const Color(0xFF00897B);
    final Color bgColor = isDark
        ? const Color(0xFF00332B)
        : const Color(0xFFE0F2F1);
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
                    : const Color(0xFF00251A).withValues(alpha: .95),
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
