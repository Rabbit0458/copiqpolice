import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChargementPage extends StatelessWidget {
  const ChargementPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/chargement';

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
    final Color cardRules = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardLimits = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardInfra = isDark
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
            "Chargement des véhicules",
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
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le chargement d’un véhicule ne doit pas être une cause de dommage ou de danger. "
                "Les précautions utiles doivent être prises afin d’éviter tout débordement, chute, oscillation dangereuse "
                "ou accessoire traînant sur la chaussée.",
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
                _lawSpan("R. 312-19 à R. 312-22 du Code de la route"),
                const TextSpan(
                  text:
                      " : règles générales relatives au chargement des véhicules et aux limites autorisées (sécurisation, dimensions, débords).",
                ),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Règles essentielles (sécurisation)
          _ConditionCard(
            title: "II — Règles essentielles de sécurité",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Amarrage obligatoire"),
              const _BulletPoint(
                text:
                    "Tout chargement débordant (ou pouvant déborder à cause des oscillations) doit être solidement amarré — NATINF 22595.",
              ),
              const _BulletPoint(
                text:
                    "Les pièces de grande longueur doivent être solidement amarrées entre elles et au véhicule, afin de ne pas déborder latéralement lors des oscillations — NATINF 22595.",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "B) Accessoires (chaînes, bâches, éléments flottants)",
              ),
              const _BulletPoint(
                text:
                    "Les chaînes, bâches et autres accessoires mobiles ou flottants doivent être fixés de façon à ne jamais sortir du contour extérieur du chargement et à ne pas traîner au sol — NATINF 22596.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "En pratique : un accessoire qui bat au vent, dépasse le gabarit ou frotte le sol = non conforme.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Dimensions / débords
          _ConditionCard(
            title: "III — Largeur & longueur maximales",
            cardColor: cardLimits,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Rappel"),
              const _Paragraph(
                "Hors cas particuliers (ex. transports exceptionnels), le chargement doit respecter des limites strictes "
                "de largeur et de débordement.",
              ),
              const SizedBox(height: 10),
              const _SubTitle("B) Largeur maximale"),
              const _BulletPoint(text: "Largeur maximale : 2,55 m."),
              _Paragraph.rich([
                const TextSpan(text: "Références NATINF : "),
                _boldSpan("22597"),
                const TextSpan(text: " (dépassement ≤ 20%) et "),
                _boldSpan("22598"),
                const TextSpan(text: " (dépassement > 20%)."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("C) Longueur / débords"),
              const _BulletPoint(
                text:
                    "Vers l’avant : le chargement ne doit pas dépasser l’aplomb antérieur du véhicule — NATINF 22599.",
              ),
              const _BulletPoint(
                text:
                    "Vers l’arrière : le chargement ne doit pas dépasser de plus de 3 mètres l’extrémité du véhicule ou de la remorque — NATINF 22601 / 22602.",
              ),
              const _BulletPoint(
                text:
                    "Le chargement ne doit pas traîner sur le sol — NATINF 22600.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions (avec bases légales + pédagogique)
          _ConditionCard(
            title: "IV — Infractions (NATINF) & points clés",
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Sécurisation / accessoires"),
              _Paragraph.rich([
                _boldSpan("NATINF 22595"),
                const TextSpan(
                  text:
                      " — Absence d’amarrage (chargement débordant / grande longueur). Base : ",
                ),
                _lawSpan("R. 312-19 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 22596"),
                const TextSpan(
                  text:
                      " — Absence de fixation des chaînes, bâches et accessoires. Base : ",
                ),
                _lawSpan("R. 312-20 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Largeur excessive"),
              _Paragraph.rich([
                _boldSpan("NATINF 22597"),
                const TextSpan(
                  text:
                      " — Largeur du chargement dépassant le maximum réglementaire (dépassement ≤ 20%).",
                ),
              ]),
              const SizedBox(height: 6),
              _Paragraph.rich([
                _boldSpan("NATINF 22598"),
                const TextSpan(
                  text:
                      " — Largeur du chargement dépassant le maximum réglementaire (dépassement > 20%).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "À noter : NATINF 22598 relève d’une procédure plus sévère (PVO 5e classe).",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle(
                "C) Débord avant / arrière / chargement traînant",
              ),
              _Paragraph.rich([
                _boldSpan("NATINF 22599"),
                const TextSpan(
                  text: " — Chargement dépassant l’aplomb antérieur. Base : ",
                ),
                _lawSpan("R. 312-22 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 22600"),
                const TextSpan(text: " — Chargement traînant sur le sol."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 22601"),
                const TextSpan(
                  text:
                      " — Dépassement arrière > 3 m (dépassement ≤ 20%). Base : ",
                ),
                _lawSpan("R. 312-21 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 22602"),
                const TextSpan(
                  text: " — Dépassement arrière > 3 m (dépassement > 20%).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Beaucoup de ces infractions peuvent entraîner une immobilisation (selon situation de danger).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Réflexe PV / précision
          _ConditionCard(
            title: "V — Réflexes rédactionnels (P.V.)",
            cardColor: cardRules,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Pour un dossier propre et exploitable, pense à décrire précisément le chargement, "
                "la nature du débordement, et la manière dont il est (ou n’est pas) sécurisé.",
              ),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Décrire : type de chargement, localisation (avant/arrière/latéral), risque (oscillation, chute, traînage).",
              ),
              const _BulletPoint(
                text:
                    "Préciser : dépassement estimé (mètres / pourcentage) lorsque c’est utile (largeur / débord arrière).",
              ),
              const _BulletPoint(
                text:
                    "Mentionner : accessoires flottants (bâche, sangle, chaîne) et effets observés (traîne au sol, dépasse le gabarit).",
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
