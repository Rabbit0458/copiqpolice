import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrincipesGenerauxCirculationPage extends StatelessWidget {
  const PrincipesGenerauxCirculationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/natinf';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _b(String text) => TextSpan(
    text: text,
    style: const TextStyle(fontWeight: FontWeight.w900),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardMat = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardMoral = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardAggr = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardRep = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentAmber = isDark
        ? const Color(0xFFFFCA28)
        : const Color(0xFFF9A825);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

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
          "Règles d’usage des voies",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fustat(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: textMain,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text(
            "Principes généraux de circulation",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Intro / source
          _ConditionCard(
            title: "Repère",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Page “Natinf” classique : règles générales applicables à tout conducteur, "
                "avec focus sur la prudence, la position de conduite, les interdictions courantes "
                "(téléphone, oreillette, écran), et quelques obligations de circulation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "I — Élément légal",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _law("R. 412-6 à R. 412-16 du Code de la route"),
                const TextSpan(
                  text:
                      " : principes généraux de prudence, de maîtrise et de comportement du conducteur.",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel (les “faits” / obligations-interdictions)
          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Comportement prudent"),
              const _Paragraph(
                "Le conducteur de tout véhicule doit, à tout moment, adopter un comportement prudent et respectueux "
                "envers les autres usagers, avec une prudence accrue à l’égard des usagers les plus vulnérables.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Être en état et en position de manœuvrer"),
              const _Paragraph(
                "Le conducteur doit se tenir constamment en état et en position d’exécuter commodément et sans délai "
                "toutes les manœuvres qui lui incombent (champ de vision et possibilités de mouvement non réduits par : "
                "passagers, objets transportés, objets non transparents sur les vitres…).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6090"),
                  const TextSpan(text: " — "),
                  _law("R. 412-6 du Code de la route"),
                  const TextSpan(
                    text:
                        " (gêne / conditions ne permettant pas de manœuvrer aisément).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("C) Interdictions en circulation"),
              const _BulletPoint(text: "Usage d’un téléphone tenu en main."),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("23800"),
                  const TextSpan(text: " — "),
                  _law("R. 412-6-1 du Code de la route"),
                  const TextSpan(
                    text:
                        " (AF min. 4e classe, retrait de 3 points ; contrôle alcoolémie obligatoire).",
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Port à l’oreille d’un dispositif susceptible d’émettre du son (sauf appareils correcteurs de surdité).",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("31063"),
                  const TextSpan(text: " — "),
                  _law("R. 412-6-1 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Placer dans le champ de vision un appareil en fonctionnement doté d’un écran (hors aide à la conduite/navigation).",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("26963"),
                  const TextSpan(text: " — "),
                  _law("R. 412-6-2 du Code de la route"),
                  const TextSpan(
                    text:
                        " (AF min. 5e classe, retrait de 3 points, saisie possible de l’appareil).",
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Adopter une position ou effectuer une manœuvre acrobatique / non conforme aux conditions normales d’utilisation (conduite imprudente caractérisée).",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("35564"),
                  const TextSpan(text: " — "),
                  _law("R. 412-6-4 du Code de la route"),
                  const TextSpan(
                    text:
                        " (AF min. 3e classe, retrait de 2 points ; contrôle alcoolémie obligatoire).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("D) Obligations de circulation sur la chaussée"),
              const _Paragraph(
                "Obligation de circuler sur la chaussée (sauf nécessité absolue, accès carrossables, aménagement particulier). "
                "En marche normale, les véhicules circulent près du bord droit (sauf trajectoire matérialisée pour cycles/EDPM/cyclomobiles légers, "
                "ou giratoire à plusieurs voies).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("24088"),
                  const TextSpan(text: " — "),
                  _law("R. 412-7 du Code de la route"),
                  const TextSpan(
                    text: " (circulation en dehors de la chaussée).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6092"),
                  const TextSpan(text: " — "),
                  _law("R. 412-9 du Code de la route"),
                  const TextSpan(text: " (éloigné du bord droit)."),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6093"),
                  const TextSpan(text: " — "),
                  _law("R. 412-9 du Code de la route"),
                  const TextSpan(
                    text:
                        " (marche normale sur la partie gauche d’une chaussée à double sens).",
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle(
                "E) Voies réservées / voies vertes / aires piétonnes / BAU",
              ),
              const _BulletPoint(
                text:
                    "Voies réservées : interdiction de circuler pour les véhicules non autorisés (transport en commun, véhicules d’intérêt général, piste/bande cyclable…).",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF (exemples)",
                bodySpans: [
                  _bold("24090"),
                  const TextSpan(text: ", "),
                  _bold("24091"),
                  const TextSpan(text: ", "),
                  _bold("32512"),
                  const TextSpan(text: " — "),
                  _law("R. 412-7 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text:
                    "Voies vertes / aires piétonnes : interdiction de circuler en véhicule motorisé (sauf exceptions fixées par arrêté).",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("24089"),
                  const TextSpan(text: " — "),
                  _law("R. 412-7 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),

              const _BulletPoint(
                text: "Bande d’arrêt d’urgence : circulation interdite.",
              ),
              const SizedBox(height: 6),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6292"),
                  const TextSpan(text: " — "),
                  _law("R. 412-8 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("F) Distances de sécurité"),
              const _Paragraph(
                "Le conducteur doit conserver une distance de sécurité suffisante pour éviter une collision en cas de ralentissement brusque "
                "ou d’arrêt subit du véhicule qui le précède : distance correspondant à au moins 2 secondes.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Repères",
                bodySpans: const [
                  TextSpan(
                    text:
                        "50 km/h ≈ 28 m • 90 km/h ≈ 50 m • 110 km/h ≈ 62 m • 130 km/h ≈ 73 m.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("6096"),
                  const TextSpan(text: " — "),
                  _law("R. 412-12 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 8),
              _NotaBox(
                title: "Ouvrages à risques",
                bodySpans: [
                  _bold("23082"),
                  const TextSpan(text: " — "),
                  _law("R. 412-12 du Code de la route"),
                  const TextSpan(text: " (distance imposée : tunnel/pont…)."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("G) Avertissement préalable (clignotants)"),
              const _Paragraph(
                "Tout conducteur qui s’apprête à changer de direction ou à ralentir doit avertir de son intention les autres usagers "
                "(se porter à gauche, traverser, reprendre sa place après arrêt/stationnement…).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("217"),
                  const TextSpan(text: " — "),
                  _law("R. 412-10 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("H) Facilités de passage (transport en commun)"),
              const _Paragraph(
                "En agglomération, le conducteur doit ralentir si nécessaire et au besoin s’arrêter "
                "pour laisser les véhicules de transport en commun quitter les arrêts signalés.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "NATINF",
                bodySpans: [
                  _bold("11084"),
                  const TextSpan(text: " — "),
                  _law("R. 412-11 du Code de la route"),
                  const TextSpan(text: "."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément moral (logique “NATINF”)
          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En pratique, ces infractions reposent sur la violation d’une obligation de prudence/maîtrise "
                "ou d’une interdiction explicite (téléphone, oreillette, écran, manœuvre acrobatique, etc.).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Circonstances aggravantes
          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Pas de circonstance aggravante spécifique indiquée ici : se référer à la NATINF concernée "
                "et aux dispositions particulières (ex. alcoolémie obligatoire, retraits de points, saisie…).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Répression (résumé clean, pédagogique)
          _ConditionCard(
            title: "V — Répression (repères NATINF)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Obligations / interdictions majeures"),
              _Paragraph.rich([
                _b("6090"),
                const TextSpan(text: " — gêne du conducteur — "),
                _law("R. 412-6 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("23800"),
                const TextSpan(text: " — téléphone tenu en main — "),
                _law("R. 412-6-1 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("31063"),
                const TextSpan(text: " — dispositif à l’oreille — "),
                _law("R. 412-6-1 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("26963"),
                const TextSpan(text: " — écran dans le champ de vision — "),
                _law("R. 412-6-2 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("35564"),
                const TextSpan(text: " — manœuvre/position acrobatique — "),
                _law("R. 412-6-4 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _b("24088"),
                const TextSpan(text: " — hors chaussée — "),
                _law("R. 412-7 C.R."),
                const TextSpan(text: " • "),
                _b("6092"),
                const TextSpan(text: " / "),
                _b("6093"),
                const TextSpan(text: " — bord droit — "),
                _law("R. 412-9 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("6292"),
                const TextSpan(text: " — bande d’arrêt d’urgence — "),
                _law("R. 412-8 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("6096"),
                const TextSpan(text: " — distance de sécurité — "),
                _law("R. 412-12 C.R."),
                const TextSpan(text: " • "),
                _b("23082"),
                const TextSpan(text: " — ouvrage à risques."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("217"),
                const TextSpan(
                  text: " — changement de direction sans avertissement — ",
                ),
                _law("R. 412-10 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _b("11084"),
                const TextSpan(text: " — passage bus quittant arrêt — "),
                _law("R. 412-11 C.R."),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _NotaBox(
                title: "Note",
                bodySpans: [
                  TextSpan(
                    text:
                        "Selon la NATINF : contrôle alcoolémie peut être obligatoire, retraits de points variables, saisie/immobilisation possibles.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative & complicité
          _ConditionCard(
            title: "VI — Tentative & complicité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Tentative : NON (contraventions liées à un comportement constaté).",
              ),
              _BulletPoint(
                text:
                    "Complicité : en pratique NON pour ces obligations personnelles (appréciation au cas par cas selon l’infraction).",
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextSpan _bold(String text) => TextSpan(
    text: text,
    style: const TextStyle(fontWeight: FontWeight.w900),
  );
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
                    : const Color(0xFF1F1F1F).withOpacity(.92),
              ),
            ),
          ),
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
