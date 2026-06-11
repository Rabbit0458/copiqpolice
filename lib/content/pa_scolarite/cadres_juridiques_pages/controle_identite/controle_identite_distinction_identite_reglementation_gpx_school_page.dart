import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaConntroleIdentiteReglementationGpxSchool extends StatelessWidget {
  const PaConntroleIdentiteReglementationGpxSchool({super.key});

  static const String routeName =
      '/pa/dps_dpg/cadres_juridiques/controle_identite/chapitre1/distinction_identite_reglementation';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF222222).withValues(alpha: .72);

    final Color cardColor = isDark
? const Color(0xFF424242)
: const Color(0xFFF5F5F5);
    final Color accent = isDark
? const Color(0xFF64B5F6)
: const Color(0xFF1565C0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0D47A1);
    final Color articleColor = isDark
        ? const Color(0xFFFF8A80)
        : const Color(0xFFC62828);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'Contrôle / réglementation',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          // ===================== TITRE & INTRO ============================
          Text(
            'Distinction contrôle d’identité / contrôle de réglementation',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Comprendre la différence entre le contrôle d’identité de droit commun et les contrôles '
            'portant sur la présentation de titres ou documents liés à certaines activités ou situations '
            '(automobilistes, chasseurs, commerçants ambulants, etc.).',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
              height: 1.35,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 18),

          _ConditionCard(
            title:
                'La distinction contrôle d’identité – contrôle de réglementation',
            cardColor: cardColor,
            accent: accent,
            titleColor: titleColor,
            children: [
              // ===================== 1.3.1 – INTÉRÊT =====================
              const _SubTitle('1.3.1 – Intérêt de la distinction'),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Le contrôle d’identité de droit commun est strictement encadré par le ',
                ),
                TextSpan(
                  text: 'article 78-2 du code de procédure pénale',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: articleColor,
                  ),
                ),
                const TextSpan(
                  text:
                      ', qui fixe les hypothèses, les autorités compétentes et les modalités de sa mise en œuvre. '
                      'En dehors de ces cas limitativement définis, d’autres textes imposent à certaines catégories '
                      'de personnes de présenter, à toute réquisition de la force publique, un titre ou un document '
                      'prouvant la régularité de leur situation ou de leur activité.',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Il s’agit notamment des règles applicables à certaines professions ou activités soumises à un '
                'statut particulier : commerçants ambulants, forains, brocanteurs, chasseurs, pêcheurs, '
                'automobilistes, etc. Dans ces situations, la personne doit pouvoir présenter le document requis '
                '(permis, autorisation, titre, attestation…), mais il ne s’agit pas, juridiquement, d’un contrôle '
                'd’identité au sens de l’article 78-2 du code de procédure pénale.',
              ),
              const SizedBox(height: 14),

              // ===================== CONTROLE D’IDENTITÉ ==================
              const _SubTitle('Le contrôle d’identité de droit commun'),
              const _Paragraph(
                'Le contrôle d’identité est l’opération par laquelle une personne est invitée à justifier, sur place, '
                'de son identité. Il répond aux conditions et aux finalités prévues par le code de procédure pénale '
                '(police judiciaire, police administrative, contrôles en zone frontière, etc.).',
              ),
              const _Paragraph(
                'Dans ce cadre, l’agent qui contrôle doit pouvoir justifier qu’il se trouve dans l’un des cas prévus '
                'par les textes (raison plausible de soupçonner une infraction, réquisitions du procureur de la '
                'République, prévention d’atteintes à l’ordre public, recherches d’auteurs d’infractions, etc.).',
              ),
              const SizedBox(height: 14),

              // ===================== CONTROLE DE RÉGLEMENTATION ===========
              const _SubTitle('Le contrôle de réglementation'),
              const _Paragraph(
                'À l’inverse, certains textes imposent la présentation d’un titre ou d’un document en lien direct '
                'avec une activité ou une situation particulière : permis de conduire, permis de chasser, titre '
                'professionnel, autorisation d’exercice, etc. La personne contrôlée doit alors justifier non pas de '
                'son identité, mais de la régularité de sa situation au regard d’une réglementation spécifique.',
              ),
              const _Paragraph(
                'Ce contrôle de réglementation peut intervenir indépendamment de tout contrôle d’identité dès lors '
                'que l’appartenance de la personne à la catégorie concernée est matériellement évidente : '
                'automobiliste au volant de son véhicule, chasseur porteur de son fusil, marchand ambulant dans '
                'sa voiture-boutique, pêcheur en action de pêche, etc.',
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                'On parle donc de vérification spécifique liée à des statuts particuliers (professions, activités ou '
                'personnes soumises à des obligations particulières) et non d’un contrôle d’identité au sens du '
                'code de procédure pénale.',
              ),
              const SizedBox(height: 14),

              const _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        'Pour le policier sur le terrain, bien distinguer contrôle d’identité et contrôle de '
                        'réglementation permet de choisir le bon fondement juridique, d’éviter les nullités de procédure '
                        'et de respecter l’équilibre entre les libertés individuelles et les nécessités de l’ordre public.',
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
