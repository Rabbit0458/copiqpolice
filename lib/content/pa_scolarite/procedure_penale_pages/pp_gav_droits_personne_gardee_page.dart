import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:copiqpolice/content/gpx_scolarite/shared/scolarite_text.dart';

class PaPpGavDroitsPersonneGardeePage extends StatelessWidget {
  const PaPpGavDroitsPersonneGardeePage({super.key});

  static const String routeName =
      '/pa/dps_dpg/procedure_penale/pp_gav_droits_personne_gardee';

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
    final Color cardRed = isDark
        ? const Color(0xFF2A0A0A)
        : const Color(0xFFFFEBEE);
    const cardRedAccent = Color(0xFFC62828);

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

    Widget rightCard({
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
            "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
            "f00001",
            'Retour',
          ),
        ),
        title: Text(
          ScolariteText.value(
            "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
            "f00002",
            'Droits de la personne gardée à vue',
          ),
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 16,
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
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00003",
              'Droits de la personne gardée à vue',
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
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00004",
              'Art. 63-1 à 63-6 CPP — notification immédiate',
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
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00005",
              '1. Droits notifiés dès le placement en GAV',
            ),
          ),
          // ----------------------------------------------------------------
          rightCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.info_outline,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00006",
              'Notification de la nature de l\'infraction',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00007",
              'La personne gardée à vue doit être informée, dans une langue qu\'elle comprend, de la nature et de la date présumée de l\'infraction sur laquelle porte l\'enquête.',
            ),
          ),
          rightCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.mic_off_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00008",
              'Droit au silence',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00009",
              'La personne a le droit de faire des déclarations, de répondre aux questions posées ou de se taire (art. 63-1 CPP).',
            ),
          ),
          rightCard(
            bg: cardBlue,
            accent: cardBlueAccent,
            icon: Icons.schedule_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00010",
              'Durée maximale',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00011",
              'La GAV ne peut excéder 24 heures. Elle peut être prolongée une fois, pour la même durée, sur autorisation du Procureur de la République.',
            ),
          ),

          // ----------------------------------------------------------------
          sectionTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00012",
              '2. Droit à un avocat (art. 63-3-1 CPP)',
            ),
          ),
          // ----------------------------------------------------------------
          rightCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.balance_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00013",
              'Désignation d\'un avocat',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00014",
              'La personne peut demander à être assistée par un avocat dès le début de la garde à vue. Si elle n\'en a pas, un avocat commis d\'office peut être désigné.',
            ),
          ),
          rightCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.access_time_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00015",
              'Entretien de 30 minutes',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00016",
              'L\'avocat peut s\'entretenir confidentiellement avec la personne gardée à vue pendant 30 minutes dès son arrivée.',
            ),
          ),
          rightCard(
            bg: cardGreen,
            accent: cardGreenAccent,
            icon: Icons.assignment_ind_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00017",
              'Assistance aux auditions',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00018",
              'L\'avocat peut assister aux auditions. Il peut prendre des notes et, à l\'issue de chaque audition, poser des questions.',
            ),
          ),

          // ----------------------------------------------------------------
          sectionTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00019",
              '3. Autres droits garantis',
            ),
          ),
          // ----------------------------------------------------------------
          rightCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.phone_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00020",
              'Prévenir un proche (art. 63-2 CPP)',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00021",
              'La personne peut faire prévenir un membre de sa famille, son employeur ou son consulat si elle est étrangère. Cette notification peut être différée par le Parquet.',
            ),
          ),
          rightCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.medical_services_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00022",
              'Examen médical (art. 63-3 CPP)',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00023",
              'La personne peut demander à tout moment à être examinée par un médecin. Un médecin doit être désigné par l\'OPJ ou le Procureur.',
            ),
          ),
          rightCard(
            bg: cardOrange,
            accent: cardOrangeAccent,
            icon: Icons.translate_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00024",
              'Interprète (art. 63-1 CPP)',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00025",
              'Si la personne ne comprend pas le français, un interprète doit être désigné. Toutes les notifications sont effectuées dans une langue comprise.',
            ),
          ),

          // ----------------------------------------------------------------
          sectionTitle(
            ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00026",
              '4. Ce qui est interdit',
            ),
          ),
          // ----------------------------------------------------------------
          rightCard(
            bg: cardRed,
            accent: cardRedAccent,
            icon: Icons.block_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00027",
              'Interdiction de contrainte',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00028",
              'Aucune pression physique ou psychologique ne peut être exercée. Les aveux obtenus sous la contrainte sont nuls.',
            ),
          ),
          rightCard(
            bg: cardRed,
            accent: cardRedAccent,
            icon: Icons.no_food_outlined,
            title: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00029",
              'Conditions matérielles',
            ),
            body: ScolariteText.value(
              "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
              "f00030",
              'La personne gardée à vue bénéficie de repas et d\'un lieu de repos décent. Le non-respect de ces conditions peut entraîner la nullité de la procédure.',
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
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
                      "f00031",
                      'À retenir : ',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4527A0),
                    ),
                  ),
                  TextSpan(
                    text: ScolariteText.value(
                      "lib/content/pa_scolarite/procedure_penale_pages/pp_gav_droits_personne_gardee_page.dart",
                      "f00032",
                      'La notification des droits doit être immédiate, complète et tracée dans le PV de GAV. Toute omission peut entraîner la nullité de la procédure.',
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
