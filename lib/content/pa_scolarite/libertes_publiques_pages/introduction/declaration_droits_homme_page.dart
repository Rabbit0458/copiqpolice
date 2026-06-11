import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — LIBERTÉS PUBLIQUES
///
///  La Déclaration des droits de l’homme et du citoyen de 1789
///
///   - Contexte historique et place dans la hiérarchie des normes
///   - Principes généraux et articles clés
///   - Droits et libertés garantis
///   - Garanties pénales et procédurales
///   - Intérêt pratique pour les libertés publiques et l’action policière
/// ===================================================================
class PaDeclarationDroitsHommePage extends StatelessWidget {
  const PaDeclarationDroitsHommePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/libertes_publiques/introduction/declaration_droits_homme';

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
        : const Color(0xFF3949AB);
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
          'Déclaration des droits de l’homme',
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
            'La Déclaration des droits de l’homme\net du citoyen de 1789 (D.D.H.C.)',
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
                  'Adoptée le 26 août 1789, en pleine Révolution française, la Déclaration des droits de l’homme et du citoyen (D.D.H.C.) est un texte fondamental qui proclame les droits naturels, inaliénables et imprescriptibles de l’être humain. ',
            ),
            TextSpan(
              text:
                  'Elle figure aujourd’hui dans le Préambule de la Constitution de 1958',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: referenceColor,
              ),
            ),
            const TextSpan(
              text:
                  ' et fait partie du « bloc de constitutionnalité ». Elle s’impose à toutes les autorités : Parlement, Gouvernement, administration, juges… et encadre directement l’action de la police.',
            ),
          ]),
          const SizedBox(height: 14),
          const _NotaBox(
            title: 'À retenir absolument',
            bodySpans: [
              TextSpan(
                text:
                    'La D.D.H.C. est un texte à valeur constitutionnelle qui consacre les grands principes des libertés publiques (égalité, liberté, sûreté, propriété, séparation des pouvoirs…). '
                    'Elle est très souvent citée par le Conseil constitutionnel et les juridictions lorsqu’il s’agit de contrôler une loi, un acte administratif ou une atteinte aux libertés.',
              ),
            ],
          ),
          const SizedBox(height: 22),

          // =====================================================
          // 1 — CONTEXTE HISTORIQUE & PLACE DANS LA HIÉRARCHIE
          // =====================================================
          _HypoCard(
            title:
                '1. Contexte historique et place\nde la D.D.H.C. dans la hiérarchie des normes',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La D.D.H.C. est rédigée par les représentants du peuple français, réunis en Assemblée constituante. '
                'Elle s’inspire à la fois des Lumières (Montesquieu, Rousseau, Voltaire) et des déclarations américaines d’indépendance.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Date : 26 août 1789 ; texte adopté avant la première Constitution française de 1791.',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Finalité : rappeler les droits fondamentaux afin que « les actes du pouvoir législatif et ceux du pouvoir exécutif puissent être à chaque instant comparés avec le but de toute institution politique ». ',
                ),
              ]),
              const _BulletPoint.rich([
                TextSpan(
                  text:
                      'Portée universelle : même si le texte est adopté en France, il se veut applicable à tous les êtres humains.',
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Depuis la décision « Liberté d’association » du Conseil constitutionnel (1971), la D.D.H.C. est reconnue comme ayant ',
                ),
                TextSpan(
                  text: 'valeur constitutionnelle',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: referenceColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : toute loi contraire peut être censurée. Elle fait partie du « bloc de constitutionnalité » aux côtés du Préambule de 1946, de la Constitution de 1958 et de la Charte de l’environnement de 2004.',
                ),
              ]),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 2 — PRINCIPES GÉNÉRAUX ET ARTICLES CLÉS
          // =====================================================
          _HypoCard(
            title: '2. Principes généraux proclamés par la D.D.H.C.',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'La D.D.H.C. pose d’emblée quelques idées-forces qui irriguent ensuite tout le droit des libertés publiques.',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Article 1er : « Les hommes naissent et demeurent libres et égaux en droits. » → Principe d’égalité et de liberté, interdiction des privilèges de naissance.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Article 2 : énumère les droits naturels et imprescriptibles de l’homme : la liberté, la propriété, la sûreté et la résistance à l’oppression.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Article 3 : principe de souveraineté nationale : « Le principe de toute Souveraineté réside essentiellement dans la Nation. »',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Article 6 : la loi est « l’expression de la volonté générale » ; elle doit être la même pour tous, et tous les citoyens doivent pouvoir concourir à son élaboration, directement ou par leurs représentants.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Article 16 : « Toute Société dans laquelle la garantie des Droits n’est pas assurée, ni la séparation des Pouvoirs déterminée, n’a point de Constitution. » → principe de séparation des pouvoirs et nécessité de garanties effectives.',
                ),
              ]),
              SizedBox(height: 10),
              _ExempleBox(
                title: 'Illustrations en pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        '• Le principe d’égalité (art. 1) est régulièrement invoqué pour contester des différences de traitement injustifiées entre catégories de personnes (fonctionnaires, étrangers, détenus…).\n'
                        '• L’article 16 sert de fondement au contrôle de la séparation des pouvoirs et au droit à un procès équitable (indépendance du juge, recours effectif…).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 3 — DROITS & LIBERTÉS GARANTIS
          // =====================================================
          _HypoCard(
            title: '3. Les principaux droits et libertés garantis',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'La D.D.H.C. ne distingue pas comme nous entre « libertés individuelles », « libertés collectives » ou « droits sociaux ». '
                'Elle énumère une série de droits qui seront ensuite précisés par le législateur et la jurisprudence.',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Liberté (art. 4) : la liberté consiste à « pouvoir faire tout ce qui ne nuit pas à autrui ». Elle est limitée par la loi, qui ne peut restreindre la liberté que lorsque c’est nécessaire pour garantir les droits d’autrui.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Sûreté (art. 7 à 9) : nul ne peut être arrêté ni détenu arbitrairement ; la loi fixe les procédures ; les agents qui ordonnent ou exécutent des ordres arbitraires doivent être punis.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Propriété (art. 17) : « La propriété étant un droit inviolable et sacré », nul ne peut en être privé si ce n’est pour cause d’utilité publique et sous condition d’une juste et préalable indemnité.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Liberté d’opinion, notamment religieuse (art. 10) : « Nul ne doit être inquiété pour ses opinions, même religieuses », tant que leur manifestation ne trouble pas l’ordre public établi par la loi.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Liberté d’expression et de communication (art. 11) : la libre communication des pensées et des opinions est « un des droits les plus précieux de l’homme ». Chacun peut donc parler, écrire, imprimer librement, sous réserve de répondre des abus de cette liberté dans les cas prévus par la loi.',
                ),
              ]),
              SizedBox(height: 10),
              _NotaBox(
                title: 'Articles incontournables à connaître',
                bodySpans: [
                  TextSpan(
                    text:
                        'Pour un policier et plus largement pour tout agent public, les articles les plus cités sont : '
                        '1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 16 et 17. Ils servent de base à la plupart des grandes libertés étudiées en droit administratif et en droit pénal.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 4 — GARANTIES PÉNALES & PROCÉDURALES
          // =====================================================
          _HypoCard(
            title: '4. Garanties pénales et procédurales',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Plusieurs articles de la D.D.H.C. encadrent directement le droit pénal et la procédure pénale. Ils sont essentiels pour l’activité policière : contrôles d’identité, gardes à vue, enquêtes, perquisitions…',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Principe de légalité des délits et des peines (art. 8) : « Nul ne peut être puni qu’en vertu d’une loi établie et promulguée antérieurement au délit. » → interdiction des incriminations et peines rétroactives.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Principe de nécessité et de proportionnalité des peines (art. 8) : la loi ne doit établir que des peines « strictement et évidemment nécessaires ». ',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Principe de présomption d’innocence (art. 9) : « Tout homme étant présumé innocent jusqu’à ce qu’il ait été déclaré coupable… » ; la rigueur des mesures privatives de liberté ne doit pas excéder ce qui est nécessaire.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Garanties contre les arrestations arbitraires (art. 7) : ceux qui donnent ou exécutent des ordres arbitraires doivent être punis ; le citoyen a le droit de résister s’il est arrêté illégalement.',
                ),
              ]),
              SizedBox(height: 10),
              _ExempleBox(
                title: 'Exemples de contrôle par le juge',
                bodySpans: [
                  TextSpan(
                    text:
                        '• Une loi créant une nouvelle infraction floue et trop large peut être censurée au regard de l’article 8 (principe de légalité et de nécessité des peines).\n'
                        '• Des conditions de garde à vue trop longues ou insuffisamment encadrées peuvent être jugées contraires à l’article 9 (présomption d’innocence et nécessité des mesures).',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =====================================================
          // 5 — INTÉRÊT POUR LE POLICIER & LES LIBERTÉS PUBLIQUES
          // =====================================================
          _HypoCard(
            title:
                '5. Intérêt de la D.D.H.C. pour les libertés publiques\n   et pour l’action du policier',
            cardColor: cardColor,
            accent: accentColor,
            titleColor: titleColor,
            textColor: textColor,
            children: const [
              _Paragraph(
                'Pour un policier, la D.D.H.C. n’est pas un texte théorique : elle constitue la base de la plupart des règles encadrant l’usage de la force, '
                'les contrôles, les fouilles, les gardes à vue, les perquisitions ou encore la liberté de manifester.',
              ),
              SizedBox(height: 8),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'Principe : toute mesure de police porte atteinte à une liberté. Cette atteinte doit toujours pouvoir être justifiée au regard des principes de la D.D.H.C. (nécessité, proportionnalité, égalité, respect de la sûreté…).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text:
                      'En cas de contentieux, le juge administratif ou judiciaire peut contrôler la compatibilité d’un acte de police avec la D.D.H.C. et éventuellement l’annuler ou sanctionner ses auteurs.',
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                'Connaître les grands articles de la D.D.H.C. permet donc au policier de comprendre le sens des libertés publiques, '
                'de mieux appliquer les lois et règlements et d’anticiper les risques juridiques liés à ses interventions.',
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
