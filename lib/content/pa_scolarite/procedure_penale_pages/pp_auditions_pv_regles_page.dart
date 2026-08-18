import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPpAuditionsPvReglesPage extends StatelessWidget {
  const PaPpAuditionsPvReglesPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_auditions_pv_regles';

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

    Widget infoCard({
      required Color bg,
      required Color accent,
      required IconData icon,
      required String title,
      required String body,
    }) => Container(
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
          tooltip: ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
            "f00002",
            'Règles du PV',
          ),
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
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00003",
              'Règles de rédaction du procès-verbal',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00004",
              'Formalités obligatoires — Art. 62 à 78-5 CPP',
            ),
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: textSoft,
            ),
          ),
          const SizedBox(height: 20),

          // ----------------------------------------------------------------
          sectionTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00005",
              '1. Mentions obligatoires',
            ),
          ),
          // ----------------------------------------------------------------
          infoCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.assignment_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00006",
              'Identité et qualité',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00007",
              'Le PV doit mentionner les nom, prénom, grade et numéro de matricule de l\'agent rédacteur, ainsi que son habilitation judiciaire (OPJ, APJ, APJA).',
            ),
          ),
          infoCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.calendar_today_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00008",
              'Date, heure et lieu',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00009",
              'La date, l\'heure de début et de fin, ainsi que le lieu de rédaction et d\'audition doivent être précisément indiqués.',
            ),
          ),
          infoCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.person_outline,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00010",
              'Identité de la personne entendue',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00011",
              'État civil complet, adresse, profession. En cas de refus ou d\'impossibilité, mention expresse de ce refus.',
            ),
          ),

          // ----------------------------------------------------------------
          sectionTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00012",
              '2. Droits notifiés avant audition',
            ),
          ),
          // ----------------------------------------------------------------
          infoCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.gavel_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00013",
              'Droit au silence',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00014",
              'La personne doit être informée de son droit de faire des déclarations, de répondre aux questions posées ou de se taire (art. 61-1 CPP).',
            ),
          ),
          infoCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.support_agent_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00015",
              'Droit à un avocat',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00016",
              'En audition libre : notification du droit à l\'assistance d\'un avocat. En GAV : notification dès le placement.',
            ),
          ),
          infoCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.translate_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00017",
              'Droit à un interprète',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00018",
              'Si la personne ne comprend pas le français, un interprète doit être désigné. Mention dans le PV.',
            ),
          ),

          // ----------------------------------------------------------------
          sectionTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00019",
              '3. Formalités de clôture',
            ),
          ),
          // ----------------------------------------------------------------
          infoCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.edit_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00020",
              'Lecture et signature',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00021",
              'Le PV est lu à l\'intéressé qui peut y faire ajouter ses observations. Il est signé par lui et par le fonctionnaire rédacteur.',
            ),
          ),
          infoCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.block_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00022",
              'Refus de signer',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00023",
              'En cas de refus ou d\'impossibilité de signer, mention expresse du refus dans le PV. Le PV reste valable.',
            ),
          ),
          infoCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.warning_amber_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00024",
              'Surcharges et ratures',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00025",
              'Toute rature ou surcharge doit être approuvée par signature ou paraphe. Les blancs doivent être bâtonnés (barrés) pour éviter tout ajout ultérieur.',
            ),
          ),

          // ----------------------------------------------------------------
          sectionTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00026",
              '4. Transmission',
            ),
          ),
          // ----------------------------------------------------------------
          infoCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.send_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00027",
              'Transmission au Parquet',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
              "f00028",
              'Les PV sont transmis sans délai au procureur de la République. En cas de flagrance, la transmission est immédiate.',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFEDE7F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4527A0).withValues(alpha: .3),
              ),
            ),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.fustat(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                  height: 1.45,
                  color: textSoft,
                ),
                children: [
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
                      "f00029",
                      'À retenir : ',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4527A0),
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_auditions_pv_regles_page.dart",
                      "f00030",
                      'Un PV irrégulier peut être frappé de nullité par le juge. La rigueur dans la rédaction protège la procédure et garantit la recevabilité des actes.',
                    ),
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
