import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaArmesClassificationPage extends StatelessWidget {
  const PaArmesClassificationPage({super.key});

  static const String routeName =
      '/pa/dps_dpg/armes_munitions_pages/armes_classification';

  static const Color _lawRed = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardA = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardB = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardC = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardD = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);

    final Color accentBlue = isDark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF1565C0);
    final Color accentPink = isDark
        ? const Color(0xFFF48FB1)
        : const Color(0xFFC2185B);
    final Color accentGreen = isDark
        ? const Color(0xFF66BB6A)
        : const Color(0xFF2E7D32);
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
          "Armes & munitions",
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
            "Classification des armes et des munitions",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Élément légal en haut
          _ConditionCard(
            title: "Élément légal (texte de référence)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph.rich([
                TextSpan(
                  text: "Article R. 311-2 du C.S.I.",
                  style: TextStyle(
                    color: _lawRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text:
                      " : fixe la classification des armes et munitions en catégories A, B, C et D.",
                ),
              ]),
              SizedBox(height: 10),
              _Paragraph(
                "Cette classification organise le régime juridique (interdiction, autorisation, déclaration ou liberté "
                "d’acquisition/détention) selon la dangerosité et l’usage des armes/munitions.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Intro pédagogique
          _ConditionCard(
            title: "Repères rapides",
            cardColor: cardD,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _IntroBullet(
                text:
                    "Catégorie A : matériels de guerre / armes interdites à l’acquisition et à la détention (A1/A2).",
              ),
              _IntroBullet(
                text:
                    "Catégorie B : armes soumises à autorisation (principalement armes de poing et certaines armes d’épaule).",
              ),
              _IntroBullet(
                text:
                    "Catégorie C : armes soumises à déclaration (certaines armes d’épaule, munitions/éléments associés).",
              ),
              _IntroBullet(
                text:
                    "Catégorie D : acquisition et détention libres (armes/objets listés, sous conditions selon cas).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // I - Catégorie A
          _ConditionCard(
            title: "I — Catégorie A (interdiction)",
            cardColor: cardA,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La catégorie A regroupe les matériels de guerre et les armes interdits à l’acquisition et à la détention. "
                "Elle se subdivise en A1 et A2.",
              ),
              SizedBox(height: 12),

              _SubTitle("A) Catégorie A1"),
              _Paragraph(
                "Armes et éléments d’armes interdits, ainsi que certains systèmes d’alimentation et munitions.",
              ),
              SizedBox(height: 10),

              _SubTitle("Points clés (A1)"),
              _BulletPoint(
                text: "Armes à feu camouflées sous la forme d’un autre objet.",
              ),
              _BulletPoint(
                text:
                    "Armes de poing tirant plus de 21 munitions sans réapprovisionnement (avec chargeur > 20 intégré ou inséré).",
              ),
              _BulletPoint(
                text:
                    "Armes d’épaule semi-auto : annulaire (> 31 coups) ou centrale (> 11 coups) selon chargeur intégré/inséré.",
              ),
              _BulletPoint(
                text:
                    "Armes d’épaule alimentées par bande (quelle qu’en soit la capacité).",
              ),
              _BulletPoint(
                text:
                    "Armes à canon rayé + munitions si projectile ≥ 20 mm (sauf projectiles non métalliques exclusivement).",
              ),
              _BulletPoint(
                text:
                    "Armes à canon lisse + munitions de calibre supérieur au calibre 8 (exceptions selon arrêtés).",
              ),
              _BulletPoint(
                text:
                    "Munitions dont le projectile ≥ 20 mm (sauf celles utilisées par armes classées en catégorie C).",
              ),
              _BulletPoint(
                text:
                    "Éléments d’armes/munitions + systèmes d’alimentation : poing > 20, épaule annulaire > 30, épaule centrale > 10, répétition manuelle centrale > 30.",
              ),
              SizedBox(height: 12),

              _SubTitle("B) Catégorie A2"),
              _Paragraph(
                "Matériels de guerre, équipements destinés au combat, certaines munitions et matériels spécialisés.",
              ),
              SizedBox(height: 10),

              _SubTitle("Points clés (A2)"),
              _BulletPoint(
                text:
                    "Armes automatiques et dispositifs permettant le tir en rafale (ou assimilé).",
              ),
              _BulletPoint(
                text:
                    "Munitions à projectiles perforants, explosifs ou incendiaires.",
              ),
              _BulletPoint(
                text:
                    "Armes à effets laser/ondes électromagnétiques de grande puissance.",
              ),
              _BulletPoint(
                text:
                    "Canons, obusiers, mortiers, lance-roquettes, lance-grenades et équipements associés.",
              ),
              _BulletPoint(
                text:
                    "Bombes, torpilles, mines, missiles, grenades, engins incendiaires, leurres, équipements de lancement/largage.",
              ),
              _BulletPoint(
                text:
                    "Engins nucléaires explosifs + composants spécifiques + matériels/logiciels spécialisés.",
              ),
              _BulletPoint(
                text:
                    "Véhicules de combat, aéronefs militaires (pilotés ou non), navires de guerre et éléments associés.",
              ),
              _BulletPoint(
                text:
                    "Matériels de transmission/télécommunication militaires, contre-mesures électroniques, moyens de cryptologie.",
              ),
              _BulletPoint(
                text:
                    "Matériels d’observation/visée, vision nocturne, conduite de tir, détection/brouillage, protection NBC/radiologique.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // II - Catégorie B
          _ConditionCard(
            title: "II — Catégorie B (autorisation)",
            cardColor: cardB,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La catégorie B regroupe les armes soumises à autorisation pour l’acquisition et la détention.",
              ),
              SizedBox(height: 12),

              _SubTitle("Principaux ensembles"),
              _BulletPoint(
                text:
                    "B 1° : armes à feu de poing (et armes converties en armes de poing non classées ailleurs).",
              ),
              _BulletPoint(
                text:
                    "B 2° : armes à feu d’épaule (semi-auto centrale/annulaire selon capacités, longueurs, apparence, pompe…).",
              ),
              _BulletPoint(
                text:
                    "B 4° : armes chambrant certains calibres (ex. 7,62x39 ; 5,56x45 ; 5,45x39 ; 12,7x99 ; 14,5x114) + munitions, douilles.",
              ),
              _BulletPoint(
                text:
                    "B 6° / B 7° : armes à impulsion électrique (distance / contact) selon classement par arrêté.",
              ),
              _BulletPoint(
                text:
                    "B 8° : générateurs d’aérosols incapacitants/lacrymogènes > 100 ml (ou classés par arrêté).",
              ),
              _BulletPoint(
                text:
                    "B 10° / B 11° : certaines munitions à percussion centrale + systèmes d’alimentation des armes de catégorie B.",
              ),
              _BulletPoint(
                text:
                    "B 12° : armes à répétition manuelle avec mécanisme transportant la munition par action sur la détente (définition légale).",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // III - Catégorie C
          _ConditionCard(
            title: "III — Catégorie C (déclaration)",
            cardColor: cardC,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La catégorie C concerne les armes soumises à déclaration : principalement certaines armes d’épaule, "
                "leurs éléments, et certaines munitions/éléments associés.",
              ),
              SizedBox(height: 12),

              _SubTitle("Points clés"),
              _BulletPoint(
                text:
                    "C 1° : armes à feu d’épaule (semi-auto limitée à 3 coups, répétition manuelle limitée à 11 coups, un coup par canon, pompe à canon rayé sous conditions…).",
              ),
              _BulletPoint(text: "C 2° : éléments de ces armes."),
              _BulletPoint(
                text:
                    "C 4° : armes/lanceurs non pyrotechniques avec énergie à la bouche ≥ 20 joules.",
              ),
              _BulletPoint(
                text:
                    "C 6° à C 8° : munitions/éléments classés selon modalités prévues, y compris arrêtés conjoints.",
              ),
              _BulletPoint(
                text:
                    "C 9° : armes neutralisées selon modalités fixées par arrêté.",
              ),
              _BulletPoint(
                text:
                    "C 10° : systèmes d’alimentation des armes de catégorie C.",
              ),
              _BulletPoint(
                text: "C 12° : armes d’alarme et de signalisation.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // IV - Catégorie D
          _ConditionCard(
            title: "IV — Catégorie D (libre acquisition/détention)",
            cardColor: cardD,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "La catégorie D regroupe des armes et matériels dont l’acquisition et la détention sont libres, "
                "dans les conditions fixées par les textes (et selon certains arrêtés).",
              ),
              SizedBox(height: 12),

              _SubTitle("Exemples et ensembles"),
              _BulletPoint(
                text:
                    "Objets susceptibles de constituer une arme dangereuse (armes non à feu camouflées, poignards, matraques… selon arrêtés).",
              ),
              _BulletPoint(
                text:
                    "Aérosols lacrymogènes/incapacitants ≤ 100 ml (sauf reclassement par arrêté).",
              ),
              _BulletPoint(
                text:
                    "Armes à impulsions électriques de contact (sauf reclassement par arrêté).",
              ),
              _BulletPoint(
                text:
                    "Armes historiques et de collection (modèle antérieur au 1er janvier 1900) et certaines reproductions (conditions techniques/arrêtés).",
              ),
              _BulletPoint(
                text:
                    "Armes/lanceurs non pyrotechniques : énergie à la bouche entre 2 et 20 joules.",
              ),
              _BulletPoint(
                text:
                    "Certaines munitions et éléments (poudre noire, sans étui métallique, fabrications anciennes…), selon listes et conditions.",
              ),
              _BulletPoint(
                text:
                    "Certains matériels de guerre selon modèle et neutralisation (avant/après 1946), selon arrêtés.",
              ),
              SizedBox(height: 12),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "La classification exacte dépend parfois d’arrêtés conjoints (Intérieur, Défense, Douanes, Industrie). "
                        "En pratique, on vérifie toujours la catégorie précise dans les textes applicables.",
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
          border: Border.all(color: accent.withValues(alpha: .22), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
        : const Color(0xFF1F1F1F).withValues(alpha: .92);

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
                    : const Color(0xFF1F1F1F).withValues(alpha: .92),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotaBox extends StatelessWidget {
  const _NotaBox({required this.bodySpans});

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
        color: bgColor.withValues(alpha: isDark ? .7 : .95),
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
                : const Color(0xFF3E2723).withValues(alpha: .95),
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
