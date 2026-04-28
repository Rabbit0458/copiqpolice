import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AssuranceObligatoirePage extends StatelessWidget {
  const AssuranceObligatoirePage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/controle_routier/assurance_obligatoire';

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
    final Color cardCadre = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardModalites = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardEtranger = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardDelit = isDark
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
          "Contrôle routier",
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
            "L’assurance obligatoire",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Définition
          _ConditionCard(
            title: "Définition",
            cardColor: cardDelit,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Toute personne physique ou morale (autre que l’État) doit être couverte par une assurance responsabilité civile pour faire circuler ",
                ),
                const TextSpan(text: "(y compris stationnement) "),
                const TextSpan(
                  text:
                      "un véhicule terrestre à moteur (immatriculé ou non) ou une remorque. ",
                ),
                const TextSpan(text: "Voir "),
                _boldSpan("NATINF 6163"),
                const TextSpan(text: "."),
              ]),
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
                _lawSpan("L. 211-1 du Code des assurances"),
                const TextSpan(text: ", "),
                _lawSpan("R. 211-14-0 à R. 211-21-6 du Code des assurances"),
                const TextSpan(text: ", "),
                _lawSpan("L. 324-1 du Code de la route"),
                const TextSpan(text: " et "),
                _lawSpan("L. 324-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Véhicules immatriculés (FVA)
          _ConditionCard(
            title: "II — Véhicules à moteur immatriculés",
            cardColor: cardCadre,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Le conducteur d’un véhicule immatriculé est présumé satisfaire à l’obligation d’assurance "
                "lorsqu’il résulte de la consultation du Fichier des Véhicules Assurés (FVA) que le véhicule est couvert.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(text: "L’assureur dispose d’un délai de "),
                  const TextSpan(
                    text: "72 heures",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(
                    text:
                        " à compter de la souscription du contrat pour alimenter le fichier.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("Si la présomption FVA ne peut pas être établie"),
              const _BulletPoint(
                text:
                    "Elle peut l’être par la présentation d’un justificatif d’assurance mentionnant sa durée de validité (15 jours maximum).",
              ),
              const _BulletPoint(
                text:
                    "Le conducteur peut également prouver par tous moyens (auprès des autorités judiciaires) que son véhicule est assuré.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Véhicules non immatriculés (EDPM / cyclomobiles légers)
          _ConditionCard(
            title:
                "III — Véhicules non immatriculés (EDPM & cyclomobiles légers)",
            cardColor: cardModalites,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Pour ces véhicules, les organismes d’assurance doivent délivrer sans frais :\n"
                "• un document justificatif (attestation d’assurance ou attestation provisoire valable 1 mois)\n"
                "• un certificat d’assurance (ou certificat provisoire valable 1 mois).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("A) Attestation d’assurance"),
              const _Paragraph(
                "Ce document doit être présenté lors de tout contrôle des services de police.",
              ),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "La non-présentation ("),
                _boldSpan("NATINF 6168"),
                const TextSpan(
                  text:
                      ") entraîne l’obligation d’en justifier la possession dans les 5 jours "
                      "(délai porté à 12 jours dans le cadre du PVe). ",
                ),
                const TextSpan(text: "Voir "),
                _boldSpan("NATINF 6164"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "En cas de non justification dans les délais, seule la contravention NATINF 6164 est maintenue.",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Certificat d’assurance"),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Un certificat d’assurance en cours de validité doit être apposé sur les véhicules à moteur non immatriculés (voir ",
                ),
                _boldSpan("NATINF 6166"),
                const TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Véhicules étrangers
          _ConditionCard(
            title: "IV — Assurance des véhicules étrangers",
            cardColor: cardEtranger,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _lawSpan("R. 211-14-0"),
                const TextSpan(text: ", "),
                _lawSpan("R. 211-14-1"),
                const TextSpan(text: ", "),
                _lawSpan("R. 211-22"),
                const TextSpan(text: " et "),
                _lawSpan("R. 211-23 du Code des assurances"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _Paragraph(
                "Le conducteur d’un véhicule ayant son stationnement habituel à l’étranger doit être en mesure de produire, "
                "lors d’un contrôle de police ne visant pas exclusivement l’assurance :",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(
                text:
                    "Une carte internationale d’assurance (« carte verte ») en cours de validité.",
              ),
              const _BulletPoint(
                text:
                    "Ou une attestation justifiant la souscription d’une assurance spéciale dite « assurance frontière ».",
              ),
              const SizedBox(height: 8),
              const _Paragraph(
                "À défaut, il doit prouver par tout autre moyen que son véhicule est assuré.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Délit : défaut d’assurance
          _ConditionCard(
            title: "V — Défaut d’assurance (DÉLIT)",
            cardColor: cardDelit,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _boldSpan("NATINF 6163"),
                const TextSpan(
                  text:
                      " — Circulation avec un véhicule terrestre à moteur sans assurance.",
                ),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("Bases légales (constatation / répression)"),
              _Paragraph.rich([
                const TextSpan(text: "Prévu par "),
                _lawSpan("L. 211-1"),
                const TextSpan(text: " et "),
                _lawSpan("L. 211-26 du Code des assurances"),
                const TextSpan(text: ", ainsi que "),
                _lawSpan("L. 324-1"),
                const TextSpan(text: " et "),
                _lawSpan("L. 324-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(text: "Réprimé par "),
                _lawSpan("L. 211-26"),
                const TextSpan(text: ", "),
                _lawSpan("L. 211-27 du Code des assurances"),
                const TextSpan(text: " et "),
                _lawSpan("L. 324-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("Mesures / contrôles associés"),
              const _BulletPoint(
                text: "A.F.D. ou P.V.O. (si cas d’exclusion de l’AFD ou EDPM).",
              ),
              const _BulletPoint(text: "Contrôle alcoolémie : obligatoire."),
              const _BulletPoint(text: "Dépistage stupéfiants : facultatif."),
              const _BulletPoint(text: "Immobilisation possible."),
              _Paragraph.rich([
                const TextSpan(text: "MEF possible avec accord du P.R. (cf "),
                _lawSpan("L. 325-1-1 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 12),
              _NotaBox(
                title: "Attention",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Il s’agit d’un délit qui n’est pas puni d’une peine d’emprisonnement : pas de coercition.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal.",
                  ),
                ],
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
