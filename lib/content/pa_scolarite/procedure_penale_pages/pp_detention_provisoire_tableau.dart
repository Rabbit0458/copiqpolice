import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPPDetentionProvisoireTableauPage extends StatelessWidget {
  const PaPPDetentionProvisoireTableauPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_detention_provisoire_tableau';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xFF303030) : const Color(0xFFF5F5F5);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF303030) : Colors.white,
        elevation: 0.6,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textMain),
          tooltip: 'Retour',
        ),
        title: Text(
          'Tableaux — Détention provisoire',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          const _TitleBlock(),
          const SizedBox(height: 20),

          // =================== DÉLITS ======================
          const _SubTitle(
            'Tableau — Détention provisoire des majeurs en matière de délits',
          ),
          const SizedBox(height: 8),
          const _DetentionDelitsTable(),

          const SizedBox(height: 28),

          // =================== CRIMES ======================
          const _SubTitle(
            'Tableau — Détention provisoire des majeurs en matière de crimes',
          ),
          const SizedBox(height: 8),
          const _DetentionCrimesTable(),

          const SizedBox(height: 24),
          const _NotaDetention(),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                         BLOC TITRE / INTRO                               ///
///////////////////////////////////////////////////////////////////////////////

class _TitleBlock extends StatelessWidget {
  const _TitleBlock();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF383838) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black12,
          width: .7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tableaux de la détention provisoire',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 8),
          const _Paragraph(
            'Ces tableaux récapitulent les durées initiales, les prolongations et les '
            'durées maximales de la détention provisoire pour les majeurs, en matière '
            'de délits et de crimes. Ils complètent les règles posées par la loi et '
            'permettent une vision globale des différents cas.',
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///                         WIDGETS TEXTE                                    ///
///////////////////////////////////////////////////////////////////////////////

class _SubTitle extends StatelessWidget {
  const _SubTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: GoogleFonts.fustat(
        fontWeight: FontWeight.w700,
        fontSize: 15.5,
        color: isDark ? const Color(0xFFBBDEFB) : const Color(0xFF0D47A1),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

    return Text(
      text,
      textAlign: TextAlign.justify,
      style: GoogleFonts.fustat(
        fontSize: 13.5,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}

class _NotaDetention extends StatelessWidget {
  const _NotaDetention();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class _DetentionDelitsTable extends StatelessWidget {
  const _DetentionDelitsTable();
  @override
  Widget build(BuildContext context) => const Placeholder(fallbackHeight: 120);
}

class _DetentionCrimesTable extends StatelessWidget {
  const _DetentionCrimesTable();
  @override
  Widget build(BuildContext context) => const Placeholder(fallbackHeight: 120);
}
