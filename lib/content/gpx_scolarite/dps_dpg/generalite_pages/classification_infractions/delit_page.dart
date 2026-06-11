import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DelitPage extends StatelessWidget {
  const DelitPage({super.key});

  static const String routeName =
      '/gpx/generalites/classification_infractions/delit';

  // === Thème & assets ======================================================
  static const String _headerImage = 'assets/images/delit.jpeg';
  static const Color _bgDark = Color(0xFF373737);
  static const Color _bgLight = Color(0xFFFFFFFF);
  static const Color _cardStrokeDark = Color(0x33FFFFFF);
  static const Color _cardFillDark = Color(0x14FFFFFF);
  static const Color _cardStrokeLight = Color(0x19000000);
  static const Color _cardFillLight = Color(0x0F000000);
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? _bgDark : _bgLight;
    final textMain = isDark ? Colors.white : const Color(0xFF050505);
    final textSoft = isDark ? Colors.white70 : const Color(0x99000000);
    final cardBorder = isDark ? _cardStrokeDark : _cardStrokeLight;
    final cardFill = isDark ? _cardFillDark : _cardFillLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          'Délits',
          style: GoogleFonts.fustat(
            color: textMain,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _HeaderHero(
              imagePath: _headerImage,
              title: 'Le DÉLIT',
              isDark: isDark,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList.list(
              children: [
                _SectionCard(
                  title: 'Définition & juridiction',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p(
                        "Le délit est une infraction de gravité intermédiaire entre le crime et la contravention.",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _p(
                        "Il est jugé par le tribunal correctionnel, et peut être sanctionné de peines correctionnelles.",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _ChipRow(
                        labels: const [
                          'Infraction intermédiaire',
                          'Tribunal correctionnel',
                        ],
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Peines encourues',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet(
                        "Emprisonnement de 2 mois à 10 ans (selon la nature du délit).",
                        textSoft,
                      ),
                      _bullet("Amende supérieure à 3 750 €.", textSoft),
                      _bullet(
                        "Travail d’intérêt général, jours-amende, interdictions, peines complémentaires…",
                        textSoft,
                      ),
                      _note(
                        "Les peines correctionnelles sont prévues aux articles 131-3 et suivants du Code pénal.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Tentative & complicité',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet(
                        "Tentative : punissable uniquement si la loi le prévoit expressément.",
                        textSoft,
                      ),
                      _bullet(
                        "Complicité : toujours punissable (aide, assistance, provocation, etc.).",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Prescription',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet(
                        "Action publique : 6 ans à compter du jour des faits.",
                        textSoft,
                      ),
                      _bullet(
                        "Peine : 6 ans à compter du jour où la condamnation est devenue définitive.",
                        textSoft,
                      ),
                      _bullet(
                        "Certaines infractions bénéficient de délais spéciaux (terrorisme, délits sexuels, etc.).",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Catégories de délits',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle("Délits de droit commun", textMain),
                      _p(
                        "Exemples : vol, escroquerie, abus de confiance, violences volontaires, etc.",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Délits politiques", textMain),
                      _p(
                        "Liés aux intérêts fondamentaux de la Nation ; jugés par les juridictions ordinaires (ou militaires en temps de guerre).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Délits terroristes", textMain),
                      _p(
                        "Prévu aux articles 421-1 et suivants du Code pénal. Compétence centralisée, peines aggravées.",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Délits militaires", textMain),
                      _p(
                        "Infractions commises par des militaires (désobéissance, désertion). Compétence : tribunaux militaires ou juridictions spécialisées.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Instantané / continu — effets juridiques',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle("Définitions", textMain),
                      _bullet(
                        "Infraction instantanée : réalisée en un seul acte (ex. vol, escroquerie).",
                        textSoft,
                      ),
                      _bullet(
                        "Infraction continue : se prolonge dans le temps (ex. non-représentation d’enfant).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Effets", textMain),
                      _bullet(
                        "Prescription : point de départ à la fin de la situation infractionnelle.",
                        textSoft,
                      ),
                      _bullet(
                        "Compétence : toutes les juridictions où les faits se produisent peuvent connaître l’affaire.",
                        textSoft,
                      ),
                      _bullet(
                        "Loi nouvelle : applicable aux délits continus si ceux-ci persistent sous son empire.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Simple / complexe / d’habitude',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet(
                        "Infraction simple : acte unique (ex. vol).",
                        textSoft,
                      ),
                      _bullet(
                        "Infraction complexe : plusieurs actes différents (ex. escroquerie).",
                        textSoft,
                      ),
                      _bullet(
                        "Infraction d’habitude : répétition d’actes semblables (ex. exercice illégal d’une profession).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Effets juridiques", textMain),
                      _bullet(
                        "Prescription : part du dernier acte de l’habitude.",
                        textSoft,
                      ),
                      _bullet(
                        "Loi nouvelle : s’applique si le dernier acte est postérieur à son entrée en vigueur.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Exemples de délits fréquents',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet(
                        "Vol simple (art. 311-3 C. pén.) — 3 ans d’emprisonnement et 45 000 € d’amende.",
                        textSoft,
                      ),
                      _bullet(
                        "Escroquerie (art. 313-1 C. pén.) — 5 ans et 375 000 €.",
                        textSoft,
                      ),
                      _bullet(
                        "Conduite en état d’ivresse (art. L.234-1 Code de la route) — 2 ans et 4 500 €.",
                        textSoft,
                      ),
                      _bullet(
                        "Violences volontaires ayant entraîné une ITT < 8 jours — 3 ans et 45 000 €.",
                        textSoft,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ——— Helpers texte ———

  static Widget _p(String text, Color color) => Text(
    text,
    style: GoogleFonts.fustat(
      fontSize: 15,
      height: 1.38,
      color: color,
      fontWeight: FontWeight.w500,
    ),
  );

  static Widget _subtitle(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.fustat(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  static Widget _bullet(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 7),
          child: Icon(Icons.circle, size: 6, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.fustat(fontSize: 15, height: 1.38, color: color),
          ),
        ),
      ],
    ),
  );

  static Widget _note(String text, Color color) => Container(
    margin: const EdgeInsets.only(top: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withValues(alpha: .16)),
    ),
    child: Text(
      text,
      style: GoogleFonts.fustat(
        fontSize: 14,
        height: 1.35,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

// ——— UI Components identiques à CrimePage ———

class _HeaderHero extends StatelessWidget {
  const _HeaderHero({
    required this.imagePath,
    required this.title,
    required this.isDark,
  });

  final String imagePath;
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'hero_delit',
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Color(0xCC000000)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: GoogleFonts.fustat(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    required this.textMain,
    required this.textSoft,
    required this.cardFill,
    required this.cardBorder,
  });

  final String title;
  final Widget child;
  final Color textMain;
  final Color textSoft;
  final Color cardFill;
  final Color cardBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Accordion extends StatefulWidget {
  const _Accordion({
    required this.title,
    required this.body,
    required this.textMain,
    required this.textSoft,
    required this.cardFill,
    required this.cardBorder,
  });

  final String title;
  final Widget body;
  final Color textMain;
  final Color textSoft;
  final Color cardFill;
  final Color cardBorder;

  @override
  State<_Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<_Accordion> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: widget.cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.cardBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _open,
          onExpansionChanged: (v) => setState(() => _open = v),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          title: Row(
            children: [
              AnimatedRotation(
                turns: _open ? 0.0 : -0.25,
                duration: const Duration(milliseconds: 220),
                child: const Icon(
                  Icons.adjust_rounded,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.fustat(
                    fontWeight: FontWeight.w800,
                    color: widget.textMain,
                  ),
                ),
              ),
            ],
          ),
          children: [widget.body],
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.labels, required this.isDark});
  final List<String> labels;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels
          .map(
            (t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white.withValues(alpha: isDark ? .10 : .08),
                border: Border.all(
                  color: Colors.white.withValues(alpha: isDark ? .18 : .14),
                ),
              ),
              child: Text(
                t,
                style: GoogleFonts.fustat(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
