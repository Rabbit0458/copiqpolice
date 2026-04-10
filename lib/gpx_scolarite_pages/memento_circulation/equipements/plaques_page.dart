import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaquesPage extends StatelessWidget {
  const PlaquesPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/plaques';

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
            "Plaques (constructeur, tare, immatriculation)",
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
                "Les plaques (constructeur, tare et immatriculation) permettent l’identification du véhicule "
                "et la vérification de sa conformité. Leur absence, leur non-conformité ou leur falsification "
                "peut entraîner des contraventions, voire des délits.",
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
                _lawSpan("R. 317-8 à R. 317-11 du Code de la route"),
                const TextSpan(
                  text:
                      " : obligations relatives aux plaques (immatriculation, plaque constructeur, plaque de tare…).",
                ),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Délits relatifs aux plaques : "),
                _lawSpan("L. 317-2"),
                const TextSpan(text: ", "),
                _lawSpan("L. 317-3"),
                const TextSpan(text: ", "),
                _lawSpan("L. 317-4"),
                const TextSpan(text: " et "),
                _lawSpan("L. 317-4-1 du Code de la route"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Élément matériel — obligations
          _ConditionCard(
            title: "II — Élément matériel (obligations)",
            cardColor: cardMat,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Plaque du constructeur"),
              const _Paragraph(
                "Tout véhicule à moteur, toute remorque ou semi-remorque agricole doit être muni d’une plaque du constructeur.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Nom ou marque du constructeur."),
              const _BulletPoint(text: "Type du véhicule."),
              const _BulletPoint(
                text:
                    "Numéro d’identification du véhicule (V.I.N.) — inscrit aussi à la rubrique E du certificat d’immatriculation.",
              ),
              const _BulletPoint(
                text:
                    "Informations techniques (ex. poids, niveau sonore à l’arrêt pour les motocyclettes…).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Le numéro V.I.N. est également frappé à froid sur un élément indémontable du véhicule, à un endroit accessible (ex. cadre moto).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotaBox(
                title: "ASTUCE",
                bodySpans: [
                  const TextSpan(
                    text:
                        "L’application EUVID (via CHEOPS NG) permet d’identifier l’emplacement de la plaque constructeur et du V.I.N. sur de nombreux modèles.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Plaque de tare (chargement / encombrement)"),
              const _Paragraph(
                "Obligatoire pour tout véhicule à moteur de P.T.A.C. > 3,5 t et toute remorque de P.T.A.C. > 3,5 t.",
              ),
              const SizedBox(height: 8),
              const _BulletPoint(text: "Poids à vide (P.V.)."),
              const _BulletPoint(
                text: "Poids total autorisé en charge (P.T.A.C.).",
              ),
              const _BulletPoint(
                text: "Poids total roulant autorisé (P.T.R.A.).",
              ),
              const _BulletPoint(
                text: "Longueur (L), largeur (l), surface (S).",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "La plaque de tare doit être fixée en évidence pour un observateur placé à droite.",
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const _SubTitle("C) Plaque d’immatriculation (règles générales)"),
              const _BulletPoint(
                text:
                    "Tout véhicule à moteur (sauf matériels de travaux publics) doit porter 1 ou 2 plaques d’immatriculation.",
              ),
              const _BulletPoint(
                text:
                    "Remorques de PTAC > 500 kg et semi-remorques : plaque d’immatriculation obligatoire.",
              ),
              const _BulletPoint(
                text:
                    "Remorques de PTAC ≤ 500 kg : plaque reproduisant le numéro du véhicule tracteur (sauf cas particuliers).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Chaque plaque doit reproduire le numéro inscrit sur le certificat d’immatriculation. ",
                ),
                _boldSpan(
                  "Toute discordance peut faire basculer sur un délit.",
                ),
              ]),
              const SizedBox(height: 12),

              const _SubTitle(
                "D) Plaques “série normale” (SIV) — points visibles",
              ),
              const _BulletPoint(
                text:
                    "Numéro au format AA-111-AA (tiret entre blocs), sur 1 ou 2 lignes.",
              ),
              const _BulletPoint(
                text:
                    "Caractères noirs non rétro-réfléchissants sur fond blanc rétro-réfléchissant.",
              ),
              const _BulletPoint(
                text:
                    "Symbole européen + lettre F sur fond bleu rétro-réfléchissant.",
              ),
              const _BulletPoint(
                text:
                    "Identifiant territorial : logo de région + numéro de département.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("E) Conditions de conformité"),
              const _BulletPoint(
                text:
                    "Conformes aux modèles réglementaires (dimensions, caractères, couleur).",
              ),
              const _BulletPoint(
                text:
                    "En état d’entretien permettant la lecture (plaque lisible).",
              ),
              const _BulletPoint(
                text:
                    "Fixées de manière inamovible (sauf plaque de remorque reproduisant le numéro du tracteur).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Contraventions (infractions “matérielles”)
          _ConditionCard(
            title: "III — Contraventions (contrôles terrain)",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Plaque constructeur / tare"),
              _Paragraph.rich([
                _boldSpan("NATINF 22628"),
                const TextSpan(
                  text: " — Plaque constructeur non conforme. Base : ",
                ),
                _lawSpan("R. 317-9 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 7541"),
                const TextSpan(
                  text:
                      " — Véhicule/remorque PTAC > 3,5 t sans inscription conforme (poids, longueur, largeur, surface). Base : ",
                ),
                _lawSpan("R. 317-11 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("B) Plaque d’immatriculation — contraventions"),
              _Paragraph.rich([
                _boldSpan("NATINF 24030"),
                const TextSpan(
                  text: " — Plaque d’immatriculation non conforme. Base : ",
                ),
                _lawSpan("R. 317-8 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 24028"),
                const TextSpan(text: " — Plaque illisible. Base : "),
                _lawSpan("R. 317-8 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 24029"),
                const TextSpan(text: " — Plaque amovible. Base : "),
                _lawSpan("R. 317-8 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 7542"),
                const TextSpan(
                  text:
                      " — Véhicule/remorque non muni de plaque d’immatriculation visible (absence de plaque visible).",
                ),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Selon la situation, une immobilisation peut être envisagée (notamment absence de plaque visible / plaque non conforme).",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Délits (avec élément moral)
          _ConditionCard(
            title: "IV — Délits relatifs aux plaques",
            cardColor: cardAggr,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Attention : la qualification change tout. Dès qu’il y a falsification, usurpation ou usage volontaire d’une plaque mensongère, "
                "on n’est plus dans la simple contravention.",
              ),
              const SizedBox(height: 10),

              const _SubTitle("A) Typologie (mémo clair)"),
              const _BulletPoint(
                text:
                    "Défaut de plaque (simple) : contravention 4e classe — NATINF 7542.",
              ),
              const _BulletPoint(
                text:
                    "Usage de fausse plaque / fausse inscription : délit — NATINF 48.",
              ),
              const _BulletPoint(text: "Plaque inexacte : délit — NATINF 45."),
              const _BulletPoint(
                text:
                    "Fausse déclaration (propriétaire / identité) sur véhicule circulant sans plaque : délit — NATINF 49.",
              ),
              const _BulletPoint(
                text:
                    "Usurpation de plaque (numéro attribué à un autre véhicule) : délit — NATINF 25123.",
              ),
              const SizedBox(height: 12),

              const _SubTitle("B) Base légale (à citer en procédure)"),
              _Paragraph.rich([
                _boldSpan("NATINF 48"),
                const TextSpan(text: " — "),
                _lawSpan("L. 317-2 du Code de la route"),
                const TextSpan(
                  text: " (usage de fausse plaque / fausse inscription).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 49"),
                const TextSpan(text: " — "),
                _lawSpan("L. 317-3 du Code de la route"),
                const TextSpan(
                  text:
                      " (fausse déclaration sur propriétaire, véhicule circulant sans plaque).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 45"),
                const TextSpan(text: " — "),
                _lawSpan("L. 317-4 du Code de la route"),
                const TextSpan(
                  text:
                      " (mise en circulation avec plaque / inscription inexacte).",
                ),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                _boldSpan("NATINF 25123"),
                const TextSpan(text: " — "),
                _lawSpan("L. 317-4-1 du Code de la route"),
                const TextSpan(text: " (usurpation de plaque)."),
              ]),
              const SizedBox(height: 12),

              const _SubTitle("C) Élément moral (intention)"),
              _ConditionCard(
                title: "Point clé",
                cardColor: cardMoral,
                accent: accentPink,
                titleColor: textMain,
                children: [
                  const _Paragraph(
                    "Les délits impliquent une dimension volontaire : utilisation d’une plaque fausse/inexacte, "
                    "ou usage d’un numéro attribué à un autre véhicule, typiquement avec une volonté d’induire en erreur "
                    "ou d’échapper à des poursuites (ex. radars automatiques).",
                  ),
                  const SizedBox(height: 10),
                  _NotaBox(
                    bodySpans: [
                      const TextSpan(
                        text:
                            "Important : les A.P.J.A. ne sont pas habilités à constater les délits par procès-verbal (selon ton mémento).",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tentative/complicité (demande utilisateur)
          _ConditionCard(
            title: "V — Tentative & complicité",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _BulletPoint(
                text:
                    "Tentative : NON (non expressément prévue ici : les textes visent des actes consommés comme la mise en circulation / l’usage).",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Complicité : OUI, conformément à "),
                _lawSpan("l’article 121-6 du Code pénal"),
                const TextSpan(text: " et "),
                _lawSpan("l’article 121-7 du Code pénal"),
                const TextSpan(text: "."),
              ]),
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
