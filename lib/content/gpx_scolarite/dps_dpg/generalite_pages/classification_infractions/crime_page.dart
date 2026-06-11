import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CrimePage extends StatelessWidget {
  const CrimePage({super.key});

  static const String routeName =
      '/gpx/generalites/classification_infractions/crime';

  // === EDITABLE — ASSETS & THEME ============================================
  static const String _headerImage = 'assets/images/crime.jpeg';
  static const Color _bgDark = Color(
    0xFF373737,
  ); // <- fond sombre doux (au lieu de noir)
  static const Color _bgLight = Color(0xFFFFFFFF);
  static const Color _cardStrokeDark = Color(0x33FFFFFF);
  static const Color _cardFillDark = Color(0x14FFFFFF);
  static const Color _cardStrokeLight = Color(0x19000000);
  static const Color _cardFillLight = Color(0x0F000000);
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? _bgDark : _bgLight;
    final textMain = isDark ? Colors.white : const Color(0xFF050505);
    final textSoft = isDark
        ? Colors.white70
        : const Color(0x99000000); // lisible
    final cardBorder = isDark ? _cardStrokeDark : _cardStrokeLight;
    final cardFill = isDark ? _cardFillDark : _cardFillLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Crimes',
          style: GoogleFonts.fustat(
            color: textMain,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, color: textMain),
          tooltip: 'Retour',
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _HeaderHero(
              imagePath: _headerImage,
              title: 'Le CRIME',
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
                        "Le crime est l’infraction la plus grave, jugée par la "
                        "cour d’assises.",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _ChipRow(
                        labels: const ['Gravité maximale', 'Cour d’assises'],
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Peines encourues (repères clés)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet(
                        "Réclusion ou détention criminelle à perpétuité.",
                        textSoft,
                      ),
                      _bullet(
                        "Réclusion ou détention criminelle de 10 à 30 ans au plus (seuil minimal de 10 ans).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _note(
                        "Des peines d’amende et/ou des peines complémentaires peuvent s’ajouter.",
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
                        "Tentative : toujours punissable pour les crimes.",
                        textSoft,
                      ),
                      _bullet(
                        "Complicité : punissable (aide/assistance, provocation, instructions…)",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Prescription (action publique)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet("Principe : 20 ans.", textSoft),
                      _bullet(
                        "Exceptions : 30 ans (ex. crimes de terrorisme, trafic de stupéfiants, crimes contre des mineurs dans certains cas).",
                        textSoft,
                      ),
                      _bullet(
                        "Imprescriptibilité : crimes contre l’humanité.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'La cour d’assises (fonctionnement)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p(
                        "La cour d’assises juge les crimes (meurtre, viol, vol à main armée, etc.). "
                        "Elle connaît également des tentatives et des complicités. "
                        "Elle siège sur saisine du juge d’instruction.",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _bullet(
                        "Composition : 3 magistrats professionnels + jury populaire (6 citoyens tirés au sort).",
                        textSoft,
                      ),
                      _bullet(
                        "Audience : publique ou à huis clos dans des cas prévus (ex. mineurs).",
                        textSoft,
                      ),
                      _bullet(
                        "Formations spéciales : cour d’assises des mineurs ; cour d’assises spéciale (terrorisme, trafic de stupéfiants en bande organisée).",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Catégories particulières de crimes (repères)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle("Crimes de droit commun", textMain),
                      _p(
                        "Réclusion criminelle / détention criminelle (échelle usuelle : 10 à 30 ans, ou perpétuité selon les textes).",
                        textSoft,
                      ),
                      const SizedBox(height: 10),
                      _subtitle("Crimes politiques", textMain),
                      _p(
                        "Juridictions : règles spécifiques historiques ; aujourd’hui, qualification rare. Certains actes relèvent de juridictions spécialisées.",
                        textSoft,
                      ),
                      const SizedBox(height: 10),
                      _subtitle("Crimes terroristes", textMain),
                      _p(
                        "Compétence spécifique (centralisation possible) ; peines aggravées ; procédures particulières (perquisition, garde à vue, etc.).",
                        textSoft,
                      ),
                      const SizedBox(height: 10),
                      _subtitle("Crimes militaires", textMain),
                      _p(
                        "Infractions commises par des militaires dans certains contextes : règles de compétence et de procédure spécifiques.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Modes de réalisation (commission / omission)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle("Infractions de commission", textMain),
                      _p(
                        "Réalisation d’un acte prohibé (ex. meurtre).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Infractions d’omission", textMain),
                      _p(
                        "L’omission est réprimée en tant que telle lorsque la loi la prévoit.",
                        textSoft,
                      ),
                      _bullet(
                        "Omission de porter secours (art. 223-6, al. 2 C. pén.).",
                        textSoft,
                      ),
                      _bullet(
                        "Omission de témoigner en faveur d’un innocent (art. 434-11 C. pén.).",
                        textSoft,
                      ),
                      _bullet(
                        "Délaissement d’une personne vulnérable (art. 223-3 C. pén.).",
                        textSoft,
                      ),
                      _bullet(
                        "Privation d’aliments/soins à mineur de 15 ans (art. 227-15 C. pén.).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Commission par omission", textMain),
                      _p(
                        "Exceptionnellement, une abstention est assimilée à une action lorsqu’un dommage résulte de la passivité fautive (ex. homicide/blessures par imprudence — art. 221-6, 222-19 C. pén.).",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                _Accordion(
                  title: 'Instantané / continu — impacts procéduraux',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle("Définitions", textMain),
                      _bullet(
                        "Infraction instantanée : se réalise en un instant (ex. meurtre).",
                        textSoft,
                      ),
                      _bullet(
                        "Infraction continue : exécution qui se prolonge (non-représentation d’enfant, port illégal de décoration, recel).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Intérêts de la distinction", textMain),
                      _bullet(
                        "Prescription : point de départ au jour des faits (instantané) / fin de l’état infractionnel (continu).",
                        textSoft,
                      ),
                      _bullet(
                        "Loi nouvelle : s’applique au délit continu si celui-ci se prolonge sous la nouvelle loi.",
                        textSoft,
                      ),
                      _bullet(
                        "Compétence : délit continu possible en plusieurs lieux — pluralité de juridictions compétentes.",
                        textSoft,
                      ),
                      _bullet(
                        "Amnistie : le délit continu peut demeurer punissable s’il perdure après l’amnistie.",
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
                      _subtitle("Définitions", textMain),
                      _bullet(
                        "Infraction simple : acte unique (ex. vol).",
                        textSoft,
                      ),
                      _bullet(
                        "Infraction complexe : plusieurs actes de nature différente (ex. escroquerie : manœuvres + remise).",
                        textSoft,
                      ),
                      _bullet(
                        "Infraction d’habitude : répétition d’actes identiques qui, isolés, ne constitueraient pas une infraction (ex. exercice illégal de la médecine).",
                        textSoft,
                      ),
                      const SizedBox(height: 8),
                      _subtitle("Intérêts", textMain),
                      _bullet(
                        "Prescription : pour l’habitude, point de départ au dernier acte.",
                        textSoft,
                      ),
                      _bullet(
                        "Loi nouvelle : s’applique si le dernier acte a été commis sous son empire.",
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

  // ————————————————— UI helpers —————————————————

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

// ————————————————— Components —————————————————

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
            tag: 'hero_crime',
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
