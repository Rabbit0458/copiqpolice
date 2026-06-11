import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaPpGavConditionsPlacementPage extends StatelessWidget {
  const PaPpGavConditionsPlacementPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_gav_conditions_placement';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);
    final Color textSoft = isDark
        ? Colors.white70
        : const Color(0xFF1F1F1F).withValues(alpha: .88);
    final Color cardBlue = isDark
        ? const Color(0xFF0D1B2A)
        : const Color(0xFFE3F2FD);
    const cardBlueAccent = Color(0xFF1565C0);
    final Color cardGreen = isDark
        ? const Color(0xFF0A2019)
        : const Color(0xFFE8F5E9);
    const cardGreenAccent = Color(0xFF2E7D32);
    final Color cardOrange = isDark
        ? const Color(0xFF2A1800)
        : const Color(0xFFFFF3E0);
    const cardOrangeAccent = Color(0xFFE65100);
    final Color cardIndigo = isDark
        ? const Color(0xFF1A1533)
        : const Color(0xFFEDE7F6);
    const cardIndigoAccent = Color(0xFF4527A0);

    Widget sectionTitle(String text) => Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 8),
          child: Text(
            text,
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: cardBlueAccent,
            ),
          ),
        );

    Widget condCard({
      required Color bg,
      required Color accent,
      required IconData icon,
      required String title,
      required String body,
    }) =>
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accent.withValues(alpha: .3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: GoogleFonts.fustat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.4,
                        color: textSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

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
          'Conditions GAV',
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 17.5,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          Text(
            'Conditions de placement en garde à vue',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Art. 62-2 CPP — Placement & durée',
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 20),

          // ----------------------------------------------------------------
          sectionTitle('1. Conditions légales de placement (art. 62-2 CPP)'),
          // ----------------------------------------------------------------
          condCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.gavel_outlined,
            title: 'Raisons plausibles de soupçon',
            body:
                'Il doit exister des raisons plausibles de soupçonner que la personne a commis ou tenté de commettre un crime ou un délit puni d\'une peine d\'emprisonnement.',
          ),
          condCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.list_alt_outlined,
            title: 'Nécessité de la mesure (l\'une des conditions)',
            body:
                '• Permettre l\'exécution des investigations\n• Garantir la représentation en justice\n• Empêcher une modification des preuves ou indices\n• Empêcher des pressions sur victimes ou témoins\n• Empêcher la concertation avec des coauteurs ou complices\n• Garantir la mise en œuvre de mesures destinées à faire cesser le crime',
          ),

          // ----------------------------------------------------------------
          sectionTitle('2. Qui peut placer en GAV ?'),
          // ----------------------------------------------------------------
          condCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.badge_outlined,
            title: 'Officier de Police Judiciaire (OPJ)',
            body:
                'Seul l\'OPJ peut décider du placement en GAV. L\'APJ et l\'APJA peuvent mener des auditions mais ne peuvent pas ordonner de GAV.',
          ),
          condCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.account_balance_outlined,
            title: 'Information du Procureur',
            body:
                'L\'OPJ doit informer sans délai le Procureur de la République du placement en GAV. Le Parquet peut mettre fin à la mesure à tout moment.',
          ),

          // ----------------------------------------------------------------
          sectionTitle('3. Durée de la garde à vue'),
          // ----------------------------------------------------------------
          condCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.hourglass_empty_outlined,
            title: 'Durée initiale : 24 heures',
            body:
                'La garde à vue ne peut excéder 24 heures à compter du placement effectif de la personne.',
          ),
          condCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.hourglass_full_outlined,
            title: 'Prolongation : + 24 heures',
            body:
                'Sur autorisation du Procureur de la République (ou du juge des libertés), la GAV peut être prolongée une fois pour une durée maximale de 24 heures supplémentaires.\n\nTotal possible : 48 heures.',
          ),
          condCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.dangerous_outlined,
            title: 'Durées spéciales (régimes dérogatoires)',
            body:
                '• Criminalité organisée : jusqu\'à 96 heures\n• Terrorisme : jusqu\'à 144 heures (6 jours)\n• Ces prolongations nécessitent l\'autorisation du JLD.',
          ),

          // ----------------------------------------------------------------
          sectionTitle('4. PV de placement en GAV'),
          // ----------------------------------------------------------------
          condCard(
            bg: cardIndigo,
            accent: cardIndigoAccent,
            icon: Icons.assignment_outlined,
            title: 'Contenu du PV',
            body:
                'Le PV de placement doit mentionner :\n• La date et l\'heure du placement\n• Les motifs justifiant la GAV\n• La nature de l\'infraction\n• La notification des droits (mention explicite)',
          ),

          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardIndigo,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cardIndigoAccent.withValues(alpha: .3)),
            ),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                  height: 1.45,
                  color: textSoft,
                ),
                children: const [
                  TextSpan(
                    text: 'À retenir : ',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: cardIndigoAccent,
                    ),
                  ),
                  TextSpan(
                    text:
                        'La GAV est une mesure privative de liberté soumise au contrôle du Parquet. Toute irrégularité dans le placement ou la notification des droits peut entraîner la nullité de la procédure.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
