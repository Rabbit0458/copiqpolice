import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ===================================================================
///  COP'IQ — RÉTENTION DANS LES LOCAUX DE POLICE
///
///  Principes généraux
///   - Locaux de rétention & administrations concernées
///   - Liberté individuelle / liberté d’aller et venir
///   - Encadrement légal, article 9 DDHC, contrôle judiciaire
///   - Distinction judiciaire / administratif (clé pédagogique)
/// ===================================================================
class RetentionPrincipesPage extends StatelessWidget {
  const RetentionPrincipesPage({super.key});

  static const String routeName =
      '/gpx/generalites/retention_locaux_police/principes';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : Colors.white;
    final Color card = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF7F7F7);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF050505);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);
    final Color accent = isDark
        ? const Color(0xFF90CAF9)
        : const Color(0xFF1565C0);
    final Color redAccent = const Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
        ),
        title: Text(
          'Rétention – Principes généraux',
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
          // ================= TITRE GLOBAL =================
          Text(
            'I. Rétention dans les locaux de police\n(Principes généraux)',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),

          _Paragraph(
            'Les services de police disposent presque tous de locaux de rétention de personnes '
            '(geôles, locaux de garde à vue). Comme la gendarmerie, les douanes et l’autorité judiciaire, '
            'ils peuvent retenir des individus, mais uniquement dans les cas et les formes prévus par la loi.',
          ),
          const SizedBox(height: 10),

          Text(
            'En toile de fond, un principe majeur : la liberté individuelle, dont la liberté d’aller et venir '
            'est une composante essentielle. Toute rétention constitue donc une atteinte exceptionnelle à cette '
            'liberté, justifiée seulement lorsqu’il faut protéger un autre droit ou une autre liberté.',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.35,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),

          _BulletPoint.rich([
            TextSpan(
              text:
                  'La liberté est le principe, la rétention est l’exception encadrée par la loi.',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),
          _BulletPoint.rich([
            TextSpan(
              text:
                  'Chaque mesure de rétention doit pouvoir être rattachée à un texte précis, avec une durée et un niveau de coercition clairement définis.',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),

          const SizedBox(height: 22),

          // =====================================================
          // 1 — LOCAUX DE RÉTENTION & ADMINISTRATIONS
          // =====================================================
          _HypoCard(
            title: '1. Locaux de rétention et administrations concernées',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Les locaux de rétention de personnes regroupent notamment les geôles et locaux de garde à vue. '
                'Ils permettent de maintenir temporairement une personne sous la main de la police, le temps d’une mesure judiciaire '
                'ou administrative clairement encadrée.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Police nationale et gendarmerie',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : administrations principalement concernées par la rétention dans leurs locaux opérationnels.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Douanes et justice',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : disposent également de prérogatives de rétention dans un cadre spécifique (rétention douanière, locaux pénitentiaires ou judiciaires).',
                ),
              ]),

              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Exemple',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une personne interpellée pour vol aggravé est placée en garde à vue dans les locaux du commissariat. '
                        'Son retenu n’est licite que parce qu’elle s’inscrit dans une procédure judiciaire prévue par le Code de procédure pénale.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 2 — LIBERTÉ INDIVIDUELLE & LIBERTÉ D’ALLER ET VENIR
          // =====================================================
          _HypoCard(
            title: '2. Liberté individuelle et liberté d’aller et venir',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La liberté d’aller et venir est l’une des composantes centrales de la liberté individuelle. '
                'Retenir quelqu’un dans un local de police revient donc à limiter directement cette liberté fondamentale.',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Atteinte justifiée par un autre droit',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : la rétention ne se conçoit que pour protéger un autre intérêt majeur (sécurité des personnes, ordre public, exécution des décisions de justice, etc.).',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Atteinte strictement limitée',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : le temps et le niveau de contrainte doivent rester réduits à ce qui est nécessaire à la mesure (durée maximale, fouilles, usage de menottes…).',
                ),
              ]),

              const SizedBox(height: 10),
              const _NotaBox(
                title: 'Idée clé',
                bodySpans: [
                  TextSpan(
                    text:
                        'Ce n’est pas parce qu’une personne est placée en geôle qu’elle perd tous ses droits. '
                        'Elle reste titulaire de la liberté individuelle : seule la portion strictement nécessaire à la mesure est temporairement restreinte.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 3 — ENCADREMENT LÉGAL & ARTICLE 9 DDHC
          // =====================================================
          _HypoCard(
            title:
                '3. Encadrement légal, article 9 DDHC et contrôle judiciaire',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'Les atteintes à la liberté d’aller et venir ont été codifiées par le législateur lui-même, '
                'afin de concilier protection des libertés et exigences de sécurité. Elles s’accompagnent toujours d’un formalisme précis '
                'et d’un contrôle par l’autorité judiciaire.',
              ),
              const SizedBox(height: 10),

              _Paragraph.rich([
                TextSpan(
                  text:
                      'Article 9 de la Déclaration des droits de l’homme et du citoyen',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : toute personne est présumée innocente tant que sa culpabilité n’a pas été légalement établie. '
                      'Si l’on juge indispensable de l’arrêter, les rigueurs imposées doivent rester strictement nécessaires pour s’assurer de sa personne.',
                ),
              ]),
              const SizedBox(height: 8),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Pas de texte = rétention arbitraire',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : une mesure non prévue par la loi ou qui déborde le cadre fixé (durée, droits, niveau de contrainte) '
                      'peut être qualifiée d’arbitraire et engager la responsabilité de l’agent et de l’État.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Contrôle du juge',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: redAccent,
                  ),
                ),
                const TextSpan(
                  text:
                      ' : l’autorité judiciaire vérifie, a posteriori, la régularité de la rétention (fondement juridique, durée, respect des droits). '
                      'Un manquement peut entraîner annulation de procédure et indemnisations.',
                ),
              ]),

              const SizedBox(height: 10),
              const _ExempleBox(
                title: 'Exemple opérationnel',
                bodySpans: [
                  TextSpan(
                    text:
                        'Une personne est maintenue plusieurs heures dans un local de police sans base légale claire ni mention d’horaire de début. '
                        'En cas de contestation, le juge peut considérer la rétention comme arbitraire, annuler les actes subséquents et engager des poursuites.',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // 4 — JUDICIAIRE / ADMINISTRATIF : CLÉ PÉDAGOGIQUE
          // =====================================================
          _HypoCard(
            title: '4. Rétention judiciaire / rétention administrative',
            cardColor: card,
            accent: accent,
            titleColor: titleColor,
            textColor: textColor,
            children: [
              const _Paragraph(
                'La rétention d’une personne dans les locaux de police peut reposer sur une mesure à caractère judiciaire '
                '(garde à vue, vérification d’identité, exécution d’un mandat, etc.) ou sur une mesure à caractère administratif '
                '(droit au séjour, ivresse publique et manifeste, mineurs en fugue, terrorisme, etc.).',
              ),
              const SizedBox(height: 10),

              _BulletPoint.rich([
                TextSpan(
                  text: 'Mesures à caractère judiciaire',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : décidées ou contrôlées par l’autorité judiciaire, elles s’inscrivent dans une procédure pénale ou quasi-pénale.',
                ),
              ]),
              _BulletPoint.rich([
                TextSpan(
                  text: 'Mesures à caractère administratif',
                  style: TextStyle(fontWeight: FontWeight.w900, color: accent),
                ),
                const TextSpan(
                  text:
                      ' : décidées par l’autorité administrative (préfet, maire, administration), elles visent principalement la protection de l’ordre public.',
                ),
              ]),
              const SizedBox(height: 8),
              const _NotaBox(
                title: 'Attention pratique',
                bodySpans: [
                  TextSpan(
                    text:
                        'Dans certaines situations (par exemple la vérification d’identité), la frontière entre judiciaire et administratif peut être floue. '
                        'La distinction reste surtout pédagogique : sur le terrain, l’important est de connaître le fondement juridique exact, la durée maximale '
                        'et les droits de la personne retenue.',
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

//
//  ===================================================================
//  WIDGETS TEMPLATE (identiques à ta page LdPersonnesPage)
//  ===================================================================
/// ------------------------------------------------------------------
/// CARTE HYPOTHÈSE
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
/// PUCE SIMPLE
/// ------------------------------------------------------------------
class _BulletPoint extends StatelessWidget {
  final List<InlineSpan> spans;

  const _BulletPoint.rich(this.spans, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.white70 : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 15, height: 1.4, color: color)),
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
  const _ExempleBox({required this.title, required this.bodySpans});

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
        color: bgColor.withOpacity(isDark ? .65 : .9),
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
/// BLOC NOTA
/// ------------------------------------------------------------------
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
        color: bgColor.withOpacity(isDark ? .70 : .95),
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
