import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContraventionPage extends StatelessWidget {
  const ContraventionPage({super.key});

  static const String routeName =
      '/gpx/generalites/classification_infractions/contravention';

  // === Thème & assets ======================================================
  static const String _headerImage = 'assets/images/contravention.jpeg';

  // Palette : lisibilité parfaite sur les deux thèmes
  static const Color _bgDark = Color(0xFF2E2E2E); // gris profond (pas noir)
  static const Color _bgLight = Color(0xFFF7F7F7); // gris très clair

  static const Color _cardStrokeDark = Color(0x44FFFFFF);
  static const Color _cardFillDark = Color(0x22FFFFFF);

  static const Color _cardStrokeLight = Color(0x22000000);
  static const Color _cardFillLight = Color(0xFFFFFFFF); // cartes blanches
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? _bgDark : _bgLight;
    final textMain = isDark ? Colors.white : const Color(0xFF111111);
    final textSoft = isDark ? Colors.white70 : const Color(0xFF333333);

    final cardBorder = isDark ? _cardStrokeDark : _cardStrokeLight;
    final cardFill = isDark ? _cardFillDark : _cardFillLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          'Contraventions',
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
              title: 'La CONTRAVENTION',
              isDark: isDark,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList.list(
              children: [
                // Définition
                _SectionCard(
                  title: 'Définition et juridiction',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p(
                        "La contravention est l’infraction pénale la moins grave. "
                        "Elle relève de la compétence du tribunal de police. "
                        "Les contraventions sont classées de la 1ère à la 5ème classe.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                // Montant amendes maximum (Article 131-13)
                _Accordion(
                  title:
                      'Montant légal maximal des amendes (Article 131-13 du Code pénal)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: _FinesTable(
                    isDark: isDark,
                    textMain: textMain,
                    textSoft: textSoft,
                    header1: 'Classe',
                    header2: 'Montant maximal légal',
                    rows: const [
                      ['1ère classe', '38 €'],
                      ['2ème classe', '150 €'],
                      ['3ème classe', '450 €'],
                      ['4ème classe', '750 €'],
                      [
                        '5ème classe',
                        '1 500 € (porté à 3 000 € en cas de récidive lorsque le texte le prévoit)',
                      ],
                    ],
                  ),
                ),

                // Amende forfaitaire (1 -> 4)
                _Accordion(
                  title: 'Amende forfaitaire (classes de la 1ère à la 4ème)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _p(
                        "Certaines contraventions des quatre 1ères classes sont punies d’une amende forfaitaire "
                        "(montants indicatifs ci-dessous).",
                        textSoft,
                      ),
                      const SizedBox(height: 10),
                      _FinesTable(
                        isDark: isDark,
                        textMain: textMain,
                        textSoft: textSoft,
                        header1: 'Classe',
                        header2: 'Montant forfaitaire indicatif',
                        rows: const [
                          ['1ère classe', '38 €'],
                          ['2ème classe', '150 €'],
                          ['3ème classe', '450 €'],
                          ['4ème classe', '750 €'],
                        ],
                      ),
                      _note(
                        "Les montants peuvent varier selon les textes et selon le régime minoré / normal / majoré. "
                        "Toujours vérifier le texte réprimant l’infraction et les barèmes en vigueur.",
                        textSoft,
                        isDark,
                      ),
                    ],
                  ),
                ),

                // Exemples par classe
                _Accordion(
                  title: 'Exemples d’infractions par classe (repères)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle("1ère classe", textMain),
                      _bullet(
                        "Infractions aux règles de stationnement (exemple : stationnement gênant).",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 8),

                      _subtitle("2ème classe", textMain),
                      _bullet(
                        "Changement de direction sans utiliser les indicateurs de direction.",
                        textSoft,
                        textMain,
                      ),
                      _bullet("Non-paiement d’un péage.", textSoft, textMain),
                      _bullet(
                        "Absence d’attestation d’assurance (cas contraventionnel).",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 8),

                      _subtitle("3ème classe", textMain),
                      _bullet(
                        "Excès de vitesse inférieur à 20 km/h lorsque la vitesse maximale autorisée est supérieure à 50 km/h.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Dispositifs de freinage non conformes.",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 8),

                      _subtitle("4ème classe", textMain),
                      _bullet(
                        "Utilisation d’un téléphone tenu en main.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Circulation sur la bande d’arrêt d’urgence.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Conduite sans ceinture de sécurité.",
                        textSoft,
                        textMain,
                      ),
                      _bullet("Refus de priorité.", textSoft, textMain),
                      _bullet(
                        "Non-respect d’un feu rouge ou d’un panneau stop.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Franchissement ou chevauchement d’une ligne continue.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Absence de contrôle technique périodique.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Conduite en état alcoolique (contraventionnelle selon les seuils).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Circulation en sens interdit.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Non-respect des distances de sécurité.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Excès de vitesse inférieur à 50 km/h.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Dépassement dangereux ou sans visibilité.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Circulation sans éclairage.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Absence de certificat d’immatriculation.",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 8),

                      _subtitle("5ème classe", textMain),
                      _bullet(
                        "Excès de vitesse supérieur à 50 km/h (hors bascule délictuelle prévue par certains textes).",
                        textSoft,
                        textMain,
                      ),
                    ],
                  ),
                ),

                // Peines prévues par le Code pénal
                _Accordion(
                  title: 'Peines contraventionnelles — Code pénal',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle(
                        "Article 131-12 du Code pénal — Principe",
                        textMain,
                      ),
                      _bullet("1° L’amende.", textSoft, textMain),
                      _bullet(
                        "2° Les peines privatives ou restrictives de droits (Article 131-14 du Code pénal).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "3° La peine de sanction-réparation (Article 131-15-1 du Code pénal).",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 10),

                      _subtitle(
                        "Article 131-14 du Code pénal — 5ème classe : peines privatives ou restrictives de droits possibles",
                        textMain,
                      ),
                      _bullet(
                        "Suspension du permis de conduire (jusqu’à un an, sauf texte excluant cette limitation).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Immobilisation d’un ou de plusieurs véhicules (jusqu’à six mois).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Confiscation d’une ou de plusieurs armes.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Retrait du permis de chasser.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Interdiction, pour une durée d’un an au plus, d’émettre certains chèques et d’utiliser des cartes de paiement.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Confiscation de la chose ayant servi à commettre l’infraction ou qui en est le produit (sauf en matière de délit de presse).",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 10),

                      _subtitle(
                        "Article 131-16 du Code pénal — Peines complémentaires pouvant être prévues par le règlement",
                        textMain,
                      ),
                      _p(
                        "Selon le texte réprimant la contravention, le règlement peut notamment prévoir :",
                        textSoft,
                      ),
                      _bullet(
                        "Suspension du permis de conduire (jusqu’à trois ans).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Interdiction de détenir ou de porter une arme soumise à autorisation (jusqu’à trois ans).",
                        textSoft,
                        textMain,
                      ),
                      _bullet("Confiscation d’armes.", textSoft, textMain),
                      _bullet(
                        "Retrait du permis de chasser (jusqu’à trois ans).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Confiscation de l’objet ou du produit de l’infraction.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Interdiction de conduire certains véhicules terrestres à moteur (jusqu’à trois ans).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Peines de stage (par exemple : sécurité routière).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Confiscation d’un animal utilisé pour l’infraction ou contre lequel l’infraction a été commise.",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Interdiction de détenir un animal (jusqu’à trois ans).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Retrait de titres de conduite en mer / interdiction de navigation (jusqu’à un an).",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 10),

                      _subtitle(
                        "Article 131-17 du Code pénal — 5ème classe : peines complémentaires spécifiques",
                        textMain,
                      ),
                      _bullet(
                        "Interdiction d’émettre certains chèques (jusqu’à trois ans).",
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        "Travail d’intérêt général (de vingt à cent-vingt heures) à titre de peine complémentaire.",
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 10),

                      _subtitle(
                        "Article 131-18 du Code pénal — Cumul",
                        textMain,
                      ),
                      _p(
                        "Lorsque plusieurs peines complémentaires sont encourues (Articles 131-16 et 131-17 du Code pénal), "
                        "la juridiction peut prononcer soit la peine complémentaire, soit une ou plusieurs des peines complémentaires encourues.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                // Procédure / permis
                _Accordion(
                  title: 'Procédure et permis à points (routier)',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _subtitle('Procédure', textMain),
                      _bullet(
                        'Procès-verbal sur place ou contrôle automatisé.',
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        'Amende forfaitaire (minorée / forfaitaire / majorée) selon les délais et le paiement.',
                        textSoft,
                        textMain,
                      ),
                      _bullet(
                        'Possibilité de contestation (requête) menant à une ordonnance pénale ou à une audience.',
                        textSoft,
                        textMain,
                      ),
                      const SizedBox(height: 8),
                      _subtitle('Permis à points', textMain),
                      _p(
                        "Mesure administrative distincte des peines pénales. Retraits de points possibles pour certaines contraventions du Code de la route.",
                        textSoft,
                      ),
                    ],
                  ),
                ),

                // 4ème express
                _Accordion(
                  title: 'Mémo express',
                  textMain: textMain,
                  textSoft: textSoft,
                  cardFill: cardFill,
                  cardBorder: cardBorder,
                  body: _FinesTable(
                    isDark: isDark,
                    textMain: textMain,
                    textSoft: textSoft,
                    header1: 'Rubrique',
                    header2: 'Information',
                    rows: const [
                      ['Juridiction compétente', 'Tribunal de police'],
                      [
                        'Gravité',
                        'La moins élevée (de la 1ère à la 5ème classe)',
                      ],
                      [
                        'Peine principale',
                        'Amende (Articles 131-12 et 131-13 du Code pénal)',
                      ],
                      [
                        'Peines complémentaires',
                        'Selon les textes — 5ème classe : Article 131-14 ; Règlements : Article 131-16 ; Spécifiques : Article 131-17',
                      ],
                      ['Tentative et complicité', 'Non punissables'],
                      ['Prescription de l’action publique', '1 an'],
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

  static Widget _bullet(String text, Color color, Color main) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Icon(Icons.circle, size: 6, color: main.withValues(alpha: 0.7)),
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

  static Widget _note(String text, Color color, bool isDark) => Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F1F1),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : const Color(0x22000000),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          size: 18,
          color: isDark ? Colors.white70 : const Color(0xFF555555),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.fustat(
              fontSize: 14,
              height: 1.38,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  static Widget _chipLine(String label, String value, bool isDark) => Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: isDark
              ? Colors.white.withValues(alpha: .10)
              : const Color(0xFFEDEDED),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: .18)
                : const Color(0x22000000),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: isDark ? Colors.white : const Color(0xFF111111),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          value,
          style: GoogleFonts.fustat(
            fontSize: 15,
            height: 1.38,
            color: isDark ? Colors.white70 : const Color(0xFF333333),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

// ——— UI Components ———

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
            tag: 'hero_contravention',
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
                child: Icon(
                  Icons.adjust_rounded,
                  size: 18,
                  color: widget.textMain.withValues(alpha: 0.55),
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
                color: isDark
                    ? Colors.white.withValues(alpha: .10)
                    : const Color(0xFFEDEDED),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: .18)
                      : const Color(0x22000000),
                ),
              ),
              child: Text(
                t,
                style: GoogleFonts.fustat(
                  color: isDark ? Colors.white : const Color(0xFF111111),
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

// ——— Tableau simple de montants ———

class _FinesTable extends StatelessWidget {
  const _FinesTable({
    required this.isDark,
    required this.textMain,
    required this.textSoft,
    required this.header1,
    required this.header2,
    required this.rows,
  });

  final bool isDark;
  final Color textMain;
  final Color textSoft;
  final String header1;
  final String header2;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final headStyle = GoogleFonts.fustat(
      fontWeight: FontWeight.w900,
      color: isDark ? Colors.white : const Color(0xFF111111),
    );
    final cellStyle = GoogleFonts.fustat(
      color: textSoft,
      fontWeight: FontWeight.w600,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .12)
              : const Color(0x22000000),
        ),
        color: isDark ? Colors.white.withValues(alpha: .05) : Colors.white,
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1.2), 1: FlexColumnWidth(1.3)},
        border: TableBorder.symmetric(
          inside: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: .08)
                : const Color(0x11000000),
          ),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: .06)
                  : const Color(0x0F000000),
            ),
            children: [
              _cell(header1, headStyle, pad: const EdgeInsets.all(12)),
              _cell(header2, headStyle, pad: const EdgeInsets.all(12)),
            ],
          ),
          ...rows.map(
            (r) => TableRow(
              children: [_cell(r[0], cellStyle), _cell(r[1], cellStyle)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(
    String text,
    TextStyle style, {
    EdgeInsets pad = const EdgeInsets.all(10),
  }) {
    return Padding(
      padding: pad,
      child: Text(text, style: style),
    );
  }
}
