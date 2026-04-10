import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CeintureRetenueEnfantPage extends StatelessWidget {
  const CeintureRetenueEnfantPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/ceinture_retenue_enfant';

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
            "Ceinture de sécurité & retenue enfant",
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
                "Assurer la sécurité des occupants : port obligatoire de la ceinture homologuée, "
                "règles de transport des mineurs, et usage d’un système de retenue enfant adapté.",
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
                _lawSpan("R. 412-1 du Code de la route"),
                const TextSpan(text: " — "),
                _lawSpan("R. 412-1-1 du Code de la route"),
                const TextSpan(text: " — "),
                _lawSpan("R. 412-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Repères NATINF",
                bodySpans: [
                  _boldSpan("12929"),
                  const TextSpan(text: " (conducteur sans ceinture) • "),
                  _boldSpan("12930"),
                  const TextSpan(text: " (passager sans ceinture) • "),
                  _boldSpan("26813"),
                  const TextSpan(
                    text: " (plusieurs personnes sur un siège) • ",
                  ),
                  _boldSpan("32933"),
                  const TextSpan(text: " (passagers en surnombre) • "),
                  _boldSpan("11065"),
                  const TextSpan(text: " (mineur non retenu) • "),
                  _boldSpan("27193"),
                  const TextSpan(text: " (enfant < 3 ans sans ceinture) • "),
                  _boldSpan("237"),
                  const TextSpan(text: " (enfant < 10 ans à l’avant)."),
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
              const _SubTitle(
                "A) Port de la ceinture (conducteur + passagers)",
              ),
              _Paragraph.rich([
                _lawSpan("R. 412-1 du Code de la route"),
                const TextSpan(
                  text:
                      " : tout conducteur ou passager d’un véhicule à moteur doit porter une ceinture de sécurité homologuée "
                      "(sauf dérogations ou véhicule réceptionné sans être équipé).",
                ),
              ]),
              const SizedBox(height: 10),
              const _BulletPoint(
                text:
                    "Obligation valable pour le conducteur ET les passagers (si véhicule réceptionné avec ceinture).",
              ),
              const _BulletPoint(
                text:
                    "Un siège équipé d’une ceinture ne peut être occupé que par une seule personne.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Références : "),
                _lawSpan("R. 412-1-1 du Code de la route"),
                const TextSpan(text: " (occupation d’un siège) • NATINF "),
                _boldSpan("26813"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("B) Nombre de passagers (places assises)"),
              const _Paragraph(
                "Le nombre de personnes transportées dans le véhicule est limité au nombre de places assises "
                "indiqué sur le certificat d’immatriculation.",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Repère : NATINF "),
                _boldSpan("32933"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle(
                "C) Mineurs : ceinture / système de retenue enfant",
              ),
              _Paragraph.rich([
                _lawSpan("R. 412-2 du Code de la route"),
                const TextSpan(
                  text:
                      " : le conducteur d’un véhicule (≤ 9 places assises, conducteur inclus) doit s’assurer que tout passager mineur "
                      "est maintenu par une ceinture de sécurité, ou par un système homologué de retenue pour enfant lorsque l’enfant "
                      "a moins de 10 ans.",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Mineurs < 10 ans",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Système homologué de retenue adapté à la taille et au poids (sauf exceptions prévues).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Mineurs 10 à 18 ans",
                bodySpans: [
                  const TextSpan(
                    text:
                        "Système homologué de retenue ou ceinture de sécurité.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("D) Enfant < 3 ans & sièges sans ceinture"),
              _Paragraph.rich([
                const TextSpan(text: "Si un siège n’est "),
                _boldSpan("pas équipé"),
                const TextSpan(
                  text:
                      " de ceinture de sécurité, il est interdit d’y transporter un enfant de moins de trois ans.",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Repère : NATINF "),
                _boldSpan("27193"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("E) Transport d’un enfant < 10 ans à l’avant"),
              const _Paragraph(
                "Les enfants de moins de 10 ans ne peuvent être transportés sur un siège avant, sauf exceptions.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Exceptions (avant autorisé)",
                bodySpans: [
                  const TextSpan(text: "• Enfant transporté "),
                  _boldSpan("dos à la route"),
                  const TextSpan(
                    text:
                        " dans un siège homologué et airbag frontal désactivé.\n",
                  ),
                  const TextSpan(
                    text:
                        "• Véhicule sans siège arrière ou siège arrière sans ceinture.\n",
                  ),
                  const TextSpan(
                    text:
                        "• Siège arrière momentanément inutilisable ou déjà occupé par des enfants < 10 ans en retenue.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Repère : NATINF "),
                _boldSpan("237"),
                const TextSpan(text: " — base "),
                _lawSpan("R. 412-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),

              const SizedBox(height: 14),

              const _SubTitle("F) Dérogations (ceinture / retenue enfant)"),
              const _Paragraph(
                "Le port de la ceinture ou l’usage d’un système de retenue peut ne pas être obligatoire dans certains cas "
                "(dérogations prévues par les textes).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Ceinture non obligatoire (exemples)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "• Morphologie manifestement inadaptée.\n"
                        "• Contre-indication médicale avec certificat (durée de validité + symbole d’exemption).\n"
                        "• Occupants de véhicules d’intérêt général prioritaire en intervention urgente (police, gendarmerie, douanes, pompiers, etc.).\n"
                        "• Conducteurs de taxis en service.\n"
                        "• Services publics avec arrêts fréquents en agglomération.\n"
                        "• Livraisons de porte à porte en agglomération.",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "Retenue enfant non obligatoire (dérogations)",
                bodySpans: [
                  const TextSpan(
                    text:
                        "• Enfant dont la taille est adaptée au port de la ceinture.\n"
                        "• Certificat médical d’exemption (durée + symbole).\n"
                        "• Enfant transporté dans un taxi ou un véhicule de transport en commun.",
                  ),
                ],
              ),
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
                "Ces infractions sont généralement constatées par l’absence de port de la ceinture / l’absence de dispositif "
                "de retenue ou le non-respect des règles de transport. La matérialité du manquement suffit en pratique.",
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
                "Aucune circonstance aggravante spécifique n’est mentionnée dans l’extrait du mémento. "
                "En revanche, plusieurs manquements peuvent se cumuler (ex. mineur non retenu + enfant à l’avant + surnombre).",
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
              const _SubTitle("Récapitulatif NATINF (infractions)"),
              _Paragraph.rich([
                _boldSpan("12929"),
                const TextSpan(text: " — Conducteur sans ceinture. Base : "),
                _lawSpan("R. 412-1 du Code de la route"),
                const TextSpan(text: " (4e classe, retrait 3 points)."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("12930"),
                const TextSpan(text: " — Passager sans ceinture. Base : "),
                _lawSpan("R. 412-1 du Code de la route"),
                const TextSpan(text: " (4e classe)."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("26813"),
                const TextSpan(
                  text: " — Plusieurs personnes sur un siège. Base : ",
                ),
                _lawSpan("R. 412-1-1 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("32933"),
                const TextSpan(
                  text: " — Surnombre de passagers (places assises).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("11065"),
                const TextSpan(
                  text:
                      " — Mineur transporté sans ceinture / sans retenue homologuée. Base : ",
                ),
                _lawSpan("R. 412-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("27193"),
                const TextSpan(
                  text:
                      " — Enfant < 3 ans transporté sur un siège sans ceinture. (4e classe).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("237"),
                const TextSpan(
                  text:
                      " — Enfant < 10 ans transporté à l’avant (interdit). Base : ",
                ),
                _lawSpan("R. 412-2 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _NotaBox(
                title: "Mesures & mentions",
                bodySpans: [
                  TextSpan(
                    text:
                        "Le mémento mentionne des contrôles DIA / dépistage stupéfiants facultatifs sur plusieurs NATINF de cette rubrique.",
                  ),
                ],
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
                    "Tentative : NON (contraventions liées à un non-respect constaté).",
              ),
              _BulletPoint(
                text:
                    "Complicité : NON (verbalisation centrée sur l’obligation du conducteur / occupant).",
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
