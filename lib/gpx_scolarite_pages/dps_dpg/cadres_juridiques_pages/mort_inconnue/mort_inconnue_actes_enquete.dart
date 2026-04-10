// lib/gpx_scolarite_pages/cadres_juridiques/mort_inconnue/mort_inconnue_actes_enquete.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _lawColor = Color(0xFFE53935);

class MortInconnueActesEnquetePage extends StatelessWidget {
  const MortInconnueActesEnquetePage({super.key});

  static const String routeName =
      '/gpx/cadres_juridiques/mort_inconnue/actes_enquete';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color accent = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
        ),
        title: Text(
          'Mort de cause inconnue',
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
          // ========================= TITRE PAGE ============================
          Text(
            'Les actes de l’enquête',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          _Paragraph.rich([
            const TextSpan(
              text:
                  'Cette partie présente les principaux actes réalisés par les officiers '
                  'et agents de police judiciaire lorsqu’un décès de cause inconnue ou '
                  'suspecte est signalé. Elle reprend la logique opérationnelle de ',
            ),
            TextSpan(
              text: 'l’article 74 alinéa 1 du Code de procédure pénale',
              style: const TextStyle(
                color: _lawColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const TextSpan(
              text:
                  ' : transport sur les lieux, premières constatations, choix du cadre '
                  'juridique et information du procureur de la République.',
            ),
          ]),
          const SizedBox(height: 18),

          // =================== CARTE 1 : TRANSPORT & CONSTATATIONS =========
          _ConditionCard(
            title: '1. Transport sur les lieux et premières constatations',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'L’enquête est toujours précédée d’un transport sur les lieux, effectué '
                      'par l’officier de police judiciaire ou, sous son contrôle, par '
                      'l’agent de police judiciaire. Conformément à ',
                ),
                TextSpan(
                  text: 'l’article 74 alinéa 1 du Code de procédure pénale',
                  style: const TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(
                  text:
                      ', l’enquêteur « procède aux premières constatations ». ',
                ),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Ces premières constatations ont plusieurs objectifs : sécuriser les lieux, '
                'préserver les traces et indices, identifier les témoins éventuels et '
                'apprécier, de façon globale, le contexte du décès.',
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Observer la scène de manière méthodique (position du corps, désordre, '
                    'traces de lutte, objets à proximité, médicaments, armes, etc.).',
              ),
              const _BulletPoint(
                text:
                    'Relever les éléments horaires (heure d’appel, arrivée sur les lieux, '
                    'présence éventuelle de secours médicaux).',
              ),
              const _BulletPoint(
                text:
                    'Identifier immédiatement les personnes présentes (famille, voisins, '
                    'témoins directs, premiers intervenants).',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // =================== CARTE 2 : HEURES LÉGALES & SECOURS ==========
          _ConditionCard(
            title: '2. Heures légales et nécessité de porter secours',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: const [
              _Paragraph(
                'En principe, l’enquêteur veille au respect des heures légales de visite '
                'des lieux d’habitation. Toutefois, en matière de décès, cette exigence '
                'cède le plus souvent devant la nécessité de porter secours ou de faire '
                'intervenir sans délai les services médicaux compétents (SAMU, médecin, '
                'médecin légiste).',
              ),
              SizedBox(height: 8),
              _BulletPoint(
                text:
                    'En cas de doute sur l’état de la personne, la priorité absolue '
                    'demeure la sauvegarde de la vie et l’appel aux secours.',
              ),
              _BulletPoint(
                text:
                    'Les actes de police judiciaire sont ensuite ajustés à la situation : '
                    'victime décédée à l’arrivée, décès constaté par un médecin, '
                    'personne réanimée puis décédée ultérieurement, etc.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // =================== CARTE 3 : CHOIX DU CADRE JURIDIQUE ==========
          _ConditionCard(
            title: '3. Détermination du cadre juridique d’enquête',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              const _Paragraph(
                'Les premières constatations ont pour but de déterminer le cadre juridique '
                'd’enquête adapté à la situation. À partir des éléments recueillis sur les '
                'lieux, l’enquêteur doit apprécier si la mort semble naturelle, violente, '
                'accidentelle, suicidaire ou potentiellement liée à une infraction pénale.',
              ),
              const SizedBox(height: 8),
              _IntroBullet(
                text:
                    'Lorsque les circonstances apparaissent compatibles avec une mort naturelle ou '
                    'accidentelle sans intervention de tiers, la procédure peut rester dans un '
                    'registre purement administratif (officier de l’état civil, certificat de '
                    'décès, permis d’inhumer).',
              ),
              _IntroBullet(
                text:
                    'Lorsque la mort est violente mais manifestement non criminelle (suicide ou '
                    'accident fortuit), l’enquête se rattache aux obligations prévues par le code '
                    'civil et les constatations de l’officier de police judiciaire.',
              ),
              _IntroBullet(
                text:
                    'Lorsque la cause de la mort est inconnue ou suspecte, le cadre spécifique de '
                    'la recherche des causes de la mort prévu par l’article 74 du Code de procédure '
                    'pénale doit être mis en œuvre.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // =================== CARTE 4 : INFORMATION DU PARQUET ============
          _ConditionCard(
            title:
                '4. Information du procureur de la République et suites immédiates',
            cardColor: cardColor,
            accent: accent,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      'Dès lors qu’il apparaît que la mort procède d’une cause inconnue ou suspecte, '
                      'l’officier de police judiciaire ou l’agent de police judiciaire agissant sous '
                      'son contrôle en rend compte sans délai au procureur de la République, '
                      'conformément à ',
                ),
                TextSpan(
                  text: 'l’article 74 du Code de procédure pénale',
                  style: const TextStyle(
                    color: _lawColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const TextSpan(text: '.'),
              ]),
              const SizedBox(height: 8),
              const _Paragraph(
                'Informé sur le champ, le procureur de la République peut décider de se rendre '
                'sur place s’il le juge nécessaire et se faire assister de personnes capables '
                'd’apprécier la nature des circonstances du décès (médecin, médecin légiste, '
                'techniciens en identification criminelle, etc.).',
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    'Le procureur peut laisser l’officier ou l’agent de police judiciaire '
                    'poursuivre les investigations dans le cadre de l’article 74 du Code de '
                    'procédure pénale.',
              ),
              const _BulletPoint(
                text:
                    'Il peut dessaisir le service initialement saisi pour confier l’enquête à '
                    'un autre service spécialisé (par exemple brigade criminelle, SRPJ, '
                    'section de recherches).',
              ),
              const _BulletPoint(
                text:
                    'Il peut enfin requérir l’ouverture d’une information pour recherche des '
                    'causes de la mort, permettant au juge d’instruction de prendre le relais '
                    'et, le cas échéant, de déléguer des actes aux enquêteurs par commission '
                    'rogatoire.',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====================== NOTA =====================================
          _NotaBox(
            bodySpans: [
              TextSpan(
                text:
                    'Les actes de l’enquête réalisés dès la découverte du corps conditionnent '
                    'la suite de la procédure. Des constatations rigoureuses, datées et '
                    'précises, faciliteront le choix ultérieur entre classement, procédure '
                    'administrative simple, enquête pénale classique ou information '
                    'judiciaire pour homicide ou violences ayant entraîné la mort.',
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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
        : const Color(0xFF1F1F1F).withOpacity(.92);

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
  const _BulletPoint({required this.text}) : rich = null;

  const _BulletPoint.rich(this.rich) : text = null;

  final String? text;
  final List<TextSpan>? rich;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color textColor = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withOpacity(.92);

    final Widget child;
    if (rich != null) {
      child = RichText(
        text: TextSpan(
          style: GoogleFonts.fustat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.35,
            color: textColor,
          ),
          children: rich!,
        ),
      );
    } else {
      child = Text(
        text ?? '',
        style: GoogleFonts.fustat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.35,
          color: textColor,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_rounded, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Expanded(child: child),
        ],
      ),
    );
  }
}

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
        color: bgColor.withOpacity(isDark ? .7 : .95),
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
