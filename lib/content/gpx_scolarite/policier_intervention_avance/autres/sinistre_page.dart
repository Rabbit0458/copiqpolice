import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SinistrePage extends StatelessWidget {
  const SinistrePage({super.key});

  static const String routeName = '/gpx/intervention/autres/sinistre';

  static const Color _lawRed = Color(0xFFE53935);

  TextSpan _law(String text) {
    return const TextSpan(); // placeholder to satisfy analyzer in unused contexts
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg = isDark ? const Color(0xFF373737) : const Color(0xFFFFFFFF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF050505);

    // Palette cards (propre + lisible)
    final Color cardDef = isDark
        ? const Color(0xFF222224)
        : const Color(0xFFF7F7F7);
    final Color cardLegal = isDark
        ? const Color(0xFF1F2733)
        : const Color(0xFFF2F6FF);
    final Color cardAnalyse = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardSecours = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardPerimetre = isDark
        ? const Color(0xFF2C2417)
        : const Color(0xFFFFF8E1);
    final Color cardTraces = isDark
        ? const Color(0xFF1F2B34)
        : const Color(0xFFEFF7FF);
    final Color cardConstat = isDark
        ? const Color(0xFF26201A)
        : const Color(0xFFFFF3E0);

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
    final Color accentOrange = isDark
        ? const Color(0xFFFFB74D)
        : const Color(0xFFEF6C00);
    final Color accentGrey = isDark ? Colors.white70 : const Color(0xFF616161);

    TextSpan lawSpan(String label) {
      return TextSpan(
        text: label,
        style: const TextStyle(color: _lawRed, fontWeight: FontWeight.w900),
      );
    }

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
          "Intervention — Autres",
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
            "Intervention sur les lieux d’un sinistre",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          _ConditionCard(
            title: "Contexte",
            cardColor: cardDef,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "L’intervention de police sur les lieux d’un sinistre se fait en renfort des services spécialisés, "
                "mais répond aussi à des missions précises.\n\n"
                "En présence d’un incendie ou d’une explosion (ex. gaz), les policiers interviennent notamment "
                "pour porter secours, effectuer les premières constatations et rendre compte à la hiérarchie afin "
                "de faciliter l’enquête et/ou renseigner les familles.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Élément “légal” en haut : ici, pas d’article fourni dans ton texte
          // => on met un cadre “Références” clair + neutre (sans inventer)
          _ConditionCard(
            title: "Références (à compléter si besoin)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le texte fourni ne mentionne pas d’articles de loi spécifiques pour cette fiche “sinistre”. "
                "Si tu veux, tu me donnes la/les référence(s) (CPP / CSI / CRPM…) et je les place ici en rouge, tout en haut.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "I — Analyser la situation",
            cardColor: cardAnalyse,
            accent: accentGreen,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Dès l’arrivée sur les lieux, les premiers intervenants doivent établir un premier bilan "
                "(blessés, tués, ampleur du sinistre) afin de permettre au C.I.C d’évaluer les moyens nécessaires "
                "et d’aviser les services de secours.\n\n"
                "Les messages radio doivent être clairs et concis.",
              ),
              SizedBox(height: 10),
              _SubTitle("Signaux à signaler immédiatement"),
              _IntroBullet(text: "Bruits d’explosions / détonations."),
              _IntroBullet(text: "Présence de fumées, nuage coloré."),
              _IntroBullet(text: "Liquide répandu ou projeté."),
              _IntroBullet(
                text: "Bruits anormaux, fuite de gaz, odeurs particulières.",
              ),
              SizedBox(height: 10),
              _Paragraph(
                "À l’arrivée d’un gradé, officier ou commissaire : rendre compte immédiatement des éléments disponibles.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "II — Secourir les victimes",
            cardColor: cardSecours,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "En attendant l’arrivée en nombre suffisant des personnels spécialisés (sapeurs-pompiers, SAMU), "
                "les effectifs de police arrivés sur place prodiguent les premiers soins.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Aucune conduite à l’hôpital ne doit être effectuée d’initiative par les services de police.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Rendre compte au C.I.C de la destination des blessés (où ils sont évacués).",
              ),
              _BulletPoint(
                text:
                    "Si relogement nécessaire (personnes sinistrées), informer le C.I.C pour répercussion aux services municipaux compétents.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "III — Mettre en place un périmètre de sécurité",
            cardColor: cardPerimetre,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Au fur et à mesure de l’arrivée des renforts, et le cas échéant sous l’autorité d’un officier ou commissaire, "
                "établir un périmètre de sécurité selon la configuration des lieux.\n\n"
                "Ce périmètre doit intégrer les risques d’extension éventuelle du sinistre.",
              ),
              SizedBox(height: 10),
              _SubTitle("Organisation du périmètre"),
              _BulletPoint(
                text:
                    "Prévoir des zones réservées au stationnement des véhicules de secours et de police.",
              ),
              _BulletPoint(
                text:
                    "Assurer la circulation, dévier si nécessaire (prévenir les sociétés de transport en commun).",
              ),
              _BulletPoint(
                text:
                    "Faire déplacer les véhicules en stationnement pour faciliter l’intervention des secours.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "En présence (ou suspicion) de fuite de gaz ou vapeurs inflammables : ne pas rester dans le périmètre de sécurité avec un appareil de transmission (radio / téléphone), même éteint.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "Éloigner/arrêter toute source d’étincelles ou de chaleur : notamment interdire le fonctionnement des véhicules automobiles dans le périmètre.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "IV — Préserver les traces et indices",
            cardColor: cardTraces,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Dès le début, garder à l’esprit la nécessité de préserver les traces et indices et de conserver les lieux en l’état, "
                "en vue de l’enquête judiciaire.",
              ),
              SizedBox(height: 10),
              _BulletPoint(
                text:
                    "Avant l’arrivée de l’identité judiciaire : seuls les secours aux personnes doivent pouvoir approcher du lieu du sinistre.",
              ),
              _BulletPoint(
                text:
                    "Diriger et contrôler strictement les mouvements de personnel vers la zone.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          _ConditionCard(
            title: "V — Effectuer les constatations (premiers intervenants)",
            cardColor: cardConstat,
            accent: accentOrange,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Les premiers intervenants effectuent les diligences inhérentes aux constatations initiales, "
                "afin de figer les informations utiles avant dégradation des lieux ou modification par les secours.",
              ),
              SizedBox(height: 10),

              _SubTitle("Checklist de constatations"),
              _BulletPoint(
                text:
                    "Localiser le(s) foyer(s) et décrire : couleurs des fumées/flammes, odeurs, hauteur, rapidité de propagation.",
              ),
              _BulletPoint(
                text:
                    "Rechercher supports/matières inflammables et indices éventuels d’une mise à feu intentionnelle (allumettes, liquides inflammables, bouteilles de gaz…).",
              ),
              _BulletPoint(
                text:
                    "Décrire l’état des lieux avant extension : accès ouverts/fermés, traces d’effraction, mise en scène, anomalies, sabotage des installations de détection/protection.",
              ),
              _BulletPoint(
                text:
                    "Noter les modifications apportées par les sapeurs-pompiers.",
              ),
              _BulletPoint(
                text:
                    "Identifier les personnes présentes, notamment le public : comportements inhabituels (agitation, fascination, personnes déjà vues sur un autre événement).",
              ),
              SizedBox(height: 12),

              _SubTitle("Témoignages (résumé structuré)"),
              _IntroBullet(text: "Identité, adresse, qualité du témoin."),
              _IntroBullet(
                text: "Précisions apportées (faits observés, chronologie).",
              ),
              _IntroBullet(
                text:
                    "Nature et valeur du témoignage (direct/indirect, cohérence, éléments matériels).",
              ),
              SizedBox(height: 10),

              _NotaBox(
                bodySpans: [
                  TextSpan(
                    text:
                        "De retour au service, rédiger un procès-verbal de saisine-constatations, même si l’O.P.J. rédigera ensuite des constatations plus détaillées.",
                    style: TextStyle(fontWeight: FontWeight.w900),
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
