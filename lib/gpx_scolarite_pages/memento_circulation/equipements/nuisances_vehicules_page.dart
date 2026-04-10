import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NuisancesVehiculesPage extends StatelessWidget {
  const NuisancesVehiculesPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/nuisances';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _lawSpan(String text) => TextSpan(
    text: text,
    style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
  );

  TextSpan _boldSpan(String text) => TextSpan(
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
          "Équipements",
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
            "Les nuisances causées par les véhicules",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Objectif",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Encadrer et sanctionner les nuisances causées par les véhicules (pollution, bruits, usage abusif du klaxon) "
                "lorsqu’elles compromettent la santé, la sécurité publiques ou gênent les usagers et riverains.",
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
                _lawSpan("R. 318-1 du Code de la route"),
                const TextSpan(text: " (fumées / gaz) — "),
                _lawSpan("R. 318-3 du Code de la route"),
                const TextSpan(text: " (bruits) — "),
                _lawSpan("R. 416-1 du Code de la route"),
                const TextSpan(text: " & "),
                _lawSpan("R. 416-2 du Code de la route"),
                const TextSpan(text: " (avertisseur sonore)."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Repères NATINF",
                bodySpans: [
                  _boldSpan("9920"),
                  const TextSpan(text: " (émissions polluantes) • "),
                  _boldSpan("22656"),
                  const TextSpan(text: " (échappement libre) • "),
                  _boldSpan("22657"),
                  const TextSpan(text: " (échappement interrompable) • "),
                  _boldSpan("22658"),
                  const TextSpan(
                    text: " (échappement modifié / mauvais état) • ",
                  ),
                  _boldSpan("6126"),
                  const TextSpan(text: " (bruits gênants) • "),
                  _boldSpan("22882"),
                  const TextSpan(text: " (klaxon abusif jour) • "),
                  _boldSpan("22883"),
                  const TextSpan(text: " (klaxon nuit)."),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Élément matériel",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Émissions de fumées / gaz toxiques"),
              _Paragraph.rich([
                _lawSpan("R. 318-1 du Code de la route"),
                const TextSpan(
                  text:
                      " : les véhicules automobiles (sauf 2 roues motorisés, tricycles et quadricycles à moteur) "
                      "ne doivent pas émettre de fumées, gaz toxiques, corrosifs ou odorants dans des conditions susceptibles "
                      "d’incommoder la population ou de compromettre la santé et la sécurité publiques.",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Diesel : fumées non odorantes, non teintées, non opaques (tolérance au démarrage à froid et lors des changements de régime).",
              ),
              const _BulletPoint(
                text:
                    "Constat possible « de visu » si fumées nettement teintées/opaques en régime continu (contestation possible).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Essence (cas particulier)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Si le propriétaire a fait régler le moteur depuis moins d’un an, le véhicule ne peut pas être verbalisé "
                        "si le conducteur présente un justificatif (ex. PV de visite technique) et qu’un nouveau réglage antipollution "
                        "est effectué dans les 30 jours.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Présentation à un service de contrôle"),
              const _Paragraph(
                "Lorsqu’une infraction est constatée, l’agent verbalisateur peut soit autoriser la conduite vers un établissement "
                "de réparation (avec immobilisation possible + fiche de circulation provisoire), soit prescrire une présentation "
                "à la brigade de contrôle technique selon des délais fixés (diesel / essence).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence : "),
                _boldSpan("NATINF 6210"),
                const TextSpan(text: ", "),
                _boldSpan("21937"),
                const TextSpan(text: ", "),
                _boldSpan("21938"),
                const TextSpan(text: " (refus de présenter le véhicule)."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("C) Émissions de bruits gênants"),
              _Paragraph.rich([
                _lawSpan("R. 318-3 du Code de la route"),
                const TextSpan(
                  text:
                      " : les véhicules automobiles ne doivent pas émettre de bruits susceptibles de causer une gêne "
                      "aux usagers de la route ou aux riverains.",
                ),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Deux situations pratiques sont distinguées :\n"
                "• Origine du bruit déterminable : infraction relevée + immobilisation possible avec circulation vers réparation.\n"
                "• Origine non décelable : pas de verbalisation immédiate, mais présentation à la BCT pour contrôle au sonomètre.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Origines typiques",
                bodySpans: [
                  _boldSpan("Échappement libre"),
                  const TextSpan(text: " (dispositif absent) — "),
                  _boldSpan("mauvais état / modification"),
                  const TextSpan(text: " — "),
                  _boldSpan("dispositif interrompable"),
                  const TextSpan(text: "."),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Repères NATINF : "),
                _boldSpan("22656"),
                const TextSpan(text: " (échappement libre), "),
                _boldSpan("22658"),
                const TextSpan(text: " (mauvais état/modifié), "),
                _boldSpan("22657"),
                const TextSpan(text: " (interrompable), "),
                _boldSpan("6126"),
                const TextSpan(text: " (bruits gênants)."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("D) Usage intempestif de l’avertisseur sonore"),
              _Paragraph.rich([
                _lawSpan("R. 416-1 du Code de la route"),
                const TextSpan(
                  text:
                      " : l’avertisseur sonore ne peut être utilisé (de jour) que pour donner les avertissements nécessaires (hors agglomération) "
                      "ou en cas de danger immédiat (en agglomération).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _lawSpan("R. 416-2 du Code de la route"),
                const TextSpan(
                  text:
                      " : de nuit, l’avertisseur sonore ne peut être utilisé qu’en cas d’absolue nécessité.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Repères NATINF : "),
                _boldSpan("22882"),
                const TextSpan(text: " (jour) • "),
                _boldSpan("22883"),
                const TextSpan(text: " (nuit)."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Élément moral",
            cardColor: cardMoral,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Ces infractions relèvent en pratique de la constatation de comportements/états du véhicule "
                "(pollution visible/odorante, bruit gênant, usage injustifié du klaxon). "
                "La matérialité du fait suffit généralement à caractériser l’infraction.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Circonstances aggravantes",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Aucune circonstance aggravante spécifique n’est mentionnée dans l’extrait du mémento pour ces nuisances. "
                "En revanche, des mesures de procédure (immobilisation, présentation BCT, PVO) peuvent s’appliquer selon les cas.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Répression",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("Tableau récapitulatif (NATINF)"),
              _Paragraph.rich([
                _boldSpan("9920"),
                const TextSpan(
                  text: " — Émission de fumées / gaz toxiques. Base : ",
                ),
                _lawSpan("R. 318-1 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22656"),
                const TextSpan(text: " — Échappement libre. Base : "),
                _lawSpan("R. 318-3 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22657"),
                const TextSpan(
                  text: " — Dispositif d’échappement interrompable. Base : ",
                ),
                _lawSpan("R. 318-3 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22658"),
                const TextSpan(
                  text:
                      " — Dispositif d’échappement modifié / non entretenu. Base : ",
                ),
                _lawSpan("R. 318-3 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("6126"),
                const TextSpan(text: " — Bruits gênants. Base : "),
                _lawSpan("R. 318-3 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _boldSpan("6210"),
                const TextSpan(text: ", "),
                _boldSpan("21937"),
                const TextSpan(text: ", "),
                _boldSpan("21938"),
                const TextSpan(
                  text:
                      " — Refus de présenter le véhicule à un service de contrôle (niveau sonore / émissions). Base : ",
                ),
                _lawSpan("R. 325-8 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _boldSpan("22882"),
                const TextSpan(
                  text:
                      " — Usage abusif (jour) de l’avertisseur sonore. Base : ",
                ),
                _lawSpan("R. 416-1 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("22883"),
                const TextSpan(
                  text: " — Usage (nuit) de l’avertisseur sonore. Base : ",
                ),
                _lawSpan("R. 416-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("Mesures & mentions (selon mémento)"),
              const _BulletPoint(
                text:
                    "Plusieurs NATINF indiquent : D.I.A. / dépistage stupéfiants facultatifs.",
              ),
              const _BulletPoint(
                text:
                    "Immobilisation : mentionnée pour certaines contraventions (pollution/bruit).",
              ),
              const _BulletPoint(
                text:
                    "P.V.O. : mentionné pour le refus de présentation (5e classe).",
              ),
              const _BulletPoint(
                text:
                    "Usage abusif du klaxon : contravention (minimum 2e classe).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "VI — Tentative & complicité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _BulletPoint(
                text:
                    "Tentative : NON (non applicable pour ces contraventions liées à un état/usage constaté).",
              ),
              _BulletPoint(
                text:
                    "Complicité : NON (pas pertinente ici, verbalisation centrée sur le conducteur / le véhicule).",
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
