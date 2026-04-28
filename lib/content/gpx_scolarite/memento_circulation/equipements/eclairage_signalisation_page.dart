import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EclairageSignalisationPage extends StatelessWidget {
  const EclairageSignalisationPage({super.key});

  static const String routeName =
      '/gpx/memento_circulation/equipements/eclairage_signalisation';

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
    final Color cardOblig = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardRem = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardUsage = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
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
            "Éclairage & signalisation",
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
                "Tout véhicule à moteur ou remorque ne peut être équipé que de dispositifs d’éclairage et de signalisation "
                "autorisés, installés conformément au Code de la route, et maintenus en état de fonctionnement. "
                "Les infractions varient selon l’équipement concerné (dispositif absent, non conforme, ou usage irrégulier).",
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
                _lawSpan("R. 313-1 à R. 313-23 du Code de la route"),
                const TextSpan(text: ", "),
                _lawSpan("R. 416-4 à R. 416-20 du Code de la route"),
                const TextSpan(text: ", "),
                _lawSpan("R. 412-10 du Code de la route"),
                const TextSpan(text: " et "),
                _lawSpan("R. 414-4 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Référence conformité dispositifs : "),
                _boldSpan("NATINF 22830"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Dispositifs obligatoires véhicules à moteur
          _ConditionCard(
            title: "II — Dispositifs obligatoires (véhicules à moteur)",
            cardColor: cardOblig,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Obligatoires pour tout véhicule à moteur"),
              const _BulletPoint(
                text:
                    "Feux de croisement (lumière jaune ou blanche) — NATINF 22833.",
              ),
              const _BulletPoint(
                text:
                    "Feux de position arrière (lumière rouge non éblouissante) — NATINF 22835.",
              ),
              const _BulletPoint(
                text:
                    "Catadioptres arrière (rouges, non triangulaires) — NATINF 22844.",
              ),
              const _BulletPoint(
                text: "Feux stop (rouges non éblouissants) — NATINF 22837.",
              ),
              const _BulletPoint(
                text:
                    "Éclairage de la plaque d’immatriculation arrière — NATINF 22840.",
              ),
              const SizedBox(height: 12),
              const _SubTitle(
                "B) Obligatoires pour certains véhicules à moteur",
              ),
              const _BulletPoint(
                text:
                    "Feux de route (jaune/blanc) — NATINF 22832 (tous sauf cyclomoteurs et quadricycles légers à moteur).",
              ),
              const _BulletPoint(
                text:
                    "Feux de position avant (jaune/orange/blanc) — NATINF 22834 (tous sauf cyclomoteurs à 2 roues).",
              ),
              const _BulletPoint(
                text:
                    "Indicateurs de direction (orangés non éblouissants) — NATINF 22842 (tous sauf cyclomoteurs).",
              ),
              const _BulletPoint(
                text:
                    "Signal de détresse — NATINF 22843 (tous sauf motocyclettes, cyclomoteurs, quadricycles légers à moteur).",
              ),
              const _BulletPoint(
                text:
                    "Feu de brouillard arrière — NATINF 22838 (1re MEC à compter du 01/10/1990, sauf moto/tricycles/quad/cyclo).",
              ),
              const _BulletPoint(
                text:
                    "Catadioptres latéraux — NATINF 22846 (véhicules > 6 m, cyclomoteurs, quadricycles à moteur).",
              ),
              const _BulletPoint(
                text:
                    "Triangle de présignalisation — NATINF 26986 (tous sauf moto/cyclo/tricycles/quad non carrossés).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Remorques
          _ConditionCard(
            title: "III — Dispositifs obligatoires (remorques)",
            cardColor: cardRem,
            accent: accentPink,
            titleColor: textMain,
            children: [
              const _SubTitle("A) Équipements arrière principaux"),
              const _BulletPoint(
                text:
                    "Catadioptres arrière rouges triangulaires — NATINF 22844 (non triangulaire possible si groupés avec dispositifs arrière).",
              ),
              const _BulletPoint(
                text: "Feux de position arrière rouges — NATINF 22835.",
              ),
              const _BulletPoint(
                text:
                    "Éclairage de la plaque d’immatriculation — NATINF 22840.",
              ),
              const SizedBox(height: 12),
              const _SubTitle("B) Obligatoires selon PTAC / masquage des feux"),
              const _BulletPoint(
                text:
                    "Feu de brouillard arrière — NATINF 22838 (1re MEC à compter du 01/10/1990).",
              ),
              const _BulletPoint(
                text: "Indicateurs de direction — NATINF 22842.",
              ),
              const _BulletPoint(text: "Signal de détresse — NATINF 22843."),
              const _BulletPoint(text: "Feux stop — NATINF 22837."),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Ces dispositifs concernent notamment : toute remorque de PTAC > 500 kg, "
                        "et les remorques de PTAC ≤ 500 kg lorsque la remorque ou son chargement masque les feux du véhicule tracteur.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Infractions (dispositifs)
          _ConditionCard(
            title: "IV — Infractions (dispositifs)",
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                _boldSpan("NATINF 22830"),
                const TextSpan(
                  text:
                      " — Dispositif d’éclairage/signalisation non réglementaire (véhicule à moteur). Base : ",
                ),
                _lawSpan("R. 313-1 du Code de la route"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Principales absences/non-conformités (AF min. 3e classe) : ",
                ),
              ]),
              const SizedBox(height: 8),
              const _BulletPoint(
                text: "Feux de route — NATINF 22832 (base : R. 313-2).",
              ),
              const _BulletPoint(
                text: "Feux de croisement — NATINF 22833 (base : R. 313-3).",
              ),
              const _BulletPoint(
                text:
                    "Feux de position avant — NATINF 22834 (base : R. 313-4).",
              ),
              const _BulletPoint(
                text:
                    "Feux de position arrière — NATINF 22835 (base : R. 313-5).",
              ),
              const _BulletPoint(
                text: "Feux stop — NATINF 22837 (base : R. 313-7).",
              ),
              const _BulletPoint(
                text:
                    "Feu de brouillard arrière — NATINF 22838 (base : R. 313-9).",
              ),
              const _BulletPoint(
                text:
                    "Éclairage plaque arrière — NATINF 22840 (base : R. 313-12).",
              ),
              const _BulletPoint(
                text:
                    "Indicateurs de direction — NATINF 22842 (base : R. 313-14).",
              ),
              const _BulletPoint(
                text: "Signal de détresse — NATINF 22843 (base : R. 313-17).",
              ),
              const _BulletPoint(
                text: "Catadioptres arrière — NATINF 22844 (base : R. 313-18).",
              ),
              const _BulletPoint(
                text:
                    "Catadioptres latéraux — NATINF 22846 (base : R. 313-19).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                _boldSpan("NATINF 26986"),
                const TextSpan(
                  text: " — Absence de triangle conforme. Base : ",
                ),
                _lawSpan("R. 416-19 du Code de la route"),
                const TextSpan(text: " et "),
                _lawSpan("R. 233-1 du Code de la route"),
                const TextSpan(text: " (AF 1re classe)."),
              ]),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Immobilisation : possible pour NATINF 22830. Pour les autres NATINF, immobilisation possible la nuit, "
                        "ou de jour si la visibilité est insuffisante.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Règles d’utilisation (usage des feux)
          _ConditionCard(
            title: "V — Règles d’utilisation (éclairage & signalisation)",
            cardColor: cardUsage,
            accent: accentAmber,
            titleColor: textMain,
            children: [
              const _SubTitle(
                "A) Usage obligatoire de jour (2 roues motorisés)",
              ),
              const _BulletPoint(
                text:
                    "Motocyclettes (1re MEC après le 01/01/1965), motocyclettes légères (1re MEC à compter du 01/01/1988), cyclomoteurs (1re MEC à compter du 01/07/2004) : feux de croisement ou feux diurnes allumés.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "NATINF : "),
                _boldSpan("238"),
                const TextSpan(text: " (moto) et "),
                _boldSpan("26165"),
                const TextSpan(text: " (cyclomoteur)."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("B) Nuit / visibilité insuffisante"),
              const _BulletPoint(
                text: "Feux rouges arrière allumés — NATINF 22892.",
              ),
              const _BulletPoint(
                text: "Éclairage de plaque arrière allumé — NATINF 22893.",
              ),
              const _BulletPoint(
                text: "Feux de position des remorques allumés — NATINF 22895.",
              ),
              const _BulletPoint(
                text:
                    "Cyclomoteurs et quadricycles légers à moteur : feux de croisement — NATINF 22887.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Autres véhicules : usage des feux de croisement notamment en cas d’éblouissement, en agglomération éclairée, "
                        "hors agglomération sur route éclairée en continu, ou si la visibilité est réduite (NATINF 22888 / 22889).",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Interdiction : circuler sans éclairage/signalisation en lieu dépourvu d’éclairage public — ",
                ),
                _boldSpan("NATINF 11052"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("C) Feux de brouillard"),
              const _BulletPoint(
                text:
                    "Feux avant : peuvent remplacer/compléter les feux de croisement en cas de brouillard, neige ou forte pluie.",
              ),
              const _BulletPoint(
                text:
                    "Feux arrière : uniquement en cas de brouillard ou chute de neige.",
              ),
              _Paragraph.rich([
                const TextSpan(text: "Usage injustifié : "),
                _boldSpan("NATINF 22890"),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 12),
              const _SubTitle("D) Indicateurs de direction"),
              const _BulletPoint(
                text:
                    "Changement de direction / ralentissement : obligation d’avertir — NATINF 217 (base : R. 412-10).",
              ),
              const _BulletPoint(
                text:
                    "Dépassement : avertissement préalable — NATINF 11054 (base : R. 414-4).",
              ),
              const SizedBox(height: 12),
              const _SubTitle("E) Signal de détresse"),
              const _BulletPoint(
                text:
                    "À utiliser pour avertir les autres usagers d’un risque de surprise (allure très réduite, dernier d’une file lente).",
              ),
              _Paragraph.rich([
                const TextSpan(text: "NATINF : "),
                _boldSpan("6290"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Présignalisation immobilisation / chargement
          _ConditionCard(
            title: "VI — Présignalisation (véhicule/chargement immobilisé)",
            cardColor: cardInfra,
            accent: accentGrey,
            titleColor: textMain,
            children: [
              const _Paragraph(
                "Lorsqu’un véhicule immobilisé sur la chaussée constitue un danger (intersections, virages, sommets de côtes, "
                "passages à niveau, visibilité insuffisante), ou lorsqu’un chargement tombe sur la chaussée, le conducteur doit :\n"
                "• utiliser les feux de détresse ;\n"
                "• mettre un triangle de présignalisation (sauf si cela met manifestement sa vie en danger) ;\n"
                "• porter un gilet haute visibilité (rubrique EPI rétroréfléchissant).",
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Absence de présignalisation conforme : "),
                _boldSpan("NATINF 22799"),
                const TextSpan(text: " (base : "),
                _lawSpan("R. 416-19 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
              const SizedBox(height: 8),
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Autoroute (nécessité absolue) : feux de détresse obligatoires — ",
                ),
                _boldSpan("NATINF 7574"),
                const TextSpan(text: " (base : "),
                _lawSpan("R. 421-7 du Code de la route"),
                const TextSpan(text: ")."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // Cycles
          _ConditionCard(
            title: "VII — Cycles (rappel)",
            cardColor: cardOblig,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(
                  text:
                      "Dispositifs obligatoires cycles et règles d’utilisation : ",
                ),
                _lawSpan(
                  "R. 313-1, R. 313-4, R. 313-5, R. 313-18 à R. 313-20, R. 416-10, R. 431-1-1 du Code de la route",
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("A) Catadioptres (toujours)"),
              const _BulletPoint(text: "Arrière rouge — NATINF 22858."),
              const _BulletPoint(text: "Avant blanc — NATINF 22861."),
              const _BulletPoint(
                text:
                    "Latéraux orange (min. 1 roue AV + 1 roue AR) — NATINF 22859.",
              ),
              const _BulletPoint(text: "Pédales orange — NATINF 22860."),
              const SizedBox(height: 12),
              const _SubTitle("B) Nuit / visibilité insuffisante"),
              const _BulletPoint(
                text: "Feu de position avant jaune/blanc — NATINF 22856.",
              ),
              const _BulletPoint(
                text: "Feu de position arrière visible — NATINF 22857.",
              ),
              const _BulletPoint(
                text:
                    "Feux allumés (et remorque le cas échéant) — NATINF 22796.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Port du gilet haute visibilité : obligatoire pour le conducteur et le passager (voir rubrique dédiée).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Dispositif non réglementaire : "),
                _boldSpan("NATINF 22855"),
                const TextSpan(text: "."),
              ]),
            ],
          ),

          const SizedBox(height: 14),

          // EDPM
          _ConditionCard(
            title: "VIII — E.D.P.M. (rappel)",
            cardColor: cardRem,
            accent: accentPink,
            titleColor: textMain,
            children: [
              _Paragraph.rich([
                const TextSpan(text: "Dispositifs obligatoires E.D.P.M. : "),
                _lawSpan(
                  "R. 313-1, R. 313-4, R. 313-5, R. 313-18 à R. 313-20 du Code de la route",
                ),
                const TextSpan(text: "."),
              ]),
              const SizedBox(height: 10),
              const _SubTitle("A) Catadioptres"),
              const _BulletPoint(text: "Arrière rouge — NATINF 33354."),
              const _BulletPoint(text: "Avant blanc — NATINF 33356."),
              const _BulletPoint(text: "Latéraux orange — NATINF 33355."),
              const SizedBox(height: 12),
              const _SubTitle("B) Nuit / visibilité insuffisante"),
              const _BulletPoint(text: "Feu de position avant — NATINF 33352."),
              const _BulletPoint(
                text: "Feu de position arrière — NATINF 33353.",
              ),
              const SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  const TextSpan(
                    text:
                        "Port du gilet haute visibilité : obligatoire pour le conducteur (voir rubrique dédiée).",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _Paragraph.rich([
                const TextSpan(text: "Dispositif non réglementaire : "),
                _boldSpan("NATINF 33348"),
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
