import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignalementDescriptifPage extends StatelessWidget {
  const SignalementDescriptifPage({super.key});

  static const String routeName =
      '/gpx/intervention/patrouille/signalement-descriptif';

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
    final Color cardPerson = isDark
        ? const Color(0xFF1D2A24)
        : const Color(0xFFF1FBF5);
    final Color cardVehicle = isDark
        ? const Color(0xFF2A1F2D)
        : const Color(0xFFFFF1F8);
    final Color cardGoodPractice = isDark
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
          "Patrouille",
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
            "Le signalement descriptif",
            style: GoogleFonts.fustat(
              fontWeight: FontWeight.w900,
              fontSize: 21,
              height: 1.15,
              color: textMain,
            ),
          ),
          const SizedBox(height: 10),

          // Objectif
          _ConditionCard(
            title: "Objectif opérationnel",
            cardColor: cardRep,
            accent: accentGrey,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Le policier doit savoir relever rapidement les éléments déterminants d’un signalement descriptif "
                "et l’utiliser pour identifier une personne ou un véhicule.\n\n"
                "Le principe : aller à l’essentiel pour permettre une diffusion immédiate sur les ondes et sensibiliser "
                "les patrouilles à proximité.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Élément légal (aucun article explicite fourni dans ton texte)
          _ConditionCard(
            title: "I — Élément légal (repère)",
            cardColor: cardLegal,
            accent: accentBlue,
            titleColor: textMain,
            children: const [
              _Paragraph(
                "Aucun article précis n’est mentionné dans la fiche fournie.\n\n"
                "➡️ Cette page est donc centrée sur la méthode opérationnelle : comment formuler un signalement "
                "clair, neutre, utile et diffusable immédiatement.",
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Signalement personne
          _ConditionCard(
            title: "II — Signalement d’une personne",
            cardColor: cardPerson,
            accent: accentGreen,
            titleColor: textMain,
            children: [
              const _SubTitle("Règle d’or : précis, court, utile"),
              const _Paragraph(
                "On suit des rubriques simples, dans un ordre logique. "
                "L’objectif est de donner une image mentale rapide et exploitable.",
              ),
              const SizedBox(height: 10),

              _NotaBox(
                title: "Interdit",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Tout terme à caractère raciste, xénophobe, injurieux ou discriminatoire est prohibé.",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const _SubTitle("Les rubriques essentielles (checklist radio)"),
              const _BulletPoint(text: "1) Sexe : masculin / féminin."),
              const _BulletPoint(
                text:
                    "2) Âge : mineur / majeur + estimation par tranche (ex. 20–30 ans).",
              ),
              const _BulletPoint(
                text:
                    "3) Taille : petite / moyenne / grande + estimation chiffrée si possible.",
              ),
              const _BulletPoint(
                text:
                    "4) Corpulence : mince/maigre/svelte — normale — trapue — forte.",
              ),
              const _BulletPoint(
                text:
                    "5) Type (termes descriptifs neutres) : caucasien, méditerranéen, moyen-oriental, maghrébin, asiatique/eurasien, indo-pakistanais, métis/mulâtre, africain/antillais, polynésien, mélanésien, amérindien.",
              ),

              const SizedBox(height: 12),

              const _SubTitle("Détails d’identification (si visibles)"),
              const _BulletPoint(
                text:
                    "6) Cheveux : couleur (blonds/châtains/bruns/blancs…), longueur (courts/mi-longs/longs), nature (raides/frisés/crépus…), abondance (chauve/clairsemés…), coiffure (tresses/chignon/rasés…).",
              ),
              const _BulletPoint(
                text:
                    "7) Yeux : couleur, forme (enfoncés/globuleux/bridés…), regard (fuyant/vif/vitreux…), indices (lunettes, strabisme, pupille rouge…).",
              ),
              const _BulletPoint(
                text: "8) Barbe / moustache : couleur, longueur, forme.",
              ),
              const _BulletPoint(
                text:
                    "9) Visage : forme (rond/ovale/carré…), teint, sourcils, front, bouche, expression, menton, oreilles + signes particuliers (cicatrice, tatouage, piercing, grains de beauté…).",
              ),
              const _BulletPoint(
                text:
                    "10) Démarche / silhouette / gestuelle : lourde/souple, voûtée/déhanchée, handicap, tics, droitier/gaucher…",
              ),
              const _BulletPoint(
                text:
                    "11) Voix : tonalité (grave/aiguë), intensité (forte/faible), élocution (rapide/lente/hachée), accent, bégaiement…",
              ),
              const _BulletPoint(
                text:
                    "12) Habillement : coiffure (bonnet/casquette…), nature (ville/sport/travail), type (survêt/tee-shirt/robe…), couleurs, marque, logo, chaussures, accessoires (sac, gants…).",
              ),
              const _BulletPoint(
                text:
                    "13) Autres éléments : catégorie socio-pro présumée (si utile), nombre de personnes impliquées, direction de fuite, blessures, contexte (vol/agression…), type d’arme, moyen de locomotion, présence d’animaux.",
              ),

              const SizedBox(height: 12),

              _NotaBox(
                title: "Astuce radio",
                bodySpans: const [
                  TextSpan(
                    text:
                        "Commence toujours par les éléments discriminants (sexe/âge/taille/corpulence) "
                        "puis ajoute 2–3 détails forts (vêtement marquant, tatouage, démarche, accessoire). "
                        "Mieux vaut 6 infos fiables que 15 incertaines.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Signalement véhicule
          _ConditionCard(
            title: "III — Signalement d’un véhicule",
            cardColor: cardVehicle,
            accent: accentPink,
            titleColor: textMain,
            children: const [
              _SubTitle("À annoncer en priorité"),
              _BulletPoint(
                text: "1) Numéro d’immatriculation (si connu, même partiel).",
              ),
              _BulletPoint(text: "2) Marque."),
              _BulletPoint(text: "3) Type / modèle (si possible)."),
              _BulletPoint(
                text: "4) Genre (VL, utilitaire, deux-roues, camionnette…).",
              ),
              _BulletPoint(text: "5) Couleur de carrosserie."),
              _BulletPoint(
                text: "6) Catégorie d’immatriculation : française / étrangère.",
              ),
              _BulletPoint(text: "7) Nombre d’occupants."),
              _BulletPoint(text: "8) Signalement sommaire du conducteur."),
              _BulletPoint(text: "9) Direction prise."),
              _BulletPoint(
                text:
                    "10) Particularités : autocollants, chocs, éraflures, éléments distinctifs…",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Conseil",
                bodySpans: [
                  TextSpan(
                    text:
                        "Si tu n’as pas l’immatriculation : compense avec 3 marqueurs forts "
                        "(couleur + type + particularité visible) et la direction de fuite.",
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bonnes pratiques / diffusion
          _ConditionCard(
            title: "IV — Bonnes pratiques de diffusion",
            cardColor: cardGoodPractice,
            accent: accentAmber,
            titleColor: textMain,
            children: const [
              _SubTitle("Ce qui rend un signalement exploitable"),
              _BulletPoint(
                text:
                    "Ordre logique : QUI ? (personne) / QUOI ? (véhicule) / OÙ ? / VERS OÙ ?",
              ),
              _BulletPoint(
                text:
                    "Infos courtes et factuelles : éviter les interprétations.",
              ),
              _BulletPoint(
                text:
                    "Toujours donner la direction de fuite et le contexte (agression, vol, arme…).",
              ),
              _BulletPoint(
                text:
                    "Ne pas surcharger : privilégier les éléments vraiment discriminants.",
              ),
              SizedBox(height: 10),
              _NotaBox(
                title: "Rappel",
                bodySpans: [
                  TextSpan(
                    text:
                        "L’objectif n’est pas de “tout dire”, mais de permettre une prise d’info immédiate "
                        "et une reconnaissance rapide par les équipages à proximité.",
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
